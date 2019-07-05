###############################
# Automate the creation of R script and bash files to run simulation in the server
# Version for the supplementary figures
# Will Vieira
# June 29, 2019
# Last update: June 29, 2019
##############################

##############################
# Steps:
  # define simulation variants
  # create all subfolders for the simulation output
  # for each sim, create a bash + Rscript file and submit it
##############################

library(STManaged)
set.seed(42)

# define simulation variants

  cellSize = 0.3
  RCP = 4.5
  managPractice <- 1:4
  managInt <- c(0.02, 0.05, 0.1, 0.2)
  reps = 1:15

#



# create all subfolders for the simulation output

  mainFolder = 'output'
  if(!dir.exists(mainFolder)) dir.create(mainFolder)
  manag <- paste0('mg_', managPractice)
  mgInt <- paste0('mgInt_', 1:length(managInt))
  folders <- do.call(paste, c(expand.grid(manag, mgInt), sep = "_"))
  invisible(sapply(paste0(mainFolder, '/', folders), dir.create))

#



# create bash with Rscript
  initLandFoder = '../initLandscape'
  job = 1
  for(mg in managPractice) {
    for(mgIn in 1:length(managInt)) {
      for(rp in reps) {

        # define simulation name
        simName = paste0('mg', mg, 'mgInt', mgIn, 'rep', rp)
        # define initLand file
        initFile = paste0(initLandFoder, '/initLand_cellSize_', cellSize, '_rep_', rp, '.RDS')
        # define fileOutput
        fOutput = paste0('mg', '_', mg, '_mgInt_', mgIn, '_rep_', rp)
        # define folderOutput
        fdOutput = paste0('mg', '_', mg, '_mgInt_', mgIn)

        # define management practice and intensity
        management <- c(0, 0, 0, 0)
        if(mg != 0) {
          management[mg] <- managInt[mgIn]
        }

        # send me an email when the last simulation is over
        if(mg == managPractice[length(managPractice)] & mgIn == length(managInt) & rp == reps[length(reps)]) {
          mail <- 'ALL'
        }else {
          mail <- 'FAIL'
        }

# Bash + Rscript
bash <- paste0('#!/bin/bash

#SBATCH --account=def-dgravel
#SBATCH -t 3-00:00:00
#SBATCH --mem=3000
#SBATCH --job-name=', simName, '
#SBATCH --mail-user=willian.vieira@usherbrooke.ca
#SBATCH --mail-type=', mail, '

R --vanilla <<code', '\n',
'library(STManaged)

initLand <- readRDS("', initFile,'")

run_model(steps = 200, initLand = initLand,
    managInt = c(', management[1], ',', management[2], ',', management[3], ',', management[4], '),
    RCP =', RCP, ',
    stoch = TRUE,
    cores = 1,
    outputLand = c(0, 30, 200), # 150 and 1000 years
    rangeLimitOccup = 0.85,
    stateOccup = TRUE,
    saveOutput = TRUE,
    fileOutput = "', fOutput, '",
    folderOutput = "', fdOutput, '")
code')

        # save sh file
        system(paste0("echo ", "'", bash, "' > sub.sh"))

        # run sh
        system('sbatch sub.sh')

        # remove sh file
        system('rm sub.sh')

        cat('                           - job ', job, 'of', length(managPractice) * length(managInt) * length(reps), '\r')
        job <- job + 1
      }
    }
  }
#
