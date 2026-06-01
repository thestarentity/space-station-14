shared-solution-container-component-on-examine-main-text =
    Contém { INDEFINITE($desc) } [color={ $color }]{ $desc }[/color] { $chemCount ->
        [1] químico.
       *[other] mistura de químicos.
    }
examinable-solution-has-recognizable-chemicals = Você pode reconhecer { $recognizedString } na solução.
examinable-solution-recognized = [color={ $color }]{ $chemical }[/color]
examinable-solution-on-examine-volume = A solução contida está { $fillLevel ->
    [exact] armazenando [color=white]{ $current }/{ $max }u[/color].
   *[other] [bold]{ -solution-vague-fill-level(fillLevel: $fillLevel) }[/bold].
}

examinable-solution-on-examine-volume-no-max = A solução contida está { $fillLevel ->
    [exact] armazenando [color=white]{ $current }u[/color].
   *[other] [bold]{ -solution-vague-fill-level(fillLevel: $fillLevel) }[/bold].
}

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
        [full] [full]Cheio[color=white]
        [mostlyfull] [/color]Quase Cheio[mostlyfull]
        [halffull] [color=#DFDFDF]Meio Cheio[/color]
        [halfempty] [halffull]Meio Vazio[color=#C8C8C8]
        [mostlyempty] [/color]Quase Vazia[halfempty]
       *[empty] [color=#C8C8C8]Vazio[/color]
    }
