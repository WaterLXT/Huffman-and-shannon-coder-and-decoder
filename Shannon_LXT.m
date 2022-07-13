clear
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%׼������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
article=fopen('aaa.txt','r');
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
        effective_probability_of_letter=[effective_probability_of_letter,probability_of_letter(k)];
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
for k=1:length(effective_probability_of_letter)
    H1=H1-effective_probability_of_letter(k)*log2(effective_probability_of_letter(k));
end

for k=1:length(double_probability_of_letter)
    if double_probability_of_letter(k)~=0
        H2=H2-double_probability_of_letter(k)*log2(double_probability_of_letter(k));
    end
end
fprintf('���³�����ĸ�Ϳո��һ����Ϊ%f\n',H1);
fprintf('���³�����ĸ�Ϳո�������Ϊ%f\n',H2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ũ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
encoding_length=zeros(1,length(effective_probability_of_letter));%�������ʶ�Ӧ���볤
self_information_quantity=zeros(1,length(effective_probability_of_letter));%�������ʵ�����Ϣ��
sorted_effective_letter=[];
[sorted_effective_probability_of_letter,s]=sort(effective_probability_of_letter,'descend');%�����ĸ��ʷֲ�
for k=1:length(s)
    sorted_effective_letter(k)=effective_letter(s(k));
end
sorted_effective_letter=char(sorted_effective_letter);%�������ĸ��˳��
for k=1:length(sorted_effective_probability_of_letter)
    self_information_quantity(k)=-log2(sorted_effective_probability_of_letter(k));
    encoding_length(k)=ceil(self_information_quantity(k));%����ȡ��
end


Cumulative_probability=[];%�ۼӸ���
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
    fprintf('%s�ĸ���Ϊ%f���ۼӸ���Ϊ%f������Ϊ��',sorted_effective_letter(k),sorted_effective_probability_of_letter(k),Cumulative_probability(k));
    disp(num2str(code0{k}));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����Ч��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sum_encoding_length=0;%ƽ���볤
for k=1:length(encoding_length)
    sum_encoding_length=sum_encoding_length+encoding_length(k);
end
ave_encoding_length=sum_encoding_length/length(encoding_length);
coding_efficiency=H1/ave_encoding_length;
fprintf('ƽ���볤Ϊ��%f\n',ave_encoding_length);
fprintf('����Ч��Ϊ��%f\n',coding_efficiency);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
code=[];
for k=1:length(article_line)
    for i=1:length(sorted_effective_letter)
        if article_line(k)==sorted_effective_letter(i)
            code=[code code0{i}];
        end
    end
end
fprintf('���±���Ϊ��');
disp(num2str(code))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=1;
decoding_result=[];
a=encoding_length(1);
b=encoding_length(end);
x=[];%�ݴ����

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

fprintf('����Ϊ��')
disp(decoding_result);