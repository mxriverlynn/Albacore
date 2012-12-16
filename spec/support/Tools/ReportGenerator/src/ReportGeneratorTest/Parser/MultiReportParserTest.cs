using System.IO;
using System.Linq;
using System.Xml.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Palmmedia.ReportGenerator.Parser;

namespace Palmmedia.ReportGeneratorTest.Parser
{
    /// <summary>
    /// This is a test class for MultiReportParserTest and is intended
    /// to contain all MultiReportParserTest Unit Tests
    /// </summary>
    [TestClass()]
    public class MultiReportParserTest
    {
        private static readonly string filePath1 = Path.Combine(FileManager.GetReportDirectory(), "Partcover2.2.xml");

        private static readonly string filePath2 = Path.Combine(FileManager.GetReportDirectory(), "Partcover2.3.xml");

        private static IParser parser;

        // Use ClassInitialize to run code before running the first test in the class
        [ClassInitialize()]
        public static void MyClassInitialize(TestContext testContext)
        {
            var report = XDocument.Load(filePath1);
            var parser1 = new PartCover22Parser(report);

            report = XDocument.Load(filePath2);
            var parser2 = new PartCover23Parser(report);

            parser = new MultiReportParser(new IParser[] { parser1, parser2 });
        }

        // Use ClassCleanup to run code after all tests in a class have run
        [ClassCleanup()]
        public static void MyClassCleanup()
        {
        }

        /// <summary>
        /// A test for NumberOfLineVisits
        /// </summary>
        [TestMethod()]
        public void NumberOfLineVisitsTest()
        {
            Assert.AreEqual(2, parser.NumberOfLineVisits("Test", "Test.TestClass", "C:\\temp\\TestClass.cs", 14), "Wrong number of line visits");

            Assert.AreEqual(0, parser.NumberOfLineVisits("Test", "Test.TestClass", "C:\\temp\\TestClass.cs", 18), "Wrong number of line visits");

            Assert.AreEqual(0, parser.NumberOfLineVisits("Test", "Test.TestClass2", "C:\\temp\\TestClass2.cs", 19), "Wrong number of line visits");

            Assert.AreEqual(4, parser.NumberOfLineVisits("Test", "Test.TestClass2", "C:\\temp\\TestClass2.cs", 25), "Wrong number of line visits");

            Assert.AreEqual(2, parser.NumberOfLineVisits("Test", "Test.TestClass2", "C:\\temp\\TestClass2.cs", 31), "Wrong number of line visits");

            Assert.AreEqual(0, parser.NumberOfLineVisits("Test", "Test.TestClass2", "C:\\temp\\TestClass2.cs", 37), "Wrong number of line visits");

            Assert.AreEqual(8, parser.NumberOfLineVisits("Test", "Test.TestClass2", "C:\\temp\\TestClass2.cs", 54), "Wrong number of line visits");

            Assert.AreEqual(0, parser.NumberOfLineVisits("Test", "Test.TestClass2", "C:\\temp\\TestClass2.cs", 81), "Wrong number of line visits");

            Assert.AreEqual(2, parser.NumberOfLineVisits("Test", "Test.PartialClass", "C:\\temp\\PartialClass.cs", 9), "Wrong number of line visits");

            Assert.AreEqual(0, parser.NumberOfLineVisits("Test", "Test.PartialClass", "C:\\temp\\PartialClass.cs", 14), "Wrong number of line visits");

            Assert.AreEqual(2, parser.NumberOfLineVisits("Test", "Test.PartialClass", "C:\\temp\\PartialClass2.cs", 9), "Wrong number of line visits");

            Assert.AreEqual(0, parser.NumberOfLineVisits("Test", "Test.PartialClass", "C:\\temp\\PartialClass2.cs", 14), "Wrong number of line visits");
        }

        /// <summary>
        /// A test for NumberOfFiles
        /// </summary>
        [TestMethod()]
        public void NumberOfFilesTest()
        {
            Assert.AreEqual(5, parser.Files().Count(), "Wrong number of files");
        }

        /// <summary>
        /// A test for FilesOfClass
        /// </summary>
        [TestMethod()]
        public void FilesOfClassTest()
        {
            Assert.AreEqual(1, parser.FilesOfClass("Test", "Test.TestClass").Count(), "Wrong number of files");
            Assert.AreEqual(2, parser.FilesOfClass("Test", "Test.PartialClass").Count(), "Wrong number of files");
        }

        /// <summary>
        /// A test for ClassesInAssembly
        /// </summary>
        [TestMethod()]
        public void ClassesInAssemblyTest()
        {
            Assert.AreEqual(7, parser.ClassesInAssembly("Test").Count(), "Wrong number of classes");
        }

        /// <summary>
        /// A test for Assemblies
        /// </summary>
        [TestMethod()]
        public void AssembliesTest()
        {
            Assert.AreEqual(1, parser.Assemblies().Count(), "Wrong number of assemblies");
        }

        /// <summary>
        ///A test for MethodMetrics
        /// </summary>
        [TestMethod()]
        public void MethodMetricsTest()
        {
            Assert.AreEqual(0, parser.MethodMetrics("Test", "Test.TestClass").Count(), "Wrong number of metrics");
        }

        /// <summary>
        /// A test for MethodMetrics
        /// </summary>
        [TestMethod()]
        public void OpenCoverMethodMetricsTest()
        {
            string filePath = Path.Combine(FileManager.GetReportDirectory(), "MultiOpenCover.xml");
            var multiReportParser = ParserFactory.CreateParser(new string[] { filePath });
            Assert.IsInstanceOfType(multiReportParser, typeof(MultiReportParser), "Wrong type");

            var metrics = multiReportParser.MethodMetrics(@"Test", "Test.TestClass");

            Assert.AreEqual(1, metrics.Count(), "Wrong number of method metrics");
            Assert.AreEqual("SampleFunction()", metrics.First().Name, "Wrong name of method");
            Assert.AreEqual(3, metrics.First().Metrics.Count(), "Wrong number of metrics");

            Assert.AreEqual("Cyclomatic Complexity", metrics.First().Metrics.ElementAt(0).Name, "Wrong name of metric");
            Assert.AreEqual(111, metrics.First().Metrics.ElementAt(0).Value, "Wrong value of metric");
            Assert.AreEqual("Sequence Coverage", metrics.First().Metrics.ElementAt(1).Name, "Wrong name of metric");
            Assert.AreEqual(222, metrics.First().Metrics.ElementAt(1).Value, "Wrong value of metric");
            Assert.AreEqual("Branch Coverage", metrics.First().Metrics.ElementAt(2).Name, "Wrong name of metric");
            Assert.AreEqual(333, metrics.First().Metrics.ElementAt(2).Value, "Wrong value of metric");
        }
    }
}
