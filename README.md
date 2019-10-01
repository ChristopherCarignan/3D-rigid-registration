# 3D-rigid-registration
Performs rigid body registration of points in a three-dimensional Cartesian coordinate system. Useful for head-correction of data derived from electromagnetic articulometry and 3D tracking systems for speech.

Date: 2019-08-29

Author: Christopher Carignan

Email: c.carignan@phonetik.uni-muenchen.de

Institution: Institute of Phonetics and Speech Processing (IPS), Ludwig-Maximilians-Universität München, Munich, Germany


Description:
Performs rigid body registration of points in a three-dimensional Cartesian coordinate system. Useful for head-correction of data derived from electromagnetic articulometry and 3D tracking systems for speech.

NB: currently, the function can only be used with THREE reference sensors, which produces a square matrix (3 sensors x 3 dimensions). The math is much simpler for square matrices and it hurts my tiny brain to try to figure out rectangular ones...



Examples are shown below for head-corrected Optotrak data of one speaker (head reference sensors shown in red):

![x-y_correction](https://github.com/ChristopherCarignan/3D-rigid-registration/blob/master/x-y_correction.png)

![x-z_correction](https://github.com/ChristopherCarignan/3D-rigid-registration/blob/master/x-z_correction.png)



Input arguments:

data.raw: two-dimensional array of data

ref.obs: the number of the row/observation/sample in data.raw to use as a reference for registration

x: a 3-element vector of column indices for the x-dimension values of the reference points (e.g., head sensors). Can be either a numeric vector with explicit column numbers or a character vector with explicit column names.

y: a 3-element vector of column indices for the y-dimension values of the reference points (e.g., head sensors). Can be either a numeric vector with explicit column numbers or a character vector with explicit column names.

z: a 3-element vector of column indices for the z-dimension values of the reference points (e.g., head sensors). Can be either a numeric vector with explicit column numbers or a character vector with explicit column names.

xx: an N-element vector of column indices for the x-dimension values of the points to be rotated. Can be either a numeric vector with explicit column numbers or a character vector with explicit column names.

yy: an N-element vector of column indices for the y-dimension values of the points to be rotated. Can be either a numeric vector with explicit column numbers or a character vector with explicit column names.

zz: an N-element vector of column indices for the z-dimension values of the points to be rotated. Can be either a numeric vector with explicit column numbers or a character vector with explicit column names.

NB: the vectors (x,y,z) and (xx,yy,zz) must constitute element-wise matching triplets, i.e., element-wise corresponding values must be for the same point/sensor, e.g., x[1], y[1], and x[1] must be x,y,z values for the same point, same for xx[64], yy[64], zz[64], etc.

Function example:
rot.dat <- head_correction(data.raw=test.dat, ref.obs=50, x=c('x_1','x_2','x_3'), y=c('y_1','y_2','y_3'), z=c('z_1','z_2','z_3'), xx=c(11:20), yy=c(21:30), zz=c(31:40))
