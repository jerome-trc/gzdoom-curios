class FDX_BFGPickupBase : FDX_AmmoPickup abstract
{
	final override bool CanPickup(Actor toucher)
	{
		if (!super.CanPickup(toucher))
			return false;

		let pawn = PlayerPawn(toucher);

		if (ForbidWaste(pawn))
			return FDX_Common.HasFreeBFGCapacity(pawn, CalcGiveAmount(pawn));
		else
			return !FDX_Common.BFGFull(PlayerPawn(toucher));
	}

	final override class<Inventory> GivenAmmoType(PlayerPawn pawn) const
	{
		return 'FDBFGAmmoPickupCounter';
	}

	final override FDX_Theme RelevantTheme(PlayerPawn pawn) const
	{
		return FDX_Common.BFGTheme(pawn);
	}
}

mixin class FDX_BFGAmmoPickupImpl
{
	private action void A_FDX_SpawnPickupVisuals(bool dynamic)
	{
		if (FDX_Common.Customizer())
		{
			let handler = FDX_EventHandler.Get();

			for (uint i = 0; i < invoker.VISUAL_PICKUPS_CUSTOMIZER.Size(); i++)
			{
				A_SpawnItemEx(
					invoker.VISUAL_PICKUPS_CUSTOMIZER[i],
					flags: SXF_SETMASTER,
					failChance: handler.BFGAmmoVisualSpawnFailChance(i)
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

class FDX_BFGPickup_ZS : FDX_BFGPickupBase
{
	mixin FDX_AmmoPickupImpl;
	mixin FDX_BFGAmmoPickupImpl;

	static const name VISUAL_PICKUPS[] = {
		'FDBFGAmmoPickupVisualPlutonia',
		'FDBFGAmmoPickupVisualTNT',
		'FDBFGAmmoPickupVisualDoom2',
		'FDBFGAmmoPickupVisualAliens',
		'FDBFGAmmoPickupVisualJPCP',
		'FDBFGAmmoPickupVisualBTSX',
		'FDBFGAmmoPickupVisualHellbound',
		'FDBFGAmmoPickupVisualAlienVendetta',
		'FDBFGAmmoPickupVisualWhitemare'
	};

	static const name VISUAL_PICKUPS_CUSTOMIZER[] = {
		'FDCBFGAmmoPickupVisualPlutonia',
		'FDCBFGAmmoPickupVisualTNT',
		'FDCBFGAmmoPickupVisualDoom2',
		'FDCBFGAmmoPickupVisualAliens',
		'FDCBFGAmmoPickupVisualJPCP',
		'FDCBFGAmmoPickupVisualBTSX',
		'FDCBFGAmmoPickupVisualHellbound',
		'FDCBFGAmmoPickupVisualAlienVendetta',
		'FDCBFGAmmoPickupVisualWhitemare'
	};

	static const uint GIVE_AMOUNTS[] = {
		10,
		10,
		10,
		10,
		10,
		10,
		10,
		10,
		10
	};

	static const string PICKUP_MESSAGES[] = {
		"You picked up a quantum battery.",
		"You picked up an annihilator cell.",
		"You picked up a BFG power cell.",
		"You picked up a strange power source.",
		"You picked up a devastator pack.",
		"You picked up an X-Spark cell.",
		"You picked up some Totenheim materials.",
		"You picked up a Vendetta cell.",
		"You picked up a solar powercore."
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
		DBFA A -1;
		Loop;
	Spawn.Fancy:
		GBFA A -1 Bright;
		Loop;
	}
}

class FDX_BFGPickupBig_ZS : FDX_BFGPickupBase
{
	mixin FDX_AmmoPickupImpl;
	mixin FDX_BFGAmmoPickupImpl;

	static const name VISUAL_PICKUPS[] = {
		'FDBFGAmmoPickupBigVisualPlutonia',
		'FDBFGAmmoPickupBigVisualTNT',
		'FDBFGAmmoPickupBigVisualDoom2',
		'FDBFGAmmoPickupBigVisualAliens',
		'FDBFGAmmoPickupBigVisualJPCP',
		'FDBFGAmmoPickupBigVisualBTSX',
		'FDBFGAmmoPickupBigVisualHellbound',
		'FDBFGAmmoPickupBigVisualAlienVendetta',
		'FDBFGAmmoPickupBigVisualWhitemare'
	};

	static const name VISUAL_PICKUPS_CUSTOMIZER[] = {
		'FDCBFGAmmoPickupBigVisualPlutonia',
		'FDCBFGAmmoPickupBigVisualTNT',
		'FDCBFGAmmoPickupBigVisualDoom2',
		'FDCBFGAmmoPickupBigVisualAliens',
		'FDCBFGAmmoPickupBigVisualJPCP',
		'FDCBFGAmmoPickupBigVisualBTSX',
		'FDCBFGAmmoPickupBigVisualHellbound',
		'FDCBFGAmmoPickupBigVisualAlienVendetta',
		'FDCBFGAmmoPickupBigVisualWhitemare'
	};

	static const uint GIVE_AMOUNTS[] = {
		25,
		25,
		25,
		25,
		25,
		25,
		25,
		25,
		25
	};

	static const string PICKUP_MESSAGES[] = {
		"You picked up a big quantum battery.",
		"You picked up a heavy annihilator cell.",
		"You picked up a large BFG cell.",
		"You picked up a large alien power source.",
		"You picked up a big devastator pack.",
		"You picked up a large X-Spark cell.",
		"You picked up a large box of Totenheim materials.",
		"You picked up a large Vendetta cell.",
		"You picked up some solar fuel rods."
	};

	static const string PICKUP_MESSAGES_PARTIAL[] = {
		"You partially drained a big quantum battery.",
		"You partially drained a heavy annihilator cell.",
		"You partially drained a large BFG cell.",
		"You partially drained a large alien power source.",
		"You partially drained a big devastator pack.",
		"You partially drained a large X-Spark cell.",
		"You picked up part of a large box of Totenheim materials.",
		"You partially drained a large Vendetta cell.",
		"You picked up part of a set of solar fuel rods."
	};

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
		DBFA A -1;
		Loop;
	Spawn.Fancy:
		GBFA A -1 Bright;
		Loop;
	}
}
