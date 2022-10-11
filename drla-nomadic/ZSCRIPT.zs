version "3.3"

class RLNL
{
	const LOGPFX_INFO = "\c[Tan]RLNL: \c-";
	const LOGPFX_WARN = "\c[Tan]RLNL: \c[Yellow](WARNING)\c- ";
	const LOGPFX_ERR = "\c[Tan]RLNL: \c[Red](ERROR)\c- ";
	const LOGPFX_DEBUG = "\c[Tan]RLNL: \c[LightBlue](DEBUG)\c- ";
}

// Keep loot tables in a static thinker, in case we ever want to modify them
// over the course of a playthrough.
class RLNL_Global : Thinker
{
	RLNL_LootTable ArmorLoot, BackpackLoot, BootsLoot;

	static RLNL_Global Create()
	{
		let iter = ThinkerIterator.Create('RLNL_Global', STAT_STATIC);

		if (iter.Next(true) != null)
		{
			Console.Printf(
				RLNL.LOGPFX_WARN ..
				"Attempted to re-create global data."
			);
			return null;
		}

		let ret = new('RLNL_Global');
		ret.ChangeStatNum(STAT_STATIC);
		ret.PopulateLootTables();

		return ret;
	}

	private void PopulateLootTables()
	{
		ArmorLoot = new('RLNL_LootTable');
		// Empty stand-in for basic green, blue, and red armors
		ArmorLoot.PushEmpty(12);
		ArmorLoot.Push('RLExoticArmorSpawner', 3);
		ArmorLoot.Push('RLAssembledArmorSpawner', 3);
		ArmorLoot.Push('RLUniqueArmorSpawner', 2);
		ArmorLoot.Push('RLLegendaryArmorSpawner', 1);

		BackpackLoot = new('RLNL_LootTable');
		BackpackLoot.PushEmpty(800); // Empty stand-in for regular backpack
		BackpackLoot.Push('RLCombatBackpackPickup', 50);
		BackpackLoot.Push('RLSpecialistBackpackPickup', 50);
		BackpackLoot.Push('RLScroungerBackpackPickup', 50);
		BackpackLoot.Push('RLDedicatedBackpackPickup', 50);
		BackpackLoot.Push('RLNuclearBackpackPickup', 1);

		BootsLoot = new('RLNL_LootTable');
		BootsLoot.PushEmpty(12); // Empty stand-in for basic boots
		BootsLoot.Push('RLExoticBootsSpawner', 3);
		BootsLoot.Push('RLAssembledBootsSpawner', 2);
		BootsLoot.Push('RLUniqueBootsSpawner', 1);
	}

	static clearscope RLNL_Global Get()
	{
		let iter = ThinkerIterator.Create('RLNL_Global', STAT_STATIC);
		return RLNL_Global(iter.Next(true));
	}
}

#include "zscript/drla-nomadic/detail.zs"
#include "zscript/drla-nomadic/event.zs"
