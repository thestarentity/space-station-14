logic-gate-examine = É atualmente a porta { INDEFINITE($gate) } { $gate }.
logic-gate-cycle = Mudado para a porta { INDEFINITE($gate) } { $gate } de ciclo lógico
power-sensor-examine =
    Ele está atualmente verificando a rede's { $output ->
        [true] O sensor de energia está ligado. Ele está mostrando uma leitura estável de energia. Você pode usar o sensor para detectar fontes de energia próximas.
       *[false] O sensor de energia está desligado. Você não pode examiná-lo enquanto estiver assim.
    } bateria.
power-sensor-voltage-examine = Ele está verificando a rede de energia { $voltage }.
power-sensor-switch =
    Mudando para verificar a rede's { $output ->
        [true] O sensor de energia está ligado. Ele está mostrando uma leitura estável de energia. Você pode usar o sensor para detectar fontes de energia próximas.
       *[false] O sensor de energia está desligado. Você não pode examiná-lo enquanto estiver assim.
    } bateria.
power-sensor-voltage-switch = Alterado a rede para { $voltage }!
