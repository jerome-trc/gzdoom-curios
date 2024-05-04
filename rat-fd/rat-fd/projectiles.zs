// These types improve the performance of Plasma Vulcan projectiles by optionally
// applying a significant reduction on their trails.

class ratfd_BTSXPlasmaProjectile : FastProjectile
{
	Default
	{
		Projectile;

		+THRUSPECIES
		+THRUGHOST
		+FORCEXYBILLBOARD
		+BLOODLESSIMPACT

		Alpha 1.0;
		DamageFunction (Random(16, 24));
		DamageType 'Plasma';
		Decal 'PlasmaScorchLower';
		Height 4;
		Radius 4;
		RenderStyle 'Add';
		Scale 0.58;
		Species 'Player';
		Speed 65;
	}

	States
	{
	Spawn:
		TNT1 A 0;
		TNT1 A 0
		{
			if (RATFD_projtrails)
				return ResolveState('Spawn.Trail');
			else
				return ResolveState('Spawn.NoTrail');
		}
	Spawn.Trail:
		TNT1 A 1 Light("FDBTSXPlasmaBlueGlow")
		{
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail',
				(0.01 * Vel.X) / -35.0, -(0.01 * Vel.Y) / -35.0, 2 + (0.01 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail2',
				(0.5 * Vel.X) / -35.0, -(0.5 * Vel.Y) / -35.0, 2 + (0.5 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail3',
				(1 * Vel.X) / -35.0, -(1 * Vel.Y) / -35.0, 2 + (1 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail4',
				(2 * Vel.X) / -35.0, -(2 * Vel.Y) / -35.0, 2 + (2 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail5',
				(3 * Vel.X) / -35.0, -(3 * Vel.Y) / -35.0, 2 + (3 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail6',
				(4 * Vel.X) / -35.0, -(4 * Vel.Y) / -35.0, 2 + (4 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail7',
				(5 * Vel.X) / -35.0, -(5 * Vel.Y) / -35.0, 2 + (5 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail8',
				(6 * Vel.X) / -35.0, -(6 * Vel.Y) / -35.0, 2 + (6 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail9',
				(7 * Vel.X) / -35.0, -(7 * Vel.Y) / -35.0, 2 + (7 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx('FDBTSXPlasmaProjectileTrail10',
				(8 * Vel.X) / -35.0, -(8 * Vel.Y) / -35.0, 2 + (8 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail11',
				(9 * Vel.X) / -35.0, -(9 * Vel.Y) / -35.0, 2 + (9 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail12',
				(10 * Vel.X) / -35.0, -(10 * Vel.Y) / -35.0, 2 + (10 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail13',
				(11 * Vel.X) / -35.0, -(11 * Vel.Y) / -35.0, 2 + (11 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail14',
				(12 * Vel.X) / -35.0, -(12 * Vel.Y) / -35.0, 2 + (12 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail15',
				(13 * Vel.X) / -35.0, -(13 * Vel.Y) / -35.0, 2 + (13 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail16',
				(14 * Vel.X) / -35.0, -(14 * Vel.Y) / -35.0, 2 + (14 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail17',
				(15 * Vel.X) / -35.0, -(15 * Vel.Y) / -35.0, 2 + (15 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail18',
				(16 * Vel.X) / -35.0, -(16 * Vel.Y) / -35.0, 2 + (16 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail19',
				(17 * Vel.X) / -35.0, -(17 * Vel.Y) / -35.0, 2 + (17 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail20',
				(18 * Vel.X) / -35.0, -(18 * Vel.Y) / -35.0, 2 + (18 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail21',
				(19 * Vel.X) / -35.0, -(19 * Vel.Y) / -35.0, 2 + (19 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail22',
				(20 * Vel.X) / -35.0, -(20 * Vel.Y) / -35.0, 2 + (20 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail23',
				(21 * Vel.X) / -35.0, -(21 * Vel.Y) / -35.0, 2 + (21 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);

			if (FD_particles)
				A_BTSXPlasmaProjectile_SpawnParticles();
		}
		Loop;
	Spawn.NoTrail:
		TNT1 A 1 Light("FDBTSXPlasmaBlueGlow")
		{
			A_SpawnItemEx(
				'FDBTSXPlasmaProjectileTrail',
				(0.01 * Vel.X) / -35.0, -(0.01 * Vel.Y) / -35.0, 2 + (0.01 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);

			if (FD_particles)
				A_BTSXPlasmaProjectile_SpawnParticles();
		}
		Loop;
	Death:
		TNT1 A 0
		{
			A_StartSound(
				"btsx/energyimpact",
				CHAN_7,
				volume: 0.4,
				attenuation: 1.5
			);

			if (FD_particles)
			{
				let r = RandomPick(25, 20, 15);

				for (uint i = 0; i < r; i++)
				{
					A_SpawnParticle(
						"0000ff",
						SPF_FULLBRIGHT | SPF_RELATIVE,
						Random(15, 25), Random(1, 3), FRandom(0, 360),
						0, 0, 0,
						FRandom(0.2, 12.0), FRandom(-0.2, 0.2), FRandom(-6.0, 6.0),
						0, 0, 0,
						0.98, -1
					);
				}
			}
		}
		XPSG AAA 1 Bright Light("FDBTSXPlasmaBlueImpact1") A_FadeTo(0, 0.1, 1);
		XPSG BBB 1 Bright Light("FDBTSXPlasmaBlueImpact2") A_FadeTo(0, 0.1, 1);
		Stop;
	}

	private action void A_BTSXPlasmaProjectile_SpawnParticles()
	{
		let r = RandomPick(9, 6, 3);

		for (uint i = 0; i < r; i++)
		{
			A_SpawnParticle(
				"0000ff",
				SPF_FULLBRIGHT | SPF_RELATIVE | SPF_RELANG,
				Random(8, 16), Random(2, 3), 0,
				FRandom(-16.0, 16.0), FRandom(-4.2, 4.2), FRandom(-4.2, 4.2),
				0, 0, 0,
				0, 0, 0,
				0.5,
				-1
			);
		}
	}
}

class ratfd_BTSXFancyPlasmaProjectile : ratfd_BTSXPlasmaProjectile
{
	Default
	{
		Scale 0.58;
	}

	States
	{
	Spawn.Trail:
		TNT1 A 1 Light("FDBTSXPlasmaBlueGlowFancy")
		{
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail',
				(0.01 * Vel.X) / -35.0, -(0.01 * Vel.Y) / -35.0, 2 + (0.01 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail2',
				(0.5 * Vel.X) / -35.0, -(0.5 * Vel.Y) / -35.0, 2 + (0.5 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail3',
				(1 * Vel.X) / -35.0, -(1 * Vel.Y) / -35.0, 2 + (1 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail4',
				(2 * Vel.X) / -35.0, -(2 * Vel.Y) / -35.0, 2 + (2 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail5',
				(3 * Vel.X) / -35.0, -(3 * Vel.Y) / -35.0, 2 + (3 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail6',
				(4 * Vel.X) / -35.0, -(4 * Vel.Y) / -35.0, 2 + (4 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail7',
				(5 * Vel.X) / -35.0, -(5 * Vel.Y) / -35.0, 2 + (5 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail8',
				(6 * Vel.X) / -35.0, -(6 * Vel.Y) / -35.0, 2 + (6 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail9',
				(7 * Vel.X) / -35.0, -(7 * Vel.Y) / -35.0, 2 + (7 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx('FDBTSXFancyPlasmaProjectileTrail10',
				(8 * Vel.X) / -35.0, -(8 * Vel.Y) / -35.0, 2 + (8 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail11',
				(9 * Vel.X) / -35.0, -(9 * Vel.Y) / -35.0, 2 + (9 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail12',
				(10 * Vel.X) / -35.0, -(10 * Vel.Y) / -35.0, 2 + (10 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail13',
				(11 * Vel.X) / -35.0, -(11 * Vel.Y) / -35.0, 2 + (11 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail14',
				(12 * Vel.X) / -35.0, -(12 * Vel.Y) / -35.0, 2 + (12 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail15',
				(13 * Vel.X) / -35.0, -(13 * Vel.Y) / -35.0, 2 + (13 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail16',
				(14 * Vel.X) / -35.0, -(14 * Vel.Y) / -35.0, 2 + (14 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail17',
				(15 * Vel.X) / -35.0, -(15 * Vel.Y) / -35.0, 2 + (15 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail18',
				(16 * Vel.X) / -35.0, -(16 * Vel.Y) / -35.0, 2 + (16 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail19',
				(17 * Vel.X) / -35.0, -(17 * Vel.Y) / -35.0, 2 + (17 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail20',
				(18 * Vel.X) / -35.0, -(18 * Vel.Y) / -35.0, 2 + (18 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail21',
				(19 * Vel.X) / -35.0, -(19 * Vel.Y) / -35.0, 2 + (19 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail22',
				(20 * Vel.X) / -35.0, -(20 * Vel.Y) / -35.0, 2 + (20 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail23',
				(21 * Vel.X) / -35.0, -(21 * Vel.Y) / -35.0, 2 + (21 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);

			if (FD_particles)
				A_BTSXPlasmaProjectile_SpawnParticlesFancy();
		}
		Loop;
	Spawn.NoTrail:
		TNT1 A 1 Light("FDBTSXPlasmaBlueGlow")
		{
			A_SpawnItemEx(
				'FDBTSXFancyPlasmaProjectileTrail',
				(0.01 * Vel.X) / -35.0, -(0.01 * Vel.Y) / -35.0, 2 + (0.01 * Vel.Z) / -35.0,
				0, 0, 0,
				0,
				SXF_ABSOLUTEANGLE | SXF_NOCHECKPOSITION
			);

			if (FD_particles)
				A_BTSXPlasmaProjectile_SpawnParticlesFancy();
		}
		Loop;
	Death:
		TNT1 A 0
		{
			A_StartSound(
				"btsx/energyimpact",
				CHAN_7,
				volume: 0.4,
				attenuation: 1.5
			);

			if (FD_particles)
			{
				let r = RandomPick(25, 20, 15);

				for (uint i = 0; i < r; i++)
				{
					A_SpawnParticle(
						"72e0f1",
						SPF_FULLBRIGHT | SPF_RELATIVE,
						Random(15, 25), Random(1, 3), FRandom(0.0, 360.0),
						0, 0, 0,
						FRandom(0.2, 12.0), FRandom(-0.2, 0.2), FRandom(-6.0, 6.0),
						0, 0, 0,
						0.98, -1
					);
				}
			}
		}
		XPSG FFF 1 Bright Light("FDBTSXPlasmaBlueImpactFancy1") A_FadeTo(0, 0.1, 1);
		XPSG GGG 1 Bright Light("FDBTSXPlasmaBlueImpactFancy2") A_FadeTo(0, 0.1, 1);
		Stop;
	}

	private action void A_BTSXPlasmaProjectile_SpawnParticlesFancy()
	{
		let r = RandomPick(9, 6, 3);

		for (uint i = 0; i < r; i++)
		{
			A_SpawnParticle(
				"72e0f1",
				SPF_FULLBRIGHT | SPF_RELATIVE | SPF_RELANG,
				Random(8, 16), Random(2, 3), 0,
				FRandom(-16.0, 16.0), FRandom(-4.2, 4.2), FRandom(-4.2, 4.2),
				0, 0, 0,
				0, 0, 0,
				0.5,
				-1
			);
		}
	}
}
