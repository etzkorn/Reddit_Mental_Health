
### Create Dates
      get.date = function(day) as.POSIXct(day, origin = "1970-01-01", tz = "GMT")
      july1 = get.date("2016-07-01 00:00:00")
      june1 = get.date("2016-06-01 00:00:00")
      october10 = get.date("2016-10-10 16:00:00")
      october1 = get.date("2016-10-01 00:00:00")
      jan1 = get.date("2016-01-01 00:00:00")

### Get Data
      load(file="Data/SI_Author_Sample/June_SI_Classified.RData")
      si.user.data = user.data
      load(file="Data/SI_Author_Sample/June_NoSI_Classified.RData")
      user.data = rbind(cbind(si.user.data, si.author=T), cbind(user.data, si.author=F))
      rm(si.user.data)
      rm(get.date)
      
### Load Packages
      library(dplyr)
      library(ggplot2)
      options(width = 200)

### Get rid of extra people
      extras = with(user.data, 
                    intersect(unique(author[si.author]), unique(author[!si.author])))
      user.data = 
            filter(user.data, !(author %in% extras & !si.author))
      rm(extras)

### Get rid of extra variables
      user.data = select(user.data, author, date, type, r.depression, time.last, class,
                         si.author)

### Only take posts back to the first censor date of either posts or comments
      user.data =
            user.data %>%
            group_by(author, type) %>%
            mutate(oldest = min(date,na.rm=T),
                   n = n()) %>%
            ungroup() %>%
            group_by(author) %>%
            mutate(oldest = oldest[n == max(n)][1],
                   n = max(n)) %>%
            filter(n < 975 | date >= oldest) %>%
            ungroup
      
### Summarize Author Data
      author.summary =
            user.data %>%
            group_by(author, type) %>%
            summarise(oldest = min(date),
                      newest = max(date),
                      si.author = any(si.author),
                      n.post = n()) %>%
            ungroup
      
save.image(file="Data/SI_Author_Sample/June_Authors_Combined.RData")
