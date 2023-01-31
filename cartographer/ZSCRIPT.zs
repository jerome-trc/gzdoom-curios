version "3.7.1"

class CARTO_Marker : MapMarker {}

class CARTO_Partition
{
	Array<Inventory> items;
}

class CARTO_EventHandler : EventHandler
{
	const LOGPFX_ERR = "\c[Cyan]Cartographer: \c[Red](ERROR)\c- ";

	/// Markers get created and updated incrementally.
	/// This is how many sectors and partitions are covered in a single sim tic.
	private uint incrementSize;
	private int curPartition;
	/// Markers are bizarrely expensive on tick time, so they get spawned lazily.
	/// Each sector gets a partition, containing the items that need markers
	/// spawned for them upon being seen.
	private Array<CARTO_Partition> partitions;
	private Array<class<Inventory> > exclusions;

	static const name BUILTIN_EXCLUSIONS[] = {
		'Zhs2_IS_BaseItem',
		'NashGoreActor'
	};

	final override void OnRegister()
	{
		for (int i = 0; i < BUILTIN_EXCLUSIONS.Size(); ++i)
		{
			let cls = (class<Inventory>)(BUILTIN_EXCLUSIONS[i]);

			if (cls != null)
				self.exclusions.Push(cls);
		}
	}

	final override void WorldLoaded(WorldEvent event)
	{
		self.partitions.Clear();
		self.incrementSize = level.sectors.Size() / 5;

		for (let i = 0; i < level.sectors.Size(); ++i)
			self.partitions.Push(New('CARTO_Partition'));
	}

	final override void WorldThingSpawned(WorldEvent event)
	{
		if (self.IsExcluded(Inventory(event.thing)))
			return;

		let partition = self.partitions[event.thing.curSector.sectorNum];
		partition.items.Push(Inventory(event.thing));
	}

	final override void WorldTick()
	{
		for (uint s = 0; s < self.incrementSize; ++s)
		{
			let sect = level.sectors[self.curPartition];
			let partition = self.partitions[self.curPartition];

			let psz = partition.items.Size();

			if (psz > 0)
			{
				for (int i = psz - 1; i >= 0; --i)
				{
					let item = partition.items[i];

					if (item == null || item.bDestroyed)
					{
						partition.items.Delete(i);
						continue;
					}

					// RAT: Why isn't this function called `CheckIfUnseen`?
					if (item.CheckIfSeen())
						continue;

					let marker = Actor.Spawn('CARTO_Marker', item.pos);
					marker.args[2] = 1;
					marker.master = item;
					partition.items.Delete(i);
				}
			}

			for (Actor a = sect.thingList; a != null; a = a.sNext)
			{
				let marker = CARTO_Marker(a);

				if (marker == null)
					continue;

				if (marker.master == null)
				{
					if (!marker.bDestroyed)
						marker.Destroy();

					continue;
				}

				marker.sprite = marker.master.sprite;
				marker.frame = marker.master.frame;
				marker.translation = marker.master.translation;

				if (marker.master.pos != marker.pos)
					marker.SetOrigin(marker.master.pos, true);
			}

			self.curPartition += 1;

			if (self.curPartition >= self.partitions.Size())
				self.curPartition = 0;
		}
	}

	final override void ConsoleProcess(ConsoleEvent event)
	{
		if (!(event.name ~== "carto_diag"))
			return;

		if (!event.isManual)
		{
			Console.Printf(
				LOGPFX_ERR ..
				"Illegal attempt by a script to invoke `carto_diag`."
			);

			return;
		}

		for (int p = 0; p < self.partitions.Size(); ++p)
		{
			Console.Printf("Partition %d", p);
			let partition = self.partitions[p];

			if (partition.items.Size() <= 0)
				continue;

			for (int i = 0; i < partition.items.Size(); ++i)
			{
				if (partition.items[i] != null)
				{
					Console.Printf(
						"\tItem %i: %s",
						i,
						partition.items[i].GetClassName()
					);
				}
				else
				{
					Console.Printf("\tItem %i: <null>", i);
				}
			}
		}
	}

	private bool IsExcluded(Inventory item) const
	{
		if (item == null)
			return true;

		if (item.owner != null)
			return true;

		for (int i = 0; i < self.exclusions.Size(); ++i)
			if (item is self.exclusions[i])
				return true;

		return false;
	}
}
