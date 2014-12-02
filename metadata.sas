/* Datasets:
	* postsev2
		Variables:
			plot = fmh plot #
			year = year of plot visit
			type = plot type (Forest, Brush)
			dist = tape distance where measurement was recorded
			vege = vegetation severity, on a scale of 0-5. 
			subs = substrate severity	   
				* for both vege and subs: [0=N/A, 1=heavily burned, 2=moderately burned, 3=lightly burned, 4=scorched, 5=unburned]
					see backside of FMH-21 for more details on categories.
	   		burnsev (u, s, l, m, h) = wildfire severity
			burn (0-4 in order of increasing severity)
			bcat1 [AA = u, A = s, l, m; B = h]
			bcat2 [AA = u, A = s, l; B = m ; C = h]
   			hydr (x, n, l, h) = hydromulch [x = unknown, n = none, l = light, h = heavy]
			lastrx = year of last prescribed burn
   			yrrx1, yrrx2, yrrx3 = years of rx burns since 2003

	* seedlings4
		Variables:
			plot = fmh plot #
			sspp = species code
			heig = height class
			snum = number of seedlings or resprouts per height class. sdlngs here on out for simplicity.
			stat = L/D (live or dead)
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
			year = year of plot visit;

	* shrubs5
		Variables:
			plot = fmh plot #
			most = monitoring status (FMH system to keep track of how long before/after a burn plot was surveyed)
			sspp = species code
			agec = age class [R = resprout, I = immature, M = mature]
			coun = count
			stat = L/D (live or dead)
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
			Date = date of plot visit;	
	
	* canopy3
		Variables:
			plot = fmh plot #
			year = year of data collection
			*conversion factor;
			fact = (100/96);
			*converting to canopy cover from canopy openness;
			cov1 = -((qua1 * fact) - 100);
			cov2 = -((qua2 * fact) - 100);
			cov3 = -((qua3 * fact) - 100);
			cov4 = -((qua4 * fact) - 100);
			orig = -((orim * fact) - 100);
			*getting mean canopy cover per plot;
			covm = ((cov1 + cov2 + cov3 + cov4 + orig)/5); 

	* piquil
		Variables: hist2 + seedlings4 + shrubs5
		Notes: This is a dataset including pines and oaks as seedlings (measured in 10mx5m subplot), and ilex as a shrub (measured in 1mx50m subplot). 
			May or may not be useful. piquil2 merges with plot history and piquil3 separates dates to pre- and post-fire.

	*all
		just what it sounds like.
