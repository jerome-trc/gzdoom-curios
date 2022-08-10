version "2.4"

class RATT_EventHandler : EventHandler
{
	final override void NetworkProcess(ConsoleEvent event)
	{
		if (event.Name ~== "rat_legen")
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
	}
}
