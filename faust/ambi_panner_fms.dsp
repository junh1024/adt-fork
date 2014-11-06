declare name		"AmbiPanner3";
declare version 	"1.0";
declare author 		"AmbisonicDecoderToolkit";
declare license 	"GPL";
declare copyright	"(c) Aaron J. Heller 2013";

math = library("math.lib");    // for PI
music = library("music.lib");  // for "noise"

process = fms_panner(3);

fms_panner(N) = _,test_sig : select2(test_ui) <: gain( par(i,(N+1)^2,fms(i)) )  
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

  // Furse-Malham Set in Cartesian coordinates
  //   FMS definitions assume x^2 + y^2 + z^2 = 1
  //
  // degree = 0
  fms( 0) = sqrt(1/2); //W
  // degree = 1
  fms( 1) = x; //X
  fms( 2) = y; //Y
  fms( 3) = z; //Z
  // degree = 2
  fms( 4) =  (1/2) * (3 * z * z - 1); // R
  fms( 5) =  2 * z * x; // S
  fms( 6) =  2 * y * z; // T
  fms( 7) =  x*x - y*y; // U
  fms( 8) =  2 * x * y; // V
  // degree = 3
  fms( 9) = (1/2) * z * (5 * z * z - 3);          // K
  fms(10) = sqrt(135/256) * x * (5 * z * z - 1);  // L
  fms(11) = sqrt(135/256) * y * (5 * z * z - 1);  // M
  fms(12) = sqrt(27/4) * z * (x*x - y*y);         // N
  fms(13) = sqrt(27) * x * y * z;                 // O
  fms(14) = x * (x*x - 3*y*y);                    // P
  fms(15) = y * (3*x*x - y*y);                    // Q

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


