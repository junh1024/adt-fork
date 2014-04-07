declare name		"AmbiPanner5_SN2D";
declare version 	"1.0";
declare author 		"AmbisonicDecoderToolkit";
declare license 	"GPL";
declare copyright	"(c) Aaron J. Heller 2013";

math = library("math.lib");    // for PI
music = library("music.lib");  // for "noise"

process =  _,test_sig : select2(test_ui)<:encoder(5,az);

// button for pink noise test signal
test_ui = button("test");
test_sig = pink(music.noise):gain(1/4);

pink = f : (+ ~ g) with {
  f(x) = 0.04957526213389*x - 0.06305581334498*x' + 0.01483220320740*x'';
  g(x) = 1.80116083982126*x - 0.80257737639225*x';
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



// UI "dezipper"
smooth(c) = *(1-c) : +~*(c);
dezipper = smooth(0.999);

az = (math.PI/180.0)*hslider("azi", 0, -180, 180, 1) : dezipper;

encoder(0, a) = _:*(sqrt(1/2));
encoder(n, a) = (encoder(n-1, a), _*cos(n*a), _*sin(n*a));