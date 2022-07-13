clear
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%准备工作%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
article=fopen('English_article.txt','r');
line=[];%文章的每一行
article_line=[];%把文章放到一行
number_of_letter=zeros(1,27);%数组的第一位到第27位分别对应26个英文字母和‘ ’
probability_of_letter=zeros(1,27);%数组的第一位到第27位分别对应26个英文字母和‘ ’的概率

while ~feof(article)%把文章放到一行
    line=fgetl(article);
    article_line=[article_line,line];
end
fprintf('文章为：')
disp(article_line)
if mod(length(article_line),2)~=0
    article_line=strcat(article_line,'a');
end
for k=1:length(article_line)%将所有标点换成空格
    if (article_line(k)<97||article_line(k)>122)&&(article_line(k)~=32)
        article_line(k)=' ';
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%求每个字母的数量与概率%%%%%%%%%%%%%%%%%%%%%%%%%%
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
sum_of_number_of_letter=sum(number_of_letter);%字母与空格的总量
for k=1:length(number_of_letter)
    probability_of_letter(k)=number_of_letter(k)/sum_of_number_of_letter;
end
letter=['a','b','c','d','e','f','g','h','i','j','k','l','n','m','o','p','q','r','s','t','u','v','w','x','y','z',' '];
effective_probability_of_letter=[];%有效的概率
effective_letter=[];%有效的字母
w=1;
for k=1:length(probability_of_letter)
    if probability_of_letter(k)~=0
        effective_probability_of_letter=[effective_probability_of_letter probability_of_letter(k)];
        effective_letter(w)=letter(k);
        w=w+1;
    end
end
effective_letter=char(effective_letter);
%%%%%%%%%%%%%%%%%%%%%%%%%%求每个字母组合的数量与概率%%%%%%%%%%%%%%%%%%%%%%%%
double_number_of_letter=zeros(27);%双字母数量矩阵1-26对应a-z，27位空格
for k=(1:2:length(article_line))
    for o=[97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,32]%第一个字母
        for t=[97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,32]%第二个字母
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
sum_of_double_number_of_letter=sum(sum(double_number_of_letter));%字母组合数量的总量
double_probability_of_letter=zeros(27);%双字母概率矩阵1-26对应a-z，27位空格

for k1=1:27
    for k2=1:27
        double_probability_of_letter(k1,k2)=double_number_of_letter(k1,k2)/sum_of_double_number_of_letter;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%求各自的熵%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
fprintf('文章出现字母和空格的一阶熵为%f\n',H1);
fprintf('文章出现字母和空格的组合熵为%f\n',H2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%构建霍夫曼树%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p=effective_probability_of_letter;
[~,n]=size(p);%得到编码个数
HT=zeros(2*n-1,4);%构造霍夫曼树

for i=1:n
    HT(i,1)=p(i);
end
HT;%第一列为个数的权重值 1~4列分别为  权重  父节点  左支  右支
HT0=HT;

%构建霍夫曼树
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%霍夫曼编码%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

fprintf('各分布概率的霍夫曼编码为:\n');
for i=1:n
    fprintf( '%s的概率为：%f-----编码为:' ,effective_letter(i),HT(i,1));
    disp(num2str(a{i}));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%计算平均码长%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
l=[];
L_1=0;
for i=1:n
    l(i)=length(a{i});
    L_1=l(i)*HT(i,1)+L_1;
end
fprintf('平均码长为:%f \n',L_1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%计算编码效率%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
coding_efficiency=H1/L_1;
fprintf('编码效率为:%f \n',coding_efficiency);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%编码%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
code=[];
for k=1:length(article_line)
    for i=1:length(effective_probability_of_letter)
        if article_line(k)==effective_letter(i)
            code=[code a{i}];
        end
    end
end
fprintf('文章编码为：');
disp(num2str(code))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%解码%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
decoding_result=[];
t=code;%存储二进制报文
[~,v]=size(t);%得到二进制报文的长度
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
fprintf('译码结果为：');
disp(decoding_result)


