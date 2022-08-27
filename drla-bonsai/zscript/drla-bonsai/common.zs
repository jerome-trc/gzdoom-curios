struct RLLV_Utils
{
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

	static bool WeaponIsAssembly(class<Weapon> weap_t)
	{
		let pickup_tn = String.Format("%sPickup", weap_t.GetClassName());
		let pickup_t = (class<CustomInventory>)(pickup_tn);

		return
			pickup_t is 'RLBasicAssembledWeaponPickup' ||
			pickup_t is 'RLAdvancedAssembledWeaponPickup' ||
			pickup_t is 'RLMasterAssembledWeaponPickup';
	}
}
