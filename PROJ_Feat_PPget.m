function ProjectedTestImage = PROJ_Feat_PPget(TestImage, LEAF_VECT_FEATU_PCA_ALGO_PROCESS, LEAF_VECT_FEATU_POST_PROCESS)



ProjectedTestImage = LEAF_VECT_FEATU_POST_PROCESS' * LEAF_VECT_FEATU_PCA_ALGO_PROCESS' * TestImage; 