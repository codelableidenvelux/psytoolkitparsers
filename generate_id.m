function [x] = generate_id(id)
digs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
x = int2base(id, 62);
for i=1:8
    if (length(char(x)) < 8)
        x = append(digs(1),x);
    end
end 