function [check_general_Atplus1_At_Bt, check_general_Atplus1_At, check_general_At_Bt, check_general_At] = check_general()

    check_general_Atplus1_At_Bt(1,1:9)=1;
    check_general_Atplus1_At_Bt(1,10:18)=0;
    check_general_Atplus1_At_Bt(1,19:27)=-1;
 
    check_general_Atplus1_At_Bt(2,1:3)=1;
    check_general_Atplus1_At_Bt(2,10:12)=1;
    check_general_Atplus1_At_Bt(2,19:21)=1;
    check_general_Atplus1_At_Bt(2,4:6)=0;
    check_general_Atplus1_At_Bt(2,13:15)=0;
    check_general_Atplus1_At_Bt(2,22:24)=0;
    check_general_Atplus1_At_Bt(2,7:9)=-1;
    check_general_Atplus1_At_Bt(2,16:18)=-1;
    check_general_Atplus1_At_Bt(2,25:27)=-1;
    
    check_general_Atplus1_At_Bt(3,1:3:25)=1;
    check_general_Atplus1_At_Bt(3,2:3:26)=0;
    check_general_Atplus1_At_Bt(3,3:3:27)=-1;
    
    
    check_general_Atplus1_At(1,:)=check_general_Atplus1_At_Bt(2,:);
    check_general_Atplus1_At(2,:)=check_general_Atplus1_At_Bt(3,:);
    
    
    check_general_At_Bt(1,:)=check_general_Atplus1_At_Bt(1,:);
    check_general_At_Bt(2,:)=check_general_Atplus1_At_Bt(2,:);
    
    
    check_general_At(1,:)=check_general_Atplus1_At_Bt(2,:);
   
end
    

    
    
