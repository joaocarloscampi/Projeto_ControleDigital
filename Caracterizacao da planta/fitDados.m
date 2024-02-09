%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Controle Digital - UFSCar
%   Fit de dados experimentais e estimativa da função
%   de transferência da planta
%
%   Autores:
%       Andre Camilo Terra Costa
%       Giovanna Amorim Nascimento
%       João Carlos Tonon Campi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear;
close all;
clc;

%% Janelamento do sinal
data = readmatrix('scope_0.csv');

inicio = 710;
fim = 200;

yData = data(inicio:(end-fim), 2)*0.6186 - 1.1856; % Conversão de V para rad
yData = yData - yData(1);
tData = data(inicio:(end-fim), 1);

% Visualização do janelamento
figure(1)
hold on;
plot(tData, yData)
%plot(data(inicio:(end-fim), 1), data(inicio:(end-fim), 3))
title("Dados janelados")
grid on
ylabel("Tensão [V]")
xlabel("Tempo [s]")

% Fit resultado - curvefit:
%        a =         251  (127.2, 374.9)
%        b =       250.5  (126.7, 374.4)
%        c =       28.21  (21.6, 34.82)
%        d =      0.1107  (0.08236, 0.1391)

%% Caracterização da planta - Obtenção da função de transferência
% Constantes obtidas no curvefit
a = 161.8;
b = 161.8;
c = 18.01;
d = 0.11;

% Constantes da função de transferencia
p = d;
K = c*p;

% Conversão PWM - Força
degrau_pwm = 15;
degrau_f = -0.161 + 0.0126*degrau_pwm + 0.00019*degrau_pwm^2;

% Correção do valor K
K = K/degrau_f;

% FT da planta bimotora
funcao_transferencia = tf([K], [1 p 0 ]);

% Degrau FT com t=1
[step_data, tempo] = step(funcao_transferencia, 1);

figure(2)
hold on
title("Comparação da caracterização")
xlabel("Tempo [s]")
ylabel("Tensão [V]")
grid on
plot(tData-tData(1), yData)
plot(tempo, step_data*degrau_f )
legend("Experimento", "Planta caracterizada")

% Calculo do modelo estimado pelo cuvefit
t = linspace(0, 4, 1000);
y_exp = c*t - b + a*exp(-d*t);

% Degrau FT com t=4
[step_data, tempo] = step(funcao_transferencia, 4); 

figure(3)
title("Comparação da caracterização 2")
xlabel("Tempo [s]")
ylabel("Tensão [V]")
hold on
grid on
plot(tempo, step_data*degrau_f)
plot(t, y_exp)
legend("Planta caracterizada", "Exponencial")

%% Discretização da planta

Ts = 0.02;
ft_discreta = c2d(funcao_transferencia, Ts, 'zoh');
