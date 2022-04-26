clear all


global pset6="C:\Users\condo\OneDrive\Documents\School\ECO 348K\ECO-348K-psets\pset6"

cap log close
log using "$pset6\pset6_log.log", replace

*** Q1
	
	use "$pset6\BraceroData.dta", clear
	
	* a)
	
	gen post = 1 if year >= 1962
	replace post = 0 if post == .
	
	preserve
	drop if post == 1
	drop if treated == 1
	mean(yearly_mex_frac)
	restore
	
	preserve
	drop if post == 0
	drop if treated == 1
	mean(yearly_mex_frac)
	restore
	
	preserve
	drop if post == 1
	drop if treated == 0
	mean(yearly_mex_frac)
	restore
	
	preserve
	drop if post == 0
	drop if treated == 0
	mean(yearly_mex_frac)
	restore
	
	/*
	post = 0, treated = 0: .0156
	post = 1, treated = 0: .001841
	post = 0, treated = 1: .3347968
	post = 1, treated = 1: .072632
	
	In the treated states, the termination of the bracero program decreased yearly_mex_frac by .2483
	*/
	
	* b) 
	
	reg yearly_mex_frac post##treated, cluster(year)
	
	/*
	The estimate for post##treated is the same as the one from the 2x2 comparison. 
	*/
	
	* c)
	
	binscatter yearly_mex_frac year, xline(1962) xline(1965) discrete by(treated)
	
	* d) 
	
	areg yearly_mex_frac post##treated ib1961.year##treated, a(year)
	
	coefplot ,vertical keep(*.year#1.treated) omit base rename(*.year#1.treated="") ///
	xlabel(,angle(45)) nolabels color(black) plotregion(color(white)) graphregion(color(white)) ///
	ytitle("Mexican Fraction of Seasonal Workers") xtitle("Year") xline(8 11, lpattern(dash)) ///
	level(95) ylabel(-0.6(.2)0.6) yscale(r(-.6,.6))
	
	* e) 
	
	/*
	Based on the coefficients from d), it doesn't look like any of the years prior to 1962 for the treated group 
	differed from zero statistically. Between 1962 and 1965, the coefficients in the treated group become positive 
	then return to statistical zero following the 1965 cancellation of the program. 
	
	Together with the mostly flat pre-treatment results from the graph in c), it looks like the relative proportion 
	of Mexican workers used in agriculture doesn't change substantially prior to the treatment.  Thus, the parallel
	trends assumption holds. 
	*/
	
	* f)
	
	* for realwage_hourly
	
		* a)
		
		preserve
		drop if post == 1
		drop if treated == 1
		mean(realwage_hourly)
		restore
	
		preserve
		drop if post == 0
		drop if treated == 1
		mean(realwage_hourly)
		restore
	
		preserve
		drop if post == 1
		drop if treated == 0
		mean(realwage_hourly)
		restore
	
		preserve
		drop if post == 0
		drop if treated == 0
		mean(realwage_hourly)
		restore
	
		/*
		post = 0, treated = 0: .8490163
		post = 1, treated = 0: .9785149
		post = 0, treated = 1: .9303454
		post = 1, treated = 1: 1.064346
	
		In the treated states, the termination of the bracero program increased wages by .005
	
		This appears to fall inside the noise floor of the standard errors of the means I generated.
		*/
	
		* b)
		
		reg realwage_hourly post##treated, cluster(year)
		
		/*
		The estimate for post##treated is the same as the one from the 2x2 comparison. At 95% confidence
		the coefficient is a statistical zero.
		*/
		
		* c) 
		
		binscatter realwage_hourly year, xline(1962) xline(1965) discrete by(treated)
		
		* d) 
		
		areg realwage_hourly post##treated ib1961.year##treated, a(year)
	
		coefplot ,vertical keep(*.year#1.treated) omit base rename(*.year#1.treated="") ///
		xlabel(,angle(45)) nolabels color(black) plotregion(color(white)) graphregion(color(white)) ///
		ytitle("Real Hourly Wages") xtitle("Year") xline(8 11, lpattern(dash)) ///
		level(95) ylabel(-0.6(.2)0.6) yscale(r(-.6,.6))
		
		* e)
		
		/*
		The change in real wages before and after the termination of the braceros program appears to 
		be a statistical zero. The trend lines are identical for the graph in c), and the coefficient
		graph generated in d) is flat as a board. 
		
		The parallel trends assumption holds.
		*/
		
	* for domestic_seasonal
	
		* a)
		
		preserve
		drop if post == 1
		drop if treated == 1
		mean(domestic_seasonal)
		restore
	
		preserve
		drop if post == 0
		drop if treated == 1
		mean(domestic_seasonal)
		restore
	
		preserve
		drop if post == 1
		drop if treated == 0
		mean(domestic_seasonal)
		restore
	
		preserve
		drop if post == 0
		drop if treated == 0
		mean(domestic_seasonal)
		restore
	
		/*
		post = 0, treated = 0: 25049.42
		post = 1, treated = 0: 24833.1 
		post = 0, treated = 1: 43726.5
		post = 1, treated = 1: 32695.52
	
		In the treated states, the termination of the bracero program decreased domestic seasonal workers
		by 10,814.
		*/
	
		* b)
		
		reg domestic_seasonal post##treated, cluster(year)
		
		/*
		The estimate for post##treated is the same as the one from the 2x2 comparison. 
		*/
		
		* c) 
		
		binscatter domestic_seasonal year, xline(1962) xline(1965) discrete by(treated)
		
		* d) 
		
		areg domestic_seasonal post##treated ib1961.year##treated, a(year)
	
		coefplot ,vertical keep(*.year#1.treated) omit base rename(*.year#1.treated="") ///
		xlabel(,angle(45)) nolabels color(black) plotregion(color(white)) graphregion(color(white)) ///
		ytitle("Total Domestic Seasonal Workers") xtitle("Year") xline(8 11, lpattern(dash)) ///
		level(95) ylabel(-0.6(.2)0.6) yscale(r(-.6,.6))
		
		* e)
		
		/*
		The coefficients in the pre-1962 period among the treated are again not statistically different 
		from zero. However, domestic migrant laborer numbers exhibit a trend of decline in both treated 
		and untreated groups prior to treatment. This trend remains unchanged during treatment, but the
		trends are different prior to treatment. 
		
		The parallel trends assumption does not hold.
		*/
		
	/*
	The repeal of the braceros program does not appear to have achieved the stated goal of improving wages
	and domestic employment for seasonal workers in the United States. Looks like the Mexican agriculture 
	workers lost, and the American agricultural workers didn't win.
	*/
	
	reg tomatoes_total post##treated, cluster(year)
	
	reg asparagus_total post##treated, cluster(year)
	
	/*
	Farms likely replaced labor with capital following the termination of the bracero program. Tomato 
	cultivation increased dramatically, and asparagus production decreased. It's possible that mechanization
	of farming was also part of the reason that domestic employment of migrant agricultural workers fell prior
	to the termination of the braceros program.
	*/
	
	* g)
	
	use "$pset6\Tomatoes.dta", clear
	
	binscatter tomato_mech year, xline(1962) xline(1965) discrete by(state)
	
	/*
	Termination of the braceros program correlates with in an immediate and dramatic increase in mechanization
	of tomato harvesting, beginning in 1963. Taken together, it appears tomato farmers maximized efficiency by 
	substituting capital for labor in the absence of cheap labor from the braceros program. 
	*/