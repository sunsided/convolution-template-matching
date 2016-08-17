% Template matching by convolution

% This might not work as expected. The convolution (more specifically the 
% cross-correlation) will multiply the kernel with the image, so each
% occurrence of high values in the input image will also result in
% high values in the output image, no matter the kernel.

input = imread('image.jpg');
mask  = imread('mask.jpg');

% grayscale conversion using Gleam transformation
% (i.e. mean over all gamma-corrected channels)
gleam = @(I) (1/3) * ((double(I(:,:,1))/255).^(1/2.2) + ...
                      (double(I(:,:,2))/255).^(1/2.2) + ...
                      (double(I(:,:,3))/255).^(1/2.2));

% input range compression to 0..1
normalize = @(I) (I-min(min(I)))/(max(max(I))-min(min(I)));
                  
% convert input and mask to grayscale
g_input = gleam(input);
g_mask  = gleam(mask);

% normalize the mask
g_mask = normalize(g_mask);

% flip the mask along all axes to make the convolution behave
% like a correlation.
g_mask = rot90(g_mask, 2);

% perform the cross-correlation
convolved = conv2(g_input, g_mask, 'valid');

% find the maximum 
[max_value, max_index] = max(convolved(:));
[max_row, max_col]     = ind2sub(size(convolved), max_index)

% show the convolution map
figure;
imshow(normalize(convolved)); hold on; 
plot(max_col, max_row, 'r+');

% show the original image
figure;
imshow(g_input); hold on; 
plot(max_col + size(mask,2)/2, max_row + size(mask,1)/2, 'r+');