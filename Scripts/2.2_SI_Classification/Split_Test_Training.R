load(file="Data/Jun1_Post_Data.RData")

all.ind <- sample(1:nrow(post.data), size = 1000, replace = F)
lacey2 <- post.data[all.ind[1:300],]
linda2 <- post.data[all.ind[200:499],]
test2 <- post.data[all.ind[500:1000],]

save(linda2, file="Data/Training_Linda2.RData")
save(lacey2, file="Data/Training_Lacey2.RData")
save(test2, file="Data/Test2.RData")

