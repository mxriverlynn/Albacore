
namespace Test
{
    class Program
    {
        static void Main(string[] args)
        {
            new TestClass().SampleFunction();

            new TestClass2("Test").ExecutedMethod();
            new TestClass2("Test").SampleFunction("Munich");

            new PartialClass().ExecutedMethod_1();
            new PartialClass().ExecutedMethod_2();
            new PartialClass().SomeProperty = -10;

            new PartialClassWithAutoProperties().Property1 = "Test";
            new PartialClassWithAutoProperties().Property2 = "Test";

            new SomeClass().Property1 = "Test";

            new ClassWithExcludes().IncludedMethod();
            new ClassWithExcludes().ExcludedMethod();
        }
    }
}
