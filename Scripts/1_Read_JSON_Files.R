library(dplyr)

### variable names
comm.vars =
      c("author", "created_utc", "likes", "score", "ups", "downs", 
        "subreddit_id", "link_id", "id", "name", "parent_id",        
        "body") 
post.vars = 
      c("author", "title", "created_utc", "name", "id", "subreddit_id",
        "downs",  "ups", "upvote_ratio", "likes", "score", "num_comments",    
        "permalink",  "url", "selftext")

### recursive get comments function
      get_children = function(parent){
            if("" %in% parent$data$replies)   return(NULL)
            parent$data$replies$data$children
      }
      get_reply_list <- function(parent.list){
            if(is.null(parent.list)) return(NULL)
            child.list = 
                  lapply(parent.list, get_children) %>% 
                  unlist(recursive=F) %>%
                  get_reply_list()
            c(child.list, parent.list)
      }
      get_comments <- function(file.json){
            comments = list(file.json$data$children[[2]])
            replies = 
                  get_reply_list(comments) %>%
                  lapply(function(x){
                              if(length(x$data) < 10) NULL else x$data[comm.vars]
                        })%>%
                  do.call(what = rbind)
            return(replies)
      }
      get_posts <- function(file.json){
            file.json$data$children[[1]]$data[post.vars]
      }
      
### get text for all posts in directory
      data.dir = "Data/One_Day_Depression_Sample/depression 01-06-2016 30-06-2016/"
      all.files = dir(data.dir)[grep("json", dir(data.dir))]

      comm.data <- data.frame()
      post.data <- data.frame()

      for(file.name in all.files){
            try({
                  cat(file.name, "\n")
                  file.json = 
                        file.path(data.dir, file.name) %>%
                        readLines() %>%
                        fromJSON()
                  comm.data <- rbind(comm.data, get_comments(file.json))
                  post.data <- rbind(post.data, get_posts(file.json))
            })
      }
      
      rm(all.files, comm.vars, file.json, file.name, get_comments,
         get_children, get_posts, get_reply_list, post.vars,
         data.dir, bad.file)
      save.image(file="Data/June_Posts.RData")

