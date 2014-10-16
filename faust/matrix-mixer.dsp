declare name		"matrix_mixer";
declare version 	"1.0";
declare author 		"AmbisonicDecoderToolkit";
declare license 	"GPL";
declare copyright	"(c) Aaron J. Heller 2013";

// bus with gains
gain(c) = R(c) with {
  R((c,cl)) = R(c),R(cl);
  R(1)      = _;
  R(0)      = !;
  //R(0)      = !:0; // if you need to preserve the number of outputs
  R(float(0)) = R(0);
  R(float(1)) = R(1);
  R(c)      = *(c);
};

// n = number of inputs
// m = number of output
matrix(n,m) = par(i,n,_) <: par(i,m,gain(a(i)):>_);

//a(0) = (0.5, -0.5, 1.1, 1.2,hslider("gain [unit:dB]", -10, -30, +10, 1));
//a(1) = (1,2,3,4,-1);
//a(2) = (0.5,0.5,0,0.25,1/3);
//a(3) = (0,0,0,.1, sqrt(2));

process = matrix(32,25);

a( 0) = (0.496289,0.089999,0.088666,0.805063,0.498354,0.705077,0.278784,0.954103,0.594037,0.999478,0.899983,0.034866,0.309369,0.540878,0.367286,0.437973,0.475786,0.090166,0.631931,0.961994,0.466202,0.059095,0.864622,0.151846,0.190903,0.583133,0.243648,0.406830,0.652520,0.130974,0.804521,0.733773);
a( 1) = (0.979765,0.642315,0.320941,0.838256,0.451375,0.808990,0.558559,0.198222,0.542813,0.241084,0.980978,0.193434,0.885420,0.523030,0.207731,0.744868,0.940337,0.399075,0.904666,0.985237,0.540204,0.325653,0.740905,0.055953,0.847911,0.145732,0.698254,0.104822,0.938316,0.917299,0.833729,0.816911);
a( 2) = (0.284824,0.221266,0.511409,0.584719,0.382646,0.356509,0.756631,0.195072,0.540106,0.841369,0.127037,0.754425,0.407731,0.325299,0.219284,0.892267,0.005834,0.599438,0.884389,0.559477,0.030270,0.630205,0.506795,0.816855,0.784855,0.585044,0.029332,0.858353,0.255427,0.509839,0.800468,0.189471);
a( 3) = (0.594974,0.837056,0.060606,0.948109,0.789644,0.073243,0.995481,0.326840,0.311110,0.857213,0.232240,0.346261,0.036382,0.831843,0.325806,0.242603,0.610307,0.800523,0.438990,0.933592,0.696314,0.230299,0.199925,0.528922,0.270832,0.073362,0.527883,0.698200,0.533163,0.974191,0.917880,0.123693);
a( 4) = (0.962161,0.971075,0.725688,0.061029,0.364287,0.590991,0.962431,0.880338,0.071235,0.963612,0.023632,0.418625,0.746148,0.810295,0.095949,0.129597,0.801076,0.105069,0.781723,0.720343,0.519716,0.579885,0.427194,0.694351,0.227811,0.822326,0.032073,0.733742,0.954755,0.197279,0.137304,0.820996);
a( 5) = (0.185778,0.846373,0.556556,0.584641,0.532350,0.910188,0.535067,0.471102,0.181980,0.488900,0.607433,0.155720,0.154829,0.556998,0.747534,0.225068,0.232982,0.821442,0.148465,0.484039,0.059031,0.603156,0.168690,0.212405,0.321023,0.722903,0.827142,0.650531,0.267748,0.111185,0.504732,0.637898);
a( 6) = (0.193040,0.505999,0.529360,0.285108,0.711657,0.193766,0.963870,0.403969,0.092989,0.220310,0.110809,0.819001,0.143908,0.262964,0.748509,0.350014,0.932469,0.841086,0.619816,0.639031,0.890036,0.599879,0.751695,0.543280,0.829562,0.925858,0.339986,0.516271,0.250085,0.297354,0.404958,0.016120);
a( 7) = (0.341644,0.278876,0.829982,0.827732,0.871477,0.432368,0.115626,0.179231,0.463489,0.226209,0.407460,0.624924,0.605959,0.680566,0.543299,0.287085,0.763263,0.354506,0.260624,0.887637,0.330202,0.448428,0.368351,0.702520,0.822182,0.492639,0.846711,0.326388,0.927673,0.396419,0.173572,0.895955);
a( 8) = (0.932898,0.746617,0.858759,0.190986,0.328690,0.749160,0.051448,0.968925,0.009333,0.536788,0.884077,0.738560,0.254481,0.233653,0.338132,0.927488,0.826450,0.430069,0.445656,0.198737,0.229701,0.035423,0.941818,0.956435,0.570683,0.654883,0.246070,0.661776,0.068582,0.420756,0.575184,0.515375);
a( 9) = (0.390668,0.236930,0.789029,0.442530,0.650118,0.039184,0.304349,0.407456,0.915026,0.762110,0.548133,0.805112,0.324154,0.456425,0.832334,0.051314,0.573464,0.572239,0.844000,0.395366,0.113949,0.513815,0.017173,0.444542,0.571830,0.890123,0.581491,0.117565,0.299400,0.311475,0.606218,0.544522);
a(10) = (0.273217,0.957345,0.317833,0.393412,0.974836,0.946325,0.580192,0.844487,0.642742,0.347567,0.369003,0.067223,0.401791,0.384567,0.552572,0.592667,0.792582,0.700825,0.196205,0.992175,0.310923,0.407730,0.829056,0.085398,0.286018,0.538526,0.937677,0.147817,0.591584,0.693843,0.214446,0.606442);
a(11) = (0.151947,0.620260,0.452207,0.826574,0.075967,0.763673,0.530964,0.615325,0.001419,0.461232,0.208346,0.950790,0.406373,0.538601,0.957543,0.162899,0.329041,0.742470,0.303852,0.402352,0.228432,0.108046,0.626591,0.057340,0.699134,0.282205,0.047787,0.019765,0.203299,0.091872,0.519932,0.760436);
a(12) = (0.397109,0.600262,0.752228,0.676871,0.587019,0.558821,0.901208,0.376611,0.030385,0.639324,0.440943,0.497577,0.386191,0.991704,0.892833,0.838406,0.223462,0.757884,0.483295,0.658856,0.651997,0.459876,0.538747,0.629450,0.796258,0.975958,0.053978,0.964292,0.635883,0.402089,0.989186,0.855347);
a(13) = (0.374722,0.172605,0.109862,0.207603,0.413886,0.183843,0.540550,0.877182,0.208470,0.917336,0.956196,0.755146,0.609802,0.755220,0.356504,0.167561,0.312386,0.389129,0.337812,0.901348,0.066160,0.450883,0.650508,0.796179,0.441589,0.036426,0.020618,0.970373,0.798370,0.295181,0.489915,0.382868);
a(14) = (0.131115,0.090347,0.109742,0.318105,0.309136,0.497949,0.431981,0.784852,0.454966,0.161573,0.124026,0.742405,0.166891,0.980455,0.546402,0.502201,0.584523,0.429302,0.798486,0.995382,0.275431,0.551140,0.726630,0.691191,0.446216,0.326245,0.681479,0.123861,0.501701,0.306497,0.694873,0.084649);
a(15) = (0.435041,0.255262,0.269884,0.133811,0.263834,0.517846,0.542667,0.464954,0.127266,0.715635,0.470763,0.831130,0.188092,0.234783,0.346682,0.999329,0.829914,0.956345,0.987488,0.653163,0.281820,0.805404,0.094489,0.345308,0.465662,0.973014,0.598629,0.467410,0.650812,0.105561,0.411422,0.733873);
a(16) = (0.091513,0.858571,0.524637,0.671463,0.758766,0.994243,0.712415,0.813977,0.008648,0.577739,0.856896,0.156502,0.094629,0.528559,0.622803,0.355407,0.290462,0.572971,0.159048,0.108436,0.880066,0.700850,0.877574,0.946817,0.279039,0.365033,0.114030,0.656694,0.795955,0.593828,0.034777,0.331989);
a(17) = (0.614627,0.911067,0.972651,0.570991,0.995216,0.854852,0.016675,0.898444,0.727080,0.433299,0.043390,0.457309,0.323186,0.051436,0.796625,0.047078,0.402554,0.849722,0.236880,0.036114,0.444330,0.872236,0.014362,0.520190,0.675375,0.309150,0.796245,0.290186,0.233374,0.282728,0.292832,0.839750);
a(18) = (0.010979,0.699634,0.710409,0.169767,0.186571,0.962404,0.800921,0.429239,0.354116,0.884243,0.691625,0.618100,0.769597,0.756875,0.745875,0.213661,0.862057,0.276345,0.702237,0.618091,0.755914,0.052192,0.294303,0.953813,0.903665,0.120912,0.617851,0.754537,0.600839,0.155222,0.801442,0.371723);
a(19) = (0.573260,0.725182,0.311860,0.147656,0.781145,0.678941,0.142509,0.334329,0.780446,0.393052,0.978985,0.932183,0.234118,0.601980,0.125536,0.397839,0.614740,0.622324,0.375472,0.567144,0.603296,0.219681,0.179915,0.073596,0.908526,0.915766,0.070214,0.558118,0.112462,0.000659,0.346502,0.828215);
a(20) = (0.789730,0.229886,0.291457,0.476080,0.195798,0.403501,0.478474,0.596647,0.436657,0.178975,0.283268,0.835088,0.740365,0.857169,0.822394,0.333668,0.991188,0.588362,0.973705,0.961965,0.783266,0.459642,0.926294,0.207032,0.747197,0.135478,0.069279,0.427793,0.515766,0.283595,0.083316,0.176519);
a(21) = (0.235367,0.576053,0.850357,0.908102,0.992359,0.934979,0.256835,0.901991,0.436555,0.633334,0.133780,0.895424,0.692818,0.988277,0.025151,0.229603,0.203699,0.963468,0.972306,0.746105,0.113931,0.958534,0.068180,0.775028,0.260512,0.332118,0.136007,0.267194,0.837841,0.550811,0.511106,0.129520);
a(22) = (0.448020,0.810628,0.911647,0.552175,0.802262,0.479485,0.369092,0.702066,0.049213,0.624001,0.685280,0.582519,0.824078,0.929484,0.414429,0.936120,0.827209,0.085903,0.643698,0.662516,0.978564,0.790045,0.581093,0.914188,0.689638,0.897480,0.788891,0.753736,0.920790,0.870902,0.366833,0.879884);
a(23) = (0.569358,0.403843,0.639276,0.032940,0.424227,0.231792,0.661765,0.377455,0.049632,0.327942,0.909455,0.582747,0.827978,0.409515,0.731407,0.683189,0.675862,0.500499,0.860099,0.523313,0.848597,0.451875,0.637151,0.782551,0.131831,0.499649,0.092398,0.898376,0.498228,0.042253,0.739480,0.044079);
a(24) = (0.061401,0.988439,0.255370,0.053863,0.728864,0.396290,0.169609,0.734956,0.091100,0.802965,0.610869,0.854926,0.293368,0.000341,0.781374,0.962114,0.248949,0.521590,0.401883,0.259894,0.050646,0.333428,0.651269,0.295534,0.123501,0.615288,0.237869,0.728444,0.277611,0.904722,0.524740,0.686720);

