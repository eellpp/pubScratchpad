
In a linear algebra perspective, the linear regression algorithm is the way to solve a linear system Ax=b with more equations than unknowns. In most of the cases there is no solution to this problem. And this is because the vector b doesn't belong to the column space of A, C(A).

https://stats.stackexchange.com/a/1845

`Ordinary Least Squares (OLS)` is a method used to fit linear regression models. Because of the demonstrable consistency and efficiency (under supplementary assumptions) of the OLS method, it is the dominant approach. 

### Other Estimation Methods
https://en.wikipedia.org/w/index.php?title=Linear_regression&action=edit&section=12

### Gradient descent method for estimation of regression params
In a big data set when number of features are huge then gradient descent is used for linear regression estimation \
When n (number of features ) is low (n < 1000 or n < 10000) you can think of normal equations as the better option for calculation theta, however for greater values Gradient Descent is much more faster, so the only reason is the time

https://stats.stackexchange.com/a/278794

The main reason why gradient descent is used for linear regression is the computational complexity: it's computationally cheaper (faster) to find the solution using the gradient descent in some cases.

The formula which you wrote looks very simple, even computationally, because it only works for univariate case, i.e. when you have only one variable. In the multivariate case, when you have many variables, the formulae is slightly more complicated on paper and requires much more calculations when you implement it in software:
β=(X′X)−1X′Y
Here, you need to calculate the matrix X′X then invert it (see note below). It's an expensive calculation. For your reference, the (design) matrix X has K+1 columns where K is the number of predictors and N rows of observations. In a machine learning algorithm you can end up with K>1000 and N>1,000,000. The X′X matrix itself takes a little while to calculate, then you have to invert K×K matrix - this is expensive.

So, the gradient descent allows to save a lot of time on calculations. Moreover, the way it's done allows for a trivial parallelization, i.e. distributing the calculations across multiple processors or machines. The linear algebra solution can also be parallelized but it's more complicated and still expensive.

Additionally, there are versions of gradient descent when you keep only a piece of your data in memory, lowering the requirements for computer memory. Overall, for extra large problems it's more efficient than linear algebra solution.

This becomes even more important as the dimensionality increases, when you have thousands of variables like in machine learning.

#### Example with number of columns > 1000

If you are performing feature extraction from text, image or sound corpus, you may end up with data with more columns than number of rows. 
For example look into TfidfVectorizer (4.1. Feature extraction), it gives you a sparse matrix, but if you convert it to conventional dense matrix, the columns can easily go beyond 1000, and if you have less than 1000 samples, you have a data that has 1000+ columns and m < n.

Genetic data is the classic example, and a lot of the best research on this type of data structure has been pioneered by computational biologists. It is not usual to only have dozens of rows with tens of thousands to millions of columns.

Medical research often has significantly more measurements per person (i.e. columns, features, etc) than persons in the study.

A lot of market research data sources have more columns than rows. Often, the respondents have to select from long lists of brands etc. which produces a lot of 0/1 variables because these are not single or exclusive items.

Time series data, for example.  I could have daily stock prices for S&P500 stocks, for each day for a decade.  One representation would be to have a column for each day.
