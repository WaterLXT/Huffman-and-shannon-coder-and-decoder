clear
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%准备工作%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
article=fopen('aaa.txt','r');
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
        effective_probability_of_letter=[effective_probability_of_letter,probability_of_letter(k)];
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
            if (article_line(k)==o1)&&(article_line(k+1)==t1)
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
for k=1:length(effective_probability_of_letter)
    H1=H1-effective_probability_of_letter(k)*log2(effective_probability_of_letter(k));
end

for k=1:length(double_probability_of_letter)
    if double_probability_of_letter(k)~=0
        H2=H2-double_probability_of_letter(k)*log2(double_probability_of_letter(k));
    end
end
fprintf('文章出现字母和空格的一阶熵为%f\n',H1);
fprintf('文章出现字母和空格的组合熵为%f\n',H2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%香农编码%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
encoding_length=zeros(1,length(effective_probability_of_letter));%各个概率对应的码长
self_information_quantity=zeros(1,length(effective_probability_of_letter));%各个概率的自信息量
sorted_effective_letter=[];
[sorted_effective_probability_of_letter,s]=sort(effective_probability_of_letter,'descend');%排序后的概率分布
for k=1:length(s)
    sorted_effective_letter(k)=effective_letter(s(k));
end
sorted_effective_letter=char(sorted_effective_letter);%排序后字母的顺序
for k=1:length(sorted_effective_probability_of_letter)
    self_information_quantity(k)=-log2(sorted_effective_probability_of_letter(k));
    encoding_length(k)=ceil(self_information_quantity(k));%向上取整
end


Cumulative_probability=[];%累加概率
Cumulative_probability(1)=0;
for k=2:length(sorted_effective_probability_of_letter)
    Cumulative_probability(k)=Cumulative_probability(k-1)+sorted_effective_probability_of_letter(k-1);
end

code0=cell(1,length(sorted_effective_probability_of_letter));
used_Cumulative_probability=Cumulative_probability;
for k=1:length(encoding_length)
    for i=1:encoding_length(k)
        temp=2*used_Cumulative_probability(k);
        if temp<1
            code0{k}=[code0{k} 0];
            used_Cumulative_probability(k)=temp;
        else
            code0{k}=[code0{k} 1];
            used_Cumulative_probability(k)=temp-1;
        end
    end
end
for k=1:length(sorted_effective_letter)
    fprintf('%s的概率为%f，累加概率为%f，编码为：',sorted_effective_letter(k),sorted_effective_probability_of_letter(k),Cumulative_probability(k));
    disp(num2str(code0{k}));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%编码效率%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sum_encoding_length=0;%平均码长
for k=1:length(encoding_length)
    sum_encoding_length=sum_encoding_length+encoding_length(k);
end
ave_encoding_length=sum_encoding_length/length(encoding_length);
coding_efficiency=H1/ave_encoding_length;
fprintf('平均码长为：%f\n',ave_encoding_length);
fprintf('编码效率为：%f\n',coding_efficiency);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%编码%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
code=[];
for k=1:length(article_line)
    for i=1:length(sorted_effective_letter)
        if article_line(k)==sorted_effective_letter(i)
            code=[code code0{i}];
        end
    end
end
fprintf('文章编码为：');
disp(num2str(code))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%解码%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=1;
decoding_result=[];
a=encoding_length(1);
b=encoding_length(end);
x=[];%暂存矩阵

while k<length(code)
    for i=a:b
        for w=1:length(sorted_effective_letter)
             if k+i-1<=length(code)
                x=code(k:k+i-1);
                if length(x)==length(code0{w})
                    if x==code0{w}
                        decoding_result=[decoding_result sorted_effective_letter(w)];
                        k=k+i;
                    end
                end
             end
        end
    end
end

fprintf('解码为：')
disp(decoding_result);