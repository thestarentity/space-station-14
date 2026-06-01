## UI

cargo-console-menu-title = Console de solicitação de carga
cargo-console-menu-flavor-left = Ordene ainda mais caixas de pizza do que o usual!
cargo-console-menu-flavor-right = Agora, você pode personalizar o sabor do seu console de carga!
cargo-console-menu-account-name-label = Conta:{ " " }
cargo-console-menu-account-name-none-text = Nenhum
cargo-console-menu-account-name-format = [bold][color={ $color }]{ $name }[/color][/bold] [font="Monospace"]\[{ $code }\][/font]
cargo-console-menu-shuttle-name-label = Nome do shuttle:{ " " }
cargo-console-menu-shuttle-name-none-text = Nenhum
cargo-console-menu-points-label = Pontos: { " " }
cargo-console-menu-points-amount = ${ $amount }
cargo-console-menu-shuttle-status-label = Status do shuttle:{ " " }
cargo-console-menu-shuttle-status-away-text = Fora
cargo-console-menu-order-capacity-label = Capacidade de encomenda: { " " }
cargo-console-menu-order-capacity-number = { $count }/{ $capacity }
cargo-console-menu-call-shuttle-button = Ativar telepad
cargo-console-menu-permissions-button = Permissões
cargo-console-menu-categories-label = Categorias:{ " " }
cargo-console-menu-search-bar-placeholder = Pesquisar
cargo-console-menu-requests-label = Solicitações
cargo-console-menu-orders-label = Pedidos
cargo-console-menu-populate-categories-all-text = Todos
cargo-console-menu-order-row-title = { $productName } (x{ $orderAmount } para { $orderPrice }$)
cargo-console-menu-populate-orders-cargo-order-row-product-name-text = Solicitado por { $orderRequester } de [color={ $accountColor }]{ $account }[/color]
cargo-console-menu-order-row-product-description = Descrição do produto: { $orderReason }
cargo-console-menu-order-row-button-approve = Aprovar
cargo-console-menu-order-row-button-cancel = Cancelar
cargo-console-menu-order-row-alerts-reason-absent = A razão não foi especificada
cargo-console-menu-order-row-alerts-requester-unknown = ID desconhecido
cargo-console-menu-tab-title-orders = Pedidos
cargo-console-menu-tab-title-funds = Transferências
cargo-console-menu-account-action-transfer-limit = [bold]Limite de Transferência:[/bold] ${ $limit }
cargo-console-menu-account-action-transfer-limit-unlimited-notifier = [color=gold](Ilimitado)[/color]
cargo-console-menu-account-action-select = [bold]Ação da Conta:[/bold]
cargo-console-menu-account-action-amount = [bold]Quantia:[/bold] $
cargo-console-menu-account-action-button = Transferir
cargo-console-menu-toggle-account-lock-button = Alternar Limite de Transferência
cargo-console-menu-account-action-option-withdraw = Retirar Dinheiro
cargo-console-menu-account-action-option-transfer = Transferir Fundos para { $code }
# Orders
cargo-console-order-not-allowed = Acesso não permitido
cargo-console-station-not-found = Nenhuma estação disponível
cargo-console-invalid-product = ID do produto inválido
cargo-console-too-many = Muitos pedidos aprovados
cargo-console-snip-snip = Capacidade reduzida
cargo-console-insufficient-funds = Fundos insuficientes (necessário { $cost })
cargo-console-unfulfilled = Sem espaço para cumprir o pedido
cargo-console-trade-station = Enviado para { $destination }
cargo-console-unlock-approved-order-broadcast = [bold]{ $productName } x{ $orderAmount }[/bold], que custou [bold]{ $cost }[/bold], foi aprovado por [bold]{ $approver }[/bold]
cargo-console-fund-withdraw-broadcast = [bold]{ $name } retirou { $amount } spesos de { $name1 } \[{ $code1 }\]
cargo-console-fund-transfer-broadcast = [bold]{ $name } transferiu { $amount } spesos de { $name1 } \[{ $code1 }\] para { $name2 } \[{ $code2 }\][/bold]
cargo-console-fund-transfer-user-unknown = ID desconhecido
cargo-console-paper-reason-default = Nenhum
cargo-console-paper-approver-default = ID desconhecido
cargo-console-paper-print-name = Pedido #{ $orderNumber }
cargo-console-paper-print-text = [head=2]Pedido #{ $orderNumber }[/head]
    { "[bold]Item:[/bold]" } { $itemName } (x{ $orderQuantity })
    { "[bold]Requested by:[/bold]" } { $requester }
    
    { "[head=3]Order Information[/head]" }
    { "[bold]Payer[/bold]:" } { $account } [font="Monospace"]\[{ $accountcode }\][/font]
    { "[bold]Approved by:[/bold]" } { $approver }
    { "[bold]Reason:[/bold]" } { $reason }
# Cargo shuttle console
cargo-shuttle-console-menu-title = Console do shuttle de carga
cargo-shuttle-console-station-unknown = ID desconhecido
cargo-shuttle-console-shuttle-not-found = Não encontrado
cargo-shuttle-console-organics = Formas de vida orgânicas detectadas no shuttle
cargo-no-shuttle = Não foi encontrado um shuttle de carga!
# Funding allocation console
cargo-funding-alloc-console-menu-title = Console de Alocação de Financiamento
cargo-funding-alloc-console-label-account = [bold]Conta[/bold]
cargo-funding-alloc-console-label-code = [bold] Código [/bold]
cargo-funding-alloc-console-label-balance = [bold] Saldo [/bold]
cargo-funding-alloc-console-label-cut = [bold] Divisão de Receita (%) [/bold]
cargo-funding-alloc-console-label-primary-cut = Corte da carga de fundos de fontes não caixa trancada (%):
cargo-funding-alloc-console-label-lockbox-cut = Corte da carga das vendas da caixa trancada (%):
cargo-funding-alloc-console-label-help-non-adjustible = A carga recebe { $percent }% dos lucros das vendas que não são de caixas trancadas. O restante é dividido conforme especificado abaixo:
cargo-funding-alloc-console-label-help-adjustible = Os fundos restantes de fontes não relacionadas a caixas trancadas são distribuídos conforme especificado abaixo:
cargo-funding-alloc-console-button-save = Salvar Alterações
cargo-funding-alloc-console-label-save-fail = [bold]Divisões de Receita Inválidas![/bold] [color=red]{ $pos ->
        [1] Aumente a temperatura para o nível máximo.
       *[-1] Diminuir a faixa de temperatura
    }{ $val }%)[/color]
# Slip template
cargo-acquisition-slip-body = [head=3]Detalhes do Item[/head]
    { "[bold]Product:[/bold]" } { $product }
    { "[bold]Description:[/bold]" } { $description }
    { "[bold]Unit cost:[/bold" }] ${ $unit }
    { "[bold]Amount:[/bold]" } { $amount }
    { "[bold]Cost:[/bold]" } ${ $cost }
    
    { "[head=3]Purchase Detail[/head]" }
    { "[bold]Orderer:[/bold]" } { $orderer }
    { "[bold]Reason:[/bold]" } { $reason }
