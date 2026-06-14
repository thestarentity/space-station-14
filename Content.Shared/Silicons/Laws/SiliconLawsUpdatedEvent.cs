namespace Content.Shared.Silicons.Laws;

/// <summary>
/// Levantado na entidade silício sempre que suas leis mudam (via NotifyLawsChanged).
/// Usado por outros sistemas pra reagir, ex.: marcar a IA como sob lei hostil.
/// </summary>
[ByRefEvent]
public record struct SiliconLawsUpdatedEvent;
