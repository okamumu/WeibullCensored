
gen.sample <- function(n, t, shape, scale) {
  x <- rweibull(n, shape = shape, scale = scale)
  b <- x >= t
  x[b] <- t
  data.frame(time=x, censored=b)
}

loglikelihoodWithoutCensored <- function(param, x) {
  shape <- param[1]
  scale <- param[2]
  if (shape <= 0 || scale <= 0) {
    return(NA)
  }
  b <- x$censored
  x0 <- x$time[b == FALSE]
  sum(dweibull(x0, shape=shape, scale=scale, log = TRUE))
}

loglikelihoodWithCensored <- function(param, x) {
  shape <- param[1]
  scale <- param[2]
  if (shape <= 0 || scale <= 0) {
    return(NA)
  }
  b <- x$censored
  x0 <- x$time[b == FALSE]
  x1 <- x$time[b == TRUE]
  sum(dweibull(x0, shape=shape, scale=scale, log = TRUE)) + sum(pweibull(x1, shape=shape, scale=scale, lower.tail = FALSE, log.p=TRUE))
}

mle.withoutcensored <- function(x) {
  optim(par=c(1,1), fn=loglikelihoodWithoutCensored, control = list(fnscale=-1), x=x)
}

mle.withcensored <- function(x) {
  optim(par=c(1,1), fn=loglikelihoodWithCensored, control = list(fnscale=-1), x=x)
}

# ##
# ## 実行例（真の故障分布を設定して，仮想的な実験データをサンプル，そのサンプルからワイブルパラメータを推定）
# ##
# 
# shape <- 2 # 真の故障分布（ワイブル形状パラメータ）
# scale <- 1000 # 真の故障分布（ワイブル尺度パラメータ（スケール））
# t <- 1000 # 打ち切り時間
# n <- 100 # 試験する製品数
# 
# data <- gen.sample(n, t, shape, scale) # 擬似的な実験データを生成
# print(paste("# of censored items", sum(data$censored))) # 打ち切りされた製品個数
# print(paste("# of failedd items", sum(data$censored == FALSE))) # 故障した製品数
# 
# print("Do not use censored data")
# result <- mle.withoutcensored(data)
# print(paste("Estimated shape parameter", result$par[1]))
# print(paste("Estimated scale parameter", result$par[2]))
# 
# print("Use censored data")
# result <- mle.withcensored(data)
# print(paste("Estimated shape parameter", result$par[1]))
# print(paste("Estimated scale parameter", result$par[2]))
