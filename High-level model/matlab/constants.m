function [c2i, c2i1] = constants(i)
    ci1 = i + 1;
    c0  = 0;

    const = 0;
    const = bitor(const,bitshift(ci1, 27));
    const = bitor(const,bitshift(c0, 22));
    const = bitor(const,bitshift(ci1, 17));
    const = bitor(const,bitshift(c0, 15));
    const = bitor(const,bitshift(ci1, 10));
    const = bitor(const,bitshift(c0, 5));
    const = bitor(const,bitshift(ci1, 0));

    const = bitxor(const, hex2dec('0f1e2d3c'));
    c2i  = bitshift(const, -16);
    c2i1 = bitand(const, 65535);
end
