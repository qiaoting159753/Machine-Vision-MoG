function [Precision,Recall,F1] = precision_recall_f1(Input,Ground_Truth)
    dimens = size(Input);
    dimens2 = size(Ground_Truth);
    
    %Input and Ground_Truth must have same dimention
    if dimens ~= dimens2 
        return
    end
    
    %store the TP,FP,TN,FN
    TPA = 0;
    FPA = 0;
    TNA = 0;
    FNA = 0;
    
    %For each pixel
    for row = 1:dimens(1)
        for column = 1:dimens(2)
        
            %True positive: result is the same as ground truth
            if (Input(row,column) ==1) && (Ground_Truth(row,column) == 1)
                TPA = TPA + 1;
            end
            
            %False Positive: result is positive, but it is wrong
            if (Input(row,column) == 1) && (Ground_Truth(row,column) == 0)
                FPA = FPA + 1;
            end
                
            %True Negative: The result is negative, the ground truth is
            %negative as well.
            if (Input(row,column) == 0) && (Ground_Truth(row,column) == 0)
                TNA = TNA + 1;
            end
                
            %False Negative: The result is negative, the ground truth
            %is positive. 
            if (Input(row,column) == 0) && (Ground_Truth(row,column) == 1)
                FNA = FNA + 1;
            end
        end
    end
    
    %Calculate the true positive rate and false positive rate.
    Precision = TPA / (TPA + FPA);
    Recall = TPA / (TPA + FNA);
    F1 = (2 * Precision * Recall)/(Precision + Recall);
end