library(tidyverse)
library(janitor)
library(readxl)
library(writexl)

#to run new scrape(s) from the live Biden site currently:
source("01_scrape_agencyteams.R")
source("02_scrape_nominees.R")



#### WHITE HOUSE SENIOR STAFF ##### --------------------------------------------------------

#Assignment Part 1:

#Write your code here that will compare the current white house staff names on the site to the
#archived rds file storied in the archived_data folder to determine which names are new.

# https://buildbackbetter.gov/the-administration/white-house-senior-staff/

#You can use the filled-in version for the agency teams below to help model yours after if it's helpful,
#since the steps should be much the same.


#Your code here#

staff_data_current <- readRDS("processed_data/staff_data_scraped.rds")
staff_data_current

staff_data_previous <- readRDS("archived_data/staff_data_archived_2020_11_24t14_00.rds")
staff_data_previous

#find new records of names added since previous
newnames <- anti_join(transition_data_scraped, transition_data_archived_2020_11_24t09_52, by = "idstring")

#see what we have
newnames

#11 new 


# Compare TOTALS by department #######

title_count_current <- staff_data_scraped %>%
  count(title, name="current_count")

title_count_previous <- staff_data_archived_2020_11_24t14_00 %>%
  count(title, name="previouscount")



#join

title_count_compare <- left_join(title_count_current, title_count_previous, by = "title")




#names of new agency review team members
saveRDS(newnames, "processed_data/newnames.rds")
#aggregate county of agency totals compared
saveRDS(agencycount_compare, "processed_data/agencycount_compare.rds")
#entire combined agency teams file
saveRDS(agencyteams, "processed_data/agencyteams.rds")



#### AGENCY TEAMS ##### --------------------------------------------------------


### COMPARE agency team members with previous archived version ######

#load current data
transition_data_current <- readRDS("processed_data/transition_data_scraped.rds")
transition_data_current

# load archived data to compare against
transition_data_previous <- readRDS("archived_data/transition_data_archived_2020_11_24t09_52.rds")
# transition_data_previous <- readRDS("archived_data/transition_data_archived_2020_11_25t09_34.rds")
transition_data_previous

#find new records of names added since previous
newnames <- anti_join(transition_data_current, transition_data_previous, by = "idstring")

#see what we have
newnames


# Compare TOTALS by department #######
agencycount_current <- transition_data_current %>% 
  count(agency, name = "current_count")

agencycount_current

agencycount_previous <- transition_data_previous %>% 
  count(agency, name = "previous_count")

agencycount_previous

#join
agencycount_compare <- left_join(agencycount_current, agencycount_previous, by = "agency")
agencycount_compare

#add change columns
agencycount_compare <- agencycount_compare %>% 
  mutate(
    change = current_count - previous_count
  )


#we'll create a NEW NAMED OBJECT to use from here on out for the full dataset
agencyteams <- transition_data_current


### SAVE results #### 

#names of new agency review team members
saveRDS(newnames, "processed_data/newnames.rds")
#aggregate county of agency totals compared
saveRDS(agencycount_compare, "processed_data/agencycount_compare.rds")
#entire combined agency teams file
saveRDS(agencyteams, "processed_data/agencyteams.rds")

