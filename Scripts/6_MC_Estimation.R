### Load Data
      load("Data/SI_Author_Sample/June_Authors_Combined.RData")
      require(dplyr)

### Summarize to Author Level
      author.summary = 
            user.data %>% 
            group_by(author) %>%
            summarise(n = n()-1,
                      eps.bar = mean(time.last, na.rm=T),
                      t = as.numeric(october10 - max(date)),
                      si.author = si.author[1]) %>%
            filter(t < 150)
      n = author.summary$n
      eps = author.summary$eps.bar
      eps[is.na(eps)] = 0 
      t = author.summary$t
      N = nrow(author.summary)
      si = author.summary$si.author
### Simulate Mu given Data
      mu = replicate(n = 10000, rgamma(N, shape = 1 + n, rate = 1 + n*eps))
### Now get overall credible interval for sum(Q)
      prior.p = 10^-10
      post.si = 
            apply(mu[si,], 2, 
                  function(mu,p,t) p / (exp(-mu*t)*(1-p) + p), 
                  p=prior.p, 
                  t=t[si]) %>%
            colSums
      post.nosi = 
            apply(mu[!si,], 2, 
                  function(mu,p,t) p / (exp(-mu*t)*(1-p) + p), 
                  p=prior.p, 
                  t=t[!si]) %>%
            colSums
      post.excess = post.si - post.nosi
      
### Save Posterior Samples
      save(post.excess, file = "Data/Posteriors/Attributable_10e-10.Rdata")

### Calculate P(Q) from Mu and data
      prior.p = 10^-seq(0.5,15.5, by=0.5)
      get.p = function(mu,p,t) p / (exp(-mu*t)*(1-p) + p)
      post_p = 
            sapply(prior.p, FUN = function(x){
                  post.si = colSums(apply(mu[si,], 2, get.p, p=x, t=t[si]))
                  post.nosi = colSums(apply(mu[!si,], 2, get.p, p=x, t=t[!si]))/sum(!si)*sum(si)
                  post.excess = post.si - post.nosi
                  return(quantile(post.excess, probs = c(0.025, 0.5, 0.975)))
            })
      colnames(post_p) = paste0("p10e-", seq(0.5,15.5, by=0.5))

### Save Posterior Samples
      save(post_p, file="Data/Posteriors/Attributable_All.Rdata")
      save(prior.p, file="Data/Posteriors/Priors_All.Rdata")
      