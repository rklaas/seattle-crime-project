#Generating the school data from API requests
library(httr)
library(jsonlite)
library(dplyr)
library(tidyr)

my.app.id <- #App ID
my.app.key <- #App key

#Bring in a dataframe of all Seattle schools
df.public.schools <- read.csv("public_schools.csv", stringsAsFactors = FALSE) %>% 
  filter(NAME != "")

df.public.schools$Shape <- substr(df.public.schools$Shape, 2, nchar(df.public.schools$Shape) -1) #Remove parens

#Create a vector of stringsplits for extracting lat/long
coords_list <- strsplit(df.public.schools$Shape,', ')

#Create lat/long columns
df.public.schools$Latitude <- as.numeric(unlist(coords_list)[2*(1:length(df.public.schools$Shape))-1])
df.public.schools$Longitude <- as.numeric(unlist(coords_list)[2*(1:length(df.public.schools$Shape))])

#Set PHONE column name to undercase phone, for use as reference column in joins
colnames(df.public.schools)[9] <- "phone"

#Create a column of modified school names for use with the API calls
school.call.names <- sub(" K-8", "", df.public.schools$NAME) %>% 
  sub(" Int'l", "", .) %>% #Remove terms that mess up search results
  sub(" STEM", "", .) %>% 
  sub(" (interim at John Marshall)", "", ., fixed="TRUE") %>% #Remove these clarifiers that obstruct results
  sub(" (interim at Lincoln)", "", ., fixed="TRUE") %>% 
  sub(" (interim at Cedar Park)", "", ., fixed="TRUE") %>% 
  gsub(" ", "+", .) #Replace spaces with '+'s for the API call

df.public.schools <- df.public.schools %>% 
  mutate(school.search.name = school.call.names)

#Initiate the merger of two dataframes by joining the first row

#Call the API for first school's info
school.info <- GET(paste0("https://api.schooldigger.com/v1/schools?st=WA&q=", df.public.schools$school.search.name[1], "&city=Seattle&appID=", my.app.id, "&appKey=", my.app.key))

#Convert that returned data into an R-readable dataframe
school.info.body <- school.info %>% 
  content("text") %>% #Get the content (in "text" format)
  fromJSON() %>% 
  .$schoolList

#Join that data into the dataframe to generate the column names needed
df.public.schools <- left_join(df.public.schools, school.info.body, by = "phone")

#We can only access 10 at a time with the schoolDigger API so we'll have to use for loops to fill out this dataframe (Sorry Joel)

#Make calls for 1:10, 11:20, 21:30, 31:40, 41:50, 51:60, 61:70, 71:80, 81:90, 91:97
for(val in c(5:10)){
  #Make a request for the given school row (val)
  school.info <- GET(paste0("https://api.schooldigger.com/v1/schools?st=WA&q=", df.public.schools$school.search.name[val], "&city=Seattle&appID=", my.app.id, "&appKey=", my.app.key))
  
  #Convert that returned data into an R-readable dataframe
  school.info.body <- school.info %>% 
    content("text") %>% #Get the content (in "text" format)
    fromJSON() %>% 
    .$schoolList
  
  #Merge in data row by row
  if(length(school.info.body) > 0){ #If the school is listed in the schooldigger database
    df.public.schools[val, 15:40] <- school.info.body[1,-3] #[,-3] excludes the phone numbers merged in the left_join, [1,] takes only the first school in the case of two matches in the database
  }
}

df.public.schools <- df.public.schools[, c(-19, -28, -29)] %>% #Remove the address, district, and county columns that throw errors
  filter(!is.na(schoolid)) #Filter out all schools without schooldigger results

#Unnest all racial demographics into a separate dataframe 
df.public.schools.observations <- df.public.schools %>%
  filter(!is.na(schoolid))
df.public.schools.observations <- unnest(df.public.schools.observations, schoolYearlyDetails)[,-27] #No need for these lists, will get unnested and joined in next statement

#Unnest all school ranking demographics, then filter by year (to get only the 2016 rankings)
df.public.schools.ranked <- filter(df.public.schools, rankHistory != "NA") #Filter for schools with rankings
df.public.schools.ranked <- unnest(df.public.schools.ranked, rankHistory) %>% 
  filter(year == "2016") %>%  
  .[, c(15, 40:42)] #Select only the ranking observations

df.public.schools.full <- left_join(df.public.schools.observations, df.public.schools.ranked, by = "schoolid") #Merge rank observations into table with expanded race observations

write.csv(df.public.schools.full, file = "public_school_data_full.csv")
