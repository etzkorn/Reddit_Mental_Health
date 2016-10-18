
### Load Data
      load(file="Data/SI_Author_Sample/June_Authors_Data_Classified.RData")
      colnames(user.data)
      library(dplyr)
      library(ggplot2)
      
### Summarize Data Frame
      get.date = function(day) as.POSIXct(day, origin = "1970-01-01", tz = "GMT")
      oct10 = get.date("2016-10-10 16:00:00")
      user.summary = 
            user.data %>%
            group_by(author) %>%
            summarise(n = n()-1,
                      eps = mean(time.last/60/60/24, na.rm=T),
                      recent = as.numeric(oct10 - max(date)))
      
### Save Data
      save(user.summary, file = "Data/SI_Author_Sample/Author_Summary.RData")
      
      
      ggplot(user.summary) +
            geom_histogram(aes(x=recent))
      ggplot(user.summary) +
            geom_histogram(aes(x=n))
      ggplot(user.summary) +
            geom_histogram(aes(x=eps))
      
      
      #filter(user.summary, recent > 135)
