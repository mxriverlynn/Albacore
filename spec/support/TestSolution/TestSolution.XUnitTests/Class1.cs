using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Xunit;

namespace TestSolution.XUnitTests
{
	public class SomeTestFixture
	{
		[Fact]
        [Trait("type","passing")]
		public void foo()
		{
			Class1 c1 = new Class1();
			string s = c1.Foo();
			Assert.Equal("bar", s);
		}
	}
}