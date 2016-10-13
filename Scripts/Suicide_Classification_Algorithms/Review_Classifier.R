load(file="Data/Training/Training_Lacey_Classified.RData")
load(file="Data/Training/Training_Lacey2_Classified.RData")
load(file="Data/Training/Training_Linda_Classified.RData")
load(file="Data/Training/Training_Linda_Classified2.RData")

### Merge Data
      df1 <- merge(lacey, linda, 
                   by=c("author", "created", "title", 
                        "link", "post.text", "file"),
                   all=T, suffixes = c(".la", ".li"))
      
      df2 <- merge(lacey2, linda2, 
                   by=c("author", "created", "title", 
                        "link", "post.text", "file"),
                   all=T, suffixes = c(".la", ".li"))
      
      df <- rbind(df1, df2)
      rm(df1, df2, lacey, linda, linda2, lacey2)
      
### Fix bugs
      df$suicidal.la[df$suicidal.la == ""] <- "0"
      df$suicidal.la[is.na(df$suicidal.la)] <- "na"
      df$suicidal.li[is.na(df$suicidal.li)] <- "na"
      df$suicidal = df$suicidal.li == "1" | df$suicidal.la == "1" 
      
### Review Classifiers
      source("Suicide_Classification_Algorithms/ideation_phrases.R")
      load(file="Data/June_Posts.RData")
      
      ### Get phrases
      key.phrases = clean.text(key.phrases)
      key.phrases = key.phrases[nchar(key.phrases) > 8]
      key_phrase_regex = paste(key.phrases, collapse="|")
      
      ### Classify text
      comm.data$txt = clean.text(comm.data$body)
      comm.data$class = grepl(key_phrase_regex, comm.data$txt, ignore.case = T)
      
      post.data$txt = clean.text(post.data$body)
      post.data$class = grepl(key_phrase_regex, post.data$txt, ignore.case = T)
      with(df, table(suicidal, class))
      
