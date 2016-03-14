function vocabList = getCompleteVocabList()
%GETCOMPLETEVOCABLIST reads the vocabulary list in complete_vocab_list.txt 
%After applying a porter algorithm on it, it returns a cell array of the words
%   vocabList = GETCOMPLETEVOCABLIST() reads the fixed vocabulary list in vocab.txt 
%   and returns a cell array of the words in vocabList.


%---------------------------------------------------------
%Process the complete vocab list with the porter algorithm
vocablist_contents = readFile('complete_vocab_list.txt');

word_number=1;
Finish_percent = 0;
Finish_flag = 0;

vocabList = cell(0, 0);

while ~isempty(vocablist_contents)
    

    
    %Monitor the progression of the processing of the vocab list
    if Finish_flag <580
        Finish_flag=Finish_flag+1;
    else
        Finish_flag = 0;
        Finish_percent = Finish_percent + 1;
        fprintf('.');
        if Finish_percent == 50
            fprintf('\n');
        end
    end
    
    
    % Tokenize and also get rid of any punctuation
    [str, vocablist_contents] = ...
       strtok(vocablist_contents, ...
              [' @$/#.-:&*+=[]?!(){},''">_<;%' char(10) char(13)]);
   
    % Remove any non alphanumeric characters
    str = regexprep(str, '[^a-zA-Z0-9]', '');

    % Stem the word 
    % (the porterStemmer sometimes has issues, so we use a try catch block)
    try str = porterStemmer(strtrim(str)); 
        catch str = ''; continue;
    end;

    % Skip the word if it is too short
    if length(str) < 1
       continue;
    end
    
    i=word_number;
    same_word_flag=false;
    
    %check for identical words within the vocab list already processed
    while i>1 & same_word_flag==false 
       if strcmp(str,vocabList{i-1})==1
            same_word_flag=true;
       end
       
     %Put that condition in order to make the algorithm faster to process
     %The first two letters have to be identical  
     if strcmp(str(1),vocabList{i-1}(1))==1 & ...
                        strcmp(str(2),vocabList{i-1}(2))==1
            i = i-1;
        else
            i=0;
        end
    end

    
    if same_word_flag == false
        vocabList = [vocabList;str];
        
        %counting the words in the library
        word_number = word_number + 1;
    end
    


end

end
