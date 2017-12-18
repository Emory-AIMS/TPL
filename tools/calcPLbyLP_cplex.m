% can be also used for calculate FPL
% some precision problem could happen when a is large (e.g. a>30)
% calcBPLbyPreComp.m and calcBPLbyFunc.m have no precision problem
function [bpl,x]=calcPLbyLP_cplex(Q,D, a)

n=size(Q,2); % size of variables yi
m=n*(n-1)/2; % size of contraints  exp(-a)<=yi  OR   yj<=exp(a);

% constraints  exp(-a)<=yi/yj<=exp(a);
% i.e.:  exp(-a)*yj -yi<=0    yi-exp(a)*yj<=0
row=repmat(1:2*m,2,1);
row=[row(:)];
col=nchoosek(1:n,2)';
col=[col(:); col(:)];
val=[repmat([-exp(a); 1],m,1) ; repmat([1; -exp(a)],m,1)];

% % constraints -y_i<0; y_i<1
% row=[row; 2*m+1+(1:2*n)'];
% col=[col; (1:n)'; (1:n)'];
% val=[val;-1*ones(n,1); ones(n,1)];

Aineq=sparse(row,col,val);

bineq=zeros(2*m,1 ); %NOTE: CLOUMN vec for cplexlp  (diff from linprog)

% constraints D'*yi=1
Aeq= D;
beq=1;

%min f
f=-1*Q'; %NOTE: CLOUMN vec for cplexlp  (diff from linprog)

[x, fval, exitflag, output]=cplexlp(f,Aineq,bineq,Aeq,beq);


bpl=log(-1*fval); % linprog find min, we multiply -1* f

end