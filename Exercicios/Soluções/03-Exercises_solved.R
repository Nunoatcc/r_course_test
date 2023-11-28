###############################################
#                                             #
# PART 03                                     #
# Exploratory Data Analysis (EDA)             #
# Exercises                                   #
#                                             #
###############################################

#Load packages
library(tidyverse) #ggplot is part of the tidyverse
library(crosstable)
library(gapminder)
library(medicaldata)

# ==== UNIVARIATE NON-GRAPHICAL ====
#===================================

# CATEGORICAL DATA

#Using the polyps dataset, from the {medicaldata} package, do:

#Crosstabulation with the tidyverse, showing absolute and relative frequencies

## For sex
polyps %>%
  count(sex) %>% 
  mutate(rel_freq = n/sum(n))


#Crosstabulation with {crosstable}

## For sex
polyps %>% 
  crosstable(sex)

## For treatment
polyps %>% 
  crosstable(treatment)

# What are the advantages and disadvantages of using each approach?

#ANSWER: tidyverse gives you more control, at the cost of increased complexity


# QUANTITATIVE DATA


#Using the gapminder dataset, from the {gapminder} package, do:

#BASE R: Summary statistics for lifeExp
summary(gapminder$lifeExp)
#Similar
with(gapminder, summary(lifeExp))

##All the quantiles of life expectancy, in 1% increments
quantile(gapminder$lifeExp, seq(0.01,1,.01))


#TIDYVERSE: Summary statistics

##Max, Min, Mean, median, IQR, standard deviation
gapminder %>% 
  summarise(mean = mean(lifeExp),
            median = median(lifeExp),
            sd = sd(lifeExp),
            var = var(lifeExp),
            min = min(lifeExp),
            max = max(lifeExp),
            iqr = IQR(lifeExp))

#CROSSTABLE: Summary statistics

#For life expectancy
gapminder %>% 
  crosstable(lifeExp) %>% 
  as_flextable() #This line of code is for display purposes only

#For all variables except country
gapminder %>% 
  crosstable(-country) %>% 
  as_flextable() 


#Using the polyps dataset, from the {medicaldata} package, do:

#TIDYVERSE: Summary statistics (Mean, Median, SD) for the number of polyps at 12m~ - What happened and why?
polyps %>% 
  summarise(mean = mean(number12m, na.rm = T),
            median = median(number12m, na.rm = T),
            sd = sd(number12m, na.rm = T))

#ANSWER: we need to add the na.rm parameters, to exclude na


#Using the gapminder dataset, from the {gapminder} package:

#What is the mean and standard deviation of GDP per capita in the most recent year, by continent?
gapminder %>% 
  filter(year == max(year)) %>% 
  group_by(continent) %>% 
  summarise(mean = mean(gdpPercap),
            sd = sd(gdpPercap))


# ==== UNIVARIATE GRAPHICAL ====
#===============================

#With the gapminder dataset, and using {ggplot2}

# Histogram of life expectancy
gapminder %>% 
  ggplot(aes(x = lifeExp)) +
  geom_histogram()

# Density plot of life expectancy, filled by continent
gapminder %>% 
  ggplot(aes(x = lifeExp)) +
  geom_density()
  
# Density of life expectancy, filled by continent, faceted

##FILLED
gapminder %>% 
  ggplot(aes(x = lifeExp, fill = continent, color = continent)) +
  geom_density(alpha = 0.3)

##FACETED
gapminder %>% 
  ggplot(aes(x = lifeExp, fill = continent, color = continent)) +
  geom_density(alpha = 0.3) +
  facet_wrap(vars(continent))

#Quantile-quantile plot
gapminder %>% 
  ggplot(aes(sample=lifeExp)) +
  geom_qq(color="red4") +
  geom_qq_line()


#==== MULTIVARIATE NON-GRAPHICAL ====
#====================================

# CATEGORICAL DATA

#Using the polyps dataset, from the {medicaldata} package, do:

#crosstable of treatment over sex
polyps %>% 
  crosstable(cols = treatment, 
             by = sex)

#crosstable of treatment and age over sex
polyps %>% 
  crosstable(cols = c(treatment,age), 
             by = sex) %>% 
  as_flextable()

#crosstable of all other variables, except paticipant_id, over sex
crosstable(data = polyps,
           cols = -participant_id,
           by = treatment,
           percent_digits=1) %>% 
  as_flextable()

#QUANTITATIVE DATA

#Using the gapminder dataset, from the {gapminder} package, do:

#Correlation of life expectancy and gdp per capita using cor()
cor(gapminder$lifeExp, gapminder$gdpPercap)
with(gapminder, cor(lifeExp, gdpPercap)) #Alternative

#Covariance of life expectancy and gdp per capita using cov()
cov(gapminder$lifeExp, gapminder$gdpPercap)

#Correlation of life expectancy and population with gdp per capita using crosstable
gapminder %>% 
  crosstable(cols = lifeExp,
             by = gdpPercap,
             cor_method = "spearman")


#Using the polyps dataset, from the {medicaldata} package, do:

#Correlation of polyps at baseline with polyps at 12m.
cor(polyps$baseline, polyps$number12m) #Problem with NAs
##What happens? Try to explore the function help file with F1 or ? and solve the problem 
?cor
cor(polyps$baseline, polyps$number12m, 
    use = "pairwise.complete.obs",
    method = "spearman") #Solve with "pairwise.complete.obs"

#Confirm the results above with crosstable
polyps %>% 
  crosstable(cols = baseline,
             by = number12m,
             cor_method = "spearman")

#==== MULTIVARIATE GRAPHICAL ====
#================================

#Using the polyps dataset, from the {medicaldata} package, do:

#Bar chart of mean number of polyps at 3M for placebo vs sulindac
polyps %>% 
  group_by(treatment) %>% 
  summarise(mean_polyps_3m = mean(number3m)) %>% 
  ggplot(aes(x = treatment, y = mean_polyps_3m, fill = treatment)) +
  geom_col() +
  scale_fill_brewer(palette = "Set2")
#Was this the best approach to the problem? 
#What bias can be present in using the mean number of polyps? How could we improve on that?

#Bar chart of mean number of polyps at 3M for placebo vs sulindac
polyps %>% 
  mutate(diff = number3m - baseline) %>% 
  group_by(treatment) %>%
  summarise(mean_diff = mean(diff)) %>% 
  ggplot(aes(x = treatment, y = mean_diff, fill = treatment)) +
  geom_col() +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

polyps %>% 
  mutate(diff = number3m - baseline,
         pct_diff = (number3m - baseline)/baseline*100) %>% 
  group_by(treatment) %>%
  summarise(mean_pct_diff = mean(pct_diff)) %>% 
  ggplot(aes(x = treatment, y = mean_pct_diff, fill = treatment)) +
  geom_col() +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

#Stacked bar chart of mean number of polyps at 3M for placebo vs sulindac, BY SEX
polyps %>% 
  group_by(treatment, sex) %>% 
  summarise(mean_polyps_3m = mean(number3m)) %>% 
  ggplot(aes(y=mean_polyps_3m, x = sex, fill = treatment)) +
  geom_col() +
  scale_fill_brewer(palette = "Set2") 

#Using the gapminder dataset, from the {gapminder} package, do:

# A scatter plot of life expectancy and gdp per capita for all the available data, colored by continent
gapminder %>% 
  ggplot(aes(x = log(gdpPercap), y = lifeExp, color = continent)) +
  geom_point()

#In some places the point density is so high that it's difficult to understand 
#if some regions of space are denser than others. How to improve? HINT: Change the alpha (aka, transparency)
gapminder %>% 
  ggplot(aes(x = log(gdpPercap), y = lifeExp, color = continent)) +
  geom_point(alpha = 0.3)

#Bubble chart, with the size of the bubble proportional to population size
gapminder %>% 
  filter(year == 2007) %>% 
  ggplot(aes(x = log(gdpPercap), y = lifeExp, color = continent)) +
  geom_point(aes(size = pop), alpha = 0.5) 

#Violin plot with the distribution of life expectancy by continent
gapminder %>% 
  ggplot(aes(x = continent, y = lifeExp, fill = continent)) +
  geom_violin() +
  geom_boxplot(width = 0.1, color = "black", outlier.size = 0.3, size = 0.3)
  
