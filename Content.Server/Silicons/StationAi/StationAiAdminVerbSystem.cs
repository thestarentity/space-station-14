using Content.Server.Administration.Managers;
using Content.Server.Mind;
using Content.Shared.Administration;
using Content.Shared.Database;
using Content.Shared.Silicons.StationAi;
using Content.Shared.Verbs;
using Robust.Shared.Player;
using Robust.Shared.Utility;

namespace Content.Server.Silicons.StationAi;

/// <summary>
/// Utilitário de admin: adiciona um verbo "Controlar IA" ao núcleo da IA de estação. Clicar
/// transfere o controle do admin para o CÉREBRO da IA (a entidade no container
/// <c>station_ai_mind_slot</c>, que tem as funções/menu radial) — e não para a carcaça do núcleo,
/// que é o que o <c>controlmob</c> no núcleo pegaria por engano. Evita ter que caçar o UID do
/// cérebro no View Variables. Gated por admin, como o comando controlmob.
/// </summary>
public sealed partial class StationAiAdminVerbSystem : EntitySystem
{
    [Dependency] private IAdminManager _admin = default!;
    [Dependency] private MindSystem _mind = default!;
    [Dependency] private StationAiSystem _stationAi = default!;

    public override void Initialize()
    {
        base.Initialize();

        SubscribeLocalEvent<StationAiCoreComponent, GetVerbsEvent<Verb>>(OnGetVerbs);
    }

    private void OnGetVerbs(Entity<StationAiCoreComponent> ent, ref GetVerbsEvent<Verb> args)
    {
        if (!TryComp(args.User, out ActorComponent? actor) || !_admin.IsAdmin(actor.PlayerSession))
            return;

        // Acha o cérebro da IA (a entidade controlável com as funções) dentro do núcleo.
        if (!_stationAi.TryGetHeld((ent.Owner, ent.Comp), out var held) || held == null)
            return;

        var user = args.User;
        var target = held.Value;

        args.Verbs.Add(new Verb
        {
            Text = Loc.GetString("station-ai-admin-control-verb"),
            Category = VerbCategory.Admin,
            Icon = new SpriteSpecifier.Texture(new("/Textures/Interface/VerbIcons/in.svg.192dpi.png")),
            Act = () => _mind.ControlMob(user, target),
            Impact = LogImpact.High,
        });
    }
}
