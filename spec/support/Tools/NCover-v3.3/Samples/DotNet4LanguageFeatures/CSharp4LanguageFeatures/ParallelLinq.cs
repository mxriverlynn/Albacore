using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.Collections;

namespace CSharp4LanguageFeatures
{
    class ParallelLinq
    {
        public static Tuple<Tuple<Stopwatch, long>, Tuple<Stopwatch, long>> DemonstrateParallelExtensions(int numItems)
        {
            if (numItems < 10)
                numItems = 10;

            var sequence1 = GenerateRandomSequence(numItems, 1, 10);
            var sequence2 = GenerateRandomSequence(numItems, 1, 10);

            var time1 = Stopwatch.StartNew();
            var sum1 = CrossProductParallel(sequence1, sequence2);
            time1.Stop();

            var time2 = Stopwatch.StartNew();
            var sum2 = CrossProductSerial(sequence1, sequence2);
            time2.Stop();

            return new Tuple<Tuple<Stopwatch, long>, Tuple<Stopwatch, long>>(
                new Tuple<Stopwatch, long>(time1, sum1),
                new Tuple<Stopwatch, long>(time2, sum2));
        }

        private static List<long> GenerateRandomSequence(int numItems, int min, int max)
        {
            Random r = new Random(DateTime.Now.Millisecond);
            var list = new List<long>();
            for (int i = 0; i < numItems; i++)
            {
                list.Add(r.Next(min, max));
            }

            return list;
        }
        private static long CrossProductParallel(IList<long> vector1, IList<long> vector2)
        {
            if (vector1.Count != vector2.Count)
                return 0;

            var sum = (from a in vector1.AsParallel()
                       select ((from b in vector2 select b * a).Sum())).Sum();

            return sum;
        }

        private static long CrossProductSerial(IList<long> vector1, IList<long> vector2)
        {
            if (vector1.Count != vector2.Count)
                return 0;

            long sum = 0;

            for (int i = 0; i < vector1.Count; i++)
            {
                for (int j = 0; j < vector2.Count; j++)
                {
                    sum += vector1[i] * vector2[j];
                }
            }

            return sum;
        }
    }
}
