# Shown when greeted with the Suspicion role
suspicion-role-greeting = Você é um { $roleName }!
# Shown when greeted with the Suspicion role
suspicion-objective = Objetivo: { $objectiveText }
# Shown when greeted with the Suspicion role
suspicion-partners-in-crime =
    { $partnersCount ->
        [zero] Você está sozinho. Boa sorte!
        [one] Seu parceiro em crime é { $partnerNames }.
       *[other] Seus parceiros em crime são { $partnerNames }.
    }
