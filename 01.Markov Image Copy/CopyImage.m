function  r = CopyImage(im)
% copy image using Markov chain
% key feature:
% slow done image copy by 1000 times;
r = zeros(size(im));
parfor i =  1 : size(r,3)
    r (:,:,i) =  MarkovCopy(im(:,:,i));
end
end

function r = MarkovCopy(im)
im = im2double(im);
% create a canvas
r = zeros(size(im));
% initial point
x_size = size(im,2);
y_size = size(im,1);
x = randi([1, x_size]);
y = randi([1, y_size]);
Fs = im(y,x);
% prob
txy = 1 / (x_size * y_size);
tyx = 1 / (x_size * y_size);
% copy iter times
r_num = x_size * y_size * 256;
copy_num = r_num;
buffer_size = x_size * y_size;
buffer_rand_x = randi([1, x_size],buffer_size,1);
buffer_rand_y = randi([1, y_size],buffer_size,1);
next_idx = 1;

while(r_num>0)
    % next point
    
    if(next_idx > buffer_size)
        buffer_rand_x = randi([1, x_size],buffer_size,1);
        buffer_rand_y = randi([1, y_size],buffer_size,1);
        next_idx = 1;
    end
    xn = buffer_rand_x(next_idx);
    yn = buffer_rand_y(next_idx);
    next_idx = next_idx + 1;
    
    Fn = im(yn,xn);
    % transfer prob
    a_s_2_n = min(1,  Fn * txy / (Fs * tyx));
    rn = rand();
    if(rn < a_s_2_n) % accept next point
       x = xn; 
       y = yn;
       Fs = Fn;
    end
    % histograph ++
    r(y,x) = r(y,x) + 1;
    r_num = r_num - 1;
end
sz = sum(im(:));
r = r ./ double(copy_num) .* sz;

end