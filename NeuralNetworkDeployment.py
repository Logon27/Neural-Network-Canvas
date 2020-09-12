import sys
import numpy
# scipy.special for the sigmoid function expit()
import scipy.special
# helper to load data from PNG image files
import imageio

def print_to_stdout(*a): 
    print(*a, file = sys.stdout) 

# neural network class definition
class neuralNetworkDeploy:
  # initialise the neural network
  def __init__(self, inputnodes, hiddennodes, outputnodes, wih, who):
    # set number of nodes in each input, hidden, output layer
    self.inodes = inputnodes
    self.hnodes = hiddennodes
    self.onodes = outputnodes
    
    # link weight matrices, wih and who
    # weights inside the arrays are w_i_j, where link is from node i to node j in the next layer
    # w11 w21
    # w12 w22 etc 
    self.wih = wih
    self.who = who

  def activation_function(self, x):
    return scipy.special.expit(x)
    
  # query the neural network
  def query(self, inputs_list):
    # convert inputs list to 2d array
    inputs = numpy.array(inputs_list, ndmin=2).T
    
    # calculate signals into hidden layer
    hidden_inputs = numpy.dot(self.wih, inputs)
    # calculate the signals emerging from hidden layer
    hidden_outputs = self.activation_function(hidden_inputs)
    
    # calculate signals into final output layer
    final_inputs = numpy.dot(self.who, hidden_outputs)
    # calculate the signals emerging from final output layer
    final_outputs = self.activation_function(final_inputs)
    
    return final_outputs
	
# number of input, hidden and output nodes
input_nodes = 784
hidden_nodes = 200
output_nodes = 10

# load the weights from the model file
with open('D:\\NNTesting\\model.npy', 'rb') as f:
    wih = numpy.load(f)
    who = numpy.load(f)

# create instance of neural network
net = neuralNetworkDeploy(input_nodes, hidden_nodes, output_nodes, wih, who)


# load image data from jpg files into an array
img_array = imageio.imread('D:\\NNTesting\\inputImage.jpg', as_gray=True)
    
# reshape from 28x28 to list of 784 values, invert values
img_data  = 255.0 - img_array.reshape(784)
    
# then scale data to range from 0.01 to 1.0
img_data = (img_data / 255.0 * 0.99) + 0.01
# print("min = ", numpy.min(img_data))
# print("max = ", numpy.max(img_data))

# query the network
outputs = net.query(img_data)
#print (outputs)

# the index of the highest value corresponds to the label
label = numpy.argmax(outputs)
print(label)
#print("Network predition: ", label)