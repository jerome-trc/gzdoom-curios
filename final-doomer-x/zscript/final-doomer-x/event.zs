// Rectifies ammo capacities to intended values when using the Customizer add-on.
class FDX_EventHandler : EventHandler
{
	final override void OnRegister()
	{
		if (!FDX_Common.Customizer())
		{
			Destroy();
			return;
		}
	}

	private static Inventory FindOrGive(PlayerPawn pawn, name type)
	{
		let ret = pawn.FindInventory(type);

		if (ret == null)
		{
			pawn.GiveInventory(type, 0);
			ret = pawn.FindInventory(type);
		}

		return ret;
	}

	final override void PlayerSpawned(PlayerEvent event)
	{
		if (!FDX_Common.Customizer())
			return;

		PlayerInfo p = Players[event.PlayerNumber];

		let iClip = Ammo(FindOrGive(p.MO, 'Clip'));
		let iShell = Ammo(FindOrGive(p.MO, 'Shell'));
		let iRocket = Ammo(FindOrGive(p.MO, 'RocketAmmo'));
		let iCell = Ammo(FindOrGive(p.MO, 'Cell'));

		let clip_tn = FDX_Common.BULLET_TYPES[FDX_Common.ChaingunTheme(p.MO)];
		let shell_tn1 = FDX_Common.SHELL_TYPES[FDX_Common.ShotgunTheme(p.MO)];
		let shell_tn2 = FDX_Common.SHELL_TYPES[FDX_Common.SuperShotgunTheme(p.MO)];
		let rocket_tn = FDX_Common.ROCKETAMMO_TYPES[FDX_Common.RocketLauncherTheme(p.MO)];
		let cell_tn = FDX_Common.CELL_TYPES[FDX_Common.PlasmaRifleTheme(p.MO)];

		let clip_t = (class<Ammo>)(clip_tn);
		let shell_t1 = (class<Ammo>)(shell_tn1);
		let shell_t2 = (class<Ammo>)(shell_tn2);
		let rocket_t = (class<Ammo>)(rocket_tn);
		let cell_t = (class<Ammo>)(cell_tn);

		let clipDefs = GetDefaultByType(clip_t);
		let shellDefs1 = GetDefaultByType(shell_t1);
		let shellDefs2 = GetDefaultByType(shell_t2);
		let rocketDefs = GetDefaultByType(rocket_t);
		let cellDefs = GetDefaultByType(cell_t);

		iClip.MaxAmount = clipDefs.MaxAmount;
		iClip.BackpackMaxAmount = clipDefs.BackpackMaxAmount;

		iShell.MaxAmount = Max(shellDefs1.MaxAmount, shellDefs2.MaxAmount);
		iShell.BackpackMaxAmount = Max(shellDefs1.BackpackMaxAmount, shellDefs2.BackpackMaxAmount);

		iRocket.MaxAmount = rocketDefs.MaxAmount;
		iRocket.BackpackMaxAmount = rocketDefs.BackpackMaxAmount;

		iCell.MaxAmount = cellDefs.MaxAmount;
		iCell.BackpackMaxAmount = cellDefs.BackpackMaxAmount;
	}
}
