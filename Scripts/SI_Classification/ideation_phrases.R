
library(dplyr)

### Clean text
clean.text <-function(x){
      x = gsub(" |\t|\n", "", x)
      x = gsub("[[:punct:]]", "", x)
      a = paste(word.list$accessories, collapse="|")
      x = gsub(a, "", x)
      return(tolower(x))
}

### Read in the suicide lexicon
words <- readLines("Scripts/2.2_SI_Classification/Suicide_Syntax.txt")
words <- gsub("\t","",words)
word.list <- list()
category <- ""

for(i in words){
      if(grepl("\\[", i)){
            category <- sub("\\[","",i)
            category <- sub("\\]:","",category)
            category <- sub(" ","_",category)
            word.list[category] <- ""
      } else word.list[[category]] <- append(word.list[[category]], i)
}

word.list <- lapply(word.list, function(x) x[-1])

### Generate Suicidal Phrases
make.phrases <- function(x, i){
      sub(" \'", "\'", 
      paste(i, 
      expand.grid(word.list[x]) %>% 
      apply(1, paste, collapse=" "))) 
}

### Direct admission of suicide ideation
      # [iam] [intentioning verb] [suicide verb]
      i.am.intentioningverb.suicideverb <- make.phrases(c("iam", "intentioning_verb", "suicide_verb"), i="")

      #[I am] [thinking verb] [suicide noun]
      i.am.thinkingverb.suicidenoun <- make.phrases(c("iam", "thinking_verb","suicide_noun"), i="")
      
      #I [intention verb] [suicide verb]
      i.intentionverb.suicideverb <- make.phrases(c("intention_verb", "suicide_verb"), i="i")
      
      #I [possess] [think noun] [suicide noun]
      i.possess.thinknoun.suicidenoun <- make.phrases(c("possess", "think_noun", "suicide_noun"), i="i")
      
      #I [think verb] [suicide noun]
      i.thinkverb.suicidenoun <- make.phrases(c("think_verb", "suicide_noun"), i="i")
      
      #If I [suicide verb]
      i.suicideverb <- make.phrases(c("suicide_verb"), i="i")
      
      #[iam] [suicide adj]
      iam.suicideadjective <- make.phrases(c("iam", "suicide_adj"), i="")
      
      # me to [suicide verb]
      me.suicideverb <- make.phrases(c("me", "suicide_verb"), i="")

### Lack desire to live
      #I [oppose verb] [live verb]
      i.opposeverb.liveverb <- make.phrases(c("oppose_verb", "live_verb"), i="i")
      
      #[iam] [oppose_being verb] [live verb]
      i.am.opposebeingverb.liveverb <- make.phrases(c("iam", "oppose_being_verb", "live_verb"), i="")
      
      #[iam] [oppose_being][live noun] 
      i.am.opposebeing.live <- make.phrases(c("iam", "oppose_being", "live_noun"), i="")
      
###Question
      #Why not [suicide verb]
      why.not.suicideverb <- make.phrases(c("suicide_verb"), i="why not")


### Make the suicide lexicon
key.phrases = 
      c(i.am.intentioningverb.suicideverb,
        i.am.thinkingverb.suicidenoun,
        i.intentionverb.suicideverb,
        i.possess.thinknoun.suicidenoun,
        i.opposeverb.liveverb,
        i.am.opposebeingverb.liveverb,
        i.am.opposebeing.live,
        i.suicideverb,
        iam.suicideadjective,
        why.not.suicideverb,
        me.suicideverb,
        i.thinkverb.suicidenoun)


