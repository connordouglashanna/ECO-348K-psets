clear all


global pset4="C:\Users\condo\OneDrive\Documents\School\ECO 348K\pset4"

cap log close
log using "$pset4\pset4_log.log", replace

*** Q1
	
	use "$pset4\ClassSizeRKD.dta", clear
	
	* a)
	
	/*
	See handwritten notes
	*/
	
	* b)
	
	/*
	See handwritten notes
	*/
	
	* c)
	
	/*
	See handwritten notes
	*/
	
	* d)
	
	preserve
	drop if cohsize>80
	
	gen center40=cohsize-40
	
	gen above40 = 1 if cohsize>40
	replace above40 = 0 if above40==.
	
	reg num_classrooms above40##c.center40 if abs(center40)<=40, cl(coh_id)
	
	/*
	"1.above40" is the discontinuity magnitude
	"center40" is the slope of the line before/after the cutoff
	"above40#c.center40" is the change in slope after the cutoff
	*/
	
	* e)
	
	reg avgscore above40##c.center40 if abs(center40)<=40, cl(coh_id)
	
		* i)
		
		/*
		Both discontinuities are positive and statistically significant. The slope
		change after the cutoff is also positive and statistically significant for
		the scores regression, but isn't statistically significant in the regression
		on number of classes. The combined effect at the cutoff is likely to be
		positive, as described in the notes for c). The number of classes does not 
		appear to have an effect on the slope.
		*/
	
		* ii)
		
		/*
		Class size alone has a negative correlation with scores, since we can observe
		the combined improvement effect when class size and no. classrooms change
		at the discontinuity. We can also observe the negative relationship between class
		size and test scores overall, and the positive change in the correlation coefficient
		of cohort size and scores post-discontinuity where the decreasing correlation magnitude
		between cohort size and class size causes increases in cohort size to become less 
		correlated with poor outcomes.
		*/
		
*** Q2
	
	use "$pset4\SpeedDiscount.dta", clear
	
	* a)
	
	gen whitelenient = (white * lenient)
	
	areg discount white lenient whitelenient i.year, a(countynum) r
	
	/*
	The interaction term is the change in discount rate when the driver was white AND the
	officer was lenient. We can observe that the lenient officers are more likely to
	discount a white driver, and thus there is racial bias in traffic policing within 
	the sample. 
	*/
	
	* b)

	gen femalelenient = (female * lenient)
	gen agelenient = (age * lenient)
	gen above25klenient = (above25k * lenient)
	gen anytixlenient = (anytix * lenient)
	gen instatelenient = (instate * lenient)
	
	areg discount female lenient femalelenient i.year, a(countynum) r
	areg discount age lenient agelenient i.year, a(countynum) r
	areg discount above25k lenient above25klenient i.year, a(countynum) r
	areg discount anytix lenient anytixlenient i.year, a(countynum) r
	areg discount instate lenient instatelenient i.year, a(countynum) r
	areg discount blackmale blackfemale hispmale hispfemale whitefemale lenient lenient##c.blackmale lenient##c.blackfemale lenient##c.hispmale lenient##c.hispfemale lenient##c.whitefemale i.year, a(countynum) r