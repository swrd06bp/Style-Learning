
function [Page_indices Chapter_indices Book_contents] = processBook(file_contents)
%PROCESSEMAIL preprocesses a the body of an email and
%returns a list of word_indices 
%   word_indices = PROCESSEMAIL(email_contents) preprocesses 
%   the body of an email and returns a list of indices of the 
%   words contained in the email. 
%

% ========================== Preprocess Book ===========================

% Find the Headers ( \n\n and remove )
% Uncomment the following lines if you are working with raw emails with the
% full headers

% hdrstart = strfind(email_contents, ([char(10) char(10)]));
% email_contents = email_contents(hdrstart(1):end);

% Lower case
file_contents = lower(file_contents);

% Strip all HTML
% Looks for any expression that starts with < and ends with > and replace
% and does not have any < or > in the tag it with a space
file_contents = regexprep(file_contents, '<[^<>]+>', ' ');


% Handle Numbers
% Look for one or more characters between 0-9
file_contents = regexprep(file_contents, '[0-9]+', 'number');

%Handle carriage return for next page
file_contents = regexprep(file_contents,'chapter number' ,'nextchapterbook');

%Handle carriage return for next page
file_contents = regexprep(file_contents,'number' ,'nextpagebook');

% Handle $ sign
file_contents = regexprep(file_contents, '[$]+', 'dollar');

%Get rid of the ponctuation
file_contents = regexprep(file_contents, '\W+', ' ');



% Remove any non alphanumeric characters



% ========================== Save email ===========================

% Output the book to screen as well


Page_indices = strfind(file_contents,'nextpagebook');

Chapter_indices = strfind(file_contents,'nextchapterbook');

Book_contents = strsplit(file_contents);


percent =0;
    for i=1:size(Book_contents,2)
        try Book_contents{i} = porterStemmer(strtrim(Book_contents{i})); 
            catch Book_contents{i} = ''; continue;
        end;

        % Skip the word if it is too short
        if length(Book_contents{i}) < 1
            continue;
        end
        
        %Monitor the progress of the algorithm
        if i*100/size(Book_contents,2) > percent
           percent = percent +1;
           fprintf('.');
           if percent==50
               fprintf('\n');
           end
        end
        
    end

end
