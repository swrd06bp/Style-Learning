function [p accuracy prob] = testBookModel(exBook, class, model, wordList)

    file_contents = readFile(exBook);
    
    [Page_indices Chapter_indices Book_contents] = ...
                                    processBook(file_contents);
                                
     
     a = 500; %Can be changed if wanted

     %Parameter of the book
     b = floor(size(Book_contents,2)/a);     
     
     fprintf('\n');
     %Process exemple 1
    X_Book = contentFeatures(Book_contents,wordList,a);
    
    if class == 0
        Y_Book = zeros(b,1);
    elseif class == 1
        Y_Book = ones(b,1);
    end
    
    [p prob] = svmPredict(model, X_Book);
     accuracy = mean(double(p == Y_Book)) * 100;
     
end