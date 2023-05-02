version "2.4"

class ZSBENCH_EventHandler : EventHandler
{
	const SAMPLE_SIZE = 50;

	final override void ConsoleProcess(ConsoleEvent event)
	{
		if (!(event.name ~== "zsbench"))
			return;

		let fibr = 0;

		for (uint i = 0; i < SAMPLE_SIZE; i++)
		{
			let start = MSTime();
			let n = FibRecur(34);
			fibr += MSTime() - start;

			if (n != 5702887)
			{
				ThrowAbortException("???");
			}
		}

		let fibi = 0;

		for (uint i = 0; i < SAMPLE_SIZE; i++)
		{
			let start = MSTime();
			let n = FibIter(34);
			fibi += MSTime() - start;

			if (n != 5702887)
			{
				ThrowAbortException("???");
			}
		}

		Console.Printf("Fibonacci recursive: %dms", fibr / SAMPLE_SIZE);
		Console.Printf("Fibonacci iterative: %dms", fibi / SAMPLE_SIZE);
	}

	private clearscope int FibRecur(int n)
	{
		if (n < 2)
			return n;

		return FibRecur(n - 2) + FibRecur(n - 1);
	}

	private clearscope int FibIter(int n)
	{
		int last = 0, cur = 1, temp;
		n = n - 1;

		while (n)
		{
			--n;
			temp = cur;
			cur = last + cur;
			last = temp;
		}

		return cur;
	}
}
