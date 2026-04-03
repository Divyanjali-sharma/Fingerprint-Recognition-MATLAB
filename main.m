clc;
clear;
close all;


img1 = imread('dataset/f1.png');
img2 = imread('dataset/f2.png');

figure, imshow(img1), title('Original Image 1');
figure, imshow(img2), title('Original Image 2');


if size(img1,3) == 3
    img1 = rgb2gray(img1);
end
if size(img2,3) == 3
    img2 = rgb2gray(img2);
end


img1 = adapthisteq(img1);
img2 = adapthisteq(img2);

figure, imshow(img1), title('Enhanced Image 1');
figure, imshow(img2), title('Enhanced Image 2');


img1 = medfilt2(img1);
img2 = medfilt2(img2);

bw1 = imbinarize(img1);
bw2 = imbinarize(img2);

figure, imshow(bw1), title('Binary Image 1');
figure, imshow(bw2), title('Binary Image 2');

bw1 = bwareaopen(bw1, 50);
bw2 = bwareaopen(bw2, 50);

thin1 = bwmorph(bw1, 'thin', Inf);
thin2 = bwmorph(bw2, 'thin', Inf);

figure, imshow(thin1), title('Thinned Image 1');
figure, imshow(thin2), title('Thinned Image 2');

end1 = bwmorph(thin1, 'endpoints');
branch1 = bwmorph(thin1, 'branchpoints');

figure, imshow(thin1); hold on;
[y,x] = find(end1);
plot(x,y,'ro');
[y,x] = find(branch1);
plot(x,y,'go');
title('Minutiae Points Image 1');

end2 = bwmorph(thin2, 'endpoints');
branch2 = bwmorph(thin2, 'branchpoints');

figure, imshow(thin2); hold on;
[y,x] = find(end2);
plot(x,y,'ro');
[y,x] = find(branch2);
plot(x,y,'go');
title('Minutiae Points Image 2');

% Resize second image
img2 = imresize(img2, size(img1));

% Matching
score = corr2(img1, img2);

disp(['Matching Score: ', num2str(score)]);

if score > 0.75
    disp('✅ Fingerprints Matched');
else
    disp('❌ Fingerprints Not Matched');
end