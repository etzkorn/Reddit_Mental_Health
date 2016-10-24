load(file = "Data/SI_Author_Sample/June_NoSI_Authors_Data.RData")
get.date = function(day) as.POSIXct(day, origin = "1970-01-01", tz = "GMT")
october10 = get.date("2016-10-10 16:00:00")

user.comment.data =
            transmute(user.comment.data, 
                      author, subreddit_id, date = get.date(created_utc), type="comment",
                      post = link_id, text = body, r.depression = subreddit_id=="t5_2qqqf") %>%
            filter(date < october10) %>%
            group_by(author) %>%
            arrange(date) %>%
            mutate(time.last = c(NA, diff(date))/60/60/24) %>%
            ungroup
            
user.post.data = 
            transmute(user.post.data,
                      author, subreddit_id, date = get.date(created_utc), type="post",
                      post = name, text = paste(title, selftext), r.depression = subreddit_id=="t5_2qqqf") %>%
            filter(date < october10) %>%
            group_by(author) %>%
            arrange(date) %>%
            mutate(time.last = c(NA, diff(date))/60/60/24) %>%
            ungroup

user.data = 
            rbind(user.post.data, user.comment.data)

### Get phrases
      source("Scripts/SI_Classification/ideation_phrases.R")
      key.phrases = clean.text(key.phrases)
      key.phrases = key.phrases[nchar(key.phrases) > 8]
      key_phrase_regex = paste(key.phrases, collapse="|")

### Classify text
      user.data$txt = clean.text(user.data$text)
      user.data$class = grepl(key_phrase_regex, user.data$txt, ignore.case = T)
      user.data$txt = NULL

      rm(list=setdiff(ls(), c("user.data","authors.noSI")))
      
save.image(file="Data/SI_Author_Sample/June_NoSI_Classified.RData")
      
      