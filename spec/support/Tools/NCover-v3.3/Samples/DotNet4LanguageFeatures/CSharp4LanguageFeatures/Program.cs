using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSharp4LanguageFeatures
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine();
            Console.WriteLine("Demonstrating Code Contracts");
            int next = CodeContracts.NextEven(6);
            Console.WriteLine("The even number after 6 is {0}", next);
            next = CodeContracts.NextEven(9);
            Console.WriteLine("The even number after 9 is {0}", next);
            next = CodeContracts.NextOdd(4);
            Console.WriteLine("The odd number after 4 is {0}", next);
            next = CodeContracts.NextOdd(7);
            Console.WriteLine("The odd number after 7 is {0}", next);

            Console.WriteLine();
            Console.WriteLine("Demonstrating Dynamic Types");
            dynamic mock = new DynamicMock();
            int expectedValue = 45;
            mock.ExpectMethodCall("newmethod", 2, expectedValue);
            int value = mock.newmethod();
            Console.WriteLine("Expected value: {0} Actual value: {1}", expectedValue, value);

            Console.WriteLine();
            Console.WriteLine("Demonstrating Co-variance and Contra-variance");
            var result3 = GenericVariance.CreateDrinks();
            foreach (var item in result3.Item1)
            {
                Console.WriteLine("Juice: {0}  Gallons: {1}", item.TypeOfJuice, item.Gallons);
            }
            foreach (var item in result3.Item2)
            {
                Console.WriteLine("Juice: {0}  Gallons: {1}", item.TypeOfJuice, item.Gallons);
            }


            Console.WriteLine();
            Console.WriteLine("Demonstrating Named and Optional parameters");
            var named = NamedAndOptionalParameters.Create(new Guid());
            Console.WriteLine("Object Values ["+named.ToString()+"]");
            named = NamedAndOptionalParameters.Create(new Guid(), 5);
            Console.WriteLine("Object Values [" + named.ToString() + "]");
            named = NamedAndOptionalParameters.Create(new Guid(), "Rover");
            Console.WriteLine("Object Values [" + named.ToString() + "]");
            named = NamedAndOptionalParameters.Create(new Guid(), 45, "Rover");
            Console.WriteLine("Object Values [" + named.ToString() + "]");


            Console.WriteLine();
            Console.WriteLine("Demonstrating Parallel Linq");
            int number = 20000;
            Console.WriteLine("Calculating the cross product of 2 vectors with {0:N0} elements.", number);
            //var result5 = ParallelLinq.DemonstrateParallelExtensions(number);
            //Console.WriteLine("Parallel Execution Time: {0:N0}ms  Result: {1:N0}", result5.Item1.Item1.ElapsedMilliseconds, result5.Item1.Item2);
            //Console.WriteLine("Serial Execution Time:   {0:N0}ms  Result: {1:N0}", result5.Item2.Item1.ElapsedMilliseconds, result5.Item2.Item2);
            

        }
    }
}
