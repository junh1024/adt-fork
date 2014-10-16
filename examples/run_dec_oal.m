function [ output_args ] = run_dec_oal( )
   %UNTITLED Summary of this function goes here
   %   Detailed explanation goes here

   r = 2;

   [fl_x, fl_y, fl_z] = sph2cart(-30*pi/180, 0, r);

   S = [ 110 0 r; 30 0 r; 0 0 fl_x; -30 0 r; -110 0 r ];

   val.name = 'itu50';
   val.id = {'BL' 'FL' 'FC' 'FR' 'BR'};

   
   val.az = S(:,1) * pi/180;
   val.el = S(:,2) * pi/180;
   val.r  = S(:,3);
   
   [val.x, val.y, val.z] = sph2cart(val.az, val.el, 1);
   
   ambi_run_allrad(val,[2,0], [0,0,1;0,0,-1]);
end
