function I = read_nii(input)
%READ_NII Return the image matrix for given nii file.
%   
%   TODO gzip for Windows.
%
%   Author: Osman Baskaya <osman.baskaya@computer.org>
%   Date: 31/07/2012

try
    s = load_nii(input);
catch err
    if isempty(err.identifier)
        fprintf('Not a NII file: %s. Trying to extract it.\n', input);
    else
        error(err.message)
    end
    
    inputs = gunzip(input);
    s = load_nii(inputs{1});
    
%     There is already built-in gunzip function... The following code is
%     not necessary anymore.
%
%     if isunix
%         if strcmpi('gz', input(end-1:end))
%             input = input(1:end-3); % removing ".gz" part.
%         else
%             fprintf('Input should be either gz file or nii file.\n');
%             fprintf('Program should be stopped.\n');
%             return; % for exit.
%         end
%         command = sprintf('gzip -d %s', input);
%         e = unix(command);
%         if e ~= 0
%             fprintf('Program should be stopped.\n');
%             return; % for exit.
%         end
%         s = load_nii(input);
%         disp('Successfully extracted.');
%     else %TODO gzip for Windows.
%         problem = 'UNIX not found. You should think twice when it comes to choosing OS\n';
%         fprintf(problem);
%     end
end

I = s.img;

end