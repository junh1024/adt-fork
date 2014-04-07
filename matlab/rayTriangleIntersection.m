function [flag, u, v, t] = rayTriangleIntersection (o, d, p0, p1, p2)
% Ray/triangle intersection using the algorithm proposed by Möller and Trumbore (1997).
%
% Input:
%    o : origin.
%    d : direction.
%    p0, p1, p2: vertices of the triangle.
% Output:
%    flag: (0) Reject, (1) Intersect.
%    u,v: barycentric coordinates.
%    t: distance from the ray origin.
% Author: 
%    Jesus Mena
%    (see License section for license terms)    

    epsilon = 0.00001;

    e1 = p1-p0;
    e2 = p2-p0;
    q  = cross(d,e2);
    a  = dot(e1,q); % determinant of the matrix M

    if (a>-epsilon && a<epsilon) 
        % the vector is parallel to the plane (the intersection is at infinity)
        [flag, u, v, t] = deal(0,0,0,0);
        return;
    end;
    
    f = 1/a;
    s = o-p0;
    u = f*dot(s,q);
    
    if (u<0.0)
        % the intersection is outside of the triangle
        [flag, u, v, t] = deal(0,0,0,0);
        return;          
    end;
    
    r = cross(s,e1);
    v = f*dot(d,r);
    
    if (v<0.0 || u+v>1.0)
        % the intersection is outside of the triangle
        [flag, u, v, t] = deal(0,0,0,0);
        return;
    end;
    
    t = f*dot(e2,r); % verified! 
    flag = 1;
    return;
end

%% Downloaded from MATLAB Central File Exchange
% url: http://www.mathworks.com/matlabcentral/fileexchange/25058

%% README: rayTriangleIntersection
%
% Ray/triangle intersection using the algorithm proposed by Möller and Trumbore (1997).
% The zip file includes one example of intersection.
%
% Author: 
%     Jesús Mena
%
% References:
% [1] "Real Time Rendering". Third Edition.
%     Tomas Akenine-Möller, Eric Haines and Naty Hoffman.
%     A. K. Peters, Ltd. 2008 (Section 16.8)
%
% [2] "Fast, minimum storage ray-triangle intersection".
%     Tomas Möller and Ben Trumbore.
%     Journal of Graphics Tools, 2(1):21--28, 1997. 
%
% [3] Other algorithms:
%     http://www.realtimerendering.com/intersections.html
%
% Keyword:
%     ray, triangle, intersection, ray tracing, render, computer graphics

%% license.txt
% Copyright (c) 2009, Jesus Mena
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
%
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%      
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.
