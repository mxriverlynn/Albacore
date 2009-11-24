using Machine.Specifications;

namespace TestSolution.MSpecTests
{

	[Subject("some spec test")]
	public class SomeSpecTest
	{
		private static Class1 someclass;
		private static string foo;

		private Establish context = () => { someclass = new Class1(); };

		private Because of = () => { foo = someclass.Foo(); };

		private It should_be_the_right_string = () => foo.ShouldEqual("bar");
	}
}
