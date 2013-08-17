function [y] = sbox(x)
    load('sbox_table.mat');
    
    y = sbox_table(x + 1);
end







