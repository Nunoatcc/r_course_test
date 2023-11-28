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
  group_by(sex) %>% 
  summarize(n = n()) %>% 
  mutate(freq_rel = n/sum(n))

#Crosstabulation with {crosstable}

## For sex

## For treatment


# What are the advantages and disadvantages of using each approach?



# QUANTITATIVE DATA


#Using the gapminder dataset, from the {gapminder} package, do:

#BASE R: Summary statistics 
summary(gapminder$lifeExp)


##All the quantiles of life expectancy, in 1% increments
quantile(x=gapminder$lifeExp,
         probs = c(0.01,0.99, 0.01))

#TIDYVERSE: Summary statistics

##Max, Min, Mean, median, IQR, standard deviation
gapminder %>% 
  summarise(media = mean(lifeExp),
            mediana = median(lifeExp),
            range = IQR(lifeExp),
            variance = var(lifeExp),
            sd = sd(lifeExp)) %>% 
  pivot_longer(everything())


#CROSSTABLE: Summary statistics

#For life expectancy
gapminder %>% 
  crosstable(cols=lifeExp) %>% 
  as_flextable()

#For all variables except country

gapminder %>% 
  crosstable(cols=!country) %>% 
  as_flextable()

#Using the polyps dataset, from the {medicaldata} package, do:

#TIDYVERSE: Summary statistics (Mean, Median, SD) for the number of polyps at 12m~ - What happened and why?
polyps %>% 
  summarise(media = mean(number12m, na.rm = T),
            mediana = median(number12m, na.rm = T),
            sd = sd(number12m, na.rm = T))

# escreve-se "na.rm = T" porque existem valores NA, assim calcula a media ignorando esses valores

#What is the mean and standard deviation of GDP per capita in the most recent year, by continent?

gapminder %>%
  filter(year == max(year)) %>% 
  group_by(continent) %>% 
  summarise(media = mean(gdpPercap),
            sd = sd(gdpPercap))


# ==== UNIVARIATE GRAPHICAL ====
#===============================

#With the gapminder dataset, and using {ggplot2}

# Histogram of life expectancy

ggplot(data=gapminder)+
  aes(x=lifeExp)+
  geom_histogram(binwidth = 0.5, fill="blue", color="red")+
  labs(title = "BLABLA", x="bleble", y="bliblibli")

#ou entao:

gapminder %>% 
  ggplot(aes(x=lifeExp))+
  geom_histogram(binwidth = 2, fill="darkred", color="black")


# Density plot of life expectancy, filled by continent

gapminder %>% 
  ggplot(aes(x=lifeExp, fill=continent))+
  geom_density(alpha=0.5)+
  labs(title="ABC", x="DEF", y="GHI")

#OU ENTAO

ggplot(data=gapminder)+
  aes(x=lifeExp, fill=continent)+
  geom_density(alpha=0.5)+
  labs(title = "BLABLA", x="bleble", y="bliblibli")

# Density of life expectancy, filled by continent, faceted

ggplot(data=gapminder)+
  aes(x=lifeExp, fill=continent)+
  geom_density(alpha=0.5)+
  labs(title = "BLABLA", x="bleble", y="bliblibli")+
  facet_wrap(vars(continent))

# Quantile-quantile plot

gapminder %>% 
  ggplot(aes(sample=lifeExp))+
  geom_qq()

gapminder %>% 
  ggplot(aes(sample=lifeExp))+
  geom_qq()+
  geom_qq_line()

gapminder %>% 
  ggplot(aes(sample=lifeExp))+
  geom_qq()+
  geom_qq_line()+
  facet_wrap(vars(continent))

#==== MULTIVARIATE NON-GRAPHICAL ====
#====================================

# CATEGORICAL DATA

#Using the polyps dataset, from the {medicaldata} package, do:

#crosstable of treatment over sex

polyps %>% 
  crosstable(cols=treatment,
             by=sex) %>% 
  as_flextable()

#crosstable of treatment and age over sex

polyps %>% 
  crosstable(cols=c(treatment,age),
             by=sex) %>% 
  as_flextable()

#crosstable of all other variables, except paticipant_id, over sex

polyps %>% 
  crosstable(cols=!participant_id,
             by=sex) %>% 
  as_flextable()

#QUANTITATIVE DATA

#Using the gapminder dataset, from the {gapminder} package, do:

#Correlation of life expectancy and gdp per capita using cor()
library(gapminder)

cor(x=gapminder$lifeExp, y=gapminder$gdpPercap, method="spearman")

#Covariance of life expectancy and gdp per capita using cov()
cov(x=gapminder$lifeExp, y=gapminder$gdpPercap, method="spearman")


#Correlation of life expectancy and population with gdp per capita using crosstable

gapminder %>% 
  crosstable(cols=c(lifeExp, pop),
             by=gdpPercap,
             cor_method="spearman") %>% 
  as_flextable()


#Using the polyps dataset, from the {medicaldata} package, do:

#Correlation of polyps at baseline with polyps at 12m. 
##What happens? Try to explore the function help file with F1 or ? and solve the problem 

cor(polyps$baseline, polyps$number12m, use="complete.obs")

#sem o use=xxxx , o valor dava NA 
 
#Confirm the results above with crosstable

polyps %>% 
  crosstable(cols=baseline,
             by=number12m)

#==== MULTIVARIATE GRAPHICAL ====
#================================

#Using the polyps dataset, from the {medicaldata} package, do:

#Bar chart of mean number of polyps at 3M for placebo vs sulindac

polyps %>% 
  ggplot(aes(x=treatment,y=number3m))+
  geom_bar(stat="summary", fun="mean", width=0.5, fill="green")

#OU

polyps %>% 
  group_by(treatment) %>% 
  summarize(mean_polyps_3m=mean(number3m)) %>% 
  ggplot(aes(x=treatment,y=mean_polyps_3m))+
  geom_col()

#Was this the best approach to the problem? 
#What bias can be present in using the mean number of polyps? How could we improve on that?
polyps_calcs <- polyps %>% 
  mutate(abs_diff_3m= number3m - baseline,
         rel_diff_3m= (number3m-baseline)/baseline) %>%
  group_by(treatment) %>% 
  summarise(mean_abs_diff_3m = mean(abs_diff_3m),
            mean_red_diff_3m = mean(rel_diff_3m))

polyps_calcs %>% 
  ggplot(aes(x=treatment,y=mean_abs_diff_3m))+
  geom_col()

#Stacked bar chart of mean number of polyps at 3M for placebo vs sulindac, BY SEX

polyps %>% 
  group_by(sex,treatment) %>% 
  summarize(mean_polyps_3m=mean(number3m)) %>% 
  ggplot(aes(x=treatment, y=mean_polyps_3m, fill=sex))+
  geom_col()


#Using the gapminder dataset, from the {gapminder} package, do:

# A scatter plot of life expectancy and gdp per capita for all the available data



#In some places the point density is so high that it's difficult to understand 
#if some regions of space are denser than others. How to improve? HINT: Change the alpha (aka, transparency)


#Bubble chart, with the size of the bubble proportional to population size


#Violin plot with the distribution of life expectancy by continent


