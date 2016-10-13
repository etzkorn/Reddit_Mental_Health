### Setup
      load(file="Data/June_Authors_Data.RData")
      rm(authors)
      library(dplyr)
      
### Define Functions
      get.date = function(day) as.POSIXct(day, origin = "1970-01-01", tz = "GMT")
      
### Reformat Data
      user.data = 
            rbind(transmute(user.comment.data, author, subreddit_id,  
                            date = get.date(created_utc), type="post",
                            post = link_id, text = body),
                  transmute(user.post.data, author, subreddit_id,  
                            date = get.date(created_utc), type="comment",
                            post = name, text = selftext)) %>%
            mutate(r.depression = subreddit_id=="t5_2qqqf") %>%
            group_by(author) %>%
            arrange(date) %>%
            mutate(time.last = c(NA, diff(date))) %>%
            ungroup()
      
      rm(user.comment.data, user.post.data, get.date)
      
### Classify Suicide Ideation
      source("Suicide_Classification_Algorithms/ideation_phrases.R")
      
      ### Get phrases
            key.phrases = clean.text(key.phrases)
            key.phrases = key.phrases[nchar(key.phrases) > 8]
            key_phrase_regex = paste(key.phrases, collapse="|")
            
      ### Classify text
            user.data$txt = clean.text(user.data$text)
            user.data$class = grepl(key_phrase_regex, user.data$txt, ignore.case = T)
            user.data$txt = NULL
      
      rm(list=setdiff(ls(), c("user.data")))
            
### Save New Data Frame
      save(user.data, file="Data/June_Authors_Data_Classified.RData")
      hist(user.data$time.last)
      