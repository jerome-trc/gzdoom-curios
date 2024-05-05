class ratfd_ArmorBonus : ArmorBonus replaces ArmorBonus
{
	mixin ratfd_Pickup;

	default
	{
		-INVENTORY.ALWAYSPICKUP
		Tag "Armor Bonus";
		Inventory.PickupSound "items/armorbonuspickup";
		ratfd_ArmorBonus.FoundMessage "$RATFD_ARMORBONUS_FOUND";
	}

	final override bool Use(bool pickup)
	{
		let armor = BasicArmor(self.owner.FindInventory('BasicArmor'));
		let spct = Clamp(self.savePercent, 0.0, 100.0) / 100.0;

		// No null check here. I'd prefer to catch VM aborts early in testing.

		if (armor.SavePercent < spct)
		{
			armor.armorType = self.GetClassName();
			armor.icon = self.icon;
			armor.maxAbsorb = self.maxAbsorb;
			armor.maxFullAbsorb = self.maxFullAbsorb;
			armor.savePercent = spct;
			armor.actualSaveAmount = self.maxSaveAmount;
		}

		if (armor.amount < self.maxSaveAmount)
		{
			armor.maxAmount = Max(armor.maxAmount, self.maxSaveAmount);
			armor.amount++;
			return true;
		}

		if (self.bCountItem)
		{
			if (self.pickupFlash != null)
				Actor.Spawn(self.pickupFlash, self.pos, ALLOW_REPLACE);

			self.MarkAsCollected(self.owner);
		}

		return false;
	}
}

mixin class ratfd_Armor
{
	final override bool Use(bool pickup)
	{
		let max100 = false;
		let armor = BasicArmor(self.owner.FindInventory('BasicArmor'));
		let spct = Clamp(self.savePercent, 0.0, 100.0) / 100.0;
		int defSaveAmount = 0;
		class<BasicArmorPickup> barmor_t = armor.armorType;
		class<Armor> armor_t = armor.armorType;

		if (barmor_t != null)
		{
			let defs = GetDefaultByType((class<BasicArmorPickup>)(armor.armorType));
			defSaveAmount = defs.saveAmount;
		}
		else if (armor_t is 'BasicArmorBonus' || armor_t is 'ratfd_GreenArmor')
		{
			max100 = true;
			defSaveAmount = 100;
		}

		if (armor.savePercent >= spct && armor.amount < defSaveAmount)
		{
			let missing = armor.maxAmount - armor.amount;

			if (self is 'ratfd_GreenArmor' && max100)
				missing -= 100;

			if (missing <= 0)
				return false;

			int change = 0;

			if (armor.savePercent ~== spct)
			{
				change = Min(missing, self.saveAmount);
				self.saveAmount -= change;
			}
			else
			{
				change = Min(missing, int(Ceil((float(self.saveAmount) / 2.0))));
				self.saveAmount -= change * 2;
			}

			if (self.bIgnoreSkill)
				armor.amount += change;
			else
				armor.amount += int(change * G_SkillPropertyFloat(SKILLP_ARMORFACTOR));

			if (self.saveAmount <= 0)
				return true;
			else
				self.OnPartialPickup(self.owner);
		}
		else if (armor.savePercent < spct)
		{
			if ((class<Armor>)(armor.armorType) != null)
			{
				self.PrintPickupMessage(
					self.owner.CheckLocalView(),
					"$RATFD_DISCARDEDINFERIORARMOR"
				);

				let s = Actor.Spawn('ratfd_GreenArmor', self.owner.pos);
				let discarded = ratfd_GreenArmor(s);

				discarded.amount = armor.amount;
				discarded.saveAmount = armor.amount;
			}

			armor.savePercent = spct;
			armor.amount = self.saveAmount + armor.bonusCount;
			armor.maxAmount = self.saveAmount;
			armor.icon = self.icon;
			armor.maxAbsorb = self.maxAbsorb;
			armor.maxFullAbsorb = self.maxFullAbsorb;
			// (RAT) Why isn't this variable of type `class<T>`...?
			armor.armorType = self.GetClassName();
			armor.actualSaveAmount = self.saveAmount;
			return true;
		}

		if (self.bCountItem)
			self.MarkAsCollected(self.owner);

		return false;
	}

	final override string PickupMessage()
	{
		if (self.saveAmount <= 0)
			return self.PARTIAL_PICKUP_MESSAGE;
		else
			return self.PICKUPMSG;
	}
}

class ratfd_GreenArmor : GreenArmor replaces GreenArmor
{
	mixin ratfd_Pickup;
	mixin ratfd_Armor;

	default
	{
		Tag "Security Armor";
		Inventory.PickupSound "items/greenarmorpickup";
		ratfd_GreenArmor.PartialPickupMessage "$RATFD_GREENARMOR_PARTIAL";
	}
}

class ratfd_BlueArmor : BlueArmor replaces BlueArmor
{
	mixin ratfd_Pickup;
	mixin ratfd_Armor;

	default
	{
		Tag "Combat Armor";
		Inventory.PickupSound "items/bluearmorpickup";
		ratfd_BlueArmor.PartialPickupMessage "$RATFD_BLUEARMOR_PARTIAL";
	}
}
