function [X,Y]=sky2xy(FileName,Long,Lat,HDUnum)
%--------------------------------------------------------------------------
% sky2xy function                                                 ImAstrom
% Description: Given a FITS image, SIM or a structure containing the FITS
%              WCS keyword (returned by fits_get_wcs.m), convert longitude
%              and latitude to X and Y position in the image.
% Input  : - A string containing a FITS image name, SIM, or a structure
%            containing the FITS WCS keyword, returned by fits_get_wcs.m,
%            or a SIM structure or class.
%          - Vector of Longitudes (e.g., RA)
%            [radian, sexagesimal string or vector] see convertdms.m
%          - Vector of Latitudes (e.g., Dec)
%            [radian, sexagesimal string or vector] see convertdms.m
%          - HDU number in FITS image from which to read the header.
%            Default is 1.
% Output : - Column vector of X [pixel].
%          - Column vector of Y [pixel].
% Tested : Matlab R2014a
%     By : Eran O. Ofek                    Dec 2014
%    URL : http://weizmann.ac.il/home/eofek/matlab/
% Example:  [X,Y]=sky2xy_tan('File.fits',1,1);
%          % or:
%          WCS = fits_get_wcs('File.fits');
%          [X,Y]=sky2xy_tan(WCS,1,1);
%          % or:
%          Sim = images2sim('File.fits');
%          [X,Y]=sky2xy_tan(Sim,1,1);
% Reliable: 2
%--------------------------------------------------------------------------


if (nargin==3),
    HDUnum = 1;
end

% deal with types of input
if (isstruct(FileName)),
    if (isfield(FileName,'CTYPE1')),
        % assume input is a WCS structure (generated by fits_get_wcs.m)
        WCS = FileName;
        CallGetWCS = false;
    else
        CallGetWCS = true;
    end
else
    CallGetWCS = true;
end

if (CallGetWCS),
    WCS = fits_get_wcs(FileName,'HDUnum',HDUnum);
end

ProjType1 = WCS.CTYPE1(6:8);   % see also read_ctype.m
ProjType2 = WCS.CTYPE2(6:8);
if (~strcmp(ProjType1,ProjType2)),
    error('Axes have different orojection types');
end

switch lower(ProjType1)
    case 'tan'
        [X,Y] = sky2xy_tan(WCS,Long,Lat,HDUnum);
    case 'ait'
        [X,Y] = sky2xy_ait(WCS,Long,Lat,HDUnum);
    otherwise
        error('Unsupported projection type: %s',ProjType1);
end

        
        
        