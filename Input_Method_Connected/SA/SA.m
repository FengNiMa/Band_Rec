%matlab ����ʵ�� ģ���˻��㷨���� ������ֵ�����ú��޸ģ���л ARMYLAU��

%ʹ��ģ���˻�����J����Сֵ
%�������⣬���������ȴ����ȱ�Ϊ��
%����ʼ�¶�Ϊ30
%˥������Ϊ0.95
%��ɷ�������Ϊ4
%Metropolis�Ĳ���Ϊ0.02
%��������Ϊ������һ�����Ž������µ�һ�����Ž��֮��С��ĳ���ݲ
%ʹ��METROPOLIS����׼�����ģ��, ��������

function [Res,BestX,BestY]=SA(x,Data,ii)
%% parameters
a0=max(x-25,1); % initial point
b0=min(x+25,length(Data)); % initial point
l_min=30; 
l_max=80; 
bias_max=50;
c1=10; % penalty parameter
c2=10; % penalty parameter
h=1; % numerically compute partial diff of judge(a,b)
yita=2; % learning rate
cvg_threshold=0.1; % judge whether converge
iter_threshold=100; % if not converge, break
L=length(Data);

%%
%Ҫ������ֵ��Ŀ�꺯��,�������������
XMAX= bias_max;
YMAX = bias_max;
%��ȴ�����
MarkovLength = 2; %// ��ɷ�������
DecayScale = 0.8; %// ˥������
StepFactor = 2; %// ��������
Temperature0=30;
Temperature=Temperature0; %// ��ʼ�¶�
Tolerance = 0.7; %// �ݲ�
AcceptPoints = 0.0; %// Metropolis�������ܽ��ܵ�
rnd =rand;

%% ���ѡ�� ��ֵ�趨
PreX = a0;
PreY = b0;
BestX = PreX;
BestY = PreY;
PreBestX  = PreX;
PreBestY = PreX;

%% ÿ����һ���˻�һ��(����), ֱ�������������Ϊֹ
iter=0;
mm=abs(J(BestX, BestY,x,l_min,l_max,bias_max, c1, c2,ii,Data)...
    -J(PreBestX, PreBestY,x,l_min,l_max,bias_max, c1, c2,ii,Data));
del=0;
while mm > Tolerance
    iter=iter+1
    BB(iter)=BestX;
    if iter>3
        if BB(iter)==BB(iter-1)
            del=del+1;
        else
            del=0;
        end
    end
    if del==10
        break;
    end
    BestX
    BestY
    
    Temperature=DecayScale*Temperature;
    %StepFactor=StepFactor.*Temperature./Temperature0;
    AcceptPoints = 0.0;
    % �ڵ�ǰ�¶�T�µ���loop(��MARKOV������)��
    for i=1:1:4
        % 1) �ڴ˵㸽�����ѡ��һ��
        p=0;
        while p==0
            if mod(i,4)==1
                NextX = PreX + StepFactor*XMAX*abs((rand-0.5));
                NextY = PreY + StepFactor*YMAX*abs((rand-0.5));
            elseif mod(i,4)==2
                NextX = PreX + StepFactor*XMAX*abs((rand-0.5));
                NextY = PreY - StepFactor*YMAX*abs((rand-0.5));
            elseif mod(i,4)==3
                NextX = PreX - StepFactor*XMAX*abs((rand-0.5));
                NextY = PreY + StepFactor*YMAX*abs((rand-0.5));
            else
                NextX = PreX - StepFactor*XMAX*abs((rand-0.5));
                NextY = PreY - StepFactor*YMAX*abs((rand-0.5));
            end
            if (NextX>=x-bias_max && NextX<=x && NextY>=x && NextY<=x+bias_max)
                p=1;
            end
        end
        % 2) �Ƿ�ȫ�����Ž�
        Nex=J(NextX,NextY,x,l_min,l_max,bias_max, c1, c2,ii,Data);
        if (J(BestX,BestY,x,l_min,l_max,bias_max, c1, c2,ii,Data) ...
                > Nex)
            % ������һ�����Ž�
            PreBestX =BestX;
            PreBestY = BestY;
            % ��Ϊ�µ����Ž�
            BestX=NextX;
            BestY=NextY;
        end
        % 3) Metropolis����
        if( J(PreX,PreY,x,l_min,l_max,bias_max, c1, c2,ii,Data)...
                - Nex > 0 )
            %// ����, �˴�lastPoint����һ�������ĵ����½��ܵĵ㿪ʼ
            PreX=NextX;
            PreY=NextY;
            AcceptPoints=AcceptPoints+1;
        else
            changer = -1 * ( Nex ...
                - J(PreX,PreY,x,l_min,l_max,bias_max, c1, c2,ii,Data) ) / Temperature ;
            rnd=rand;
            p1=exp(changer);
            double (p1);
            if p1 > rand             %// ������, ����ԭ��
                PreX=NextX;
                PreY=NextY;
                AcceptPoints=AcceptPoints+1;
            end
        end
    end
    mm=abs(J( BestX,BestY,x,l_min,l_max,bias_max, c1, c2,ii,Data)...
        -J(PreBestX, PreBestY,x,l_min,l_max,bias_max, c1, c2,ii,Data));
end
%%
disp('ideal a and b is')
disp([BestX, BestY])
disp('this J is')
disp(J(BestX, BestY,x,l_min,l_max,bias_max, c1, c2,ii,Data))
disp('the judge is')
disp(judge(BestX,BestY,ii,Data))
Res=judge(BestX,BestY,ii,Data);
disp('number of iterations')
disp(iter)
end