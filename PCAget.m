
function [InImWeight wt_bst] = PCAget(LEAF_DATA_NORM_FORM,u,wt)

InImWeight = zeros(1,size(u,2));

for i=1:size(u,2)    

    WeightOfInputImage = dot(u(:,i)',double(LEAF_DATA_NORM_FORM'));   
	 
    InImWeight(i) = WeightOfInputImage;

end

wt_bst = wt;