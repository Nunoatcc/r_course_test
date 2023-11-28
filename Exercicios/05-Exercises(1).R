###############################################
#                                             #
# PART 05                                     #
# Statistics with R                           #
# Exercises                                   #
#                                             #
###############################################

#Install packages as needed
# install.packages("tidyverse") #The core packages
# install.packages("rio") #To import data
# install.packages("car") #For the levene test
# install.packages("MASS") #For a dataset that we will use
# install.packages("medicaldata") #For datasets that we will use
# install.packages("ggstatsplot") #For quick plots with stats info already on them
# install.packages("broom") #Tidy model outputs
# install.packages("survival") #Do survival models
# install.packages("ggsurvfit") #Plot survival models with ggplot
# install.packages("report") #Report model outputs
# install.packages("lme4") #Mixed models

#Load packages
library(tidyverse) #The core library
library(rio) #to import data
library(car) #For the levene test
library(MASS) #For example datasets and stepwise regression
library(medicaldata) #For datasets that we will use
library(ggstatsplot) #For quick plots with stats info already on them
library(broom) #Tidy model outputs
library(survival) #Do survival models
library(ggsurvfit) #Plot survival models with ggplot
library(report) #Report model outputs
library(lme4) #Mixed models

# ==== No Dependent or independent variables ====

#***********************#
#    Chi-square test    #
#***********************#

#Let's import the cancer dataset
cancer <-  rio::import("https://github.com/c-matos/Intro-R4Heads/raw/main/materials/data/cancer_data.xlsx") %>% 
  as_tibble()

#Do a chisq.test of status (dead or alive) over ecog score (0 to 3)

#Do you get a warning message? Why?

#Plot a chart with ggstatsplot
#HINT: use the ggbarstats() function



# ==== Continuous independent variables ====

# ==== PARAMETRIC tests ====


#***********************#
#    One sample t-test  #
#***********************#

#Using the anorexia dataset from the {MASS} package
#Is the Weight of patient before study period equal to 80lbs?
##Do a paired samples t.test of the weight at baseline

#******************************#
# Paired samples sample t-test #
#******************************#

#Using the anorexia dataset from the {MASS} package
#Is there a difference in weights before and after study period?
##Do a paired samples t.test of weight at baseline and after treatment

#***********************************#
# Independent samples sample t-test #
#***********************************#

#Using the polyps dataset from the {medicaldata} package
#Do a LeveneTest to check if homogeneity of variances can be assumed

# Do an independent samples t.test of number of polyps at baseline, by treatment type.
# Change the parameter var.equal in the t.test according to the leveneTest results

#***********************************#
# One way ANOVA                     #
#***********************************#

#Using the anorexia dataset from the {MASS} package
#Create a new variable for the difference in weights with th treatment


#Do a LeveneTest to check if homogeneity of variances can be assumed
#Perform a oneway.test (ANOVA)

#If the results is significant, do a pairwise.t.test to identify which groups show differences

#Plot a chart with ggstatsplot
#HINT: use the ggbetweenstats() function


#Now get the stats that appear in the plot to a table, with the extract_stats() function



# ==== NON-PARAMETTRIC tests ====

#***********************************#
# Wilcoxon signed-rank test         #
#***********************************#

#One sample
#Paired Samples

#***************************#
# Mann-Whitney U test       #
#***************************#

#Independent samples (2 levels)

#**************************#
# Kruskal-Wallis test      #
#**************************#

#Independent sample (> 2 levels)

# ==== Regression Modelling ====

#******************************#
# Simple linear regression     #
#******************************#

#Import the dp dataset from Github
#Note that rio::import takes care of a SPSS .sav file, directly from the web
bp_dataset <- rio::import("materials/data/blood_pressure.sav") %>% as_tibble() %>% glimpse()
bp_dataset <- rio::import("https://raw.githubusercontent.com/c-matos/Intro-R4Heads/main/materials/data/blood_pressure.sav") %>% 
  as_tibble() %>% 
  glimpse()

#Do a simple linear regression of systolic pressure over weight
#Store the results in an object called bp_lm_model

#Explore the results with the summary() funciton

#Explore the model with each of the broom functions


#Plot the linear correlation with ggscatterstats()
#Note that this is a correlation between two variables. You need to pass the dataset as argument, not the model output

#Plot the coefficients with ggcoefstats()
## Note: if the intercept is to far away from the other coefficients, use exclude.intercept = TRUE

#Using your model, make a prediction for the systolic pressure for a person weighting 85Kg


#Now do a similar model, but add age as a predictor

#explore the model results with summary()

#Now explore a model of the interaction between weight and age as predictors of systolic BP.
## Try using weight*age vs weight:age for the interaction. What is the difference?


#Now do a model to predict systolic BP with all available variables and call it bp_full_model
#WARNING: we will use this model to do a stepwise regression that doesn't deal well with missings, 
#therefore we need to remove all missings from the dataset first


#Using the stepAIC function from the {MASS} package, do a stepwise regression


#Now visually check the model assumptions with plot()

#************************#
# Logistic regression    #
#************************#

#Using the cancer dataset, imported in the first exercise of this page
# Do a logistic regression of status over sex and ecog

#Exponentiate the coefficients and get IC 95%  using the tidy() function from {broom}



#************************#
# Survival analysis      #
#************************#

#Using the lung dataset from {survival} package

#Do a survival model (Kaplan-Meier) by sex and store the result in a lung_kaplan_meier object

#Explore the median survival time and CI


#Plot the results with ggsurvfit. Add components to the chart and explore the resulting changes 
#HINT: ggsurvit uses the syntax add_* to add components.
#      use ggsurvfit:: to see what components are available to add to the chart (e.g. pvalue, quantile, ...)


#Perform a log rank test for differences in survival curves by sex


#Now let's do a Cox proportional hazards model instead

#Check the results with summary()


#************************#
# Mixed models           #
#************************#

#Using the sleepstudy dataset, from {lme4} package
#Do a mixed effects regression of Reaction time over days and subject, 
#considering fixed effects for days, and random effects for days over subjects

#Explore the model output

#Using the report() function, from the {report} package, create a report for the mixed model you just created

#Now use the report function for the lm and glm models created above and see the results

