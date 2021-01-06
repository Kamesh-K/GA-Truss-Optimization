import numpy as np 
E = 3*10**7
A = 3.14
mu = 0.3
FS = 1.5
Rho = 73*10**-5

class node:
	node_id = None 
	x = None 
	y = None 
	def __init__(self,id,x,y,z):
		self.node_id = id 
		self.x = x
		self.y = y
		self.z = z
class element:
	element_id = None 
	first = None 
	second = None
	length = None  
	element_stiffness_matrix = None
	def calc_stiffness_matrix(self):
		length = self.length
		first = self.first
		second = self.second 
		l = second.x - first.x
		m = second.y - first.y
		n = second.z - first.z  
		element_stiffness_matrix = (E*A/length)*np.matrix([[l**2,l*m,l*n,-1*l**2,-1*l*m,-1*l*n],[l*m,m**2,m*n,-1*l*m,-1*m**2,-1*m*n],[l*n,m*n,n**2,-1*l*n,-1*m*n,-1*n**2]])
		print(element_stiffness_matrix)
		return element_stiffness_matrix
	def __init__(self,element_id,first,second):
		self.first = first
		self.second = second
		self.length = np.sqrt((first.x-second.x)**2+(first.y-second.y)**2+(first.z-second.z)**2)
		self.element_stiffness_matrix = self.calc_stiffness_matrix()
class truss:
	elements = []
	nodes = []
	hinges = []
	number_nodes = None 
	number_elements = None 
	global_stiffness_matrix = None
	rhs = None 
	solution = None 
	def __init__(self,number_nodes,number_elements,number_hinges,number_forces):
		self.number_nodes = number_nodes
		self.number_elements = number_elements
		nodes = []
		elements = []
		hinges = []
		for i in range(number_nodes):
			print('Node - ',i+1)
			x = float(input('Enter the x-coordinate - '))
			y = float(input('Enter the y-coordinate - '))
			z = float(input('Enter the z-coordinate - '))
			nodes.append(node(i+1,x,y,z))
		self.nodes = nodes
		for i in range(number_elements):
			print('Element - ',i+1)
			m = int(input('Enter the first node - '))
			n = int(input('Enter the second node - '))
			elements.append(element(i+1,nodes[m-1],nodes[n-1]))
		self.elements = elements 
		print('Enter the hinges in the truss - ')
		rhs = np.zeros(3*number_nodes)
		for i in range(number_hinges):
			x = int(input('Hinge Node - {} = '.format(i+1)))
			hinges.append(x)
		self.hinges = hinges
		for i in range(number_forces):
			print("Information of Force {}".format(i+1))
			node_id = int(input("Enter the node on which the force is acting - "))
			F = float(input('Magnitude of Force = '))
			alpha = float(input('Enter the angle WRT to X-axis - '))
			alpha = alpha*np.pi/180.0
			phi = float(input('Enter the angle WRT to Z-axis - '))
			phi = phi*np.pi/180.0	
			F_resolved = F*np.array([np.sin(phi)*np.cos(alpha),np.sin(phi)*np.sin(alpha),np.cos(phi)])
			rhs[3*(node_id-1):3*node_id] = F_resolved 
	def form_stiffness_matrix(self):
		number_nodes = self.number_nodes
		number_elements = self.number_elements 
		elements = self.elements 
		global_stiffness_matrix = np.zeros((3*number_nodes,3*number_nodes))
		for i in range(number_elements):
			n1 = elements[i].first.node_id
			n2 = elements[i].second.node_id
			k1 = 3*(n1-1)
			k2 = 3*n1-2
			k3 = 3*n1-1
			k4 = 3*(n2-1)
			k5 = 3*(n2-2)
			k6 = 3*(n2-3)
			element_matrix = elements[i].element_stiffness_matrix
			global_stiffness_matrix[k1:k3+1,k1:k3+1] += element_matrix[0:3,0:3]
			global_stiffness_matrix[k1:k3+1,k4:k6+1] += element_matrix[0:3,3:6]
			global_stiffness_matrix[k4:k6+1,k1:k3+1] += element_matrix[3:6,0:3]
			global_stiffness_matrix[k4:k6+1,k4:k6+1] += element_matrix[3:6,3:6]
	def solve(self):
		self.form_stiffness_matrix()
truss(2,1,1,1).solve()
