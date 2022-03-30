clear all


global pset3="C:\Users\condo\OneDrive\Documents\School\ECO 348K\pset3"

cap log close
log using "$pset3\pset3_log.log", replace

*** Q1
	
	use "$pset3\VisibleHand.dta", clear
	*reg y x [w = stateweight], r
	
	* a)
	
	/* 
	highquality = Advertisement quality, "low" or "high"
	holiday = Gift holiday, binary for if the transaction was near Christmas/Valentine's
	ipodtype = current or outdated, and generation
	price = asking price, 90 110 or 130
	night = post time, day or night
	*/
	
	* b) 
	
	mean(highquality) if white == 1
	mean(highquality) if white == 0
		
	mean(holiday) if white == 1
	mean(holiday) if white == 0
	
	mean(ipodtype) if white == 1
	mean(ipodtype) if white == 0
	
	mean(price) if white == 1 
	mean(price) if white == 0 
	
	mean(night) if white == 1
	mean(night) if white == 0
	
	*gen typebinary = .
	*replace typebinary = 1 if ipodtype == "5th gen.\ (current)"
	
	/*
	Based on the provided confidence intervals at p = .95, none of the conditional means 
	are verifiably different from one another. The conditional means of each variable fall
	within the confidence interval of the opposite condition and vice versa. This is good because
	it means our regression analysis won't suffer from collinearity between our outcome variables 
	and dependent variable, whiteness.
	*/
	
	* c)
	
	/*
	reponses = number of responses to post
	anyoffer = was there an offer in response to the post?
	bestoffer = what was the highest offered price in response to the post?
	*/
	
	reg responses white
	reg anyoffer white
	
	/*
	The coefficient values in the above regressions are not significant at p = .95
	*/
	
	* d)
	
	/*
	Selection bias should be approximately equal to zero, since the samples for both
	treated and untreated populations are roughly equal in all other characteristics.
	*/
	
	* e) 
	
	sum bestoffer
	reg bestoffer white
	
	/*
	The ATE of whiteness in the model is 2.995, significant at p = .95. Relative to the mean 
	value of bestoffer, this is roughly a ~4% increase in offer price compared to the untreated.
	
	The sample is smaller because not all listings received offers, and Stata omits NA values for
	the target IV automatically.
	*/
	
	* f) 
	
	gen newvar = bestoffer
	replace newvar = 0 if newvar == .
	
	reg newvar white
	
	/*
	The coefficient is now larger - including some of the variation we previously captured in the 
	regressions in c). Unfortunately, it is also no longer signficant at p = .95.
	*/
	
	* g)
	
	preserve
	
	drop if highquality == 1
	reg newvar white
	restore
	
	preserve 
	
	drop if highquality == 0 
	reg newvar white
	restore
	
	reg newvar white highquality
	
	/*
	The first regression didn't return statistically significant results, but the 
	regression containing only the high quality sample showed a much higher ATE than any previous
	regression with statistical signficance at p = .95. 
	
	Neither variable was statistically signficant in the third regression, but the estimated ATEs 
	showed a sizeable positive effect from both whiteness and listing quality. Whiteness had a larger
	effect by a factor of five. 
	*/
	
	* h)
	
	/*
	Looking at the results from d) through g), I would feel reasonably confident stating that 
	in the sample there was a positive impact of whiteness on the selling price.
	
	This difference was especially large when the listing was already a "high quality" advertisement. 
	*/
	
*** Q2

	use "$pset3\ClassSizeRD.dta", clear
	
	* a)
	
	/*
	``Twenty-five children may be put in charge of one teacher. If the number in
	the class exceeds twenty-five but is not more than forty, he should
	have an assistant to help with the instruction. If there are more
	than forty, two teachers must be appointed''
	*/
	
	* b)
	
	/*
	M's rule is a source of exogenous variation in class size that is not collinear
	with other variables in the data. The running variable is enrollment cohorts,
	and class size as governed by M's rule is discontinuous across enrollment cohort size.
	Test scores are the outcome variable.
	*/
	
	* c) 
	
	scatter classize cohsize, xline(40 80 120 160)
	
	/*
	Class size is discontinuous with cohort size according to Ms rule.
	*/
	
	* d)
	
	gen center40=cohsize-40
	
	gen above40 = 1 if cohsize>40
	replace above40 = 0 if above40==.
	
	gen above80 = 1 if cohsize>80
	replace above40 = 0 if above40==.
	
	*bandwidth 20
	preserve
	drop if cohsize>60
	drop if cohsize<20
	reg classize above40
	restore
	
	preserve
	drop if cohsize>100
	drop if cohsize<60
	reg classize above80
	restore
	
	*bandwidth 30
	preserve
	drop if cohsize>70
	drop if cohsize<10
	reg classize above40
	restore
	
	preserve
	drop if cohsize>110
	drop if cohsize<50
	reg classize above80
	restore
	
	/* 
	Stata dropped above40/above80 from the regression because of collinearity?
	*/
	
	* e)
	
	drop if cohsize>80
	
	/*
	From the paper:
	"To see how this variation comes about, note that according to Maimonides' rule, class size
	increases one-for-one with enrollment until 40 pupils are enrolled,
	but when 41 students are enrolled, there will be a sharp drop in
	class size, to an average of 20.5 pupils. Similarly, when 80 pupils
	are enrolled, the average class size will again be 40, but when 81
	pupils are enrolled the average class size drops to 27"
	*/
	
	* f)
	
	scatter tipuach cohsize, xline(40)
	
	/*
	Looks continuous across cohort size at 40. This is beneficial, since we won't be getting 
	inteference from endogenous collinear variables in our models.
	*/
	
	* g)
	preserve
	g count=1
	collapse (sum) count, by(cohsize)
	
	scatter count cohsize, xline(40)
	
	/*
	Count IS discontinuous at 40. I've been wondering this whole time if administrators would
	pack students into classrooms just under the dividing threshold to keep class sizes larger and
	reduce cost. The opposite seems to be true. I can't think of a reason this would necessarily be 
	bad if everything else is accounted for, but it does raise an eyebrow. 
	*/
	
	* h) 
	
	restore
	preserve
	drop if cohsize>80
	reg avgscore classize
	restore
	
	preserve
	drop if cohsize>60
	drop if cohsize<20
	reg avgscore classize above40
	restore
	
	preserve
	drop if cohsize>70
	drop if cohsize<10
	reg avgscore classize above40
	restore
	
	/*
	There's definitely a statistically significant impact of class size on test scores. The improvement
	in performance from the threshold class size drop is pretty large, as is the impact of class size alone.
	Both are statistically significant. Impact of class size is actually bigger in the RD model. Project STAR 
	seems a lot more difficult to implement on a large scale than the M rule - it still has valid and relevant
	results, but I'm a lot more optimistic about the implementation of these findings.
	*/
	
	* i)
	
	*group our center40 variable into bins of 2 (e.g., center40=0 and center40=1 will now both equal zero).
	g center40_2 = floor(center40/2)*2
	*keep only observations with center40 between -20 and 20
	keep if abs(center40)<=20
	*take the mean of test scores and class size by our grouped bins
	collapse (mean) classize avgscore, by(center40_2)
	*create a scatter plot and fit a line on both sides of the cutoff.
	scatter avgscore center40_2, ylabel(40(5)80) || ///
	lfit avgscore center40_2 if center40_2<0 || ///
	lfit avgscore center40_2 if center40_2>=0
	*create a scatter plot and fit a line on both sides of the cutoff.
	scatter classize center40_2, ylabel(10(5)40) || ///
	lfit classize center40_2 if center40_2<0 || ///
	lfit classize center40_2 if center40_2>=0
	
	/*
	Well, now I know I did most of d) wrong but I'm not certain how to correct it with the time I have left before additional penalties beyond 24hrs set in. I'll review on an ongoing basis. 
	
	The discontinuity in the second graph is about 10, and in the first is just under 5. I know this because it should mirror the discontinuities from the models in h)
	*/