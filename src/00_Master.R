source("src/01_DataPreparation.R")
source("src/99_misc.R")

require(ggplot2)
require(reshape2)
require(plotly)
require(dplyr)
require(htmlwidgets)
require(cowplot)

dir.create("results", showWarnings = F)

source("src/11_Summary.R")
source("src/12_Trends.R")
source("src/13_Groups.R")
source("src/14_IndividualData.R")
source("src/15_MissingsAnalysis.R")