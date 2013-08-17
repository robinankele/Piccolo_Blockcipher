function [wk, rk] = keyschedule(key)
    k0L = 0; k0R = 0;
    k1L = 0; k1R = 0;
    k2L = 0; k2R = 0;
    k3L = 0; k3R = 0;
    k4L = 0; k4R = 0;
    wk = [0;0;0;0];
    
    k0L = bitor(k0L,bitshift(key(1), 4));
    k0L = bitor(k0L,bitshift(key(2), 0));
    k0R = bitor(k0R,bitshift(key(3), 4));
    k0R = bitor(k0R,bitshift(key(4), 0));
    
    k1L = bitor(k1L,bitshift(key(5), 4));
    k1L = bitor(k1L,bitshift(key(6), 0));
    k1R = bitor(k1R,bitshift(key(7), 4));
    k1R = bitor(k1R,bitshift(key(8), 0));
    
    k2L = bitor(k2L,bitshift(key(9), 4));
    k2L = bitor(k2L,bitshift(key(10), 0));
    k2R = bitor(k2R,bitshift(key(11), 4));
    k2R = bitor(k2R,bitshift(key(12), 0));
    
    k3L = bitor(k3L,bitshift(key(13), 4));
    k3L = bitor(k3L,bitshift(key(14), 0));
    k3R = bitor(k3R,bitshift(key(15), 4));
    k3R = bitor(k3R,bitshift(key(16), 0));
    
    k4L = bitor(k4L,bitshift(key(17), 4));
    k4L = bitor(k4L,bitshift(key(18), 0));
    k4R = bitor(k4R,bitshift(key(19), 4));
    k4R = bitor(k4R,bitshift(key(20), 0));

    % whitening keys
    wk(1) = bitor(wk(1),bitshift(k0L, 8));
    wk(1) = bitor(wk(1),bitshift(k1R, 0));
    
    wk(2) = bitor(wk(2),bitshift(k1L, 8));
    wk(2) = bitor(wk(2),bitshift(k0R, 0));
    
    wk(3) = bitor(wk(3),bitshift(k4L, 8));
    wk(3) = bitor(wk(3),bitshift(k3R, 0));
    
    wk(4) = bitor(wk(4),bitshift(k3L, 8));
    wk(4) = bitor(wk(4),bitshift(k4R, 0));
    
    k0 = 0; k1 = 0; k2 = 0; k3 = 0; k4 = 0;
    k0 = bitor(k0,bitshift(k0L, 8));
    k0 = bitor(k0,bitshift(k0R, 0));
    k1 = bitor(k1,bitshift(k1L, 8));
    k1 = bitor(k1,bitshift(k1R, 0));
    k2 = bitor(k2,bitshift(k2L, 8));
    k2 = bitor(k2,bitshift(k2R, 0));
    k3 = bitor(k3,bitshift(k3L, 8));
    k3 = bitor(k3,bitshift(k3R, 0));
    k4 = bitor(k4,bitshift(k4L, 8));
    k4 = bitor(k4,bitshift(k4R, 0));
    
    % round keys
    for i = 0:24
        [rk(2*i+1), rk(2*i + 2)] = constants(i);
        
        if(mod(i, 5) == 0 || i == 2)
            rk(2*i+1) = bitxor(rk(2*i+1), k2);
            rk(2*i + 2) = bitxor(rk(2*i + 2), k3);
        end
        if(mod(i, 5) == 1 || i == 4)
            rk(2*i+1) = bitxor(rk(2*i+1), k0);
            rk(2*i + 2) = bitxor(rk(2*i + 2), k1);
        end
        if(mod(i, 5) == 3)
            rk(2*i+1) = bitxor(rk(2*i+1), k4);
            rk(2*i + 2) = bitxor(rk(2*i + 2), k4);
        end
    end
end
