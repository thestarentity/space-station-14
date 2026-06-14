namespace Content.Server.Silicons.StationAi;

/// <summary>
/// Marca um borg como "armado" para detonação pela IA de estação (confirmação por duplo-clique).
/// O primeiro clique em "Detonar" arma; o segundo clique, enquanto ainda armado pelo mesmo ator,
/// detona de fato. Some sozinho após <see cref="Until"/> (re-arma se clicar de novo depois disso).
/// </summary>
[RegisterComponent]
public sealed partial class StationAiDetonateArmedComponent : Component
{
    /// <summary>
    /// A IA (ator) que armou a detonação. Só ela pode confirmar.
    /// </summary>
    [DataField]
    public EntityUid Armer;

    /// <summary>
    /// Até quando a confirmação fica válida.
    /// </summary>
    [DataField]
    public TimeSpan Until;
}
