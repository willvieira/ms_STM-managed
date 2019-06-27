################################
# Plot figure 1
  # Five metrics of the transient dynamic over the latitudinal gradient
# Will Vieira
# June 20, 2019
################################

practices <- c('Plantation', 'Harvest', 'Thinning', 'Enrichment', 'noManaged')
metrics <- c('Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes')

# get solved data
for(i in c(practices, 'noCC')) assign(paste0('dat_', i), readRDS(file = paste0('num-results/data/fig1/dat_', i, '.RDS')))

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

  if(mt == 'Cumulative state changes') legend('topright', legend = practices, lty = 1, col = mgCols, bty = 'n', cex = 1)
}

plot(dat_noManaged[, c('env1aUnscaled', 'EqB')], type = 'l', xlab = '', ylab = 'State proportion', ylim = c(0, 1), col = stateCols[1])
points(dat_noManaged$env1aUnscaled, dat_noManaged$EqM + dat_noManaged$EqT, type = 'l', col = stateCols[2])
points(dat_noCC[, c('env1aUnscaled', 'EqB')], type = 'l', xlab = '', ylab = 'State proportion', ylim = c(0, 1), col = stateCols[1], lty = 2)
points(dat_noCC$env1aUnscaled, dat_noCC$EqM + dat_noCC$EqT, type = 'l', col = stateCols[2], lty = 2)
legend(1.6, 0.98, legend = c('Boreal', 'Mixed +\nTemperate'), lty = 1, col = c(stateCols[1], stateCols[2]), bty = 'n', cex = 1)
legend(1.6, 0.62, legend = c(expression('T'[0]), expression('T'[1])), lty = c(2, 1), col = 1, bty = 'n', cex = 1)

# text
mtext("Latitude (annual mean temperature)", 1, line = 0.2, cex = 0.92, outer = TRUE)
dev.off()