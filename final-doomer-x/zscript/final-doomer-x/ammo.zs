// (Rat): This code could maybe be even more statically polymorphic
// but mixins have an incomprehensible relationship with real definitions.
// This works, so I'm leaving it as it is.
// It inherits from `CustomInventory` while undoing that class' overrides
// so that Zhs2's Intelligent Supplies can be configured to ignore these.
class FDX_AmmoPickup : CustomInventory abstract
{
	protected meta class<FDX_AmmoPickup> SmallCounterpart;
	property SmallCounterpart: SmallCounterpart;

	protected meta class<Inventory> BFGAmmoPickupType;
	protected meta uint BFGAmmoPickupCount;
	property BFGAmmoPickups: BFGAmmoPickupType, BFGAmmoPickupCount;

	protected meta uint BFGAmmoMulti;
	property BFGAmmoMulti: BFGAmmoMulti;

	protected meta string PickupSoundTemplate;
	property PickupSoundTemplate: PickupSoundTemplate;

	// (Rat): The semantics of `bDropped` are a mystery to me
	// (and probably to the core team too) so I'm bypassing them altogether
	protected bool IsDropped;

	Default
	{
		+INVENTORY.AUTOACTIVATE
		+FORCEXYBILLBOARD

		Height 14;
		Radius 16;

		Inventory.Amount 0;
		Inventory.PickupMessage "";
		Inventory.PickupSound "";
	}

	final override bool Use(bool pickup)
	{
		return Inventory.Use(pickup);
	}

	final override bool SpecialDropAction(Actor dropper)
	{
		return Inventory.SpecialDropAction(dropper);
	}

	final override bool TryPickup(in out Actor toucher)
	{
		return Inventory.TryPickup(toucher);
	}

	final override Inventory CreateTossable(int amt)
	{
		let ret = super.CreateTossable(amt);
		FDX_AmmoPickup(ret).IsDropped = true;
		return ret;
	}

	protected void AmmoPickupSound(Actor toucher, sound toPlay)
	{
		toucher.A_StartSound(toPlay, CHAN_ITEM, CHANF_DEFAULT, 1.0, 1.5);
	}

	protected void AmmoPickupMessage(Actor toucher, string msg)
	{
		PrintPickupMessage(toucher.CheckLocalView(), msg);
	}

	protected float PlayerAmountMultiplier(Actor toucher) const
	{
		if (IsDropped)
			return CVar.GetCVar("FD_droppedammoamount", toucher.Player).GetFloat();
		else
			return CVar.GetCVar("FD_ammopickupamount", toucher.Player).GetFloat();
	}

	protected bool IsLargePickup() const
	{
		return SmallCounterpart != null;
	}

	protected bool ForbidWaste(PlayerPawn pawn) const
	{
		return
			!IsLargePickup() &&
			CVar.GetCVar("FDX_wasteproof_small", pawn.Player).GetBool();
	}

	final override void DoPickupSpecial(Actor toucher)
	{
		super.DoPickupSpecial(toucher);

		let pawn = PlayerPawn(toucher);
		let theme = RelevantTheme(pawn);

		uint giveAmt = CalcGiveAmount(pawn) * PlayerAmountMultiplier(pawn);

		sound pkupSnd;
		
		if (!(self is 'FDX_BFGPickupBase'))
		{
			pkupSnd = String.Format(
				PickupSoundTemplate,
				FDX_Common.THEME_STRINGS[theme],
				IsLargePickup() ? "large" : "small"
			);
		}
		else
		{
			pkupSnd = String.Format(
				"items/bfgammo%spickup",
				IsLargePickup() ? "big" : "small"
			);
		}

		let ammo_t = GivenAmmoType(pawn);
		bool partial = false;

		if (IsLargePickup())
		{
			uint amt = 0, maxAmt = GetDefaultByType(ammo_t).MaxAmount;
			let item = pawn.FindInventory(ammo_t);

			if (item != null)
			{
				amt = item.Amount;
				maxAmt = item.MaxAmount;
			}

			int smallAmt = GetDefaultByType(SmallCounterpart).CalcGiveAmount(pawn);
			int leftover = giveAmt - (maxAmt - amt);

			while (leftover >= smallAmt)
			{
				A_SpawnItemEx(
					SmallCounterpart,
					0.0, 0.0, 16.0,
					FRandom(0.1, 2.0), 1.0, FRandom(0.1, 2.0),
					FRandom(0.0, 360.0)
				);

				leftOver -= smallAmt;
				partial = true;
			}
		}

		pawn.GiveInventory(ammo_t, giveAmt);

		AmmoPickupSound(pawn, String.Format(pkupSnd));
		AmmoPickupMessage(pawn, ResolvePickupMessage(theme, partial));

		if (FD_bfgammosystem == FDX_BFGAMMO_ALLLARGE &&
			IsLargePickup() &&
			BFGAmmoMulti > 0)
		{
			let cv = CVar.GetCVar("FD_bfgammoamount", pawn.Player).GetFloat();
			let bfgAmt = BFGAmmoMulti * cv;

			if (bfgAmt <= 0)
				return;

			pawn.GiveInventory('FDBFGAmmoPickupCounter', bfgAmt);
			DispenseBFGAmmo(pawn);
		}
		else if (FD_bfgammosystem == FDX_BFGAMMO_FROMCELL)
		{
			let bfgAmt = 0;
			let cv = CVar.GetCVar("FD_bfgammoamount", pawn.Player).GetFloat();

			if (self is 'FDX_Cell_ZS')
				bfgAmt = 20 * cv;
			else if (self is 'FDX_CellPack_ZS')
				bfgAmt = 50 * cv;

			if (bfgAmt <= 0)
				return;

			pawn.GiveInventory('FDBFGAmmoPickupCounter', bfgAmt);
			DispenseBFGAmmo(pawn);
		}
		else if (self is 'FDX_BFGPickupBase')
		{
			DispenseBFGAmmo(pawn);
		}
	}

	private void DispenseBFGAmmo(PlayerPawn pawn)
	{
		let cc_t = FDX_Common.BFGCollectCounterType(pawn);
		let charge_t = FDX_Common.BFGChargeType(pawn);

		let apc = pawn.FindInventory('FDBFGAmmoPickupCounter');
		let cc = pawn.FindInventory(cc_t);
		let charge = pawn.FindInventory(charge_t);
		uint leftover = 0;

		if (cc == null)
		{
			pawn.GiveInventory(cc_t, 0);
			cc = pawn.FindInventory(cc_t);
		}

		if (charge == null)
		{
			pawn.GiveInventory(charge_t, 0);
			charge = pawn.FindInventory(charge_t);
		}

		for (; apc.Amount >= 0; apc.Amount--)
		{
			if (cc.Amount >= cc.MaxAmount)
			{
				if (charge.Amount >= charge.MaxAmount)
				{
					cc.Amount = Max(cc.Amount, cc.MaxAmount);
					leftover += apc.Amount;
					break;
				}
				else
				{
					charge.Amount++;
					cc.Amount = 0;
				}
			}
			else
			{
				cc.Amount++;
			}
		}

		apc.DepleteOrDestroy();

		if (leftover >= 10)
		{
			static const string MESSAGES[] = {
				"Left behind the excess quantum batteries.",
				"Left behind the excess annihilator cells.",
				"Left behind the excess BFG power cells.",
				"Left behind the excess alien power sources.",
				"Left behind the excess devastator packs.",
				"Left behind the excess X-Spark cells.",
				"Left behind the excess Totenheim materials.",
				"Left behind the excess Vendetta cells.",
				"Left behind the excess solar fuel rods."
			};

			PrintPickupMessage(
				pawn.CheckLocalView(),
				MESSAGES[FDX_Common.MainTheme(pawn)]
			);
		}

		while (leftover >= 25)
		{
			A_SpawnItemEx(
				'FDX_BFGPickupBig_ZS',
				0.0, 0.0, 16.0,
				FRandom(0.1, 2.0), 1.0, FRandom(0.1, 2.0),
				FRandom(0.0, 360.0)
			);

			leftover -= 25;
		}

		while (leftover >= 10)
		{
			A_SpawnItemEx(
				'FDX_BFGPickup_ZS',
				0.0, 0.0, 16.0,
				FRandom(0.1, 2.0), 1.0, FRandom(0.1, 2.0),
				FRandom(0.0, 360.0)
			);

			leftover -= 10;
		}
	}

	abstract protected string ResolvePickupMessage(FDX_Theme theme, bool partial) const;
	abstract protected uint CalcGiveAmount(PlayerPawn pawn) const;
	// This needs to return a `class<Inventory>` rather than a `class<Ammo` in
	// order to generalise over `FDBFGAmmoPickupCounter`.
	abstract protected class<Inventory> GivenAmmoType(PlayerPawn pawn) const;
	abstract FDX_Theme RelevantTheme(PlayerPawn pawn) const;

	protected action state A_FDX_AmmoSpawn()
	{
		bool bfgSpawns =
			FD_bfgammosystem == FDX_BFGAMMO_LARGESEPARATE &&
			invoker.IsLargePickup();

		bfgSpawns |=
			FD_bfgammosystem == FDX_BFGAMMO_CELLSEPARATE &&
			invoker is 'FDX_CellPickup';

		if (bfgSpawns)
		{
			for (uint i = 0; i < invoker.BFGAmmoPickupCount; i++)
			{
				invoker.A_SpawnItemEx(
					invoker.BFGAmmoPickupType,
					FRandom(-20.0, 20.0),
					FRandom(-20.0, 20.0),
					flags: SXF_NOCHECKPOSITION
				);
			}
		}

		switch (FD_itemvisuals)
		{
		case FDX_ITEMVIS_GENERIC:
			return ResolveState('Spawn.Generic');
		case FDX_ITEMVIS_FANCYGENERIC:
			return ResolveState('Spawn.Fancy');
		default:
		}

		if (FD_dynamicvisuals)
			return ResolveState('Spawn.Dynamic');

		return state(null);
	}
}

mixin class FDX_AmmoPickupImpl
{
	final override string ResolvePickupMessage(FDX_Theme theme, bool partial) const
	{
		if (partial)
			return PICKUP_MESSAGES_PARTIAL[theme];
		else
			return PICKUP_MESSAGES[theme];
	}

	final override uint CalcGiveAmount(PlayerPawn toucher)
	{
		return GIVE_AMOUNTS[RelevantTheme(toucher)];
	}

	protected action void A_FDX_SpawnPickupVisuals(bool dynamic)
	{
		for (uint i = 0; i < invoker.VISUAL_PICKUPS.Size(); i++)
		{
			A_SpawnItemEx(
				invoker.VISUAL_PICKUPS[i],
				flags: SXF_SETMASTER,
				failChance: (dynamic ? CallACS("FDPlayerIn", i) : 0)
			);
		}
	}
}
