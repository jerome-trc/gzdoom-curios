version "3.7.0"

class rlmal_EventHandler : StaticEventHandler
{
	final override void OnRegister()
	{
		if (self.bDestroyed)
			return;

		name tn = 'RLMonsterPackThingo';

		if ((class<Actor>)(tn) == null)
		{
			if (developer >= 1)
				Console.PrintF("DRLM Maladaptive deactivating.");

			self.Destroy();
		}
		else
		{
			if (developer >= 1)
				Console.PrintF("DRLM Maladaptive is active.");
		}
	}

	final override void CheckReplacement(ReplaceEvent event)
	{
		if (skill != 7)
			return;

		switch (event.replacee.GetClassName())
		{
		case 'RLAdaptiveFormerHuman':
			static const name FORMER_HUMAN_TYPES[] = {
				'RLFormerHumanVariantSpawner',
				'RLEliteFormerHumanSpawner',
				'RLFormerCyborgBattleRifle',
				'RLFormerAssaultTrooper'
			};

			event.replacement = (class<Actor>)(
				FORMER_HUMAN_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptiveFormerSergeant':
			static const name FORMER_SERGEANT_TYPES[] = {
				'RLFormerSergeantVariantSpawner',
				'RLEliteFormerSergeantSpawner',
				'RLEliteFormerSergeantSpawner',
				'RLFormerOverwatch'
			};

			event.replacement = (class<Actor>)(
				FORMER_SERGEANT_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptiveFormerCommando':
			static const name FORMER_COMMANDO_TYPES[] = {
				'RLFormerCommandoAdaptiveSpawner',
				'RLEliteCommandoAdaptiveSpawner',
				'RLEliteCommandoAdaptiveSpawner',
				'RLFormerShocktrooper'
			};

			event.replacement = (class<Actor>)(
				FORMER_COMMANDO_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptiveImp':
			static const name IMP_TYPES[] = {
				'RLImp',
				'RLNightmareImp',
				'RLCyberneticImp',
				'RLArmageddonImp'
			};

			event.replacement = (class<Actor>)(
				IMP_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptiveDemon':
			static const name DEMON_TYPES[] = {
				'RLDemon',
				'RLNightmareDemon',
				'RLCyberneticDemon',
				'RLArmageddonDemon'
			};

			event.replacement = (class<Actor>)(
				DEMON_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptiveSpectre':
			static const name SPECTRE_TYPES[] = {
				'RLSpectre',
				'RLNightmareSpectre',
				'RLCyberneticSpectre',
				'RLNightmareSpectre'
			};

			event.replacement = (class<Actor>)(
				SPECTRE_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptiveLostSoul':
			static const name LOSTSOUL_TYPES[] = {
				'RLLostSoul',
				'RLNightmareLostSoul',
				'RLCyberneticLostSoul',
				'RLTheHungrySpawner'
			};

			event.replacement = (class<Actor>)(
				LOSTSOUL_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptiveCacodemon':
			static const name CACODEMON_TYPES[] = {
				'RLCacodemon',
				'RLNightmareCacodemon',
				'RLNightmareCacodemon',
				'RLArmageddonCacodemon'
			};

			event.replacement = (class<Actor>)(
				CACODEMON_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptiveHellKnight':
			static const name HELLKNIGHT_TYPES[] = {
				'RLHellKnight',
				'RLNightmareHellKnight',
				'RLCyberneticHellKnight',
				'RLCyberneticHellKnight'
			};

			event.replacement = (class<Actor>)(
				HELLKNIGHT_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptiveBaronOfHell':
			static const name HELLBARON_TYPES[] = {
				'RLBaronOfHell',
				'RLNightmareBaronOfHell',
				'RLCyberneticBaronOfHell',
				'RLArmageddonBaronOfHell'
			};

			event.replacement = (class<Actor>)(
				HELLBARON_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptiveArachnotron':
			static const name ARACHNOTRON_TYPES[] = {
				'RLArachnotron',
				'RLNightmareArachnotron',
				'RLCyberneticArachnotron',
				'RLArmageddonArachnotron'
			};

			event.replacement = (class<Actor>)(
				ARACHNOTRON_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptivePainElemental':
			static const name PAINELEMENTAL_TYPES[] = {
				'RLPainElemental',
				'RLNightmarePainElemental',
				'RLCyberneticPainElemental',
				'RLArmageddonPainElemental'
			};

			event.replacement = (class<Actor>)(
				PAINELEMENTAL_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptiveRevenant':
			static const name REVENANT_TYPES[] = {
				'RLRevenant',
				'RLNightmareRevenant',
				'RLCyberneticRevenant',
				'RLArmageddonRevenant'
			};

			event.replacement = (class<Actor>)(
				REVENANT_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptiveMancubus':
			static const name MANCUBUS_TYPES[] = {
				'RLMancubus',
				'RLNightmareMancubus',
				'RLCyberneticMancubus',
				'RLArmageddonMancubus'
			};

			event.replacement = (class<Actor>)(
				MANCUBUS_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptiveArchvile':
			static const name ARCHVILE_TYPES[] = {
				'RLArchvile',
				'RLNightmareArchvile',
				'RLCyberneticArchvile',
				'RLArmageddonArchvile'
			};

			event.replacement = (class<Actor>)(
				ARCHVILE_TYPES[rlmal_EventHandler.RandomCategory()]
			);

			break;
		case 'RLAdaptiveCyberdemon':
			switch (rlmal_EventHandler.RandomCategory())
			{
			case RLMAL_CAT_UV:
				if (RandomPick[rlmal](0, 1, 2, 3) == 0)
				{
					name tn = 'RLBruiserBrother';
					event.replacement = (class<Actor>)(tn);
				}
				else
				{
					name tn = 'RLCyberdemon';
					event.replacement = (class<Actor>)(tn);
				}
			case RLMAL_CAT_NIGHTMARE:
				if (RandomPick[rlmal](0, 1, 2, 3) == 0)
				{
					name tn = 'RLAgonyElemental';
					event.replacement = (class<Actor>)(tn);
				}
				else
				{
					name tn = 'RLNightmareCyberdemon';
					event.replacement = (class<Actor>)(tn);
				}
			case RLMAL_CAT_CYBERNETIC:
				if (RandomPick[rlmal](0, 1, 2, 3) == 0)
				{
					name tn = 'RLTerminator';
					event.replacement = (class<Actor>)(tn);
				}
				else
				{
					name tn = 'RLCyberneticCyberdemon';
					event.replacement = (class<Actor>)(tn);
				}
			case RLMAL_CAT_ARMAGGEDON:
			{
				// TODO: an armageddon cyberdemon may be added here eventually.
				name tn = 'RLAbominant';
				event.replacement = (class<Actor>)(tn);
			}
			}

			break;
		case 'RLAdaptiveSpiderMastermind':
			switch (rlmal_EventHandler.RandomCategory())
			{
			case RLMAL_CAT_UV:
				if (RandomPick[rlmal](0, 1, 2, 3) == 0)
				{
					name tn = 'RLBruiserBrother';
					event.replacement = (class<Actor>)(tn);
				}
				else
				{
					name tn = 'RLSpiderMastermind';
					event.replacement = (class<Actor>)(tn);
				}
			case RLMAL_CAT_NIGHTMARE:
				if (RandomPick[rlmal](0, 1, 2, 3) == 0)
				{
					name tn = 'RLAgonyElemental';
					event.replacement = (class<Actor>)(tn);
				}
				else
				{
					name tn = 'RLNightmareSpiderMastermind';
					event.replacement = (class<Actor>)(tn);
				}
			case RLMAL_CAT_CYBERNETIC:
				if (RandomPick[rlmal](0, 1, 2, 3) == 0)
				{
					name tn = 'RLTerminator';
					event.replacement = (class<Actor>)(tn);
				}
				else
				{
					name tn = 'RLCyberneticSpiderMastermind';
					event.replacement = (class<Actor>)(tn);
				}
			case RLMAL_CAT_ARMAGGEDON:
			{
				// TODO: an armageddon mastermind may be added here eventually.
				name tn = 'RLAbominant';
				event.replacement = (class<Actor>)(tn);
			}
			}

			break;
		default: {}
		}
	}

	// Details /////////////////////////////////////////////////////////////////

	private static rlmal_MonsterCategory RandomCategory()
	{
		uint weightSum =
			rlmal_uvWeight + rlmal_nmWeight + rlmal_cyberWeight + rlmal_armaWeight;

		uint attempts = 0;

		while (attempts < 100)
		{
			uint
				chance = Random[rlmal](1, weightSum),
				runningSum = 0;

			runningSum += rlmal_uvWeight;

			if (chance <= runningSum)
				return RLMAL_CAT_UV;

			runningSum += rlmal_nmWeight;

			if (chance <= runningSum)
				return RLMAL_CAT_NIGHTMARE;

			runningSum += rlmal_cyberWeight;

			if (chance <= runningSum)
				return RLMAL_CAT_CYBERNETIC;

			runningSum += rlmal_armaWeight;

			if (chance <= runningSum)
				return RLMAL_CAT_ARMAGGEDON;

			attempts += 1;
		}

		ThrowAbortException(
			"DRLM Maladaptive failed to make a weighted random choice after 100 attempts.\n"
			"Make sure that not all weights are set to 0 (otherwise this will happen again).\n"
			"If you're certain that your weights are fine, report a bug to RatCircus.\n"
		);

		return uint.MAX;
	}
}

enum rlmal_MonsterCategory : uint8
{
	RLMAL_CAT_UV,
	RLMAL_CAT_NIGHTMARE,
	RLMAL_CAT_CYBERNETIC,
	RLMAL_CAT_ARMAGGEDON,
}

// libtooltipoptionsmenu ///////////////////////////////////////////////////////

// TooltipOptionsMenu -- a drop-in replacement for OptionsMenu with tooltip support.
// See https://github.com/ToxicFrog/doom-mods/tree/main/libtooltipmenu

/*  Copyright © 2022 Rebecca "ToxicFrog" Kelly

	Permission is hereby granted, free of charge, to any person obtaining a copy of
	this software and associated documentation files (the "Software"), to deal in
	the Software without restriction, including without limitation the rights to
	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
	the Software, and to permit persons to whom the Software is furnished to do so,
	subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

// Prefix menu item names with "rlmal_" so as not to hit
// a redefinition error when trying to load this with Gun Bonsai.

class rlmal_Tooltip : Object ui {
	double x, y, w, xpad, ypad, scale; // Geometry
	uint first, last; // First and last menuitems this applies to
	Font font;
	Color colour;
	TextureID texture;
	string text;

	void CopyFrom(rlmal_Tooltip settings) {
		self.x = settings.x;
		self.y = settings.y;
		self.w = settings.w;
		self.xpad = settings.xpad;
		self.ypad = settings.ypad;
		self.scale = settings.scale;
		self.font = settings.font;
		self.colour = settings.colour;
		self.texture = settings.texture;
	}

	int GetX(uint screen_width, uint width) {
		return (screen_width - width) * self.x;
	}

	int GetY(uint screen_width, uint height) {
		return (screen_width - height) * self.y;
	}

	void Draw() {
		// In order to draw the text readably at high resolutions, we calculate
		// everything using a virtual screen size and then tell DrawTexture and
		// DrawText to scale appropriately when blitting the background and tooltip
		// text to the real screen.
		uint virtual_height = screen.GetHeight() / CleanYFac_1 / scale;
		let aspect = screen.GetAspectRatio();
		let virtual_width = virtual_height * aspect;
		// Font metrics: em width and line height.
		let em = self.font.GetCharWidth(0x6D);
		let lh = self.font.GetHeight();
		// Nominal width is the maximum width of the tooltip based on configuration
		// in the MENUDEF.
		let nominal_width = virtual_width * self.w;
		let lines = self.font.BreakLines(self.text, nominal_width);

		// Calculate the real width of the tooltip. This may be less than the
		// nominal width if it's a short one-liner. This is still in virtual screen
		// coordinates, not real screen!
		uint actual_width = 0;
		for (uint i = 0; i < lines.count(); ++i) {
		actual_width = max(actual_width, self.font.StringWidth(lines.StringAt(i)));
		}
		actual_width += self.xpad * 2.0 * em;

		// Calculate the real height based on the number of lines we wrapped it into
		// and the vertical margins.
		uint actual_height = self.font.GetHeight() * (self.ypad * 2.0 + lines.count());

		// Get the coordinates of the top left corner of the tooltip's bounding box,
		// including padding, in virtual screen coordinates.
		uint x = GetX(virtual_width, actual_width);
		uint y = GetY(virtual_height, actual_height);

		// Draw the background texture, if defined. DTA_Virtual* commands it to scale
		// the virtual screen size to match the real screen; DTA_KeepRatio tells it
		// to assume the ratio of the virtual screen matches the real screen. (The
		// documentation on the wiki is wrong here; leaving it false forces a 4:3
		// aspect ratio.)
		Screen.DrawTexture(texture, true, x, y,
			DTA_VirtualWidthF, virtual_width, DTA_VirtualHeight, virtual_height,
			DTA_KeepRatio, true,
			DTA_LeftOffset, 0, DTA_TopOffset, 0,
			DTA_DestWidth, actual_width, DTA_DestHeight, actual_height);

		for (uint i = 0; i < lines.count(); ++i) {
		screen.DrawText(
			self.font, self.colour,
			x + self.xpad*em,
			y + i*lh + self.ypad*lh,
			lines.StringAt(i),
			DTA_VirtualWidthF, virtual_width, DTA_VirtualHeight, virtual_height,
			DTA_KeepRatio, true);
		}
	}
}

class rlmal_TooltipOptionMenu : OptionMenu {
	array<rlmal_Tooltip> tooltips;

	// Default settings:
	// - top left corner
	// - 30% of the screen width
	// - 1em horizontal margin and 0.5lh vertical margin
	// - white text using newsmallfont
	rlmal_Tooltip GetDefaults() {
		let tt = rlmal_Tooltip(new("rlmal_Tooltip"));
		tt.x = tt.y = 0.0;
		tt.w = 0.3;
		tt.xpad = 1.0;
		tt.ypad = 0.5;
		tt.scale = 1.0;
		tt.font = newsmallfont;
		tt.colour = Font.CR_WHITE;
		return tt;
	}

	override void Init(Menu parent, OptionMenuDescriptor desc) {
		super.Init(parent, desc);
		let settings = GetDefaults();

		// If there's already a TooltipHolder in tail position, we've already been
		// initialized and just need to retrieve our saved tooltips from it.
		let tail = OptionMenuItemrlmal_TooltipHolder(desc.mItems[desc.mItems.size()-1]);
		if (tail) {
		tooltips.copy(tail.tooltips);
		return;
		}

		// Steal the descriptor's list of menu items, then rebuild it containing
		// only the items we want to display.
		array<OptionMenuItem> items;
		items.Move(desc.mItems);

		// Start of tooltip block, i.e. index of the topmost menu item the next
		// tooltip will attach to.
		int startblock = -1;
		// Whether we're building a run of tooltips or processing non-tooltip menu
		// items.
		bool tooltip_mode = true;
		for (uint i = 0; i < items.size(); ++i) {
		if (items[i] is "OptionMenuItemrlmal_Tooltip") {
			let tt = OptionMenuItemrlmal_Tooltip(items[i]);
			if (tt.tooltip == "" && !tooltip_mode) {
			// Explicit marker that the above items should have no tooltips.
			startblock = desc.mItems.size();
			} else {
			AddTooltip(settings, startblock, desc.mItems.size()-1, tt.tooltip);
			tooltip_mode = true;
			}
		} else if (items[i] is "OptionMenuItemrlmal_TooltipGeometry") {
			OptionMenuItemrlmal_TooltipGeometry(items[i]).CopyTo(settings);
		} else if (items[i] is "OptionMenuItemrlmal_TooltipAppearance") {
			OptionMenuItemrlmal_TooltipAppearance(items[i]).CopyTo(settings);
		} else {
			if (tooltip_mode) {
			// Just finished a run of tooltips.
			startblock = desc.mItems.size();
			tooltip_mode = false;
			}
			desc.mItems.push(items[i]);
		}
		}

		// Store our tooltips inside the menu descriptor so we can recover them when
		// the menu is redisplayed.
		desc.mItems.push(new("OptionMenuItemrlmal_TooltipHolder").Init(tooltips));
	}

	rlmal_Tooltip AppendableTooltip(uint first, uint last) {
		if (tooltips.size() <= 0) return null;
		let tt = tooltips[tooltips.size()-1];
		if (tt.first == first) return tt;
		return null;
	}

	void AddTooltip(rlmal_Tooltip settings, uint first, uint last, string tooltip) {
		if (first < 0) ThrowAbortException("Tooltip must have at least one menu item preceding it!");
		let tt = AppendableTooltip(first, last);
		if (tt) {
		// Existing tooltip that we're just appending to.
		tt.text = tt.text .. "\n" .. tooltip;
		return;
		}
		// No existing tooltip for these menu entries, create a new one.
		tt = new("rlmal_Tooltip");
		tt.CopyFrom(settings);
		tt.first = first;
		tt.last = last;
		tt.text = tooltip;
		tooltips.push(tt);
	}

	rlmal_Tooltip FindTooltipFor(int item) {
		if (item < 0 || item >= mDesc.mItems.size()) return null;
		if (!mDesc.mItems[item].Selectable()) return null;
		for (uint i = 0; i < tooltips.size(); ++i) {
		if (tooltips[i].first <= item && item <= tooltips[i].last) {
			// console.printf("Found %d <= %d <= %d",
			//   tooltips[i].first, i, tooltips[i].last);
			return tooltips[i];
		}
		}
		return null;
	}

	override void Drawer() {
		super.Drawer();
		let tt = FindTooltipFor(mDesc.mSelectedItem);
		if (tt) tt.Draw();
	}
}

class OptionMenuItemrlmal_TooltipHolder : OptionMenuItem {
	array<rlmal_Tooltip> tooltips;

	OptionMenuItemrlmal_TooltipHolder Init(array<rlmal_Tooltip> tts) {
		self.tooltips.copy(tts);
		return self;
	}

	override bool Selectable() { return false; }
}

class OptionMenuItemrlmal_Tooltip : OptionMenuItem {
	string tooltip;

	OptionMenuItemrlmal_Tooltip Init(string tooltip) {
		self.tooltip = tooltip.filter();
		return self;
	}
}

class OptionMenuItemrlmal_TooltipGeometry : OptionMenuitem {
	double x, y, w, xpad, ypad, scale;

	OptionMenuItemrlmal_TooltipGeometry Init(
		double x=-1.0, double y=-1.0, double w=-1.0,
		double xpad=-1.0, double ypad=-1.0,
		double scale=-1.0) {
		self.x = x; self.y = y; self.w = w;
		self.xpad = xpad; self.ypad = ypad;
		self.scale = scale;
		return self;
	}

	void CopyTo(rlmal_Tooltip settings) {
		if (self.x >= 0) settings.x = self.x;
		if (self.y >= 0) settings.y = self.y;
		if (self.w >= 0) settings.w = self.w;
		if (self.xpad >= 0) settings.xpad = self.xpad;
		if (self.ypad >= 0) settings.ypad = self.ypad;
		if (self.scale > 0) settings.scale = self.scale;
	}
}

class OptionMenuItemrlmal_TooltipAppearance : OptionMenuitem {
	Font myfont;
	Color colour;
	TextureID texture;

	OptionMenuItemrlmal_TooltipAppearance Init(string myfont="", string colour="", string texture="") {
		if (myfont != "") self.myfont = Font.GetFont(myfont);
		if (colour != "") self.colour = Font.FindFontColor(colour);
		if (texture != "") self.texture = TexMan.CheckForTexture(texture, TexMan.TYPE_ANY);
		return self;
	}

	void CopyTo(rlmal_Tooltip settings) {
		if (self.myfont) settings.font = self.myfont;
		if (self.colour) settings.colour = self.colour;
		if (self.texture) settings.texture = self.texture;
	}
}

