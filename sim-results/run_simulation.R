###############################
# Automate the creation of R script and bash files to run simulation in the server
# Will Vieira
# May 15, 2019
# Last update: May 15, 2019
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
  RCP = c(0, 4.5)
  managPractice <- 0:4
  managInt <- c(0.0025, 0.01, 0.0025, 0.0025) * 5 # times 5 because one model step equals 5 years
  reps = 1:15

#



# create all subfolders for the simulation output

  mainFolder = 'output'
  if(!dir.exists(mainFolder)) dir.create(mainFolder)
  cc <- paste0('RCP_', RCP)
  manag <- paste0('mg_', managPractice)
  folders <- do.call(paste, c(expand.grid(cc, manag), sep = "_"))
  invisible(sapply(paste0(mainFolder, '/', folders), dir.create))

#



# create bash with Rscript
  initLandFoder = '../initLandscape'
  job = 1
  for(cc in RCP) {
    for(mg in managPractice) {
      for(rp in reps) {

        # define simulation name
        simName = paste0('RCP', cc, 'mg', mg, 'rep', rp)
        # define initLand file
        initFile = paste0(initLandFoder, '/initLand_cellSize_', cellSize, '_rep_', rp, '.RDS')
        # define fileOutput
        fOutput = paste0('RCP_', cc, '_mg', '_', mg, '_rep_', rp)
        # define folderOutput
        fdOutput = paste0('RCP_', cc, '_mg', '_', mg)

        # define management practice and intensity
        management <- c(0, 0, 0, 0)
        if(mg != 0) {
          management[mg] <- managInt[mg]
        }

        # send me an email when the last simulation is over
        if(cc == RCP[length(RCP)] & mg == managPractice[length(managPractice)] & rp == reps[length(reps)]) {
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
    RCP =', cc, ',
    stoch = TRUE,
    cores = 1,
    outputLand = c(30, 50, 100, 200), # 150, 250, 500 and 1000 years
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

        cat('                           - job ', job, 'of', length(RCP) * length(managPractice) * length(reps), '\r')
        job <- job + 1
      }
    }
  }
#
