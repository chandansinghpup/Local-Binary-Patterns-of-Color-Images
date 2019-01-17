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
function [h, nfeature]=LBPC(fxy, P, R)

[M,N,K]=size(fxy);
M1=M-1;  N1=N-1;  M12=2*M1+1;  N12=2*N1+1;  M22=2*M1;  N22=2*N1;  MN=M*N;
L=2^P;  Lm1=L-1;  Pm1=P-1;  n=ceil(2*R+1.);  nm1=n-1;  n2=floor(n/2);  nsqr=n*n;

sumRGB=zeros(3,1);  hplane=zeros(L,1);  h=zeros(L,1);
fvp=zeros(P,1);
for x=1:M
    for y=1:N
        for k=1:K
            sumRGB(k)=sumRGB(k)+fxy(x,y,k);
        end  % next k
    end  % next y
end  % next x

% 	Find the average color of R, G, and B components in nxn window to find
%   the reference color vector(normal to the local plane).
for x=0:M1
    xp1=x+1;  xmn2=x-n2;
    for y=0:N1
        yp1=y+1;  ymn2=y-n2;
        sumr=0;  sumg=0;  sumb=0;
        for s=0:nm1
            xs=xmn2+s; 
            if(xs<0) xs=abs(xs)-1;  elseif(xs>=M) xs=M12-xs;  end
            xsp1=xs+1;
            for t=0:nm1
                yt=ymn2+t;
                if(yt<0) yt=abs(yt)-1;  elseif(yt>=N) yt=N12-yt;  end
                ytp1=yt+1;
                sumr=sumr+fxy(xsp1,ytp1,1);  sumg=sumg+fxy(xsp1,ytp1,2);
                sumb=sumb+fxy(xsp1,ytp1,3);
            end  % next t
        end  % next s
        refR=sumr/double(nsqr);  refG=sumg/double(nsqr);
        refB=sumb/double(nsqr);
        r0=fxy(xp1,yp1,1);  g0=fxy(xp1,yp1,2);  b0=fxy(xp1,yp1,3);
        %dotP0=refR*r0+refG*g0+refB*b0;  % no circular shift of pixels
        dotP0=refR*g0+refG*b0+refB*r0;  %  circular shift of pixels
        sum=0;   place_value=1;
        for p=0:Pm1
            theta=2.0*pi*p/P;
            xd=x+R*cos(theta);  yd=y-R*sin(theta);
            if(xd<0) xd=abs(xd);  elseif(xd>M1) xd=M22-xd;  end
            if(yd<0) yd=abs(yd);  elseif(yd>N1) yd=N22-yd;  end
            x0=floor(xd);  y0=floor(yd);  x1=ceil(xd);  y1=ceil(yd);
            xp=xd-x0;  yp=yd-y0;  x0p1=x0+1;  y0p1=y0+1;  x1p1=x1+1;  y1p1=y1+1;
            for k=1:3
                f0=fxy(x0p1,y0p1,k);  f1=fxy(x1p1,y0p1,k);  
                f2=fxy(x1p1,y1p1,k);  f3=fxy(x0p1,y1p1,k);
                value=f0+(f1-f0)*xp+(f3-f0)*yp+((f0+f2)-(f1+f3))*xp*yp;
                if(k==1) rd=value;
                elseif(k==2) gd=value;
                elseif(k==3) bd=value;
                end
            end  % next k
            %dotP1=refR*rd+refG*gd+refB*bd;
            dotP1=refR*gd+refG*bd+refB*rd;
            if(dotP1>=dotP0) sum=sum+place_value;  end
            fvp(p+1)=dotP1;
            place_value=2*place_value;
        end  % next p
        if(sum<0 || sum>Lm1)
            error('myApp:argChk',['sum=%d either less than zero or greater than'...
                ' Lm1'], sum);
        end
        hplane(sum+1)=hplane(sum+1)+1;
    end  % next y
end  % next x
for i=1:L
    h(i)=hplane(i)/double(MN);
    fprintf(1, 'i=%d, hplane(i)=%d, h(i)=%f\n', i, h(i), hplane(i));
end  % next i
nfeature=L;
end
