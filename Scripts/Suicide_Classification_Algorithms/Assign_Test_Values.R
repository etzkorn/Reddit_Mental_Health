load(file="Data/Training_Lacey2.RData")

for(i in 1:nrow(lacey2)){
      writeLines(paste(lacey2[i,"title"],"\n",
          lacey2[i,"post.text"], "\n",
          lacey2[i,"suicidal"]))
      lacey2$suicidal[i] <- readline(prompt="Current Suicide Ideation (0,1):") 
}

save(lacey2, file="Data/Training_Lacey2_Classified.RData")

table(lacey2$suicidal)

