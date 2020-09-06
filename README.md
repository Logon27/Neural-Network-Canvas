# Neural-Network-Canvas

This was a program I created after learning how to make a neural network from scratch. I mainly learned from a book called "Make Your Own Neural Network" by Tariq Rashid. The network was created using python, numpy, and scipy. I then trained the network on the mnist data set. The current network has 97% accuracy after training. The canvas itself was created using Processing 3 which is based on Java. Therefor I had to get around the fact that Processing 3 does not support native python. To accomplish this the canvas will save the current drawn image to a jpg file. Then I call a separate neural network python program. This separate python program loads the weights from the model I trained and prints its prediction to stdout. Then I take the stdout produced by the python process inside the Java Canvas and display the prediction.

---

## Canvas Demo

![Neural Network Canvas Demo](https://i.imgur.com/R1RyVl4.gif)

---

Current issues:

- Sometimes the network has issues distinguishing between 2's and 7's. There are also some occasional guesses that can be blatantly wrong. This may be a product of the brush I implemented on the canvas. Since you just use your mouse to draw there is no pressure or change in brightness for surrounding pixels. So I tried to manually implement that to get more accurate predictions. This can be improved im sure to increase prediction accuracy.

---

Code Coming Soon...
