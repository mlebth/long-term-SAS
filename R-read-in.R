setwd('D:/Research/FMH Raw Data, SAS, Tables/FFI long-term data')

# read in all datasets
plothist <- read.csv('plothistory.csv')
postsev <- read.csv('postburnsev.csv')
canopy <- read.csv('cc.csv')
seedlings <- read.csv('Seedlings-allyrs.csv')
poles <- read.csv('Saplings-allyrs.csv')
overstory <- read.csv('Overstory-allyrs.csv')
shrub <- read.csv('Shrubs-allyrs.csv')
herb <- read.csv('Herbaceous-allyrs.csv')
trans <- read.csv('PointIntercept-allyrs.csv')

#POST-BURN SEV
library(plyr)
postsev$year <- as.Date(postsev$Date, "%m/%d/%Y")
postsev$year <- format(postsev$year, "%Y")
postsev <- rename(postsev, c("MacroPlot.Name"="plot", "PlotType"="type", 
                              "Veg"="vege", "Sub"="subs"))
myvars <- names(postsev) %in% c("plot", "year", "type", "vege", "subs") 
postsev1 <- postsev[myvars]
postsev2 <- arrange(postsev1, plot)

dummydat <- data.frame (id=1:3, plot=9999, year=9999, type="     ", vege=9, subs=9)
postsev2x <- merge(postsev2, dummydat, "plot")
########## left off here 2/12/15 still trying to merge successfully
data postsev2x; set postsev1 dummydatx; run; * N = 1230;
proc sort data=postsev2x; by plot type; run;
/*proc print data=postsev2x; title 'postsev2x'; run; */

# -----------CANOPY
# averaging measurements at each location;
canopy$qua1 <- ((canopy$qu1a + canopy$qu1b + canopy$qu1c + canopy$qu1d) / 4)
canopy$qua2 <- ((canopy$qu2a + canopy$qu2b + canopy$qu2c + canopy$qu2d) / 4)
canopy$qua3 <- ((canopy$qu3a + canopy$qu3b + canopy$qu3c + canopy$qu3d) / 4)
canopy$qua4 <- ((canopy$qu4a + canopy$qu4b + canopy$qu4c + canopy$qu4d) / 4)
canopy$orim <- ((canopy$oria + canopy$orib + canopy$oric + canopy$orid) / 4)
# conversion factor
canopy$fact <- (100/96)
# converting to canopy cover from canopy openness
canopy$cov1 <- -((qua1 * fact) - 100)
canopy$cov2 <- -((qua2 * fact) - 100)
canopy$cov3 <- -((qua3 * fact) - 100)
canopy$cov4 <- -((qua4 * fact) - 100)
canopy$orig <- -((orim * fact) - 100)
# getting mean canopy cover per plot
canopy$covm <- ((cov1 + cov2 + cov3 + cov4 + orig)/5)

nrow(canopy) #N = 197
