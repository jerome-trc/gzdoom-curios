class RLNL_EventHandler : EventHandler
{
	private RLNL_Global Globals;
	private uint DangerLevel;

	final override void OnRegister()
	{
		if (Globals == null)
			Globals = RLNL_Global.Get();
	}

	final override void NewGame()
	{
		Globals = RLNL_Global.Create();
	}

	final override void WorldUnloaded(WorldEvent event)
	{
		let iter = ThinkerIterator.Create('Inventory');

		Inventory item = null;

		while (item = Inventory(iter.Next()))
		{
			if (item.Owner == null)
				continue;

			if (item is 'RLDangerLevel' ||
				item is 'RLUniqueBossLevel' ||
				item is 'RLDemonArtifactItem')
				continue;

			item.Amount = 0;
			item.DepleteOrDestroy();
		}

		for (uint i = 0; i < MAXPLAYERS; i++)
		{
			if (!PlayerInGame[i])
				continue;

			let pawn = Players[i].MO;

			pawn.ACS_NamedExecuteAlways("DRLA_ClearBackpack");
			pawn.GiveDefaultInventory();
			pawn.Health = Players[i].Health = pawn.Default.Health;

			for (Inventory it = pawn.Inv; it != null; it = it.Inv)
				if (it is 'RLWeapon')
					Players[i].ReadyWeapon = Players[i].PendingWeapon = Weapon(it);
		}
	}

	final override void WorldLoaded(WorldEvent event)
	{
		for (int i = 0; i < MAXPLAYERS; i++)
		{
			if (!PlayerInGame[i])
				continue;

			name danger_t = 'RLDangerLevel';
			let pawn = Players[i].MO;

			if (pawn.CountInv(danger_t) <= 0)
				danger_t = 'RLUniqueBossLevel';

			DangerLevel = Max(DangerLevel, pawn.CountInv(danger_t));

			// If this player has eschewed all other class bonuses while also
			// running Nomadic Lifestyle, they deserve a little extra
			if (pawn is 'DoomRLNomad')
				DangerLevel++;
		}
	}

	final override void WorldThingSpawned(WorldEvent event)
	{
		let item = Inventory(event.Thing);

		if (item == null)
			return;

		let chances = DangerLevel / 2;

		for (uint i = 0; i < chances; i++)
		{
			if (IsLargeAmmoPickup(item.GetClass()))
			{
				if (Random[RLNL](1, 6) != 6)
					continue;

				Actor.Spawn('RLModPackSpawner', item.Pos);
			}
			else if (item is 'RLWeapon' && IsCommonWeapon(item.GetClass()))
			{
				if (Level.MapTime > 5)
					return;

				let r = Random[RLNL](0, 150);
				class<Actor> spawner_t = null;

				if (r == 0)
					spawner_t = 'RLSuperWeaponSpawner';
				else if (r == 1)
					spawner_t = 'RLUniqueWeaponSpawner';
				else if (r == 2 || r == 3)
					spawner_t = 'RLSuperiorWeaponSpawner';
				else if (r < 7)
					spawner_t = 'RLAssembledWeaponSpawner';
				else if (r < 15)
					spawner_t = 'RLExoticWeaponSpawner';
				else
					continue;

				RLNL_WanderingSpawner.Create(item.Pos, spawner_t, 10);
			}
			else if (item is 'RLBackpack')
			{
				let loot = Globals.BackpackLoot.Result();

				if (loot == null)
					continue;

				Actor.Spawn((class<Actor>)(loot), item.Pos);
				item.Destroy();
			}
			else if (IsBasicArmor(item.GetClass()))
			{
				let loot = (class<Inventory>)(Globals.ArmorLoot.Result());

				if (loot == null)
					continue;

				Actor.Spawn(loot, item.Pos);
				item.Destroy();
			}
			else if (IsBasicBoots(item.GetClass()))
			{
				let loot = (class<Inventory>)(Globals.BootsLoot.Result());

				if (loot == null)
					continue;

				Actor.Spawn(loot, item.Pos);
				item.Destroy();
			}
		}
	}

	private static bool IsLargeAmmoPickup(class<Inventory> item_t)
	{
		static const name CLASSES[] = {
			'RLClipBoxSpawner',
			'RLShellBoxSpawner',
			'RLRocketBoxSpawner',
			'RLCellPackSpawner'
		};

		for (uint i = 0; i < CLASSES.Size(); i++)
			if (item_t is CLASSES[i])
				return true;

		return false;
	}

	private static bool IsCommonWeapon(class<Inventory> item_t)
	{
		static const name CLASSES[] = {
			'RLPistolPickup',
			'RLShotgunPickup',
			'RLCombatShotgunPickup',
			'RLChaingunPickup',
			'RLRocketLauncherPickup',
			'RLPlasmaRiflePickup',
			'RLBFG9000Pickup'
		};

		for (uint i = 0; i < CLASSES.Size(); i++)
			if (item_t is CLASSES[i])
				return true;

		return false;
	}

	private static bool IsBasicArmor(class<Inventory> item_t)
	{
		static const name CLASSES[] = {
			'RLGreenArmorPickup',
			'RLBlueArmorPickup',
			'RLRedArmorPickup'
		};

		for (uint i = 0; i < CLASSES.Size(); i++)
			if (item_t is CLASSES[i])
				return true;

		return false;
	}

	private static bool IsBasicBoots(class<Inventory> item_t)
	{
		static const name CLASSES[] = {
			'RLSteelBootsPickup',
			'RLProtectiveBootsPickup',
			'RLPlasteelBootsPickup'
		};

		for (uint i = 0; i < CLASSES.Size(); i++)
			if (item_t is CLASSES[i])
				return true;

		return false;
	}
}
