
function Ind = LEAF_CLASS_SVM(cAlpha,nTrainingSamples,InImWeight,omega)

Training = omega';

Ind = 1;

for ii = 2:size(cAlpha,2)
    
    Group = [ii*ones(1,nTrainingSamples) Ind*ones(1,nTrainingSamples)];
    

    Train = [Training((ii-1)*nTrainingSamples+1:(ii-1)*nTrainingSamples+nTrainingSamples,:); ...
            Training((Ind-1)*nTrainingSamples+1:(Ind-1)*nTrainingSamples+nTrainingSamples,:)];
        
    SVMStruct = svmtrain(Train, Group);    
    
   
    Ind = svmclassify(SVMStruct, InImWeight);
end
