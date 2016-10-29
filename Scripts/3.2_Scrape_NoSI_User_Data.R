
### get functions
      source(file="Scripts/3.3_Scrape_Functions.R")
      load(file = "Data/June_Unique_SI_Authors.RData")
      authors = na.omit(authors)
      
### loop through users
      user.comment.data = data.frame()
      user.post.data = data.frame()
      
for(user in authors){
            cat("\nuser: ", user)
            tryCatch({
                  cat("\n\t submissions: ")
                  user.submitted = user_data_frame(user, type="submitted")
                  cat("\n\t comments: ")
                  user.comments = user_data_frame(user, type="comments")
                  user.comment.data = rbind(user.comment.data, user.comments)
                  user.post.data = rbind(user.post.data, user.submitted)
            }, error = function(e) {cat("\n\t error from user: ", user)})
}
rm(comm.vars, get_reddit_user, post.vars, replace_null, 
   user, user_data_frame, user.comments, user.submitted)
save.image(file = "Data/SI_Author_Sample/June_Authors_Data.RData")
