##########################################################################################
#  Function to get summarized data using the solveEq function
##########################################################################################

print('Running numerical analysis')

# source local functions and paramenters values
source('num-results/model_STM_managed.R')
source('num-results/model_STM.R')
source('num-results/solve_Eq.R')
params = read.table("num-results/pars.txt", row.names = 1)

# get data.table with all five measures of the transiet analysis along management intensity
solve_summary <- function(env1a, env1b, growth, managPractices = c(1, 0, 0, 0))
{
  # data frame to save solveEq output
  dat <- setNames(data.frame(seq(0, 1, length.out = 40), NA, NA, NA, NA, NA, NA, NA, NA, NA), c('managInt', 'deltaTime', 'deltaState', 'R_inf', 'R_init', 'integral', 'EqB', 'EqT', 'EqM', 'EqR'))

  # management practices
  managPrac <- list()
  for(i in 1:4) {
    managPrac[[i]] <- seq(0, managPractices[i], length.out = 40)
  }

  # solveEq for each management intensity
  for(i in 1:dim(dat)[1])
  {
    # create management vector from managPrac list
    management = c(managPrac[[1]][i], managPrac[[2]][i], managPrac[[3]][i], managPrac[[4]][i])
    res <- solve_Eq(func = model_fm, ENV1a = env1a, ENV1b = env1b,
                    growth,
                    management = management)

    dat[i, c('EqB', 'EqT', 'EqM', 'EqR')] <- c(res[['eq']], 1 - sum(res[['eq']]))
    dat[i, c('deltaTime', 'deltaState', 'R_inf', 'R_init', 'integral')] <- c(res[['deltaTime']], res[['deltaState']], res[['R_inf']], res[['R_init']], res[['integral']])
  }
  return(dat)
}

# get dat for each management practices
ENV1a = -1.55 # value of temperature (scaled) for T0
ENV1b = -0.882 # value of temperature (scaled) for scenario RCP 4.5
dat_plant <- solve_summary(env1a = ENV1a, env1b = ENV1b, growth = 'linear', managPractices = c(1, 0, 0, 0))
dat_harv <- solve_summary(env1a = ENV1a, env1b = ENV1b, growth = 'linear', managPractices = c(0, 1, 0, 0))
dat_thin <- solve_summary(env1a = ENV1a, env1b = ENV1b, growth = 'linear', managPractices = c(0, 0, 1, 0))
dat_enr <- solve_summary(env1a = ENV1a, env1b = ENV1b, growth = 'linear', managPractices = c(0, 0, 0, 1))

#plot final figure
# state colors
stateColor <- setNames(c(rgb(0.15,	0.55, 0.54), rgb(0.98, 0.63, 0.22), rgb(0.53, 0.79, 0.51), 'black'), c('Boreal', 'Temperate', 'Mixed', 'Regeneration'))

# ylim for each plot
dats <- c("dat_plant", "dat_harv", "dat_thin", "dat_enr")
vars <- names(dat_plant)[2:6]
for(i in 1:length(vars)) {
    vec = c()
   for(j in 1:length(dats)) {
    vec = append(vec, get(dats[j])[,vars[i]])
  }
assign(paste0('range_', vars[i]), range(vec))
}

# plot and save

print('Plot numerical analysis')

pdf(file = 'manuscript/img/num-result.pdf', width = 6.4)
par(mfrow = c(3, 2), mar = c(3,3.35,0.4,1), mgp = c(1.5, 0.3, 0), tck = -.008)
# Equilibrium
#plot(dat$managInt, dat$EqB, col = stateColor[1], type = 'l', lwd = 2.1, ylim = c(0, 1), xlab = '', ylab = 'Proportion of states')
#invisible(sapply(8:10, function(x) points(dat$managInt, dat[, x], type = 'l', col = stateColor[x-6], lwd = 2.1)))

# R_infinity
plot(get(dats[1])$managInt, get(dats[1])$R_inf, ylim = range_R_inf, type = 'l', lwd = 1.2, xlab = '', ylab = expression('-R'[infinity]))
for(i in 2:4) points(get(dats[i])[,'managInt'], get(dats[i])[,'R_inf'], type = 'l', lwd = 1.2, lty = i)
legend(par('usr')[1] - (par('usr')[2]-par('usr')[1])*0.06, par('usr')[4], legend = '(a)', bty = 'n', cex = 1.2)

# R_init
plot(get(dats[1])$managInt, get(dats[1])$R_init, ylim = range_R_init, type = 'l', lwd = 1.2, xlab = '', ylab = expression(R['0']))
for(i in 2:4) points(get(dats[i])[,'managInt'], get(dats[i])[,'R_init'], type = 'l', lwd = 1.2, lty = i)
legend(par('usr')[1] - (par('usr')[2]-par('usr')[1])*0.06, par('usr')[4], legend = '(b)', bty = 'n', cex = 1.2)

# deltaState (exposure)
plot(get(dats[1])$managInt, get(dats[1])$deltaState, ylim = range_deltaState, type = 'l', lwd = 1.2, xlab = '', ylab = expression(Delta ['state']))
for(i in 2:4) points(get(dats[i])[,'managInt'], get(dats[i])[,'deltaState'], type = 'l', lwd = 1.2, lty = i)
legend(par('usr')[1] - (par('usr')[2]-par('usr')[1])*0.06, par('usr')[4], legend = '(c)', bty = 'n', cex = 1.2)

# detalTime (sensibility)
plot(get(dats[1])$managInt, get(dats[1])$deltaTime, ylim = range_deltaTime, type = 'l', lwd = 1.2, xlab = '', ylab = expression(paste(Delta ['Time'], ' (year*5)')))
for(i in 2:4) points(get(dats[i])[,'managInt'], get(dats[i])[,'deltaTime'], type = 'l', lwd = 1.2, lty = i)
legend(par('usr')[1] - (par('usr')[2]-par('usr')[1])*0.06, par('usr')[4], legend = '(d)', bty = 'n', cex = 1.2)

# Integral
plot(get(dats[1])$managInt, get(dats[1])$integral, ylim = range_integral, type = 'l', lwd = 1.2, xlab = '', ylab = expression(integral(S(t)*dt)))
for(i in 2:4) points(get(dats[i])[,'managInt'], get(dats[i])[,'integral'], type = 'l', lwd = 1.2, lty = i)
legend(par('usr')[1] - (par('usr')[2]-par('usr')[1])*0.06, par('usr')[4], legend = '(e)', bty = 'n', cex = 1.2)

# empty plot for legend
plot(1, type="n", axes=F, xlab="", ylab="")
legend('center', legend = c('Plantation', 'Harvest', 'Thinning', 'Enrichment'), lty = 1:4, bty = 'n', cex = 1.2)
# text
mtext("Management intensity", 1, line = -1.3, cex = .9, outer = TRUE)

dev.off()
