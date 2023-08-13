version "2.4"

class rcdj_EventHandler : StaticEventHandler
{
	array<rcdj_SongInfo> songs;

	enum EventArg0 : int
	{
		EVA0_OPENMENU = 0
	}

	final override void ConsoleProcess(ConsoleEvent event)
	{
		if (!(event.name ~== "rcdj_console"))
			return;

		switch (event.args[0])
		{
		case EVA0_OPENMENU:
		{
			if (Menu.GetCurrentMenu() is 'rcdj_Menu')
				break;

			Menu.SetMenu('rcdj_Menu');
			break;
		}
		default: break;
		}
	}

	final override void OnRegister()
	{
		for (uint i = 0; i < Wads.GetNumLumps(); ++i)
		{
			if (Wads.GetLumpNamespace(i) != Wads.NS_MUSIC)
				continue;

			let fullName = Wads.GetLumpFullName(i);
			fullName.Replace("music/", "");
			let songInfo = new('rcdj_SongInfo');
			songInfo.label = fullName;
			songInfo.lump = i;
			self.songs.Push(songInfo);
		}
	}
}

class rcdj_Menu : OptionMenu
{
	final override void Init(Menu parent, OptionMenuDescriptor desc)
	{
		super.Init(parent, desc);
		let global = rcdj_EventHandler(StaticEventHandler.Find('rcdj_EventHandler'));

		for (int i = 0; i < global.songs.Size(); ++i)
		{
			let song = global.songs[i];
			let omi = new('rcdj_OptionMenuItem');
			omi.Init(song.lump, song.label, Font.CR_WHITE);
			self.mDesc.mItems.push(omi);
		}
	}

	final override void OnDestroy()
	{
		super.OnDestroy();
		self.mDesc.mItems.Clear();
	}
}

class rcdj_OptionMenuItem : OptionMenuItem
{
	int lump, fontColor;
	string songName;

	rcdj_OptionMenuItem Init(
		int lump,
		string label,
		int fontColor
	)
	{
		super.Init(label, "", true);
		self.lump = lump;
		self.fontColor = fontColor;
		return self;
	}

	override int Draw(OptionMenuDescriptor d, int y, int indent, bool selected)
	{
		self.DrawLabel(indent, y, self.fontColor);
		// self.DrawValue(indent, y, self.fontColor, self.songName);
		return indent;
	}

	final override bool MenuEvent(int key, bool fromController)
	{
		if (key != Menu.MKEY_ENTER)
			return super.MenuEvent(key, fromController);

		let lmpname = Wads.GetLumpFullName(self.lump);
		S_ChangeMusic(lmpname);
		Menu.MenuSound("menu/choose");
		Menu.GetCurrentMenu().Close();
		return true;
	}
}

class rcdj_SongInfo
{
	int lump;
	string label;
}
