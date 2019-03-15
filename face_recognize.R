################################################################################################################
#
#   Face recognition algorithm 
#       by Ramakanth Chirravuri Venkata
#
################################################################################################################

## Installs dependent packages

install.packages("pixmap")
library(pixmap)

## face_recognize function needs folder path of training data and test data as inputs

face_recognize <- function(training_directory, test_directory){
  
  ## Creates a new directory for saving the results
  
  dir.create("Results_face_recognize")
  results_dir <- paste(getwd(), "Results_face_recognize/", sep = "/")
  
  ## Converts image matrices to vectors and generates a matrix of column vectors of all images
  
  files <- list.files(pattern = ".pgm", path = training_directory, full.names = T)
  files_1 <- list.files(pattern = ".pgm", path = training_directory)
  a <- scan(files[1], skip = 3)
  a1 <- 
    c <- matrix(0, length(a), length(files))
  for(i in 1:length(files)){
    a <- scan(files[i], skip = 3)
    c[, i] <- a
  }
  
  colnames(c) <- gsub(".pgm", "", files_1)
  
  ## Generates an average image of all training images
  
  av <- as.matrix(apply(c, 1, mean))
  
  ## Writes an average images of training images to a file
  
  
  a1 <- read.pnm(files[1])
  a1@grey <- matrix(av[, 1], ncol = a1@size[2], nrow = a1@size[1], byrow = T)
  write.pnm(a1, paste(results_dir, "average_face.pgm", sep = ""), type = "pgm", forceplain = T)
  
  
  ## subtracts average face from training images to remove redundancies (conserved features)
  
  c1 <- c
  for(j in 1:ncol(c)){
    c[, j] <- c[, j] - av[, 1]
  }
  
  ## Produces a covarience matrix, that further aids in generating the eigen values and eigen vectors
  
  cov_mat <- t(c)%*%c
  eig_values <- eigen(cov_mat)$values
  eig_vectors <- eigen(cov_mat)$vectors
  
  ## Left multiply the eigen vectors of the training image matrix and normalizing the vectors to produce eigenfaces
  
  e_mat <-c
  for(l in 1:ncol(eig_vectors)){
    e_mat[, l] <- (c %*% eig_vectors[, l]) 
    e_mat[, l] <- e_mat[,l]/ norm(as.matrix(e_mat[, l]))}
  
  ## Saves the matrix of top 20 eigen faces as .csv file
  write.csv(e_mat[, 1:20], paste(results_dir,"top_20_eigen_faces.csv", sep = ""), quote = F, row.names = F)
  
  
  ## Reads the test directory
  
  files2 <- list.files(pattern = "pgm", path = test_directory, full.names = T)
  files_2 <- list.files(pattern = "pgm", path = test_directory)
  
  ## projects the face space of the training and test images and calculates the euclidean distance among the test images and training images
  
  results <- matrix(0, length(files2), 2)
  distance <- c()
  for(k in 1:length(files2)){
    atest <- scan(files2[k], skip = 3)
    project_test <- t(e_mat[, 1:20]) %*% (atest - av[, 1])
    for(r in 1:length(files)){
      p <- scan(files[r], skip = 3)
      project_train <- t(e_mat[, 1:20]) %*% (p - av[, 1])
      distance[r] <- sqrt(sum((project_test-project_train)**2))}
    
    ## Identifies closest training image of the test image
    
    idx <- which(distance == min(distance))
    results[k, 1] <- substr(files_2[k], 1, 3)
    results[k, 2] <- substr(files_1[idx], 1, 3)}
  
  colnames(results) <- c("Test_image", "Predicted_train_image")
  idx2 <- which(results[, 1] == results[, 2])
  write.csv(results, paste(results_dir,"Prediction_results.csv", sep = ""), quote = F, row.names = F)
  
  ## Calculates the accuracies of the overall predictions and returns the accuracy score
  
  accuracy <- length(idx2)/nrow(results) * 100
  
  print(noquote("A RESULTS FOLDER IS CREATED IN THE CURRENT DIRECTORY"))
  print(noquote("The overall accuracy of the predictions made by the algorithm is"))
  print(accuracy)
  print(noquote(""))
  print(noquote(""))
  print(noquote(""))
  print(noquote("***** Results of the predictions are returned ******"))
  return(results)
  
}
