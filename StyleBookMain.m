%% Machine Learning Online Class
%  Exercise 6 | Spam Classification with SVMs
%
%  Instructions
%  ------------
% 
%  This file contains code that helps you get started on the
%  exercise. You will need to complete the following functions:
%
%     gaussianKernel.m
%     dataset3Params.m
%     processEmail.m
%     emailFeatures.m
%
%  For this exercise, you will not need to change any code in this file,
%  or any other files other than those mentioned above.
%

%% Initialization
close all; clc ; clear all;

%% Loading the data
% In your environement, you will have the following variables:
%       - wordList: a vector containing all the English words proccessed
%                   with the PORTER algorithm
%       - X_Book: a 'm' by 'n' matrix representing the number of words
%                  proccessed with PORTER algorithm read in a section of 
%                  length 'a' of different books.
%                  'm' is the number of exemples privided and 'n' is the
%                   number of features.
%       - Y_Book: a vector of integers that classifies the author

load('ExBooks.mat');

fprintf('I read everything')

[m n] = size(X_Book);

[X_Book_Norm, mu, sigma] = featureNormalize(X_Book);

%% =========== Part 1: Train Linear SVM for Book Classification ========
%  In this section, you will train a linear classifier to determine the
%  style of a given author


%X_Book_Train = X_Book_Norm(41:350,:);
%X_Book_Train = X_Book(41:350,:);
%Y_Book_Train = Y_Book(41:350,:);

%Training exemples. We take only 60 per cent of the content of each book.
%X_Book_Train = [X_Book(indexBook(1):floor(indexBook(2)*0.6),:);...
                %X_Book(indexBook(2)+1:indexBook(2) + ...
                             %floor((indexBook(3)-indexBook(2))*0.6),:);...
                %X_Book(indexBook(3)+1:indexBook(3) + ...
                             %floor((indexBook(4)-indexBook(3))*0.6),:);...
                %X_Book(indexBook(4)+1:indexBook(4) + ...
                 %            floor((indexBook(5)-indexBook(4))*0.6),:)];
            
%Y_Book_Train = [Y_Book(indexBook(1):floor(indexBook(2)*0.6));...
 %               Y_Book(indexBook(2)+1:indexBook(2) + ...
  %                           floor((indexBook(3)-indexBook(2))*0.6));...
   %             Y_Book(indexBook(3)+1:indexBook(3) + ...
    %                         floor((indexBook(4)-indexBook(3))*0.6));...
     %           Y_Book(indexBook(4)+1:indexBook(4) + ...
      %                       floor((indexBook(5)-indexBook(4))*0.6))];

%Cross validation exemples We take 20 per cent of each book.
%X_Book_Val = [X_Book(ceil(indexBook(2)*0.6):floor(indexBook(2)*0.8),:);...
 %             X_Book(indexBook(2)+ ...
  %                ceil((indexBook(3)-indexBook(2))*0.6):indexBook(2) + ...
   %                          floor((indexBook(3)-indexBook(2))*0.8),:);...
    %          X_Book(indexBook(3)+ ...
     %             ceil((indexBook(4)-indexBook(3))*0.6):indexBook(3) + ...
      %                       floor((indexBook(4)-indexBook(3))*0.8),:);...
       %       X_Book(indexBook(4)+ ...
        %          ceil((indexBook(5)-indexBook(4))*0.6):indexBook(4) + ...
         %                    floor((indexBook(5)-indexBook(4))*0.8),:)];
            
%Y_Book_Val = [Y_Book(ceil(indexBook(2)*0.6):floor(indexBook(2)*0.8));...
 %             Y_Book(indexBook(2)+ ...
  %                ceil((indexBook(3)-indexBook(2))*0.6):indexBook(2) + ...
   %                          floor((indexBook(3)-indexBook(2))*0.8));...
    %          Y_Book(indexBook(3)+ ...
     %             ceil((indexBook(4)-indexBook(3))*0.6):indexBook(3) + ...
      %                       floor((indexBook(4)-indexBook(3))*0.8));...
       %       Y_Book(indexBook(4)+ ...
        %          ceil((indexBook(5)-indexBook(4))*0.6):indexBook(4) + ...
         %                    floor((indexBook(5)-indexBook(4))*0.8))];

k = 20;
Best_model.w = zeros(n,1);
Best_model.b = 0;
         
for position = 1:k        
         
    [X_Book_Train Y_Book_Train X_Book_Val Y_Book_Val] = ...
                      getCVEx(X_Book,Y_Book,indexBook,0.8,k,position);
         
         
         
    fprintf('\nTraining Linear SVM (Spam Classification)\n')
    fprintf('(this may take 1 to 2 minutes) ...\n')

    Best_accuracy_train = 0;
    Best_accuracy_val = 0;

    for i = 1 : 100
        %Training the model
        C = 0.1;
        model = svmTrain(X_Book_Train, Y_Book_Train, C, @linearKernel);
    
        %Evaluating the model on the training exemples
        [p_train prob_train] = svmPredict(model, X_Book_Train);
        accuracy_train = mean(double(p_train == Y_Book_Train)) * 100;
    
        %Evaluating the model on the validation exemples
        [p_val prob_val] = svmPredict(model, X_Book_Val);
        accuracy_val = mean(double(p_val == Y_Book_Val)) * 100;
    
        if accuracy_val > Best_accuracy_val
            Best_accuracy_val = accuracy_val;
            Best_accuracy_train = accuracy_train;
        
            Best_submodel{position} = model;
        
        elseif accuracy_val == Best_accuracy_val
            if accuracy_train > Best_accuracy_train
                Best_accuracy_train = accuracy_train; 
           
                Best_submodel{position} = model;
            end 
        end
    
    end
   
    Best_model.w = Best_model.w + Best_submodel{position}.w;
    Best_model.b = Best_model.b + Best_submodel{position}.b;
    
    
end
    
Best_model.w = Best_model.w/k;
Best_model.b = Best_model.b/k;

Best_model.kernelFunction = Best_submodel{position}.kernelFunction;

%% =================== Part 4: Cross Validation ================
% This is showing the results and the training data versus the cross
% validation data.

[p_train prob_train] = svmPredict(Best_model, X_Book_Train);
[p_val prob_val] = svmPredict(Best_model, X_Book_Val);

fprintf('Training Accuracy: %f\n', mean(double(p_train == Y_Book_Train)) * 100);
fprintf('Validation Accuracy: %f\n', mean(double(p_val == Y_Book_Val)) * 100);


%% =================== Part 4: Test Spam Classification ================
%  After training the classifier, we can evaluate it on a test set. We have
%  included a test set in spamTest.mat

%X_Book_Test = [X_Book_Norm(1:40,:);X_Book_Norm(351:373,:)];
%X_Book_Test = [X_Book(1:40,:);X_Book(351:373,:)];
%Y_Book_Test = [Y_Book(1:40);Y_Book(351:373)];

X_Book_Test = [X_Book(ceil(indexBook(2)*0.8):floor(indexBook(2)*1),:);...
              X_Book(indexBook(2)+ ...
                  ceil((indexBook(3)-indexBook(2))*0.8):indexBook(2) + ...
                             floor((indexBook(3)-indexBook(2))*1),:);...
              X_Book(indexBook(3)+ ...
                  ceil((indexBook(4)-indexBook(3))*0.8):indexBook(3) + ...
                             floor((indexBook(4)-indexBook(3))*1),:);...
              X_Book(indexBook(4)+ ...
                  ceil((indexBook(5)-indexBook(4))*0.8):indexBook(4) + ...
                             floor((indexBook(5)-indexBook(4))*1),:)];
            
Y_Book_Test = [Y_Book(ceil(indexBook(2)*0.8):floor(indexBook(2)*1));...
              Y_Book(indexBook(2)+ ...
                  ceil((indexBook(3)-indexBook(2))*0.8):indexBook(2) + ...
                             floor((indexBook(3)-indexBook(2))*1));...
              Y_Book(indexBook(3)+ ...
                  ceil((indexBook(4)-indexBook(3))*0.8):indexBook(3) + ...
                             floor((indexBook(4)-indexBook(3))*1));...
              Y_Book(indexBook(4)+ ...
                  ceil((indexBook(5)-indexBook(4))*0.8):indexBook(4) + ...
                             floor((indexBook(5)-indexBook(4))*1))];

fprintf('\nEvaluating the trained Linear SVM on a test set ...\n')

[p_test prob_test] = svmPredict(Best_model, X_Book_Test);

fprintf('Test Accuracy: %f\n', mean(double(p_test == Y_Book_Test)) * 100);



%% ================= Part 5: Top Predictors of Spam ====================
%  Since the model we are training is a linear SVM, we can inspect the
%  weights learned by the model to understand better how it is determining
%  whether an email is spam or not. The following code finds the words with
%  the highest weights in the classifier. Informally, the classifier
%  'thinks' that these words are the most likely indicators of spam.
%

% Sort the weights and obtin the vocabulary list
[weight, idx] = sort(Best_model.w, 'descend');


fprintf('\nTop predictors of a book of J.R. Rowling: \n');
for i = 1:15
    fprintf(' %-15s (%f) \n', wordList{idx(i)}, weight(i));
end

[weight, idx] = sort(Best_model.w, 'ascend');

fprintf('\nTop predictors of a book of HarryPotter: \n');
for i = 1:15
    fprintf(' %-15s (%f) \n', wordList{idx(i)}, weight(i));
end

fprintf('\n\n');




%% =================== Part 6: Save the best model =====================

save Best_model.mat Best_model
