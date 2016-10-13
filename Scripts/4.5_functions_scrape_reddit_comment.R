
library(httr)
library(dplyr)

### takes a list and replaces NULL values with NA values
      replace_null <- function(a.list){
            null.values <- unlist(lapply(a.list, is.null))
            a.list[null.values] <- NA
            return(a.list)
      }

### grabs data for a user
      get_reddit_user <- function(username, type = "submitted", after=NA){
          root_url = "https://api.reddit.com/user/"
          url = paste0(root_url, username, "/", type)
          if(!is.na(after)) url = paste0(url, "?after=", after)
          agent2 = user_agent("blah")
          reddit = GET(url, agent2)
          stop_for_status(reddit)
          cr = content(reddit)
          return(cr)
      }

### grabs comments from user data
      comm.vars =
            c("author", "created_utc", "likes", "score", "ups", "downs", 
              "subreddit_id", "link_id", "id", "name", "parent_id",        
              "body") 
      post.vars = 
            c("author", "title", "created_utc", "name", "id", "subreddit_id",
              "downs",  "ups", "upvote_ratio", "likes", "score", "num_comments",    
              "permalink",  "url", "selftext")
      
      user_data_frame <- function(user, type="submitted", after = NA, n=0){
            if(n==1000) return(NULL)
            if(type == "submitted"){
                  vars = post.vars
            } else if(type=="comments"){
                  vars = comm.vars
            }
            data.list = get_reddit_user(user, type, after)$data$children
            data = 
                  lapply(data.list, 
                         function(x) {
                               x$data[vars] %>%
                               replace_null() %>%
                               as.data.frame(stringsAsFactors=F)
                         }) %>%
                  do.call(what="rbind")
            if(is.null(data)) return(NULL)
            if(nrow(data) == 25){
                  cat(n, ", ")
                  next.data = 
                        user_data_frame(user, type, after =  data$name[25], n = n+25)
                  data = rbind(data, next.data)
            }
            return(data)
      }
