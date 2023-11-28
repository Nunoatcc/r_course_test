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
library(maps)
library(camcorder)
library(sf)

#With the gapminder dataset
##Plot life expectancy over gdp per capita
##Try mapping different aesthetics(size, shape, color) to different variables(pop, gdp per capita, life expectancy) and see what happens...

#Preparing the data
gm_latest <- gapminder %>% 
  filter(year == max(year))


#Scatter plot
gm_latest %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

#Now with size of the points proportional to population
gm_latest %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(size = pop))

#Now with color by continent
gm_latest %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(size = pop, color = continent))

#Now with a shape by continent
gm_latest %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(size = pop, color = continent, shape = continent))

#now add an alpha of 0.7
gm_latest %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(size = pop, color = continent, shape = continent), alpha = 0.7) 

#There seems to exist a log/exp relation of gpdPercap and lifeExp, so let's try plotting the log of gdp instead
gm_latest %>% 
  ggplot(aes(x = log(gdpPercap), y = lifeExp)) +
  geom_point(aes(size = pop, color = continent, shape = continent), alpha = 0.7) 

#Now add a manual discrete scale to the color aesthetic, and use the colors provided in gapminder::continent_colors
gm_latest %>% 
  ggplot(aes(x = log(gdpPercap), y = lifeExp)) +
  geom_point(aes(size = pop, color = continent, shape = continent), alpha = 0.7) +
  scale_color_manual("teste", values = gapminder::continent_colors)

#Now Suppose you don't like those colors, and want to try out new ones
##Explore the available sets from {RColorBrewer} with RColorBrewer::display.brewer.all()

RColorBrewer::display.brewer.all()

##Suppose that you like "Set1".
## Sample an amount of colors equal to the number of continents with with RColorBrewer::brewer.pal and store it in a vector
my_colors <- RColorBrewer::brewer.pal(5,"Set1")
scales::show_col(my_colors)

##Add a name to each element of the vector corresponding to the available continents
names(my_colors) <- c("Asia", "Americas","Europe", "Oceania", "Africa")
my_colors

##Change the colors to the vector you just created
gm_latest %>% 
  ggplot(aes(x = log(gdpPercap), y = lifeExp)) +
  geom_point(aes(size = pop, color = continent, shape = continent), alpha = 0.7) +
  scale_color_manual("teste", values = my_colors)

##Now suppose you don't like the shapes. Give manual values to the shapes
##Suggested: use shapes 15 to 20
gm_latest %>% 
  ggplot(aes(x = log(gdpPercap), y = lifeExp)) +
  geom_point(aes(size = pop, color = continent, shape = continent), alpha = 0.7) +
  scale_color_manual("Continent", values = my_colors) +
  scale_shape_manual("Continent", values = 15:20)

#Now change the axis labels and add informative title and subtitles
gm_latest %>% 
  ggplot(aes(x = log(gdpPercap), y = lifeExp)) +
  geom_point(aes(size = pop, color = continent, shape = continent), alpha = 0.7) +
  scale_color_manual("Continent", values = my_colors) +
  scale_shape_manual("Continent", values = 15:20) +
  labs(x = "GDPpc (Log scale)",
       y = "Life Expectancy",
       title = "Relation between GPDpc and Life Expectancy",
       subtitle = "Life Expectancy seems to increase with GDPpc")

#Now remove the gray background and the panel grid
gm_latest %>% 
  ggplot(aes(x = log(gdpPercap), y = lifeExp)) +
  geom_point(aes(size = pop, color = continent, shape = continent), alpha = 0.7) +
  scale_color_manual("Continent", values = my_colors) +
  scale_shape_manual("Continent", values = 15:20) +
  labs(x = "GDPpc (Log scale)",
       y = "Life Expectancy",
       title = "Relation between GPDpc and Life Expectancy",
       subtitle = "Life Expectancy seems to increase with GDPpc") +
  theme(panel.background = element_blank(),
        panel.grid = element_blank())

#Now add only X- and Y-axis major grid
gm_latest %>% 
  ggplot(aes(x = log(gdpPercap), y = lifeExp)) +
  geom_point(aes(size = pop, color = continent, shape = continent), alpha = 0.7) +
  scale_color_manual("Continent", values = my_colors) +
  scale_shape_manual("Continent", values = 15:20) +
  labs(x = "GDPpc (Log scale)",
       y = "Life Expectancy",
       title = "Relation between GPDpc and Life Expectancy",
       subtitle = "Life Expectancy seems to increase with GDPpc") +
  theme(panel.background = element_rect(fill = "NA"),
        panel.grid = element_blank(),
        panel.grid.major = element_line(colour = "#EEEEEE60"))

#Instead of using log(gpd) in the x axis, we can use the gdpPercap in the aes, and isntead transform the axis, 
#using coord_trans(x="log10")
gm_latest %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(size = pop, color = continent, shape = continent), alpha = 0.7) +
  scale_color_manual("Continent", values = my_colors) +
  scale_shape_manual("Continent", values = 15:20) +
  coord_trans(x="log10") +
  labs(x = "GDPpc (Log scale)",
       y = "Life Expectancy",
       title = "Relation between GPDpc and Life Expectancy",
       subtitle = "Life Expectancy seems to increase with GDPpc") +
  theme(panel.background = element_rect(fill = "NA"),
        panel.grid = element_blank(),
        panel.grid.major = element_line(colour = "#EEEEEE80"))

#Now suppose you want to hide the pop legend, and instead add a caption explaining that size varies with pop
g1 <- gm_latest %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(size = pop, color = continent, shape = continent), alpha = 0.7) +
  scale_color_manual("Continent", values = my_colors) +
  scale_shape_manual("Continent", values = 15:20) +
  scale_size_continuous(guide = "none") +
  coord_trans(x="log10") +
  labs(x = "GDPpc (Log scale)",
       y = "Life Expectancy",
       title = "Relation between GPDpc and Life Expectancy",
       subtitle = "Life Expectancy seems to increase with GDPpc",
       caption = "Shape size is proportional to population") +
  theme(panel.background = element_rect(fill = "NA"),
        panel.grid = element_blank(),
        panel.grid.major = element_line(colour = "#EEEEEE80")) 

g1
##Suppose you are happy with your plot. Save it with ggsave and check the results. How did it look?
ggsave("myplot1.png", g1)

##One way to improve the look is with the gg_record() function from the camcorder package
#install.packages("camcorder")
library(camcorder)

camcorder::gg_record( 
  dir = "_dev/images",
  device = "png",
  width = 10,
  height = 10 * 3/4,
  #bg = "white",
  scale = 0.8
)

#Simple map with leaflet, showing ISPUP coordinates and logo
ispup_logo <- c("<img src=https://ispup.up.pt/wp-content/themes/ispup/images/logo-color.svg>")
ispup_coordinates <- tibble(lon = -8.616611357347235, lat=41.14440087224056, logo = ispup_logo)

leaflet(ispup_coordinates) %>% 
  addTiles() %>% 
  addPopups(lng= ~lon, lat=~lat, popup = ~logo)

#=====================================

#Plot Portuguese hospitals (with markers) on the map with leaflet
hospital_data <- jsonlite::fromJSON("https://transparencia.sns.gov.pt/api/explore/v2.1/catalog/datasets/atividade-de-internamento-hospitalar/records?limit=-1&refine=tempo%3A%222022%2F12%22") %>%
  pluck("results") %>% #R reads JSON objects as a list, and here we are extracting only the results
  unnest_wider(localizacao_geografica) #Because the column "localizacao_geografica" is a list, with nested lat and long  

leaflet(hospital_data) %>% 
  addTiles() %>% 
  addMarkers(lng = ~lon, lat = ~lat, popup = ~instituicao) 

#=====================================

#BONUS - Check it out!
#Creating buffers around each hospital, proportional to the number of treated patients
#By type (medical vs surgical), with user controled inputs
hospital_data <- jsonlite::fromJSON("https://transparencia.sns.gov.pt/api/explore/v2.1/catalog/datasets/atividade-de-internamento-hospitalar/records?limit=-1&refine=tempo%3A%222022%2F12%22") %>%
  pluck("results") %>% 
  unnest_wider(localizacao_geografica) %>% 
  pivot_wider(names_from = tipo_de_especialidade, values_from = c("doentes_saidos","dias_de_internamento"))

leaflet(hospital_data) %>% 
  addTiles() %>% 
  addMarkers(lng = ~lon, lat = ~lat, popup = ~instituicao) %>% 
  addCircles(~lon, ~lat, ~`doentes_saidos_Especialidade Médica`, stroke = F, group = "Doentes Saidos - Médica") %>% 
  addCircles(~lon, ~lat, ~`doentes_saidos_Especialidade Cirurgica`, stroke = F, group = "Doentes Saidos - Cirúrgica") %>% 
  addLayersControl(
    overlayGroups = c("Doentes Saidos - Médica", "Doentes Saidos - Cirúrgica"),
    options = layersControlOptions(collapsed = FALSE)
  )


#==================================

#install.packages (maps)
library(maps)

#Plot a world map
world <- map_data("world") 

##explore the dataset above. What is the difference between the variables region and group?
###Each group is one country, that may have several regions (e.g. island chains)
#world %>% distinct(region, group) %>% View

world %>% 
  ggplot() +
  geom_polygon(aes(x = long, y = lat, group = group), color = "white", linewidth = 0.1)  +
  theme(legend.position = "none") +
  theme_void() +
  coord_equal() # without this the proportions get distorted

#==================================
#Plot a world map with population data from gapminder from the most recent year
#HINT: Before joining the data, explore the datasets to check which variables match in each dataset
world_with_pop <- map_data("world") %>% 
  left_join(gapminder %>% 
              filter(year == max(year)),
            by = c("region" = "country"))

world_with_pop %>% 
  ggplot() +
  geom_polygon(aes(x = long, y = lat, group = group, fill = gdpPercap))  +
  theme(legend.position = "none") +
  coord_equal() # without this the proportions get distorted

#==================================


#1. Get population data from "pt_pop_nuts3.rds"
#2. Filter for the year 2022
#3. Get map data from eurostat
  #3A.Alternatively, if getting an error, use "pt_map_nuts3.rds"
#4. Filter for PT only, and exclude RAM and RAA
#5. Join population data to map data
  #HINT: the variable nuts_id from the map data is not exactly equal to "geo_cod" from population data!
  #       Some processing will be required.. What to you suggest?
#6. Plot with geom_sf()


nuts3_data <- 
  rio::import("https://github.com/c-matos/Intro-R4Heads/raw/main/materials/data/pt_pop_nuts3.rds") %>% 
  filter(year == 2022) %>% 
  mutate(nuts_id = glue::glue("PT{geo_cod}")) #Create a version of the code that is equal to the one on the map data

pt_map_nuts3 <- 
  get_eurostat_geospatial(
    resolution = 10, nuts_level = 3, year = 2021
    ) %>% #Get map data by NUTS 3
  clean_names() %>% #Clean names with janitor
  filter(
    cntr_code == "PT",
    !nuts_id %in% c("PT200","PT300")
    ) %>% #Keep only Portugal and exlcude RAM and RAA
  select(nuts_id, nuts_name, mount_type, urbn_type, coast_type, geometry) %>% 
  left_join(nuts3_data) #Join population data

pt_map_nuts3 %>% 
  ggplot() +
  geom_sf(aes(fill = pop), color = "white") +
  theme_void()






