###############################
# Create init_landscape for simulations
# Will Vieira
# April 24, 2019
# Last update: September 7, 2019
##############################

set.seed(42)
library(STManaged)


# create 30 initial landscapes (one for each sim replication)

  # create folder to store all landscapes
  initLandFoder = 'sim-results/initLandscape'
  if(!dir.exists(initLandFoder)) dir.create(initLandFoder)

  reps = 1:30

  # file names
  initLandFiles = paste0('initLand_cellSize_0.3_rep_', reps)

  # check if initial landscapes are already created (because it's very time consuming)
  files = dir(initLandFoder)
  run = ifelse(!all(initLandFiles %in% sub('\\.RDS$', '', files)), TRUE, FALSE)
  cat('creating init_landscapes ? -> ', run, '\n')

  # 1 land for each repetion x 6 different cell size = 180 initLand objects
  if(run == TRUE) {
    for(rep in reps) {
      saveRDS(create_virtual_landscape(climRange = c(-2.61, 5.07), cellSize = 0.3), file = paste0(initLandFoder, '/initLand_cellSize_', 0.3, '_rep_', rep, '.RDS'))
      print(paste('    creating initial landscapes', round(rep/length(reps) * 100, 1)))
    }
  }
#
