class RLNL_WeightedRandomTableEntry
{
	class<Object> Type;
	RLNL_WeightedRandomTable Subtable;
	uint Weight;
}

class RLNL_WeightedRandomTable
{
	string Label;
	protected Array<RLNL_WeightedRandomTableEntry> Entries;
	protected uint WeightSum;

	virtual protected uint RandomImpl() const { return Random(1, WeightSum); }

	void Push(class<Object> type, uint weight)
	{
		if (type == null)
		{
			Console.Printf(
				RLNL.LOGPFX_ERR ..
				"Tried to push `null` onto WeightedRandomTable `%s`.",
				Label.Length() > 0 ? Label : String.Format("%p", self));
			return;
		}

		if (weight <= 0)
		{
			Console.Printf(
				RLNL.LOGPFX_ERR ..
				"Tried to push a weight of 0 onto WeightedRandomTable `%s` (%s).",
				Label.Length() > 0 ? Label : String.Format("%p", self),
				type.GetClassName());
			return;
		}

		uint end = Entries.Push(new('RLNL_WeightedRandomTableEntry'));
		Entries[end].Type = type;
		Entries[end].Weight = weight;
		WeightSum += weight;
	}

	void PushEmpty(uint weight)
	{
		uint end = Entries.Push(new('RLNL_WeightedRandomTableEntry'));
		Entries[end].Type = null;
		Entries[end].Weight = weight;
		WeightSum += weight;
	}

	RLNL_WeightedRandomTable EmplaceLayer(uint weight)
	{
		if (weight <= 0)
		{
			Console.Printf(
				RLNL.LOGPFX_ERR ..
				"Tried to add a layer with a weight of 0 onto WeightedRandomTable `%s`.",
				Label.Length() > 0 ? Label : String.Format("%p", self));
			return null;
		}

		uint end = Entries.Push(new('RLNL_WeightedRandomTableEntry'));
		Entries[end].SubTable = RLNL_WeightedRandomTable(new(GetClass()));
		Entries[end].Weight = weight;
		WeightSum += weight;
		return Entries[end].SubTable;
	}

	void PushLayer(RLNL_WeightedRandomTable wrt, uint weight)
	{
		if (wrt == self)
		{
			Console.Printf(
				RLNL.LOGPFX_ERR ..
				"Attempted to nest WeightedRandomTable `%s` within itself.",
				Label.Length() > 0 ? Label : String.Format("%p", self));
			return;
		}

		if (weight <= 0)
		{
			Console.Printf(
				RLNL.LOGPFX_ERR ..
				"Tried to push a layer with a weight of 0 onto WeightedRandomTable `%s`.",
				Label.Length() > 0 ? Label : String.Format("%p", self));
			return;
		}

		uint end  = Entries.Push(new('RLNL_WeightedRandomTableEntry'));
		Entries[end].SubTable = wrt;
		Entries[end].Weight = weight;
		WeightSum += weight;
	}

	class<Object> Result() const
	{
		if (Entries.Size() < 1)
		{
			Console.Printf(
				RLNL.LOGPFX_ERR ..
				"Tried to get a result from an empty WeightedRandomTable (`%s`).",
				Label.Length() > 0 ? Label : String.Format("%p", self));
			return null;
		}

		uint iters = 0;

		while (iters < 10000)
		{
			uint chance = RandomImpl();
			uint runningSum = 0, choice = 0;

			for (uint i = 0; i < Entries.Size(); i++)
			{
				runningSum += Entries[i].Weight;

				if (chance <= runningSum) 
				{
					if (Entries[i].SubTable != null)
						return Entries[i].SubTable.Result();
					else
						return Entries[i].Type;
				}

				choice++;
			}

			iters++;
		}

		Console.Printf(
			RLNL.LOGPFX_ERR ..
			"Failed to make a weighted random choice after 10000 tries (`%s`).",
			Label.Length() > 0 ? Label : String.Format("%p", self)
		);
		return null;
	}

	void FromArray(
		in out Array<class<Object> > arr, in out Array<uint> weights)
	{
		if (arr.Size() != weights.Size())
		{
			Console.Printf(
				RLNL.LOGPFX_ERR ..
				"WeightedRandomTable::FromArray() received unequal-sized "
				"parallel arrays.");
			return;
		}

		for (uint i = 0; i < arr.Size(); i++)
			Push(arr[i], weights[i]);
	}

	void RemoveByType(class<Object> type)
	{
		for (uint i = Entries.Size() - 1; i >= 0; i--)
		{
			if (Entries[i].SubTable != null)
				Entries[i].SubTable.RemoveByType(type);
			
			if (Entries[i].Type == type)
			{
				WeightSum -= Entries[i].Weight;
				Entries.Delete(i);
			}
		}
	}

	void Clear()
	{
		Entries.Clear();
		WeightSum = 0;
	}

	uint Size() const
	{
		uint ret = 0;

		for (uint i = 0; i < Entries.Size(); i++)
		{
			if (Entries[i].SubTable != null)
				ret += Entries[i].SubTable.Size();
			else
				ret++;
		}

		return ret;
	}

	string ToString() const { return ToStringImpl(0); }

	private string ToStringImpl(uint depth) const
	{
		string ret = String.Format(
			"Contents of WeightedRandomTable `%s`:\n",
			Label.Length() > 0 ? Label : String.Format("%p", self)
		);

		string prefix = "\t";

		for (uint i = 0; i < depth; i++)
			prefix = prefix .. "\t";

		for (uint i = 0; i < Entries.Size(); i++)
		{
			if (Entries[i].SubTable != null)
			{
				ret.AppendFormat(Entries[i].SubTable.ToStringImpl(depth + 1));
			}
			else
			{
				ret.AppendFormat(prefix .. "\t%s: %d\n",
					Entries[i].Type.GetClassName(), Entries[i].Weight
				);
			}
		}

		ret.DeleteLastCharacter();
		return ret;
	}
}

class RLNL_LootTable : RLNL_WeightedRandomTable
{
	final override uint RandomImpl() const
	{
		return Random[RLNL](1, WeightSum);
	}
}

class RLNL_IntangibleActor : Actor abstract
{
	Default
	{
		-SOLID
		+CANPASS
		+DONTSPLASH
		+FLOORCLIP
		+NOBLOCKMAP
		+NOBLOCKMONST
		+NOTELEPORT
		+NOTIMEFREEZE
		+NOTONAUTOMAP
		+NOTRIGGER

		Height 8;
		Radius 16;
		RenderStyle 'None';
	}
}

class RLNL_WanderingSpawner : RLNL_IntangibleActor
{
	private class<Actor> ToSpawn;
	private uint WanderCount;

	Default
	{
		Speed 15;
	}	

	States
	{
	Spawn:
		TNT1 A 0;
		TNT1 A 1
		{
			if (invoker.WanderCount <= 0 || invoker.ToSpawn == null)
				return ResolveState('Spawn');

			for (uint i = 0; i < invoker.WanderCount; i++)
				A_Wander();

			Actor.Spawn(ToSpawn, Pos);
			return state(null);
		}
		Stop;
	}

	static RLNL_WanderingSpawner Create(
		Vector3 position,
		class<Actor> toSpawn,
		uint wanderCount
	)
	{
		let ret = RLNL_WanderingSpawner(
			Actor.Spawn('RLNL_WanderingSpawner', position)
		);
		ret.ToSpawn = toSpawn;
		ret.WanderCount = wanderCount;
		return ret;
	}
}
