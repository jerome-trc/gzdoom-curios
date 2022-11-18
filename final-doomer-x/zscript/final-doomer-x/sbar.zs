class FDX_StatusBar : BaseStatusBar
{
	private CVar JPCPAltHUD;

	private FDX_SBarDrawData DrawData;

	private FDX_Theme Theme;
	private FDX_SBarPlayerTypes PlayerTypes;

	private Inventory CurrentArmor, CurrentAmmo;
	private FDX_Interpolator
		HealthInterpolator, ArmorInterpolator,
		Ammo1Interpolator, HeatInterpolator,
		BulletInterpolator, BulletCapacityInterpolator,
		ShellInterpolator, ShellCapacityInterpolator,
		RocketAmmoInterpolator, RocketAmmoCapacityInterpolator,
		CellInterpolator, CellCapacityInterpolator,
		BFGChargeInterpolator;

	private InventoryBarState InvBarState;

	final override void Init()
	{
		super.Init();
		SetSize(32, 320, 200);
		InvBarState = InventoryBarState.Create();

		HealthInterpolator.SetDefaults();
		ArmorInterpolator.SetDefaults();
		Ammo1Interpolator.SetDefaults();
		HeatInterpolator.SetDefaults();

		BulletInterpolator.SetDefaults();
		ShellInterpolator.SetDefaults();
		RocketAmmoInterpolator.SetDefaults();
		CellInterpolator.SetDefaults();
		BFGChargeInterpolator.SetDefaults();

		BulletCapacityInterpolator.SetDefaults();
		ShellCapacityInterpolator.SetDefaults();
		RocketAmmoCapacityInterpolator.SetDefaults();
		CellCapacityInterpolator.SetDefaults();
	}

	private static HUDFont CreateHUDFont(Font f)
	{
		return HUDFont.Create(f, f.GetCharWidth("0"), Mono_CellLeft);
	}

	final override void AttachToPlayer(PlayerInfo player)
	{
		super.AttachToPlayer(player);

		if (player.MO == null)
		{
			// ???
			return;
		}

		Theme = FDX_Common.MainTheme(player.MO);
		CurrentArmor = player.MO.FindInventory('BasicArmor');

		switch (Theme)
		{
		case FDX_THEME_PLUTONIA:
			DrawData.SmallFont = CreateHUDFont('INDEXFONT_DOOM');
			DrawData.BigFont = CreateHUDFont('HUDFONT_DOOM');
			DrawData.HealthBackground = 'FLHEALTH';
			DrawData.ArmorBackground = 'FLARMOR';
			DrawData.PercentSign = 'STTPRCNT';
			DrawData.AmmoBackground = 'FLAMMO';
			DrawData.KeysBackground = 'FLKEYS';
			DrawData.CapacitiesBackground = 'FLPCAPS';
			DrawData.BFGChargeBarFrame = 'FLBFGPLU';
			DrawData.BFGChargeBar = 'FLBFGBAR';
			DrawData.BFGChargeBarBackground = 'FLBFGBAK';

			DrawData.HealthTextPos = (43, -29);
			DrawData.ArmorBackgroundPos = (87, -15);
			DrawData.InvSelPos = (-26, -83);
			DrawData.BFGChargeBarFramePos = (-84, -32);
			DrawData.BFGChargeBarPos = (-82, -29);
			break;
		case FDX_THEME_TNT:
			DrawData.SmallFont = CreateHUDFont('INDEXFONT_DOOM');
			DrawData.BigFont = CreateHUDFont('HUDFONT_DOOM');
			DrawData.HealthBackground = 'FLHEALTH';
			DrawData.ArmorBackground = 'FLARMOR';
			DrawData.PercentSign = 'STTPRCNT';
			DrawData.AmmoBackground = 'FLAMMO';
			DrawData.KeysBackground = 'FLKEYS';
			DrawData.CapacitiesBackground = 'FLTCAPS';
			DrawData.BFGChargeBarFrame = 'FLBFGPLU';
			DrawData.BFGChargeBar = 'FLBFGBAR';
			DrawData.BFGChargeBarBackground = 'FLBFGBAK';

			DrawData.HealthTextPos = (43, -29);
			DrawData.ArmorBackgroundPos = (87, -15);
			DrawData.InvSelPos = (-26, -83);
			DrawData.BFGChargeBarFramePos = (-84, -32);
			DrawData.BFGChargeBarPos = (-82, -29);
			break;
		case FDX_THEME_DOOM2:
			DrawData.SmallFont = CreateHUDFont('FDFONT_SDOOM2');
			DrawData.BigFont = CreateHUDFont('FDFONT_DOOM2');
			DrawData.PercentSign = 'D2PRCNT';
			DrawData.HealthBackground = 'FLDHEALT';
			DrawData.ArmorBackground = 'FLDARMOR';
			DrawData.AmmoBackground = 'FLDAMMO';
			DrawData.KeysBackground = 'FLDKEYS';
			DrawData.CapacitiesBackground = 'FLDCAPS';
			DrawData.BFGChargeBarFrame = 'FLBFGDM2';
			DrawData.BFGChargeBar = 'FLBFGBAR';
			DrawData.BFGChargeBarBackground = 'FLBFGBAK';

			DrawData.HealthTextPos = (43, -29);
			DrawData.ArmorBackgroundPos = (87, -15);
			DrawData.InvSelPos = (-26, -86);
			DrawData.BFGChargeBarFramePos = (-84, -32);
			DrawData.BFGChargeBarPos = (-82, -29);
			break;
		case FDX_THEME_ANCIENTALIENS:
			DrawData.SmallFont = CreateHUDFont('FDFONT_SALIENS');
			DrawData.BigFont = CreateHUDFont('FDFONT_ALIENS');
			DrawData.PercentSign = 'AAPRCNT';
			DrawData.HealthBackground = 'FLAHEALT';
			DrawData.ArmorBackground = 'FLAARMOR';
			DrawData.AmmoBackground = 'FLAAMMO';
			DrawData.KeysBackground = 'FLAKEYS';
			DrawData.CapacitiesBackground = 'FLACAPS';
			DrawData.BFGChargeBarFrame = 'FLBFGDM2';
			DrawData.BFGChargeBar = 'FLBFGBAR';
			DrawData.BFGChargeBarBackground = 'FLBFGBAK';

			DrawData.HealthTextPos = (42, -29);
			DrawData.ArmorBackgroundPos = (87, -15);
			DrawData.InvSelPos = (-26, -86);
			DrawData.BFGChargeBarFramePos = (-84, -32);
			DrawData.BFGChargeBarPos = (-82, -29);
			break;
		case FDX_THEME_JPCP:
			JPCPAltHUD = CVar.GetCVar("FD_jpcphud", player);

			DrawData.SmallFont = CreateHUDFont('FDFONT_SDOOM2');
			DrawData.HealthTextPos = (43, -29);
			DrawData.ArmorBackgroundPos = (87, -15);
			DrawData.BFGChargeBarFrame = 'JORBBACK';
			DrawData.BFGChargeBar = 'JORB1';
			DrawData.BFGChargeBarBackground = 'JORBBACK';
			DrawData.InvSelPos = (-26, -86);
			DrawData.BFGChargeBarFramePos = (-90, -63);
			DrawData.BFGChargeBarPos = (-90, -63);

			if (JPCPAltHUD.GetBool())
			{
				DrawData.BigFont = CreateHUDFont('FDFONT_JPCP');
				DrawData.PercentSign = 'JPPRCT';
				DrawData.HealthBackground = 'FLJHEAL2';
				DrawData.ArmorBackground = 'FLJARMO2';
				DrawData.AmmoBackground = 'FLJAMMO2';
				DrawData.KeysBackground = 'FLJKEYS';
				DrawData.CapacitiesBackground = 'FLJCAPS2';
			}
			else
			{
				DrawData.BigFont = CreateHUDFont('FDFONT_DOOM2');
				DrawData.PercentSign = 'D2PRCNT';
				DrawData.HealthBackground = 'FLJHEALT';
				DrawData.ArmorBackground = 'FLJARMOR';
				DrawData.AmmoBackground = 'FLJAMMO';
				DrawData.KeysBackground = 'FLJKEYS';
				DrawData.CapacitiesBackground = 'FLJCAPS';
			}

			break;
		case FDX_THEME_BTSX:
			DrawData.SmallFont = CreateHUDFont('FDFONT_SBTSX');
			DrawData.BigFont = CreateHUDFont('FDFONT_BTSX');
			DrawData.PercentSign = 'BTSXPRCT';
			DrawData.HealthBackground = 'FLXHEALT';
			DrawData.ArmorBackground = 'FLXARMOR';
			DrawData.AmmoBackground = 'FLXAMMO';
			DrawData.KeysBackground = 'FLXKEYS';
			DrawData.CapacitiesBackground = 'FLXCAPS';
			// No BFG charge bar frame
			DrawData.BFGChargeBar = 'FLXBFG2';
			DrawData.BFGChargeBarBackground = 'FLXBFG1';

			DrawData.HealthTextPos = (43, -29);
			DrawData.ArmorBackgroundPos = (86, -15);
			DrawData.InvSelPos = (-26, -86);
			DrawData.BFGChargeBarPos = (-76, -24);
			break;
		case FDX_THEME_HELLBOUND:
			DrawData.SmallFont = CreateHUDFont('FDFONT_SDOOM2');
			DrawData.BigFont = CreateHUDFont('FDFONT_HELLBOUND');
			DrawData.PercentSign = 'HBPRCNT';
			DrawData.HealthBackground = 'FLHHEALT';
			DrawData.ArmorBackground = 'FLHARMOR';
			DrawData.AmmoBackground = 'FLHAMMO';
			DrawData.KeysBackground = 'FLHKEYS';
			DrawData.CapacitiesBackground = 'FLHCAPS';
			DrawData.BFGChargeBarFrame = 'FLBFGHB';
			DrawData.BFGChargeBar = 'FLBFGBAR';
			DrawData.BFGChargeBarBackground = 'FLBFGBAK';

			DrawData.HealthTextPos = (43, -29);
			DrawData.ArmorBackgroundPos = (87, -15);
			DrawData.InvSelPos = (-26, -86);
			DrawData.BFGChargeBarFramePos = (-84, -32);
			DrawData.BFGChargeBarPos = (-82, -29);
			break;
		case FDX_THEME_ALIENVENDETTA:
			DrawData.SmallFont = CreateHUDFont('FDFONT_SALIENVENDETTA');
			DrawData.BigFont = CreateHUDFont('FDFONT_ALIENVENDETTA');
			DrawData.PercentSign = 'AVPRCNT';
			DrawData.HealthBackground = 'FLVHEALT';
			DrawData.ArmorBackground = 'FLVARMOR';
			DrawData.AmmoBackground = 'FLVAMMO';
			DrawData.KeysBackground = 'FLVKEYS';
			DrawData.CapacitiesBackground = 'FLVCAPS';
			DrawData.BFGChargeBarFrame = 'FLBFGAV';
			DrawData.BFGChargeBar = 'FLAVBFG';
			DrawData.BFGChargeBarBackground = 'FLBFGBAK';

			DrawData.HealthTextPos = (43, -29);
			DrawData.ArmorBackgroundPos = (87, -15);
			DrawData.InvSelPos = (-26, -86);
			DrawData.BFGChargeBarFramePos = (-81, -32);
			DrawData.BFGChargeBarPos = (-79, -29);
			break;
		case FDX_THEME_WHITEMARE:
			DrawData.SmallFont = CreateHUDFont('FDFONT_SALIENVENDETTA');
			DrawData.BigFont = CreateHUDFont('FDFONT_ALIENVENDETTA');
			DrawData.PercentSign = 'AVPRCNT';
			DrawData.HealthBackground = 'FLWHEALT';
			DrawData.ArmorBackground = 'FLWARMOR';
			DrawData.AmmoBackground = 'FLWAMMO';
			DrawData.KeysBackground = 'FLWKEYS';
			DrawData.CapacitiesBackground = 'FLWCAPS';
			DrawData.BFGChargeBarFrame = 'FLWBFG1';
			DrawData.BFGChargeBar = 'FLWBFG2';
			DrawData.BFGChargeBarBackground = 'FLBFGBAK';

			DrawData.HealthTextPos = (43, -29);
			DrawData.ArmorBackgroundPos = (87, -15);
			DrawData.InvSelPos = (-26, -86);
			DrawData.BFGChargeBarFramePos = (-84, -32);
			DrawData.BFGChargeBarPos = (-82, -29);
			break;
		default:
			Object.ThrowAbortException(
				"Player is not of a valid Final Doomer class."
			);
		}

		InvBarState.AmountFont = DrawData.SmallFont;

		PlayerTypes.Bullet = FDX_Common.BulletType(player.MO);
		PlayerTypes.Shell = FDX_Common.ShellType(player.MO);
		PlayerTypes.RocketAmmo = FDX_Common.RocketAmmoType(player.MO);
		PlayerTypes.Cell = FDX_Common.CellType(player.MO);
		PlayerTypes.BFGCharge = FDX_Common.BFGChargeType(player.MO);

		PlayerTypes.Pistol = FDX_Common.PistolType(player.MO);
		PlayerTypes.BFG = FDX_Common.BFGType(player.MO);

		name fdcWhitemareChainsaw_tn = 'FDCWhitemareChainsaw';
		let fdcWhitemareChainsaw_t = (class<Weapon>)(fdcWhitemareChainsaw_tn);

		if (fdcWhitemareChainsaw_t != null)
			PlayerTypes.WhitemareChainsaw = fdcWhitemareChainsaw_t;
		else
			PlayerTypes.WhitemareChainsaw = 'FDWhitemareChainsaw';
	}

	final override void Tick()
	{
		super.Tick();

		HealthInterpolator.Update(CPlayer.Health);
		ArmorInterpolator.Update(CPlayer.MO.CountInv('BasicArmor'));

		CurrentAmmo = null;

		for (Inventory i = CPlayer.MO.Inv; i != null; i = i.Inv)
		{
			if (CurrentAmmo == null &&
				CPlayer.ReadyWeapon != null &&
				i.GetClass() == CPlayer.ReadyWeapon.AmmoType1)
			{
				CurrentAmmo = i;
			}
			if (i.GetClass() == PlayerTypes.Bullet)
			{
				if (CPlayer.ReadyWeapon is PlayerTypes.Pistol &&
					CVar.GetCVar("FD_pistolammo", CPlayer).GetInt() == FDX_PISTOLAMMO_BULLET)
				{
					CurrentAmmo = i;
				}

				BulletInterpolator.Update(i.Amount);
				BulletCapacityInterpolator.Update(i.MaxAmount);
			}
			else if (i.GetClass() == PlayerTypes.Shell)
			{
				ShellInterpolator.Update(i.Amount);
				ShellCapacityInterpolator.Update(i.MaxAmount);
			}
			else if (i.GetClass() == PlayerTypes.RocketAmmo)
			{
				RocketAmmoInterpolator.Update(i.Amount);
				RocketAmmoCapacityInterpolator.Update(i.MaxAmount);
			}
			else if (i.GetClass() == PlayerTypes.Cell)
			{
				if (CPlayer.ReadyWeapon is PlayerTypes.BFG &&
					FD_bfgammosystem == FDX_BFGAMMO_VANILLA)
				{
					CurrentAmmo = i;
				}

				CellInterpolator.Update(i.Amount);
				CellCapacityInterpolator.Update(i.MaxAmount);
			}
			else if (i.GetClass() == PlayerTypes.BFGCharge)
			{
				if (CPlayer.ReadyWeapon is PlayerTypes.BFG &&
					FD_bfgammosystem != FDX_BFGAMMO_VANILLA)
				{
					CurrentAmmo = i;
				}

				BFGChargeInterpolator.Update(i.Amount);
			}
			else if (i is 'FDWhitemareHeatLevel')
			{
				HeatInterpolator.Update(i.Amount);
			}
		}

		if (CurrentAmmo != null)
			Ammo1Interpolator.Update(CurrentAmmo.Amount);
		else
			Ammo1Interpolator.Update(0);

		if (Theme == FDX_THEME_JPCP)
		{
			if (JPCPAltHUD.GetBool())
			{
				DrawData.BigFont = CreateHUDFont('FDFONT_JPCP');
				DrawData.PercentSign = 'JPPRCT';
				DrawData.HealthBackground = 'FLJHEAL2';
				DrawData.ArmorBackground = 'FLJARMO2';
				DrawData.AmmoBackground = 'FLJAMMO2';
				DrawData.CapacitiesBackground = 'FLJCAPS2';
				InvBarState.AmountFont = DrawData.SmallFont;
			}
			else
			{
				DrawData.BigFont = CreateHUDFont('FDFONT_DOOM2');
				DrawData.PercentSign = 'D2PRCNT';
				DrawData.HealthBackground = 'FLJHEALT';
				DrawData.ArmorBackground = 'FLJARMOR';
				DrawData.AmmoBackground = 'FLJAMMO';
				DrawData.CapacitiesBackground = 'FLJCAPS';
				InvBarState.AmountFont = DrawData.SmallFont;
			}
		}
	}

	final override void Draw(int state, double ticFrac)
	{
		super.Draw(state, ticFrac);

		if (state == HUD_StatusBar)
		{
			BeginStatusBar();
			DrawMainBar(TicFrac);
		}
		else if (state == HUD_Fullscreen)
		{
			BeginHUD();
			DrawFullscreenHUD_Health();
			DrawFullscreenHUD_WhitemareChainsaw();
			DrawFullscreenHUD_Armor();
			DrawFullscreenHUD_Ammo();
			DrawFullscreenHUD_AllAmmoCounts();
			DrawFullscreenHUD_AllAmmoCapacities();
			DrawFullscreenHUD_BFGChargeBar();
			DrawFullscreenHUD_Keys();
			DrawFullScreenHUD_Inventory();
		}
	}

	private void DrawMainBar(double TicFrac) const
	{
		// Soon!
	}
}

// Common fullscreen drawing functions.
extend class FDX_StatusBar
{
	private void DrawFullscreenHUD_Health() const
	{
		DrawImage(DrawData.HealthBackground, (29, -15), DI_ITEM_CENTER);

		if (CPlayer.MO.FindInventory('PowerStrength', true) != null)
		{
			DrawImage(
				'PSTRA0',
				(29, -22),
				DI_ITEM_CENTER | DI_FORCESCALE,
				alpha: 0.4,
				box: (46, 20)
			);
		}

		DrawString(
			DrawData.BigFont,
			FormatNumber(HealthInterpolator.CurrentValue, 1, 3),
			DrawData.HealthTextPos,
			DI_TEXT_ALIGN_RIGHT,
			Font.CR_UNTRANSLATED
		);

		DrawImage(DrawData.PercentSign, DrawData.HealthTextPos, DI_ITEM_LEFT_TOP);
	}

	private void DrawFullscreenHUD_Armor() const
	{
		DrawImage(DrawData.ArmorBackground, (87, -15), DI_ITEM_CENTER);

		if (CurrentArmor.Amount > 0)
		{
			DrawInventoryIcon(
				CurrentArmor,
				(87, -21),
				DI_ITEM_CENTER | DI_FORCESCALE,
				0.4,
				(58, 16)
			);
		}

		DrawString(
			DrawData.BigFont,
			FormatNumber(ArmorInterpolator.CurrentValue, 1, 3),
			(101, -29),
			DI_TEXT_ALIGN_RIGHT,
			Font.CR_UNTRANSLATED
		);

		DrawImage(DrawData.PercentSign, (101, -29), DI_ITEM_LEFT_TOP);

	}

	private void DrawFullscreenHUD_Ammo() const
	{
		DrawImage(DrawData.AmmoBackground, (-23, -48), DI_ITEM_CENTER);
		DrawImage(DrawData.KeysBackground, (-52, -47), DI_ITEM_CENTER);

		// The Customizer uses vanilla's generic ammo types instead of FD's
		// class-specific ammo types. Draw the icons for the latter if necessary

		if (CurrentAmmo == null)
			return;
		
		let icon = CurrentAmmo.Icon;
		
		if (CurrentAmmo is 'Clip')
		{
			let ammo_t = (class<Ammo>)(FDX_Common.BULLET_TYPES[Theme]);
			icon = GetDefaultByType(ammo_t).Icon;
		}
		else if (CurrentAmmo is 'Shell')
		{
			let ammo_t = (class<Ammo>)(FDX_Common.SHELL_TYPES[Theme]);
			icon = GetDefaultByType(ammo_t).Icon;
		}
		else if (CurrentAmmo is 'RocketAmmo')
		{
			let ammo_t = (class<Ammo>)(FDX_Common.ROCKETAMMO_TYPES[Theme]);
			icon = GetDefaultByType(ammo_t).Icon;
		}
		else if (CurrentAmmo is 'Cell')
		{
			let ammo_t = (class<Ammo>)(FDX_Common.CELL_TYPES[Theme]);
			icon = GetDefaultByType(ammo_t).Icon;
		}

		DrawTexture(
			icon,
			(-23, -54),
			DI_ITEM_CENTER | DI_FORCESCALE,
			0.4,
			(32, 14)
		);

		DrawString(
			DrawData.BigFont,
			FormatNumber(Ammo1Interpolator.CurrentValue, 1, 3),
			(-2, -61),
			DI_TEXT_ALIGN_RIGHT,
			Font.CR_UNTRANSLATED
		);
	}

	private void DrawFullscreenHUD_AllAmmoCounts() const
	{
		DrawImage(DrawData.CapacitiesBackground, (-36, -15), DI_ITEM_CENTER);

		DrawString(
			DrawData.SmallFont,
			FormatNumber(BulletInterpolator.CurrentValue, 1, 3),
			(-33, -27),
			DI_TEXT_ALIGN_RIGHT,
			Font.CR_UNTRANSLATED
		);

		DrawString(
			DrawData.SmallFont,
			FormatNumber(ShellInterpolator.CurrentValue, 1, 3),
			(-33, -21),
			DI_TEXT_ALIGN_RIGHT,
			Font.CR_UNTRANSLATED
		);

		DrawString(
			DrawData.SmallFont,
			FormatNumber(RocketAmmoInterpolator.CurrentValue, 1, 3),
			(-33, -15),
			DI_TEXT_ALIGN_RIGHT,
			Font.CR_UNTRANSLATED
		);

		DrawString(
			DrawData.SmallFont,
			FormatNumber(CellInterpolator.CurrentValue, 1, 3),
			(-33, -9),
			DI_TEXT_ALIGN_RIGHT,
			Font.CR_UNTRANSLATED
		);
	}

	private void DrawFullscreenHUD_AllAmmoCapacities() const
	{
		DrawString(
			DrawData.SmallFont,
			FormatNumber(BulletCapacityInterpolator.CurrentValue, 1, 3),
			(-7, -27),
			DI_TEXT_ALIGN_RIGHT,
			Font.CR_UNTRANSLATED
		);

		DrawString(
			DrawData.SmallFont,
			FormatNumber(ShellCapacityInterpolator.CurrentValue, 1, 3),
			(-7, -21),
			DI_TEXT_ALIGN_RIGHT,
			Font.CR_UNTRANSLATED
		);

		DrawString(
			DrawData.SmallFont,
			FormatNumber(RocketAmmoCapacityInterpolator.CurrentValue, 1, 3),
			(-7, -15),
			DI_TEXT_ALIGN_RIGHT,
			Font.CR_UNTRANSLATED
		);

		DrawString(
			DrawData.SmallFont,
			FormatNumber(CellCapacityInterpolator.CurrentValue, 1, 3),
			(-7, -9),
			DI_TEXT_ALIGN_RIGHT,
			Font.CR_UNTRANSLATED
		);
	}

	private void DrawFullscreenHUD_BFGChargeBar() const
	{
		DrawImage(
			DrawData.BFGChargeBarFrame,
			DrawData.BFGChargeBarFramePos,
			DI_ITEM_LEFT_TOP
		);

		if (BFGChargeInterpolator.CurrentValue > 0)
		{
			DrawBar(
				DrawData.BFGChargeBar,
				DrawData.BFGChargeBarBackground,
				BFGChargeInterpolator.CurrentValue,
				GetDefaultByType(PlayerTypes.BFGCharge).MaxAmount,
				DrawData.BFGChargeBarPos,
				0,
				SHADER_VERT | SHADER_REVERSE,
				DI_ITEM_LEFT_TOP
			);
		}
	}

	private void DrawFullscreenHUD_Keys() const
	{
		bool locks[6];
		string image;

		locks[0] = CPlayer.MO.CheckKeys(1, false, true);
		locks[1] = CPlayer.MO.CheckKeys(2, false, true);
		locks[2] = CPlayer.MO.CheckKeys(3, false, true);
		locks[3] = CPlayer.MO.CheckKeys(4, false, true);
		locks[4] = CPlayer.MO.CheckKeys(5, false, true);
		locks[5] = CPlayer.MO.CheckKeys(6, false, true);

		if (locks[1] && locks[4])
			image = "STKEYS6";
		else if
			(locks[1]) image = "STKEYS0";
		else if
			(locks[4]) image = "STKEYS3";

		DrawImage(image, (-56, -60), DI_ITEM_OFFSETS);

		if (locks[2] && locks[5])
			image = "STKEYS7";
		else if (locks[2])
			image = "STKEYS1";
		else if (locks[5])
			image = "STKEYS4";
		else
			image = "";

		DrawImage(image, (-56, -50), DI_ITEM_OFFSETS);

		if (locks[0] && locks[3])
			image = "STKEYS8";
		else if (locks[0])
			image = "STKEYS2";
		else if (locks[3])
			image = "STKEYS5";
		else
			image = "";

		DrawImage(image, (-56, -40), DI_ITEM_OFFSETS);
	}

	private void DrawFullScreenHUD_Inventory() const
	{
		if (!IsInventoryBarVisible() && !Level.NoInventoryBar && CPlayer.MO.InvSel != null)
		{
			DrawInventoryIcon(
				CPlayer.MO.InvSel,
				(-14, -71),
				DI_DIMDEPLETED | DI_ITEM_CENTER_BOTTOM
			);

			DrawString(
				DrawData.BigFont,
				FormatNumber(CPlayer.MO.InvSel.Amount, 3),
				DrawData.InvSelPos,
				DI_TEXT_ALIGN_RIGHT,
				Font.CR_UNTRANSLATED
			);
		}

		if (IsInventoryBarVisible())
		{
			DrawInventoryBar(InvBarState, (0, 0), 7, DI_SCREEN_CENTER_BOTTOM);
		}
	}

	private void DrawFullscreenHUD_WhitemareChainsaw()
	{
		Inventory chainsaw = null, overload = null;

		for (Inventory i = CPlayer.MO.Inv; i != null; i = i.Inv)
		{
			if (i is PlayerTypes.WhitemareChainsaw)
				chainsaw = i;
			else if (i is 'FDWhitemareHeatOverload')
				overload = i;
		}

		if (chainsaw == null)
			return;

		DrawImage('STWHEATE', (0, -45), DI_ITEM_LEFT_TOP);

		DrawBar(
			'STWHEAT',
			'STWHEATB',
			HeatInterpolator.CurrentValue,
			GetDefaultByType('FDWhitemareHeatLevel').MaxAmount,
			(2, -43),
			0,
			false,
			DI_ITEM_LEFT_TOP
		);

		if (overload != null && overload.Amount >= 1)
			DrawImage('STWHEATF', (0, -45));
	}
}

// Helpers /////////////////////////////////////////////////////////////////////

// Copied from DynamicValueInterpolator because it has no reason to be a class.
struct FDX_Interpolator
{
	int CurrentValue;
	int MinChange;
	int MaxChange;
	double ChangeFactor;

	void Reset(int value)
	{
		CurrentValue = value;
	}

	void Update(int destvalue)
	{
		int diff = int(
			Clamp(
				Abs(destvalue - CurrentValue) * ChangeFactor,
				MinChange,
				MaxChange
			)
		);

		if (CurrentValue > destvalue)
			CurrentValue = max(destvalue, CurrentValue - diff);
		else
			CurrentValue = min(destvalue, CurrentValue + diff);
	}

	void SetDefaults()
	{
		ChangeFactor = 0.25;
		MinChange = 1;
		MaxChange = 8;
	}
}

struct FDX_SBarPlayerTypes
{
	class<Inventory>
		Bullet, Shell, RocketAmmo, Cell, BFGCharge,
		Pistol, BFG,
		WhitemareChainsaw; // Adapts to Customizer
}

struct FDX_SBarDrawData
{
	HUDFont
		BigFont, SmallFont;
	string // (Rat): Yes I would rather these be textureIDs but the API is whacked
		PercentSign,
		HealthBackground, ArmorBackground,
		AmmoBackground, KeysBackground, CapacitiesBackground,
		BFGChargeBarFrame, BFGChargeBar, BFGChargeBarBackground;
	Vector2
		HealthTextPos, ArmorBackgroundPos,
		BFGChargeBarPos, BFGChargeBarFramePos,
		InvSelPos;
}
