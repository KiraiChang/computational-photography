dir = '../picture/';
name = 'emper_build';
sub = 'jpg';

I = imread([dir, name, '.', sub]);
I = im2double(I);
sigma_s = 60;
sigma_r = 0.4;

%{
lab = RGB2Lab(I);
figure, imshow(lab); title('LAB');
rgb = Lab2RGB(lab);
figure, imshow(rgb); title('RGB');
%}


F_nc = NC(I, sigma_s, sigma_r);
figure, imshow(I); title('Input photograph');
figure, imshow(F_nc); title('Normalized convolution');
imwrite(F_nc, [dir, name, '_NC.', 'png']);

F_lab_nc = RGB2Lab(F_nc);
imwrite(F_lab_nc, [dir, name, '_NC_Lab.', 'png']);
figure, imshow(F_lab_nc); title('NC Lab');

%F_qc = CQ(F_lab_nc);
%imwrite(F_qc, [dir, name, '_CQ.', 'png']);
%figure, imshow(F_qc); title('Color Quantization');

F_eed = DoG(F_lab_nc, 1.0, 1.6, 0.99, 2.0);
imwrite(F_eed, [dir, name, '_DOG.', 'png']);
figure, imshow(F_eed); title('Edge Enhancement');

%F_qc = Lab2RGB(F_qc);
%F_qc = im2double(F_qc);
F_eec = CM(F_nc, F_eed);
imwrite(F_eec, [dir, name, '_CMB.', 'png']);
figure, imshow(F_eec); title('Image Combine');
