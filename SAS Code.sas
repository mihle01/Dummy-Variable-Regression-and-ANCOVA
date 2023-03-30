libname HW6 "/home/u60739998/BS 805/Class 6";
filename fib "/home/u60739998/BS 805/Class 6/fibr03_f22.txt";

data HW6.fib_old;
	infile fib;
	input FIQ group disease_sev age;
run;

data fib_temp;
	input @1 FIQ 4.1 @6 group 1. @8 disease_sev 1. @10 age 2.;
	datalines;
	6.2 3 2 19
	;
run;

data HW6.fib_new;
	set Hw6.fib_old fib_temp;
run;

data fib_new_temp;
	set HW6.fib_new;
	
	if group=1 then class1=1; else class1=0;
	if group=2 then class2=1; else class2=0;
run;

/* one-way ANOVA */ *means statement just to check variance;
proc glm data=fib_new_temp;
	class group;
	model FIQ=group;
	lsmeans group/stderr cl adjust=tukey;
	means group;
run;
/* wanted to get t-values for post-hoc test, but diff between groups disappeared if I use tdiff and adjust=tukey in same proc, so just did 2 seperate ones.*/
proc glm data=fib_new_temp;
	class group;
	model FIQ=group;
	lsmeans group/stderr cl tdiff adjust=tukey;
run;
/* linear regression with dummy variables for group */
proc reg data=fib_new_temp;
	model FIQ=class1 class2;
	test class1, class2 = 0;
run;

/* linear regeresison with group variable as ordinal variable */
proc reg data=fib_new_temp;
	model FIQ=group;
run;

/* multiple variable regression */
proc reg data=fib_new_temp;
	model FIQ=class1 class2 disease_sev age / clb;
	test class1, class2 = 0;
run;

/* joint confounding by disesase severity and age? compare unadj and adj model slopes */
/*unadjusted*/
proc reg data=fib_new_temp;
	model FIQ=class1 class2;
	test class1, class2 = 0;
run;
/*adjusted*/
proc reg data=fib_new_temp;
	model FIQ=class1 class2 disease_sev age;
	test class1, class2 = 0;
run;
