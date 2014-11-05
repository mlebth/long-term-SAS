/* Datasets:
	1. hist2
		Variables: 
   			burnsev (s, l, m, h) = wildfire severity
				burn (1-4 in order of increasing severity)
				bcat1 [A = s, l, m; B = h]
				bcat2 [A = s, l; B = m ; C = h]
   			hydr (x, n, l, h) = hydromulch [x = unknown, n = none, l = light, h = heavy]
			lastrx = year of last prescribed burn
   			yrrx1, yrrx2, yrrx3 = years of rx burns since 2003
   			plot = fmh plot #

	2. postsev2
		Variables:
			plot = fmh plot #
			most = monitoring status (FMH system to keep track of how long before/after a burn plot was surveyed)
			type = plot type (Forest, Brush)
			dist = tape distance where measurement was recorded
			vege = vegetation severity, on a scale of 0-5. 
			subs = substrate severity	   
				* for both vege and subs: [0=N/A, 1=heavily burned, 2=moderately burned, 3=lightly burned, 4=scorched, 5=unburned]
					see backside of FMH-21 for more details on categories.
	
	3. seedlings4
		Variables:
			plot = fmh plot #
			most = monitoring status (FMH system to keep track of how long before/after a burn plot was surveyed)
			sspp = species code
			heig = height class
			snum = number of seedlings or resprouts per height class. sdlngs here on out for simplicity.
			stat = L/D (live or dead)
			Date = date of plot visit;
	
	4. saplings5
		Variables:
			plot = fmh plot #
			most = monitoring status (FMH system to keep track of how long before/after a burn plot was surveyed)
			sspp = species code
			diam = dbh
			heig = height class
			stat = L/D (live or dead)
			Date = date of plot visit;
	
	5. overstory4
		Variables:	
			plot = fmh plot #
			most = monitoring status (FMH system to keep track of how long before/after a burn plot was surveyed)
			sspp = species code
			quar = plot quarter	(1-4)
			tagn = individual tree tag number
			diam = dbh
			crwn = relative dominance of crown
			stat = L/D (live or dead)
			Date = date of plot visit;

	6. shrubs5
		Variables:
			plot = fmh plot #
			most = monitoring status (FMH system to keep track of how long before/after a burn plot was surveyed)
			sspp = species code
			agec = age class [R = resprout, I = immature, M = mature]
			coun = count
			stat = L/D (live or dead)
			Date = date of plot visit;

	7. herbs3
		Variables:
			plot = fmh plot #
			most = monitoring status (FMH system to keep track of how long before/after a burn plot was surveyed)
			sspp = species code
			quad = quadrat (1-10)
			coun = count
			stat = L/D (live or dead)
			Date = date of plot visit;

	8. trans3
		Variables:
			plot = fmh plot #
			most = monitoring status (FMH system to keep track of how long before/after a burn plot was surveyed)
			sspp = species code
			poin = numbered point on tape (0.3m = point 1,  0.6m = point 2, etc.)
			Tape = distance on tape measure
			heig = height of tallest plant at any given point
			Date = date of plot visit;	
	
	9. canopy2
		Variables:
			plot = fmh plot #
			year = year of data collection
			bsev = burn severity [U = unburned, S = scorched, L = lightly burned, M = moderately burned, H = heavily burned]	
			orig, qua1, qua2, qua3, qua4 = canopy cover measurements at 4 corners and origin
			cavg = (qua1 + qua2 + qua3 + qua4 + orig)/5)

	10. piquil
		Variables: hist2 + seedlings4 + shrubs5
		Notes: This is a dataset including pines and oaks as seedlings (measured in 10mx5m subplot), and ilex as a shrub (measured in 1mx50m subplot). 
			May or may not be useful. piquil2 merges with plot history and piquil3 separates dates to pre- and post-fire.

seedlings5 (seedlings4 + hist2 + canopy2) */
