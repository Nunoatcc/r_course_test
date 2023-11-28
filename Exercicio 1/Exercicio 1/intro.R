single_number <- 10
single_number
my_first_vector <- c(1,2,3)
my_second_vector <- c(1:10)
my_third_vector <- c(1:5,17)
my_fourth_vector <- seq(1,50,3)
my_first_vector * 2
my_new_first_vector <- my_first_vector + 2
typeof(my_fourth_vector)
my_attempt_logical_vector <- c(T,F,2)
my_attempt_logical_vector
my_named_vector <- c(one="A", two = "B")
my_named_vector
my_colors <- c(Portugal = "red", Europe = "blue")
same_long_vector <- seq(0,100,0.1)
same_long_vector
head(same_long_vector,10)
tails(same_long_vector,10)
tail(same_long_vector,10)
same_long_vector(47)
same_long_vector[47:50]
same_long_vector[47,50]
same_long_vector[c(47,50)]
my_first_vector[-2] # o "-" quer dizer exceto!



named_vector <- c(PT = "red", EU = "blue")
named_vector["PT"]

renamed_vector <- named_vect
rm(named_vector)



#Let's create a numeric vector
x <- c(10, 33, NA, 4, 9, 2, NA)

#a logical vector. Is TRUE if x is NA
x_na <- is.na(x)
x[is.na(x)]# os [] e tipo seleccionar uma secção

x[!is.na(x)]
!x_na

x[x>5]

x[x>5]
x[x>5 & !is.na(x)] # o "!" é tipo inverso
x[x>5 | x == 2] # o "|" e ou

x[is.na(x)]
x[(x>5 | x == 2) & !is.na(x)]





some_char_vec <- c("a","b","c","d")
some_char_vec[4]
some_char_vec[1:2] <- c("x","y")
some_char_vec



first_list <- list(1:3,"A",list(4:6))
first_list
first_list[1]
first_list[[1]]
first_list[1:2]
my_named_list <- list(some_vector = c(1:3),
                      some_value = "R",
                      other_value = list(1:3))

my_named_list$some_vector
my_named_list$other_value

#Statistical models output lists in R. 
#Select the coefficient associated with gdpPercap in the model below
#'[Red]* HINT: use the object explorer to visually explore the output *
some_model_output <- lm(lifeExp ~ gdpPercap, data = gapminder::gapminder)

some_model_output[["coefficients"]][["gdpPercap"]]

some_model_output$coefficients["gdpPercap"]


my_dataframe <- data.frame(col1 = 1:3,
                           col2= c("A","B","C"))

View(my_dataframe)

my_dataframe[,2] #acede à coluna 2
my_dataframe[2,] #acede à linha 2

my_dataframe[3,2] #acede à linha 3 + coluna 2

library(tidyverse)

my_dataframe <- tibble(col1 = 1:3,
                           col2= c("A","B","C")) #precisamos de carregar o tidyverse 1º

my_dataframe


my_tibble <- tibble(col1 = letters,
                    col2 = LETTERS)
my_tibble

print(my_tibble, n=20)

my_tibble
view(my_tibble)

df <- data.frame(col1 = c(1,2,3),
                 col2 = c("A","B","C"))
df[3,1] <- "a"
df[3,1]
view(df)

df <- tibble(col1 = c("A","B","C"),
             col2 = c(1,2,3),
             col3 = c(TRUE, FALSE, TRUE))
df
view(df)

#Add a new variable to the tibble
df$my_awesome_new_col <- c("Awe-","wait for it","-some!")
view(df)


library(tidyverse)

view(df)

library(janitor)

