function [X_Book_Train Y_Book_Train X_Book_Val Y_Book_Val] = ...
                      getCVEx(X_Book,Y_Book,indexBook,VolumeCV,k,position)

%This function will provide X_Training 
    X_Book_Train = zeros(0);
    Y_Book_Train = zeros(0);
    
   

    X_Book_Val = zeros(0);
    Y_Book_Val = zeros(0);
    

%      
%   if position is equal to 2 and k = 5
%   then
%
%   a      position   postion+1                                         b
%   |---------|---------|---------|---------|---------|-----------------|
%    <--D1---> <---D2--> <------------D3------------->
%    <-----------------VolumeCV----------------------> <--(1-VolumeCV)-->
%
%
%  D1 = a + (b-a)*VolumeCV*position*/k
%         :
%  D2 = a + (b-a)*Volume*(position/k + (position+1)/k - position/k)
%  D3 = a + (b-a)*(Volume - Volume*(position+1)/k)


    for i = 1:(size(indexBook,2)-1)
       
       D1 = (indexBook(i)+1):...
                (indexBook(i)+1) + ...
                floor((indexBook(i+1)-indexBook(i))*VolumeCV*(position-1)/k);
         
       
            
       D2 = (indexBook(i)+1 + ...
            ceil((indexBook(i+1)-indexBook(i))*VolumeCV*(position-1)/k)):...      
            (indexBook(i)+1+...
            floor((indexBook(i+1)-indexBook(i))*VolumeCV*(position)/k));
               
               
       D3 = (indexBook(i)+1 +...
            ceil((indexBook(i+1)-indexBook(i))*VolumeCV*(position)/k)):...
            (indexBook(i)+floor((indexBook(i+1)-indexBook(i))*VolumeCV));
             
       X_Book_Val = [X_Book_Val;X_Book(D2,:)];
                  
       Y_Book_Val = [Y_Book_Val;Y_Book(D2)];
          
       X_Book_Train = [X_Book_Train;X_Book(D1,:);X_Book(D3,:)];
                  
       Y_Book_Train = [Y_Book_Train;Y_Book(D1);Y_Book(D3)];
                 
    end
        
end