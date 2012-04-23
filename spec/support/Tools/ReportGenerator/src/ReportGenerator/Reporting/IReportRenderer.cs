using System.Collections.Generic;
using Palmmedia.ReportGenerator.Analysis;
using Palmmedia.ReportGenerator.Parser;

namespace Palmmedia.ReportGenerator.Reporting
{
    /// <summary>
    /// Interface for report renderers.
    /// </summary>
    public interface IReportRenderer
    {
        /// <summary>
        /// Begins the summary report.
        /// </summary>
        /// <param name="title">The title.</param>
        void BeginSummaryReport(string title);

        /// <summary>
        /// Begins the class report.
        /// </summary>
        /// <param name="className">Name of the class.</param>
        void BeginClassReport(string className);

        /// <summary>
        /// Saves a summary report.
        /// </summary>
        /// <param name="targetDirectory">The target directory.</param>
        void SaveSummaryReport(string targetDirectory);

        /// <summary>
        /// Saves a class report.
        /// </summary>
        /// <param name="targetDirectory">The target directory.</param>
        /// <param name="assemblyName">Name of the assembly.</param>
        /// <param name="className">Name of the class.</param>
        void SaveClassReport(string targetDirectory, string assemblyName, string className);

        /// <summary>
        /// Adds a header to the report.
        /// </summary>
        /// <param name="text">The text.</param>
        void Header(string text);

        /// <summary>
        /// Adds a file of a class to a report.
        /// </summary>
        /// <param name="path">The path of the file.</param>
        void File(string path);

        /// <summary>
        /// Adds a paragraph to the report.
        /// </summary>
        /// <param name="text">The text.</param>
        void Paragraph(string text);

        /// <summary>
        /// Adds a table with two columns to the report.
        /// </summary>
        void BeginKeyValueTable();

        /// <summary>
        /// Adds a summary table to the report.
        /// </summary>
        void BeginSummaryTable();

        /// <summary>
        /// Adds a metrics table to the report.
        /// </summary>
        /// <param name="headers">The headers.</param>
        void BeginMetricsTable(IEnumerable<string> headers);

        /// <summary>
        /// Adds a file analysis table to the report.
        /// </summary>
        /// <param name="headers">The headers.</param>
        void BeginLineAnalysisTable(IEnumerable<string> headers);

        /// <summary>
        /// Adds a table row with two cells to the report.
        /// </summary>
        /// <param name="key">The text of the first column.</param>
        /// <param name="value">The text of the second column.</param>
        void KeyValueRow(string key, string value);

        /// <summary>
        /// Adds a table row with two cells to the report.
        /// </summary>
        /// <param name="key">The text of the first column.</param>
        /// <param name="files">The files.</param>
        void KeyValueRow(string key, IEnumerable<string> files);

        /// <summary>
        /// Adds the coverage information of an assembly to the report.
        /// </summary>
        /// <param name="assembly">The assembly.</param>
        void SummaryAssembly(Assembly assembly);

        /// <summary>
        /// Adds the coverage information of a class to the report.
        /// </summary>
        /// <param name="clazz">The class.</param>
        void SummaryClass(Class clazz);

        /// <summary>
        /// Adds the given metric values to the report.
        /// </summary>
        /// <param name="metric">The metric.</param>
        void MetricsRow(MethodMetric metric);

        /// <summary>
        /// Adds the coverage information of a single line of a file to the report.
        /// </summary>
        /// <param name="analysis">The line analysis.</param>
        void LineAnalysis(LineAnalysis analysis);

        /// <summary>
        /// Finishes the current table.
        /// </summary>
        void FinishTable();
    }
}
