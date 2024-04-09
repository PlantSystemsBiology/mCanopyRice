function [Transmittance, Reflectance] = LeafSPAD2TR (SPAD)
% predict leaf transmittance and reflectance from SPAD values. 

X = SPAD;

Ytr=0.0098*X.^2-1.1512*X+35.452;	% transmittance	Red	0.957	2-poly
Ytg=0.0037*X.^2-0.6464*X+28.607;	%	transmittance	Green	0.938	2-poly
Ytb=0.0013*X.^2-0.1758*X+5.8576;	%	transmittance	Blue	0.776	2-poly
Yrr=0.0035*X.^2 - 0.4928*X + 22.279;	%	reflectance	Red	0.893	2-poly
Yrg=-0.193*X+18.617;	%	reflectance	Green	0.847	linear
Yrb=-0.0276*X+6.3225;	%	reflectance	Blue	0.229	linear

% Blue : Green : Red = 533.8 : 694.0 : 755.0;
Yt = ( Ytr * 533.8 + Ytg * 694.0 + Ytb * 755.0 ) ./ (533.8 + 694.0 + 755.0);
Yr = ( Yrr * 533.8 + Yrg * 694.0 + Yrb * 755.0 ) ./ (533.8 + 694.0 + 755.0);
Transmittance = Yt;
Reflectance = Yr;

end