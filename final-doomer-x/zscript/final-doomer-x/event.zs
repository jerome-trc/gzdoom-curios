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

		for (uint i = 0; i < 5; i++)
			for (uint ii = 0; ii < __FDX_THEME_COUNT__; ii++)
				PlayerPresence[i][ii] = 256;
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

	private static void FixFDCAmmoCapacities(uint playerNumber)
	{
		if (!FDX_Common.Customizer())
			return;

		PlayerInfo p = Players[playerNumber];

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

	final override void PlayerSpawned(PlayerEvent event)
	{
		let pawn = Players[event.PlayerNumber].MO;

		if (pawn is 'FDCPlayer')
		{
			PlayerPresence[0][FDX_Common.ChaingunTheme(pawn)] = 0;
			PlayerPresence[1][FDX_Common.SuperShotgunTheme(pawn)] = 0;
			PlayerPresence[2][FDX_Common.RocketLauncherTheme(pawn)] = 0;
			PlayerPresence[3][FDX_Common.PlasmaRifleTheme(pawn)] = 0;
			PlayerPresence[4][FDX_Common.BFGTheme(pawn)] = 0;
		}

		FixFDCAmmoCapacities(event.PlayerNumber);
	}

	final override void PlayerEntered(PlayerEvent event)
	{
		FixFDCAmmoCapacities(event.PlayerNumber);
	}

	final override void CheckReplacement(ReplaceEvent event)
	{
		if (event.Replacee is 'FDBerserkPickup')
			event.Replacement = 'FDX_Berserk';
		else if (event.Replacee.GetClassName() == 'FDBTSXPlasmaProjectile')
			event.Replacement = 'FDX_BTSXPlasmaProjectile';
		else if (event.Replacee.GetClassName() == 'FDBTSXFancyPlasmaProjectile')
			event.Replacement = 'FDX_BTSXFancyPlasmaProjectile';
	}

	// Non-Customizer players have an ACS script that tracks if any of them are
	// present for the purposes of spawning item visuals conditionally.
	// The Customizer offers no such facility, so we do it ourselves.
	// Any given value is either 256 or 0.
	// Remember that this targets a ZS version below 3.7.2 so array accesses
	// are dimensionally backwards.
	private int PlayerPresence[__FDX_THEME_COUNT__][5];

	int ClipVisualSpawnFailChance(FDX_Theme theme) const
	{
		return PlayerPresence[0][theme];
	}

	int ShellVisualSpawnFailChance(FDX_Theme theme) const
	{
		return PlayerPresence[1][theme];
	}

	int RocketAmmoVisualSpawnFailChance(FDX_Theme theme) const
	{
		return PlayerPresence[2][theme];
	}

	int CellVisualSpawnFailChance(FDX_Theme theme) const
	{
		return PlayerPresence[3][theme];
	}

	int BFGAmmoVisualSpawnFailChance(FDX_Theme theme) const
	{
		return PlayerPresence[4][theme];
	}

	static clearscope FDX_EventHandler Get()
	{
		return FDX_EventHandler(EventHandler.Find('FDX_EventHandler'));
	}
}
