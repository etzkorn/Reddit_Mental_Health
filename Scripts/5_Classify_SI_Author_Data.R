load(file = "Data/June_Posts.RData")
source("Suicide_Classification_Algorithms/ideation_phrases.R")

### Get phrases
      key.phrases = clean.text(key.phrases)
      key.phrases = key.phrases[nchar(key.phrases) > 8]
      key_phrase_regex = paste(key.phrases, collapse="|")

### Classify text
      comm.data$txt = clean.text(comm.data$body)
      comm.data$class = grepl(key_phrase_regex, comm.data$txt, ignore.case = T)
      comm.data$txt = NULL
      
      post.data$txt = clean.text(paste(post.data$title, post.data$selftext))
      post.data$class = grepl(key_phrase_regex, post.data$txt, ignore.case = T)
      post.data$txt = NULL
      rm(list=setdiff(ls(), c("comm.data","post.data")))
      
save.image(file="Data/June_Posts_Classified.RData")
      
      