book-text-atmos-distro =
    A rede de distribuição, ou "distro" para abreviar, é a linha de vida da estação. Ela é responsável por transportar ar dos atmosféricos por todo a estação.
    
    Tubulações relevantes são frequentemente pintadas de Azul Submisso Pulsante, mas uma forma infalível de identificá-las é usar um scanner de bandeja para rastrear quais tubulações estão conectadas a ventos ativos na estação.
    
    A mistura padrão de gás da rede de distribuição é 20 graus celsius, 78% nitrogênio, 22% oxigênio. Você pode verificar isso usando um analisador de gás em uma tubulação de distro ou qualquer vento conectado a ela. Circunstâncias especiais podem exigir misturas especiais.
    
    Quando se trata de decidir a pressão da distro, há algumas coisas a considerar. Vents ativos regularão a pressão da estação, então desde que tudo esteja funcionando corretamente, não existe tal coisa como uma pressão de distro muito alta.
    
    Uma pressão de distro mais alta permitirá que a rede de distro atue como um buffer entre os mineradores de gás e os vents, fornecendo uma quantidade significativa de ar extra que pode ser usada para re-pressurizar a estação após um spacing.
    
    Uma pressão de distro mais baixa reduzirá a quantidade de gás perdida no caso de um spacing na distro, uma forma rápida de lidar com a contaminação da distro. Ela também pode ajudar a reduzir ou evitar a super-pressurização da estação no caso de problemas com os vents.
    
    Pressões comuns de distro estão na faixa de 300-375 kPa, mas outras pressões podem ser usadas com conhecimento dos riscos e benefícios.
    
    A pressão da rede é determinada pela última bomba que está bombando para ela. Para evitar gargalos, todas as outras bombas entre os mineradores e a última bomba devem ser configuradas na sua taxa máxima, e quaisquer dispositivos desnecessários devem ser removidos.
    
    Você pode validar a pressão da distro com um analisador de gás, mas lembre-se de que uma alta demanda devido a coisas como spacings pode causar a distro a ficar abaixo da pressão alvo definida por períodos prolongados. Então, se você notar uma queda na pressão, não entre em pânico — pode ser temporária.
book-text-atmos-waste =
    A rede de resíduos é o sistema principal responsável por manter o ar na estação livre de contaminantes.
    
    Você pode identificar os tubos relevantes pela cor Agradavelmente Tosta Vermelha ou usando um scanner de bandeja para rastrear quais tubos estão conectados aos purificadores na estação.
    
    A rede de resíduos é usada para transportar gases residuais para serem filtrados ou lançados no espaço. É ideal manter a pressão em 0 kPa, mas ela pode estar ocasionalmente em uma pressão baixa, mas não zero, enquanto está em uso.
    
    Os técnicos têm a opção de filtrar ou lançar os gases residuais. Embora lançar seja mais rápido, filtrar permite que os gases sejam reutilizados para reciclagem ou venda.
    
    A rede de resíduos também pode ser usada para diagnosticar problemas atmosféricos na estação. Níveis altos de um gás residual podem sugerir uma grande fuga, enquanto a presença de gases que não são residuais pode indicar um problema de configuração ou conexão física dos purificadores. Se os gases estiverem em uma temperatura alta, pode indicar um incêndio.
book-text-atmos-alarms =
    Alarms de ar estão localizados em toda a estação para permitir o gerenciamento e monitoramento da atmosfera local.
    
    A interface do alarme de ar fornece aos técnicos uma lista de sensores conectados, suas leituras e a capacidade de ajustar os limites. Esses limites são usados para determinar a condição de alarme do alarme de ar. Os técnicos também podem usar a interface para definir pressões-alvo para ventos e configurar as velocidades de operação e os gases-alvo para os purificadores.
    
    Embora a interface permita ajustes finos dos dispositivos sob o controle do alarme de ar, também existem vários modos disponíveis para configuração rápida do alarme. Esses modos são automaticamente ativados quando o estado do alarme muda:
    - Filtragem: O modo padrão
    - Filtragem (ampla): Um modo de filtragem que modifica a operação dos purificadores para limpar uma área mais ampla
    - Encher: Desativa os purificadores e define os ventos para sua pressão máxima
    - Pânico: Desativa os ventos e define os purificadores para sifonar
    
    Um multitool ou um configurador de rede pode ser usado para vincular dispositivos a alarmes de ar.
book-text-atmos-vents =
    Abaixo está um guia rápido de referência para vários dispositivos atmosféricos:
    
                Válvulas Passivas:
                Essas válvulas não requerem energia, permitindo que gases fluam livremente tanto para dentro quanto para fora da rede de tubos a que estão conectadas.
    
                Válvulas Ativas:
                Essas são as válvulas mais comuns na estação. Elas possuem uma bomba interna e requerem energia. Por padrão, elas só bombearão gases para fora dos tubos e apenas até 101 kpa. No entanto, podem ser reconfiguradas usando um alarme de ar. Elas também travarão se a sala estiver com menos de 1 kpa, para evitar bombear gases para o espaço.
    
                Purificadores de Ar:
                Esses dispositivos permitem que gases sejam removidos do ambiente e colocados na rede de tubos conectada. Eles podem ser configurados para selecionar gases específicos quando conectados a um alarme de ar.
    
                Injetores de Ar:
                Os injetores são semelhantes às válvulas ativas, mas não possuem uma bomba interna e não requerem energia. Eles não podem ser configurados, mas podem continuar a bombear gases até pressões muito mais altas.
