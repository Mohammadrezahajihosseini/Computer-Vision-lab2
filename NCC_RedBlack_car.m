% Cleanup/initialization
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;
%=====================================================================
%Demonstration 6 gray scale images and indicated red and blue rectangle
%corresponding in order said to red and black machine
for i = 1:6
    c{i}=imread(sprintf('ur_c_s_03a_01_L_037%d.png',i));
    subplot(2,3,i);
    imagesc(im2gray(c{i})),colormap gray,title('picture',i)
    gray{i} = double(im2gray(c{i}));
    hold on
    rectangle('Position', [685 355 90 75] ,'EdgeColor','r','LineWidth',1)
    hold on
    plot(730,382,'r*')
    hold on 
    rectangle('Position', [530 365 115 55] ,'EdgeColor','b','LineWidth',1)
    hold on
    plot(587,392,'b*')  
end
%=========================================================================
figure
% Extract template of Red car
 T= double(c{1}(355:425,690:775));
    subplot(1,2,1),imagesc(T),colormap gray, title('Red car')
    Q = double(im2gray(T));
 %Extract template of Black car 
 T1= double(c{1}(360:415,560:650));
    subplot(1,2,2),imagesc(T1),colormap gray, title('black car')
    Q1 = double(im2gray(T1));
    %===================================================================
    %normalized cross correlation of Red car on first 
    % image ur_c_s_03a_01_L_0371.png with other 6 image 
figure
for k =1:6
    Red{k} = normxcorr2(Q,gray{i}); 
    %the position of the maximum of the score map and a Red box corresponding
    %to the size of the template for all the 6 images
    %extracting the Red color from grayscale image
    diff_im{k}=imsubtract(c{i}(:,:,1),rgb2gray(c{i}));
    %Filtering the noise
    diff_im{k}=medfilt2(diff_im{k},[3,3]);
    %Converting grayscale image into binary image
    diff_im{k}=im2bw(diff_im{k},0.18);
    %remove all pixels less than 300 pixel
    diff_im{k}=bwareaopen(diff_im{k},300);
    %Draw rectangular boxes around the red object detected & label image
    bw{k}=bwlabel(diff_im{k},8);
    stats{k}=regionprops(bw{k},'BoundingBox','Centroid');
    %Show image
    subplot(2,3,k);
    imagesc(Red{k}),title('Find Red Car',k), colormap gray;
    hold on 
    %create the regtangular box
    %saving data of centroid and boundary in BB & BC 
    bb=stats{k}(2).BoundingBox;
    bc=stats{k}(2).Centroid;
    %Draw the rectangle with data BB & BC
    rectangle('Position',bb,'EdgeColor','r','LineWidth',1)
    %Plot the rectangle output
    plot(bc(1),bc(2),'-r*')
    %Output X&Y coordinates
    a{k}=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
end
%=========================================================================
%normalized cross correlation of Black car on first 
% image ur_c_s_03a_01_L_0371.png with other 6 image
figure
for j =1:6
    Black{j} = normxcorr2(Q1,gray{i});
    subplot(2,3,j)
    %the position of the maximum of the score map and a Red box corresponding
    %to the size of the template for all the 6 images
    imagesc(Black{j}),colormap gray, title('Find black Car',j)
    rectangle('Position', [530 365 115 55] ,'EdgeColor','b','LineWidth',1)
    hold on
    plot(587,392,'b*')  
end

%==========================================================================
%three different sizes of the window centered around the dark car
 Window1= double(c{1}(360:415,560:650));
    figure
    subplot(1,3,1),imagesc(Window1),colormap gray, title('Black car Window 1')
    win1 = double(im2gray(Window1));
 Window2= double(c{1}(355:425,555:660));
    %[15 pixels larger on each side]
    subplot(1,3,2),imagesc(Window2),colormap gray, title('Black car Window 2')
    win2 = double(im2gray(Window2));
 Window3= double(c{1}(340:435,540:670));
    %[40 pixels larger on each side]
    subplot(1,3,3),imagesc(Window3),colormap gray, title('Black car Window 3')
    win3 = double(im2gray(Window3));
    
%==========================================================================
%normalized cross correlation of Black car on Window 1,2,3 with other first image
tic;
w1 = normxcorr2(win1,gray{1});
figure,imagesc(w1),colormap gray, title('NNC Black car Window 1')
%the position of the maximum of the score map and a yellow box corresponding
%to the size of the template for all the 6 images
hold on
rectangle('Position', [530 365 115 55] ,'EdgeColor','y','LineWidth',1)
hold on
plot(587,392,'y*')
toc;

tic;
w2 = normxcorr2(win2,gray{1});
figure,imagesc(w2),colormap gray, title('NNC Black car Window 2')
%the position of the maximum of the score map and a yellow box corresponding
%to the size of the template for all the 6 images
hold on
rectangle('Position', [530 365 115 55] ,'EdgeColor','y','LineWidth',1)
hold on
plot(587,392,'y*')
toc;

tic;
w3 = normxcorr2(win3,gray{1});
figure,imagesc(w3),colormap gray, title('NNC Black car Window 3')
%the position of the maximum of the score map and a yellow box corresponding
%to the size of the template for all the 6 images
hold on
rectangle('Position', [530 365 115 55] ,'EdgeColor','y','LineWidth',1)
hold on
plot(587,392,'y*')
toc;


