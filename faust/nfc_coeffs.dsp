declare name		"nfc_coeffs";
declare version 	"1.0";
declare author 		"AmbisonicDecoderToolkit";
declare license 	"GPL";
declare copyright	"(c) Aaron J. Heller 2013";

m = library("math.lib");

SR = float(m.SR);

// physical constants     

temp_celcius = 20;                        
c = 340.29; // speed of sound m/s
//c = 331.3 * sqrt(1.0 + (temp_celcius/273.15));


// first and second order state variable filters see [4]
//   FIXME FIXME this code needs to be refactored, so that the zeros are 
//               passed in, or another API layer
svf1(g,d1)    = _ : *(g) :       (+      <: +~_, _ ) ~ *(d1)                   : !,_ ;
svf2(g,d1,d2) = _ : *(g) : (((_,_,_):> _ <: +~_, _ ) ~ *(d1) : +~_, _) ~ *(d2) : !,_ ;

//  these are Bessel filters, see [1,2]
nfc1(r,gain) = d1 //svf1(g,d1)  // r in meters
 with {
   omega = c/(r*SR);
//   omega = float(c)/(float(r)*float(SR));
   //  1  1
   b1 = omega/2.0;
   g1 = 1.0 + b1;
   d1 = 0 - (2.0 * b1) / g1;
   g = gain/g1;
};

nfc2(r,gain) = d1,d2 //svf2(g,d1,d2)
 with {
   omega = c/(r*SR);
//   omega = float(c)/(float(r)*float(SR));

   r1 = omega/2.0;
   r2 = r1 * r1;

   // 1.000000000000000   3.00000000000000   3.00000000000000
   b1 = 3.0 * r1;
   b2 = 3.0 * r2;
   g2 = 1 + b1 + b2;

   d1 = 0-(2.0 * b1 + 4.0 * b2)/g2;
   d2 = (4.0 * b2) / g2;
   g = gain/g2;
};

nfc3(r,gain) = d1,d2,d3 //svf2(g,d1,d2):svf1(1.0,d3)
 with {
   omega = c/(r*SR);
 //  omega = float(c)/(float(r)*float(SR));

   r1 = omega/2.0;
   r2 = r1 * r1;

   // 1.000000000000000   3.677814645373914   6.459432693483369
   b1 = 3.677814645373914 * r1;
   b2 = 6.459432693483369 * r2;         
   g2 = 1 + b1 + b2;
   d1 = 0 - (2 * b1 + 4 * b2) / g2;
   d2 = (4 * b2) / g2;

   // 1.000000000000000   2.322185354626086
   b3 = 2.322185354626086 * r1;
   g3 = 1 + b3;
   d3 = 0 - (2 * b3) / g3;

   g = gain/(g3*g2);
};

nfc4(r,gain) = d1,d2,d3,d4 //svf2(g,d1,d2):svf2(1.0,d3,d4)
 with {
   omega = c/(r*SR);
//   omega = float(c)/(float(r)*float(SR));

   r1 = omega/2.0;
   r2 = r1 * r1;
   
   // 1.000000000000000   4.207578794359250  11.487800476871168
   b1 =  4.207578794359250 * r1;
   b2 = 11.487800476871168 * r2;         
   g2 = 1 + b1 + b2;
   d1 = 0 - (2 * b1 + 4 * b2) / g2;
   d2 = (4 * b2) / g2;

   // 1.000000000000000   5.792421205640748   9.140130890277934
   b3 = 5.792421205640748 * r1;
   b4 = 9.140130890277934 * r2;         
   g3 = 1 + b3 + b4;
   d3 = 0 - (2 * b3 + 4 * b4) / g3;
   d4 = (4 * b4) / g3;
   
   g = gain/(g3*g2);
};

nfc5(r,gain) = d1,d2,d3,d4,d5 //svf2(g,d1,d2):svf2(1.0,d3,d4):svf1(1.0,d5)
 with {
   omega = c/(r*SR);
//   omega = float(c)/(float(r)*float(SR));

   r1 = omega/2.0;
   r2 = r1 * r1;
   
   // 1.000000000000000   4.649348606363304  18.156315313452325
   b1 =  4.649348606363304 * r1;
   b2 = 18.156315313452325 * r2;         
   g2 = 1 + b1 + b2;
   d1 = 0 - (2 * b1 + 4 * b2) / g2;
   d2 = (4 * b2) / g2;

   // 1.000000000000000   6.703912798306966  14.272480513279568
   b3 =  6.703912798306966 * r1;
   b4 = 14.272480513279568 * r2;         
   g3 = 1 + b3 + b4;
   d3 = 0 - (2 * b3 + 4 * b4) / g3;
   d4 = (4 * b4) / g3;

   // 1.000000000000000   3.646738595329718
   b5 = 3.646738595329718 * r1;
   g4 = 1 + b5;
   d5 = 0 - (2 * b5) / g4;

   g = gain/(g4*g3*g2);
 };



nfc(0,r,g) = 1; //gain(g);
nfc(1,r,g) = nfc1(r,g);
nfc(2,r,g) = nfc2(r,g);
nfc(3,r,g) = nfc3(r,g);
nfc(4,r,g) = nfc4(r,g);
nfc(5,r,g) = nfc5(r,g);

r0 = 2.0;

process = 
 (SR,  // 1
  nfc(1,r0,1),  // 2
  nfc(2,r0,1),  // 3,4
  nfc(3,r0,1),  // 5,6,7
  nfc(4,r0,1),  // 8,9,10,11
  nfc(5,r0,1)); // 12,13,14,15,16
