### Setup
      load(file="Data/June_NoSI_Authors_Data.RData")
      library(dplyr)
      
### Define Functions
      get.date = function(day) as.POSIXct(day, origin = "1970-01-01", tz = "GMT")
      
### Reformat Data
      comm.data =
            transmute(comm.data, author, created_utc, date = get.date(created_utc), 
                      thread_id = link_id, text = body)
      post.data = 
            transmute(post.data, author, created_utc, date = get.date(created_utc),
                      thread_id = name, text = paste(title, selftext))
      user.data = 
            rbind(comm.data, post.data)
      
      rm(comm.data, post.data, get.date)
      
### Classify Suicide Ideation
      source("Scripts/2.2_SI_Classification/ideation_phrases.R")
      
      ### Get phrases
            key.phrases = clean.text(key.phrases)
            key.phrases = key.phrases[nchar(key.phrases) > 8]
            key_phrase_regex = paste(key.phrases, collapse="|")
            
      ### Classify text
            user.data$txt = clean.text(user.data$text)
            user.data$si = grepl(key_phrase_regex, user.data$txt, ignore.case = T)
            user.data$txt = NULL
      
      rm(list=setdiff(ls(), c("user.data")))
            
### Save New Data Frame
      save(user.data, file="Data/June_Depression_Sample/June_Posts_Classified.RData")
