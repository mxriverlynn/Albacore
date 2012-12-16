using System.IO;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Palmmedia.ReportGenerator.Parser.CodeAnalysis;

namespace Palmmedia.ReportGeneratorTest.Parser.CodeAnalysis
{
    /// <summary>
    /// This is a test class for SourceCodeAnalyzer and is intended
    /// to contain all SourceCodeAnalyzer Unit Tests
    /// </summary>
    [TestClass()]
    public class SourceCodeAnalyzerTest
    {
        private static string classFile = Path.Combine(FileManager.GetCodeAnalysisDirectory(), "AnalyzerTestClass.cs");

        /// <summary>
        /// A test for FindMethod
        /// </summary>
        [TestMethod()]
        public void FindMethod_SearchExistingMethod_PositionMustNotBeNullAndSupplyCorrectLinenumber()
        {
            PartCoverMethodElement partCoverMethodElement = new PartCoverMethodElement(
                "AnalyzerTestClass",
                "DoSomething",
                "string  (string, string[], System.Guid, string, string, System.Decimal, int, stringint, ref int, float, double, bool, unsigned byte, char, object, byte, short, unsigned int, unsigned long, unsigned short, ICSharpCode.NRefactory.Ast.INode)");

            var methodPosition = SourceCodeAnalyzer.FindSourceElement(classFile, partCoverMethodElement);

            Assert.IsNotNull(methodPosition, "MethodPosition must not be null.");

            Assert.AreEqual(35, methodPosition.Start, "Start line number does not match.");
            Assert.AreEqual(38, methodPosition.End, "End line number does not match.");
        }

        /// <summary>
        /// A test for FindMethod
        /// </summary>
        [TestMethod()]
        public void FindMethod_SearchExistingConstructor_PositionMustNotBeNullAndSupplyCorrectLinenumber()
        {
            PartCoverMethodElement partCoverMethodElement = new PartCoverMethodElement(
                "AnalyzerTestClass",
                ".ctor",
                "void  ()");

            var methodPosition = SourceCodeAnalyzer.FindSourceElement(classFile, partCoverMethodElement);

            Assert.IsNotNull(methodPosition, "MethodPosition must not be null.");

            Assert.AreEqual(10, methodPosition.Start, "Start line number does not match.");
            Assert.AreEqual(12, methodPosition.End, "End line number does not match.");
        }

        /// <summary>
        /// A test for FindMethod
        /// </summary>
        [TestMethod()]
        public void FindMethod_SearchNonExistingGenericMethod_PositionIsNull()
        {
            PartCoverMethodElement partCoverMethodElement = new PartCoverMethodElement(
                "AnalyzerTestClass",
                "GenericMethod",
                "void  (int)");

            var methodPosition = SourceCodeAnalyzer.FindSourceElement(classFile, partCoverMethodElement);

            Assert.IsNull(methodPosition, "MethodPosition is not null.");
        }

        /// <summary>
        /// A test for FindProperty
        /// </summary>
        [TestMethod()]
        public void FindProperty_SearchExistingProperty_PositionMustNotBeNullAndSupplyCorrectLinenumber()
        {
            PropertyElement propertyElement = new PropertyElement("get_AutoProperty");

            var propertyPosition = SourceCodeAnalyzer.FindSourceElement(classFile, propertyElement);

            Assert.IsNotNull(propertyPosition, "PropertyPosition must not be null.");

            Assert.AreEqual(44, propertyPosition.Start, "Start line number does not match.");
            Assert.AreEqual(44, propertyPosition.End, "End line number does not match.");
        }

        /// <summary>
        /// A test for FindProperty
        /// </summary>
        [TestMethod()]
        public void FindProperty_SearchNonExistingProperty_PositionIsNull()
        {
            PropertyElement propertyElement = new PropertyElement("get_DoesNotExist");

            var propertyPosition = SourceCodeAnalyzer.FindSourceElement(classFile, propertyElement);

            Assert.IsNull(propertyPosition, "PropertyPosition is not null.");
        }
    }
}
