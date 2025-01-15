# Loading packages

library(tidyverse)

# Reading in data 

sample_data <- read_csv("data/sample_data.csv")

## summarize takes a dataframe or tibble and returns tibble
## allows us to take values from multiple rows and combine them into one value
summarize(sample_data, average_cells = mean(cells_per_ml))

## command+shift+M = pipe operator
## pipe operator takes whats on left and pipes to right


## pipe means its the same command
sample_data %>% 
  summarize(average_cells = mean(cells_per_ml)) ##took our dataframe and squished it through the pipe to the first function on the right 

# Filtering rows
## We are only interested in Deep so we will filter out rows that only match Deep conditions and then we summarize the data again to get average_cells for Deep condition
##filters first argument is dataframe

sample_data %>% 
  filter(env_group == "Deep") %>% 
  summarize(average_cells = mean(cells_per_ml))

## in tidyverse if we are referencing a column in the dataframe then it does not need to be in quotation marks but a value in a column in the dataframe like "Deep" needs to be in ""
## == is a logical operator and means is equal to and it is to differentiate from arguement

## depth is greater than 50
sample_data %>% 
  filter(depth > 50) %>% 
  summarize(average_cells = mean(cells_per_ml))

## depth is less than 50
sample_data %>% 
  filter(depth < 50) %>% 
  summarize(average_cells = mean(cells_per_ml))

## filter deep and shallow_map conditions
sample_data %>% 
  filter(env_group %in% c("Deep", "Shallow_May")) 

## match anythign that starts with shallow
sample_data %>% 
  filter(str_detect(env_group, "Shallow*")) %>% 
  summarize(average_cells = mean(cells_per_ml))

# Calculate the average chlorophyll in the entire dataset

summarize(sample_data, average_cells = mean(chlorophyll))

## Gus's code
sample_data %>% 
  summarise(avg_chl = mean(chlorophyll))

# Calculate the average chlorophyll just in Shallow September

sample_data %>% 
  filter(env_group == "Shallow_September") %>% 
  summarize(average_cells = mean(chlorophyll))

## Gus's code
sample_data %>%
  filter(env_group == "Shallow_September") %>%
  summarise(avg_chl = mean(chlorophyll))


# if we want to filter for September
sample_data %>% 
  filter(str_detect(env_group, "September")) %>% 
  summarize(average_cells = mean(chlorophyll))

## want to know average chlorophyll in all conditions
# group_by

sample_data %>% 
  group_by(env_group) %>% 
  summarise(average_cells = mean(cells_per_ml),
            min_cells = min(cells_per_ml))

## with summarize we can make multiple columns at once or group by multiple columns at once

# Calculate the average temp per env_group
sample_data %>% 
  group_by(env_group) %>% 
  summarise(average_temp = mean(temperature))

## how do we make new columns in the dataframe

# Mutate - makes a new column in a dataframe
# TN:TP ratio for each observation

sample_data %>% 
  mutate(tn_tp_ratio = total_nitrogen / total_phosphorus) %>%  view() #view() opens tibble in new window
## new column is still not in original sample_data
## if I must use a colon in a name use back tick:
  ##mutate('TN:TP' = total_nitrogen / total_phosphorus)

## what if we want to group by multiple columns
sample_data %>% 
  mutate(temp_is_hot = temperature > 8) %>% ## this created a logical column which can only have two values like true or false
  group_by(env_group, temp_is_hot) %>% 
  summarise(avg_temp = mean(temperature),
            avg_cells = mean(cells_per_ml))

# selecting columns with select

sample_data %>% 
  select(sample_id, depth)

## we can also use select to get rid of columns

sample_data %>% 
  select(-env_group)

## colon is a way for us to select a range of values 

sample_data %>% 
  select(sample_id:temperature) ## has selected sample_id to temperature


## starts_with helper function in select

sample_data %>% 
  select(starts_with("total")) # has selected columns that started with "total"

# Create a dataframe with only sample_id, env_group, depth, temperature, and cells_per_ml
sample_data %>% 
  select(sample_id:temperature)

## Another way
sample_data %>% 
  select(sample_id, env_group, depth, temperature, cells_per_ml)

## Another way
sample_data %>% 
  select(-total_nitrogen, -total_phosphorus, -diss_org_carbon, -chlorophyll)

## Another way
sample_data %>% 
  select(1:5)

## Another way
sample_data %>% 
  select(-(total_nitrogen:chlorophyll))

## Another way
sample_data %>% 
  select(-(6:9))

# CLEANING DATA

read_csv("data/taxon_abundance.csv", skip = 2) %>% ## skip = 2 means skip the frist 2 lines of this dataframe
  select(-...10) %>% 
  rename(sequencer = ...9) %>% view()

## "...#" is how read_csv assigns a name to a untitled column in dataframe
## dbl or double columns are numerical columns

# Also remove the lot number and sequencer columns

read_csv("data/taxon_abundance.csv", skip = 2) %>% ## skip = 2 means skip the first 2 lines of this dataframe
  select(-...10) %>% 
  rename(sequencer = ...9) %>% 
  select(-(Lot_Number:sequencer)) %>%  view()

# Assign this all to an object called "taxon_clean"

taxon_clean <- read_csv("data/taxon_abundance.csv", skip = 2) %>% ## skip = 2 means skip the frist 2 lines of this dataframe
  select(-...10) %>% 
  rename(sequencer = ...9) %>% 
  select(-(Lot_Number:sequencer)) %>%  view()

## change wide data to long data

taxon_long <- taxon_clean %>% 
  pivot_longer(cols = Proteobacteria:Cyanobacteria, 
               names_to = "Phylum", ## take columns cols = Proteobacteria:Cyanobacteria and make new column with them named Phylum
               values_to = "Abundance")

##different functions in tidyverse require either wide or long format data


taxon_long %>% 
  group_by(Phylum) %>% 
  summarise(avg_abund = mean(Abundance)) ## calculated the average relative abundance for each phylum 

## ggplot needs long format data

## stacked bar plot

taxon_long %>% ##take this dataframe and pipe to ggplot
  ggplot() + #adding layers within ggplot. NO more PIPING!!
  aes(x = sample_id, 
      y = Abundance, 
      fill = Phylum) +
  geom_col() +
  theme(axis.text.x = element_text(angle = 90))

# making long data wide

taxon_long %>% 
  pivot_wider(names_from = "Phylum",
              values_from = "Abundance")

# JOINING DATA FRAMES

## we want to take two dataframes that have same key values and join them
head(sample_data)

head(taxon_clean)

## join works by each row in each data frame and glue them by corresponding sample_id

## inner join will look for keys that are present in both tables and take those and put them inour new joined table (drop key values that are not present in both tables)

## full join (don't drop any columns) kept all key values and fill in NA where key values don't have any observations

## directional joins (left or right) keep all IDs in either table and don't care about the IDs in the other table 

## Anti join only keeping key pairs that aren't present niether table, in R it is directional so if C is only in table 1 we will keep C and get rid of everything that is also in Table 2

inner_join(sample_data, taxon_clean)

## by default R will look for column names that match in different tables when joining but it is best to define which column to join by

inner_join(sample_data, taxon_clean, by = "sample_id")

anti_join(sample_data, taxon_clean, by = "sample_id")

sample_data$sample_id

taxon_clean$sample_id

## $ -> select a specific column from this data frame

taxon_clean_goodSep <- taxon_clean %>% 
  mutate(sample_id = str_replace(sample_id, pattern = "Sep", replacement = "September"))

## str_replace() detect a word in a column and replace it 

inner_join(sample_data, taxon_clean_goodSep, by = "sample_id")

sample_and_taxon <- inner_join(sample_data, taxon_clean_goodSep, by = "sample_id")

write_csv(sample_and_taxon, file = "data/sample_and_taxon.csv")

# Make a plot
# Ask: Where dies Chloroflexi like to live?

install.packages("ggpubr")
library(ggpubr)

sample_and_taxon %>% 
  ggplot() +
  aes(x = depth,
      y = Chloroflexi) +
  geom_point() + ## geom_point tells you where each indivudal observation sits
  labs(x = "Depth (m)",
       y = "Chloroflexi relative abundance") +
  geom_smooth(method = "lm") +
  #stat_regline_equation() +
  stat_cor() +
  annotate(geom = "text",
           x = 25, y = .3,
           label = "This is a text label")

##annotate(geom = "text",
## x = 25, y = .3,
## label = "This is a text label") - THIS allows you to put any text on the plot anywhere

# What is the average abundance and standard deviation of Chloroflexi in our three env_groups

sample_and_taxon %>% 
  group_by(env_group) %>% 
  summarise(avg_chloro = mean(Chloroflexi),
            sd_chloro = sd(Chloroflexi))

