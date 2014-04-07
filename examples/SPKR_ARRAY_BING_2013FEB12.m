function [ val ] = SPKR_ARRAY_BING_2013FEB12( )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here

% From: Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>
% Subject: Re: pesky coefficients...
% Date: February 12, 2013 5:00:27 PM PST

% sprk  az   el

% #1    16   0
% #2
% #3    37   9.7
% #4
% #5    70   12.35
% #6
% #7   104   15.43
% #8
% #9   129   22
% #10
% #11  161   22.2
% #12

% spkr azim  elev

% #13  19    40
% #14
% #15  54    40
% #16
% #17  128   40
% #18
% #19  164   40
% #20
% #21   51   65
% #22
% #23  141   65
% #24

% I listed only odd speakers, even ones are just a mirror image (12 on the floor, two rings of 8 and 4 speakers).

    R = 5.0;
    S = [ ...
        % == Floor:
         16   0  R
        -16   0  R
         37  9.7 R
        -37  9.7 R
         70  12.35 R
        -70  12.35 R
        104  15.43 R
       -104  15.43 R
        129  22    R
       -129  22    R
        161  22.2  R
       -161  22.2  R
        ...
        % == Rigged
         19  40    R
        -19  40    R
         54  40    R
        -54  40    R
        128  40    R
       -128  40    R
        164  40    R
       -164  40    R
         51  65    R
        -51  65    R
        141  65    R
       -141  65    R
        ];

    val.az = S(:,1)*pi/180;
    val.el = S(:,2)*pi/180;
    [val.x, val.y, val.z] = sph2cart(val.az, val.el, 1);
    val.r = S(:,3);
    val.id = {
        'S01', 'S02', 'S03', 'S04', 'S05', 'S06', 'S07', 'S08', 'S09', 'S10', 'S11', 'S12',...
        'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C20', ...
        'H21', 'H22', 'H23', 'H24' ...
        };
    val.name = 'BING_2013FEB12';

end
