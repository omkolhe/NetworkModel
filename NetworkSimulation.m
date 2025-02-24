%% Network Paramters 
%Number of neurons in one dimension 
grid_size = 50;
excitatory_ratio = 0.8;
% Size of the patch of cortex to simulate 
grid_length = 1e-3; % in m


% Decay constant for connectivity 
sigma = 0.4e-3; %% in m 
% Speed of AP 
vAP = 0.2; % in m/s
% Synaptic delay 
tau_syn = 300e-6; % in seconds

%% Simulation Parameters
% time step of simulation in s
time_step = 0.1e-3;
% Total time of simulation in s 
total_time = 2;

%% Create spiling neural network SNN 
SNN = Network(grid_size,grid_length,excitatory_ratio, sigma,vAP,tau_syn,time_step,total_time);
% Checking structure 
% SNN.plot_network();
% SNN.plot_neuron_connection(45);

%% Saving session
savepath = uigetdir(path);
sessionName = [savepath,'/','SNNStimulation50x50PoissonInput.mat'];

%% Simulating network
h = waitbar(0, 'Initializing...'); % Initialize waitbar
total_iterations = total_time / time_step;
start_time = tic; % Start timer
save_interval = total_iterations/10;

N = grid_size*grid_size;         % Number of neurons
rate = 20;                       % Firing rate in Hz
duration = 1;    
dt = time_step; 
spike_train_ext = generate_poisson_spikes_N(N, rate, duration, dt);

for i = 1:total_iterations
    % % Apply external current condition
    % if i * time_step > 0.001 && i * time_step < 1
    %     I_ext = 0.5e-9 * ones(SNN.num_neurons, 1);
    % else
    I_ext = zeros(SNN.num_neurons, 1);
    % end
   
    if i <= size(spike_train_ext,2)
        spike_ext = squeeze(spike_train_ext(:,i));
    else
        spike_ext = false(N,1);
    end
    % Update network
    SNN = SNN.update_par(i, i * time_step, I_ext,spike_ext);
    
    % Calculate elapsed time and estimate time remaining
    elapsed_time = toc(start_time);
    avg_time_per_iter = elapsed_time / i;
    estimated_time_left = avg_time_per_iter * (total_iterations - i);
    
    % Update waitbar with progress and estimated time left
    waitbar(i / total_iterations, h, ...
        sprintf('SNN Simulation Progress: %.2f%% | Time left: %.2f sec', ...
        (i / total_iterations) * 100, estimated_time_left));
    if mod(i, save_interval) == 0 || i == total_iterations
        save(sessionName,"-v7.3");
        fprintf('Workspace saved at %d%% completion.\n', round((i / total_iterations) * 100));
    end
end

close(h); % Close waitbar when done

%% Plotting

figure;
plot(SNN.v_neurons(342,:));

%% 
figure();
imagesc(SNN.spikes);
colormap(flipud(gray))