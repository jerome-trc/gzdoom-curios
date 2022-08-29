enum RLLV_Rarity
{
	RLLV_RARITY_NONE,
	RLLV_RARITY_STANDARD,
	RLLV_RARITY_EXOTIC,
	RLLV_RARITY_SUPERIOR,
	RLLV_RARITY_BASIC,
	RLLV_RARITY_ADVANCED,
	RLLV_RARITY_MASTER,
	RLLV_RARITY_UNIQUE,
	RLLV_RARITY_LEGENDARY,
	RLLV_RARITY_DEMONIC
}

struct RLLV_Utils
{
	static uint WeaponCount(Actor pawn)
	{
		uint ret = 0;

		for (Inventory i = pawn.Inv; i != null; i = i.Inv)
			if (i is 'RLWeapon')
				ret++;

		return ret;
	}

	static bool PlayerHasUpgrade(
		TFLV_PerPlayerStats stats,
		class<TFLV_Upgrade_BaseUpgrade> upgrade_t,
		uint minLevel = 1
	)
	{
		let bag = stats.Upgrades;

		for (uint i = 0; i < bag.Upgrades.Size(); i++)
		{
			if (bag.Upgrades[i].GetClass() != upgrade_t)
				continue;

			if (bag.Upgrades[i].Level >= minLevel)
				return true;
		}

		return false;
	}

	static bool AnyWeaponHasUpgrade(
		TFLV_PerPlayerStats stats,
		class<TFLV_Upgrade_BaseUpgrade> upgrade_t,
		uint minLevel = 1
	)
	{
		for (uint i = 0; i < stats.Weapons.Size(); i++)
		{
			let bag = stats.Weapons[i].Upgrades;

			for (uint j = 0; j < bag.Upgrades.Size(); j++)
			{
				if (bag.Upgrades[j].GetClass() == upgrade_t)
					continue;

				if (bag.Upgrades[j].Level >= minLevel)
					return true;
			}
		}

		return false;
	}

	static bool AnyPistolHasUpgrade(
		TFLV_PerPlayerStats stats,
		uint minLevel = 1
	)
	{
		for (uint i = 0; i < stats.Weapons.Size(); i++)
		{
			let weap_t = (class<Weapon>)(stats.Weapons[i].wpnClass);

			bool isPistol = weap_t is 'RLPistolWeapon';
			isPistol |= weap_t is 'RLMiniMissilePistol';

			if (!isPistol)
				continue;

			let bag = stats.Weapons[i].Upgrades;

			for (uint j = 0; j < bag.Upgrades.Size(); j++)
			{
				if (bag.Upgrades[j].Level < minLevel)
					continue;

				return true;
			}
		}

		return false;
	}

	static RLLV_Rarity WeaponRarity(class<Weapon> weap_t)
	{
		let pickup_tn = String.Format("%sPickup", weap_t.GetClassName());
		let pickup_t = (class<CustomInventory>)(pickup_tn);

		static const name PICKUP_TYPENAMES[] = {
			'RLStandardWeaponPickup',
			'RLExoticWeaponPickup',
			'RLSuperiorWeaponPickup',
			'RLBasicAssembledWeaponPickup',
			'RLAdvancedAssembledWeaponPickup',
			'RLMasterAssembledWeaponPickup',
			'RLUniqueWeaponPickup',
			'RLLegendaryWeaponPickup',
			'RLDemonicWeaponPickup'
		};

		static const RLLV_Rarity RARITIES[] = {
			RLLV_RARITY_STANDARD,
			RLLV_RARITY_EXOTIC,
			RLLV_RARITY_SUPERIOR,
			RLLV_RARITY_BASIC,
			RLLV_RARITY_ADVANCED,
			RLLV_RARITY_MASTER,
			RLLV_RARITY_UNIQUE,
			RLLV_RARITY_LEGENDARY,
			RLLV_RARITY_DEMONIC
		};

		for (uint i = 0; i < PICKUP_TYPENAMES.Size(); i++)
			if (pickup_t is PICKUP_TYPENAMES[i])
				return RARITIES[i];

		return RLLV_RARITY_NONE;
	}

	static bool WeaponIsAssembly(class<Weapon> weap_t)
	{
		switch (WeaponRarity(weap_t))
		{
		case RLLV_RARITY_BASIC:
		case RLLV_RARITY_ADVANCED:
		case RLLV_RARITY_MASTER:
			return true;
		default:
			return false;
		}
	}
}
