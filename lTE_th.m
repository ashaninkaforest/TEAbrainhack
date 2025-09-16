function [PWTE, norm_Atplus1_At_Bt, TE, TE_Hnorm] = lTE_th(Dati,Th,check_general_Atplus1_At_Bt, check_general_Atplus1_At, check_general_At_Bt, check_general_At)

% ROI2 --> ROI1

    [nTS, nROI]=size(Dati);

    Dati_local_zscore=zscore(Dati);
    Dati_local_zscore(Dati_local_zscore>-Th&Dati_local_zscore<Th)=0;
    Dati_local_zscore(Dati_local_zscore>Th)=1;
    Dati_local_zscore(Dati_local_zscore<-Th)=-1;
    
    
    distribution_Atplus1_At_Bt(1:27,1:(nROI*nROI))=0;
    distribution_Atplus1_At(1:27,1:(nROI*nROI))=0;
    distribution_At_Bt(1:27,1:(nROI*nROI))=0;
    distribution_At(1:27,1:(nROI*nROI))=0;
    
    k=1;

   
    
    for ROI1=1:1:nROI
       
        for ROI2=1:1:nROI
              

            m(1,1)=1;

            count=1;        
        
            for i=m(1,1)+1:1:nTS

                Atplus1_At(1:m+1,count)=Dati_local_zscore(i-m:i,ROI1);
                Bt(1:m,count)=Dati_local_zscore(count:count+m-1,ROI2);
                count=count+1;

            end
        
            Atplus1_At_Bt(1:m,:)=Bt;
            Atplus1_At_Bt(m+1:m+m+1,:)=Atplus1_At;
    
            At_Bt(1,:) = Bt;
            At_Bt(2,:) = Atplus1_At(1,:);%A region at t time, same as B region at t time
    
            At(1,:)= Atplus1_At(1,:);
             
            s_size=size(Atplus1_At_Bt);

            for i=1:1:s_size(1,2)
                % sum the number of every state, using matching method
                for ii=1:1:27
                
                    check_Atplus1_At_Bt=Atplus1_At_Bt(:,i)-check_general_Atplus1_At_Bt(:,ii);
                    check_Atplus1_At=Atplus1_At(:,i)-check_general_Atplus1_At(:,ii);
                    check_At_Bt=At_Bt(:,i)-check_general_At_Bt(:,ii);
                    check_At=At(:,i)-check_general_At(:,ii);
            
                    if sum(abs(check_Atplus1_At_Bt))==0
            
                        distribution_Atplus1_At_Bt(ii,k)=distribution_Atplus1_At_Bt(ii,k)+1;
            
                    end
            
                    if sum(abs(check_Atplus1_At))==0
            
                        distribution_Atplus1_At(ii,k)=distribution_Atplus1_At(ii,k)+1;
            
                    end
            
                    if sum(abs(check_At_Bt))==0
            
                        distribution_At_Bt(ii,k)=distribution_At_Bt(ii,k)+1;
            
                    end
            
                    if sum(abs(check_At))==0
            
                        distribution_At(ii,k)=distribution_At(ii,k)+1;
            
                    end
                
                end
            
            clear check_Atplus1_At_Bt check_Atplus1_At check_At_Bt check_At
        
            end
        
        k=k+1;
     
        clear Atplus1_At_Bt Atplus1_At At_Bt At Bt
     
        end
    
    end

    probablity_Atplus1_At_Bt=distribution_Atplus1_At_Bt./distribution_At_Bt;
    probablity_Atplus1_At=distribution_Atplus1_At./distribution_At;
    
    probablity_Atplus1_At_Bt(isnan(probablity_Atplus1_At_Bt))=0;
    probablity_Atplus1_At(isnan(probablity_Atplus1_At))=0;
    

    
    PWTE=log(probablity_Atplus1_At_Bt./probablity_Atplus1_At);
    PWTE(isnan(PWTE))=0;
    PWTE(PWTE<-1000000)=0;
    
    norm_Atplus1_At_Bt= distribution_Atplus1_At_Bt./(nTS-1);
    norm_Atplus1_At = distribution_Atplus1_At ./(nTS-1);
    sup=log(probablity_Atplus1_At);
    sup(isnan(sup))=0;
    sup(sup<-1000000)=0;

    H_norm=sum(norm_Atplus1_At .* sup)*(-1);

    TE = sum(norm_Atplus1_At_Bt .* PWTE);
    TE_Hnorm = TE ./ H_norm;

    clear ROI1 ROI2

    clear Dati_local i ii k m count s_size distribution_Atplus1_At_Bt distribution_Atplus1_At distribution_At_Bt distribution_At probablity_Atplus1_At_Bt probablity_Atplus1_At
    
end
%