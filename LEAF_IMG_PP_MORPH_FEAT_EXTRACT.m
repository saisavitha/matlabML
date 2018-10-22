function LEAF_DATA_NORM_FORM = LEAF_IMG_PP_MORPH_FEAT_EXTRACT(LEAF_IMG_DAT_1,nRows,nColumns,threshold,LEAF_IMG_OUT_CNTRL)
if(LEAF_IMG_OUT_CNTRL == 1)
    % Display Original Image
    f = figure();
    set(f,'name','Input Images')
    imshow(LEAF_IMG_DAT_1);    
    set(gca, 'fontsize', 28);            
end
BWImg1 = rgb2gray(LEAF_IMG_DAT_1);

BWImg=rgb2hsv(BWImg1);

BWImg = imresize(BWImg,[nRows nColumns]);

LEAF_IN_IMG = double(imadjust(LEAF_IMG_DAT_1, [0 0.8], [0 1])); 
% To decrease contrast: increase a
% To increase contrast: decrease b
% To increase brightness: increase c
% To decrease brightness: decrease d
        
LEAF_RECOG_PHY_LENGTH_FEAT_ROI = LEAF_RECOG_GET_PHY_AREA_LENGTH(LEAF_IN_IMG);

ThresImage = LEAF_RECOG_PHY_LENGTH_FEAT_ROI>threshold;

if(LEAF_IMG_OUT_CNTRL == 1)
    
    f = figure();

    set(f,'name','Leaf Thresholded Image')       
	     
    imshow((LEAF_RECOG_PHY_LENGTH_FEAT_ROI>threshold)*64);

    colormap('gray');    

    set(gca, 'fontsize', 28);           
	 
end

Mask = ones(5,5);

ThresImage = imerode(ThresImage,Mask);%Remove isolated pixels

Mask = ones(5,5);

ThresImage = imdilate(ThresImage,Mask);%Get vein of leaf         

ThresImage = imresize(ThresImage,[nRows nColumns]);

FinalImg = double(BWImg) .* ThresImage;

[row,col,~] = find(FinalImg);

if (size(row,1) > 10)

    FinalImg = imresize(FinalImg(min(row):max(row),min(col):max(col)),[nRows nColumns]);

else

    FinalImg = imresize(BWImg,[nRows nColumns]);

end
    
if(LEAF_IMG_OUT_CNTRL == 1)

    
    f = figure();

    set(f,'name','Extractedregion')     
	                       
    imshow(FinalImg);     
	           
    set(gca, 'fontsize', 28);     
	       
end

LEAF_DATA_NORM_FORM = reshape(FinalImg,nRows*nColumns,1);