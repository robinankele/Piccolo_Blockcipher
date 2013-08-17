function [y] = fFunction(x)

    x(1) = sbox(x(1));
    x(2) = sbox(x(2));
    x(3) = sbox(x(3));
    x(4) = sbox(x(4));

    y = diffusionFunction(x);

    y(1) = sbox(y(1));
    y(2) = sbox(y(2));
    y(3) = sbox(y(3));
    y(4) = sbox(y(4));
end