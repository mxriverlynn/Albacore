using Microsoft.VisualStudio.TestTools.UnitTesting;
using Palmmedia.ReportGenerator.Reporting;

namespace Palmmedia.ReportGeneratorTest.Reporting
{
    /// <summary>
    /// This is a test class for RendererFactory and is intended
    /// to contain all RendererFactory Unit Tests
    /// </summary>
    [TestClass()]
    public class RendererFactoryTest
    {
        [TestMethod()]
        public void SupportsParallelClassReports_Html_TrueIsReturned()
        {
            var factory = new RendererFactory(ReportType.Html);
            Assert.IsTrue(factory.SupportsParallelClassReports, "True was expected.");

            factory = new RendererFactory(ReportType.HtmlSummary);
            Assert.IsTrue(factory.SupportsParallelClassReports, "True was expected.");
        }

        [TestMethod()]
        public void SupportsParallelClassReports_Xml_TrueIsReturned()
        {
            var factory = new RendererFactory(ReportType.Xml);
            Assert.IsTrue(factory.SupportsParallelClassReports, "True was expected.");

            factory = new RendererFactory(ReportType.XmlSummary);
            Assert.IsTrue(factory.SupportsParallelClassReports, "True was expected.");
        }

        [TestMethod()]
        public void SupportsParallelClassReports_Latex_FalseIsReturned()
        {
            var factory = new RendererFactory(ReportType.Latex);
            Assert.IsFalse(factory.SupportsParallelClassReports, "False was expected.");
        }

        [TestMethod()]
        public void SupportsParallelClassReports_LatexSummary_TrueIsReturned()
        {
            var factory = new RendererFactory(ReportType.LatexSummary);
            Assert.IsTrue(factory.SupportsParallelClassReports, "True was expected.");
        }

        [TestMethod()]
        public void CreateSummaryRenderer_Html_NewInstanceIsCreated()
        {
            var factory = new RendererFactory(ReportType.Html);

            var renderer1 = factory.CreateSummaryRenderer();
            var renderer2 = factory.CreateSummaryRenderer();

            Assert.AreNotSame(renderer1, renderer2, "New instance expected.");
            Assert.IsInstanceOfType(renderer1, typeof(HtmlRenderer), "Wrong type returned.");
        }

        [TestMethod()]
        public void CreateSummaryRenderer_HtmlSummary_NewInstanceIsCreated()
        {
            var factory = new RendererFactory(ReportType.HtmlSummary);

            var renderer1 = factory.CreateSummaryRenderer();
            var renderer2 = factory.CreateSummaryRenderer();

            Assert.AreNotSame(renderer1, renderer2, "New instance expected.");
            Assert.IsInstanceOfType(renderer1, typeof(HtmlRenderer), "Wrong type returned.");
        }

        [TestMethod()]
        public void CreateSummaryRenderer_Xml_NewInstanceIsCreated()
        {
            var factory = new RendererFactory(ReportType.Xml);

            var renderer1 = factory.CreateSummaryRenderer();
            var renderer2 = factory.CreateSummaryRenderer();

            Assert.AreNotSame(renderer1, renderer2, "New instance expected.");
            Assert.IsInstanceOfType(renderer1, typeof(XmlRenderer), "Wrong type returned.");
        }

        [TestMethod()]
        public void CreateSummaryRenderer_XmlSummary_NewInstanceIsCreated()
        {
            var factory = new RendererFactory(ReportType.XmlSummary);

            var renderer1 = factory.CreateSummaryRenderer();
            var renderer2 = factory.CreateSummaryRenderer();

            Assert.AreNotSame(renderer1, renderer2, "New instance expected.");
            Assert.IsInstanceOfType(renderer1, typeof(XmlRenderer), "Wrong type returned.");
        }

        [TestMethod()]
        public void CreateSummaryRenderer_Latex_SingletonIsReturned()
        {
            var factory = new RendererFactory(ReportType.Latex);

            var renderer1 = factory.CreateSummaryRenderer();
            var renderer2 = factory.CreateSummaryRenderer();

            Assert.AreSame(renderer1, renderer2, "Singleton instance expected.");
            Assert.IsInstanceOfType(renderer1, typeof(LatexRenderer), "Wrong type returned.");
        }

        [TestMethod()]
        public void CreateSummaryRenderer_LatexSummary_SingletonIsReturned()
        {
            var factory = new RendererFactory(ReportType.LatexSummary);

            var renderer1 = factory.CreateSummaryRenderer();
            var renderer2 = factory.CreateSummaryRenderer();

            Assert.AreSame(renderer1, renderer2, "Singleton instance expected.");
            Assert.IsInstanceOfType(renderer1, typeof(LatexRenderer), "Wrong type returned.");
        }

        [TestMethod()]
        public void CreateClassRenderer_Html_NewInstanceIsCreated()
        {
            var factory = new RendererFactory(ReportType.Html);

            var renderer1 = factory.CreateClassRenderer();
            var renderer2 = factory.CreateClassRenderer();

            Assert.AreNotSame(renderer1, renderer2, "New instance expected.");
            Assert.IsInstanceOfType(renderer1, typeof(HtmlRenderer), "Wrong type returned.");
        }

        [TestMethod()]
        public void CreateClassRenderer_HtmlSummary_NewInstanceIsCreated()
        {
            var factory = new RendererFactory(ReportType.HtmlSummary);

            var renderer = factory.CreateClassRenderer();

            Assert.IsNull(renderer, "Null expected.");
        }

        [TestMethod()]
        public void CreateClassRenderer_Xml_NewInstanceIsCreated()
        {
            var factory = new RendererFactory(ReportType.Xml);

            var renderer1 = factory.CreateClassRenderer();
            var renderer2 = factory.CreateClassRenderer();

            Assert.AreNotSame(renderer1, renderer2, "New instance expected.");
            Assert.IsInstanceOfType(renderer1, typeof(XmlRenderer), "Wrong type returned.");
        }

        [TestMethod()]
        public void CreateClassRenderer_XmlSummary_NewInstanceIsCreated()
        {
            var factory = new RendererFactory(ReportType.XmlSummary);

            var renderer = factory.CreateClassRenderer();

            Assert.IsNull(renderer, "Null expected.");
        }

        [TestMethod()]
        public void CreateClassRenderer_Latex_SingletonIsReturned()
        {
            var factory = new RendererFactory(ReportType.Latex);

            var renderer1 = factory.CreateClassRenderer();
            var renderer2 = factory.CreateClassRenderer();

            Assert.AreSame(renderer1, renderer2, "Singleton instance expected.");
            Assert.IsInstanceOfType(renderer1, typeof(LatexRenderer), "Wrong type returned.");
        }

        [TestMethod()]
        public void CreateClassRenderer_LatexSummary_SingletonIsReturned()
        {
            var factory = new RendererFactory(ReportType.LatexSummary);

            var renderer = factory.CreateClassRenderer();

            Assert.IsNull(renderer, "Null expected.");
        }
    }
}
