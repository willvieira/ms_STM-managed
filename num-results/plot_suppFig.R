################################
# Plot supplementary figure
  # Five metrics of the transient dynamic over the intensity of forest management
# Will Vieira
# June 20, 2019
################################

practices <- c('Plantation', 'Harvest', 'Thinning', 'Enrichment')
ev1a <- c(-1, 0)
RCP <- 4.5

Alpha = 190
mgCols = setNames(
  c(
    rgb(144, 178, 67, Alpha, maxColorValue = 255),
    rgb(11, 89, 105, Alpha, maxColorValue = 255),
    rgb(249, 66, 37, Alpha, maxColorValue = 255),
    rgb(253, 168, 48, Alpha, maxColorValue = 255)
  ),
  practices
)


# get solved data
for(cc in RCP) {
  for(env in ev1a) {
    for(mg in practices) {
      assign(paste0('dat_', mg, '_', env), readRDS(file = paste0('num-results/data/fig2/dat_', mg, '_', env, '_', cc, '.RDS')))
    }
  }
}

#############################
# Plot
#############################

metrics <- c('Initial resilience', 'Cumulative state changes')
metrics_eq <- setNames(
  c(
    expression(paste('Initial resilience ', (-R[0]))), 
    expression(paste('Cumul state changes (', integral('S(t)dt'), ')'))
  ),
  metrics
)
leg <- letters[1:(length(metrics) * 2)]
leg <- setNames(paste0('(', leg, ')'), do.call(paste0, expand.grid(metrics, ev1a)))

# ylim for each variable for each ENV1
nR <- nrow(dat_Plantation_0)
for(env1a in ev1a) {
  for(mt in metrics)
  {
    vars <- rep(NA, length(practices) * nR)
    count = 0
    for(mg in practices)
    {
      vars[(nR * count + 1):(nR * (count + 1))] <- get(paste0('dat_', mg, '_', env1a))[, mt]
      count <- count + 1
    }
    assign(paste0('ylim', mt, env1a), c(min(vars), max(vars)))
  }
}

# ylim for each variable independent of env1a
nR <- nrow(dat_Plantation_0)
for(mt in metrics)
{
  vars <- rep(NA, length(practices) * length(ev1a) * nR)
  count = 0
  for(env1a in ev1a) {
    for(mg in practices)
    {
      vars[(nR * count + 1):(nR * (count + 1))] <- get(paste0('dat_', mg, '_', env1a))[, mt]
      count <- count + 1
    }
  }
  assign(paste0('ylim', mt), c(min(vars), max(vars)))
}



print('Plot supplementary figure 1')

# Create img directory in case it does not exists
Dir <- 'manuscript/img/'
if(!dir.exists(Dir)) dir.create(Dir)
png(filename = paste0(Dir, 'num-result_supp1.png'), width = 6.4, height = 5, units = 'in', res = 250)
par(mfcol = c(2, 2), mar = c(1, 1.4, 0.5, 0), oma = c(1.5, 2, 0.5, 0), mgp = c(1.4, 0.2, 0), tck = -.008, cex = 0.8)
for(env1a in ev1a) {
  for(mt in metrics)
  {
    # empty plot
    plot(0, pch = '', xaxt = 'n', yaxt = 'n', xlim = c(0, 1), ylim = get(paste0('ylim', mt)), xlab = '', ylab = '', cex.lab = 1.1)
    # xaxis
    axis(1, labels = ifelse(mt == 'Cumulative state changes', T, F))
    axis(2, labels = ifelse(env1a == ev1a[1], T, F))

    # main for env1a
    if(mt == 'Initial resilience') mtext(paste0('Mean annual temperature = ', env1a, '°C (', ifelse(env1a == ev1a[1], 'Boreal', 'Mixed'), ')'), 3, line = 0, cex = .92)
    # ylab
    if(env1a == ev1a[1]) mtext(metrics_eq[mt], 2, line = 1.3, cex = 0.92)

    # lines of each practices
    for(mg in practices)
    {
      points(get(paste0('dat_', mg, '_', env1a))[, c('managInt', mt)], type = 'l', lwd = 1.2, col = mgCols[mg])
    }

    # legend
    if(env1a == ev1a[2] & mt == 'Cumulative state changes') legend('topright', legend = c('Plantation', 'Harvest', 'Thinning', 'Enrichment'), lty = 1, col = mgCols, bty = 'n', cex = 1)
  }

}
mtext("Management intensity", 1, line = 0.2, cex = .92, outer = TRUE)
dev.off()
