
function delay_spikes = circshiftSpikeDelay(spikes,delays)
% function to shift spike matrix by the delays to the neurons 
    
    [m,n] = size(spikes');
    b = rem(delays-1,m)+1;
    c = rem(bsxfun(@plus,m + 1 - b - m*(b == 0),(0:m-1)')-1,m)+1;
    delay_spikes = spikes(bsxfun(@plus,c,m*(0:n-1)));
    delay_spikes = delay_spikes';
end