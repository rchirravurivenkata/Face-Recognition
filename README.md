## Introduction 

There are multiple methods in which facial recognition systems work, but in general, they work by comparing selected facial features from given image with faces within a database.

This algorithm uses eigenfaces produced from principal component analysis. 



#### Mandatory arguments

******training_directory****** – Folder path of training images  need to be inputted.
******test_directory****** - Folder path of test images need to inputted. 

Note: The output files are stored in a new folder (Results_face_recognize) created by the algorithm in the working directory.

## Description

*****face_recognize***** function, converts all the training images in the training directory to respective column vectors. It then calculates the means of the column vectors to yield an average face/image. Further, the algorithm processes the training image (column) vectors to get rid of redundancies to encapture most variance in the training images in first few dimensions (dimensionality reduction technique) using the spectral decomposition method. The dimensions with most variance (top 20 dimensions/components) are then used to identify and predict the test images by considering the Euclidean distance between test images and training images. Finally the algorithm calculates the overall accuracy of predictions made to identify test images. 

The output folder created by the algorithm will contain the average face in its original .pgm format, top 20 eigenvectors in .csv format and results of the predictions in a tabular .csv format. 

