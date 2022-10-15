class FDX_CellPickup : FDX_AmmoPickup abstract
{
	Default
	{
		FDX_AmmoPickup.PickupSoundTemplate "items/%scell%s";
		FDX_AmmoPickup.BFGAmmoMulti 50;
	}

	final override bool CanPickup(Actor toucher)
	{
		if (!super.CanPickup(toucher))
			return false;

		let pawn = PlayerPawn(toucher);

		if (ForbidWaste(pawn))
			return FDX_Common.HasFreeCellCapacity(pawn, CalcGiveAmount(pawn));
		else
			return !FDX_Common.CellsFull(PlayerPawn(toucher));
	}

	final override class<Inventory> GivenAmmoType(PlayerPawn pawn) const
	{
		return FDX_Common.CellType(pawn);
	}

	final override FDX_Theme RelevantTheme(PlayerPawn pawn) const
	{
		return FDX_Common.PlasmaRifleTheme(pawn);
	}
}

class FDX_Cell_ZS : FDX_CellPickup
{
	mixin FDX_AmmoPickupImpl;

	static const name VISUAL_PICKUPS[] = {
		'FDCellPickupVisualPlutonia',
		'FDCellPickupVisualTNT',
		'FDCellPickupVisualDoom2',
		'FDCellPickupVisualAliens',
		'FDCellPickupVisualJPCP',
		'FDCellPickupVisualBTSX',
		'FDCellPickupVisualHellbound',
		'FDCellPickupVisualAlienVendetta',
		'FDCellPickupVisualWhitemare'
	};

	static const uint GIVE_AMOUNTS[] = {
		10,
		20,
		20,
		10,
		15,
		50,
		20,
		2,
		30
	};

	static const string PICKUP_MESSAGES[] = {
		"You picked up a small box of high calibre ammo.",
		"You picked up a maser charge.",
		"You picked up a plasma cell.",
		"You picked up an alien powercell.",
		"You picked up a small deck of sealing amulets.",
		"You picked up a plasma coil.",
		"You picked up some minigun ammo.",
		"You picked up a small crystal battery.",
		"You emptied a small fuel tank."
	};

	// Small pickups can't be split; this is just to satisfy a mixin
	static const string PICKUP_MESSAGES_PARTIAL[] = { "" };

	Default
	{
		FDX_AmmoPickup.BFGAmmoPickups 'FDBFGAmmoPickup', 2;
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
		DCEL A -1;
		Loop;
	Spawn.Fancy:
		GCEL A -1 Bright;
		Loop;
	}
}

class FDX_CellPack_ZS :  FDX_CellPickup
{
	mixin FDX_AmmoPickupImpl;

	static const name VISUAL_PICKUPS[] = {
		'FDCellPackPickupVisualPlutonia',
		'FDCellPackPickupVisualTNT',
		'FDCellPackPickupVisualDoom2',
		'FDCellPackPickupVisualAliens',
		'FDCellPackPickupVisualJPCP',
		'FDCellPackPickupVisualBTSX',
		'FDCellPackPickupVisualHellbound',
		'FDCellPackPickupVisualAlienVendetta',
		'FDCellPackPickupVisualWhitemare'
	};

	static const uint GIVE_AMOUNTS[] = {
		40,
		100,
		100,
		50,
		60,
		150,
		100,
		10,
		80
	};

	static const string PICKUP_MESSAGES[] = {
		"You picked up a box of high calibre ammo.",
		"You picked up a bulk maser charge.",
		"You picked up a plasma cell pack.",
		"You picked up an alien power core.",
		"You picked up a big autodeck of sealing amulets.",
		"You picked up a set of plasma coils.",
		"You emptied a crate of minigun ammo.",
		"You picked up a tachyon power crystal.",
		"You emptied a fuel barrel."
	};

	static const string PICKUP_MESSAGES_PARTIAL[] = {
		"You opened a box of high calibre ammo.",
		"You opened a bulk maser charge.",
		"You opened a plasma cell pack.",
		"You opened an alien power core.",
		"You opened a big autodeck of sealing amulets.",
		"You opened a set of plasma coils.",
		"You partially emptied a crate of minigun ammo.",
		"You splintered a tachyon power crystal.",
		"You partially emptied a fuel barrel."
	};

	Default
	{
		FDX_AmmoPickup.BFGAmmoPickups 'FDBFGAmmoPickupBig', 2;
		FDX_AmmoPickup.SmallCounterpart 'FDX_Cell_ZS';
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
		DCEL B -1;
		Loop;
	Spawn.Fancy:
		GCEL B -1 Bright;
		Loop;
	}
}
