# Filename: 3D-rigid-registration.r
# Date: 2019-08-29
# Author: Christopher Carignan
# Email: c.carignan@phonetik.uni-muenchen.de
# Institution: Institute of Phonetics and Speech Processing (IPS), Ludwig-Maximilians-Universität München, Munich, Germany

# Description:
#   Performs rigid body registration of points in a three-dimensional Cartesian coordinate system. 
#   Useful for head-correction of data derived from electromagnetic articulometry and 3D tracking systems for speech.
#   NB: currently, the function can only be used with THREE reference sensors, which produces a square matrix (3 sensors x 3 dimensions)
#     The math is much simpler for square matrices and it hurts my tiny brain to try to figure out rectangular ones...

# Input arguments:
#   data.raw: two-dimensional array of data
#   ref.obs: the number of the row/observation/sample in data.raw to use as a reference for registration
#   x: a 3-element vector of column indices for the x-dimension values of the reference points (e.g., head sensors).
#     Can be either a numeric vector with explicit column numbers or a character vector with explicit column names.
#   y: a 3-element vector of column indices for the y-dimension values of the reference points (e.g., head sensors).
#     Can be either a numeric vector with explicit column numbers or a character vector with explicit column names.
#   z: a 3-element vector of column indices for the z-dimension values of the reference points (e.g., head sensors).
#     Can be either a numeric vector with explicit column numbers or a character vector with explicit column names.
#   xx: an N-element vector of column indices for the x-dimension values of the points to be rotated.
#     Can be either a numeric vector with explicit column numbers or a character vector with explicit column names.
#   yy: an N-element vector of column indices for the y-dimension values of the points to be rotated.
#     Can be either a numeric vector with explicit column numbers or a character vector with explicit column names.
#   zz: an N-element vector of column indices for the z-dimension values of the points to be rotated.
#     Can be either a numeric vector with explicit column numbers or a character vector with explicit column names.

#   NB: the vectors (x,y,z) and (xx,yy,zz) must constitute element-wise matching triplets, 
#     i.e., element-wise corresponding values must be for the same point/sensor,
#     e.g., x[1], y[1], and x[1] must be x,y,z values for the same point, same for xx[64], yy[64], zz[64], etc.


# Main function
head_correction <- function (data.raw=data, ref.obs=1, 
                             x=x, y=y, z=z, 
                             xx=xx, yy=yy, zz=zz) {
  
  # get the sample/observation data to be used as the reference for registration
  ref.mat <- matrix(
    c(as.numeric(data.raw[ref.obs, x]), 
      as.numeric(data.raw[ref.obs, y]), 
      as.numeric(data.raw[ref.obs, z])),
    ncol=3)
  
  # get the centroid of the reference data
  ref.cnt <- matrix(
    c(mean(as.numeric(ref.mat[,1])), 
      mean(as.numeric(ref.mat[,2])), 
      mean(as.numeric(ref.mat[,3]))),
    ncol=3)
  
  # apply rigid body registration to all samples in the data frame
  for (sample in 1:nrow(data.raw)){
    # get the sample data
    samp.mat <- matrix(
      c(as.numeric(data.raw[sample, x]), 
        as.numeric(data.raw[sample, y]), 
        as.numeric(data.raw[sample, z])),
      ncol=3)
    
    # get the centroid of the sample data
    samp.cnt <- matrix(
      c(mean(as.numeric(samp.mat[,1])), 
        mean(as.numeric(samp.mat[,2])), 
        mean(as.numeric(samp.mat[,3]))),
      ncol=3)
    
    # calculate the covariance matrix
    H <- t(sweep(samp.mat,2,samp.cnt,'-')) %*% sweep(ref.mat,2,ref.cnt,'-')
    
    # singular value decomposition (to find the optimal rotation)
    S <- svd(H)
    
    # find optimal rotation matrix
    R <- S$v %*% t(S$u)
    
    # special reflection case, i.e., if the SVD returns a "reflection" matrix
    if (det(R) < 0) {
      S$v[,3] <- S$v[,3] * -1 # reflect it back!
      R <- S$v %*% t(S$u)
    }
    
    # find optimal translation vector
    tr <- tcrossprod(-R,samp.cnt) + t(ref.cnt)
    
    # apply rigid tranformation to all user-specified data
    samp.mat <- matrix(
      c(as.numeric(data.raw[sample, xx]), 
        as.numeric(data.raw[sample, yy]), 
        as.numeric(data.raw[sample, zz])),
      ncol=3)
    rotated <- sweep(R %*% t(samp.mat), 1, tr, '+') # apply rotation matrix
    data.raw[sample, c(xx,yy,zz)] <- c(rotated[1,], rotated[2,], rotated[3,]) # replace data
  }
  return(data.raw)
}