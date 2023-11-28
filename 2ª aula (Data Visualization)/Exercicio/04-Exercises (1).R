###############################################
#                                             #
# PART 04                                     #
# Data visualization with ggplot2             #
# Exercises                                   #
#                                             #
###############################################

#Load packages
library(tidyverse) #ggplot is part of the tidyverse
library(leaflet)
library(gapminder)
library(eurostat)
library(janitor)


#First worked example

gm_latest <- gapminder %>% 
  filter(year == 2007)

gm_latest %>% 
  ggplot(mapping = aes(x = gdpPercap))

#3 expressoes equivalentes
ggplot(data = gm_latest, mapping = aes(x = gdpPercap))
ggplot(gm_latest, aes(x = gdpPercap))
ggplot(gm_latest) +
  aes(x = gdpPercap)

gm_latest %>% 
  ggplot(mapping = aes(x = gdpPercap, y = lifeExp))+
  geom_point(aes(color = "blue")) #ao meter o aes ele cria uma variavel chamada blue


gm_latest %>% 
  ggplot(mapping = aes(x = gdpPercap, y = lifeExp))+
  geom_point(color = "blue") #sem o aes ja muda pra azul os pontos

gm_latest %>% 
  ggplot()+
  geom_point(aes(x = gdpPercap, y = lifeExp))+
  geom_line()

gm_latest %>% 
  ggplot() +
  geom_point(aes(x = gdpPercap, y = lifeExp, color = continent, size = 5))

#With the gapminder dataset, 
##Plot life expectancy over gdp per capita
##Try mapping different aesthetics(size, shape, color) to different variables(pop, gdp per capita, life expectancy) and see what happens...

#Preparing the data - kepp only the most recent year, at save the results in an object called gm_latest

#Scatter plot

gm_latest %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp))+
  geom_point()

#Now with size of the points proportional to population

gm_latest %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp))+
  geom_point(aes(size = pop))

#Now with color by continent

gm_latest %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp))+
  geom_point(aes(size = pop, colour = continent))

#Now with a shape by continent

gm_latest %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp))+
  geom_point(aes(size = pop, colour = continent, shape = continent))

#Now add an alpha of 0.7

gm_latest %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp))+
  geom_point(aes(size = pop, colour = continent, 
                 shape = continent),
             alpha = 0.7)


#There seems to exist a log/exp relation of gpdPercap and lifeExp, so let's try plotting the log of gdp instead

gm_latest %>% 
  ggplot(aes(x = log(gdpPercap), y = lifeExp))+
  geom_point(aes(size = pop, colour = continent, 
                 shape = continent),
             alpha = 0.7)

#Now add a manual discrete scale to the color aesthetic, and use the colors provided in gapminder::continent_colors

gapminder::continent_colors

gm_latest %>% 
  ggplot(aes(x = log(gdpPercap), y = lifeExp))+
  geom_point(aes(size = pop, colour = continent, 
                 shape = continent),
             alpha = 0.7)+
  scale_color_manual(values = gapminder::continent_colors)

#Now Suppose you don't like those colors, and want to try out new ones
##Explore the available sets from {RColorBrewer} with RColorBrewer::display.brewer.all()

RColorBrewer::display.brewer.all()

##Suppose that you like "Set1".
## Sample an amount of colors equal to the number of continents with with RColorBrewer::brewer.pal and store it in a vector

my_colors <- RColorBrewer::brewer.pal(5, "Set1")


##Add a name to each element of the vector corresponding to the available continents

names(my_colors) <- levels(gm_latest$continent)


##Change the colors to the vector you just created
names(my_colors) <- c("Oceania", "Asia", "Europa", "Africa", "Americas")


gm_latest %>%
  ggplot(aes(x=log(gdpPercap), y=lifeExp))+
  geom_point(aes(size=pop, color=continent, shape=continent),
             alpha=0.7)+
  scale_color_manual(values = gapminder::continent_colors)+
  scale_shape_manual(values = 15:20)+
  labs(titlle= "Life Expectancy iver GPD per capita",
       subtitle= "Life Expectancy increases logarithmicallly with GDP per capita",
       x = "GDP per capita (log scale)",
       y= "Life Expectancy") +
  theme(panel.background = element_rect(fill = NA), #apaga linhas das grelhas
        panel.grid = element_line(color=NA),#outro tipo de linhas
        panel.grid.major = element_line(color = "#EEEEEE")) 


##Now suppose you don't like the shapes. Give manual values to the shapes
##Suggested: use shapes 15 to 20


#Now change the axis labels and add informative title and subtitles


#Now remove the gray background and the panel grid


#Now add only X- and Y-axis major grid

#Instead of using log(gpd) in the x axis, we can use the gdpPercap in the aes, and isntead transform the axis, 
#using coord_trans(x="log10")

gm_latest %>%
  ggplot(aes(x=gdpPercap, y=lifeExp))+
  geom_point(aes(size=pop, color=continent, shape=continent),
             alpha=0.7)+
  scale_color_manual(values = gapminder::continent_colors)+
  scale_shape_manual(values = 15:20)+
  coord_trans(x="log10")+ #acrescentar isto e retirar o log do x=gdpPercap em cima
  labs(titlle= "Life Expectancy iver GPD per capita",
       subtitle= "Life Expectancy increases logarithmicallly with GDP per capita",
       x = "GDP per capita (log scale)",
       y= "Life Expectancy") +
  theme(panel.background = element_rect(fill = NA), 
        panel.grid = element_line(color=NA),
        panel.grid.major = element_line(color = "#EEEEEE"))


#Now suppose you want to hide the pop legend, and instead add a caption explaining that size varies with pop

gm_latest %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp))+
  geom_point(aes(size = pop, color = continent, 
                 shape = continent), alpha = 0.7) +
  scale_color_manual(values = my_colors) +
  scale_shape_manual(values = 15:20) +
  guides (size = 'none')+
  coord_trans(x="log10") +
  labs(title = 'life Expectancy over Gdp per capita',
       subtitle = 'life expetancy increases logarithimically with gdp per capita',
       caption = 'Shape size proportional to the population',
       x = 'Gdp per capita (log scale)',
       y = 'life expectancy')+
  theme(panel.background = element_rect(fill = NA),
        panel.grid.major = element_line(color = '#EEEEEE'),
        legend.position = 'top')
#guides, configurar a legenda fundo e tamanho

##Suppose you are happy with your plot. Save it with ggsave and check the results. How did it look?
ggsave("plot1.png")
getwd()

##One way to improve the look is with the gg_record() function from the camcorder package
#install.packages("camcorder")
install.packages("camcorder")
library(camcorder)

camcorder::gg_record(
  dir = "images/",
  device = "png",
  height = 5,
  width = 5 * 16/9,
  bg = "white",
  scale = 2
)

#=====================================

#Simple map with leaflet, showing ISPUP coordinates and logo
ispup_logo <- c("<img src=https://ispup.up.pt/wp-content/themes/ispup/images/logo-color.svg>")
ispup_coordinates <- c(lon = -8.616611357347235, lat=41.14440087224056)
install.packages("leaflet")
library(leaflet)

leaflet() %>% 
  leaflet::addTiles() %>% 
  addPopups(lng = ispup_coordinates["lon"],
            lat = ispup_coordinates["lat"],
            popup = ispup_logo)

#=====================================

#Plot Portuguese hospitals on the map with leaflet
install.packages("jsonlite")
library(jsonlite)
library(tidyverse)

hospital_data <- jsonlite::fromJSON("https://transparencia.sns.gov.pt/api/explore/v2.1/catalog/datasets/atividade-de-internamento-hospitalar/records?limit=-1&refine=tempo%3A%222022%2F12%22") %>%
  pluck("results") %>% 
  unnest_wider(localizacao_geografica)

leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = hospital_data$lon, lat = hospital_data$lat)



#==================================

#Plot a world map
world <- map_data("world") 
view(world)

world %>% 
  ggplot(aes(x = long, y = lat, group = group, fill = region)) +
  geom_polygon(color=)+
  theme(legend.position = "none")+
  coord_equal()

1#==================================

#Plot a world map with population data from gapminder from the most recent year
#HINT: Before joining the data, explore the datasets to check which variables match in each dataset




#==================================



#1. Get population data from "pt_pop_nuts3.rds"
#2. Filter for the year 2022
#3. Get map data from eurostat
  #3A.Alternatively, if getting an error, use "pt_map_nuts3.rds"
#4. Filter for PT, and exclude RAM and RAA
#5. Join population data to map data
  #HINT: the variable nuts_id from the map data is not exactly equal to "geo_cod" from population data!
  #       Some processing will be required.. What to you suggest?
#6. Plot with geom_sf()

#Get map data
library(eurostat)
library(janitor)

#1.
nuts3_data <- 
  rio::import("https://github.com/c-matos/Intro-R4Heads/raw/main/materials/data/pt_pop_nuts3.rds") 


#3.
pt_map_nuts3 <- 
  get_eurostat_geospatial(resolution = 10, nuts_level = 3, year = 2021)









