clear all
close all
clc
%% Problem Preparation

%Create the graph
[ graph ] = createGraph();

%Draw the graph
figure
subplot(1, 3, 1)
drawGraph(graph);
%% ACO Algorithm

%% Initial Parameters
maxIter = 10;
antNo = 10;
droneNo = 5;
tau0 = zeros(0, droneNo);
tau = zeros(0, droneNo);
eta = zeros(0, droneNo);
for i = 1:1:droneNo
end
rho = 0.5; % Evaporation rate 
alpha = 1;  % Phromone exponential parameters 
beta = 1;  % Desirability exponetial paramter
%% Main Loop of ACO

