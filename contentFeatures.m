function x = contentFeatures(Book_contents,wordList,a,b)
%CONTENTFEATURES takes in a Book_contents vector and produces a feature
%vector from the wordList given a and b
%   x = CONTENTFEATURES(Book_contents, wordList, a, b)
%This function will takes in a Book_contents vector and produces a feature
%vector from the wordList within Book_contents(a) and Book_contents(b)
%
%   x = CONTENTFEATURES(Book_contents, wordList, a)
%This function will takes in a Book_contents vector and produces 'a'
%feature vectors from the wordList each with a length of m/a.

%Usefull variable to get
m = size(wordList,1);

percent = 0;
if exist('b')
   x = zeros(m,1); 
    for j = a:b
        x = x + strcmp(Book_contents(j),wordList);
        
        %Show the progress of the algorithm
        if (j-a)*100/(b-a) > percent
           percent = percent +1;
           
           fprintf('.');
           if percent==50
               fprintf('\n');
           end
        end
    end    
else
   b=floor(size(Book_contents,2)/a);
   
   
   
   for i = 0:b-1
        xtemp = zeros(m,1);
        for j = (1+a*i):(a*(i+1))
            xtemp = xtemp + strcmp(Book_contents(j),wordList);
        end
        
        if exist('x')
            x = [x xtemp];
        else
            x = xtemp;
        end
        
        %Show the progress of the algorithm
        if i*100/b > percent
           percent = percent +1;
           fprintf('.');
           if percent==50
               fprintf('\n');
           end
        end
        
   end
end

%Transpose the result in order to have the variable in the right dimension
x = x';

    

end
