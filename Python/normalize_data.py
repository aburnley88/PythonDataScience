# import NumPy into Python
import numpy as np


# Create a 1000 x 20 ndarray with random integers in the half-open interval [0, 5001).

X = np.random.randint(0,5001, size = (1000,20))

# print the shape of X
print("Shape of X is",X.shape)



# Average of the values in each column of X
ave_cols = np.mean(X, axis=0)
#print(ave_cols)

# Standard Deviation of the values in each column of X
std_cols = np.mean(X, axis=0)
print(std_cols)


# Mean normalize X
X_norm = (X - ave_cols)/std_cols
print(X_norm)

# Print the average of all the values of X_norm
print(np.mean(X_norm, dtype=np.float64))

# Print the average of the minimum value in each column of X_norm
min_cols = np.min(X_norm, axis = 0)
print("minimums:\n",min_cols)

# Print the average of the maximum value in each column of X_norm
max_cols = np.max(X_norm, axis=0)
print("maximums:\n",max_cols)

# Create a rank 1 ndarray that contains a random permutation of the row indices of `X_norm`
row_indices = np.random.permutation(X_norm.shape[0])
print(row_indices)

# Make any necessary calculations.
# You can save your calculations into variables to use later.

sixty = int(len(X_norm) * 0.6)
eighty = int(len(X_norm) * 0.8)

# Create a Training Set
X_train = X_norm[row_indices[:sixty], :]

# Create a Cross Validation Set
X_crossVal = X_norm[row_indices[sixty:eighty], :]

# Create a Test Set
X_test = X_norm[row_indices[eighty: ], :]

# Print the shape of X_train
print("the rshape for X_train is:",X_train.shape)

# Print the shape of X_crossVal
print("the shape for X_crossval is:", X_crossVal.shape)

# Print the shape of X_test
print("the shape of X)test is:", X_test.shape)