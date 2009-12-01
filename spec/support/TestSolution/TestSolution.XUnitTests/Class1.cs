using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Xunit;

namespace TestSolution.Tests
{
    public class SomeTestFixture
    {
        [Fact]
        public void foo()
        {
            Class1 c1 = new Class1();
            string s = c1.Foo();
            Assert.Equal("bar", s);
        }
    }
}
