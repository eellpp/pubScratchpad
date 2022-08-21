
Below is the python code for svd for detecting weights of a model.  
Our model is : y = mx + b  
Loss function is : L = mean_square_error(y - y_predicted) = mean_square_error(y - (mx +b))  

![](/data_science/svd/img/LossFunction.gif?raw=true "")  
![](/data_science/svd/img/d_LossFunction_dm.gif?raw=true "")  
![](/data_science/svd/img/d_LossFunction_db.gif?raw=true "")  


```python
import numpy as np
from __future__ import division

class OurSGD:
    def __init__(self,m = 0,b =0 ):
        self.m = m
        self.b = b
    
    def train(self,X,Y_truevalue,epoch = 1000,rate = 0.01):    
        x = X
        y = Y_truevalue
        m = self.m
        b = self.b
        for i in range(epoch):
            n = len(x)
            L = 1/n * (sum((y - (m*x + b))**2))
            dL_dm = -2 *(1/n) * sum( x*(y - (m*x + b)))
            dL_db = -2 *(1/n) * sum( (y - (m*x + b)))
            m = m - rate * dL_dm
            b = b - rate * dL_db
            if i % 100 == 0 :
                print(L,m,b)
        self.m = m
        self.b = b
    
    def predict(self,X_unknown):
        return self.m*X_unknown + self.b

sgd = OurSGD(m = 0,b = 0)
# y is roughly equal to 2x + 3
sgd.train(np.array([1,3,4,5,7,9]) ,np.array([6,8,12,14,18,20]),1000 ,0.01)
# should be close to 23
sgd.predict(10)

```
output when running the code:
```bash
(194.0, 1.5133333333333332, 0.26)
(1.9384367447912054, 2.246649094565449, 1.6494054052882212)
(1.2714552167553343, 2.1179850442441683, 2.4465924630865628)
(0.9952414329762203, 2.0351864450767096, 2.959602674527215)
(0.8808543755501385, 1.9819034339560837, 3.2897378347356954)
(0.8334838253640513, 1.947614456816039, 3.5021882335295356)
(0.813866492114765, 1.9255486251638299, 3.6389054856972813)
(0.8057424622628466, 1.911348699499236, 3.7268865257255297)
(0.8023780976881039, 1.9022106850315224, 3.7835045697669294)
(0.8009848299135984, 1.896330139570616, 3.8199397256828473)

22.768960070232982

```
