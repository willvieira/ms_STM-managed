################################
# Plot figure 1
  # Five metrics of the transient dynamic over the latitudinal gradient
# Will Vieira
# June 20, 2019
################################

practices <- c('Plantation', 'Enrichment', 'Harvest', 'Thinning', 'noManaged')
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
leg <- letters[1:length(metrics)]
leg <- setNames(paste0('(', leg, ')'), metrics)

Alpha = 190
mgCols = setNames(c(rgb(144, 178, 67, Alpha, maxColorValue = 255),
                    rgb(11, 89, 105, Alpha, maxColorValue = 255),
                    rgb(249, 66, 37, Alpha, maxColorValue = 255),
                    rgb(253, 168, 48, Alpha, maxColorValue = 255),
                    rgb(0, 0, 0, Alpha, maxColorValue = 255)), practices)

# states color
stateCols <- c("darkcyan", "orange", "palegreen3", "black")

print('Plot figure 1')
# Create img directory in case it does not exists
Dir <- 'manuscript/img/'
if(!dir.exists(Dir)) dir.create(Dir)
pdf(file = paste0(Dir, 'num-result.pdf'), width = 6.4, height = 6.7)
par(mfrow = c(3, 2), mar = c(1, 2.5, .5, 0.8), oma = c(1.5, 0, 0.5, 0), mgp = c(1.4, 0.2, 0), tck = -.008, cex = 0.8)
for(mt in metrics)
{
  plot(0, pch = '', xlim = xLim, ylim = get(paste0('ylim', mt)), xlab = '', ylab = mt, cex.lab = 1.1, xaxt = 'n')
  # xaxis
  axis(1, labels = ifelse(mt == 'Cumulative state changes', T, F))

  for(mg in practices)
  {
    points(get(paste0('dat_', mg))[, c('env1aUnscaled', mt)], type = 'l', lwd = 1.2, col = mgCols[mg])
  }
  legend(par('usr')[1] - (par('usr')[2]-par('usr')[1])*0.06, par('usr')[4], legend = leg[mt], bty = 'n', cex = 1.2)

  if(mt == 'Cumulative state changes') legend('topright', legend = practices, lty = 1, col = mgCols, bty = 'n', cex = 1, lwd = 1.2)
}

plot(dat_noManaged[, c('env1aUnscaled', 'EqB')], type = 'l', xlab = '', ylab = 'State proportion', ylim = c(0, 1), col = stateCols[1], lwd = 1.2)
points(dat_noManaged$env1aUnscaled, dat_noManaged$EqM + dat_noManaged$EqT, type = 'l', col = stateCols[2], lwd = 1.2)
points(dat_noCC[, c('env1aUnscaled', 'EqB')], type = 'l', xlab = '', ylab = 'State proportion', ylim = c(0, 1), col = stateCols[1], lty = 2, lwd = 1.2)
points(dat_noCC$env1aUnscaled, dat_noCC$EqM + dat_noCC$EqT, type = 'l', col = stateCols[2], lty = 2, lwd = 1.2)
legend(1.05, 0.94, legend = c('Boreal', 'Mixed +\nTemperate'), lty = 1, col = c(stateCols[1], stateCols[2]), bty = 'n', cex = 1, lwd = 1.2)
legend(1.05, 0.58, legend = c(expression(paste('T'[0], ' equilibrium')), expression(paste('T'[1], ' equilibrium'))), lty = c(2, 1), col = 1, bty = 'n', cex = 1, lwd = 1.2)

# text
mtext("Latitude (annual mean temperature)", 1, line = 0.2, cex = 0.92, outer = TRUE)
dev.off()
