
In a linear algebra perspective, the linear regression algorithm is the way to solve a linear system Ax=b with more equations than unknowns. In most of the cases there is no solution to this problem. And this is because the vector b doesn't belong to the column space of A, C(A).

https://stats.stackexchange.com/a/1845

`Ordinary Least Squares (OLS)` is a method used to fit linear regression models. Because of the demonstrable consistency and efficiency (under supplementary assumptions) of the OLS method, it is the dominant approach. 

### Other Estimation Methods
https://en.wikipedia.org/w/index.php?title=Linear_regression&action=edit&section=12

In a big data set when number of predictors are huge then gradient descent is used for linear regression estimation

https://stats.stackexchange.com/a/278794

The main reason why gradient descent is used for linear regression is the computational complexity: it's computationally cheaper (faster) to find the solution using the gradient descent in some cases.

The formula which you wrote looks very simple, even computationally, because it only works for univariate case, i.e. when you have only one variable. In the multivariate case, when you have many variables, the formulae is slightly more complicated on paper and requires much more calculations when you implement it in software:
β=(X′X)−1X′Y
Here, you need to calculate the matrix X′X then invert it (see note below). It's an expensive calculation. For your reference, the (design) matrix X has K+1 columns where K is the number of predictors and N rows of observations. In a machine learning algorithm you can end up with K>1000 and N>1,000,000. The X′X matrix itself takes a little while to calculate, then you have to invert K×K matrix - this is expensive.

So, the gradient descent allows to save a lot of time on calculations. Moreover, the way it's done allows for a trivial parallelization, i.e. distributing the calculations across multiple processors or machines. The linear algebra solution can also be parallelized but it's more complicated and still expensive.

Additionally, there are versions of gradient descent when you keep only a piece of your data in memory, lowering the requirements for computer memory. Overall, for extra large problems it's more efficient than linear algebra solution.

This becomes even more important as the dimensionality increases, when you have thousands of variables like in machine learning.
