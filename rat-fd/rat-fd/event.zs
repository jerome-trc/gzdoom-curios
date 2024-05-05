// Rectifies ammo capacities to intended values when using the Customizer add-on.
class ratfd_EventHandler : StaticEventHandler
{
	private Dictionary replaceMap;

	final override void OnRegister()
	{
		self.replaceMap = Dictionary.Create();

		self.replaceMap.Insert("GreenArmor", "ratfd_GreenArmor");
		self.replaceMap.Insert("FDGreenArmorPickup", "ratfd_GreenArmor");

		self.replaceMap.Insert("BlueArmor", "ratfd_BlueArmor");
		self.replaceMap.Insert("FDBlueArmorPickup", "ratfd_BlueArmor");

		self.replaceMap.Insert("FDBerserkPickup", "ratfd_Berserk");
		self.replaceMap.Insert("FDBTSXPlasmaProjectile", "ratfd_BTSXPlasmaProjectile");
		self.replaceMap.Insert("FDBTSXFancyPlasmaProjectile", "ratfd_BTSXFancyPlasmaProjectile");

		self.replaceMap.Insert("ArmorBonus", "ratfd_ArmorBonus");
		self.replaceMap.Insert("FDArmorBonusPickup", "ratfd_ArmorBonus");

		for (uint i = 0; i < 5; i++)
			for (uint ii = 0; ii < __RATFD_THEME_COUNT__; ii++)
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
		if (!ratfd_Common.Customizer())
			return;

		PlayerInfo p = Players[playerNumber];

		let cgt = ratfd_Common.ChaingunTheme(p.MO);

		if (cgt == int.MAX)
			return; // Probably in a TITLEMAP.

		let iClip = Ammo(FindOrGive(p.MO, 'Clip'));
		let iShell = Ammo(FindOrGive(p.MO, 'Shell'));
		let iRocket = Ammo(FindOrGive(p.MO, 'RocketAmmo'));
		let iCell = Ammo(FindOrGive(p.MO, 'Cell'));

		let clip_tn = ratfd_Common.BULLET_TYPES[cgt];
		let shell_tn1 = ratfd_Common.SHELL_TYPES[ratfd_Common.ShotgunTheme(p.MO)];
		let shell_tn2 = ratfd_Common.SHELL_TYPES[ratfd_Common.SuperShotgunTheme(p.MO)];
		let rocket_tn = ratfd_Common.ROCKETAMMO_TYPES[ratfd_Common.RocketLauncherTheme(p.MO)];
		let cell_tn = ratfd_Common.CELL_TYPES[ratfd_Common.PlasmaRifleTheme(p.MO)];

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
			PlayerPresence[0][ratfd_Common.ChaingunTheme(pawn)] = 0;
			PlayerPresence[1][ratfd_Common.SuperShotgunTheme(pawn)] = 0;
			PlayerPresence[2][ratfd_Common.RocketLauncherTheme(pawn)] = 0;
			PlayerPresence[3][ratfd_Common.PlasmaRifleTheme(pawn)] = 0;
			PlayerPresence[4][ratfd_Common.BFGTheme(pawn)] = 0;
		}

		FixFDCAmmoCapacities(event.PlayerNumber);
	}

	final override void PlayerEntered(PlayerEvent event)
	{
		FixFDCAmmoCapacities(event.PlayerNumber);
	}

	/// Use this event instead of `replaces` qualifiers,
	/// since it seems to be more reliable.
	final override void CheckReplacement(ReplaceEvent event)
	{
		let tn = self.replaceMap.At(event.replacee.GetClassName());

		if (tn.Length() != 0)
			event.replacement = (class<Actor>)(tn);
	}

	// Non-Customizer players have an ACS script that tracks if any of them are
	// present for the purposes of spawning item visuals conditionally.
	// The Customizer offers no such facility, so we do it ourselves.
	// Any given value is either 256 or 0.
	// Remember that this targets a ZS version below 3.7.2 so array accesses
	// are dimensionally backwards.
	private int PlayerPresence[__RATFD_THEME_COUNT__][5];

	int ClipVisualSpawnFailChance(ratfd_Theme theme) const
	{
		return PlayerPresence[0][theme];
	}

	int ShellVisualSpawnFailChance(ratfd_Theme theme) const
	{
		return PlayerPresence[1][theme];
	}

	int RocketAmmoVisualSpawnFailChance(ratfd_Theme theme) const
	{
		return PlayerPresence[2][theme];
	}

	int CellVisualSpawnFailChance(ratfd_Theme theme) const
	{
		return PlayerPresence[3][theme];
	}

	int BFGAmmoVisualSpawnFailChance(ratfd_Theme theme) const
	{
		return PlayerPresence[4][theme];
	}

	static clearscope ratfd_EventHandler Get()
	{
		return ratfd_EventHandler(EventHandler.Find('ratfd_EventHandler'));
	}
}
