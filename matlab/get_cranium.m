function outskull = get_cranium (skull)
% GET_CRANIUM Create outskull (inner tabula) of given skull image.
%
%   Bayındır Hastanesi ile yapılan toplantılardan sonra bu asama icin
%   kullanacağımız görüntü BETSURF'ün bize sağlandığı brain_outskull_mask
%   uzantılı dosya olmuştur. Bu yüzden bu fonksiyona yukarıdaki sözü geçen
%   dosya açılıp (read_mri fonksiyonu kullanılabilir) input olarak
%   verilmelidir.
%   
%   Proper input is brain_outskull_mask for this process. This output is
%   one of the output of BETSURF. This file is choosen by the
%   consensus of neurologists and radiologist from Bayindir Hospital.
%   
%   TODO:
%       The result of this function can be written as a file. After that
%       load_cranium function load that image.
%
% SYNOPSIS :
%   get_cranium(suffix, slice_num, path)
% 
% DESCRIPTION :
%
%
% CALL EXAMPLES :
%
%
% Author(s) : Osman Başkaya <osman.baskaya@computer.org>
% Date: 2010/03/20

    
[w, h] = size(skull);
skull = bwfill(skull, w/2, h/2); % central point.
outskull = bwperim(skull, 4);

% TODO WRITING
% Writing and demonstration... PNG
%figure, imshow(mat2gray(outSkull));
%cd('/home/tyr/Programs/matlab12a/Data/skulls'); % the place in which data should be written.
%imwrite(outSkull, dataName, 'png');
%cd(path)
%close all
end


