
Below is the python code for svd for detecting weights of a model.  
Our model is : y = mx + b 
Loss function is : L = mean_square_error(y - y_predicted) = mean_square_error(y - (mx +b))  
mean_square_error : 1/n * sum(error ** 2) = 1/n * sum((y - (mx +b)) ** 2)

![Alt text](/CodeCogsEqn.gif?raw=true "Optional Title")


```python

x = np.array([1,3,4,5,7,9])
y = np.array([6,8,12,14,18,20])
m = b = 0
rate = 0.01
for i in range(1000):
    yp = m*x + b
    n = len(x)
    L = 1/n * (sum((y - (m*x + b))**2))
    dL_dm = -2 *(1/n) * sum( x*(y - (m*x + b)))
    dL_db = -2 *(1/n) * sum( (y - (m*x + b)))
    m = m - rate * dL_dm
    b = b - rate * dL_db
    print (L,m,b)

```
