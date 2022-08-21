Any given set of weights optimizes to learn how to correlate its input layer with what the output layer says it should be.

Neural Network layer & weights are essentially matrix multiplication. 

input.dot(layer_1_matrix) = output


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
 
 #### Stopping
 `Stopping` the training is a effective method for regularization. When to stop training so that we don't overfit ?  
 Use a validation data set.
 
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


#### Dropout
During training, you randomly set neurons in the network to 0 (and usually the deltas on the same nodes during backpropagation, but you technically don’t have to). This causes the neural network to train exclusively using random subsections of the neural network. 

Dropout is a form of training a bunch of networks and averaging them  

Neural networks, even though they’re randomly generated, still start by learning the biggest, most broadly sweeping features before learning much about the noise. if you train 100 neural networks (all initialized randomly), they will each tend to latch onto different noise but similar broad signal. Thus, when they make mistakes, they will often make differing mistakes. If you allowed them to vote equally, their noise would tend to cancel out, revealing only what they all learned in common: the signal.

### Big vs Small Networks
This notion of room or capacity is really important to keep in your mind. Think of it like this. Remember the clay analogy? Imagine if the clay was made of sticky rocks the size of dimes. Would that clay be able to make a good imprint of a fork? Of course not. Those stones are much like the weights. They form around the data, capturing the patterns you’re interested in. If you have only a few, larger stones, they can’t capture nuanced detail. Each stone instead is pushed on by large parts of the fork, more or less averaging the shape (ignoring fine creases and corners).

Now, imagine clay made of very fine-grained sand. It’s made up of millions and millions of small stones that can fit into every nook and cranny of a fork. This is what gives big neural networks the expressive power they often use to overfit to a dataset.  


### Individual vs Batch Gradient Descent  
Individual training examples are very noisy in terms of the weight updates they generate. Thus, averaging them makes for a smoother learning process.

Instead of training on one training example at a timeand updating the weights after each example, Train 100 training examples at a time, averaging the weight updates among all 100 examples. The effect is that training accuracy has smoother trend. Thus averaging makes for smoother training process.

