###############################################################################
# Script to calculate annual mean temperature shift of state distribution
# Will Vieira
# Feb 2022
###############################################################################


# Load sim data
load('sim-results/data/sim_summary_4.5.rda')
#load('sim-results/data/sim_summary_8.5.rda')
load('sim-results/data/sim_summary_supp2.rda')
load('sim-results/data/sim_summary_supp3.rda')



# remove border of landscape
datEq <- datEq[-c(1, nrow(datEq)), ]


# data frame to store simulation summaries
summ_dt <- data.frame()

# vector of names, color, practice and simulations
managName <- c('noManaged', 'Plantation', 'Harvest', 'Thinning', 'Enrichment')
sim_int <- c(2, 5, 10, 20)
mgCols = setNames(
    c( 
        'grey',
        rgb(144, 178, 67, maxColorValue = 255),
        rgb(249, 66, 37, maxColorValue = 255),
        rgb(253, 168, 48, maxColorValue = 255),
        rgb(11, 89, 105, maxColorValue = 255)
        
    ),
    managName
)
stateCols <- setNames(
    c(rgb(0, 0.54, 0.54), rgb(1, 0.647, 0)),
    c('Boreal', 'Temperate')
)
stateCols_t <- setNames(
    c(rgb(0, 0.54, 0.54, 0.55), rgb(1, 0.647, 0, 0.55)),
    c('Boreal', 'Temperate')
)



# Calculate shift size of state distribution at equilibrium

    # BOREAL
    prop_range <- range(c(datEq$EqB, propSummaryT0$meanB))
    propSeq <- seq(prop_range[2], prop_range[1], length.out = length(env1))

    # extract env position from data
    pred_env1B <- sapply(propSeq, function(x) env1[which.min(abs(datEq$EqB - x))])
    pred_env0B <- sapply(propSeq, function(x) env1[which.min(abs(propSummaryT0$meanB - x))])

    summ_dt <- rbind(
        summ_dt,
        data.frame(
            state = 'B',
            sim = 'Eq1',
            mg = NA,
            Time = 150,
            RCP = 4.5,
            diff = pred_env1B - pred_env0B,
            prop = propSeq
        )
    )


    # TEMPERATE
    prop_range <- range(c(datEq$EqT, propSummaryT0$meanT))
    propSeq <- seq(prop_range[1], prop_range[2], length.out = length(env1))

    # extract env position from data
    pred_env1T <- sapply(propSeq, function(x) env1[which.min(abs((datEq$EqT + datEq$EqM) - x))])
    pred_env0T <- sapply(propSeq, function(x) env1[which.min(abs(propSummaryT0$meanT - x))])

    summ_dt <- rbind(
        summ_dt,
        data.frame(
            state = 'T',
            sim = 'Eq1',
            mg = NA,
            Time = 150,
            RCP = 4.5,
            diff = pred_env1T - pred_env0T,
            prop = propSeq
        )
    )
    # plot(density(pred_env1T - ), col = 'orange')
    # lines(density(pred_env1B - pred_env0B), col = 'darkgreen')

#




# Shift with forest management (with and without climate change)

    for(RCP in c(0, 4.5))
    {
        for(state in c('B', 'T'))
        {
            for(practice in 0:4)
            {
                # generate state proportion to locate temperature
                prop_range <- range(
                    c(
                        get(paste0('listRCPProp', RCP))[[paste0('mg_', practice)]][, paste0('mean', state)],
                        propSummaryT0[, paste0('mean', state)]
                    )
                )
                propSeq <- seq(
                    prop_range[1],
                    prop_range[2],
                    length.out = length(env1)
                )

                # extract temp for generated prop given data (sim and reference)
                pred_sim <- sapply(
                    propSeq,
                    function(x)
                        env1[which.min(abs(get(paste0('listRCPProp', RCP))[[paste0('mg_', practice)]][, paste0('mean', state)] - x))]
                )
                pred_ref <- sapply(
                    propSeq,
                    function(x)
                        env1[which.min(abs(propSummaryT0[, paste0('mean', state)] - x))]
                )

                # save median and sd movement from ref to sim
                summ_dt <- rbind(
                    summ_dt,
                    data.frame(
                        state = state,
                        sim = paste0('T150', ifelse(RCP == 0, '', '+CC'), '+FM'),
                        mg = managName[practice+1],
                        Time = 150,
                        RCP = RCP,
                        diff = pred_sim - pred_ref,
                        prop = propSeq
                    )
                )
            }
        }
    }

#




# Shift for supp material A

    for(sim in c(50, 100, 200))
    {
        for(state in c('B', 'T'))
        {
            for(practice in 0:4)
            {
                # generate state proportion to locate temperature
                prop_range <- range(
                    c(
                        get(paste0('listStepProp', sim))[[paste0('mg_', practice)]][, paste0('mean', state)],
                        propSummaryT0[, paste0('mean', state)]
                    )
                )
                propSeq <- seq(
                    prop_range[1],
                    prop_range[2],
                    length.out = length(env1)
                )

                # extract temp for generated prop given data (sim and reference)
                pred_sim <- sapply(
                    propSeq,
                    function(x)
                        env1[which.min(abs(get(paste0('listStepProp', sim))[[paste0('mg_', practice)]][, paste0('mean', state)] - x))]
                )
                pred_ref <- sapply(
                    propSeq,
                    function(x)
                        env1[which.min(abs(propSummaryT0[, paste0('mean', state)] - x))]
                )

                # save median and sd movement from ref to sim
                summ_dt <- rbind(
                    summ_dt,
                    data.frame(
                        state = state,
                        sim = paste0('T', sim * 5, '+CC+FM'),
                        mg = managName[practice+1],
                        Time = sim * 5,
                        RCP = 4.5,
                        diff = pred_sim - pred_ref,
                        prop = propSeq
                    )
                )
            }
        }
    }
#



# Shift for supp material B

    for(sim in 1:4)
    {
        for(state in c('B', 'T'))
        {
            for(practice in 1:4)
            {
                # generate state proportion to locate temperature
                prop_range <- range(
                    c(
                        get(paste0('listMgProp', practice))[[paste0('mgInt_', sim)]][, paste0('mean', state)],
                        propSummaryT0[, paste0('mean', state)]
                    )
                )
                propSeq <- seq(
                    prop_range[1],
                    prop_range[2],
                    length.out = length(env1)
                )

                # extract temp for generated prop given data (sim and reference)
                pred_sim <- sapply(
                    propSeq,
                    function(x)
                        env1[which.min(abs(get(paste0('listMgProp', practice))[[paste0('mgInt_', sim)]][, paste0('mean', state)] - x))]
                )
                pred_ref <- sapply(
                    propSeq,
                    function(x)
                        env1[which.min(abs(propSummaryT0[, paste0('mean', state)] - x))]
                )

                # save median and sd movement from ref to sim
                summ_dt <- rbind(
                    summ_dt,
                    data.frame(
                        state = state,
                        sim = paste0('T150', '+CC+FM', '_', sim_int[sim]),
                        mg = managName[practice+1],
                        Time = 150,
                        RCP = 4.5,
                        diff = pred_sim - pred_ref,
                        prop = propSeq
                    )
                )
            }
        }
    }
#



# Filter extreme occupancy proportions (close to 0 and close 1) as the method we use does not work correctly in these regions
# It happens because at the extremes proportions, many temperature locations have the same state occupancy proprtion. Take for instance Boreal occupancy stays with approximate 0.96 occupancy for around 0.5C to up to -2.5C
# So when I ask which temperature my data stands at the exact position of 0.96 proportion, it's difficult to define if it's -2 or 0.5 as both are true.
# Remove these extreme proportions does not have a large effect on the results
summ_dt <- subset(summ_dt, prop < 0.93 & prop > 0.07)



# save as RDS

    saveRDS(summ_dt, file = 'sim-results/data/shift_dt.RDS')

#





# # Explore:
# summ_exp <- summ_dt

# # boxplot of median temperature shift by management practices + Time

#     # reorder management levels
#     summ_exp$mg <- factor(summ_exp$mg, levels = managName[c(5, 2, 3, 4, 1)])
#     mgCols <- mgCols[c(5, 2, 3, 4, 1)]
    
#     par(mar = c(1, 2.8, .5, 0.8), oma = c(1.5, 0, 1, 0), mgp = c(1.2, 0.2, 0), tck = -.008, cex = 0.8)
#     # plot
#     boxplot(
#         diff ~ Time + mg,
#         subset(summ_exp, sim %in% unique(summ_exp$sim)[3:6] & RCP == 4.5),
#         xlim = c(0.9, 19.9),
#         xaxt = 'n', xlab = '',
#         ylab = 'State shift in annual mean temperature (°C)',
#         col = rep(mgCols, each = 4)
#     )
#     axis(1, at = 1:20, labels = rep(unique(summ_exp$Time), 5))
#     axis(1, at = c(2, 6, 10, 14, 18) + 0.5, labels = levels(summ_exp$mg), tick = FALSE, line = 1)
#     abline(v = c(4, 8, 12, 16) + 0.5, lty = 2, col = 'grey', lwd = 1.4)
#     abline(h = median(subset(summ_exp, sim == 'Eq1')$diff), col = 'red', lty = 2, lwd = 1)

# #



# # Isolate time by geting avarange speed

#     # calculate speed
#     summ_exp$av_speed <- summ_exp$diff/summ_exp$Time


#     # It seems to narrow the distribution, and this is good as it removes noise from effect wer are not necessarily intereseted (like time)
#     par(mfrow = c(2, 1), mar = c(1, 2.8, .5, 0.8), oma = c(1.5, 0, 1, 0), mgp = c(1.2, 0.2, 0), tck = -.008, cex = 0.8)
#     # plot 1
#     boxplot(
#         diff ~ Time + mg,
#         subset(summ_exp, sim %in% unique(summ_exp$sim)[3:6] & RCP == 4.5),
#         xlim = c(0.9, 19.9),
#         xaxt = 'n', xlab = '',
#         ylab = 'State shift in annual mean temperature (°C)',
#         col = rep(mgCols, each = 4)
#     )
#     axis(1, at = 1:16, labels = NA)
#     abline(v = c(4, 8, 12) + 0.5, lty = 2, col = 'grey', lwd = 1.4)
#     abline(h = median(subset(summ_exp, sim == 'Eq1' & RCP == 4.5)$diff), col = 'red', lty = 2, lwd = 1)
#     # plot 2
#     boxplot(
#         av_speed ~ Time + mg,
#         subset(summ_exp, sim %in% unique(summ_exp$sim)[3:6] & RCP == 4.5),
#         xlim = c(0.9, 19.9),
#         xaxt = 'n', xlab = '',
#         ylab = 'Avarage speed of shift in annual mean temperature (°C)',
#         col = rep(mgCols, each = 4)
#     )
#     axis(1, at = 1:20, labels = rep(unique(summ_exp$Time), 5))
#     axis(1, at = c(2, 6, 10, 14, 18) + 0.5, labels = levels(summ_exp$mg), tick = FALSE, line = 1)
#     abline(v = c(4, 8, 12, 16) + 0.5, lty = 2, col = 'grey', lwd = 1.4)
#     abline(h = median(subset(summ_exp, sim == 'Eq1' & RCP == 4.5)$av_speed), col = 'red', lty = 2, lwd = 1)
# #



# # Without time but State + management

#     par(mfrow = c(2, 1), mar = c(1, 2.8, .5, 0.8), oma = c(1.5, 0, 1, 0), mgp = c(1.2, 0.2, 0), tck = -.008, cex = 0.8)
#     # plot 1
#     boxplot(
#         diff ~ state + mg,
#         subset(summ_exp, sim != 'T150+FM'),
#         xlim = c(0.8, 10.2),
#         xaxt = 'n', xlab = '',
#         ylab = 'State shift in annual mean temperature (°C)',
#         col = rep(stateCols, 5)
#     )
#     axis(1, at = 1:10, labels = NA)
#     abline(v = c(2, 4, 6, 8) + 0.5, lty = 2, col = 'grey', lwd = 1.4)
#     # plot 2
#     boxplot(
#         av_speed ~ state + mg,
#         subset(summ_exp, sim != 'T150+FM'),
#         xlim = c(0.8, 10.2),
#         xaxt = 'n', xlab = '',
#         ylab = 'Avarage speed of shift in annual mean temperature (°C)',
#         col = rep(stateCols, 5)
#     )
#     axis(1, at = 1:10, labels = rep(unique(summ_exp$state), 5))
#     axis(1, at = c(1, 3, 5, 7, 9) + 0.5, labels = levels(summ_exp$mg), tick = FALSE, line = 1)
#     abline(v = c(2, 4, 6, 8) + 0.5, lty = 2, col = 'grey', lwd = 1.4)

# #

