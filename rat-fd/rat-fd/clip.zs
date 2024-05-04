class ratfd_ClipPickup : ratfd_AmmoPickup abstract
{
	Default
	{
		ratfd_AmmoPickup.PickupSoundTemplate "items/%sbullet%s";
		ratfd_AmmoPickup.BFGAmmoMulti 20;
	}

	final override bool CanPickup(Actor toucher)
	{
		if (!super.CanPickup(toucher))
			return false;

		let pawn = PlayerPawn(toucher);

		if (ForbidWaste(pawn))
			return ratfd_Common.HasFreeBulletCapacity(pawn, CalcGiveAmount(pawn));
		else
			return !ratfd_Common.BulletsFull(PlayerPawn(toucher));
	}

	final override class<Inventory> GivenAmmoType(PlayerPawn pawn) const
	{
		return ratfd_Common.BulletType(pawn);
	}

	final override ratfd_Theme RelevantTheme(PlayerPawn pawn) const
	{
		return ratfd_Common.ChaingunTheme(pawn);
	}
}

mixin class ratfd_ClipPickupImpl
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
					failChance: handler.ClipVisualSpawnFailChance(i)
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

class ratfd_Clip_ZS : ratfd_ClipPickup
{
	mixin ratfd_AmmoPickupImpl;
	mixin ratfd_ClipPickupImpl;

	static const name VISUAL_PICKUPS[] = {
		'FDClipPickupVisualPlutonia',
		'FDClipPickupVisualTNT',
		'FDClipPickupVisualDoom2',
		'FDClipPickupVisualAliens',
		'FDClipPickupVisualJPCP',
		'FDClipPickupVisualBTSX',
		'FDClipPickupVisualHellbound',
		'FDClipPickupVisualAlienVendetta',
		'FDClipPickupVisualWhitemare'
	};

	static const name VISUAL_PICKUPS_CUSTOMIZER[] = {
		'FDCClipPickupVisualPlutonia',
		'FDCClipPickupVisualTNT',
		'FDCClipPickupVisualDoom2',
		'FDCClipPickupVisualAliens',
		'FDCClipPickupVisualJPCP',
		'FDCClipPickupVisualBTSX',
		'FDCClipPickupVisualHellbound',
		'FDCClipPickupVisualAlienVendetta',
		'FDCClipPickupVisualWhitemare'
	};

	static const uint GIVE_AMOUNTS[] = {
		15,
		25,
		10,
		15,
		5,
		10,
		10,
		18,
		15
	};

	static const string PICKUP_MESSAGES[] = {
		"You picked up a machinegun magazine.",
		"You picked up a machine pistol mag.",
		"You picked up a chaingun mag.",
		"You picked up an AK mag.",
		"You picked up some purifying needles.",
		"You picked up a pulsepack.",
		"You picked up an AP bullet mag.",
		"You picked up a tornado mag.",
		"You picked up some gatling ammo."
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
		DBUL A -1;
		Loop;
	Spawn.Fancy:
		GBUL A -1 Bright;
		Loop;
	}
}

class ratfd_ClipBox_ZS : ratfd_ClipPickup
{
	mixin ratfd_AmmoPickupImpl;
	mixin ratfd_ClipPickupImpl;

	static const name VISUAL_PICKUPS[] = {
		'FDClipBoxPickupVisualPlutonia',
		'FDClipBoxPickupVisualTNT',
		'FDClipBoxPickupVisualDoom2',
		'FDClipBoxPickupVisualAliens',
		'FDClipBoxPickupVisualJPCP',
		'FDClipBoxPickupVisualBTSX',
		'FDClipBoxPickupVisualHellbound',
		'FDClipBoxPickupVisualAlienVendetta',
		'FDClipBoxPickupVisualWhitemare'
	};

	static const name VISUAL_PICKUPS_CUSTOMIZER[] = {
		'FDCClipBoxPickupVisualPlutonia',
		'FDCClipBoxPickupVisualTNT',
		'FDCClipBoxPickupVisualDoom2',
		'FDCClipBoxPickupVisualAliens',
		'FDCClipBoxPickupVisualJPCP',
		'FDCClipBoxPickupVisualBTSX',
		'FDCClipBoxPickupVisualHellbound',
		'FDCClipBoxPickupVisualAlienVendetta',
		'FDCClipBoxPickupVisualWhitemare'
	};

	static const uint GIVE_AMOUNTS[] = {
		50,
		100,
		40,
		50,
		30,
		40,
		25,
		70,
		50
	};

	static const string PICKUP_MESSAGES[] = {
		"You picked up a box of bullets.",
		"You picked up a box of tech-bullets.",
		"You picked up a box of bullets.",
		"You picked up a box of bullets.",
		"You picked up a cartridge of purifying needles.",
		"You picked up a big pulsepack.",
		"You picked up a box of AP bullets.",
		"You picked up a double drum of bullets.",
		"You picked up a box of gatling ammo."
	};

	static const string PICKUP_MESSAGES_PARTIAL[] = {
		"You opened a box of bullets.",
		"You opened a box of tech-bullets.",
		"You opened a box of bullets.",
		"You opened a box of bullets.",
		"You opened a cartridge of purifying needles.",
		"You opened a big pulsepack.",
		"You opened a box of AP bullets.",
		"You opened a double drum of bullets.",
		"You opened a box of gatling ammo."
	};

	Default
	{
		ratfd_AmmoPickup.BFGAmmoPickups 'FDBFGAmmoPickup', 2;
		ratfd_AmmoPickup.SmallCounterpart 'ratfd_Clip_ZS';
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
		DBUL B -1;
		Loop;
	Spawn.Fancy:
		GBUL B -1 Bright;
		Loop;
	}
}
