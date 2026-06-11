# Chat window telephone wrap (prefix and postfix)
chat-telephone-message-wrap = [color={ $color }][bold]{ $name }[/bold] { $verb }, [font={ $fontType } size={ $fontSize }]"{ $message }"[/font][/color]
chat-telephone-message-wrap-bold = [color={ $color }][bold]{ $name }[/bold] { $verb }, [font={ $fontType } size={ $fontSize }][bold]"{ $message }"[/bold][/font][/color]
# Caller ID
chat-telephone-unknown-caller = [cor={ $color }][fonte={ $fontType } tamanho={ $fontSize }][color={ $color }]Chamada desconhecida[font={ $fontType } size={ $fontSize }][color={ $color }][font={ $fontType } size={ $fontSize }]
chat-telephone-caller-id-with-job = [cor={ $color }][fonte={ $fontType } tamanho={ $fontSize }][color={ $color }]{ CAPITALIZE($callerName) } ({ CAPITALIZE($callerJob) })[font={ $fontType } size={ $fontSize }][color={ $color }][font={ $fontType } size={ $fontSize }]
chat-telephone-caller-id-without-job = [color={ $color }][font={ $fontType } size={ $fontSize }][bold]{ CAPITALIZE($callerName) }[/bold][/font][/color]
chat-telephone-unknown-device = [cor={ $color }][fonte={ $fontType } tamanho={ $fontSize }][color={ $color }]Fonte desconhecida[font={ $fontType } size={ $fontSize }][color={ $color }][font={ $fontType } size={ $fontSize }]
chat-telephone-device-id = [color={ $color }][font={ $fontType } size={ $fontSize }][bold]{ CAPITALIZE($deviceName) }[/bold][/font][/color]
# Chat text
chat-telephone-name-relay = { $originalName } ({ $speaker })
