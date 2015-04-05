declare name		"RotateZ";
declare version 	"1.0";
declare author 		"AmbisonicDecoderToolkit";
declare license 	"GPL";
declare copyright	"(c) Aaron J. Heller 2013";

m = library("math.lib");

process = rotz;

rotz(W,X,Y,Z) = W,
                cos(th)*X - sin(th)*Y,
                sin(th)*X + cos(th)*Y,
                Z
 with {
  th = hslider("Z Rotation [unit:Degrees]", 0, -180, 180, 1) : deg2rad : dezipper;
};

deg2rad = *(m.PI/180.0);

// UI "dezipper"
smooth(c) = *(1-c) : +~*(c);
dezipper = smooth(0.999);