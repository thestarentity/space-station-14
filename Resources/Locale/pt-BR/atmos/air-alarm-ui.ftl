# UI


## Window

air-alarm-ui-title = Alarme de Ar
air-alarm-ui-access-denied = Acesso insuficiente!
air-alarm-ui-window-pressure-label = Pressão
air-alarm-ui-window-temperature-label = Temperatura
air-alarm-ui-window-alarm-state-label = Estado do alarme
air-alarm-ui-window-address-label = Endereço
air-alarm-ui-window-device-count-label = Dispositivos Totais
air-alarm-ui-window-resync-devices-label = Reconectar
air-alarm-ui-window-mode-label = Modo
air-alarm-ui-window-mode-select-locked-label = [bold][color=vermelho] Falha no seletor de modo! [/color][/bold]
air-alarm-ui-window-auto-mode-label = Modo automático
-air-alarm-state-name =
    { $state ->
        [normal] Normal
        [warning] Aviso
        [danger] Perigo
        [emagged] Emagado
       *[invalid] Inválido
    }
air-alarm-ui-window-alarm-state = [color={ $color }]{ -air-alarm-state-name(state: $state) }[/color]
air-alarm-ui-window-alarm-state-indicator = Estado: [color={ $color }]{ -air-alarm-state-name(state: $state) }[/color]
air-alarm-ui-window-listing-title = { $address } : { -air-alarm-state-name(state: $state) }
air-alarm-ui-window-pressure = { $pressure } kPa
air-alarm-ui-window-pressure-indicator = Pressão: [color={ $color }]{ $pressure } kPa[/color]
air-alarm-ui-window-temperature = { $tempC } °C ({ $temperature } K)
air-alarm-ui-window-temperature-indicator = Temperatura: [color={ $color }]{ $tempC } C ({ $temperature } K)[/color]
air-alarm-ui-window-tab-vents = Válvulas
air-alarm-ui-window-tab-scrubbers = Escovas
air-alarm-ui-window-tab-sensors = Sensores
air-alarm-ui-gases = { $gas }: { $amount } mol ({ $percentage }%)
air-alarm-ui-gases-indicator = { $gas }: [color={ $color }]{ $amount } mol ({ $percentage }%)[/color]
air-alarm-ui-mode-filtering = Filtragem
air-alarm-ui-mode-wide-filtering = Filtragem (ampla)
air-alarm-ui-mode-fill = Preencha
air-alarm-ui-mode-panic = Pânico
air-alarm-ui-mode-none = Nenhum
air-alarm-ui-pump-direction-siphoning = Sifonando
air-alarm-ui-pump-direction-scrubbing = Limpando
air-alarm-ui-pump-direction-releasing = Solta
air-alarm-ui-pressure-bound-nobound = Sem Limites
air-alarm-ui-pressure-bound-internalbound = Limitado Internamente
air-alarm-ui-pressure-bound-externalbound = Limites Externos
air-alarm-ui-pressure-bound-both = Ambos
air-alarm-ui-widget-gas-filters = Filtros de Gás

## Widgets


### General

air-alarm-ui-widget-enable = Habilitado
air-alarm-ui-widget-copy = Copie as configurações para dispositivos similares
air-alarm-ui-widget-copy-tooltip = Copia as configurações deste dispositivo para todos os dispositivos nesta aba de alarme de ar.
air-alarm-ui-widget-ignore = Ignorar
air-alarm-ui-atmos-net-device-label = Endereço: { $address }

### Vent pumps

air-alarm-ui-vent-pump-label = Direção do vento
air-alarm-ui-vent-pressure-label = Pressão limitada
air-alarm-ui-vent-external-bound-label = Limites externos
air-alarm-ui-vent-internal-bound-label = Limites internos

### Scrubbers

air-alarm-ui-scrubber-pump-direction-label = Direção
air-alarm-ui-scrubber-volume-rate-label = Taxa (L)
air-alarm-ui-scrubber-wide-net-label = WideNet
air-alarm-ui-scrubber-select-all-gases-label = Selecionar todos
air-alarm-ui-scrubber-deselect-all-gases-label = Deselecionar todos

### Thresholds

air-alarm-ui-sensor-gases = Gases
air-alarm-ui-sensor-thresholds = Limites
air-alarm-ui-thresholds-pressure-title = Limites (kPa)
air-alarm-ui-thresholds-temperature-title = Limites (K)
air-alarm-ui-thresholds-gas-title = Limiares (%)
air-alarm-ui-thresholds-upper-bound = Perigo acima
air-alarm-ui-thresholds-lower-bound = Perigo abaixo
air-alarm-ui-thresholds-upper-warning-bound = Aviso acima
air-alarm-ui-thresholds-lower-warning-bound = Aviso abaixo
air-alarm-ui-thresholds-copy = Copie os limites para todos os dispositivos
air-alarm-ui-thresholds-copy-tooltip = Copia os limites do sensor deste dispositivo para todos os dispositivos nesta aba de alarme de ar.
