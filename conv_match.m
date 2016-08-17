% Template matching by convolution

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

% flip the mask along all axes to make the convolution behave
% like a correlation.
g_mask = rot90(g_mask, 2);

% perform the cross-correlation
convolved = conv2(g_input, g_mask, 'same');

% find the maximum 
[max_value, max_index] = max(convolved(:));
[max_row, max_col]     = ind2sub(size(convolved), max_index)

return;

% show the convolution map
figure;
imshow(normalize(convolved)); hold on; 
plot(max_row, max_col, 'r+');

% show the original image
figure;
imshow(g_input); hold on; 
plot(max_row, max_col, 'r+');