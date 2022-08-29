// Classes /////////////////////////////////////////////////////////////////////

// Requires that at least one of the player's weapons has at least one level
// of Reserve Feed.
// - Reduced ammo consumption for rapid/burst weapons.
// - Longer-lasting powerups.
// - Increased rate of fire while a powerup is active.
class RLLV_Upgrade_Ammochain : TFLV_Upgrade_BaseUpgrade
{
	private bool Applied;

	final override void Tick(Actor owner)
	{
		if (Applied)
			return;

		owner.GiveInventory('RLAmmoChainPerk', 1);
		Applied = true;
	}

	final override bool IsSuitableForPlayer(TFLV_PerPlayerStats stats)
	{
		if (stats.Owner.FindInventory('RLAmmoChainPerk') != null)
			return false;

		return RLLV_Utils.AnyWeaponHasUpgrade(stats, 'RLLV_Upgrade_ReserveFeed');
	}
}

// Requires that the player has at least one level of Blast Shaping.
// - Non shell-based weapons use 50% less ammo, rounded down.
// - Armor breaking causes explosives to drop.
class RLLV_Upgrade_Fireangel : TFLV_Upgrade_BaseUpgrade
{
	private bool Applied;

	final override void Tick(Actor owner)
	{
		if (Applied)
			return;

		owner.GiveInventory('RLFireangelPerk', 1);
		Applied = true;
	}

	final override bool IsSuitableForPlayer(TFLV_PerPlayerStats stats)
	{
		if (stats.Owner.FindInventory('RLFireangelPerk') != null)
			return false;

		return RLLV_Utils.PlayerHasUpgrade(stats, 'TFLV_Upgrade_BlastShaping');
	}
}

// Requires that the player have at least one assembly weapon.
// - Can turn rare weapons into modpacks.
// - Modpack carrying capacity goes from 4 to 8.
// - Increased damage when using an assembly weapon.
// - Picking up an `Allmap` grants `PowerScanner`.
class RLLV_Upgrade_Scavenger : TFLV_Upgrade_BaseUpgrade
{
	private bool Applied;

	final override void Tick(Actor owner)
	{
		if (Applied)
			return;

		owner.GiveInventory('RLScavengerPerk', 1);
		Applied = true;
	}

	final override bool IsSuitableForPlayer(TFLV_PerPlayerStats stats)
	{
		if (stats.Owner.FindInventory('RLScavengerPerk') != null)
			return false;

		for (Inventory i = stats.Owner.Inv; i != null; i = i.Inv)
		{
			let weap = Weapon(i);

			if (weap == null)
				continue;

			if (RLLV_Utils.WeaponIsAssembly(weap.GetClass()))
				return true;
		}

		return false;
	}
}

// Requires that at least one pistol class already has at least one upgrade.
// - Better damage and accuracy with handguns.
// - Entering a new map grants `Allmap` for free.
class RLLV_Upgrade_Sharpshooter : TFLV_Upgrade_BaseUpgrade
{
	private bool Applied;

	final override void Tick(Actor owner)
	{
		if (Applied)
			return;

		owner.GiveInventory('RLSharpshooterPerk', 1);
		Applied = true;
	}

	final override bool IsSuitableForPlayer(TFLV_PerPlayerStats stats)
	{
		if (stats.Owner.FindInventory('RLSharpshooterPerk') != null)
			return false;

		return RLLV_Utils.AnyPistolHasUpgrade(stats);
	}
}

// Requires that at least one shotgun class already has at least one upgrade.
// - More pellets with scattering weaponry.
// - Picking up a `Shell` item grants a free shot with a shotgun-like weapon.
// - Armor grants more protection when equipped.
class RLLV_Upgrade_Shellshock : TFLV_Upgrade_BaseUpgrade
{
	private bool Applied;

	final override void Tick(Actor owner)
	{
		if (Applied)
			return;

		owner.GiveInventory('RLShellshockPerk', 1);
		Applied = true;
	}

	final override bool IsSuitableForPlayer(TFLV_PerPlayerStats stats)
	{
		if (stats.Owner.FindInventory('RLShellshockPerk') != null)
			return false;

		for (Inventory i = stats.Owner.Inv; i != null; i = i.Inv)
		{
			let weap = Weapon(i);

			if (weap == null)
				continue;

			if (weap.FindState('FireRenegade') != null)
				return true;
		}

		return false;
	}
}

// Miscellaneous ///////////////////////////////////////////////////////////////

// +1 to weapon carrying capacity.
class RLLV_Upgrade_Hoarder : TFLV_Upgrade_BaseUpgrade
{
	private Inventory LimitItem;

	final override void Tick(Actor owner)
	{
		if (LimitItem == null)
		{
			LimitItem = owner.FindInventory('RLWeaponLimit');

			if (LimitItem == null)
			{
				LimitItem = Inventory(Actor.Spawn('RLWeaponLimit', owner.Pos));
				LimitItem.AttachToOwner(owner);
				LimitItem.Amount = RLLV_Utils.WeaponCount(owner);
			}
		}

		LimitItem.MaxAmount = LimitItem.Default.MaxAmount + Level;
	}

	final override bool IsSuitableForPlayer(TFLV_PerPlayerStats stats)
	{
		return true;
	}
}
