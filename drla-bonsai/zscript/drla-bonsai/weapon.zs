class RLLV_Upgrade_ReserveFeed : TFLV_Upgrade_BaseUpgrade
{
	final override bool IsSuitableForWeapon(TFLV_WeaponInfo info) {
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
