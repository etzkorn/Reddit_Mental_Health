load(file="Data/June_Depression_Sample/June_Posts_Classified.RData")
require(dplyr)

### Sample 100 of each SI-positive and SI-negative
      si.positive.sample = 
            filter(user.data, si) %>%
            sample_n(100)
      
      si.negative.sample =
            filter(user.data, !si) %>%
            sample_n(100)
      
      test.sample = rbind(si.negative.sample, si.positive.sample)

rm(user.data, si.positive.sample, si.negative.sample)

for(i in 1:nrow(test.sample)){
      cat(test.sample[i,"text"], "\n")
      test.sample$suicidal[i] <- readline(prompt="Current Suicide Ideation (0,1):") 
      test.sample$phrase[i] <- readline(prompt="SI evidence:") 
}

test.sample$suicidal[!test.sample$phrase ==""] <- 1
test.sample$suicidal[test.sample$suicidal ==""] <- 0
test.sample$suicidal[!test.sample$suicidal %in% c("0","1")] <- test.sample$phrase[!test.sample$suicidal %in% c("0","1")] 

save(test.sample, file="Data/Test/Test_Classified.Rdata")
