function LEAF_RECOG_PHY_LENGTH_FEAT_ROI = LEAF_RECOG_GET_PHY_AREA_LENGTH(LEAF_IN_IMG)
persistent leaf_feat_cntr;      

if (isempty(leaf_feat_cntr))    

    leaf_recog_physi_fn = 'leafmodel.bin';

    fid = fopen(leaf_recog_physi_fn, 'rb');

    tmp = fread(fid, inf, 'real*4'); 

    fclose(fid);

    K = 32;

    leaf_feat_cntr = zeros(K,K,K);

    leaf_feat_cntr(:) = tmp(:);

    clear tmp

end

if (size(LEAF_IN_IMG,3) ~= 3)

    warning('Input image does not have 3 bands. RGB image required.');

    LEAF_RECOG_PHY_LENGTH_FEAT_ROI = [];

    return

end

LEAF_IN_IMG = double(LEAF_IN_IMG);

im2 = 1 + floor(LEAF_IN_IMG(:,:,1)/8)+floor(LEAF_IN_IMG(:,:,2)/8)*32+floor(LEAF_IN_IMG(:,:,3)/8)*32*32; 

LEAF_RECOG_PHY_LENGTH_FEAT_ROI = leaf_feat_cntr(im2); % mask



