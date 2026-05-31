shared-solution-container-component-on-examine-main-text =
    Contém { INDEFINITE($desc) } [color={ $color }]{ $desc }[/color] { $chemCount ->
        [1] químico.
       *[other] mistura de químicos.
    }
examinable-solution-has-recognizable-chemicals = Você pode reconhecer { $recognizedString } na solução.
examinable-solution-recognized = [color={ $color }]{ $chemical }[/color]
examinable-solution-on-examine-volume-puddle =
    A poça é { $fillLevel ->
        [exact] [color=white]{ $current }u[/color].
        [full] muito grande e transbordando!
        [mostlyfull] muito grande e transbordando!
        [halffull] profundo e fluente.
        [halfempty] muito profundo.
       *[mostlyempty] juntando.
        [empty] formando vários pequenos poços.
    }
-solution-vague-fill-level =
    { $fillLevel ->
        [full] [color=white]Cheio[/color]
        [mostlyfull] [cor=#DFDFDF]Quase Cheio[/cor]
        [halffull] [color=#C8C8C8]Meio Cheio[/color]
        [halfempty] [color=#C8C8C8]Meio Vazio[/color]
        [mostlyempty] [cor=#A4A4A4]Quase Vazia[/cor]
       *[empty] [cor=cinza]Vazio[/cor]
    }
