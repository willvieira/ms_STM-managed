##########################################################################################
#  FIGURE 1
##########################################################################################

print('Running numerical analysis for figure 1')

# source local functions and paramenters values
source('num-results/model_STM_managed.R')
source('num-results/model_STM.R')
source('num-results/solve_Eq.R')
load('num-results/sysdata.rda')

# get data.table with all five measures of the transiet analysis along the latitudinal gradient
solve_summary <- function(northLimit = -2.5,
                          southLimit = 0.35,
                          RCP,
                          RCPgrowth,
                          managPractices)
{

  # create env1 before (a) and after (b) climate change
  env1a <- seq(northLimit, southLimit, length.out = 200)

  # unscale temperature to add climate change
  tempSc0 <- env1a
  tempUn0 <- tempSc0 * vars.sd['annual_mean_temp'] + vars.means['annual_mean_temp']

  # add climate change
  if(RCP == 2.6) tempUn1 <- tempUn0 + 1 # increase of 1 degree
  if(RCP == 4.5) tempUn1 <- tempUn0 + 1.8
  if(RCP == 6) tempUn1 <- tempUn0 + 2.2
  if(RCP == 8.5) tempUn1 <- tempUn0 + 3.7
  if(RCP == 0) tempUn1 <- tempUn0

  # scale warming temperature
  env1b <- (tempUn1 - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp']

  # data frame to save solveEq output
  dat <- setNames(data.frame(env1a, env1b, tempUn0, NA, NA, NA, NA, NA, NA, NA, NA, NA), c('env1a', 'env1b', 'env1aUnscaled', 'Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes', 'EqB', 'EqT', 'EqM', 'EqR'))

  # solveEq for each latitudinal cell
  for(i in 1:nrow(dat))
  {
    # create management vector from managPrac list
    res <- solve_Eq(func = model_fm, ENV1a = dat[i, 'env1a'], ENV1b = dat[i, 'env1b'],
                    growth = RCPgrowth,
                    management = managPractices)

    dat[i, c('EqB', 'EqT', 'EqM', 'EqR')] <- c(res[['eq']], 1 - sum(res[['eq']]))
    dat[i, c('Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes')] <- c(res[['deltaState']], res[['R_inf']], res[['deltaTime']], res[['R_init']], res[['integral']])

    cat('     solving to equilibrium -> ', round(i/nrow(dat) * 100, 0), '%\r')
  }
  cat('     solving to equilibrium -> ', round(i/nrow(dat) * 100, 0), '%\n')
  return(dat)
}

# get dat for noManaged and then all practices
print("simulation 1 of 6")
dat_noManaged <- solve_summary(northLimit = -2.5, southLimit = 0.35, RCP = 4.5, RCPgrowth = 'linear', managPractices = c(0, 0, 0, 0))
print("simulation 2 of 6")
dat_Plantation <- solve_summary(northLimit = -2.5, southLimit = 0.35, RCP = 4.5, RCPgrowth = 'linear', managPractices = c(0.0025, 0, 0, 0))
print("simulation 3 of 6")
dat_Harvest <- solve_summary(northLimit = -2.5, southLimit = 0.35, RCP = 4.5, RCPgrowth = 'linear', managPractices = c(0, 0.01, 0, 0))
print("simulation 4 of 6")
dat_Thinning <- solve_summary(northLimit = -2.5, southLimit = 0.35, RCP = 4.5, RCPgrowth = 'linear', managPractices = c(0, 0, 0.0025, 0))
print("simulation 5 of 6")
dat_Enrichment <- solve_summary(northLimit = -2.5, southLimit = 0.35, RCP = 4.5, RCPgrowth = 'linear', managPractices = c(0, 0, 0, 0.0025))
print("simulation 6 of 6")
dat_noCC <- solve_summary(northLimit = -2.5, southLimit = 0.35, RCP = 0, RCPgrowth = 'linear', managPractices = c(0, 0, 0, 0))

practices <- c('Plantation', 'Harvest', 'Thinning', 'Enrichment', 'noManaged')
metrics <- c('Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes')



################################
# plot
################################

# ylim for each variable
nR <- nrow(dat_noManaged)
for(mt in metrics)
{
  vars <- rep(NA, length(practices) * nR)
  count = 0
  for(mg in practices)
  {
    vars[(nR * count + 1):(nR * (count + 1))] <- get(paste0('dat_', mg))[, mt]
    count <- count + 1
  }
  assign(paste0('ylim', mt), c(min(vars), max(vars)))
}

# xlim
xLim <- c(min(dat_noManaged[, 'env1aUnscaled']), max(dat_noManaged[, 'env1aUnscaled']))

# manag lines
mgLty <- setNames(c(5, 1:4), practices)
mgCols <- setNames(rainbow(length(practices)), practices)
mgCols[length(mgCols)] <- 'black'
leg <- letters[1:length(metrics)]
leg <- setNames(paste0('(', leg, ')'), metrics)

# states color
stateCols <- c("darkcyan", "orange", "palegreen3", "black")

print('Plot figure 1')
pdf(file = 'manuscript/img/num-result.pdf', width = 6.4, height = 6.7)
par(mfrow = c(3, 2), mar = c(1, 2.5, .5, 0.8), oma = c(1.5, 0, 0.5, 0), mgp = c(1.4, 0.2, 0), tck = -.008, cex = 0.8)
for(mt in metrics)
{
  plot(0, pch = '', xlim = xLim, ylim = get(paste0('ylim', mt)), xlab = '', ylab = mt, cex.lab = 1.1, xaxt = 'n')
  # xaxis
  axis(1, labels = ifelse(mt == 'Cumulative state changes', T, F))

  for(mg in practices)
  {
    points(get(paste0('dat_', mg))[, c('env1aUnscaled', mt)], type = 'l', col = mgCols[mg])
  }
  legend(par('usr')[1] - (par('usr')[2]-par('usr')[1])*0.06, par('usr')[4], legend = leg[mt], bty = 'n', cex = 1.2)
  # add an extra plot with higher resolution
  if(mt == 'TODO') {
    u <- par("usr")
    u2 <- c((u[1]-u[2])/((u[1]-u[2])/2), u[2]-(u[2]*.02), u[3] - (u[3]-u[4])/5, u[4]-(u[4]*.02))
    v <- c(
      grconvertX(u2[1:2], "user", "ndc"),
      grconvertY(u2[3:4], "user", "ndc")
    )
    par(fig=v, new=TRUE, mar=c(0,0,0,0), mgp = c(1.4, 0.01, 0))
    plot(0, pch = '', xlim = c(0.2, .65), ylim = get(paste0('ylim', mt)), axes = FALSE, xlab = "", ylab = "")
    for(mg in practices)
    {
      points(get(paste0('dat_', mg))[, c('env1aUnscaled', mt)], type = 'l', col = mgCols[mg])
    }
    box()
    axis(1, cex.axis = 0.9)
    par(mfrow = c(3, 2), mar = c(2.1, 2.5, 1, 0.5), mgp = c(1.4, 0.2, 0), tck = -.008, cex = 0.8, mfg = c(2, 2))
  }
  if(mt == 'TODO') {
    u <- par("usr")
    u2 <- c((u[1]-u[2])/((u[1]-u[2])/2), u[2]-(u[2]*.02), u[3] - (u[3]-u[4])/5, u[4]-(u[4]*.02))
    v <- c(
      grconvertX(u2[1:2], "user", "ndc"),
      grconvertY(u2[3:4], "user", "ndc")
    )
    par(fig=v, new=TRUE, mar=c(0,0,0,0), mgp = c(1.4, 0.01, 0))
    plot(0, pch = '', xlim = c(0.2, .65), ylim = get(paste0('ylim', mt)), axes = FALSE, xlab = "", ylab = "")
    for(mg in practices)
    {
      points(get(paste0('dat_', mg))[, c('env1aUnscaled', mt)], type = 'l', col = mgCols[mg])
    }
    box()
    axis(1, cex.axis = 0.9)
    par(mfrow = c(3, 2), mar = c(2.1, 2.5, 1, 0.5), mgp = c(1.4, 0.2, 0), tck = -.008, cex = 0.8, mfg = c(3, 2))
  }
  if(mt == 'Cumulative state changes') legend('topright', legend = practices, lty = 1, col = mgCols, bty = 'n', cex = 1)
}

plot(dat_noManaged[, c('env1aUnscaled', 'EqB')], type = 'l', xlab = '', ylab = 'State proportion', ylim = c(0, 1), col = stateCols[1])
points(dat_noManaged$env1aUnscaled, dat_noManaged$EqM + dat_noManaged$EqT, type = 'l', col = stateCols[2])
points(dat_noCC[, c('env1aUnscaled', 'EqB')], type = 'l', xlab = '', ylab = 'State proportion', ylim = c(0, 1), col = stateCols[1], lty = 2)
points(dat_noCC$env1aUnscaled, dat_noCC$EqM + dat_noCC$EqT, type = 'l', col = stateCols[2], lty = 2)
legend(1.6, 0.98, legend = c('Boreal', 'Mixed + \nTemperate', 'T0', 'T1'), lty = c(1, 1, 2, 1), col = c(stateCols[1], stateCols[2], 1, 1), bty = 'n', cex = 1)
#plot(dat_noManaged[, c('env1aUnscaled', 'EqB')], type = 'l', xlab = '', ylab = 'State proportion', ylim = c(0, 1), col = stateCols[1])
#points(dat_noManaged[, c('env1aUnscaled', 'EqT')], type = 'l', col = stateCols[2])
#points(dat_noManaged[, c('env1aUnscaled', 'EqM')], type = 'l', col = stateCols[3])
#points(dat_noCC[, c('env1aUnscaled', 'EqB')], type = 'l', lty = 2, col = stateCols[1])
#points(dat_noCC[, c('env1aUnscaled', 'EqT')], type = 'l', lty = 2, col = stateCols[2])
#points(dat_noCC[, c('env1aUnscaled', 'EqM')], type = 'l', lty = 2, col = stateCols[3])

# empty plot for legend
#plot(1, type="n", axes=F, xlab="", ylab="")
#legend('center', legend = practices, lty = 1, col = mgCols, bty = 'n', cex = 1)
# text
mtext("Latitude (annual mean temperature)", 1, line = 0.2, cex = 0.92, outer = TRUE)
dev.off()
