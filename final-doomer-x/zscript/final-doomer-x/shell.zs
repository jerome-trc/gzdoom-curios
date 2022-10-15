class FDX_ShellPickup : FDX_AmmoPickup abstract
{
	Default
	{
		FDX_AmmoPickup.PickupSoundTemplate "items/%sshell%s";
		FDX_AmmoPickup.BFGAmmoMulti 25;
	}

	final override bool CanPickup(Actor toucher)
	{
		if (!super.CanPickup(toucher))
			return false;

		let pawn = PlayerPawn(toucher);

		if (ForbidWaste(pawn))
			return FDX_Common.HasFreeShellCapacity(pawn, CalcGiveAmount(pawn));
		else
			return !FDX_Common.ShellsFull(PlayerPawn(toucher));
	}

	final override class<Inventory> GivenAmmoType(PlayerPawn pawn) const
	{
		return FDX_Common.ShellType(pawn);
	}
}

class FDX_Shell_ZS : FDX_ShellPickup
{
	mixin FDX_AmmoPickupImpl;

	static const name VISUAL_PICKUPS[] = {
		'FDShellPickupVisualPlutonia',
		'FDShellPickupVisualTNT',
		'FDShellPickupVisualDoom2',
		'FDShellPickupVisualAliens',
		'FDShellPickupVisualJPCP',
		'FDShellPickupVisualBTSX',
		'FDShellPickupVisualHellbound',
		'FDShellPickupVisualAlienVendetta',
		'FDShellPickupVisualWhitemare'
	};

	static const uint GIVE_AMOUNTS[] = {
		4,
		6,
		4,
		4,
		4,
		4,
		4,
		4,
		4
	};

	static const string PICKUP_MESSAGES[] = {
		"You picked up some shotgun shells.",
		"You picked up some scattershot rounds.",
		"You picked up some shotgun shells.",
		"You picked up some shotgun shells.",
		"You picked up a neutron charge.",
		"You picked up some E-charges.",
		"You picked up some 8-gauge shells.",
		"You picked up a pack of shotgun shells.",
		"You picked up some dragon's breath shells."
	};

	// Small pickups can't be split; this is just to satisfy a mixin
	static const string PICKUP_MESSAGES_PARTIAL[] = { "" };

	States
	{
	Spawn:
		TNT1 A 0;
		TNT1 A 0 A_FDX_AmmoSpawn;
		Goto Spawn.Visuals;
	Spawn.Visuals:
		TNT1 A 0 A_FDX_SpawnPickupVisuals(false);
		TNT1 A -1;
		Stop;
	Spawn.Dynamic:
		TNT1 A 1;
		TNT1 A 0 A_FDX_SpawnPickupVisuals(true);
		TNT1 A -1;
		Stop;
	Spawn.Generic:
		DSHE A -1;
		Loop;
	Spawn.Fancy:
		GSHE A -1 Bright;
		Loop;
	}

	final override FDX_Theme RelevantTheme(PlayerPawn pawn) const
	{
		return FDX_Common.ShotgunTheme(pawn);
	}
}

class FDX_ShellBox_ZS : FDX_ShellPickup
{
	mixin FDX_AmmoPickupImpl;

	static const name VISUAL_PICKUPS[] = {
		'FDShellBoxPickupVisualPlutonia',
		'FDShellBoxPickupVisualTNT',
		'FDShellBoxPickupVisualDoom2',
		'FDShellBoxPickupVisualAliens',
		'FDShellBoxPickupVisualJPCP',
		'FDShellBoxPickupVisualBTSX',
		'FDShellBoxPickupVisualHellbound',
		'FDShellBoxPickupVisualAlienVendetta',
		'FDShellBoxPickupVisualWhitemare'
	};

	static const uint GIVE_AMOUNTS[] = {
		20,
		30,
		20,
		20,
		20,
		20,
		20,
		20,
		20
	};

	static const string PICKUP_MESSAGES[] = {
		"You picked up a box of shotgun shells.",
		"You picked up a pack of scattershots.",
		"You picked up a box of shotgun shells.",
		"You picked up a box of shotgun shells.",
		"You picked up a set of neutron charges.",
		"You picked up a box of E-charges.",
		"You picked up a box of 8-gauge shells.",
		"You picked up a canister of shotgun shells.",
		"You picked up a box of dragon's breath shells."
	};

	static const string PICKUP_MESSAGES_PARTIAL[] = {
		"You opened a box of shotgun shells.",
		"You opened a pack of scattershots.",
		"You opened a box of shotgun shells.",
		"You opened a box of shotgun shells.",
		"You opened a set of neutron charges.",
		"You opened a box of E-charges.",
		"You opened a box of 8-gauge shells.",
		"You opened a canister of shotgun shells.",
		"You opened a box of dragon's breath shells."
	};

	Default
	{
		FDX_AmmoPickup.BFGAmmoPickups 'FDBFGAmmoPickupBig', 1;
		FDX_AmmoPickup.SmallCounterpart 'FDX_Shell_ZS';
	}

	States
	{
	Spawn:
		TNT1 A 0;
		TNT1 A 0 A_FDX_AmmoSpawn;
		Goto Spawn.Visuals;
	Spawn.Visuals:
		TNT1 A 0 A_FDX_SpawnPickupVisuals(false);
		TNT1 A -1;
		Stop;
	Spawn.Dynamic:
		TNT1 A 1;
		TNT1 A 0 A_FDX_SpawnPickupVisuals(true);
		TNT1 A -1;
		Stop;
	Spawn.Generic:
		DSHE B -1;
		Loop;
	Spawn.Fancy:
		GSHE B -1 Bright;
		Loop;
	}

	final override FDX_Theme RelevantTheme(PlayerPawn pawn) const
	{
		return FDX_Common.SuperShotgunTheme(pawn);
	}
}
