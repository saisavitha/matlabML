function [LEAF_VECT_FEATU_POST_PROCESS ProjectedImages_PROJ_Feat_PP] = LEAF_RECOG_F(ImgMat,LEAF_VECT_FEATU_PCA_ALGO_PROCESS,nRows,nColumns,omega,Class_number,Class_population,LEAF_IMG_OUT_CNTRL)
               
P = Class_population * Class_number; 
ProjectedImages_PCA = omega;

m_PCA = mean(ProjectedImages_PCA,2); 
m = zeros(P,Class_number); 
Sw = zeros(P,P); 
Sb = zeros(P,P); 

for i = 1 : Class_number
    m(:,i) = mean( ( ProjectedImages_PCA(:,((i-1)*Class_population+1):i*Class_population) ), 2 )';    
    
    S  = zeros(P,P); 
    for j = ( (i-1)*Class_population+1 ) : ( i*Class_population )
        S = S + (ProjectedImages_PCA(:,j)-m(:,i))*(ProjectedImages_PCA(:,j)-m(:,i))';
    end
    
    Sw = Sw + S; 
    Sb = Sb + (m(:,i)-m_PCA) * (m(:,i)-m_PCA)'; 
end


Sw = Sw + ones(P);
[J_eig_vec, J_eig_val] = eig(Sb,Sw); 
LEAF_VECT_FEATU_POST_PROCESS = fliplr(J_eig_vec);


for i = 1 : Class_number-1 
    LEAF_VECT_FEATU_POST_PROCESS(:,i) = J_eig_vec(:,i); 
end



if(LEAF_IMG_OUT_CNTRL == 1)
    for i=1:P
        
        f = figure();
        Img = LEAF_VECT_FEATU_PCA_ALGO_PROCESS*LEAF_VECT_FEATU_POST_PROCESS(:,i);
        Img = reshape(Img,nRows,nColumns);
        set(f,'name','Extracted features')                                
        imagesc(Img);                    
        axis equal;
        colormap('gray');
        set(gca, 'fontsize', 28);            
    end
end


ProjectedImages_PROJ_Feat_PP = zeros(P,P);
for i = 1 : P
    ProjectedImages_PROJ_Feat_PP(:,i) = LEAF_VECT_FEATU_POST_PROCESS' * ProjectedImages_PCA(:,i);
end