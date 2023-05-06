import numpy as np

# x = np.array([1,2,3,4,5])


# shape = x.shape
# type = type(x)
# dtype = x.dtype
# print("The following is a numpy array:\narray = {}".format(x))
# print
# print("The dtype for array is {}".format(dtype))
# print("Shape is another attribute of numpy arrays.")
# print("The shape of array: {} is {}".format(x,shape))
# print("Shape shows (num_rows,num_columns)")

# y = np.array([[1,2,3], [4,5,6], [7,8,9], [10,11,12]])
# y_shape = y.shape
# print("This is a 2D array\n{}".format(y))
# print("The shape of array:\n {} is {}".format(y,y_shape))

# x2 = np.array([1.5, 2.2, 3.7, 4.0, 5.9], dtype = np.int64)

# # We print the dtype x
# print('x2 = ', x2)
# print('The elements in x are of type:', x2.dtype)

X = np.random.randint(0,5001, size = (1000,20))
print(X)

