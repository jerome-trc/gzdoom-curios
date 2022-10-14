class FDX_RocketAmmoPickup : FDX_AmmoPickup abstract
{
	Default
	{
		FDX_AmmoPickup.PickupSoundTemplate "items/%srocket%s";
		FDX_AmmoPickup.BFGAmmoMulti 40;
	}

	final override bool CanPickup(Actor toucher)
	{
		if (!super.CanPickup(toucher))
			return false;

		let pawn = PlayerPawn(toucher);

		if (ForbidWaste(pawn))
			return FDX_Common.HasFreeRocketAmmoCapacity(pawn, CalcGiveAmount(pawn));
		else
			return !FDX_Common.RocketAmmoFull(PlayerPawn(toucher));
	}

	final override class<Inventory> GivenAmmoType(PlayerPawn pawn) const
	{
		return FDX_Common.RocketAmmoType(pawn);
	}
}

class FDX_RocketAmmo_ZS : FDX_RocketAmmoPickup
{
	mixin FDX_AmmoPickupImpl;

	static const name VISUAL_PICKUPS[] = {
		'FDRocketPickupVisualPlutonia',
		'FDRocketPickupVisualTNT',
		'FDRocketPickupVisualDoom2',
		'FDRocketPickupVisualAliens',
		'FDRocketPickupVisualJPCP',
		'FDRocketPickupVisualBTSX',
		'FDRocketPickupVisualHellbound',
		'FDRocketPickupVisualAlienVendetta',
		'FDRocketPickupVisualWhitemare'
	};

	static const uint GIVE_AMOUNTS[] = {
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		3,
		5
	};

	static const string PICKUP_MESSAGES[] = {
		"You picked up a grenade.",
		"You picked up a missile.",
		"You picked up a rocket.",
		"You picked up a photon charge.",
		"You picked up a prism canister.",
		"You picked up a heavy pulsepack.",
		"You picked up a C4 canister.",
		"You picked up a set of mini-missiles.",
		"You drained a small firegrasp fuel cell."
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
		DRKT A -1;
		Loop;
	Spawn.Fancy:
		GRKT A -1 Bright;
		Loop;
	}
}

class FDX_RocketBox_ZS : FDX_RocketAmmoPickup
{
	mixin FDX_AmmoPickupImpl;

	static const name VISUAL_PICKUPS[] = {
		'FDRocketBoxPickupVisualPlutonia',
		'FDRocketBoxPickupVisualTNT',
		'FDRocketBoxPickupVisualDoom2',
		'FDRocketBoxPickupVisualAliens',
		'FDRocketBoxPickupVisualJPCP',
		'FDRocketBoxPickupVisualBTSX',
		'FDRocketBoxPickupVisualHellbound',
		'FDRocketBoxPickupVisualAlienVendetta',
		'FDRocketBoxPickupVisualWhitemare'
	};

	static const uint GIVE_AMOUNTS[] = {
		3,
		5,
		5,
		5,
		4,
		5,
		3,
		15,
		25
	};

	static const string PICKUP_MESSAGES[] = {
		"You emptied a crate of grenads.",
		"You emptied a missile crate.",
		"You emptied a crate of rockets.",
		"You emptied a case of photon charges.",
		"You picked up a prism multi-canister.",
		"You drained a crate of heavy pulse energy.",
		"You emptied a box of C4.",
		"You emptied a crate of mini-missiles.",
		"You drained a container of firegrasp fuel."
	};

	static const string PICKUP_MESSAGES_PARTIAL[] = {
		"You partially emptied a crate of grenads.",
		"You partially emptied a missile crate.",
		"You partially emptied a crate of rockets.",
		"You partially emptied a case of photon charges.",
		"You picked up part of a prism multi-canister.",
		"You partially drained a crate of heavy pulse energy.",
		"You partially emptied a box of C4.",
		"You partially emptied a crate of mini-missiles.",
		"You partially drained a container of firegrasp fuel."
	};

	Default
	{
		FDX_AmmoPickup.BFGAmmoPickups 'FDBFGAmmoPickup', 4;
		FDX_AmmoPickup.SmallCounterpart 'FDX_RocketAmmo_ZS';
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
		DRKT B -1;
		Loop;
	Spawn.Fancy:
		GRKT B -1 Bright;
		Loop;
	}
}
