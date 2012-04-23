using Microsoft.VisualStudio.TestTools.UnitTesting;
using Palmmedia.ReportGenerator.Analysis;

namespace Palmmedia.ReportGeneratorTest.Analysis
{
    /// <summary>
    /// This is a test class for ClassTest and is intended
    /// to contain all ClassTest Unit Tests
    /// </summary>
    [TestClass()]
    public class ClassTest
    {
        /// <summary>
        /// A test for Class Constructor
        /// </summary>
        [TestMethod()]
        public void ClassConstructorTest()
        {
            string assemblyname = "C:\\test\\TestAssembly.dll";
            string classname = "TestClass";

            var target = new Class(assemblyname, classname);

            Assert.AreEqual(assemblyname, target.AssemblyName, "Not equal");
            Assert.AreEqual("TestAssembly.dll", target.ShortAssemblyName, "Not equal");
            Assert.AreEqual(classname, target.Name, "Not equal");
        }

        /// <summary>
        /// A test for Equals
        /// </summary>
        [TestMethod()]
        public void EqualsTest()
        {
            string assemblyname = "TestAssembly";
            string classname = "TestClass";

            var target1 = new Class(assemblyname, classname);
            var target2 = new Class(assemblyname, classname);

            Assert.IsTrue(target1.Equals(target2), "Objects are not equal");

            Assert.IsFalse(target1.Equals(null), "Objects are equal");

            Assert.IsFalse(target1.Equals(new object()), "Objects are equal");
        }
    }
}
