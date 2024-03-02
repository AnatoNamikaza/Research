function [sFeat,Sf,Nf,curve]=jHLBDA(feat,label,opts)
if isfield(opts,'N'), N=opts.N; end
if isfield(opts,'T'), T=opts.T; end
if isfield(opts,'pg'), pg=opts.pg; end 
if isfield(opts,'pp'), pp=opts.pp; end 

fun=@jFitnessFunction; 
D=size(feat,2); 
X=jInitialPopulation(N,D); DX=zeros(N,D); fit=zeros(1,N);
curve=inf; fitF=inf; fitE=-inf; t=1; Xnew=zeros(N,D); Dmax=6;
fitPB=ones(1,N); Xpb=zeros(N,D); 
fitPW=zeros(1,N); Xpw=zeros(N,D);
%---// Iteration start
m = 0;
while t <= T
  for i=1:N
    fit(i)=fun(feat,label,X(i,:),opts); 
    if fit(i) < fitF
      fitF=fit(i); Xf=X(i,:);
    end
    if fit(i) > fitE
      fitE=fit(i); Xe=X(i,:);
    end
    if fit(i) > fitPW(i)
      fitPW(i)=fit(i); Xpw(i,:)=X(i,:); 
    end
    if fit(i) < fitPB(i)
      fitPB(i)=fit(i); Xpb(i,:)=X(i,:);
    end
  end
  w=0.9-t*((0.9-0.4)/T);
  rate=0.1-t*((0.1-0)/(T/2));
  if rate < 0, rate=0; end
  s=2*rand()*rate; a=2*rand()*rate; c=2*rand()*rate;    
  f=2*rand(); e=rate; 
  for i=1:N
    index=0; nNeighbor=0; Xn=zeros(1,D); DXn=zeros(1,D);
    for j=1:N
      if i~=j
        index=index+1; nNeighbor=nNeighbor+1;
        DXn(index,:)=DX(j,:); Xn(index,:)=X(j,:);
      end
    end
    S=repmat(X(i,:),nNeighbor,1)-Xn; S=-sum(S,1);
    A=sum(DXn,1)/nNeighbor;
    C=sum(Xn,1)/nNeighbor; C=C-X(i,:);
    F=((Xpb(i,:)-X(i,:))+(Xf-X(i,:)))/2;
    E=((Xpw(i,:)+X(i,:))+(Xe+X(i,:)))/2;  
    for d=1:D
      dX=(s*S(d)+a*A(d)+c*C(d)+f*F(d)+e*E(d))+w*DX(i,d);
      dX(dX > Dmax)=Dmax; dX(dX < -Dmax)=-Dmax; DX(i,d)=dX;
      TF=abs(DX(i,d)/sqrt(((DX(i,d)^2)+1))); 
      r1=rand();
      if r1 >= 0 && r1 < pp 
        if rand() < TF
          Xnew(i,d)=1-X(i,d);
        else
          Xnew(i,d)=X(i,d); 
        end
      elseif r1 >= pp && r1 < pg
        Xnew(i,d)=Xpb(i,d); 
      else
        Xnew(i,d)=Xf(d);
      end
    end
  end
  X=Xnew;
  curve(t)=fitF;
  m = curve(t);
  %fprintf('\nIteration %d Best (HLBDA)= %f',t,curve(t))
  t=t+1;
end
%fprintf('\n Best (HLBDA)= %f',m)
Pos=1:D; Sf=Pos(Xf==1); sFeat=feat(:,Sf); Nf=length(Sf); 
end


