function output=Pv2Note(t,p);
%p is detecting pitch, t is time
n=size(t);
a=0;
b=0;
for i=1:n(1)
    if p(i)>0
        np=p(i-a:i)-median(p(i-a:i));
        npv=sum(abs(np));
        if npv<2.5
            a=a+1;
        else
            b=b+1;
            D(b,1)=t(i-a);
            D(b,2)=t(i-1);
            D(b,3)=round(median(p(i-a:i-1)));
            a=1;
        end
    elseif p(i)==0 & a>2
        b=b+1;
        D(b,1)=t(i-a);
        D(b,2)=t(i-1);
        D(b,3)=round(median(p(i-a:i-1)));
        a=0;
    else p(i)==0 & a<3
        a=0;
    end
end
output=D;
end

