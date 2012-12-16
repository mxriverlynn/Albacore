using System;

namespace Test
{
    class TestClass
    {
        public void SampleFunction()
        {
            Console.WriteLine("Hellow World");
            int i = 10;

            if (i > 0)
            {
                Console.WriteLine(i + " is greater that 0");
            }
            else
            {
                Console.WriteLine(i + " is not greater that 0");
            }
        }

        public class NestedClass
        {
            public void SampleFunction()
            {
                Console.WriteLine("Hello World");
            }
        }
    }
}