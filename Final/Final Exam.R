#===================================================================
# ISM645 / IAF601   Principle of Predictive Analytics
# Final Exam        Predictive Modeling
# Due Date          December 1, 11:59 pm
#===================================================================


#===================================================================
############################ Final Exam ############################
#===================================================================




# Import the student_performance.csv and explore it.
#====================== Write R code HERE ==========================





#===================================================================



#====================================
#======= Question 1 (1 Point) =======
# Answer the following questions by presenting a relevant plot (visualization).
# Q1-1. Do grades of Mathematics and Portuguese differ by gender?
# Q1-2. Does study time matter to get better grades of Mathematics and Portuguese?
# Q1-3. Does access to Internet influence students' grades of Mathematics and Portuguese?

## There could be various approaches to answer to these questions.

#====================== Write R code HERE ==========================







#===================================================================



#====================================
#======= Question 2 (2 Point) =======
# Q2-1. Split the data into two separate data frames for each subject: Mathematics and Portuguese. Then, remove a variable "subject".
# Q2-2. Build linear regression models to predict total_grade of Mathematics and Portuguese, respectively, based on time spending patterns (travel time, study time, free time after school, and going out with friends)
# Q2-3. Based on your model, make prediction for a new student's final grades of Mathematics and Portuguese, based on the following information.
#       You can write your prediction results by using comment (#).

#------------------ New Student's Information
#------------------ traveltime = 2
#------------------ studytime = 4
#------------------ freetime = 3
#------------------ goout = 2

#====================== Write R code HERE ==========================








#===================================================================



#### For the subsequent questions (Q3 to Q5), use the dataset for grades of Mathematics.

#====================================
#======= Question 3 (2 Point) =======

# Q3-1. Create a new binary variable, "pass", defined as TRUE if total_grade > 30 and FALSE otherwise.
#       To avoid any error, remove the variable, "subject".
# Q3-2. Split data into 70% train and 30% test data.
# Q3-3. Based on train data, build a logistic regression model to predict "pass" using all available predictor variables.
#       Note that "total_grade" should not be included as a predictor.
# Q3-4. Based on test data, draw a ROC curve and calculate AUC for the model trained in Q3-3.

#====================== Write R code HERE ==========================










#===================================================================



#====================================
#======= Question 4 (2 Point) =======
# Q4-1. Based on train data, build a random forest model to predict "pass" using all available predictor variables.
# Q4-2. Based on test data, draw a ROC curve and calculate AUC for the model trained in Q4-1.
# Q4-3. According to the results of Q3 and Q4, which model do you think is better? Why?
#       Write your answer below by using comment (#).

#====================== Write R code HERE ==========================










#===================================================================


#====================================
#======= Question 5 (2 Point) =======
# For this question, use the random forest model as in Q4.

# Q5. One might argue that background of parents and family structure are important in predicting children's math performance. 
#     Build another random forest model with only family-related factors (Pstatus, Medu, Mjob, Fedu, Fjob, guardian, famsize, famrel, and famsup).
#     Based on your analysis, do you agree or disagree with this argument?
#     Write your answer below by using comment (#).

#====================== Write R code HERE ==========================









#===================================================================


#====================================
#======= Question 6 (1 Point) =======
# Q6. Suggest one possible application of this predictive analytics to improve education.
#     Write your answer below by using comment (#), up to 10 lines.

#====================== Write R code HERE ==========================








#===================================================================



#===========================================================================================================
# Before submission, I recommend you restart your RStudio and run all codes.
# Please ensure that there is no error message in your code. Any code errors will get some points deduction without exception.
#===========================================================================================================


# Congratulations on your completion of the predictive analytics course!
# Wish you the best of luck!
