class FDPP_CellPickup : FDPP_AmmoPickup abstract
{
	Default
	{
		FDPP_AmmoPickup.PickupSoundTemplate "items/%scell%s";
		FDPP_AmmoPickup.BFGAmmoMulti 50;
	}

	final override bool CanPickup(Actor toucher)
	{
		if (!super.CanPickup(toucher))
			return false;

		let pawn = PlayerPawn(toucher);

		if (ForbidWaste(pawn))
			return FDPP_Common.HasFreeCellCapacity(pawn, CalcGiveAmount(pawn));
		else
			return !FDPP_Common.CellsFull(PlayerPawn(toucher));
	}

	final override class<Inventory> GivenAmmoType(PlayerPawn pawn) const
	{
		return FDPP_Common.CellType(pawn);
	}

	final override FDPP_Theme RelevantTheme(PlayerPawn pawn) const
	{
		return FDPP_Common.PlasmaRifleTheme(pawn);
	}	
}

mixin class FDPP_CellPickupImpl
{
	private action void A_FDPP_SpawnPickupVisuals(bool dynamic)
	{
		if (FDPP_Common.Customizer())
		{
			let handler = FDPP_EventHandler.Get();

			for (uint i = 0; i < invoker.VISUAL_PICKUPS_CUSTOMIZER.Size(); i++)
			{
				A_SpawnItemEx(
					invoker.VISUAL_PICKUPS_CUSTOMIZER[i],
					flags: SXF_SETMASTER,
					failChance: handler.CellVisualSpawnFailChance(i)
				);
			}
		}
		else
		{
			for (uint i = 0; i < invoker.VISUAL_PICKUPS.Size(); i++)
			{
				A_SpawnItemEx(
					invoker.VISUAL_PICKUPS[i],
					flags: SXF_SETMASTER,
					failChance: (dynamic ? CallACS("FDPlayerIn", i) : 0)
				);
			}
		}
	}
}

class FDPP_Cell_ZS : FDPP_CellPickup
{
	mixin FDPP_AmmoPickupImpl;
	mixin FDPP_CellPickupImpl;

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

	static const name VISUAL_PICKUPS_CUSTOMIZER[] = {
		'FDCCellPickupVisualPlutonia',
		'FDCCellPickupVisualTNT',
		'FDCCellPickupVisualDoom2',
		'FDCCellPickupVisualAliens',
		'FDCCellPickupVisualJPCP',
		'FDCCellPickupVisualBTSX',
		'FDCCellPickupVisualHellbound',
		'FDCCellPickupVisualAlienVendetta',
		'FDCCellPickupVisualWhitemare'
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
		FDPP_AmmoPickup.BFGAmmoPickups 'FDBFGAmmoPickup', 2;
	}

	States
	{
	Spawn:
		TNT1 A 0;
		TNT1 A 0 A_FDPP_AmmoSpawn;
		Goto Spawn.Visuals;
	Spawn.Visuals:
		TNT1 A 0 A_FDPP_SpawnPickupVisuals(false);
		TNT1 A -1;
		Stop;
	Spawn.Dynamic:
		TNT1 A 1;
		TNT1 A 0 A_FDPP_SpawnPickupVisuals(true);
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

class FDPP_CellPack_ZS :  FDPP_CellPickup
{
	mixin FDPP_AmmoPickupImpl;
	mixin FDPP_CellPickupImpl;

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

	static const name VISUAL_PICKUPS_CUSTOMIZER[] = {
		'FDCCellPackPickupVisualPlutonia',
		'FDCCellPackPickupVisualTNT',
		'FDCCellPackPickupVisualDoom2',
		'FDCCellPackPickupVisualAliens',
		'FDCCellPackPickupVisualJPCP',
		'FDCCellPackPickupVisualBTSX',
		'FDCCellPackPickupVisualHellbound',
		'FDCCellPackPickupVisualAlienVendetta',
		'FDCCellPackPickupVisualWhitemare'
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
		FDPP_AmmoPickup.BFGAmmoPickups 'FDBFGAmmoPickupBig', 2;
		FDPP_AmmoPickup.SmallCounterpart 'FDPP_Cell_ZS';
	}

	States
	{
	Spawn:
		TNT1 A 0;
		TNT1 A 0 A_FDPP_AmmoSpawn;
		Goto Spawn.Visuals;
	Spawn.Visuals:
		TNT1 A 0 A_FDPP_SpawnPickupVisuals(false);
		TNT1 A -1;
		Stop;
	Spawn.Dynamic:
		TNT1 A 1;
		TNT1 A 0 A_FDPP_SpawnPickupVisuals(true);
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
