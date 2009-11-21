using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;

namespace TestSolution.Tests
{

	[TestFixture]
	public class SomeTestFixture
	{

		[Test]
		public void foo()
		{
			Class1 c1 = new Class1();
			string s = c1.Foo();
			Assert.AreEqual("bar", s);
		}

	}
}
