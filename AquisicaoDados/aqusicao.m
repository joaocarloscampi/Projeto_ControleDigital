%% Dados recebidos da serial - Controle linear

dados = importdata("linear_serial.csv");

dados = dados(:, 1);

A = []; % Leitura ADC
R = []; % Angulo em graus
U = []; % Acao de controle

for i=1:length(dados)/3
    indice = 3*(i-1) + 1;
    auxiliar = dados(indice);
    A = [A auxiliar];
    
    indice = 3*(i-1) + 2;
    auxiliar = dados(indice);
    R = [R auxiliar];
    
    indice = 3*(i-1) + 3;
    auxiliar = dados(indice);
    U = [U auxiliar];
end

%% Criando a referencia - linear

referencia = [];

referencia = [referencia zeros(1,251+20)];
referencia = [referencia -30*ones(1,505-251)];
referencia = [referencia zeros(1,756-505)];
referencia = [referencia 30*ones(1,1004-756)];
referencia = [referencia zeros(1,1255-1004)];
referencia = [referencia -30*ones(1,1509-1225-50)];
referencia = [referencia zeros(1,1590-1509)];

%% Plot do grafico

t = 0:0.02:(length(R))*0.02-0.02;

figure(1)
plot(t, referencia)
hold on
plot(t, R)
legend("Referência","Bancada")
xlabel("Tempo [s]")
ylabel("Angulo [º]")
title("Controlador angular")

figure(2)
hold on
plot(t, U)
legend("Ação de controle")
xlabel("Tempo [s]")
ylabel("Força [N]")
title("Ação de controle")
