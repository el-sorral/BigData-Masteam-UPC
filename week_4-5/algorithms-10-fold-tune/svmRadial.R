# load the library
library(caret)
library(doParallel)
set.seed(1)

t <- proc.time()

cl <- makeCluster(detectCores()-1)
registerDoParallel(cl)

# Prepare train data
digits_csv <- read.csv("./digits.csv", head = FALSE)
train_data <- digits_csv[,-65]
train_labels <- as.factor(digits_csv[, 65])

# Prepare test data
test_csv <- read.csv("./test.csv", head = FALSE)
test_data <- test_csv[, -65]
test_labels <- as.factor(test_csv[, 65])

fitControl <- trainControl(method = "cv",
                           number = 10)

grid <- expand.grid(sigma= (9)*0.00001, C = (4:6)*0.1)

# Train the model
model <- train(train_data, train_labels, 
               trControl = fitControl,
               tuneGrid = grid,
               method = "svmRadial")

print.train(model)
plot.train(model)



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

proc.time()-t

# Other result
model$results
max(model$results$Accuracy)