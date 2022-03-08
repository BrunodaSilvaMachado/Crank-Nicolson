%=====================================================================
%
% 1D Heat Equation (Diffusion Equation)
% Crank Nicolson Method
% Bruno Da Silva Machado
%
% UFF - Volta Redonda, RJ, Brazil
% Sep 30th, 2021
%=====================================================================
%

function [] = Crank_Nicolson_2(filename,delt,tit)
%clc;
% Par�metros da barra
c = 1; % Coeficiente de condu��o t�rmica
Lx = 1.0; % Comprimento da barra
N = 100; % N�mero de n�s da Malha
delx = Lx/N; % Varia��o espacial ( discretiza��o)
x = (0:delx:1)';
%delt = [0.000001; 0.00001; 0.000025; 0.00005; 0.000051; 0.0001]; % Varia�� temporal
%delt = [0.000001, 0.00001, 0.000025, 0.00005, 0.000051, ...
%    0.00006, 0.00007, 0.00008, 0.0001]; % Varia�� temporal
maxIters = 1000; % N�mero de itera��es
% Condi��o inicial
U_n = zeros(1,N + 1); 
% Condi��o de contorno
U_n(1) = 1; %Esquerda
U_n(N + 1) = 1; %Direita
U_n_1 = U_n;

len_dt = size(delt,2);
residualA = zeros(1,maxIters);
solution = zeros(len_dt,N + 1);
ll = '';
figure(1)
for t = 1:len_dt
    lambda = (c* delt (t))/(delx*delx);
    A = lambda;
    B = 1 + 2*lambda;
    C = 1 - 2*lambda;
    % Matriz de coeficientes
    e = ones(N-1,1);
    T = spdiags([-e*A e*B -e*A], [-1 0 1], N-1, N-1);
    % Itera��o no tempo
    for n = 1: maxIters
        K = A*U_n(1:N-1) + C*U_n(2:N) + A*U_n(3:N+1);
        % Solu��o do sistema
        U_n_1 (2: N) = (T\K')';
        residualA(n) = abs( norm (U_n) - norm ( U_n_1 )); % Calculo do residuo
        U_n = U_n_1 ; % Passagem dos valores calculados
    end
    
    solution(t ,:) = U_n; % Solu��o da EDP
    ll = char(ll,sprintf('%s = %.2f','{\lambda}', lambda));
    % Gr�fico de estabilidade
    plot(log10(residualA),'LineWidth',2);grid on;
    title (tit);
    xlabel ('Numero de Itera��es','fontsize',14);
    ylabel ('Residuo [log]','fontsize',14);
    hold on
end
hold off
ll = ll(2:size(ll),:);
legend(ll,'Location','southwest');
saveas(gcf,sprintf('%s_01',filename),'png');
% Gr�fico da solu��o ( distribui��o de temperatura )
figure(2)
plot (x, solution,'LineWidth',1.5);
title ('Distribui��o de temperatura');
xlabel ('Comprimento da barra','fontsize',14);
ylabel ('Temperatura [�C]','fontsize',14);
saveas(gcf,sprintf('%s_02',filename),'png');
end