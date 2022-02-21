% Cleanup/initialization
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;
%==========================================================================
tmp=imread('i235.png','png');
I=double(tmp);
figure,imagesc(I),colormap gray,title('Original Image')
%function to find the corners
C = corner(I);

figure,imagesc(I),colormap gray,title('Original Image with Harris corner detector')
hold on
plot(C(:,1),C(:,2),'r*');

%==========================================================================
%%applying sobel edge detector in the horizontal direction
fx = [-1 0 1;-1 0 1;-1 0 1];
Ix = conv2(I,fx,'same');
figure,imagesc(Ix),colormap gray,title('partial derivatives of Ix')

%==========================================================================
% applying sobel edge detector in the vertical direction
fy = [1 1 1;0 0 0;-1 -1 -1];
Iy = conv2(I,fy,'same'); 
figure,imagesc(Iy),colormap gray,title('partial derivatives of Iy')

%==========================================================================
%compute products of derivatives at every pixel
Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;

%==========================================================================
%applying gaussian filter on the computed value
h= fspecial('gaussian',[9 9],1.2); 
figure,imagesc(h),colormap gray,title('Gaussian filter')
Gaussian= conv2(tmp,h,'same');
figure,imagesc(Gaussian),colormap gray,title('Orginale image with Gaussian filter')
Ix2 = conv2(Ix2,h,'same');
Iy2 = conv2(Iy2,h,'same');
Ixy = conv2(Ixy,h,'same');
height = size(tmp,1);
width = size(tmp,2);
result = zeros(height,width); 
R = zeros(height,width);

%==========================================================================
%features detection
[rr,cc]=size(Ix2);
corner_reg=zeros(rr,cc);
R_map=zeros(rr,cc);
k=0.05;
for ii=1:rr
    for jj=1:cc
        %define at each pixel x,y the matrix
        M=[Ix2(ii,jj),Ixy(ii,jj);Ixy(ii,jj),Iy2(ii,jj)];
        %compute the response of the detector at each pixel
        R=det(M) - k*(trace(M).^2);
        R_map(ii,jj)=R;
        %threshod on value of R, use maximum value of R_max per 0.3  
        if R> 0.3*max(R_map(:))
        %function to collect corners
            corner_reg(ii,jj)=1;
        end
    end
end

%==========================================================================
%overlap orginal image with corner region
C = imfuse(tmp,corner_reg.*I,'blend','Scaling','joint');
figure,imagesc(C),colormap gray,title('corner regions')
figure,imagesc(R_map),colormap jet,title('R map')

%==========================================================================
%function to get the centroids of the blobs in the corner regions map first
%solution
bw = im2bw(C);
s = regionprops(bw,'centroid');
centroids = cat(1,s.Centroid);
figure,imagesc(tmp), colormap gray, title ('object detected with "regionprops"')
hold on
plot(centroids(:,1),centroids(:,2),'r*')
hold off
%==========================================================================
%find centroid of the blobs in the corner regions map second solution
Rmax = 0; 
for i = 1:height
for j = 1:width
M = [Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)]; 
R(i,j) = det(M)-0.01*(trace(M))^2;
if R(i,j) > Rmax
Rmax = R(i,j);
end;
end;
end;
cnt = 0;
for i = 2:height-1
for j = 2:width-1
if R(i,j) > 0.3*max(R_map(:))  && R(i,j) > R(i-1,j-1) && R(i,j) > R(i-1,j) && R(i,j) > R(i-1,j+1) && R(i,j) > R(i,j-1) && R(i,j) > R(i,j+1) && R(i,j) > R(i+1,j-1) && R(i,j) > R(i+1,j) && R(i,j) > R(i+1,j+1)
result(i,j) = 1;
cnt = cnt+1;
end;
end;
end;
[posc, posr] = find(result == 1);
cnt ;
figure,imagesc(tmp),colormap gray,title('object detected');
hold on;
plot(posr,posc,'b*');








