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

		let sieve = 0;

		for (uint i = 0; i < SAMPLE_SIZE; i++)
		{
			let start = MSTime();
			let n = Sieve(10);
			sieve += MSTime() - start;

			if (n != 123814)
			{
				ThrowAbortException("???");
			}
		}

		Console.Printf("Fibonacci recursive: %dms", fibr / SAMPLE_SIZE);
		Console.Printf("Fibonacci iterative: %dms", fibi / SAMPLE_SIZE);
		Console.Printf("Sieve of Eratosthenes: %dms", sieve / SAMPLE_SIZE);
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

	const SIEVE_SIZE = 819000;

	private clearscope int Sieve(int arg)
	{
		int i, k, prime, count, n;
		bool flags[SIEVE_SIZE];

		for (n = 0; n < arg; n++)
		{
			count = 0;

			for (i = 0; i < SIEVE_SIZE; i++)
				flags[i] = true;

			for (i = 0; i < SIEVE_SIZE; i++)
			{
				if (flags[i])
				{
					prime = i + i + 3;

					for (k = i + prime; k < SIEVE_SIZE; k += prime)
						flags[k] = false;

					count++;
				}
			}
		}

		return count;
	}
}
