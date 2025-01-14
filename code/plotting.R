2+2

# my comments
## instructor comments

library(tidyverse)
#help >- home button -> postit chestsheets

sample_data <- read_csv("sample_data.csv")
#read_csv is tidyverses way of reading csv files read.csv is base R's way of reading csv files
#read_csv command is working with tibbles
#highlight sample_data and press run then it produces the data in the tibble
#assignment operator can be = or <- 

## assign values to objects
name <- "agar"
name

year <- 1881
year

name <- "Fanny Hesse"
name

## bad name for object
1number <- 3
# can't start variable with number
number1 <- 3

Flower <- "marigold"
Flower
flower <- "rose"
flower
# names are case sensitive

sample_data <- read_csv("sample_data.csv")

read_csv()  # produces error, must provide with file name 

read_csv(file = 'sample_data.csv') # "fie =" is the argument in the command 


## let's comment 
Sys.Date() # output the current date

getwd() # output current working directory

sum(5,6) # add numbers

# highlight and command enter to not get comments in console

sample_data <- read_csv("sample_data.csv") # reads in csv file

#creating first plot
ggplot(data = sample_data) + 
  aes(x = temperature) +
  labs(x = "Temperature (C)") +
  aes(y = cells_per_ml/1000000) +
  labs(y = "Cells (millions/mL)") +
  geom_point() + # add data points
  labs(title = "Does temperature affect microbial abundance?")  +  # add title
  aes(color = env_group) + # color samples based on env_group
  aes(size = chlorophyll) + # add another layer of aesthetic
  labs(size = "Chlorophyll (ug/L)",
       color = "Environmental Group")
 
# change shape of enviormental group
ggplot(data = sample_data) + 
  aes(x = temperature) +
  labs(x = "Temperature (C)") +
  aes(y = cells_per_ml/1000000) +
  labs(y = "Cells (millions/mL)") +
  geom_point() + # add data points
  labs(title = "Does temperature affect microbial abundance?")  +  # add title
  aes(color = env_group) + # color samples based on env_group
  aes(size = chlorophyll) + # add another layer of aesthetic
  aes(shape = env_group) +
  labs(size = "Chlorophyll (ug/L)",
       color = "Environmental Group",
       shape = "Environmental Group")

## combined "neater" code
ggplot(data = sample_data) +
  aes(x = temperature,
      y = cells_per_ml/1000000, 
      color = env_group,
      size = chlorophyll) +
  geom_point() +
  labs(x = "Temperature (C)",
       y = "Cells (millions/mL)",
       title = "Does temperature affect microbial abundance?",
       size = "Chlorophyll (ug/L)",
       color = "Environmental Group")

# aes means aesthetics, elements of plot 
  # when using actual text values we put them in "" and that overrides the column names from the data


## importing datasets
buoy_data <- read_csv("buoy_data.csv")
View(buoy_data) # opens data table

dim(buoy_data) # gives snapshot of data

head(buoy_data) ## see beginning of data
tail(buoy_data) ## shows last couple enteris, see end of data

## plot some more 
ggplot(data = buoy_data) +
  aes(x = day_of_year,
      y = temperature,
      color = depth) +
  geom_point()

##structure of our data object
str(buoy_data)

#change geompoint to geomline
ggplot(data = buoy_data) +
  aes(x = day_of_year,
      y = temperature,
      color = depth) +
  geom_line() # line for each depth

# add sensors for buoys
ggplot(data = buoy_data) +
  aes(x = day_of_year,
      y = temperature,
      group = sensor,
      color = depth) +
  geom_line() # line for each depth

# figure out which buoy this info is coming from 
ggplot(data = buoy_data) +
  aes(x = day_of_year,
      y = temperature,
      group = sensor,
      color = buoy) + #different buoys come up with different colors
  geom_line() # line for each depth

# introduce facet wrap
ggplot(data = buoy_data) +
  aes(x = day_of_year,
      y = temperature,
      group = sensor,
      color = depth) + #color difference in depth
  geom_line() + # line for each depth
  facet_wrap(~buoy) # for different buoys we can see differences in surface and bottom temperatures 

# introduce facet grid
ggplot(data = buoy_data) +
  aes(x = day_of_year,
      y = temperature,
      group = sensor, #grouping it by the sensors at different stations
      color = depth) + #color difference in depth
  geom_line() + # line for each depth
  facet_grid(rows = vars(buoy))
    # vars references column "buoy"

# must use ~ with facet wrap and vars with facet grid
 
##discrete plots
##box plot
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot()

##violin
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_violin()

##box plot for this exercise
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot() +
  geom_point()

##spread points to see them better
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot() +
  geom_jitter() #no points over laid on each other

#box plot comes first and then geom point/jitter to see points on top of box plots

##size 
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot() +
  geom_jitter(aes(size = chlorophyll))

##color 
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(color = "pink")

##fill 
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(fill = "pink")

# to create pallete in console:
#sample(colors(), size = 10)

##fill different colors for env group
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(aes(fill = env_group))

##manually enter colors
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(aes(fill = env_group)) +
  scale_fill_manual(values = c("pink", "tomato", "papayawhip"))

##scale fill brewer
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(aes(fill = env_group)) +
  scale_fill_brewer(palette = "Set1")

# in console RColorBrewer::display.brewer.all() to view built in color palettes

##custom palette time
  #need to download from internet
install.packages("wesanderson")
library(wesanderson)
names(wes_palettes)
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(aes(fill = env_group)) +
  scale_fill_manual(values = wes_palette(('Cavalcanti1')))

#National parks palettes 
install.packages("NatParksPalettes")
library(NatParksPalettes)
names(NatParksPalettes)

ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(aes(fill = env_group)) +
  scale_fill_manual(values = natparks.pals("Volcanoes")) +
  geom_point()

##box plot
## change transparency
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(fill = "darkblue", alpha = 0.3) + #alpha defaut is 1
  scale_fill_manual(values = c("pink", "tomato", "papayawhip"))

# geom_boxplot(aes(fill = "darkblue", alpha = 0.3)) -> doesn't work

#function to remove outliers
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(fill = "darkblue", 
               outliers = FALSE,
               alpha = 0.3) + #alpha defaut is 1
  scale_fill_manual(values = c("pink", "tomato", "papayawhip"))


## univariate plots
#histogram
ggplot(sample_data) +
  aes(x = cells_per_ml) +
  geom_histogram(bins = 10)

#density
ggplot(sample_data) +
  aes(x = cells_per_ml) +
  geom_density(aes(fill = env_group), alpha = 0.5)


#change background from gray to osmething else
ggplot(sample_data) +
  aes(x = cells_per_ml) +
  geom_density(aes(fill = env_group), alpha = 0.5) +
  theme_bw()

##box plot
## rotate the x-axis labels
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

## saving plots
#can use export tab plots window or use following line of code
ggsave("awesome_plot.jpg", width = 6, height = 4)

#to adjust resolution 
ggsave("awesome_plot.jpg", width = 6, height = 4, dpi = 300)

#temp save under specific variable 
box_plot <- 
  ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
box_plot
## saving plots
ggsave("awesome_plot.jpg", width = 6, height = 4, dpi = 300)

## add changes to the plot for black and white 
box_plot + theme_bw()

box_plot <- box_plot + theme_bw()
box_plot

ggsave("awesome_box_plot_example.jpg", plot = box_plot, width = 6, height = 4)


