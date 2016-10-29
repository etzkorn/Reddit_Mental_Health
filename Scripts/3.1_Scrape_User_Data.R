
### get functions
      source(file="Scripts/3.3_Scrape_Functions.R")
      load(file = "Data/June_Depression_Sample/June_Unique_NoSI_Authors.RData")
      authors.noSI = na.omit(authors.noSI)
      
### loop through users
      user.comment.data = data.frame()
      user.post.data = data.frame()
      
for(user in authors.noSI){
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
save.image(file = "Data/SI_Author_Sample/June_NoSI_Authors_Data.RData")
