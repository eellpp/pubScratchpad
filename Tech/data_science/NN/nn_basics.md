Any given set of weights optimizes to learn how to correlate its input layer with what the output layer says it should be.

What an earlier layer says it should be can be determined by taking what a later layer says it should be and multiplying it by the weights in between them. This way, later layers can tell earlier layers what kind of signal they need, to ultimately find correlation with the output. This cross-communication is called backpropagation.  
When a neuron in the final layer says, “I need to be a little higher,” it then proceeds to tell all the neurons in the layer immediately preceding it, “Hey, previous layer, send me higher signal.” They then tell the neurons preceding them, “Hey. Send us higher signal.” 

## Vectors and Matrices
In the figure, the weight matrices are the lines going from node to node, and the vectors are the strips of nodes. For example, weights_1_2 is a matrix, weights_0_1 is a matrix, and layer_1 is a vector.

## Neural NEtwork Architectures
Good neural architectures channel signal so that correlation is easy to discover. Great architectures also filter noise to help prevent overfitting. Much of the research into neural networks is about finding new architectures that can find correlation faster and generalize better to unseen data.  

## Overfitting and regularization
A more official definition of a neural network that overfits is a neural network that has learned the noise in the dataset instead of making decisions based only on the true signal.  
 Regularization is a subfield of methods for getting a model to generalize to new datapoints (instead of just memorizing the training data). It’s a subset of methods that help the neural network learn the signal and ignore the noise.  
 
 Regularization methods  
 - Stopping : stop and validate
 - dropout : radomly turn off neurons during training  
 
 
 `Stopping` the training is a effective method for regularization. When to stop training so that we don't overfit ?  
 Use a validation step.
 
 ```bash
 for each epoch
    for each training data instance
        propagate error through the network
        adjust the weights
        calculate the accuracy over training data
    for each validation data instance
        calculate the accuracy over the validation data
    if the threshold validation accuracy is met
        exit training
    else
        continue training
 ```
 Once you're finished training, then you run against your testing set and verify that the accuracy is sufficient.

`Training Set`: this data set is used to adjust the weights on the neural network.

`Validation Set`: this data set is used to minimize overfitting. You're not adjusting the weights of the network with this data set, you're just verifying that any increase in accuracy over the training data set actually yields an increase in accuracy over a data set that has not been shown to the network before, or at least the network hasn't trained on it (i.e. validation data set). If the accuracy over the training data set increases, but the accuracy over the validation data set stays the same or decreases, then you're overfitting your neural network and you should stop training.

`Testing Set`: this data set is used only for testing the final solution in order to confirm the actual predictive power of the network.  






