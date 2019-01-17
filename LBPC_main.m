% /*************************************************************************
% *                                                                        *
% *  Local Binary Patterns of Color Images.                                *
% *                                                                        *
% *  References : C. Singh, E. Walia, K. Kaur, Color texture description   *
% *               with novel local binary patterns for effective image     *
% *               retrieval, Pattern Recognition 76(2018)50-68.            *
% * Authors : Dr. Chandan Singh, Professor, and Shahbaz Majid, Research    *
% *               Fellow                                                   *
% *               Department of Computer Science,                          *
% *               Punjabi University, Patiala, Punjab-147002,              *
% *               India.                                                   *
% *               Mobile : +919872043209,+918699650390.                    *                                                                       *
% **************************************************************************
% */

clear all;  clc; 

finput=imread('lenna.tif');
f=double(finput); 
[M, N, K]=size(f); 
fprintf(1, 'M=%d, N=%d, K=%d\n', M, N, K);
if(K ~=3)
    error('myApp:argChk','Image is not a color image as K=%d is not 3\n',K);
end
P=8;  R=2;
LBPC(f, P, R);

