
clc;

clear all;

close all;


addpath('./Trng/1');

addpath('./Trng/2');

addpath('./Trng/3');

addpath('./Trng/4');

addpath('./Trng/5');

addpath('./Trng/6');

addpath('./Trng/7');

addpath('./Trng/8');

addpath('./Trng/9');

addpath('./Trng/10');

addpath('./Tstn/1');

addpath('./Tstn/2');

addpath('./Tstn/3');

addpath('./Tstn/4');

addpath('./Tstn/5');

addpath('./Tstn/6');

addpath('./Tstn/7');

addpath('./Tstn/8');

addpath('./Tstn/9');

addpath('./Tstn/10');



Symbol = input('PLEASE SELECT THE CLASS OF LEAF CATEGORY ( 1-10) -','s');

Num = input('PLEASE SELECT THE LEAF IMAGE NUMBER WITHIN THIS CATEGORY (1-10)-');

InputImage = strcat(Symbol,'',num2str(Num),'.jpg');


[LEAF_IMG_DAT_1,Map_Frm] = Map_Gen_Data_Get(InputImage);

LEAF_FEAT_VALS_TEST =LEAF_PP_FEAT_EXTRACT(double(LEAF_IMG_DAT_1));

lEaf_USR_SEL_DATA = [{'1'},{'2'},{'3'},{'4'},{'5'},{'6'},{'7'},{'8'},{'9'},{'10'}];

nTrainingSamples = 9;

nRows = 120;

nColumns = 160;

ImgMat = zeros(nRows*nColumns,size(lEaf_USR_SEL_DATA,2)*nTrainingSamples);

LEAF_IMG_OUT_CNTRL = 0;

if (nTrainingSamples ~= 1)
    
    LEAF_IMG_OUT_CNTRL = 0;
    
end

nEigValThres = 0.0001;

threshold = -2;


Indx_Val = 1;

for ii = 1:size(lEaf_USR_SEL_DATA,2);
    
    for jj = 1:nTrainingSamples ;
        
        sFilename = strcat(lEaf_USR_SEL_DATA(ii),'T',int2str(jj),'.jpg');
        
        ColorImg1 = imread(char(sFilename));
        % ACCORDING TO THE FUTURE WORK WE ARE TAKING ONE COLOR IMAGE AND WE
        % ARE CONVERTING THAT IMAGE TO HSV IMAGE. IT WILL INCREASE THE
        % CONTRAST OF THAT IMAGE.
        
        ColorImg=rgb2hsv(ColorImg1);
        
        %OR ELSE TO INCREASE THE CONTRAST WE HAVE TO INCREASE THE VALUES OF
        
        %VARIABLE A, B , C, D WHIC ARE GIVEN IN THE ADJUSTING  THE IMAGE.
        
        LEAF_FEAT_VALS_EXTRACTED(:,Indx_Val) =LEAF_PP_FEAT_EXTRACT(double(ColorImg));
        
        FinalImg = LEAF_IMG_PP_MORPH_FEAT_EXTRACT(ColorImg,nRows,nColumns,threshold,0);        
        
        
        
        ImgMat(:,Indx_Val) = FinalImg;
        
        Indx_Val = Indx_Val + 1;
        
    end
    
end



[PCAfeatures omega] = PCATraining(ImgMat,nRows,nColumns,LEAF_IMG_OUT_CNTRL,nEigValThres);

[LEAF_VECT_FEATU_POST_PROCESS ProjectedImages_PROJ_Feat_PP] = LEAF_RECOG_F(ImgMat,PCAfeatures,nRows,nColumns,omega,size(lEaf_USR_SEL_DATA,2),nTrainingSamples,LEAF_IMG_OUT_CNTRL);


ProcImg = LEAF_IMG_PP_MORPH_FEAT_EXTRACT(LEAF_IMG_DAT_1,nRows,nColumns,threshold,LEAF_IMG_OUT_CNTRL);

ProcImg = double(ProcImg);

[InImWeight Wt_Max_Boost] = PCAget(ProcImg,PCAfeatures,Map_Frm);

InImWeight2 = PROJ_Feat_PPget(ProcImg,PCAfeatures,LEAF_VECT_FEATU_POST_PROCESS);



Class = LEAF_CLASS_KNN(lEaf_USR_SEL_DATA,nTrainingSamples,InImWeight,omega);

Ind = LEAF_CLASS_SVM(lEaf_USR_SEL_DATA,nTrainingSamples,InImWeight,omega);

Class2 = LEAF_CLASS_KNN(lEaf_USR_SEL_DATA,nTrainingSamples,InImWeight2',ProjectedImages_PROJ_Feat_PP);

Ind2 = LEAF_CLASS_SVM(lEaf_USR_SEL_DATA,nTrainingSamples,InImWeight2',ProjectedImages_PROJ_Feat_PP);

RecogLeaf = Classifier_Boost(Ind,Ind2,Class,Class2,Wt_Max_Boost);


if(RecogLeaf == '1')
    LEAF_BOTANICAL_NAME = 'Ficus religiosa Linn';
end
if(RecogLeaf == '2')
    LEAF_BOTANICAL_NAME = 'SEMICARPUS ANACARDIUM LINN.F';
end
if(RecogLeaf == '3')
    LEAF_BOTANICAL_NAME = 'HYDROCARPUS WIGHTIANA BLUME';
end
if(RecogLeaf == '4')
    LEAF_BOTANICAL_NAME = 'BALIOSPERMUM MONTANUM ';
end
if(RecogLeaf == '5')
    LEAF_BOTANICAL_NAME = 'TERMINALIA ARJUNA ';
end
if(RecogLeaf == '6')
    LEAF_BOTANICAL_NAME = 'FICUS RACEMOSA LINN';
end
if(RecogLeaf == '7')
    LEAF_BOTANICAL_NAME = 'BOTANICAL NAME';
end
if(RecogLeaf == '8')
    LEAF_BOTANICAL_NAME = 'CELASLRUS PANICULATUS WILLD';
end
if(RecogLeaf == '9')
    LEAF_BOTANICAL_NAME = 'MIMUSOPS ELENGI LINN  ';
end
if(RecogLeaf == '10')
    LEAF_BOTANICAL_NAME = 'CALOPHYLLUM INOPHYLLUM  LINN';
end



f = figure();

set(gca, 'fontsize', 10);            

set(f,'name','SVM')

subplot (1,2,1)

imshow(LEAF_IMG_DAT_1);

title('Input image','fontsize', 10)

subplot (1,2,2)

RecongImg = strcat(RecogLeaf,'1.jpg');

imshow(char(RecongImg)); 

title(strcat('Recognized LEAF SPECIES IS : -',RecogLeaf,':',LEAF_BOTANICAL_NAME),'fontsize', 10);
