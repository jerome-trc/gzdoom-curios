version "2.4"

class RLThriftyReplacer : EventHandler
{
	private Array<class<Actor> > ToReplace, Replacements;

	final override void OnRegister()
	{
		name toReplace_tns[] = {
			'RLClip',
			'RLClipBox',
			'RLShell',
			'RLShellBox',
			'RLRocketAmmo',
			'RLRocketBox',
			'RLCell',
			'RLCellPack',
			'RLStimpack',
			'RLMedikit'
		};

		class<Actor> replacement_tns[] = {
			'RLThriftyClip',
			'RLThriftyClipBox',
			'RLThriftyShell',
			'RLThriftyShellBox',
			'RLThriftyRocketAmmo',
			'RLThriftyRocketBox',
			'RLThriftyCell',
			'RLThriftyCellPack',
			'RLThriftyStimpack',
			'RLThriftyMedikit'
		};

		for (uint i = 0; i < toReplace_tns.Size(); i++)
		{
			ToReplace.Push((class<Actor>)(toReplace_tns[i]));
			Replacements.Push(replacement_tns[i]);
		}
	}

	final override void CheckReplacement(ReplaceEvent event)
	{
		for (uint i = 0; i < ToReplace.Size(); i++)
		{
			if (event.Replacee is ToReplace[i])
			{
				event.Replacement = Replacements[i];
				return;
			}
		}
	}
}

// Ammo ========================================================================

mixin class RLThriftySmallAmmo
{
	override void DoPickupSpecial(Actor toucher)
	{
		super.DoPickupSpecial(toucher);

		string rlPlayer_tn = "DoomRLPlayer";
		class<PlayerPawn> rlPlayer_t = rlPlayer_tn;

		if (!(toucher.Getclass() is rlPlayer_t)) return;

		bool dedi = false;
		class<Ammo> bkpkChoice_t = null;

		for (Inventory i = toucher.Inv; i != null; i = i.Inv)
		{
			if (i is 'RLBackpackClipChosen')
				bkpkChoice_t = 'Clip';
			else if (i is 'RLBackpackShellChosen')
				bkpkChoice_t = 'Shell';
			else if (i is 'RLBackpackRocketChosen')
				bkpkChoice_t = 'RocketAmmo';
			else if (i is 'RLBackpackCellChosen')
				bkpkChoice_t = 'Cell';
			else if (i is 'RLDedicatedBackpackToken')
				dedi = true;
		}

		if (dedi)
			toucher.GiveInventory(bkpkChoice_t, Amount);
	}
}

mixin class RLThriftyBigAmmo
{
	override void DoPickupSpecial(Actor toucher)
	{
		super.DoPickupSpecial(toucher);

		string rlPlayer_tn = "DoomRLPlayer";
		class<PlayerPawn> rlPlayer_t = rlPlayer_tn;

		if (!(toucher.Getclass() is rlPlayer_t)) return;

		bool dedi = false, scrounger = false;
		class<Ammo> bkpkChoice_t = null;

		for (Inventory i = toucher.Inv; i != null; i = i.Inv)
		{
			if (i is 'RLBackpackClipChosen')
				bkpkChoice_t = 'Clip';
			else if (i is 'RLBackpackShellChosen')
				bkpkChoice_t = 'Shell';
			else if (i is 'RLBackpackRocketChosen')
				bkpkChoice_t = 'RocketAmmo';
			else if (i is 'RLBackpackCellChosen')
				bkpkChoice_t = 'Cell';
			else if (i is 'RLDedicatedBackpackToken')
				dedi = true;
			else if (i is 'RLScroungerBackpackToken')
				scrounger = true;
		}

		if (dedi)
			toucher.GiveInventory(bkpkChoice_t, Amount);
		else if (scrounger)
		{
			toucher.GiveInventory(bkpkChoice_t,
				GetDefaultByType(bkpkChoice_t).BackpackAmount);
		}
	}
}

class RLThriftyClip : ThriftyClip
{
	mixin RLThriftySmallAmmo;

	Default
	{
		Tag "Clip Pickup";
		Inventory.PickupMessage "Picked up a mag of bullets.";
		Inventory.PickupSound "misc/clippickup";
	}
}

class RLThriftyClipBox : ThriftyClipBox
{
	mixin RLThriftyBigAmmo;

	Default
	{
		Tag "Clip Box Pickup";
		Inventory.PickupMessage "Picked up a box of bullets.";
		Inventory.PickupSound "misc/clipboxpickup";
		ThriftyAmmo.PickupOpenMsg "Opened a box of bullets.";
	}
}

class RLThriftyShell : ThriftyShell
{
	mixin RLThriftySmallAmmo;

	Default
	{
		Tag "Shell Pickup";
		Inventory.PickupMessage "Picked up some shotgun shells.";
		Inventory.PickupSound "misc/shellpickup";
	}
}

class RLThriftyShellBox : ThriftyShellBox
{
	mixin RLThriftyBigAmmo;

	Default
	{
		Tag "Shell Box Pickup";
		Inventory.PickupMessage "Picked up a box of shotgun shells.";
		Inventory.PickupSound "misc/shellpickup";
		ThriftyAmmo.PickupOpenMsg "Opened a box of shotgun shells.";
	}
}

class RLThriftyRocketAmmo : ThriftyRocketAmmo
{
	mixin RLThriftySmallAmmo;

	Default
	{
		Tag "Rocket Pickup";
		Inventory.PickupMessage "Picked up a rocket.";
		Inventory.PickupSound "misc/rocketpickup";
	}
}

class RLThriftyRocketBox : ThriftyRocketBox
{
	mixin RLThriftyBigAmmo;

	Default
	{
		Tag "Rocket Box Pickup";
		Inventory.PickupMessage "Picked up a box of rockets.";
		Inventory.PickupSound "misc/rocketpickup";
		ThriftyAmmo.PickupOpenMsg "Opened a box of rockets.";
	}
}

class RLThriftyCell : ThriftyCell
{
	mixin RLThriftySmallAmmo;

	Default
	{
		Tag "Cell Pickup";
		Inventory.PickupMessage "Picked up an energy cell.";
		Inventory.PickupSound "misc/cellpickup";
	}
}

class RLThriftyCellPack : ThriftyCellPack
{
	mixin RLThriftyBigAmmo;

	Default
	{
		Tag "Cell Pack Pickup";
		Inventory.PickupMessage "Picked up an energy cell pack.";
		Inventory.PickupSound "misc/cellpickup";
		ThriftyAmmo.PickupOpenMsg "Opened an energy cell pack.";
	}
}

// Health //////////////////////////////////////////////////////////////////////

mixin class RLThriftyHealth
{
	meta int EnhancedHealth; // Added to normal health given
	property EnhancedHealth: EnhancedHealth;

	Default
	{
		ThriftyHealth.SmallPickup 'RLThriftyMiniStimpack';
	}

	override void DoPickupSpecial(Actor toucher)
	{
		super.DoPickupSpecial(toucher);

		name rlPlayer_tn = 'DoomRLPlayer';

		if (!(toucher.Getclass() is rlPlayer_tn))
			return;

		for (Inventory i = toucher.Inv; i != null; i = i.Inv)
		{
			if (
				i is 'RLSurvivalMediArmorToken' ||
				i is 'RLOModSurvivalMediArmorToken')
			{
				toucher.GiveInventory('PowerRLSurvivalMediArmorRegen', 1);
				return;
			}
			else if (
				i is 'RLMedicalArmorToken' ||
				i is 'RLMedicalPowerArmorToken' ||
				i is 'RLOModMedicalArmorToken')
			{
				toucher.GiveBody(13);
				return;
			}
		}
	}
}

class RLThriftyMiniStimpack : ThriftyMiniStimpack
{
	Default
	{
		ThriftyHealth.PickupMsg "Picked up a mini stimpack.";
	}
}

class RLThriftyStimpack : ThriftyStimpack
{
	mixin RLThriftyHealth;

	Default
	{
		Inventory.PickupMessage "Picked up a stimpack.";
		ThriftyHealth.PickupOpenMsg "Opened a stimpack.";
		RLThriftyStimpack.EnhancedHealth 5;
	}
}

class RLThriftyMedikit : ThriftyMedikit
{
	mixin RLThriftyHealth;

	Default
	{
		Inventory.PickupMessage "Picked up a medikit.";
		ThriftyHealth.PickupOpenMsg "Opened a medikit.";
		RLThriftyMedikit.EnhancedHealth 13;
	}	
}
