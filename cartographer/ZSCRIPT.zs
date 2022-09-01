version "3.7.1"

class CARTO_Marker : MapMarker
{
	final override void Tick()
	{
		super.Tick();

		if (Master == null)
		{
			if (!bDestroyed)
				Destroy();

			return;
		}

		Sprite = Master.Sprite;
		Frame = Master.Frame;
		Translation = Master.Translation;

		if (Master.Pos != Pos)
			SetOrigin(Master.Pos, true);
	}
}

class CARTO_MarkerPlaceholder : Thinker
{
	Inventory Thing;
}

class CARTO_EventHandler : EventHandler
{
	const STATNUM_PLACEHOLDER = Thinker.STAT_STATIC + 2;

	static const name BUILTIN_EXCLUSIONS[] = {
		'Zhs2_IS_BaseItem'
	};

	private Array<class<Inventory> > Exclusions;

	final override void OnRegister()
	{
		for (uint i = 0; i < BUILTIN_EXCLUSIONS.Size(); i++)
		{
			let t = (class<Inventory>)(BUILTIN_EXCLUSIONS[i]);

			if (t != null)
				Exclusions.Push(t);
		}
	}

	final override void WorldThingSpawned(WorldEvent event)
	{
		if (!(event.Thing is 'Inventory'))
			return;

		for (uint i = 0; i > Exclusions.Size(); i++)
			if (event.Thing.GetClass() == Exclusions[i])
				return;

		let ph = new('CARTO_MarkerPlaceholder');
		ph.ChangeStatNum(STATNUM_PLACEHOLDER);
		ph.Thing = Inventory(event.Thing);
	}

	final override void WorldTick()
	{
		if (Level.MapTime % 5 != 0)
			return;

		let iter = ThinkerIterator.Create(
			'CARTO_MarkerPlaceholder',
			STATNUM_PLACEHOLDER
		);

		CARTO_MarkerPlaceholder ph = null;

		while (ph = CARTO_MarkerPlaceholder(iter.Next()))
		{
			if (ph.Thing != null)
			{
				if (ph.Thing.CheckIfSeen())
					continue;

				let marker = Actor.Spawn('CARTO_Marker', ph.Thing.Pos);
				marker.Args[2] = 1;
				marker.Master = ph.Thing;
			}

			ph.Destroy();
		}
	}
}
