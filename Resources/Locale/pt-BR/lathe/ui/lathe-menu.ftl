lathe-menu-title = Menu do Torno
lathe-menu-queue = Fila
lathe-menu-server-list = Lista de servidores
lathe-menu-sync = Sincronizar
lathe-menu-search-designs = Buscar designs
lathe-menu-category-all = Todos
lathe-menu-search-filter = Filtrar:
lathe-menu-amount = Quantidade:
lathe-menu-recipe-count =
    { $count ->
        [1] { $count } Receita
       *[other] { $count } Receitas
    }
lathe-menu-reagent-slot-examine = Ele tem um slot para um balão de laboratório no lado.
lathe-reagent-dispense-no-container = Líquido vaza de { THE($name) } no chão!
lathe-menu-result-reagent-display = { $reagent } ({ $amount }u)
lathe-menu-material-display = { $material } ({ $amount })
lathe-menu-tooltip-display = { $amount } de { $material }
lathe-menu-description-display = [italic]{ $description }[/italic]
lathe-menu-material-amount =
    { $amount ->
        [1] { NATURALFIXED($amount, 2) } { $unit }
       *[other] { NATURALFIXED($amount, 2) } { MAKEPLURAL($unit) }
    }
lathe-menu-material-amount-missing =
    { $amount ->
        [1] { NATURALFIXED($amount, 2) } { $unit } de { $material } ([color=red]{ NATURALFIXED($missingAmount, 2) } { $unit } faltando[/color])
       *[other] { NATURALFIXED($amount, 2) } { MAKEPLURAL($unit) } de { $material } ([color=red]{ NATURALFIXED($missingAmount, 2) } { MAKEPLURAL($unit) } faltando[/color])
    }
lathe-menu-no-materials-message = Nenhum material carregado.
lathe-menu-silo-linked-message = Silo Vinculado
lathe-menu-fabricating-message = Fabricando...
lathe-menu-materials-title = Materiais
lathe-menu-queue-title = Fila de Fabricação
lathe-menu-delete-fabricating-tooltip = Cancelar a impressão do item atual.
lathe-menu-delete-item-tooltip = Cancelar a impressão deste lote.
lathe-menu-move-up-tooltip = Mover este lote para frente na fila.
lathe-menu-move-down-tooltip = Mova este lote para trás na fila.
lathe-menu-item-single = { $index }. { $name }
lathe-menu-item-batch = { $index }. { $name } ({ $printed }/{ $total })
