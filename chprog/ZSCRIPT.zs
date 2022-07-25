version "2.4"

enum CHPROG_SpawnTableIndex : uint8
{
	CHPROG_STNDX_REVENANT,
	CHPROG_STNDX_ZOMBIEMAN,
	CHPROG_STNDX_IMP,
	CHPROG_STNDX_SHOTGUNGUY,
	CHPROG_STNDX_DEMON,
	CHPROG_STNDX_SPECTRE,
	CHPROG_STNDX_CACODEMON,
	CHPROG_STNDX_HELLKNIGHT,
	CHPROG_STNDX_ARACHNOTRON,
	CHPROG_STNDX_MANCUBUS,
	CHPROG_STNDX_ARCHVILE,
	CHPROG_STNDX_CHAINGUNGUY,
	CHPROG_STNDX_HELLBARON,
	CHPROG_STNDX_LOSTSOUL,
	CHPROG_STNDX_PAINELEMENTAL,
	CHPROG_STNDX_CYBERDEMON,
	CHPROG_STNDX_MASTERMIND,
	__CHPROG_STNDX_COUNT__
}

class CHPROG_SpawnPair
{
	class<Actor> Type;
	int Weight;
}

struct CHPROG_SpawnTable
{
	private int WeightSum;
	Array<CHPROG_SpawnPair> Pairs;

	void AddPair(class<Actor> type, int weight)
	{
		let pair = new('CHPROG_SpawnPair');
		pair.Type = type;
		pair.Weight = weight;
		WeightSum += weight;
		Pairs.Push(pair);
	}

	class<Actor> Result() const
	{
		uint iters = 0;

		while (iters < 1000)
		{
			uint chance = Random[CHPROG](1, WeightSum);
			uint runningSum = 0, choice = 0;

			for (uint i = 0; i < Pairs.Size(); i++)
			{
				runningSum += Pairs[i].Weight;

				if (chance <= runningSum) 
					return Pairs[i].Type;

				choice++;
			}

			iters++;
		}

		return null;
	}

	int FindWeightByType(class<Actor> type) const
	{
		for (uint i = 0; i < Pairs.Size(); i++)
			if (Pairs[i].Type == type)
				return Pairs[i].Weight;

		return 0;
	}
}

class CHPROG_Global : Thinker
{
	CHPROG_SpawnTable SpawnTables[__CHPROG_STNDX_COUNT__];

	static const name REFERENCE_SPAWNERS[] = {
		'Colourset1', // Revenant
		'Colourset2', // Zombieman
		'Colourset3', // Imp
		'Colourset4', // Shotgun Guy
		'Colourset5', // Demon
		'Colourset6', // Spectre
		'Colourset7', // Cacodemon
		'Colourset8', // Hell Knight
		'Colourset9', // Arachnotron
		'Colourset10', // Mancubus
		'Colourset11', // Archvile
		'Colourset12', // Chaingun Guy
		'Colourset13', // Baron of Hell
		'Colourset14', // Lost Soul
		'Colourset15', // Pain Elemental
		'Colourset16', // Cyberdemon
		'Colourset17' // Spider Mastermind
	};

	static const string SPAWNER_LABELS[] = {
		"Revenant",
		"Zombieman",
		"Imp",
		"Shotgun Guy",
		"Demon",
		"Spectre",
		"Cacodemon",
		"Hell Knight",
		"Arachnotron",
		"Mancubus",
		"Archvile",
		"Chaingun Guy",
		"Baron of Hell",
		"Lost Soul",
		"Pain Elemental",
		"Cyberdemon",
		"Spider Mastermind"
	};

	static CHPROG_Global Create()
	{
		let iter = ThinkerIterator.Create('CHPROG_Global', STAT_STATIC);

		if (iter.Next(true) != null)
		{
			Console.Printf("CHPROG: Attempted to re-create global data.");
			return null;
		}

		Console.Printf("CHPROG: Creating global singleton...");
		let ret = new('CHPROG_Global');
		ret.ChangeStatNum(STAT_STATIC);
		ret.PopulateSpawnTables();

		return ret;
	}

	static clearscope CHPROG_Global Get()
	{
		let iter = ThinkerIterator.Create('CHPROG_Global', STAT_STATIC);
		return CHPROG_Global(iter.Next(true));
	}

	private void PopulateSpawnTables()
	{
		name rainbowEssence_tn = 'RainbowEssence';
		class<Health> rainbowEssence_t = rainbowEssence_tn;
		bool rainbow = rainbowEssence_t != null;

		for (uint i = 0; i < REFERENCE_SPAWNERS.Size(); i++)
		{
			string spawner_tn = REFERENCE_SPAWNERS[i];
			class<Actor> spawner_t = rainbow ? spawner_tn .. "Rainbow" : spawner_tn;

			// Not all Colourful Hell spawners have a rainbow counterpart
			if (spawner_t == null)
				spawner_t = REFERENCE_SPAWNERS[i];

			let defs = GetDefaultByType(spawner_t);

			for (DropItem item = defs.GetDropItems(); item != null; item = item.Next)
			{
				let type = (class<Actor>)(item.Name);
				let weight = item.Amount;
				SpawnTables[i].AddPair(type, weight);
			}
		}
	}

	class<Actor> GetSpawnTypeFor(CHPROG_SpawnTableIndex index) const
	{
		return SpawnTables[index].Result();
	}

	void Advance()
	{
		// ???
	}
}

class CHPROG_EventHandler : EventHandler
{
	private CHPROG_Global Globals;

	final override void NewGame()
	{
		Globals = CHPROG_Global.Create();
	}

	final override void OnRegister()
	{
		if (Globals == null)
			Globals = CHPROG_Global.Get();
	}

	final override void WorldThingSpawned(WorldEvent event)
	{
		if (!(event.Thing is 'RandomSpawner'))
			return;

		for (uint i = 0; i < Globals.REFERENCE_SPAWNERS.Size(); i++)
		{
			if (event.Thing is Globals.REFERENCE_SPAWNERS[i])
			{
				Actor.Spawn(Globals.GetSpawnTypeFor(i), event.Thing.Pos);
				event.Thing.Destroy();
				return;
			}
		}
	}

	final override void WorldLoaded(WorldEvent event)
	{
		// The former isn't relevant for this event handler type, but leave it
		// here in case the parent class gets changed for whatever reason
		if (event.IsSaveGame || event.IsReopen)
			return;

		Globals.Advance();
	}

	final override void ConsoleProcess(ConsoleEvent event)
	{
		if (event.Name ~== "chprog_diag")
		{
			string output = "CHPROG: All monster classes and weights:\n";

			for (uint i = 0; i < Globals.SpawnTables.Size(); i++)
			{
				output.AppendFormat("\t# \c[Blue]%s\c-\n", Globals.SPAWNER_LABELS[i]);

				for (uint j = 0; j < Globals.SpawnTables[i].Pairs.Size(); j++)
				{
					let pair = Globals.SpawnTables[i].Pairs[j];

					output.AppendFormat(
						"\t\t-> %s: %d\n",
						pair.Type.GetClassName(), pair.Weight
					);
				}
			}

			Console.Printf(output);
		}
		else if (event.Name ~== "chprog_sim")
		{
			let count = event.Args[0] == 0 ? 1000 : event.Args[0];

			string output = String.Format(
				"CHPROG: Simulating %d spawn(s) of each monster category.\n"
				"Results:\n", count
			);

			for (uint i = 0; i < Globals.SpawnTables.Size(); i++)
			{
				output.AppendFormat(
					"\t# \c[Blue]%s\c-\n",
					Globals.SPAWNER_LABELS[i]
				);

				Array<class<Actor> > types;
				Array<uint> counters;

				for (uint j = 0; j < count; j++)
				{
					let mons_t = Globals.SpawnTables[i].Result();
					let idx = types.Find(mons_t);

					if (idx == types.Size())
					{
						idx = types.Push(mons_t);
						counters.Push(1);
					}
					else
					{
						counters[idx]++;
					}
				}

				for (uint j = 0; j < types.Size(); j++)
				{
					let weight = Globals.SpawnTables[i].FindWeightByType(types[j]);

					output.AppendFormat(
						"\t\t-> %s (\c[Green]weight %d\c-): %d\n",
						types[j].GetClassName(), weight, counters[j]
					);
				}
			}

			output.DeleteLastCharacter();
			Console.Printf(output);
		}
	}
}
