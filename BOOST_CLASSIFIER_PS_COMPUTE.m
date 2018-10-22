function CLASS_BOOST_RES = BOOST_CLASSIFIER_PS_COMPUTE(PCA_FEATGET_BSTIN, BOOST_OPERATOR , INDATA_CLS)

assert(ischar(PCA_FEATGET_BSTIN) && ndims(PCA_FEATGET_BSTIN) == 2 && size(PCA_FEATGET_BSTIN,1) <= 1, ...
    'BOOST_CLASSIFIER_PS_COMPUTE:invalidarg', ...
    'The first input argument should be a char string.');

if nargin < 2
    
    SUB_SPACE_BOOSTING = true;
    
else
    pca_param_opt = BOOST_OPERATOR;
    
    assert(ischar(pca_param_opt) && ndims(pca_param_opt) == 2 && size(pca_param_opt,1) == 1 && ~isempty(pca_param_opt), ...
        'BOOST_CLASSIFIER_PS_COMPUTE:invalidarg', ...
        'The BOOST_OPERATOR should be a non-empty');
    
    pca_param_opt = strtrim(pca_param_opt);
    
    SUB_SPACE_BOOSTING = isempty(pca_param_opt);
end
    
tmp_str_boost = INDATA_CLS;

PCA_FEATGET_BSTIN = strtrim(PCA_FEATGET_BSTIN);

if SUB_SPACE_BOOSTING
    
    pca_wts_refine = isspace(PCA_FEATGET_BSTIN);     
    
    if any(pca_wts_refine)
             
        pca_diff_wts_define = diff(pca_wts_refine);
        
        feat_indx = [1, find(pca_diff_wts_define == -1) + 1];  
        
        ep = [find(pca_diff_wts_define == 1), length(PCA_FEATGET_BSTIN)];  
        
               
        nt = numel(feat_indx);
        
        CLASS_BOOST_RES = cell(1, nt);
        
        for i = 1 : nt
            
            CLASS_BOOST_RES{i} = PCA_FEATGET_BSTIN(feat_indx(i):ep(i));
            
        end  
        
    else
        
        CLASS_BOOST_RES = {PCA_FEATGET_BSTIN};
        
    end
    
else  
    
    CLASS_EVAL_OPTN = strfind(PCA_FEATGET_BSTIN, pca_param_opt);
    
    if ~isempty(CLASS_EVAL_OPTN)        
              
        nt = numel(CLASS_EVAL_OPTN) + 1;
        
        CLASS_BOOST_RES = cell(1, nt);
        
        feat_indx = 1;
        
        dl = length(BOOST_OPERATOR);
        
        for i = 1 : nt-1
            
            CLASS_BOOST_RES{i} = strtrim(PCA_FEATGET_BSTIN(feat_indx:CLASS_EVAL_OPTN(i)-1));
            
            feat_indx = CLASS_EVAL_OPTN(i) + dl;
            
        end     
        
        CLASS_BOOST_RES{nt} = strtrim(PCA_FEATGET_BSTIN(feat_indx:end));
        
    else
        
        CLASS_BOOST_RES = {PCA_FEATGET_BSTIN};
        
    end    
    
end
