#install.packages("janitor")
library(janitor)
cars <- read.csv("C:/Users/levie/OneDrive/Desktop/R programming Hub/R/datasets/Cars dataset.csv")

#...............Cleaning dirty data...................#

#install.packages("tidyverse")
library(tidyverse)
penguins_raw <- read_csv("https://raw.githubusercontent.com/allisonhorst/palmerpenguins/master/inst/extdata/penguins_raw.csv")

#Taking a glimpse at the dataset
glimpse(penguins_raw)

penguins_raw$`Delta 15 N (o/oo)`
penguins_raw$`Flipper Length (mm)`

#clean_names()` just magically turns all our messy column names into
#readable lower-case snake case:
penguins_clean <- clean_names(penguins_raw)
glimpse(penguins_clean)

#Removing constants
table(penguins_clean$region)
penguins_clean <- remove_constant(penguins_clean, quiet = F)#Quiet tells us what has been removed

#Another useful function in `janitor` is `remove_empty()` which removes
#all rows or columns that just consist of missing values (i.e. `NA`)
penguins_na <- remove_empty(penguins_clean,quiet = F)


#.............Data cleaning using tidyr.............#
table(penguins_clean$species)

#Species hold both the *common name* and the *latin name* of the penguin.
#Using separate()
penguins_clean <- separate(penguins_clean, species, sep = " \\(", into = c("species", "latin_name"))

#Removing the other )

library(stringr)
penguins_clean$latin_name <- str_remove(penguins_clean$latin_name, "\\)")
penguins_clean


#Use unite-works in the opposite way

#Using pivot_wider and pivot_longer

#Import your data
untidy_animals <- read_csv("https://github.com/favstats/ds3_r_intro/blob/main/data/untidy_animals.csv?raw=true")
untidy_animals

tidy_animals <- pivot_wider(untidy_animals,  names_from = Type, values_from = Value)
tidy_animals

#Untidy it again
pivot_longer(tidy_animals,  cols = c(lifespan, ratio))


#--------------------------Using dplyr-----------------------------#
#Select
select(penguins_clean, individual_id, sex, species)
#But its more than that
#We can also remove columns using it

select(penguins_clean, -individual_id, -sex, -species)

#Seletion helpers
#Match variables according to a particular pattern
#`starts_with()`: Starts with a prefix.

#`ends_with()`: Ends with a suffix.

#`contains()`: Contains a literal string.
select(penguins_clean, starts_with("s"))

#Selecting first 5 variables
select(penguins_clean, 1:5)
select(penguins_clean, individual_id:flipper_length_mm)

#Filter()
filter(penguins_clean, island == "Dream")

#What if you want to filter more than 1 island?
islands_to_keep <- c("Dream", "Biscoe")
filter(penguins_clean, island %in% islands_to_keep)

#Let's do come calculations
#Mutate
pg_new <- mutate(penguins_clean, bodymass_kg = body_mass_g/1000)
select(pg_new, bodymass_kg, body_mass_g)

#Using ifelse

ifelse(1 == 1, "Pick me if test is TRUE", "Pick me if test is FALSE")
ifelse(1 != 1, "Pick me if test is TRUE", "Pick me if test is FALSE")

#Using it with dplyr
pg_new <- mutate(penguins_clean, sex_short = ifelse(sex == "MALE", "m", "f"))
select(pg_new, sex, sex_short)

#Recording with case_when
x <- c(1:50)
x

case_when(
  x %in% 1:10 ~ "1 through 10",
  x %in% 11:30 ~ "11 through 30",
  TRUE ~ "above 30"
)

#Using it with mutate
test <- mutate(penguins_clean, 
               island_short = case_when(
                 island == "Torgersen" ~ "T",
                 island == "Biscoe" ~ "B",
                 island == "Dream" ~ "D"
               ))
select(test, island, island_short)
#With case_when you can even use different variables


#Rename
rename(penguins_clean, sample = sample_number)


### `arrange()`
#You can order your data to show the highest or lowest value first.
#Asceinding order
arrange(penguins_clean, flipper_length_mm)

#Descending order
arrange(penguins_clean, desc(flipper_length_mm))







