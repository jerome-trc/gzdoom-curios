class FDPP_Berserk : Berserk
{
	Default
	{
		Inventory.PickupSound "items/berserkpickup";
		Tag "Berserk";
	}

	final override void DoPickupSpecial(Actor toucher)
	{
		super.DoPickupSpecial(toucher);

		let leftover = 100 - (toucher.GetMaxHealth() - toucher.Health);
		bool split = false;
		toucher.GiveBody(100, 0);

		while (leftover >= 25)
		{
			A_SpawnItemEx(
				'FDMedikitPickup',
				0.0, 0.0, 16.0,
				FRandom(0.1, 2.0), 1.0, FRandom(0.1, 2.0),
				FRandom(0.0, 360.0)
			);

			leftover -= 25;
			split = true;
		}

		while (leftover >= 10)
		{
			A_SpawnItemEx(
				'FDStimpackPickup',
				0.0, 0.0, 16.0,
				FRandom(0.1, 2.0), 1.0, FRandom(0.1, 2.0),
				FRandom(0.0, 360.0)
			);

			leftover -= 10;
			split = true;
		}

		while (leftover >= 1)
		{
			A_SpawnItemEx(
				'FDHealthBonusPickup',
				0.0, 0.0, 16.0,
				FRandom(0.1, 2.0), 1.0, FRandom(0.1, 2.0),
				FRandom(0.0, 360.0)
			);

			leftover -= 1;
			split = true;
		}

		if (split)
		{
			PrintPickupMessage(
				toucher.CheckLocalView(),
				"Left the excess health from the berserk pack behind."
			);
		}

		BerserkSwitch(toucher);
		toucher.GiveInventory('PowerStrength', 1);
	}

	private static void BerserkSwitch(Actor toucher)
	{
		static const name FIST_TYPES[] = {
			'FDPlutFist',
			'FDTNTFist',
			'FDDoom2Fist',
			'FDAliensFist',
			'FDJPCPFist',
			'FDBTSXFist',
			'FDHellboundFist',
			'FDAlienVendettaFist'
			// Whitemare's melee weapon gets special handling
		};

		let bswitch = CVar.GetCVar("FD_berserkswitch", toucher.Player).GetInt();

		if (bswitch == 0)
			return;

		if (bswitch == 2 && toucher.CountInv('PowerStrength') > 0)
			return;

		if (toucher.ACS_ScriptCall('FDBerserkWeaponCheck') == 1)
			return;

		for (Inventory i = toucher.Inv; i != null; i = i.Inv)
		{
			for (uint j = 0; j < FIST_TYPES.Size(); j++)
			{
				let t = FIST_TYPES[j];

				if (i is t)
				{
					toucher.A_SelectWeapon(t);
					return;
				}
			}

			if (i is 'FDWhitemareFist' && toucher.CountInv('FDWhitemareFireballCharge') <= 0)
			{
				toucher.A_SelectWeapon('FDWhitemareFist');
				return;
			}
		}
	}
}
