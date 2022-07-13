clear
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%׼������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
article=fopen('English_article.txt','r');
line=[];%���µ�ÿһ��
article_line=[];%�����·ŵ�һ��
number_of_letter=zeros(1,27);%����ĵ�һλ����27λ�ֱ��Ӧ26��Ӣ����ĸ�͡� ��
probability_of_letter=zeros(1,27);%����ĵ�һλ����27λ�ֱ��Ӧ26��Ӣ����ĸ�͡� ���ĸ���

while ~feof(article)%�����·ŵ�һ��
    line=fgetl(article);
    article_line=[article_line,line];
end
fprintf('����Ϊ��')
disp(article_line)
if mod(length(article_line),2)~=0
    article_line=strcat(article_line,'a');
end
for k=1:length(article_line)%�����б�㻻�ɿո�
    if (article_line(k)<97||article_line(k)>122)&&(article_line(k)~=32)
        article_line(k)=' ';
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ÿ����ĸ�����������%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:length(article_line)
    for m=[97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,32]
        if article_line(k)==char(m)
            if m==32
                number_of_letter(27)=number_of_letter(27)+1;
            elseif m>=97
                number_of_letter(m-96)=number_of_letter(m-96)+1;
            end
        end
    end
end
sum_of_number_of_letter=sum(number_of_letter);%��ĸ��ո������
for k=1:length(number_of_letter)
    probability_of_letter(k)=number_of_letter(k)/sum_of_number_of_letter;
end
letter=['a','b','c','d','e','f','g','h','i','j','k','l','n','m','o','p','q','r','s','t','u','v','w','x','y','z',' '];
effective_probability_of_letter=[];%��Ч�ĸ���
effective_letter=[];%��Ч����ĸ
w=1;
for k=1:length(probability_of_letter)
    if probability_of_letter(k)~=0
        effective_probability_of_letter=[effective_probability_of_letter probability_of_letter(k)];
        effective_letter(w)=letter(k);
        w=w+1;
    end
end
effective_letter=char(effective_letter);
%%%%%%%%%%%%%%%%%%%%%%%%%%��ÿ����ĸ��ϵ����������%%%%%%%%%%%%%%%%%%%%%%%%
double_number_of_letter=zeros(27);%˫��ĸ��������1-26��Ӧa-z��27λ�ո�
for k=(1:2:length(article_line))
    for o=[97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,32]%��һ����ĸ
        for t=[97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,32]%�ڶ�����ĸ
            o1=char(o);
            t1=char(t);
            if (article_line(k)==o1)&(article_line(k+1)==t1)
                if o>=97&&t>=97
                    double_number_of_letter(o-96,t-96)=double_number_of_letter(o-96,t-96)+1;
                elseif o>=97&&t==32
                    double_number_of_letter(o-96,27)=double_number_of_letter(o-96,27)+1;
                elseif o==32&&t>=97
                    double_number_of_letter(27,t-96)=double_number_of_letter(27,t-96)+1;
                elseif o==32&&t==32
                    double_number_of_letter(27,27)=double_number_of_letter(27,27)+1;
                end
            end 
        end  
    end
end
sum_of_double_number_of_letter=sum(sum(double_number_of_letter));%��ĸ�������������
double_probability_of_letter=zeros(27);%˫��ĸ���ʾ���1-26��Ӧa-z��27λ�ո�

for k1=1:27
    for k2=1:27
        double_probability_of_letter(k1,k2)=double_number_of_letter(k1,k2)/sum_of_double_number_of_letter;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����Ե���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H1=0;
H2=0;
for k=1:length(probability_of_letter)
    if probability_of_letter(k)~=0
        H1=H1-probability_of_letter(k)*log2(probability_of_letter(k));
    end
end

for k=1:length(double_probability_of_letter)
    if double_probability_of_letter(k)~=0
        H2=H2-double_probability_of_letter(k)*log2(double_probability_of_letter(k));
    end
end
fprintf('���³�����ĸ�Ϳո��һ����Ϊ%f\n',H1);
fprintf('���³�����ĸ�Ϳո�������Ϊ%f\n',H2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p=effective_probability_of_letter;
[~,n]=size(p);%�õ��������
HT=zeros(2*n-1,4);%�����������

for i=1:n
    HT(i,1)=p(i);
end
HT;%��һ��Ϊ������Ȩ��ֵ 1~4�зֱ�Ϊ  Ȩ��  ���ڵ�  ��֧  ��֧
HT0=HT;

%������������
for i=1:n-1
         a=HT0(:,1);
         [b,l]=sort(a,'descend');
         s=b(n-i+1)+b(n-i);
         HT0(n+i,1)=s;
         HT0(l(n-i+1),1)=0;
         HT0(l(n-i),1)=0;
         HT0(l(n-i+1),2)=n+i; 
         HT0(l(n-i),2)=n+i;
         HT0(n+i,3)=l(n-i+1);
         HT0(n+i,4)=l(n-i);  
         
         HT(n+i,1)=s;
         HT(l(n-i+1),2)=n+i;
         HT(l(n-i),2)=n+i;
         HT(n+i,3)=l(n-i+1);
         HT(n+i,4)=l(n-i); 
end

a=cell(1,length(effective_probability_of_letter));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:n
    f=i;
    while(HT(f,2)~=0)
        q=HT(f,2);
        
        if HT(q,3)==f
            a{i}=[0 a{i}];
        else
            a{i}=[1 a{i}];
        end
        f=q;
    end   
end

fprintf('���ֲ����ʵĻ���������Ϊ:\n');
for i=1:n
    fprintf( '%s�ĸ���Ϊ��%f-----����Ϊ:' ,effective_letter(i),HT(i,1));
    disp(num2str(a{i}));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ƽ���볤%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
l=[];
L_1=0;
for i=1:n
    l(i)=length(a{i});
    L_1=l(i)*HT(i,1)+L_1;
end
fprintf('ƽ���볤Ϊ:%f \n',L_1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�������Ч��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
coding_efficiency=H1/L_1;
fprintf('����Ч��Ϊ:%f \n',coding_efficiency);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
code=[];
for k=1:length(article_line)
    for i=1:length(effective_probability_of_letter)
        if article_line(k)==effective_letter(i)
            code=[code a{i}];
        end
    end
end
fprintf('���±���Ϊ��');
disp(num2str(code))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
decoding_result=[];
t=code;%�洢�����Ʊ���
[~,v]=size(t);%�õ������Ʊ��ĵĳ���
f=2*n-1;
i=1;
while(i<=v)

    if(t(i)==0)
        q=HT(f,3);
        f=q;
    else
        q=HT(f,4);
        f=q;
    end
    i=i+1;
    if (HT(f,3)==0)&&(HT(f,4)==0)
        decoding_result=[decoding_result,effective_letter(f)];
        f=2*n-1;
    end
end
fprintf('������Ϊ��');
disp(decoding_result)


