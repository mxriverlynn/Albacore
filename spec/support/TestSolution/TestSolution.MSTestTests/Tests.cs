using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace TestSolution.MSTestTests
{
    [TestClass]
    public class Tests
    {
        [TestMethod]
        public void APassingTest()
        {
            Assert.AreEqual(1,1);
        }

        [TestMethod]
        public void AFailingTest()
        {
            Assert.Fail("a failing test");
        }
    }
}
