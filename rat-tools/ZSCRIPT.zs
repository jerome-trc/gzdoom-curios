version "2.4"

class RATT_EventHandler : EventHandler
{
	enum NetArg
	{
		NETARG_MAKELEGENDARY
	}

	final override void NetworkProcess(ConsoleEvent event)
	{
		if (!(event.Name ~== "rat_net"))
			return;

		switch (event.Args[0])
		{
		case NETARG_MAKELEGENDARY:
			MakeMonsterLegendary();
			break;
		default:
			Console.Printf("ERROR: Invalid net event argument: %d", event.Args[0]);
			break;
		}
	}

	private static void MakeMonsterLegendary()
	{
		name token_tn = 'LDLegendaryMonsterToken';

		if ((class<Inventory>)(token_tn) == null)
		{
			Console.Printf("Neither LegenDoom nor LegenDoom Lite is installed.");
			return;
		}

		let bli = BlockThingsIterator.Create(Players[ConsolePlayer].MO,	100.0);

		while (bli.Next())
		{
			if (!bli.Thing.bIsMonster)
				continue;

			bli.Thing.ACS_NamedExecuteAlways("LDMonsterInit", 0);
			Console.Printf("Turned monster legendary: %s", bli.Thing.GetClassName());
			return;
		}
	}

	enum ConsoleArg
	{
		CONSARG_LEVELDIAG
	}

	final override void ConsoleProcess(ConsoleEvent event)
	{
		if (!(event.Name ~== "rat_console"))
			return;

		switch (event.Args[0])
		{
		case CONSARG_LEVELDIAG:
			PrintLevelDiag();
			break;
		default:
			Console.Printf("ERROR: Invalid console event argument: %d", event.Args[0]);
			break;
		}
	}

	private static ui void PrintLevelDiag()
	{
		Console.Printf(
			"Level name: %s\n"
			"Map name: %s\n"
			"Level num: %d\n"
			"Checksum: %s\n",
			Level.LevelName,
			Level.MapName,
			Level.LevelNum,
			Level.GetChecksum()
		);
	}
}
