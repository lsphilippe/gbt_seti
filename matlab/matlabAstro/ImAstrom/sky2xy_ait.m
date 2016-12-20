function [X,Y]=sky2xy_ait(FileName,Long,Lat,HDUnum)
%--------------------------------------------------------------------------
% sky2xy_ait function                                             ImAstrom
% Description: Given a FITS image, SIM or a structure containing the FITS
%              WCS keyword (returned by fits_get_wcs.m), where the
%              WCS is represented using the Hammer-Aitoff
%              projection, convert longitude and latitude to X and
%              Y position.
% Input  : - A string containing a FITS image name, SIM, or a structure
%            containing the FITS WCS keyword, returned by fits_get_wcs.m,
%            or a SIM structure or class.
%          - Longitude [radians].
%          - Latitude [radians].
%          - HDU number in FITS image from which to read the header.
%            Default is 1.
% Output : - X position [pixels].
%          - Y position [pixels].
% Tested : Matlab 7.13
%     By : Eran O. Ofek             Sep 2012
%    URL : http://weizmann.ac.il/home/eofek/
% Example: [X,Y]=sky2xy_ait('File.fits',1,1);
%          % or:
%          WCS = fits_get_wcs('File.fits');
%          [X,Y]=sky2xy_ait(WCS,1,1);
%          % or:
%          Sim = images2sim('File.fits');
%          [X,Y]=sky2xy_ait(Sim,1,1);
% Reliable: 2
%--------------------------------------------------------------------------

RAD = 180./pi;

if (nargin==3),
    HDUnum = 1;
end

Long = convertdms(Long,'gH','r');
Lat  = convertdms(Lat,'gD','r');

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


% transformation
if (~strcmp(WCS.CUNIT1,WCS.CUNIT2)),
    error('CUNIT1 must be identical to CUNIT2');
end

switch lower(WCS.CUNIT1)
    case {'deg','degree'}
        Factor = RAD;
    case 'rad'
        Factor = 1;
    otherwise
        error('Unknown CUNIT option');
end

if (WCS.CRVAL1~=0 || WCS.CRVAL2~=0),
    error('This version does not support CRVAL ne 1');
end

[X,Y] = pr_hammer_aitoff(Long,Lat,Factor);

%Vec = WCS.CD*[X - WCS.CRPIX1;Y - WCS.CRPIX2]; 
X     = WCS.CRPIX1 + X./WCS.CDELT1;
Y     = WCS.CRPIX2 + Y./WCS.CDELT2;


