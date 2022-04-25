clear all


global pset5="C:\Users\condo\OneDrive\Documents\School\ECO 348K\ECO-348K-psets\pset5"

cap log close
log using "$pset5\pset5_log.log", replace

*** Q1
	
	use "$pset5\LotteryExample.dta", clear
	
	* a)
	
	* see accompanying PDF
	
	* b)
	
	* see accompanying PDF
	
	* c)
	
	reg test_score attends
	
	/*
	The omitted variable bias for attends is positive. Based on the generation function you'd expect a coefficient of
	5, but the regression returns a coefficient of 10.
	*/
	
	* d)
	
	reg test_score attends ability parent_income
	
	/*
	These coefficients match up almost perfectly to the coefficients in the formula. The true values fall within the 
	confidence interval of the coefficients for all three variables.
	*/
	
	* e)
	
	* see accompanying PDF
	
	* f) 
	
	ivregress 2sls test_score (attends = lottery), r
	
	/*
	It's the same effect size as the true effect of attendance!
	*/
	
	* g) 
	
	* first stage
	
	reg attends lottery
	
	* reduced form
	
	reg test_score lottery
	
	/* 
	Lottery win increases attendance likelihood by 66%, which conveniently is the percentage of the variation in
	test_score previously accounted for by attends that appears in the reduced form regression.
	*/
	
	* h)
	
	/*
	Assuming no defiers, LATE is the effect of lottery on test_score measured by the 2sls regression from f)
	
	Compliers are people who would not have attended a charter school had they not won the lottery
	
	Deniers are people who will refuse to attend should they win the lottery, but may attend otherwise. 
	DNE under monotonicity assumption. 
	
	Always-takers are people who would attend regardless of lottery status. 
	
	Never-takers are people who would not attend regardless of lottery status. 
	*/
	
*** Q2

	* a)
	
	/*
	Zimmerman uses the presence of a grade threshold for admissions eligibility to instrument for college 
	attendance. 
	
	Zimmerman chooses the least prestigious school in the University of Florida system to satisfy the monotonicity
	assumption, since it can be assumed that if students don't meet the requirements for the most lenient school 
	they will not be declining to attend in favor of a better offer. 
	
	Zimmerman assumes grades affect income only through their determination of attendance status, theoretically
	satisfying the exclusion restriction assumption. 
	
	Zimmerman also assumes that parent income, ability, etc are continuous through the cutoff. 
	*/
	
	* b)
	
	/*
	Looking for small classrooms' effect on test scores. 
	
	Random assignment to treatment. 
	
	IV instrument is intended treatment
	
	first stage:
	reg test_score small_class
	
	reduced:
	reg test_score assignment
	
	2sls:
	ivregress 2sls test_score (small_class = assignment), r
	
	Assumptions:
	assignment only affects test_score through variation in small_class (exclusive restriction)
	satisfied since assignment is randomly assigned
	
	where assignment occurs it moves small_class in one direction only (monotonicity)
	Probably satisfied, assignment moves students into smaller classrooms and it's probably the case
	that classroom transfers are in the noise floor/not deliberate and widespread
	
	assignment is unaffected by endogenous variables in the model
	satisfied since assignment is exogenous and random
	*/