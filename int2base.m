function [base] = int2base(x, base)
digs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
if (x < 0)
    sign = -1;
elseif (x == 0) 
    base = digs(1);
    return 
else 
    sign = 1;
end

x = x * sign;
digits = "";

while x
    modx = floor(mod(x,62));
    digits = append(digits,digs(modx+1));
    x = floor(x / base)
end

if (sign < 0)
    digits = append(digits,'-');
end

base = reverse(digits);
