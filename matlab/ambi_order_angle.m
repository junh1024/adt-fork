function ambi_order_angle()
    for N = 1:5
        rE = max(roots(LegendrePoly(N+1)));
        fprintf('%d %f %f\n', N,rE,acos(rE)*180/pi);
    end
        
