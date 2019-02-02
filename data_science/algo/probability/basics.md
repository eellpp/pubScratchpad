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

Based on the above Joint distribution , it seems the mystery can be solved if we find some evidence  
