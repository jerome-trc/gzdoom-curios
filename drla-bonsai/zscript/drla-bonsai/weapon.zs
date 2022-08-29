class RLLV_Upgrade_ReserveFeed : TFLV_Upgrade_BaseUpgrade
{
	final override bool IsSuitableForWeapon(TFLV_WeaponInfo info)
	{
		let weap_t = (class<Weapon>)(info.wpnClass);
		
		if (!(weap_t is 'RLWeapon'))
			return false;

		let defs = GetDefaultByType(weap_t);
	
		return WeaponEligible(defs.AmmoType1, defs.AmmoType2);
	}

	private static bool WeaponEligible(class<Ammo> ammo_t1, class<Ammo> ammo_t2)
	{
		if (ammo_t1 == null && ammo_t2 == null)
			return false;
	
		if (ammo_t2 != 'Clip' &&
			ammo_t2 != 'Shell' &&
			ammo_t2 != 'RocketAmmo' &&
			ammo_t2 != 'Cell')
			return false;

		if (ammo_t1 == 'Clip' ||
			ammo_t1 == 'Shell' ||
			ammo_t1 == 'RocketAmmo' ||
			ammo_t1 == 'Cell')
			return false;

		return true;
	}

	final override void Tick(Actor owner)
	{
		let weap = owner.Player.ReadyWeapon;

		if (!WeaponEligible(weap.AmmoType1, weap.AmmoType2))
			return;

		let mag = owner.FindInventory(weap.AmmoType1);
		mag.Amount = mag.MaxAmount;

		weap.AmmoType1 = weap.AmmoType2;
		weap.AmmoType2 = null;

		weap.Ammo1 = weap.Ammo2;
		weap.Ammo2 = null;
	}
}

class RLLV_Upgrade_StateSpeed : TFLV_Upgrade_BaseUpgrade
{
	private RLLV_PowerDoubleFiringSpeed Power;

	static const statelabel CHECK_STATES[] = {
		'FireFinish',
		'FireFinishF',
		'FireFinishFF',
		'FireFinishContinue',
		'FireFinishPowerupCheckDone',
		'FireFinishPowerupCheckConfirmed',
		//////////////////////////////////////
		'ReloadStartAmmoCheck',
		'Reload',
		'Reload0',
		'Reload1',
		'Reload2',
		'Reload3',
		'Reload4',
		'ReloadClipCheckDone',
		'ReloadFinish',
		'ReloadFinishNoPump',
		'ReloadFinish1',
		'ReloadFinish1NoPump',
		'ReloadFinish2',
		'ReloadFinish2NoPump',
		'ReloadFinish3',
		'ReloadFinish3NoPump',
		'ReloadFinish4',
		'ReloadFinish4NoPump',
		//////////////////////////////////////
		'LeftPunch',
		'LeftUppercut'
	};

	// If the presence of this upgrade's current level reduces every relevant
	// state of the weapon to running for only 1 tic, there's no reason to offer
	// the player another level.
	final override bool IsSuitableForWeapon(TFLV_WeaponInfo info)
	{
		let lvl = info.Upgrades.Level('RLLV_Upgrade_StateSpeed');

		for (uint i = 0; i < CHECK_STATES.Size(); i++)
		{
			let start = info.Wpn.FindState(CHECK_STATES[i]);

			if (start == null)
				continue;

			Array<state> done;

			for (state s = start; s.InStateSequence(start); s = s.NextState)
			{
				if (done.Find(s) != done.Size())
					break; // Infinite loop protection

				if ((s.Tics - int(lvl)) <= 1)
					continue;

				return true;
			}
		}

		return false;
	}

	final override void Tick(Actor owner)
	{
		let weap = owner.Player.ReadyWeapon;
		let psp = owner.Player.GetPSprite(PSP_WEAPON);

		if (weap == null || psp == null || psp.CurState == null)
			return;

		if (Power == null)
		{
			if (psp.CurState.InStateSequence(weap.GetUpState()))
			{
				Power = RLLV_PowerDoubleFiringSpeed(
					Actor.Spawn('RLLV_PowerDoubleFiringSpeed', owner.Pos)
				);
				Power.AttachToOwner(owner);
			}
		}
		else
		{
			if (psp.CurState.InStateSequence(weap.GetDownState()))
			{
				Power.DepleteOrDestroy();
				Power = null;
			}
		}

		psp.Tics = Max(psp.Tics - int(Level), 1);
	}
}

class RLLV_PowerDoubleFiringSpeed : PowerDoubleFiringSpeed
{
	Default
	{
		Powerup.Duration 0x7FFFFFFD;
	}

	final override void DoEffect()
	{
		// (Rat):
		// Dear GZDoom:
		// stop with the implicit behaviour everywhere
		// thanks
		// I shouldn't have to remove the colormap
		// from one of the most basic powerup classes
	}
}
