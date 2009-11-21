using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;

namespace TestSolution.FailingTests
{
	[TestFixture]
	public class FailingTestFixture
	{

		[Test]
		public void FailingTest()
		{
			Assert.Fail("I'm A Failing Test!");
		}
	}
}
