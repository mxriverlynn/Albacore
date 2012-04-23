using System.IO;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Palmmedia.ReportGenerator.Parser;

namespace Palmmedia.ReportGeneratorTest.Parser
{
    /// <summary>
    /// This is a test class for ParserFactoryTest and is intended
    /// to contain all ParserFactoryTest Unit Tests
    /// </summary>
    [TestClass()]
    public class ParserFactoryTest
    {
        #region Additional test attributes
        // You can use the following additional attributes as you write your tests:

        // Use ClassInitialize to run code before running the first test in the class
        [ClassInitialize()]
        public static void MyClassInitialize(TestContext testContext)
        {
        }

        // Use ClassCleanup to run code after all tests in a class have run
        [ClassCleanup()]
        public static void MyClassCleanup()
        {
        }

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
        /// A test for CreateParser
        /// </summary>
        [TestMethod()]
        public void CreateParserTest()
        {
            // Single reports
            string filePath = Path.Combine(FileManager.GetReportDirectory(), "Partcover2.3.xml");
            Assert.IsInstanceOfType(ParserFactory.CreateParser(new string[] { filePath }), typeof(PartCover23Parser), "Wrong type");

            filePath = Path.Combine(FileManager.GetReportDirectory(), "Partcover2.2.xml");
            Assert.IsInstanceOfType(ParserFactory.CreateParser(new string[] { filePath }), typeof(PartCover22Parser), "Wrong type");

            filePath = Path.Combine(FileManager.GetReportDirectory(), "NCover1.5.8.xml");
            Assert.IsInstanceOfType(ParserFactory.CreateParser(new string[] { filePath }), typeof(NCoverParser), "Wrong type");

            filePath = Path.Combine(FileManager.GetReportDirectory(), "OpenCover.xml");
            Assert.IsInstanceOfType(ParserFactory.CreateParser(new string[] { filePath }), typeof(OpenCoverParser), "Wrong type");

            // Multi reports - Single file
            filePath = Path.Combine(FileManager.GetReportDirectory(), "MultiPartcover2.3.xml");
            Assert.IsInstanceOfType(ParserFactory.CreateParser(new string[] { filePath }), typeof(MultiReportParser), "Wrong type");

            filePath = Path.Combine(FileManager.GetReportDirectory(), "MultiPartcover2.2.xml");
            Assert.IsInstanceOfType(ParserFactory.CreateParser(new string[] { filePath }), typeof(MultiReportParser), "Wrong type");

            filePath = Path.Combine(FileManager.GetReportDirectory(), "MultiNCover1.5.8.xml");
            Assert.IsInstanceOfType(ParserFactory.CreateParser(new string[] { filePath }), typeof(MultiReportParser), "Wrong type");

            filePath = Path.Combine(FileManager.GetReportDirectory(), "MultiOpenCover.xml");
            Assert.IsInstanceOfType(ParserFactory.CreateParser(new string[] { filePath }), typeof(MultiReportParser), "Wrong type");

            // Multi reports - Several files
            filePath = Path.Combine(FileManager.GetReportDirectory(), "Partcover2.2.xml");
            string filePath2 = Path.Combine(FileManager.GetReportDirectory(), "Partcover2.3.xml");
            Assert.IsInstanceOfType(ParserFactory.CreateParser(new string[] { filePath, filePath2 }), typeof(MultiReportParser), "Wrong type");

            filePath2 = Path.Combine(FileManager.GetReportDirectory(), "MultiPartcover2.3.xml");
            Assert.IsInstanceOfType(ParserFactory.CreateParser(new string[] { filePath, filePath2 }), typeof(MultiReportParser), "Wrong type");

            filePath2 = Path.Combine(FileManager.GetReportDirectory(), "OpenCover.xml");
            Assert.IsInstanceOfType(ParserFactory.CreateParser(new string[] { filePath, filePath2 }), typeof(MultiReportParser), "Wrong type");

            // No report
            Assert.IsNull(ParserFactory.CreateParser(new string[] { string.Empty }), "Excepted null");
        }
    }
}
