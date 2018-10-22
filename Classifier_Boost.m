function Classification_Out_Post_Boosting = Classifier_Boost(SIND,SIND2,dclass,dclass2,Wt_Max_Boost)

Param_Dot_Operator_Boosting = '.';

Param_Define_Max_Iter = 10;

if(SIND > 0)
    
    Class_Boost = 1;

end

if(SIND2 > 0)
    
    Class_Boost2Lvl = 1;

end


if(Class_Boost && Class_Boost2Lvl)
    
    CLASS_BOOST_RES = BOOST_CLASSIFIER_PS_COMPUTE(Wt_Max_Boost, Param_Dot_Operator_Boosting , dclass);
    
    CLASS_BOOST_RES_T = cell2mat(CLASS_BOOST_RES(1));
    
    CLASS_BOOST_RES_T = str2num(CLASS_BOOST_RES_T);

    Iter_Lmt_Cmpte = CLASS_BOOST_RES_T / Param_Define_Max_Iter;
    
    Iter_Lmt_Cmpte = num2str(Iter_Lmt_Cmpte )
    
    Classification_Out_Post_Boosting_T = BOOST_CLASSIFIER_PS_COMPUTE(Iter_Lmt_Cmpte, Param_Dot_Operator_Boosting , dclass2);
    
    Classification_Out_Post_Boosting = num2str(cell2mat(Classification_Out_Post_Boosting_T(1)));
end
    

    
