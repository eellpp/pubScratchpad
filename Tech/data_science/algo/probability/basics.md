A `random variable` is variable whose value we are not sure about. This is the variable whose value we guessing and assigning probability.

### Probabilty Distribution
Example, in murder mystery we are guessing whether murdered is Grey or Aubrey.  
P(murderer = Grey) = 0.3  
P(murderer = Aubrey) = 0.7    
<a href="https://www.codecogs.com/eqnedit.php?latex=\sum&space;P(murderer)&space;=&space;1" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\sum&space;P(murderer)&space;=&space;1" title="\sum P(murderer) = 1" /></a>  

Since the above random variable can be reduced to two state binary true/false values, it can be stated as having bernoulli distribution.

On searching the mansion, two possible weapons are found. A revolver and a dagger.  
This introduces a new random variable P(weapon)  
P(weapon = revolver) = 0.5
P(weapon = dagger) = 0.5

But based on their background, we notice that the weapon has different probabilities based on who is the murderer. Since Grey has military background and higher chance of using revolver. So this is a dependent variable. 

### Conditional Probability Distribution
However, we can also assign probability of who could have more chance of using which murder weapon.  
P(weapon = revolver| murderer = grey) = 0.9 : prob of weapon being revolver if murderer is Grey , since he has military background  
P(weapon = revolver| murderer = aubrey) = 0.20 

For the other weapon, the probabilities are automatically assigned as  
P(weapon = dagger| murderer = grey) = 0.1
P(weapon = dagger| murderer = aubrey) = 0.80

In the above example the random variable P(murderer) and P(weapon) are dependent random variables.  
An independent variable in above case could be whether it rained or not.

### Joint Probabilty
We have two RV. P(murderer), P(weapon/murderer)  

JP of Grey being murder and using revolver = 0.3 * 0.9 = 0.27  
JP of Grey being murder and using dagger = 0.3 * 0.1 = 0.03  

JP of Aubrey being murder and using revolver = 0.7 * 0.2 = 0.14
JP of Aubrey being murder and using dagger = 0.7 * 0.8 = 0.56

Note that sum of products of above is 1  
<a href="https://www.codecogs.com/eqnedit.php?latex=\sum_{a}&space;\sum_{b}P(A,B)&space;=&space;1" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\sum_{a}&space;\sum_{b}P(A,B)&space;=&space;1" title="\sum_{a} \sum_{b}P(A,B) = 1" /></a>

The sum of all the possible states of A and B is 1

Based on the above Joint distribution , it seems the mystery can be solved if we find some evidence 

### Prior and Likelihood function
Our initial probability distribution over the random variable of P(murderer) is a `Prior` . P(murderer = grey) = 0.3 is a value/state of this distribution  
The value P(weapon = Revolver| murderer = Grey) = 0.9 is an outcome of  `likelihood function`. The distribution for this can be written as P(weapon/murderer). The likelihood function is a function over the random variable murderer  
The distribution P(murderer/weapon) is the `Posterior` since it is the distribution after the fact of finding the weapon.  

The Joint distribution is calculated using `Prior` and `Likelihood Function`

Definition of Likelihood function:  
The likelihood of P(B/A) is function of random variable A when we are observing B, while we are trying to infer A
 
### A probabilistic model
A probabilitic model has two essential thing  
1) Random Variables  
2) Joint Distribution of these variables  
Once we have both of these we have a probabilistic model which can be used of making inferences  

### Marginal Distribution
Once we have a joint distribution, we will have a marginal distribution.  This is value of one of the variable, summing over all possible values of the other.  
marginal P(A) = <a href="https://www.codecogs.com/eqnedit.php?latex=\sum_{b}P(A,B)&space;=&space;1" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\sum_{b}P(A,B)&space;=&space;1" title="\sum_{b}P(A,B) = 1" /></a>  

marginal P(Revolver) = 0.27 + 0.14 = 0.41    
marginal P(Dagger) = 0.3 + 0.56 = 0.59  
marginal P(Revolver) + marginal P(Dagger) = 1

Sum over marginal distribution is also 1

### Inference using Probabilstic Model using some Evidence
Let the evidence be the fact that the weapon used was revolver  
Hence P(Dagger) = 0  

The joint probabilities (Prior) are adjusted to get new JP (Posterior) based on facts found:  
JP of Grey being murder and using revolver =  0.27 /(0.27 + 0.14) = 0.66  
JP of Aubrey being murder and using revolver = 0.14/(0.27 + 0.14)  = 0.34

This makes intuitive sense since revolver indicates Grey should be prime suspect. 

### Inference Using Bayes Rule
The same inference above can be formalised and calculated optimally using Bayes Rule

P(murderer/Weapon) = P(Weapon/Murderer) * p(Murderer)/ P(Weapon)  
P(murderer/Weapon) ~ P(Weapon/Murderer) * p(Murderer)  

Here P(Weapon) can be replaced with a normaliser such as to scale the values to 1  

### Notations
The variables that are included in joint distribution is called as factor.  
Eg: P(B/A) and P(A) are two factors. One with two variables and other with single variable.  

In practical system, there could be thousands/millions of factors that make up the model

### Adding more factors to model for better inference
The 66% probability is not good enough to convict grey. On further analysis, the detectives find a silver men hair near crime scene. It is Grey's hair strand. Either grey placed it there or it was deliberately placed by Auberey

 Likelihood of finding a silver hair at crime scene and murderer is grey : P(hair = true | murderer = Grey) = 0.50  
 Likelihood of finding a silver hair at crime scene and murderer is Aubrey : P(hair = true | murderer = Aubrey) = 0.05
 
 Also the variable hair is independent of weapon variable  
 P(hair|weapon,murderer) = p(hair | murderer)
 
 Inference with Bayes Rule
 
 P(murderer| hair, weapon) ~ P(murderer) * P(Weapon/Murderer)*P(Hair/Murderer)  
 
 P(Murderer = Grey| hair, weapon) = 0.66 *0.5 = 0.35  
 P(Murderer = Aubrey| hair, weapon) = 0.34 *0.05 = 0.017  
 After normalising  
 P(Murderer = Grey| hair, weapon) =  0.95  
 P(Murderer = Aubrey| hair, weapon) = 0.05  
 
 So with further evidence we are able to conclude the case.
 
 
 
 
 
