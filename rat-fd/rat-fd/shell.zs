class ratfd_ShellPickup : ratfd_AmmoPickup abstract
{
	Default
	{
		ratfd_AmmoPickup.PickupSoundTemplate "items/%sshell%s";
		ratfd_AmmoPickup.BFGAmmoMulti 25;
	}

	final override bool CanPickup(Actor toucher)
	{
		if (!super.CanPickup(toucher))
			return false;

		let pawn = PlayerPawn(toucher);

		if (ForbidWaste(pawn))
			return ratfd_Common.HasFreeShellCapacity(pawn, CalcGiveAmount(pawn));
		else
			return !ratfd_Common.ShellsFull(PlayerPawn(toucher));
	}

	final override class<Inventory> GivenAmmoType(PlayerPawn pawn) const
	{
		return ratfd_Common.ShellType(pawn);
	}
}

mixin class ratfd_ShellPickupImpl
{
	private action void A_ratfd_SpawnPickupVisuals(bool dynamic)
	{
		if (ratfd_Common.Customizer())
		{
			let handler = ratfd_EventHandler.Get();

			for (uint i = 0; i < invoker.VISUAL_PICKUPS_CUSTOMIZER.Size(); i++)
			{
				A_SpawnItemEx(
					invoker.VISUAL_PICKUPS_CUSTOMIZER[i],
					flags: SXF_SETMASTER,
					failChance: handler.ShellVisualSpawnFailChance(i)
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

class ratfd_Shell_ZS : ratfd_ShellPickup
{
	mixin ratfd_AmmoPickupImpl;
	mixin ratfd_ShellPickupImpl;

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

	static const name VISUAL_PICKUPS_CUSTOMIZER[] = {
		'FDCShellPickupVisualPlutonia',
		'FDCShellPickupVisualTNT',
		'FDCShellPickupVisualDoom2',
		'FDCShellPickupVisualAliens',
		'FDCShellPickupVisualJPCP',
		'FDCShellPickupVisualBTSX',
		'FDCShellPickupVisualHellbound',
		'FDCShellPickupVisualAlienVendetta',
		'FDCShellPickupVisualWhitemare'
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
		TNT1 A 0 A_ratfd_AmmoSpawn;
		Goto Spawn.Visuals;
	Spawn.Visuals:
		TNT1 A 0 A_ratfd_SpawnPickupVisuals(false);
		TNT1 A -1;
		Stop;
	Spawn.Dynamic:
		TNT1 A 1;
		TNT1 A 0 A_ratfd_SpawnPickupVisuals(true);
		TNT1 A -1;
		Stop;
	Spawn.Generic:
		DSHE A -1;
		Loop;
	Spawn.Fancy:
		GSHE A -1 Bright;
		Loop;
	}

	final override ratfd_Theme RelevantTheme(PlayerPawn pawn) const
	{
		return ratfd_Common.ShotgunTheme(pawn);
	}
}

class ratfd_ShellBox_ZS : ratfd_ShellPickup
{
	mixin ratfd_AmmoPickupImpl;
	mixin ratfd_ShellPickupImpl;

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

	static const name VISUAL_PICKUPS_CUSTOMIZER[] = {
		'FDCShellBoxPickupVisualPlutonia',
		'FDCShellBoxPickupVisualTNT',
		'FDCShellBoxPickupVisualDoom2',
		'FDCShellBoxPickupVisualAliens',
		'FDCShellBoxPickupVisualJPCP',
		'FDCShellBoxPickupVisualBTSX',
		'FDCShellBoxPickupVisualHellbound',
		'FDCShellBoxPickupVisualAlienVendetta',
		'FDCShellBoxPickupVisualWhitemare'
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
		ratfd_AmmoPickup.BFGAmmoPickups 'FDBFGAmmoPickupBig', 1;
		ratfd_AmmoPickup.SmallCounterpart 'ratfd_Shell_ZS';
	}

	States
	{
	Spawn:
		TNT1 A 0;
		TNT1 A 0 A_ratfd_AmmoSpawn;
		Goto Spawn.Visuals;
	Spawn.Visuals:
		TNT1 A 0 A_ratfd_SpawnPickupVisuals(false);
		TNT1 A -1;
		Stop;
	Spawn.Dynamic:
		TNT1 A 1;
		TNT1 A 0 A_ratfd_SpawnPickupVisuals(true);
		TNT1 A -1;
		Stop;
	Spawn.Generic:
		DSHE B -1;
		Loop;
	Spawn.Fancy:
		GSHE B -1 Bright;
		Loop;
	}

	final override ratfd_Theme RelevantTheme(PlayerPawn pawn) const
	{
		return ratfd_Common.SuperShotgunTheme(pawn);
	}
}
