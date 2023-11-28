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
chisq.test(cancer$status, cancer$ecog)

#Do you get a warning message? Why?

#Plot a chart with ggstatsplot
#HINT: use the ggbarstats() function
cancer %>% 
  filter(ecog != 3) %>% #Exclude category with a single observation
  mutate(status_fct = factor(status, levels = c(0,1), labels = c("Alive","Dead"))) %>% #Convert status to factor
  ggbarstats(x = status_fct,
             y = ecog)


# ==== Continuous independent variables ====

# ==== PARAMETRIC tests ====


#***********************#
#    One sample t-test  #
#***********************#

#Using the anorexia dataset from the {MASS} package
#Is the Weight of patient before study period equal to 80lbs?
##Do a paired samples t.test of the weight at baseline
t.test(anorexia$Prewt, mu = 81)

#******************************#
# Paired samples sample t-test #
#******************************#

#Using the anorexia dataset from the {MASS} package
#Is there a difference in weights before and after study period?
##Do a paired samples t.test of weight at baseline and after treatment
t.test(anorexia$Prewt, anorexia$Postwt, paired = T)

#***********************************#
# Independent samples sample t-test #
#***********************************#

#Using the polyps dataset from the {medicaldata} package
#Do a LeveneTest to check if homogeneity of variances can be assumed
car::leveneTest(number12m ~ treatment, data = polyps)

# Do an independent samples t.test of number of polyps at baseline, by treatment type.
# Change the parameter var.equal in the t.test according to the leveneTest results
t.test(number12m ~ treatment, data = polyps, var.equal = TRUE)

#***********************************#
# One way ANOVA                     #
#***********************************#

#Using the anorexia dataset from the {MASS} package
#Create a new variable for the difference in weights with th treatment
anorexia2 <- anorexia %>% 
  mutate(wt_diff = Postwt - Prewt)

#Do a LeveneTest to check if homogeneity of variances can be assumed
car::leveneTest(wt_diff ~ Treat, data = anorexia2)
#Perform a oneway.test (ANOVA)
oneway.test(wt_diff ~ Treat, data = anorexia2)

#If the results is significant, do a pairwise.t.test to identify which groups show differences
pairwise.t.test(x = anorexia2$wt_diff, g = anorexia2$Treat)

#Plot a chart with ggstatsplot
#HINT: use the ggbetweenstats() function
anorexia2 %>% 
  ggbetweenstats(x = Treat,
                 y = wt_diff)

#Now get the stats that appear in the plot to a table, with the extract_stats() function
anova_results <- anorexia2 %>% 
  ggbetweenstats(x = Treat,
                 y = wt_diff) %>% 
  extract_stats()

#Check the results of pairwise comparisons
anova_results$pairwise_comparisons_data

# ==== NON-PARAMETTRIC tests ====

#***********************************#
# Wilcoxon signed-rank test         #
#***********************************#

#One sample
wilcox.test(anorexia$Prewt, mu = 81) 
#Paired Samples
wilcox.test(anorexia$Prewt, anorexia$Postwt, paired = T) 

#***************************#
# Mann-Whitney U test       #
#***************************#

#Independent samples (2 levels)
wilcox.test(number12m ~ treatment, data = polyps)

#**************************#
# Kruskal-Wallis test      #
#**************************#

#Independent sample (> 2 levels)
kruskal.test(wt_diff ~ Treat, data = anorexia2)

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
bp_lm_model <- lm(systolic ~ weight, data = bp_dataset)

#Explore the results with the summary() funciton
summary(bp_lm_model)

#Explore the model with each of the broom functions
broom::tidy(bp_lm_model)
broom::glance(bp_lm_model)
broom::augment(bp_lm_model)

#Plot the linear correlation with ggscatterstats()
#Note that this is a correlation between two variables. You need to pass the dataset as argument, not the model output
ggscatterstats(bp_dataset, x = weight, y = systolic)

#Plot the coefficients with ggcoefstats()
## Note: if the intercept is to far away from the other coefficients, use exclude.intercept = TRUE
ggcoefstats(bp_lm_model, exclude.intercept = TRUE)

#Using your model, make a prediction for the systolic pressure for a person weighting 85Kg
prediction_data <- tibble(weight = 85) %>% 
  mutate(predicted_bp = predict(bp_lm_model, .))

#Now do a similar model, but add age as a predictor
bp_lm_model2 <- lm(systolic ~ weight + age, data = bp_dataset)

#explore the model results with summary()
summary(bp_lm_model2)

#Now explore a model of the interaction between weight and age as predictors of systolic BP.
## Try using weight*age vs weight:age for the interaction. What is the difference?

lm(systolic ~ weight*age, data = bp_dataset) %>% summary() #Adds both variables independently, as well as the interaction
lm(systolic ~ weight:age, data = bp_dataset) %>% summary() #Keeps just the interaction parameter

#Now do a model to predict systolic BP with all available variables and call it bp_full_model
#WARNING: we will use this model to do a stepwise regression that doesn't deal well with missings, 
#therefore we need to remove all missings from the dataset first
bp_dataset_clean <- bp_dataset %>% drop_na()
bp_full_model <- lm(systolic ~ ., data = bp_dataset_clean) #Adds both variables independently, as well as the interaction

summary(bp_full_model)

#Using the stepAIC function from the {MASS} package, do a stepwise regression

step_model <- MASS::stepAIC(bp_full_model, direction = "both")

summary(step_model)

#Now visually check the model assumptions with plot()
plot(step_model)
#NOTE: after running the command above you will see in the console "Hit <Return> to see next plot:"
#Just click enter a few times to show each plot

#************************#
# Logistic regression    #
#************************#

#Using the cancer dataset, imported in the first exercise of this page
# Do a logistic regression of status over sex and ecog
cancer_glm_model <- glm(status ~ sex + ecog, data = cancer, family = "binomial")

#Exponentiate the coefficients and get IC 95%  using the tidy() function from {broom}
cancer_glm_model %>% broom::tidy(conf.int= TRUE, exponentiate = TRUE)



#************************#
# Survival analysis      #
#************************#

#Using the lung dataset from {survival} package

#Do a survival model (Kaplan-Meier) by sex and store the result in a lung_kaplan_meier object
lung_kaplan_meier <- survfit2(Surv(time = time, event = status) ~ sex, data = lung)

#Explore the median survival time and CI
lung_kaplan_meier

#Plot the results with ggsurvfit. Add components to the chart and explore the resulting changes 
#HINT: ggsurvit uses the syntax add_* to add components.
#      use ggsurvfit:: to see what components are available to add to the chart (e.g. pvalue, quantile, ...)
lung_kaplan_meier %>% 
  ggsurvfit() +
  ggsurvfit::add_confidence_interval() +
  ggsurvfit::add_risktable(risktable_stats = c("n.risk", "cum.event")) +
  ggsurvfit::add_pvalue() +
  ggsurvfit::add_censor_mark() +
  ggsurvfit::add_quantile(.5) +
  labs(
    x = "Days",
    y = "Overall survival probability"
  )

#Perform a log rank test for differences in survival curves by sex
survdiff(formula = Surv(time, status) ~ sex, data = lung)


#Now let's do a Cox proportional hazards model instead
cox_model <- coxph(Surv(time, status) ~ sex + ph.ecog + wt.loss, data = lung)

#Check the results with summary()
summary(cox_model) 

report(lung_kaplan_meier)

#************************#
# Mixed models           #
#************************#

#Using the sleepstudy dataset, from {lme4} package
#Do a mixed effects regression of Reaction time over days and subject, 
#considering fixed effects for days, and random effects for days over subjects
mixed_model<-lmer(Reaction ~ Days + (Days | Subject), data = sleepstudy)

#Explore the model output
summary(mixed_model)

#Using the report() function, from the {report} package, create a report for the mixed model you just created
report(mixed_model)

#Now use the report function for the lm and glm models created above and see the results
report(bp_lm_model)
report(cancer_glm_model)
report_table(cancer_glm_model)
