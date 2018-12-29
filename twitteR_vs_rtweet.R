
# Git version of script with API keys removed

# Found the guide below usful:
# Access Data from Twitter API using R and Python
# https://towardsdatascience.com/access-data-from-twitter-api-using-r-and-or-python-b8ac342d3efe

library(twitteR)
library(rtweet)    # Use rtweet over twitteR
library(tidyverse)
library(skimr)

# twitteR test ===============================================

# access_secret based on your own keys
consumer_key <- "xxx"
consumer_secret <-"xxx"
access_token <- "xxx"
access_secret <- "xxx"

# Coonect to Twitter API
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

# Search Twitter
tw = searchTwitter(searchString = 'flu OR noro OR norovirus OR virus OR sick OR cold OR vomit',
                   since = '2016-08-01',
                   geocode = '51.895357,-3.682637,40mi',
                   n = 10000)

d = twListToDF(tw)

# rtweet test ================================================

# It appears that rtweet is preferable to twitteR

# Access token method: create token and save it as an environment variable
create_token(
  app = "xxx",
  consumer_key = "xxx",
  consumer_secret = "xxx",
  access_token = "xxx",
  access_secret = "xxx")

# To search for only tweets in Wales need to connect to Google Maps API,
# https://rtweet.info/reference/lookup_coords.html
# Google maps api - xxx
wales_lk <- lookup_coords(address = 'wales',
                          apikey = 'xxx')

rt = search_tweets(q = 'flu OR noro OR norovirus OR virus OR sick OR diarrhea OR vomit OR sickness',
                   n = 10000,
                   geocode = wales_lk)

# Categorise tweet by content
# TODO If more than one value appears i.e 'cold' and 'flu' add both values to cat column.
# Currently case_when will stop at 'flu'if both 'flu' and 'cold' appear
tweet_data <- rt %>%
  mutate(text = tolower(text)) %>% 
  mutate(cat = case_when(
    str_detect(text,'flu') ~ 'Flu',
    str_detect(text,'cold') ~ 'Cold',
    str_detect(text,'noro|virus') ~ 'Noro',
    str_detect(text,'diarrhea|sick|vomit') ~ 'D&V'
  )
  )

# List of features that contain location
# Note: user based column, not location of where tweeted from
loc_cols <-
  c('retweet_location',
    'place_url',
    'place_name',
    'place_full_name',
    'place_type',
    'country',
    'country_code',
    'geo_coords',
    'coords_coords',
    'bbox_coords',
    'location')

# Check for completness / missing values
tweet_data %>% 
  select(loc_cols) %>% 
  skim()

#Review unique values of each feature
tweet_data %>% 
  select(!!loc_cols) %>% 
  lapply(unique) 
