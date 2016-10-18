
### Load Data
      load(file = "Data/SI_Author_Sample/Author_Summary.RData")
      library(ggplot2)
      library(reshape2)
      user.summary = 
            filter(user.summary, recent < 150) %>%
            mutate(t = recent)
      n = user.summary$n
      eps = user.summary$eps
      eps[is.na(eps)] = 0 
      t = user.summary$t
      N = nrow(user.summary)
      
### Simulate Mu given Data
      alpha = 1; beta = 1
      mu = replicate(n = 10000, rgamma(N, shape = alpha + n, rate = beta + n*eps))
      dim(mu)

### Calculate P(Q) from Mu and data
      prior.p = c(0.5, 10^-(1:4))
      make.p = function(mu,p) p / (exp(-mu*t)*(1-p) + p)
      post_p = sapply(prior.p, FUN = function(x) apply(mu, 2, make.p, p=x) %>% rowMeans)
      colnames(post_p) = c("p.5", paste0("p10.", 1:4))
      user.summary2 = 
            cbind(user.summary, post_p) %>%
            select(-recent) %>%
            melt(id.vars = c("author", "n", "eps", "t"),
                 value.name = "post.p", variable.name = "prior.p")
      ggplot(user.summary2) + 
            geom_point(aes(t, eps, color=post.p), size=0.5, alpha=0.5) + 
            facet_wrap("prior.p") + 
            theme_bw()

### Now get overall credible interval for sum(Q)
      prior.p = 0.000001
      make.p = function(mu,p) p / (exp(-mu*t)*(1-p) + p)
      post.E = colSums(apply(mu, 2, make.p, p=prior.p))
      hist(post.E, main = "Posterior Distribution for \n Expected Total Reddit Drop-Outs")
      