# load the library
library(caret)

# load the dataset
digits_csv <- read.csv("./digits.csv", head = FALSE)

intrain <- createDataPartition(y=digits_csv[,65], p=1, list=FALSE)
train_data <- digits_csv[intrain, -65]
train_labels <- as.factor(digits_csv[intrain, 65])

# load test dataset
test_csv <- read.csv("./digits.csv", head = FALSE)

intest <- createDataPartition(y=test_csv[,65], p=1, list=FALSE)
test_data <- digits_csv[intest, -65]
test_labels <- as.factor(digits_csv[intest, 65])


algorithms <- c("rpart", "svmRadial", "knn", "nb", "nnet", "rf")

for (a in algorithms){
  # Train the model
  model <- train(train_data, train_labels, method = a)
  
  # Predict values
  predictions <- predict(model, test_data)
  
  # print results
  output <- data.frame(PREDICT=predictions, LABEL=test_labels,
                       HIT=predictions==test_labels)
  head(output)
  
  # summarize results
  res <- confusionMatrix(predictions, test_labels)
  res
  res$overall["Accuracy"]
}

