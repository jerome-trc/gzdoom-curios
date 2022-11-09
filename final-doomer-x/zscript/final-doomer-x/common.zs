struct FDX_Utils play
{
	static bool InvMaxed(Actor owner, class<Inventory> type)
	{
		let item = owner.FindInventory(type);

		if (item == null)
			return false;
		
		return item.Amount >= item.MaxAmount;
	}
}

// Symbols related to resolving and manipulating player classes and gear.
struct FDX_Common play
{
	static const string THEME_STRINGS[] = {
		"plut",
		"tnt",
		"doom2",
		"aliens",
		"jpcp",
		"btsx",
		"hellbound",
		"alienvendetta",
		"whitemare"
	};

	static const name BULLET_TYPES[] = {
		'FDPlutBullets',
		'FDTNTBullets',
		'FDDoom2Bullets',
		'FDAliensBullets',
		'FDJPCPBullets',
		'FDBTSXBullets',
		'FDHellboundBullets',
		'FDAlienVendettaBullets',
		'FDWhitemareBullets'
	};

	static const name SHELL_TYPES[] = {
		'FDPlutShells',
		'FDTNTShells',
		'FDDoom2Shells',
		'FDAliensShells',
		'FDJPCPShells',
		'FDBTSXShells',
		'FDHellboundShells',
		'FDAlienVendettaShells',
		'FDWhitemareShells'
	};

	static const name ROCKETAMMO_TYPES[] = {
		'FDPlutRocket',
		'FDTNTRocket',
		'FDDoom2Rocket',
		'FDAliensRocket',
		'FDJPCPRocket',
		'FDBTSXRocket',
		'FDHellboundRocket',
		'FDAlienVendettaRocket',
		'FDWhitemareRocket'
	};

	static const name CELL_TYPES[] = {
		'FDPlutCell',
		'FDTNTCell',
		'FDDoom2Cell',
		'FDAliensCell',
		'FDJPCPCell',
		'FDBTSXCell',
		'FDHellboundCell',
		'FDAlienVendettaCell',
		'FDWhitemareCell'
	};

	static const name BFG_COLLECT_COUNTERS[] = {
		'FDPlutBFGAmmoCollectCounter',
		'FDTNTBFGAmmoCollectCounter',
		'FDDoom2BFGAmmoCollectCounter',
		'FDAliensBFGAmmoCollectCounter',
		'FDJPCPBFGAmmoCollectCounter',
		'FDBTSXBFGAmmoCollectCounter',
		'FDHellboundBFGAmmoCollectCounter',
		'FDAlienVendettaBFGAmmoCollectCounter',
		'FDWhitemareBFGAmmoCollectCounter'
	};

	static const name BFG_CHARGE_TYPES[] = {
		'FDPlutBFGCharge',
		'FDTNTBFGCharge',
		'FDDoom2BFGCharge',
		'FDAliensBFGCharge',
		'FDJPCPBFGCharge',
		'FDBTSXBFGCharge',
		'FDHellboundBFGCharge',
		'FDAlienVendettaBFGCharge',
		'FDWhitemareBFGCharge'
	};

	static bool Customizer()
	{
		name n = 'FDCPlayer';
		return (class<PlayerPawn>)(n) != null;
	}

	static FDX_Theme MainTheme(PlayerPawn pawn)
	{
		static const name TOKENS[] = {
			'FDPlutoniaToken',
			'FDTNTToken',
			'FDDoom2Token',
			'FDAliensToken',
			'FDJPCPToken',
			'FDBTSXToken',
			'FDHellboundToken',
			'FDAlienVendettaToken',
			'FDWhitemareToken'
		};

		for (Inventory i = pawn.Inv; i != null; i = i.Inv)
		{
			if (!(i is 'FDClassToken'))
				continue;

			for (uint j = 0; j < TOKENS.Size(); j++)
				if (i is TOKENS[j])
					return j;
		}

		Object.ThrowAbortException("Player is not of a valid Final Doomer class.");
		return 0;
	}

	static FDX_Theme ShotgunTheme(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return MainTheme(pawn);
		else
			return CVar.GetCVar("FDCShotgunToken").GetInt();
	}

	static FDX_Theme SuperShotgunTheme(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return MainTheme(pawn);
		else
			return CVar.GetCVar("FDCSuperShotgunToken").GetInt();
	}

	static FDX_Theme ChaingunTheme(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return MainTheme(pawn);
		else
			return CVar.GetCVar("FDCChaingunToken").GetInt();
	}

	static FDX_Theme RocketLauncherTheme(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return MainTheme(pawn);
		else
			return CVar.GetCVar("FDCRocketLauncherToken").GetInt();
	}

	static FDX_Theme PlasmaRifleTheme(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return MainTheme(pawn);
		else
			return CVar.GetCVar("FDCPlasmaRifleToken").GetInt();
	}

	static FDX_Theme BFGTheme(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return MainTheme(pawn);
		else
			return CVar.GetCVar("FDCBFG9000Token").GetInt();
	}

	static class<Ammo> BulletType(PlayerPawn pawn)
	{
		if (!Customizer())
			return FDX_Common.BULLET_TYPES[MainTheme(pawn)];
		else
			return 'Clip';
	}

	static class<Ammo> ShellType(PlayerPawn pawn)
	{
		if (!Customizer())
			return FDX_Common.SHELL_TYPES[MainTheme(pawn)];
		else
			return 'Shell';
	}

	static class<Ammo> RocketAmmoType(PlayerPawn pawn)
	{
		if (!Customizer())
			return FDX_Common.ROCKETAMMO_TYPES[MainTheme(pawn)];
		else
			return 'RocketAmmo';
	}

	static class<Ammo> CellType(PlayerPawn pawn)
	{
		if (!Customizer())
			return FDX_Common.CELL_TYPES[MainTheme(pawn)];
		else
			return 'Cell';
	}

	static class<Inventory> BFGCollectCounterType(PlayerPawn pawn)
	{
		return FDX_Common.BFG_COLLECT_COUNTERS[BFGTheme(pawn)];
	}

	static class<Inventory> BFGChargeType(PlayerPawn pawn)
	{
		return FDX_Common.BFG_CHARGE_TYPES[BFGTheme(pawn)];
	}

	private static bool AmmoFull(Inventory item)
	{
		if (item == null)
			return false;

		return item.Amount >= item.MaxAmount;
	}

	static bool BulletsFull(PlayerPawn pawn)
	{
		return AmmoFull(pawn.FindInventory(BulletType(pawn)));
	}

	static bool ShellsFull(PlayerPawn pawn)
	{
		return AmmoFull(pawn.FindInventory(ShellType(pawn)));
	}

	static bool RocketAmmoFull(PlayerPawn pawn)
	{
		return AmmoFull(pawn.FindInventory(RocketAmmoType(pawn)));
	}

	static bool CellsFull(PlayerPawn pawn)
	{
		return AmmoFull(pawn.FindInventory(CellType(pawn)));
	}

	static bool BFGFull(PlayerPawn pawn)
	{
		let cc_t = BFGCollectCounterType(pawn);
		let charge_t = BFGChargeType(pawn);

		let charge = pawn.FindInventory(charge_t);

		if (charge == null)
		{
			pawn.GiveInventory(charge_t, 0);
			charge = pawn.FindInventory(charge_t);
		}

		let cc = pawn.FindInventory(cc_t);

		if (cc == null)
		{
			pawn.GiveInventory(cc_t, 0);
			cc = pawn.FindInventory(cc_t);
		}

		if (charge.Amount >= charge.MaxAmount)
			return false;
		else
			return cc.Amount >= cc.MaxAmount;
	}

	private static bool AmmoHasFreeCapacity(Inventory item, uint amount)
	{
		if (item == null)
			return true;

		return (item.MaxAmount - item.Amount) >= amount;
	}

	static bool HasFreeBulletCapacity(PlayerPawn pawn, uint amount)
	{
		return AmmoHasFreeCapacity(pawn.FindInventory(BulletType(pawn)), amount);
	}

	static bool HasFreeShellCapacity(PlayerPawn pawn, uint amount)
	{
		return AmmoHasFreeCapacity(pawn.FindInventory(ShellType(pawn)), amount);
	}

	static bool HasFreeRocketAmmoCapacity(PlayerPawn pawn, uint amount)
	{
		return AmmoHasFreeCapacity(pawn.FindInventory(RocketAmmoType(pawn)), amount);
	}

	static bool HasFreeCellCapacity(PlayerPawn pawn, uint amount)
	{
		return AmmoHasFreeCapacity(pawn.FindInventory(CellType(pawn)), amount);
	}

	static bool HasFreeBFGCapacity(PlayerPawn pawn, uint amount)
	{
		let cc_t = BFGCollectCounterType(pawn);
		let charge_t = BFGChargeType(pawn);

		let charge = pawn.FindInventory(charge_t);

		if (charge == null)
		{
			pawn.GiveInventory(charge_t, 0);
			charge = pawn.FindInventory(charge_t);
		}

		let cc = pawn.FindInventory(cc_t);

		if (cc == null)
		{
			pawn.GiveInventory(cc_t, 0);
			cc = pawn.FindInventory(cc_t);
		}

		let openCharge = (charge.MaxAmount - charge.Amount) * cc.MaxAmount;
		let openCC = (cc.MaxAmount - cc.Amount) + openCharge;
		return openCC > amount;
	}
}

enum FDX_Theme
{
	FDX_THEME_PLUTONIA,
	FDX_THEME_TNT,
	FDX_THEME_DOOM2,
	FDX_THEME_ANCIENTALIENS,
	FDX_THEME_JPCP,
	FDX_THEME_BTSX,
	FDX_THEME_HELLBOUND,
	FDX_THEME_ALIENVENDETTA,
	FDX_THEME_WHITEMARE
}

enum FDX_ItemVisual
{
	FDX_ITEMVIS_GENERIC = 0,
	FDX_ITEMVIS_NORMAL = 1,
	FDX_ITEMVIS_FANCYGENERIC = 2
}

enum FDX_DynVisual
{
	FDX_DYNVIS_ALL = 0,
	FDX_DYNVIS_DYNAMIC = 1
}
