using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Palmmedia.ReportGenerator.Parser.Filesearch;

namespace Palmmedia.ReportGeneratorTest.Parser.Filesearch
{
    /// <summary>
    /// This is a test class for NCoverParserTest and is intended
    /// to contain all NCoverParserTest Unit Tests
    /// </summary>
    [TestClass()]
    public class CommonStringSearcherTest
    {
        #region Additional test attributes
        // You can use the following additional attributes as you write your tests:

        //// Use ClassInitialize to run code before running the first test in the class
        //[ClassInitialize()]
        //public static void MyClassInitialize(TestContext testContext)
        //{
        //}

        //// Use ClassCleanup to run code after all tests in a class have run
        //[ClassCleanup()]
        //public static void MyClassCleanup()
        //{
        //}

        // Use TestInitialize to run code before running each test
        // [TestInitialize()]
        // public void MyTestInitialize()
        // {
        // }

        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup()
        // {
        // }
        #endregion

        /// <summary>
        /// A test for GetCommonPrefix
        /// </summary>
        [TestMethod()]
        [ExpectedException(typeof(ArgumentNullException))]
        public void GetCommonPrefix_PassNull_ArgumentNullExceptionIsThrown()
        {
            CommonStringSearcher.GetCommonPrefix(null);
        }


        /// <summary>
        /// A test for GetCommonPrefix
        /// </summary>
        [TestMethod()]
        public void GetCommonPrefix_EmptyArray_Null()
        {
            Assert.IsNull(CommonStringSearcher.GetCommonPrefix(new string[] { }));
        }

        /// <summary>
        /// A test for GetCommonPrefix
        /// </summary>
        [TestMethod()]
        public void GetCommonPrefix_NoCommonString_EmptyString()
        {
            Assert.AreEqual(string.Empty, CommonStringSearcher.GetCommonPrefix(new [] { "a", "b" }));
        }

        /// <summary>
        /// A test for GetCommonPrefix
        /// </summary>
        [TestMethod()]
        public void GetCommonPrefix_SingleCharacterCommonString_CommonString()
        {
            Assert.AreEqual("a", CommonStringSearcher.GetCommonPrefix(new[] { "a", "ab" }));
        }

        /// <summary>
        /// A test for GetCommonPrefix
        /// </summary>
        [TestMethod()]
        public void GetCommonPrefix_SeveralCharacterCommonString_CommonString()
        {
            Assert.AreEqual("abc.", CommonStringSearcher.GetCommonPrefix(new[] { "abc.xyz", "abc.def", "abc.rst" }));
        }
    }
}
