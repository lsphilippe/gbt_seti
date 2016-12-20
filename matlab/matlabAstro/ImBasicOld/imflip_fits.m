function [OutImageFileCell,OutputMatrixCell]=imflip_fits(ImInput,ImOutput,Flip,varargin)
%-----------------------------------------------------------------------------
% imflip_fits function                                                ImBasic
% Description: Flip FITS images in x or y direction.
% Input  : - List of input images (see create_list.m for details).
%            Alternatively, this can be a cell array in which each cell
%            contains the image in a matrix form, or a matrix.
%            In this case ImPutput can not be an empty matrix.
%          - List of output images (see create_list.m for details).
%            If empty matrix, then set it to be equal to the Input list.
%            Default is empty matrix.
%          - flip direction:
%            'x'  - flip image in x-direction.
%            'y'  - flip image in y-direction.
%            'xy' - flip image in x-direction and than y-direction.
%            'yx' - flip image in y-direction and than x-direction.
%          * Arbitrary number of pairs of input parameters: keyword,value,...
%            Available keywords are:
%            'OutPrefix'- Add prefix before output image names,
%                         default is empty string (i.e., '').
%            'OutDir'   - Directory in which to write the output images,
%                         default is empty string (i.e., '').
%            'CopyHead' - Copy header from original image {'y' | 'n'}.
%                         Default is 'y'.
%            'AddHead'  - Cell array with 3 columns containing additional
%                         keywords to be add to the header.
%                         See cell_fitshead_addkey.m for header structure
%                         information. Default is empty matrix.
%            'DelDataSec'-Delete DATASEC keyword from image header {'y' | 'n'}.
%                         Default is 'y'.
%                         The reason for that the DATASEC keywords may
%                         caseuse problem in image display.
%            'DataType' - Output data type (see fitswrite.m for options), 
%                         default is float32.
%            'CCDSEC'   - Image sction for image to be rotated. If given
%                         then the image will be croped before rotation.
%                         This could be string containing image keyword 
%                         name (e.g., 'CCDSEC'), or a vector of 
%                         [Xmin, Xmax, Ymin, Ymax].
%            'Save'     - Save FITS image to disk {'y' | 'n'}.
%                         Default is 'y'.
% Output  : - Cell array containing output image names.
%           - Cell array of matrices or output images.
% Tested : Matlab 7.10
%     By : Eran O. Ofek                    Jun 2010
%    URL : http://weizmann.ac.il/home/eofek/matlab/
% Example: Out=imflip_fits('lred0015.fits','try.fits','xy');
% Reliable: 2
%-----------------------------------------------------------------------------

Def.Output   = [];
if (nargin==1),
   Output   = Def.Output;
else
   % do nothing
end


DefV.OutPrefix   = '';
DefV.OutDir      = '';
DefV.DelDataSec  = 'y';
DefV.CopyHead    = 'y';
DefV.AddHead     = [];
DefV.DataType    = 'float32';
DefV.CCDSEC      = [];
DefV.Save        = 'y';

InPar = set_varargin_keyval(DefV,'y','use',varargin{:});

IsNumeric = 0;
if (isnumeric(ImInput)),
   ImInput = {ImInput};
end

if (iscell(ImInput)),
   if (isnumeric(ImInput{1})),
      % input is given in a matrix form
      IsNumeric = 1;
      if (isempty(ImOutput)),
	 error('If ImInput is numeric then must specify ImOutput');
      end
   end
end

if (IsNumeric==0),
   [~,ImInputCell] = create_list(ImInput,NaN);
else
   ImInputCell = ImInput;
end
Nim = length(ImInputCell);


if (isempty(ImOutput)),
   ImOutput = ImInput;
end
[~,ImOutputCell] = create_list(ImOutput,NaN);


%--- Go over all images ---
for Iim=1:1:Nim,
   %--- read Image ImInput ---
   if (IsNumeric==1),
      InputImage = ImInput{Iim};
   else
      InputImage = fitsread(ImInputCell{Iim});
   end

   %--- CCDSEC ---
   if (isempty(InPar.CCDSEC)),
      % use entire image
      % do nothing
   elseif (ischar(InPar.CCDSEC)),
      [InPar.CCDSEC] = get_ccdsec_fits({ImInputCell{Iim}},InPar.CCDSEC);
      [InputImage]   = cut_image(InputImage,InPar.CCDSEC,'boundry');
   elseif (length(InPar.CCDSEC)==4),
      [InputImage]   = cut_image(InputImage,InPar.CCDSEC,'boundry');
   else
      error('Illegal CCDSEC input');
   end

   %--- flip image ---
   switch lower(Flip)
    case 'x'
       InputImage = fliplr(InputImage);
    case 'y'
       InputImage = flipud(InputImage);
    case 'xy'
       InputImage = fliplr(InputImage);
       InputImage = flipud(InputImage);
    case 'yx'
       InputImage = flipud(InputImage);
       InputImage = fliplr(InputImage);
    otherwise
       error('Unknown Flip option');
   end

   OutImageFileName = sprintf('%s%s%s',InPar.OutDir,InPar.OutPrefix,ImOutputCell{Iim});
   OutImageFileCell{Iim} = OutImageFileName;

   if (IsNumeric==0),
      switch lower(InPar.CopyHead)
       case 'y'
          Info = fitsinfo(ImInputCell{Iim});
          HeaderInfo = Info.PrimaryData.Keywords;
       otherwise
          HeaderInfo = [];
      end
   else
      HeaderInfo = [];
   end

   if (IsNumeric==1),
      InputName = 'matlab Matrix format';
   else
      InputName = ImInputCell{Iim};
   end

   %--- Add to header comments regarding file creation ---
   [HeaderInfo] = cell_fitshead_addkey(HeaderInfo,...
                                       Inf,'COMMENT','','Created by imflip_fits.m written by Eran Ofek',...
                                       Inf,'HISTORY','',sprintf('Flip direction: %s',Flip),...
                                       Inf,'HISTORY','',sprintf('Input image name: %s',InputName));

   if (~isempty(InPar.AddHead)),
      %--- Add additional header keywords ---
      HeaderInfo = [HeaderInfo; InPar.AddHead];
   end

   switch lower(InPar.DelDataSec)
    case 'n'
        % do nothing
    case 'y'
        % delete DATASEC keyword from header
        [HeaderInfo] = cell_fitshead_delkey(HeaderInfo,'DATASEC');
    otherwise
        error('Unknown DelDataSec option');
   end

   %--- Write fits file ---
   switch lower(InPar.Save)
    case 'y'
       fitswrite_my(InputImage,OutImageFileName,HeaderInfo,InPar.DataType);
    case 'n'
       % do not save FITS image
    otherwise
       error('Unknown Save option');
   end

   if (nargout>1),
     OutputMatrixCell{Iim} = InputImage;
   end


end


