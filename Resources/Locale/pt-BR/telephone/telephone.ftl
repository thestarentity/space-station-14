# Chat window telephone wrap (prefix and postfix)
chat-telephone-message-wrap = [color={ $color }][bold]{ $name }[/bold] { $verb }, [font={ $fontType } size={ $fontSize }]"{ $message }"[/font][/color]
chat-telephone-message-wrap-bold = [color={ $color }][bold]{ $name }[/bold] { $verb }, [font={ $fontType } size={ $fontSize }][bold]"{ $message }"[/bold][/font][/color]
# Caller ID
chat-telephone-unknown-caller = [cor={ $color }][fonte={ $fontType } tamanho={ $fontSize }][negritoitálico]Chamada desconhecida[/negritoitálico][/fonte][/cor]
chat-telephone-caller-id-with-job = [cor={ $color }][fonte={ $fontType } tamanho={ $fontSize }][negrito]{ CAPITALIZE($callerName) } ({ CAPITALIZE($callerJob) })[/negrito][/fonte][/cor]
chat-telephone-caller-id-without-job = [color={ $color }][font={ $fontType } size={ $fontSize }][bold]{ CAPITALIZE($callerName) }[/bold][/font][/color]
chat-telephone-unknown-device = [cor={ $color }][fonte={ $fontType } tamanho={ $fontSize }][negritoitálico]Fonte desconhecida[/negritoitálico][/fonte][/cor]
chat-telephone-device-id = [color={ $color }][font={ $fontType } size={ $fontSize }][bold]{ CAPITALIZE($deviceName) }[/bold][/font][/color]
# Chat text
chat-telephone-name-relay = { $originalName } ({ $speaker })
