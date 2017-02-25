%% Import gnu.mat and plot it line segment for line segment
delete(findall(0, 'type', 'line'))
gnu = load('gnu.mat', '-ASCII');

M{1} = gnu;
M{2} = flipud(gnu);
M{3} = fliplr(gnu)*.8;
M{4} = sort(gnu);

minmax = 10*[floor(0.1*min(min(M{1}))), ceil(.1*max(max(M{1})))];

f1 = figure(1); 
SUBS=220

for t=1:length(M)
    sh(t) = subplot(SUBS + t);
    set(sh(t),'XLimMode', 'manual','YLimMode', 'manual');
    set(sh(t), 'XLim', minmax, 'YLim', minmax);
end

if 1
for t=1:length(M)
    subplot(sh(t)); hold all;
    m = M{t};
    for k=1:length(m)
        if mod(k, 2)
            line([m(k,1) m(k,3)], [m(k,2) m(k,4)], 'color', 'yellow');
        else
            line([m(k,1) m(k,3)], [m(k,2) m(k,4)], 'color', 'red');
        end
        delayWait(.2); 
        drawnow; 
    end
end
end


%%

f2 = figure(2); 
clf
SUBS=210;
m = M{1};

clear sh

for t=1:1
    sh(t) = subplot(SUBS + t);
    set(sh(t),'XLimMode', 'manual','YLimMode', 'manual');
    set(sh(t), 'XLim', minmax, 'YLim', minmax);
end

dk = 5;
for k=1:dk:length(m)
    line([m(k:k+dk,1) m(k:k+dk,3)], [m(k:k+dk,2) m(k:k+dk,4)])
    delayWait(1);
    drawnow
end

