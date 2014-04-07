declare name		"ADT Shelf";
declare version 	"1.0";
declare author 		"Aaron J. Heller <heller@ai.sri.com>";
declare license 	"GPL";
declare copyright	"(c) Aaron J. Heller 2013";

math = library("math.lib");

// gain bus
gain(c) = R(c) with {
  R((c,cl)) = R(c),R(cl);
  R(1)      = _;
  R(0)      = !;
  R(float(0)) = R(0);
  R(float(1)) = R(1);
  R(c)      = *(c);
};

// fir filter
fir(c) = R(c) :>_ with {
  R((c,lc)) = _<: R(c), (mem:R(lc));
  R(c)      = gain(c);
};

// phase-matched bandsplitter from BLaH3
xover(freq,n) = par(i,n,xover1) with {

	sub(x,y) = y-x;

	k = tan(math.PI*float(freq)/math.SR);
	k2 = k^2;
	d =  (k2 + 2*k + 1);
	//d = (k2,2*k,1):>_;
	// hf numerator
	b_hf = (1/d,-2/d,1/d);
	// lf numerator
	b_lf = (k2/d, 2*k2/d, k2/d);
	// denominator
	a = (2 * (k2-1) / d, (k2 - 2*k + 1) / d);
	//
	xover1 = _:sub ~ fir(a) <: fir(b_lf),fir(b_hf):*(-1),_;
};

shelf(freq,g_lf,g_hf) = xover(freq,1) : gain(g_lf),gain(g_hf):>_;

// testing

//process = par(i,2,shelf(400,2,0.5));

process = xover(4000,1);