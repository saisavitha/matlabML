
function Class = LEAF_CLASS_KNN(cAlpha,nTrainingSamples,InImWeight,omega)
Training = omega';%store features in training matrix
Group = zeros(size(cAlpha,2)*nTrainingSamples,1);%Store group details
ll = 1;
for ii = 1:size(cAlpha,2)
    for jj = 1:nTrainingSamples
        Group(ll) = ii;
        ll = ll + 1;
    end
end


Class = knnclassify(InImWeight, Training, Group, nTrainingSamples, 'euclidean','random');

