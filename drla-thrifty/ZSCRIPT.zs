version "2.4"

class RLThriftyReplacer : StaticEventHandler
{
	private Dictionary replaceMap;

	final override void OnRegister()
	{
		self.replaceMap = Dictionary.Create();

		self.replaceMap.Insert("Clip", "RLThriftyClip");
		self.replaceMap.Insert("RLClip", "RLThriftyClip");
		self.replaceMap.Insert("ThriftyClip", "RLThriftyClip");

		self.replaceMap.Insert("ClipBox", "RLThriftyClipBox");
		self.replaceMap.Insert("RLClipBox", "RLThriftyClipBox");
		self.replaceMap.Insert("ThriftyClipBox", "RLThriftyClipBox");

		self.replaceMap.Insert("Shell", "RLThriftyShell");
		self.replaceMap.Insert("RLShell", "RLThriftyShell");
		self.replaceMap.Insert("ThriftyShell", "RLThriftyShell");

		self.replaceMap.Insert("ShellBox", "RLThriftyShellBox");
		self.replaceMap.Insert("RLShellBox", "RLThriftyShellBox");
		self.replaceMap.Insert("ThriftyShellBox", "RLThriftyShellBox");

		self.replaceMap.Insert("RocketAmmo", "RLThriftyRocketAmmo");
		self.replaceMap.Insert("RLRocketAmmo", "RLThriftyRocketAmmo");
		self.replaceMap.Insert("ThriftyRocketAmmo", "RLThriftyRocketAmmo");

		self.replaceMap.Insert("RocketBox", "RLThriftyRocketBox");
		self.replaceMap.Insert("RLRocketBox", "RLThriftyRocketBox");
		self.replaceMap.Insert("ThriftyRocketBox", "RLThriftyRocketBox");

		self.replaceMap.Insert("Cell", "RLThriftyCell");
		self.replaceMap.Insert("RLCell", "RLThriftyCell");
		self.replaceMap.Insert("ThriftyCell", "RLThriftyCell");

		self.replaceMap.Insert("CellPack", "RLThriftyCellPack");
		self.replaceMap.Insert("RLCellPack", "RLThriftyCellPack");
		self.replaceMap.Insert("ThriftyCellPack", "RLThriftyCellPack");

		self.replaceMap.Insert("Stimpack", "RLThriftyStimpack");
		self.replaceMap.Insert("RLStimpack", "RLThriftyStimpack");
		self.replaceMap.Insert("ThriftyStimpack", "RLThriftyStimpack");

		self.replaceMap.Insert("Medikit", "RLThriftyMedikit");
		self.replaceMap.Insert("RLMedikit", "RLThriftyMedikit");
		self.replaceMap.Insert("ThriftyMedikit", "RLThriftyMedikit");
	}

	/// Use this event instead of `replaces` qualifiers,
	// since it seems to be more reliable.
	final override void CheckReplacement(ReplaceEvent event)
	{
		let tn = self.replaceMap.At(event.replacee.GetClassName());

		if (tn.Length() != 0)
		{
			event.replacement = (class<Actor>)(tn);
		}
	}
}

// Ammo ========================================================================

mixin class RLThriftySmallAmmo
{
	void DoPickupSpecialImpl(Actor toucher)
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
	override void PostBeginPlay()
	{
		super.PostBeginPlay();

		if (Random[RLThrifty](0, 6) == 0)
		{
			Actor.Spawn('RLModPackSpawner', self.pos);
			GoAwayAndDie();
		}
	}

	void DoPickupSpecialImpl(Actor toucher)
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

	override void DoPickupSpecial(Actor toucher)
	{
		self.DoPickupSpecialImpl(toucher);
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

	override void DoPickupSpecial(Actor toucher)
	{
		self.DoPickupSpecialImpl(toucher);
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

	override void DoPickupSpecial(Actor toucher)
	{
		self.DoPickupSpecialImpl(toucher);

		if (toucher.FindInventory('RLShellshockPerk') != null)
			toucher.GiveInventory('RLRenegadeExtraShot', 1);
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

	override void DoPickupSpecial(Actor toucher)
	{
		self.DoPickupSpecialImpl(toucher);

		if (toucher.FindInventory('RLShellshockPerk') != null)
			toucher.GiveInventory('RLRenegadeExtraShot', 1);
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

	override void DoPickupSpecial(Actor toucher)
	{
		self.DoPickupSpecialImpl(toucher);
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

	override void DoPickupSpecial(Actor toucher)
	{
		self.DoPickupSpecialImpl(toucher);
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

	override void DoPickupSpecial(Actor toucher)
	{
		self.DoPickupSpecialImpl(toucher);
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

	override void DoPickupSpecial(Actor toucher)
	{
		self.DoPickupSpecialImpl(toucher);
	}
}

// Health //////////////////////////////////////////////////////////////////////

mixin class RLThriftyHealth
{
	meta int ENHANCED_HEALTH; // Added to normal health given.
	property EnhancedHealth: ENHANCED_HEALTH;

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
				toucher.GiveBody(self.ENHANCED_HEALTH);
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
		Inventory.PickupSound "misc/stimpackpickup";
	}
}

class RLThriftyStimpack : ThriftyStimpack
{
	mixin RLThriftyHealth;

	Default
	{
		Inventory.PickupMessage "Picked up a stimpack.";
		Inventory.PickupSound "misc/stimpackpickup";
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
		Inventory.PickupSound "misc/medikitpickup";
		ThriftyHealth.PickupOpenMsg "Opened a medikit.";
		RLThriftyMedikit.EnhancedHealth 13;
	}
}
