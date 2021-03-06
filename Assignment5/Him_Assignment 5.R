#===================================================================
# ISM645 / IAF601   Principle of Predictive Analytics
# Assignment 5      Predictive Analytics
# Due Date          November 27, 11:59 pm
# Vathana Him
#===================================================================

library(tidyverse)
library(ggplot2)
library(rsample)
library(DescTools)
library(caTools)
library(caret)
library(broom)
library(yardstick)
library(randomForest)
library(cutpointr)


# Import the wine_quality.csv and explore it.
# Drop all observations with NAs (missing values)
# Create a new variable, "quality_binary", defined as "Good" if quality > 6 and "Not Good" otherwise

#====================== Write R code HERE ==========================
data = read.csv('wine_quality.csv')
head(data)
summary(data)
data = data %>% drop_na()
data = data %>% mutate(quality_binary = if_else(quality>6,"Good","Not Good"))
#===================================================================



#======= Question 1 (2 Point) =======
# Q1-1. Define a binary variable, "alcohol_level", defined as "Strong" if alcohol > 10 and "Weak" otherwise.
# Q1-2. Create a bar plot for average by wine type and alcohol_level (see Canvas for an exemplar plot). (Hint: add position="dodge" option to geom_bar function)
# Q1-3. Create a histogram of wine quality by wine types with binwidth = 1 (see Canvas for an exemplar plot). 

#====================== Write R code HERE ==========================

#Q1-1
data = data %>% mutate(alcohol_level = if_else(alcohol>10, "Strong", "Weak"))

#Q1-2
ggplot(data) + geom_bar(aes(type, quality, fill = alcohol_level), position="dodge", stat="summary", fun="mean")+
  labs(title = "Average by wine type and alcohol level", x="Wine Type", y = "Average Quality")

#Q2-1
ggplot(data, aes(x=quality, fill = type))+geom_histogram(binwidth = 1, position='identity', alpha=0.5)+
  facet_grid(.~type)+labs(y="Frequency (wine samples)", x="Quality (Sensory Preference)")

#===================================================================



#======= Question 2 (2 Point) =======
# Q2-1. Split data into 70% train and 30% test data.
# Q2-2. Based on train data, build a linear regression model to predict wine quality using all available predictor variables.
#       Note that you shouldn't use the binary quality variable as a predictor.
# Q2-3. Based on train data, build linear regression models separately for red and white wines.
#       Hint: use the subset() function to filter the train data.
# Q2-4. Based on test data, evaluate two predictive models (overall prediction / separate prediction for red and white wines) based on RMSE (Root Mean Squared Error). 
#       Hint: you need to also filter the test data when you apply the separate prediction models for red and white wines.

#====================== Write R code HERE ==========================
#Q2-1
wine_split = initial_split(data, 0.7)
wine_train = training(wine_split)
wine_test = testing(wine_split)

#Q2-2
lin_reg = lm(quality~.-quality_binary, data=wine_train)
summary(lin_reg)

#Q2-3
colnames(red_wine)

red_wine = wine_train %>%  filter(type=='red')
white_wine = wine_train %>% filter(type=='white')

red_reg = lm(quality~residual.sugar+density+fixed.acidity+chlorides+pH+volatile.acidity+free.sulfur.dioxide+sulphates
             +alcohol+citric.acid+alcohol_level+total.sulfur.dioxide, data=red_wine)
summary(red_reg)
white_reg = lm(quality~residual.sugar+density+fixed.acidity+chlorides+pH+
                 volatile.acidity+free.sulfur.dioxide+sulphates+alcohol+citric.acid+
                 alcohol_level+total.sulfur.dioxide, data=white_wine)
summary(white_reg)



#Q2-4
red_wine_test = wine_test%>%filter(type == 'red')
red_predict_test = red_reg %>% augment(newdata = red_wine_test, type.predict="response") 
red_RSME = red_predict_test %>% rmse(quality, .fitted)
red_RSME


white_wine_test = wine_test%>%filter(type == 'white')
white_predict_test = white_reg %>% augment(newdata = white_wine_test, type.predict="response")
white_RSME = white_predict_test %>% rmse(quality, .fitted)
white_RSME

#The RSME for both models are pretty low with values of 0.65 for the red wine model, and 0.78 for the white wine model. 
#This suggests that the data is a good fit for the model.

#===================================================================



#======= Question 3 (2 Point) =======
# Q3-1. Based on train data (both red and white wine), build a logistic regression model to classify wine quality (quality_binary) using all available predictor variables.
#       Note that you shouldn't use the numeric quality variable as a predictor.
# Q3-2. Based on test data, create a ROC curve and calculate AUC.

#====================== Write R code HERE ==========================
#Q3-1
wine_train = wine_train %>% mutate(quality_binary_2 = if_else(quality_binary=="Good",1,0))
wine_test = wine_test %>% mutate(quality_binary_2 = if_else(quality_binary=="Good",1,0))

train_wine_logistics = glm(quality_binary_2~residual.sugar+density+fixed.acidity+chlorides+
                             pH+volatile.acidity+free.sulfur.dioxide+sulphates+alcohol+citric.acid+
                             alcohol_level+total.sulfur.dioxide+type, data = wine_train, family='binomial')
summary(train_wine_logistics)
pred_wine_logistics = train_wine_logistics %>% augment(newdata=wine_test, type.predict="response")

#Q3-2
roc = roc(pred_wine_logistics, x=.fitted, class=quality_binary_2, pos_class=1, neg_class=0)
plot(roc)
auc(roc)
#===================================================================





#======= Question 4 (2 Point) =======
# Q4-1. Based on train data (both red and white wine), build a random forest model to predict quality using all available predictor variables.
# Q4-2. Based on importance measure from the random forest, which factors do you think are important in predicting wine quality?
# Q4-3. Based on test data, create a ROC curve and calculate AUC. 
#       Which model do you think is better, logistic regression (Q3) or random forest (Q4)?

#====================== Write R code HERE ==========================
#Q4-1 
wine_class_rf = randomForest(as.factor(quality_binary_2)~residual.sugar+density+fixed.acidity+chlorides+pH+
                               volatile.acidity+free.sulfur.dioxide+sulphates+alcohol+citric.acid+alcohol_level+
                               total.sulfur.dioxide+type, data=wine_train, ntree=1200, importance=TRUE)
varImpPlot(wine_class_rf)

#Q4-2
#Based on the MeanDecreaseGini model density and alcohol seems to be the most important predictor variable for
#detecting wine quality because their MeanDcreaseGini scores are signficiantly higher than other variables.

#Q4-3
pred_wine_class_rf = wine_class_rf %>% predict(newdata=wine_test, type="prob")
wine_test = wine_test %>% mutate(.fitted_rf = pred_wine_class_rf[, 2])
roc1 = roc(wine_test, x=.fitted_rf, class=quality_binary_2, pos_class=1, neg_class=0)
plot(roc1)
auc(roc1)


#the random forest model from question 4 seems to be a better model for prediction due to its higher AUC score of 0.91

#===================================================================



#======= Question 5 (2 Point) =======
# Many wine experts argue that acid is a vital component of wine.
# Q5-1. Build another random forest models to predict wine quality using all predictors but acidity measures (fixed.acidity, volatile.acidity, citric.acid, and pH).
# Q5-2. By comparing the model performance with the full model (Question 4), do you agree that acid is a significant predictor for wine quality (sensory preference)?

#====================== Write R code HERE ==========================
#Q5-1
wine_class_rf_2 = randomForest(as.factor(quality_binary_2)~residual.sugar+density+chlorides+
                                 free.sulfur.dioxide+sulphates+alcohol+alcohol_level+total.sulfur.dioxide+
                                 type, data=wine_train, ntree=1200, importance=TRUE)
varImpPlot(wine_class_rf_2)


#Q5-2
pred_wine_class_rf_2 = wine_class_rf_2 %>% predict(newdata=wine_test, type="prob")
wine_test_2 = wine_test %>% mutate(.fitted_rf = pred_wine_class_rf_2[, 2])
roc2 = roc(wine_test_2, x=.fitted_rf, class=quality_binary_2, pos_class=1, neg_class=0)
plot(roc2) +
  geom_line(data = roc1, aes(color = "roc1")) +
  geom_line(data = roc2, aes(color = "roc2")) +
  scale_color_discrete("Model", labels = c("rf1","rf2"))
auc(roc1)
auc(roc2)

#ACID is a not significant predictor for wine quality because we can see that the AUC value 
#from rf2 dropped by about 0.02 in comparison to rf1. The AUC value of 0.91 for rf1 and 0.89 for rf2 respectively are
#used to determine this conclusion. Therefore, this small drop in AUC value as a result of excluding acidity variables 
#is not significant.



#===================================================================



#===========================================================================================================
# Before submission, I recommend you restart your RStudio and run all codes.
# Please ensure that there is no error message in your code. Any code errors will get some points deduction without exception.
#===========================================================================================================

