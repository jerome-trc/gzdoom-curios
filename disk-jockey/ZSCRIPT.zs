version "2.4"

class DJ_SongInfo
{
	int Lump;
	// All un-localized.
	string Title, Artist, Origin;

	string ToString() const
	{
		return String.Format(
			StringTable.Localize("$DJ_SONGTOSTR"),
			StringTable.Localize(Artist),
			StringTable.Localize(Title)
		);
	}
}

class DJ_Playlist
{
	int Lump;
	// Un-localized.
	string Title;
	Array<DJ_SongInfo> Songs;
}

class DJ_EventHandler : StaticEventHandler
{
	private Array<DJ_Playlist> Playlists;
	private int CurrentPlaylist, CurrentSong;
	private float MusicVolume;

	const LMPNAME_PLAYLIST = "PLAYLIST";

	final override void OnRegister()
	{
		CurrentPlaylist = -1;
		CurrentSong = -1;
		MusicVolume = 1.0;

		int lump = -1, next = 0;

		do
		{
			lump = Wads.FindLump(LMPNAME_PLAYLIST, next, Wads.GLOBALNAMESPACE);

			if (lump == -1)
				break;

			next = lump + 1;

			let content = Wads.ReadLump(lump);
			Array<string> lines;
			content.Split(lines, "\n", TOK_SKIPEMPTY);

			if (lines.Size() < 1)
				return;

			let playlist = new('DJ_Playlist');

			playlist.Lump = lump;
			playlist.Title = String.Format("$DJ_PLAYLIST_%s_TITLE", lines[0]);

			for (uint i = 1; i < lines.Size(); i++)
			{
				if (lines[i] == "")
					continue;

				let muslump = Wads.CheckNumForName(
					lines[i],
					Wads.NS_MUSIC
				);

				if (muslump == -1)
				{
					Console.Printf(
						"Failed to find music lump by name: %s",
						lines[i]
					);
					continue;
				}

				let song = new('DJ_SongInfo');

				song.Lump = muslump;
				song.Title = String.Format("$DJ_SONG_%s_TITLE", lines[i]);
				song.Artist = String.Format("$DJ_SONG_%s_ARTIST", lines[i]);
				song.Origin = String.Format("$DJ_SONG_%s_ORIGIN", lines[i]);

				playlist.Songs.Push(song);
			}

			Playlists.Push(playlist);
		} while (true);
	}

	private void ChangeMusic(DJ_SongInfo song) const
	{
		let lmpname = Wads.GetLumpFullName(song.Lump);
		S_ChangeMusic(lmpname);

		Console.Printf(
			String.Format(
				StringTable.Localize("$DJ_NOWPLAYING"),
				song.ToString()
			)
		);
	}

	enum EventIndex
	{
		EVNDX_START,
		EVNDX_NEXT,
		EVNDX_PREV,
		EVNDX_LEVEL,
		EVNDX_RANDOM,
		EVNDX_VOLUP,
		EVNDX_VOLDOWN, // 6
	}

	final override void NetworkProcess(ConsoleEvent event)
	{
		if (!(event.Name ~== "diskjockey"))
			return;

		switch (event.Args[0])
		{
		case EVNDX_START:
			{
				if (Playlists.Size() < 1)
				{
					Console.Printf("No playlists to start.");
					return;
				}

				if (Playlists[0].Songs.Size() < 1)
				{
					Console.Printf("First playlist has no songs.");
					return;
				}

				CurrentPlaylist = 0;
				CurrentSong = 0;
				ChangeMusic(Playlists[CurrentPlaylist].Songs[CurrentSong]);
			}
			break;
		case EVNDX_NEXT:
			{
				if (CurrentPlaylist < 0)
					return;

				let pl = Playlists[CurrentPlaylist];

				if (++CurrentSong >= pl.Songs.Size())
					CurrentSong = 0;

				ChangeMusic(pl.Songs[CurrentSong]);
			}
			break;
		case EVNDX_PREV:
			{
				if (CurrentPlaylist < 0)
					return;

				let pl = Playlists[CurrentPlaylist];

				if (--CurrentSong < 0)
					CurrentSong = pl.Songs.Size() - 1;

				ChangeMusic(pl.Songs[CurrentSong]);
			}
			break;
		case EVNDX_LEVEL:
			{
				S_ChangeMusic("*");

				Console.Printf(
					String.Format(
						StringTable.Localize("$DJ_NOWPLAYING"),
						Level.Music
					)
				);
			}
			break;
		case EVNDX_RANDOM:
			{
				if (CurrentPlaylist < 0)
					return;

				let pl = Playlists[CurrentPlaylist];
				CurrentSong = Random[DiskJockey](0, pl.Songs.Size() - 1);
				ChangeMusic(pl.Songs[CurrentSong]);
			}
			break;
		case EVNDX_VOLUP:
			{
				MusicVolume = Min(MusicVolume + 0.1, 1.0);
				SetMusicVolume(MusicVolume);
			}
			break;
		case EVNDX_VOLDOWN:
			{
				MusicVolume = Max(MusicVolume - 0.1, 0.0);
				SetMusicVolume(MusicVolume);
			}
			break;
		default:
			Console.Printf(
				"Disk Jockey received illegal event argument: %d",
				event.Args[0]
			);
			return;
		}
	}

	final override void WorldLoaded(WorldEvent _) { MusicVolume = 1.0; }
	final override void WorldUnloaded(WorldEvent _) { MusicVolume = 1.0; }
}
