function LEAF_FEAT_VALS=LEAF_PP_FEAT_EXTRACT(LEAF_IN_IMG)  

global LEAF_FEAT_VALS;

load LEAF_SEL;

predata=zeros(1,12);
data=zeros(1,12);

[y,x,z]=size(LEAF_IN_IMG);


leaf2=rgb2gray(LEAF_IN_IMG);

stru1=strel('disk',1);   
stru2=strel('disk',2);
stru3=strel('disk',3);
stru4=strel('disk',4);
back1=imopen(leaf2,stru1);
back2=imopen(leaf2,stru2);
back3=imopen(leaf2,stru3);
back4=imopen(leaf2,stru4);
leaf31=imsubtract(leaf2,back1);
leaf32=imsubtract(leaf2,back2);
leaf33=imsubtract(leaf2,back3);
leaf34=imsubtract(leaf2,back4);
ts1=graythresh(leaf31);
ts2=graythresh(leaf32);
ts3=graythresh(leaf33);
ts4=graythresh(leaf34);
leaf41=im2bw(leaf31,ts1);
leaf42=im2bw(leaf32,ts2);
leaf43=im2bw(leaf33,ts3);
leaf44=im2bw(leaf34,ts4);
[Connected1 n]=bwlabel(leaf41,8);
[Connected2 n]=bwlabel(leaf42,8);
[Connected3 n]=bwlabel(leaf43,8);
[Connected4 n]=bwlabel(leaf44,8);
data1=regionprops(Connected1,'basic');   
data2=regionprops(Connected2,'basic');
data3=regionprops(Connected3,'basic');
data4=regionprops(Connected4,'basic');
all1=[data1.Area];
Se1=sum(all1);
all2=[data2.Area];
Se2=sum(all2);
all3=[data3.Area];
Se3=sum(all3);
all4=[data4.Area];
Se4=sum(all4);
if(Se1 <=0 )
    Se1 = 1;
end
if(Se2 <=0 )
    Se2 = 1;
end
if(Se3 <=0 )
    Se3 = 1;
end
if(Se4 <=0 )
    Se4 = 1;
end
clear all1 all2 all3 all4 
clear back1 back2 back3 back4 
clear data1 data2 data3 data4 
clear labeled1 labeled2 labeled3 labeled4 
clear leaf31 leaf32 leaf33 leaf34 
clear leaf41 leaf42 leaf43 leaf44 
clear stru1 stru2 stru3 stru4 
%%%%%
%%%%%
g1=im2bw(LEAF_IN_IMG,0.95);      
 %threshold can be 0.95,0.92  
h=fspecial('average',3);   
g=round(filter2(h,g1));
c11=bwarea(~g);  
%opposite, calculate white area
%radius equals 2
h33=fspecial('average',2);
g33=round(filter2(h33,g1));
c33=bwarea(~g33);
%%%%%
%radius equals 5
h55=fspecial('average',5); 
g55=round(filter2(h55,g1));
c55=bwarea(~g55);

t=bwlabel(g);     
g2=bwmorph(g,'remove');c21=bwarea(g2);
c21=c21-2*(x+y);
%%%%%%%%%
%%%%%%%%%
g3=double(g2);
c22=round(c21);
a=1;h=zeros(c22*2,2);
x=x-3;y=y-3;       %maybe it is 4
for m=3:x
    for n=3:y
        if g3(n,m)==1 
           h(a,1)=m;h(a,2)=n;a=a+1;
         end
    end
end

clear g g1 g2 g3

l1=zeros(a^2,1);
b=1;
for r1=1:(a-1)
    for s1=r1:a
        if h(r1,1)==0 || h(s1,1)==0
           b=b;
        else 
           l1(b)=((h(r1,1)-h(s1,1))^2+(h(r1,2)-h(s1,2))^2)^(0.5);
           b=b+1; 
        end
    end
end
ll2=max(l1); 
if(ll2 <= 0)
    l1 = 1;
    ll2 = 1;
end
%%%%%ll2 --- longest diameter

pr1(1)=LEAF_SEL(1);pr1(2)=LEAF_SEL(2);
pr2(1)=LEAF_SEL(3);pr2(2)=LEAF_SEL(4);
ll1=((pr1(1)-pr2(1))^2+(pr1(2)-pr2(2))^2)^0.5;   
%%%%%ll1 --- physilogical diameter 

l2=zeros(a^2,1);
b=1;
c=1;ls=zeros(2*a,1);
if pr1(1)~=pr2(1) & pr1(2)~=pr2(2)
    tg1=(pr1(2)-pr2(2))/(pr1(1)-pr2(1));     
    tg=(-1)/tg1;
elseif pr1(1)==pr2(1)
    tg=0;
elseif pr1(2)==pr2(2)
    tg1=0;
end
if exist('tg')==1 
  for m=1:(a-1)
    for n=(m+1):a           
        if h(m,1)==0
           break;
        end
        if h(m,1)==h(n,1) 
           if tg1<0.0314 & tg1>-0.0314      % +-1%
              if h(n,1)==0
              ls(c)=0;
              else
              ls(c)=((h(m,1)-h(n,1))^2+(h(m,2)-h(n,2))^2);
              end
              c=c+1;
           end                     
        else                          
            l2(b)=(h(m,2)-h(n,2))/(h(m,1)-h(n,1)); 
            if l2(b)<(tg+abs(0.01*tg))& l2(b)>(tg-abs(0.01*tg))
%%%%%%%%%%can not make sure the absolutely upright 
                 if h(n,1)==0
                    ls(c)=0;
                 else  
                    ls(c)=((h(m,1)-h(n,1))^2+(h(m,2)-h(n,2))^2);
                 end
                 c=c+1;                    
              end 
           b=b+1; 
        end               
    end 
 end
else 
for m=1:(a-1)
    for n=(m+1):a           
        if h(m,1)==0
           break;
        end
        if h(m,1)==h(n,1)      
              ls(c)=((h(m,1)-h(n,1))^2+(h(m,2)-h(n,2))^2);
              c=c+1;                    
        else                          
            l2(b)=(h(m,2)-h(n,2))/(h(m,1)-h(n,1));    
            if l2(b)>=57.29 | l2(b)<=-57.29
                 ls(c)=((h(m,1)-h(n,1))^2+(h(m,2)-h(n,2))^2);
            end  
            c=c+1;
        end
    end
end
end
ls1=(max(ls))^(0.5);
if(ls1<=0)
    ls1 = 1;
    ls = 1;
end
%%%%%ls1---short

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%c11--area;c33--fspecial(2);c55--fspecial(5);c21--perimeter;
%%%%%ll2--longest diameter;ll1--physilogical diameter;ls1--short;
%predata(1)=Se1;predata(2)=Se2;predata(3)=Se3;predata(4)=Se4;
%predata(5)=c11;predata(6)=c33;predata(7)=c55;predata(8)=c21
%predata(9)=ll2;predata(10)=ll1;predata(11)=ls1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
LEAF_FEAT_VALS(1)=c55/c33;
LEAF_FEAT_VALS(2)=4*pi*c11/(c21)^2;
LEAF_FEAT_VALS(3)=c11/(ls1*ll1);
LEAF_FEAT_VALS(4)=ll1/ls1;
LEAF_FEAT_VALS(5)=ll2/ls1;
LEAF_FEAT_VALS(6)=Se1/c11;
LEAF_FEAT_VALS(7)=Se2/c11;
LEAF_FEAT_VALS(8)=Se3/c11;
LEAF_FEAT_VALS(9)=Se4/c11;
LEAF_FEAT_VALS(10)=Se4/Se1;
LEAF_FEAT_VALS(11)=c21/ll2;
LEAF_FEAT_VALS(12)=c21/(ls1+ll1);



