# Template Matching by Convolution

*Template matching* attempts to find instances of a given template in an existing image by finding areas of maximum correspondence. While this can be done in terms of a cross correlation, care has to be taken to normalize both input and template, as cross correlation by itself is not invariant to mean shifts.

This experiment follows the idea that **convolution** is the same operation as **cross correlation**, when all axes of the template (i.e. the kernel) have been flipped; in terms of a two-dimensional correlation with a template, this results in a two-dimensional convolution of the same template, rotated by 180°; so

```matlab
xcorr2(image, template)
```

is conceptually the same as

```matlab
conv2(image, fliplr(flipud(template)) % or
conv2(image, rot90(template, 2))
```

Finding the template matches is then a question of finding the local maxima (i.e. areas of maximum correspondence).