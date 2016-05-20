declare name		"ambixPanner_o5";
declare version 	"1.0";
declare author 		"AmbisonicDecoderToolkit";
declare license 	"GPL";
declare copyright	"(c) Aaron J. Heller 2013";

math = library("math.lib");    // for PI
music = library("music.lib");  // for "noise"

process = ambix_panner(5);

ambix_panner(N) = _,test_sig : select2(test_ui) <: gain(pg) : ambi_order_gates((N+1)^2)
with {

  // button for pink noise test signal
  test_ui = button("[99]test");
  test_sig = pink(music.noise):gain(1/4);

  // azimuth and elevation panners, smooth to "dezipper" controls.
  az = (math.PI/180.0)*hslider("[1]azi[unit:deg]", 0, -180, 180, 1) : dezipper;
  el = (math.PI/180.0)*hslider("[2]ele[unit:deg]", 0,  -90,  90, 1) : dezipper;

  // spherical to cartesian
  r = 1;
  x = r * cos(az)*cos(el);
  y = r * sin(az)*cos(el);
  z = r * sin(el);

  ambi_order_gates(N) = par(i, math.count(pg), gate(i<N))
  with{
	gate(1) = _;
	gate(0) = !;
	};

  // panner gains ACN order, SN3D normalization
  //  generated by apf.ambix_panner(5)
  pg = (1,
        y,
        z,
        x,
        sqrt(3)*x*y,
        sqrt(3)*y*z,
        (1/2)*(3*pow(z, 2) - 1),
        sqrt(3)*x*z,
        (1/2)*sqrt(3)*(pow(x, 2) - pow(y, 2)),
        (1/4)*sqrt(10)*(3*pow(x, 2)*y - pow(y, 3)),
        sqrt(15)*x*y*z,
        (1/4)*sqrt(6)*y*(5*pow(z, 2) - 1),
        (1/2)*z*(5*pow(z, 2) - 3),
        (1/4)*sqrt(6)*x*(5*pow(z, 2) - 1),
        (1/2)*sqrt(15)*z*(pow(x, 2) - pow(y, 2)),
        (1/4)*sqrt(10)*(pow(x, 3) - 3*x*pow(y, 2)),
        (1/8)*sqrt(35)*(4*pow(x, 3)*y - 4*x*pow(y, 3)),
        (1/4)*sqrt(70)*z*(3*pow(x, 2)*y - pow(y, 3)),
        (1/2)*sqrt(5)*x*y*(7*pow(z, 2) - 1),
        (1/4)*sqrt(10)*y*z*(7*pow(z, 2) - 3),
        (1/8)*(35*pow(z, 4) - 30*pow(z, 2) + 3),
        (1/4)*sqrt(10)*x*z*(7*pow(z, 2) - 3),
        (1/4)*sqrt(5)*(pow(x, 2) - pow(y, 2))*(7*pow(z, 2) - 1),
        (1/4)*sqrt(70)*z*(pow(x, 3) - 3*x*pow(y, 2)),
        (1/8)*sqrt(35)*(pow(x, 4) - 6*pow(x, 2)*pow(y, 2) + pow(y, 4)),
        (3/16)*sqrt(14)*(5*pow(x, 4)*y - 10*pow(x, 2)*pow(y, 3) + pow(y, 5)),
        (3/8)*sqrt(35)*z*(4*pow(x, 3)*y - 4*x*pow(y, 3)),
        (1/16)*sqrt(70)*(9*pow(z, 2) - 1)*(3*pow(x, 2)*y - pow(y, 3)),
        (1/2)*sqrt(105)*x*y*z*(3*pow(z, 2) - 1),
        (1/8)*sqrt(15)*y*(21*pow(z, 4) - 14*pow(z, 2) + 1),
        (1/8)*z*(63*pow(z, 4) - 70*pow(z, 2) + 15),
        (1/8)*sqrt(15)*x*(21*pow(z, 4) - 14*pow(z, 2) + 1),
        (1/4)*sqrt(105)*z*(pow(x, 2) - pow(y, 2))*(3*pow(z, 2) - 1),
        (1/16)*sqrt(70)*(pow(x, 3) - 3*x*pow(y, 2))*(9*pow(z, 2) - 1),
        (3/8)*sqrt(35)*z*(pow(x, 4) - 6*pow(x, 2)*pow(y, 2) + pow(y, 4)),
        (3/16)*sqrt(14)*(pow(x, 5) - 10*pow(x, 3)*pow(y, 2) + 5*x*pow(y, 4)) );
};

// gain bus
gain(c) = R(c) with {
  R((c,cl)) = R(c),R(cl);
  R(1)      = _;
  R(0)      = !;
  R(float(0)) = R(0);
  R(float(1)) = R(1);
  R(c)      = *(c);
};

pink = f : (+ ~ g) with {
  f(x) = 0.04957526213389*x - 0.06305581334498*x' + 0.01483220320740*x'';
  g(x) = 1.80116083982126*x - 0.80257737639225*x';
};

// UI "dezipper"
smooth(c) = *(1-c) : +~*(c);
dezipper = smooth(0.999);

