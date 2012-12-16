using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml.Linq;
using log4net;
using Palmmedia.ReportGenerator.Analysis;
using Palmmedia.ReportGenerator.Parser;

namespace Palmmedia.ReportGenerator.Reporting
{
    /// <summary>
    /// XML report renderer.
    /// </summary>
    public class XmlRenderer : RendererBase, IReportRenderer
    {
        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog logger = LogManager.GetLogger(typeof(XmlRenderer));

        /// <summary>
        /// The overall document.
        /// </summary>
        private XDocument document;

        /// <summary>
        /// The current element to which child elements are added.
        /// </summary>
        private XElement currentElement;

        /// <summary>
        /// The current element representing an assembly to which child elements are added.
        /// </summary>
        private XElement currentAssembly;

        /// <summary>
        /// The current element representing an file to which child elements are added.
        /// </summary>
        private XElement currentFile;

        /// <summary>
        /// Begins the summary report.
        /// </summary>
        /// <param name="title">The title.</param>
        public void BeginSummaryReport(string title)
        {
            this.document = new XDocument(new XElement("CoverageReport", new XAttribute("scope", title)));
        }

        /// <summary>
        /// Begins the class report.
        /// </summary>
        /// <param name="className">Name of the class.</param>
        public void BeginClassReport(string className)
        {
            this.document = new XDocument(new XElement("CoverageReport", new XAttribute("scope", className)));
        }

        /// <summary>
        /// Adds a header to the report.
        /// </summary>
        /// <param name="text">The text.</param>
        public void Header(string text)
        {
            this.currentElement = new XElement(ReplaceInvalidXmlChars(text));
            this.document.Root.Add(this.currentElement);
        }

        /// <summary>
        /// Adds a file of a class to a report.
        /// </summary>
        /// <param name="path">The path of the file.</param>
        public void File(string path)
        {
            var file = new XElement("File", new XAttribute("name", path));
            this.currentElement.Add(file);
            this.currentFile = file;
        }

        /// <summary>
        /// Adds a paragraph to the report.
        /// </summary>
        /// <param name="text">The text.</param>
        public void Paragraph(string text)
        {
        }

        /// <summary>
        /// Adds a table with two columns to the report.
        /// </summary>
        public void BeginKeyValueTable()
        {
        }

        /// <summary>
        /// Adds a summary table to the report.
        /// </summary>
        public void BeginSummaryTable()
        {
        }

        /// <summary>
        /// Adds a metrics table to the report.
        /// </summary>
        /// <param name="headers">The headers.</param>
        public void BeginMetricsTable(IEnumerable<string> headers)
        {
        }

        /// <summary>
        /// Adds a file analysis table to the report.
        /// </summary>
        /// <param name="headers">The headers.</param>
        public void BeginLineAnalysisTable(IEnumerable<string> headers)
        {
        }

        /// <summary>
        /// Adds a table row with two cells to the report.
        /// </summary>
        /// <param name="key">The text of the first column.</param>
        /// <param name="value">The text of the second column.</param>
        public void KeyValueRow(string key, string value)
        {
            this.currentElement.Add(new XElement(ReplaceInvalidXmlChars(key), value));
        }

        /// <summary>
        /// Adds a table row with two cells to the report.
        /// </summary>
        /// <param name="key">The text of the first column.</param>
        /// <param name="files">The files.</param>
        public void KeyValueRow(string key, IEnumerable<string> files)
        {
            if (files == null)
            {
                throw new ArgumentNullException("files");
            }

            var root = new XElement(ReplaceInvalidXmlChars(key));

            foreach (var file in files)
            {
                root.Add(new XElement("File", file));
            }

            this.currentElement.Add(root);
        }

        /// <summary>
        /// Adds the given metric values to the report.
        /// </summary>
        /// <param name="metric">The metric.</param>
        public void MetricsRow(MethodMetric metric)
        {
            if (metric == null)
            {
                throw new ArgumentNullException("metric");
            }

            this.currentElement.Add(new XElement(
                ReplaceInvalidXmlChars(metric.Name),
                metric.Metrics.Select(m => new XElement(ReplaceInvalidXmlChars(m.Name), m.Value))));
        }

        /// <summary>
        /// Adds the coverage information of a single line of a file to the report.
        /// </summary>
        /// <param name="analysis">The line analysis.</param>
        public void LineAnalysis(LineAnalysis analysis)
        {
            if (analysis == null)
            {
                throw new ArgumentNullException("analysis");
            }

            var coverage = new XElement(
                "LineAnalysis",
                new XAttribute("line", analysis.LineNumber),
                new XAttribute("visits", analysis.LineVisits),
                new XAttribute("coverage", analysis.LineVisitStatus),
                new XAttribute("content", analysis.LineContent));

            this.currentFile.Add(coverage);
        }

        /// <summary>
        /// Finishes the current table.
        /// </summary>
        public void FinishTable()
        {
        }

        /// <summary>
        /// Adds the coverage information of an assembly to the report.
        /// </summary>
        /// <param name="assembly">The assembly.</param>
        public void SummaryAssembly(Assembly assembly)
        {
            var coverage = new XElement(
                "Assembly",
                new XAttribute("name", assembly.Name),
                new XAttribute("classes", assembly.Classes.Count()),
                new XAttribute("coverage", assembly.CoverageQuota),
                new XAttribute("coveredlines", assembly.CoveredLines),
                new XAttribute("coverablelines", assembly.CoverableLines),
                new XAttribute("totallines", assembly.TotalLines));

            this.currentElement.Add(coverage);

            this.currentAssembly = coverage;
        }

        /// <summary>
        /// Adds the coverage information of a class to the report.
        /// </summary>
        /// <param name="clazz">The class.</param>
        public void SummaryClass(Class clazz)
        {
            var coverage = new XElement(
                "Class",
                new XAttribute("name", clazz.Name),
                new XAttribute("coverage", clazz.CoverageQuota),
                new XAttribute("coveredlines", clazz.CoveredLines),
                new XAttribute("coverablelines", clazz.CoverableLines),
                new XAttribute("totallines", clazz.TotalLines));

            this.currentAssembly.Add(coverage);
        }

        /// <summary>
        /// Saves a summary report.
        /// </summary>
        /// <param name="targetDirectory">The target directory.</param>
        public void SaveSummaryReport(string targetDirectory)
        {
            this.SaveReport(targetDirectory, "Summary.xml");
        }

        /// <summary>
        /// Saves a class report.
        /// </summary>
        /// <param name="targetDirectory">The target directory.</param>
        /// <param name="assemblyName">Name of the assembly.</param>
        /// <param name="className">Name of the class.</param>
        public void SaveClassReport(string targetDirectory, string assemblyName, string className)
        {
            this.SaveReport(targetDirectory, ReplaceInvalidPathChars(assemblyName + "_" + className) + ".xml");
        }

        /// <summary>
        /// Saves the report.
        /// </summary>
        /// <param name="targetDirectory">The target directory.</param>
        /// <param name="fileName">Name of the file.</param>
        private void SaveReport(string targetDirectory, string fileName)
        {
            string targetPath = Path.Combine(targetDirectory, fileName);

            try
            {
                this.document.Save(targetPath);
            }
            catch (IOException ex)
            {
                logger.ErrorFormat("Report '{0}' could not be saved: {1}", targetPath, ex.Message);
            }

            this.document = null;
        }
    }
}
