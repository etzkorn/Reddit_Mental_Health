pretest <- read.csv(file="Scrape_Reddits/pretest.csv", 
                    header=F, stringsAsFactors=F)

colnames(pretest) <- c("title", "subreddit", "author", "date", "link", "text")

pretest <- cbind(pretest, suicidal=0, suicidal.past=0, mental.disorder=0)

for(i in 1:nrow(pretest)){
      print(pretest[i,"text"])
      suicidal <- readline(prompt="Current Suicide Ideation (0,1):") 
      suicidal.past <- readline(prompt="Past Suicide Ideation (0,1):") 
      mental.disorder <- readline(prompt="Some Mental Disorder (0,1):") 
      pretest[i,7:9] <- c(suicidal, suicidal.past, mental.disorder)
}

write.csv(pretest, file="Scrape_Reddits/classified_pretest.csv")


