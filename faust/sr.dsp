declare name		"sr_test";
declare version 	"1.0";
declare author 		"AmbisonicDecoderToolkit";
declare license 	"GPL";
declare copyright	"(c) Aaron J. Heller 2013";

m = library("math.lib");

//SR = float(m.SR);

//process = m.SR / 100000;

r = 3.2;

temp_celcius = 20;
c = 331.3 * sqrt(1.0 + (temp_celcius/273.15));

//process = c/(r*m.SR); //, c/(float(r)*SR);

process = m.SR;