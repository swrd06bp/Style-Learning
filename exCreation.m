%% ExCreation
%     
%
%  This file saves some exemples of books into variables that will be used 
%  later to implement a machine learning algorithm to recognize the style of
%  different authors.
%  This matlab file uses those following functions :
%
%       - getCompleteVocabList.m
%       - readFile.m
%       - processBook.m
%       - contentFeatures.m
%

%% Initialization
close all; clc ; clear all;

%% ================== Part 1: VocabList Preprocessing ==================
%We process the vocab list into a porter stemmer algorithm to simplify 
%the process and elimitate words that are very similar

fprintf('\n==== Proccessing the vocabList ====\n\n');
fprintf('This operation can take some time :\n');
wordList = getCompleteVocabList();

%% =================== Part 2: Book Preprocessing ===================
%We provide a list of books from the same author.
%First we separate them into different fractions then we modify them
%with the same algorithm used to process the vacabList


fprintf('\n\n==== Reading the BOOK ====\n\n');

% the algorithm will read books from G.Orwell

% Read exemple 1
file_contents1 = readFile('ex1984.txt');

% Read exemple 2
file_contents2 = readFile('exDownandOutinParisandLondon.txt');

% the algorithm will read books from J.K.Rowling

% Read exemple 3 
file_contents3 = readFile('exHarryPotter1.txt');

% Read exemple 4
file_contents4 = readFile('exABraveNewWord.txt');

% Read exemple 5
file_contents5 = readFile('exIRobotRobie.txt');

%file_contents4 = readFile('exHarryPotter2.txt');

% Read exemple 4
%file_contents4 = readFile('exHarryPotter3.txt');

%Call the function processBook indor to divide the book into different
%sections (pages/chapters). 

fprintf('\n==== Processing the BOOK ====\n\n');
fprintf('This operation can take some time :\n');

%Process exemple 1
[Page_indices1 Chapter_indices1 Book_contents1] = ...
                                    processBook(file_contents1);
fprintf('\n');
                                
%Process exemple 2
[Page_indices2 Chapter_indices2 Book_contents2] = ...
                                    processBook(file_contents2);

%Process exemple 3                         
fprintf('\n');

[Page_indices3 Chapter_indices3 Book_contents3] = ...
                                    processBook(file_contents3);
                                
%Process exemple 4                         
fprintf('\n');

[Page_indices4 Chapter_indices4 Book_contents4] = ...
                                    processBook(file_contents4);

%Process exemple 5 
fprintf('\n');

[Page_indices5 Chapter_indices5 Book_contents5] = ...
                                    processBook(file_contents5);
                                
%% ======== Part 2: Extract the features of the Book ===================
%Given the Book_contents, the wordList and the number of sections of the
%book this function will provide X_book variable with m exemples (row) with
%n features capturing the entire book.

fprintf('\n\n==== Extracting the features ====\n\n');
fprintf('This operation can take some time :\n');

%Parameters indicating the length (in number of words) of the training
%exemples
a = 500; %Can be changed if wanted

%Parameter of book 1
b1 = floor(size(Book_contents1,2)/a);
%Parameter of book 2
b2 = floor(size(Book_contents2,2)/a);
%Parameter of book 3
b3 = floor(size(Book_contents3,2)/a);
%Parameter of book 4
b4 = floor(size(Book_contents4,2)/a);
%Parameter of book 5
b5 = floor(size(Book_contents5,2)/a);


%Get the features off the diffrents books

%Process exemple 1
X_Book1 = contentFeatures(Book_contents1,wordList,a);
Y_Book1 = zeros(b1,1);

fprintf('\n');

%Process exemple 2
X_Book2 = contentFeatures(Book_contents2,wordList,a);
Y_Book2 = ones(b2,1);

fprintf('\n');

%Process exemple 3
X_Book3 = contentFeatures(Book_contents3,wordList,a);
Y_Book3 = ones(b3,1);

fprintf('\n');

%Process exemple 4
X_Book4 = contentFeatures(Book_contents4,wordList,a);
Y_Book4 = ones(b4,1);

%Process exemple 5
X_Book5 = contentFeatures(Book_contents5,wordList,a);
Y_Book5 = ones(b5,1);

indexBook = [0 b1 b1+b2 b1+b2+b3 b1+b2+b3+b4 b1+b2+b3+b5];


%% ======== Part 3: Processed the final results ===================
%Show a exemple of the first page

%Put all the matrice in one 
X_Book = [X_Book1;X_Book2;X_Book3;X_Book4;X_Book5];
Y_Book = [Y_Book1;Y_Book2;Y_Book3;Y_Book4;Y_Book5];

% Determine what are the coefficient that are not equal to zero
M = sum(X_Book);

% Replace the X_Book to a reduced one
X_Book = X_Book(:,find(M>0));

% replace the wordList to a reduced one
wordList = wordList(find(M>0));

%% ==================== Part 4: Save the work ===========================
%Create a file where everything will be saved

save ExBooks.mat X_Book Y_Book wordList indexBook





