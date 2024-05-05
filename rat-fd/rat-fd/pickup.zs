/// Functionality needed for waste-proof pickups.
mixin class ratfd_Pickup
{
	default
	{
		+DONTGIB
	}

	meta string PARTIAL_PICKUP_MESSAGE;
	property PartialPickupMessage: PARTIAL_PICKUP_MESSAGE;
	meta string FOUND_MESSAGE;
	property FoundMessage: FOUND_MESSAGE;
	meta string FINISHED_MESSAGE;
	property FinishedMessage: FINISHED_MESSAGE;

	/// Duplicates the behavior of `Inventory::PlayPickupSound()`.
	private void PlayCollectedSound(Actor collector)
	{
		double atten = self.bNoAttenPickupSound ? ATTN_NONE : ATTN_NORM;
		int chan = CHAN_AUTO;
		int flags = CHANF_DEFAULT;

		if (collector != null && collector.CheckLocalView())
			flags = CHANF_NOPAUSE | CHANF_MAYBE_LOCAL;
		else
			flags = CHANF_MAYBE_LOCAL;

		collector.A_StartSound("misc/i_pkup", chan, flags, 1, atten);
	}

	private void MarkAsCollected(Actor collector)
	{
		self.PlayCollectedSound(collector);
		self.PrintPickupMessage(collector.CheckLocalView(), self.FOUND_MESSAGE);
		self.bCountItem = false;
		Level.Found_Items++;
		self.A_SetTranslation('ratfd_Pkup75');
	}

	private void OnPartialPickup(Actor picker)
	{
		if (self.pickupFlash != null)
			Actor.Spawn(self.pickupFlash, self.pos, ALLOW_REPLACE);

		// Special check so voodoo dolls picking up items cause the
		// real player to make noise.
		if (picker.player != null)
			self.PlayPickupSound(picker.player.mo);
		else
			self.PlayPickupSound(picker);

		self.PrintPickupMessage(picker.CheckLocalView(), self.PARTIAL_PICKUP_MESSAGE);

		if (self.amount <= (self.default.amount * 0.25))
			self.A_SetTranslation('ratfd_Pkup25');
		else if (self.amount <= (self.default.amount * 0.5))
			self.A_SetTranslation('ratfd_Pkup50');
		else if (self.amount <= (self.default.amount * 0.75))
			self.A_SetTranslation('ratfd_Pkup75');
	}
}
