% Template matching by convolution

% The convolution (more specifically the cross-correlation) will multiply 
% the kernel with the image, so each occurrence of high values in the 
% input image will also result in high values in the output image, no 
% matter the kernel. This is due to the fact that the (unnormalized) cross
% correlation is not invariant to the mean value;
% To accommodate for this, this implementation takes the horizontal
% and vertical gradient of both image and mask and convolves on these
% representations (i.e. in feature space), which results in the
% expected behaior.

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

% get the gradients
gd_input = conv2(g_input, [-1 0 1; -1 0 1; -1 0 1]/3, 'same') + ...
           conv2(g_input, [-1 -1 -1; 0 0 0; 1 1 1]/3, 'same');
gd_mask  = conv2(g_mask, [-1 0 1; -1 0 1; -1 0 1]/3, 'same') + ...
           conv2(g_mask, [-1 -1 -1; 0 0 0; 1 1 1]/3, 'same');
      
% flip the mask along all axes to make the convolution behave
% like a correlation.
gd_mask = rot90(gd_mask, 2);

% perform the cross-correlation
convolved = conv2(gd_input, gd_mask, 'valid');

% find the maximum 
[min_value, min_index] = min(convolved(:));
[min_row, min_col]     = ind2sub(size(convolved), min_index);

% show the convolution map
figure;
imshow(normalize(convolved)); hold on; 
rectangle('Position', [min_col-32+2 min_row-32+2 64 64], 'EdgeColor', [1 0 0]);

% show the original image
figure;
imshow(input*0.75+64); hold on; 
rectangle('Position', [min_col+2 min_row+2 64 64], ...
          'EdgeColor', [0.5 0 0], ...
          'LineWidth', 3, ...
          'LineStyle', ':');