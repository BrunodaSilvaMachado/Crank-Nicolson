%=====================================================================
%
% 1D Heat Equation (Diffusion Equation)
% Euler Explicit Method
% Bruno Da Silva Machado
%
% UFF - Volta Redonda, RJ, Brazil
% Sep 30th, 2021
%=====================================================================
%
% function [] = euler_explicito(t,tit)
% filename = file name
% dt = time step array
% tit = graphic title 
% maxIters = number max of iteration
function [] = euler_explicito(filename,dt,tit,maxIters)
clc; close all;

Lx = 1.0; N = 100;
delx=Lx/(N-1); 
c = 1;
x = (0:delx:1)';
%dt = [0.000001, 0.00001, 0.000025, 0.00005, 0.000051,...
%    0.00006, 0.00007, 0.00008, 0.0001];
nt = maxIters; %input(' Number of time steps = ');
%--> Initial conditions
U_n_1 = zeros(1,N);
U_n = zeros(1,N);
%--> Boundary conditions
U_n(1) = 1; %Left side
U_n(N) = 1; %Right side
U_n_1(1) = 1; %Left side
U_n_1(N) = 1; %Right side

% ===> Frist method
len_dt = size(dt,2);
residualA = zeros(1,nt);
solution = zeros(len_dt,N);
ll = '';
% Iteration cycle
for t = 1:len_dt
    % -- Core algorithm
    lambda = (c * dt(t))/(delx*delx);
    for n = 1:nt
        U_n_1(2:N-1) = U_n(2:N-1) + lambda * (U_n(1:N-2) - 2*U_n(2:N-1) + U_n(3:N)); 
        residualA(n) = abs(norm(U_n) - norm(U_n_1)); %L2 norm
        %-- Update is done here
        U_n = U_n_1;
    end
    
    solution(t,:) = U_n;
    ll = char(ll,sprintf('%s = %.2f','{\lambda}', lambda));
    
    % Gráfico de estabilidade
    plot(log10(residualA),'LineWidth',2);grid on;
    %title ('Método de Euler (lambda <= 1/2)');
    title (tit);
    xlabel ('Numero de Iterações','fontsize',14);
    ylabel ('Residuo [log]','fontsize',14);
    hold on
end % end iteration cycle here
hold off
ll = ll(2:size(ll),:);
legend(ll,'Location','southeast');
saveas(gcf,sprintf('%s_01',filename),'png');

%Gráfico da soluçao (distribuição de temperatura)
figure(2)
plot (x, solution,'LineWidth',2);
title ('Distribuição de temperatura');
xlabel ('Comprimento da barra','fontsize',14);
ylabel ('Temperatura [°C]','fontsize',14);
saveas(gcf,sprintf('%s_02',filename),'png');
end
