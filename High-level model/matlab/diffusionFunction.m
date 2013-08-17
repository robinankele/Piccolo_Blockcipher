function [y] = diffusionFunction(x)
    M = [2,3,1,1;1,2,3,1;1,1,2,3;3,1,1,2];

    y = M*x;
    y = mod(y,16);
end
