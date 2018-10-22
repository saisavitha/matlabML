function im2 = LEAF_DATA_NORM_PROCESS(LEAF_IN_IMG)


im2 = LEAF_IN_IMG - min(min(min(LEAF_IN_IMG)));

if (max(max(max(im2))) ~= 0)

    im2 = im2 / max(max(max(im2)));

end