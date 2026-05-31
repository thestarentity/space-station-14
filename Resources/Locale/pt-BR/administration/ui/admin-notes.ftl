# UI
admin-notes-title = Notas para { $player }
admin-notes-new-note = Nova nota
admin-notes-show-more = Mostrar mais
admin-notes-for = Nota para: { $player }
admin-notes-id = Id: { $id }
admin-notes-type = Tipo: { $type }
admin-notes-severity = Gravidade: { $severity }
admin-notes-secret = Segredo
admin-notes-notsecret = Não secreto
admin-notes-expires = Expira em: { $expires }
admin-notes-expires-never = Não expira
admin-notes-edited-never = Nunca
admin-notes-round-id = ID da Rodada: { $id }
admin-notes-round-id-unknown = ID da Rodada: Desconhecido
admin-notes-created-by = Criado por: { $author }
admin-notes-created-at = Criado Em: { $date }
admin-notes-last-edited-by = Última edição por: { $author }
admin-notes-last-edited-at = Última edição em: { $date }
admin-notes-edit = Editar
admin-notes-delete = Excluir
admin-notes-hide = Ocultar
admin-notes-delete-confirm = Confirmar exclusão
admin-notes-edited = Última edição por { $author } em { $date }
admin-notes-unbanned = Desbanido por { $admin } em { $date }
admin-notes-message-desc = [cor=branco]Você recebeu  { $count ->
        [1] uma mensagem administrativa
       *[other] mensagens administrativas
    }desde a última vez que você jogou nesse servidor.
admin-notes-message-admin = De [bold]{ $admin }[/bold], escrito em { TOSTRING($date, "f") }:
admin-notes-message-wait = O botão de aceitar será ativado após { $time } segundos.
admin-notes-message-accept = Descartar permanentemente
admin-notes-message-dismiss = Ignorar por enquanto
admin-notes-message-seen = Visto
admin-notes-banned-from = Banido de
admin-notes-the-server = o servidor
admin-notes-permanently = permanentemente
admin-notes-days = { $days } dias
admin-notes-hours = { $hours } horas
admin-notes-minutes = { $minutes } minutos
# Note editor UI
admin-note-editor-title-new = Criando uma nova nota para { $player }
admin-note-editor-title-existing = Editando anotação { $id } em { $player } por { $author }
admin-note-editor-pop-out = Sair da janela
admin-note-editor-secret = Segredo?
admin-note-editor-secret-tooltip = Marcando isso fará com que a nota não seja visível pelo jogador
admin-note-editor-type-note = Nota
admin-note-editor-type-message = Você pode usar o botão 
admin-note-editor-type-watchlist = Lista de observação
admin-note-editor-type-server-ban = Banimento do Servidor
admin-note-editor-type-role-ban = Banimento de Cargo
admin-note-editor-severity-select = Selecione
admin-note-editor-severity-none = Nenhum
admin-note-editor-severity-low = Baixo
admin-note-editor-severity-medium = Médio
admin-note-editor-severity-high = Alto
admin-note-editor-expiry-checkbox = Permanente?
admin-note-editor-expiry-checkbox-tooltip = Marque isso para que ele expire
admin-note-editor-expiry-label = Expira em:
admin-note-editor-expiry-label-params = Expira em: { $date } (em { $expiresIn })
admin-note-editor-expiry-label-expired = Expirado
admin-note-editor-expiry-placeholder = Digite o tempo de expiração (número inteiro).
admin-note-editor-submit = Enviar
admin-note-editor-submit-confirm = Tem certeza?
# Time
admin-note-button-minutes = Minutos
admin-note-button-hours = Horas
admin-note-button-days = Dias
admin-note-button-weeks = Semanas
admin-note-button-months = Meses
admin-note-button-years = Anos
admin-note-button-centuries = Séculos
# Verb
admin-notes-verb-text = Abrir Notas de Administração
# Watchlist and message login
admin-notes-watchlist = Lista de observação para { $player }: { $message }
admin-notes-new-message = Você recebeu uma mensagem de administrador de { $admin }: { $message }
admin-notes-fallback-admin-name = Administrador desconhecido
# Admin remarks
admin-remarks-command-description = Abre a página de observações administrativas
admin-remarks-command-error = O administrador desativou os comentários.
admin-remarks-title = Observações do administrador
# Misc
system-user = Administrador desconhecido
