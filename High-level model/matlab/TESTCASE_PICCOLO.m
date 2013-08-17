%%TESTCASES PICCOLO BLOCKCIPHER
clear;
load('sbox.mat');
M = [2,3,1,1;1,2,3,1;1,1,2,3;3,1,1,2];


%% Diffusion Matrix Multiplication
x = [1;1;1;1];
y = M*x;
y = mod(y,16)


%% F - Function
x = [1;2;3;4];

x(1) = sbox(x(1)+1);
x(2) = sbox(x(2)+1);
x(3) = sbox(x(3)+1);
x(4) = sbox(x(4)+1);

y = M*x;
y = mod(y,16)

x(1) = sbox(y(1)+1);
x(2) = sbox(y(2)+1);
x(3) = sbox(y(3)+1);
x(4) = sbox(y(4)+1);

x
%% Gr Function



%% key Schedule



%% constants
i = 12;
ci1 = i + 1;
c0  = 0;

const = 0;
const = bitor(const,bitshift(ci1, 27));
dec2bin(const)
const = bitor(const,bitshift(c0, 22));
dec2bin(const)
const = bitor(const,bitshift(ci1, 17));
dec2bin(const)
const = bitor(const,bitshift(c0, 15));
dec2bin(const)
const = bitor(const,bitshift(ci1, 10));
dec2bin(const)
const = bitor(const,bitshift(c0, 5));
dec2bin(const)
const = bitor(const,bitshift(ci1, 0));
dec2bin(const)

const = bitxor(const, hex2dec('0f1e2d3c'));
dec2bin(const)


% keyschedule([0;0;1;1;2;2;3;3;4;4;5;5;6;6;7;7;8;8;9;9;10;10;11;11;12;12;13;13;14;14;15;15])








