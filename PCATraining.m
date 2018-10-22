
function [u omega] = PCATraining(ImgMat,nRows,nColumns,LEAF_IMG_OUT_CNTRL,nEigValThres)
%% Carry out PCA to extract features
% Find Covariance matrix in terms of vectors
L = ImgMat'*(ImgMat);%Covariance Matrix

[vv dd]=eig(L);%vv is eigen vectors, dd = eigen values
% Sort and eliminate those whose eigenvalue is less than threshold
v = zeros(size(vv));
d = zeros(1,size(dd,1));
NoOfFeatures = 0;
for i=1:size(vv,2)
    if(dd(i,i)>nEigValThres)
        v(:,i) = vv(:,i);%Store only vectors above threshold
        d(i) = dd(i,i);%%Store only Eigne values above threshold
        NoOfFeatures = NoOfFeatures + 1;%Count no of vectors saved
    end
end

%% Sort the Eigen Vectors from ascending to descending sequence 
v = fliplr(v);

%% Normalize Eigen vectors to unit magnitude
for i=1:NoOfFeatures %access each column
    kk = v(:,i);
    temp = sqrt(sum(kk.^2));%Calculate Magnitude
    v(:,i)=v(:,i)./temp;%Normalize each vector
end

%% Find Eigenvectors of actual Covariance matrix = ImgMat*ImgMat' 
% This is for using v2 = X * v1
u = ImgMat * v;

%% Normalize the Eigen vectors
for i=1:NoOfFeatures    
    kk=u(:,i);
    temp=sqrt(sum(kk.^2));%Find magnitude
    u(:,i)=u(:,i)./temp;%Normalize Eigen vectors
end

%% Show the PCA extracted features
if(LEAF_IMG_OUT_CNTRL == 1)
    for i=1:NoOfFeatures    
        % Display Extracted features
        f = figure();
        set(f,'name','Extracted Eigen features')                               
        Img = reshape(u(:,i),nRows,nColumns);%Reshape each vector to image        
        imagesc(Img);  
        axis equal;
        colormap('gray');
        set(gca, 'fontsize', 28);            
    end
end

%% Find the weight of each original symbol in the training set in transformed space
omega = zeros(NoOfFeatures,NoOfFeatures);
for i = 1 : NoOfFeatures
    omega(:,i) = u' * ImgMat(:,i);    
end
