struct FDX_Utils play
{
	static clearscope bool InvMaxed(Actor owner, class<Inventory> type)
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

	static const name PISTOL_TYPES[] = {
		'FDPlutPistol',
		'FDTNTPistol',
		'FDDoom2Pistol',
		'FDAliensPistol',
		'FDJPCPPistol',
		'FDBTSXPistol',
		'FDAlienVendettaPistol',
		'FDHellboundPistol',
		'FDWhitemarePistol'
	};

	static const name PISTOL_TYPES_CUSTOMIZER[] = {
		'FDCPlutPistol',
		'FDCTNTPistol',
		'FDCDoom2Pistol',
		'FDCAliensPistol',
		'FDCJPCPPistol',
		'FDCBTSXPistol',
		'FDCAlienVendettaPistol',
		'FDCHellboundPistol',
		'FDCWhitemarePistol'
	};

	static const name BFG_TYPES[] = {
		'FDPlutBFG9000',
		'FDTNTBFG9000',
		'FDDoom2BFG9000',
		'FDAliensBFG9000',
		'FDJPCPBFG9000',
		'FDBTSXBFG9000',
		'FDAlienVendettaBFG9000',
		'FDHellboundBFG9000',
		'FDWhitemareBFG9000'
	};

	static const name BFG_TYPES_CUSTOMIZER[] = {
		'FDCPlutBFG9000',
		'FDCTNTBFG9000',
		'FDCDoom2BFG9000',
		'FDCAliensBFG9000',
		'FDCJPCPBFG9000',
		'FDCBTSXBFG9000',
		'FDCAlienVendettaBFG9000',
		'FDCHellboundBFG9000',
		'FDCWhitemareBFG9000'
	};

	static clearscope bool Customizer()
	{
		name n = 'FDCPlayer';
		return (class<PlayerPawn>)(n) != null;
	}

	static clearscope FDX_Theme MainTheme(PlayerPawn pawn)
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

		return int.MAX;
	}

	static clearscope FDX_Theme ChainsawTheme(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return MainTheme(pawn);
		else
			return CVar.GetCVar("FDCChainsawToken").GetInt();
	}

	static clearscope FDX_Theme ShotgunTheme(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return MainTheme(pawn);
		else
			return CVar.GetCVar("FDCShotgunToken").GetInt();
	}

	static clearscope FDX_Theme SuperShotgunTheme(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return MainTheme(pawn);
		else
			return CVar.GetCVar("FDCSuperShotgunToken").GetInt();
	}

	static clearscope FDX_Theme ChaingunTheme(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return MainTheme(pawn);
		else
			return CVar.GetCVar("FDCChaingunToken").GetInt();
	}

	static clearscope FDX_Theme RocketLauncherTheme(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return MainTheme(pawn);
		else
			return CVar.GetCVar("FDCRocketLauncherToken").GetInt();
	}

	static clearscope FDX_Theme PlasmaRifleTheme(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return MainTheme(pawn);
		else
			return CVar.GetCVar("FDCPlasmaRifleToken").GetInt();
	}

	static clearscope FDX_Theme BFGTheme(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return MainTheme(pawn);
		else
			return CVar.GetCVar("FDCBFG9000Token").GetInt();
	}

	static clearscope class<Ammo> BulletType(PlayerPawn pawn)
	{
		if (!Customizer())
			return FDX_Common.BULLET_TYPES[MainTheme(pawn)];
		else
			return 'Clip';
	}

	static clearscope class<Ammo> ShellType(PlayerPawn pawn)
	{
		if (!Customizer())
			return FDX_Common.SHELL_TYPES[MainTheme(pawn)];
		else
			return 'Shell';
	}

	static clearscope class<Ammo> RocketAmmoType(PlayerPawn pawn)
	{
		if (!Customizer())
			return FDX_Common.ROCKETAMMO_TYPES[MainTheme(pawn)];
		else
			return 'RocketAmmo';
	}

	static clearscope class<Ammo> CellType(PlayerPawn pawn)
	{
		if (!Customizer())
			return FDX_Common.CELL_TYPES[MainTheme(pawn)];
		else
			return 'Cell';
	}

	static clearscope class<Inventory> BFGCollectCounterType(PlayerPawn pawn)
	{
		return FDX_Common.BFG_COLLECT_COUNTERS[BFGTheme(pawn)];
	}

	static clearscope class<Inventory> BFGChargeType(PlayerPawn pawn)
	{
		return FDX_Common.BFG_CHARGE_TYPES[BFGTheme(pawn)];
	}

	private static clearscope bool AmmoFull(Inventory item)
	{
		if (item == null)
			return false;

		return item.Amount >= item.MaxAmount;
	}

	static clearscope bool BulletsFull(PlayerPawn pawn)
	{
		return AmmoFull(pawn.FindInventory(BulletType(pawn)));
	}

	static clearscope bool ShellsFull(PlayerPawn pawn)
	{
		return AmmoFull(pawn.FindInventory(ShellType(pawn)));
	}

	static clearscope bool RocketAmmoFull(PlayerPawn pawn)
	{
		return AmmoFull(pawn.FindInventory(RocketAmmoType(pawn)));
	}

	static clearscope bool CellsFull(PlayerPawn pawn)
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

		return charge.Amount >= charge.MaxAmount && cc.Amount >= cc.MaxAmount;
	}

	private static clearscope bool AmmoHasFreeCapacity(Inventory item, uint amount)
	{
		if (item == null)
			return true;

		return (item.MaxAmount - item.Amount) >= amount;
	}

	static clearscope bool HasFreeBulletCapacity(PlayerPawn pawn, uint amount)
	{
		return AmmoHasFreeCapacity(pawn.FindInventory(BulletType(pawn)), amount);
	}

	static clearscope bool HasFreeShellCapacity(PlayerPawn pawn, uint amount)
	{
		return AmmoHasFreeCapacity(pawn.FindInventory(ShellType(pawn)), amount);
	}

	static clearscope bool HasFreeRocketAmmoCapacity(PlayerPawn pawn, uint amount)
	{
		return AmmoHasFreeCapacity(pawn.FindInventory(RocketAmmoType(pawn)), amount);
	}

	static clearscope bool HasFreeCellCapacity(PlayerPawn pawn, uint amount)
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

	static clearscope class<Weapon> PistolType(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return FDX_Common.PISTOL_TYPES[MainTheme(pawn)];
		else
			return FDX_Common.PISTOL_TYPES_CUSTOMIZER[BFGTheme(pawn)];
	}

	static clearscope class<Weapon> BFGType(PlayerPawn pawn)
	{
		if (!Customizer() || !(pawn is 'FDCPlayer'))
			return FDX_Common.BFG_TYPES[MainTheme(pawn)];
		else
			return FDX_Common.BFG_TYPES_CUSTOMIZER[BFGTheme(pawn)];
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
	FDX_THEME_WHITEMARE,
	__FDX_THEME_COUNT__
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

enum FDX_BFGAmmoSystem
{
	FDX_BFGAMMO_ALLLARGE,
	FDX_BFGAMMO_FROMCELL,
	FDX_BFGAMMO_CELLSEPARATE,
	FDX_BFGAMMO_LARGESEPARATE,
	FDX_BFGAMMO_VANILLA,
}

enum FDX_PistolAmmoSystem
{
	FDX_PISTOLAMMO_INFINITE,
	FDX_PISTOLAMMO_BULLET,
}
