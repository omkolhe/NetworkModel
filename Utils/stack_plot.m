function stack_plot(DeltaFoverF,space,scale,Fs)

if nargin<4,scale=1; end
if nargin<3,space=1; end
if nargin<4,Fs=1024; end

x = length(DeltaFoverF(1,:));
y = length(DeltaFoverF(:,1));
baseline = max(DeltaFoverF,[],'all');
time = (1:x)/Fs;
% [grad,~]=colorGradient([247 224 10]/255,[10 247 148]/255,y);
[grad,~]=colorGradient([7 49 97]/255,[110 192 235]/255,y);

for i = 1:y
    gradient = i/y;
    plot(time,scale*DeltaFoverF(i,:)+(space*baseline),'LineWidth',1,'Color',grad(i,:)); hold on;
    baseline = baseline + max(DeltaFoverF,[],'all');
end
axis tight,box off
% set(gca,'XTick',[])
set(gca,'YTick',[])
disp('Done!')
end
