/* Datasets:
	* plothist
		Variables:
			plot = fmh plot #
			year = year of plot visit
			typecat = plot type (f, b = Forest, Brush)
	   		burnsev (u, s, l, m, h) = wildfire severity
			burn (0-4 in order of increasing severity)
			bcat1 [AA = u, A = s, l, m; B = h]
			bcat2 [AA = u, A = s, l; B = m ; C = h]
   			hydr (x, n, l, h) = hydromulch [x = unknown, n = none, l = light, h = heavy]
			lastrx = year of last prescribed burn
   			yrrx1, yrrx2, yrrx3 = years of rx burns since 2003
			aspect = nort, sout, east, west
			elev = elevation (m) above sea level
			slope = % slope from topo
			soil = soil type
		*****plothist is merged with all other datasets. all of these variables are also
			in the following datasets.

	* seedlings4
		Variables:
			plot = fmh plot #
			sspp = species code
			heig = height class
			snum = number of seedlings or resprouts per height class. sdlngs here on out for simplicity.
			stat = L/D (live or dead) 
			covm = mean canopy cover
			year = year of plot visit;
	
	*seedlingprobspp
		same as seedlings4, with only CAAM (2x in 1999) and ILVO (9x in 1999)

	* saplings5
		Variables:
			plot = fmh plot #
			sspp = species code
			diam = dbh
			heig = height class
			stat = L/D (live or dead) 
			covm = mean canopy cover
			year = year of plot visit;
	
	*saplingprobspp
		same as saplings5 only with only ILVO (3 from 1999)

	* overstory4
		Variables:	
			plot = fmh plot #
			sspp = species code
			quar = plot quarter	(1-4)
			tagn = individual tree tag number
			diam = dbh
			crwn = relative dominance of crown
			stat = L/D (live or dead) 
			covm = mean canopy cover
			year = year of plot visit;

	* shrubs5
		Variables:
			plot = fmh plot #
			most = monitoring status (FMH system to keep track of how long before/after a burn plot was surveyed)
			sspp = species code
			agec = age class [R = resprout, I = immature, M = mature]
			coun = count
			stat = L/D (live or dead) 
			covm = mean canopy cover
			Date = date of plot visit;

	* shrubsprobspp
		same as shrubs 5 but with overstory trees marked as shrubs (2002, 2005, 2006)

	* herb5
		Variables:
			plot = fmh plot #
			sspp = species code
			quad = quadrat (1-10)
			coun = count
			stat = L/D (live or dead) 
			covm = mean canopy cover
			year = year of plot visit;

	*herbprobspp
		same as herb5, only SMILA (3, 1999) and RUBUS (1, 1999)

	* trans3
		Variables:
			plot = fmh plot #
			most = monitoring status (FMH system to keep track of how long before/after a burn plot was surveyed)
			sspp = species code
			poin = numbered point on tape (0.3m = point 1,  0.6m = point 2, etc.)
			Tape = distance on tape measure
			heig = height of tallest plant at any given point 
			covm = mean canopy cover
			Date = date of plot visit;	

	* piquil
		QUMAx, QUMA3, PITAx pulled from alld (supb seed) & ILVOx from alld (subp shru)
		Notes: This is a dataset including pines and oaks as seedlings (measured in 10mx5m subplot), 
		and ilex as a shrub (measured in 1mx50m subplot). 

	*alld
					   #    Variable    Type    Len    Format     Informat
                       3    stat        Char      1    $1.        $1.
                       6    subp        Char      4
                      19    typecat     Char      1
                       5    year        Num       8    BEST12.    BEST32.
                      12    yrrx1       Num       8    BEST12.    BEST32.
                      13    yrrx2       Num       8    BEST12.    BEST32.
                      14    yrrx3       Num       8    BEST12.    BEST32.
					  26    agec        Char      1    $1.        $1.
                      18    aspect      Char      4
                      22    bcat1       Char      1
                      23    bcat2       Char      1
                      21    burn        Num       8
                      10    burnsev     Char      1    $1.        $1.
                       4    coun        Num       8    BEST12.    BEST32.
                       8    covm        Num       8
                      25    crwn        Num       8    BEST12.    BEST32.
                      24    diam        Num       8    BEST12.    BEST32.
                      15    elev        Num       8    BEST12.    BEST32.
                       2    heig        Num       8    BEST12.    BEST32.
                       9    hydr        Char      1    $1.        $1.
                      11    lastrx      Num       8    BEST12.    BEST32.
                      20    meansev     Num       8
                       1    plot        Num       8    BEST12.    BEST32.
 					  27    prpo        Char      4
                      16    slope       Num       8    BEST12.    BEST32.
                      17    soil        Char      4
                       7    sspp        Char      5
*/

/*   ***************ORGANIZATION OF DATA FOR ANALYSES;
*******TAKEN FROM DATA MANIPULATION FILE;
10 herbaceous subplots (no woody plants) - species, # stems (pooled)
transect - species (all plants), ht
seedling subplot - species, ht class
mature trees - plot. dbh, species
pole trees subplot - species, dbh, ht class
shrubs subplot - species, stem count (pooled) 

independent variables:
	Fixed: Canopy cover, burn severity, soil type, hydromulch (0,1,2), 
           elevation, aspect (NESW), slope (%), year, prpo (pre, post fire)
	Random: plot
dependent variables:
	Species (all samples)
		presence/absence by species
		richness
		other measures of diversity and composition
	plant cover (transect)- hits on transect - check values
	stem count - wherever an individual has >1 stem, they are treated as separate. in lieu of N.
	height of each stem. transect: cm,  seedlings& poles: class, shrubs & trees: not measured
	DBH - pole & mature trees 
	canopy cover - densiometer in 5 places/plot x 4 readings/place = 20 readings/plot. converted to 1 #/plot.

Nesting:
	--site (Bastrop/Buescher)
		--soil type	/ --burn severity
			--plot (FMH, invasive, or demog)
				--veg

Strategy:
	--for main FMH datasets (herbaceous, shrubs, 'seedlings', pole and mature trees): merge plot history 
	  and canopy cover with each dataset  (DONE as of Feb 2015)
	--point transect: treat as other datasets for extra info (messy method)
	--invasives: logistic regressions with p/a?
	--demography: depends on data quality/quantity
*/
