using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using log4net;
using Palmmedia.ReportGenerator.Analysis;
using Palmmedia.ReportGenerator.Parser;

namespace Palmmedia.ReportGenerator.Reporting
{
    /// <summary>
    /// Latex report renderer.
    /// </summary>
    public class LatexRenderer : RendererBase, IReportRenderer
    {
        #region Latex Snippets

        /// <summary>
        /// The head of each generated Latex file.
        /// </summary>
        private const string LatexStart = @"\documentclass[a4paper,10pt]{{article}}
\usepackage[paper=a4paper,left=20mm,right=20mm,top=20mm,bottom=20mm]{{geometry}}
\usepackage{{longtable}}
\usepackage{{fancyhdr}}
\usepackage[pdftex]{{color}}
\usepackage{{colortbl}}
\definecolor{{green}}{{rgb}}{{0,1,0.12}}
\definecolor{{red}}{{rgb}}{{1,0,0}}
\definecolor{{gray}}{{rgb}}{{0.86,0.86,0.86}}

\usepackage[pdftex,
            colorlinks=true, linkcolor=red, urlcolor=green, citecolor=red,%
            raiselinks=true,%
            bookmarks=true,%
            bookmarksopenlevel=1,%
            bookmarksopen=true,%
            bookmarksnumbered=true,%
            hyperindex=true,% 
            plainpages=false,% correct hyperlinks
            pdfpagelabels=true%,% view TeX pagenumber in PDF reader
            %pdfborder={{0 0 0.5}}
            ]{{hyperref}}

\hypersetup{{pdftitle={{Coverage Report}},
            pdfauthor={{{0} - {1}}}
           }}

\pagestyle{{fancy}}
\fancyhead[LE,LO]{{\leftmark}}
\fancyhead[R]{{\thepage}}
\fancyfoot[C]{{{0} - {1}}}

\begin{{document}}

\setcounter{{secnumdepth}}{{-1}}";

        /// <summary>
        /// The end of each generated Latex file.
        /// </summary>
        private const string LatexEnd = @"\end{document}";

        #endregion

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog logger = LogManager.GetLogger(typeof(LatexRenderer));

        /// <summary>
        /// The current report builder.
        /// </summary>
        private StringBuilder reportBuilder;

        /// <summary>
        /// The report builders for the summary and the classes report.
        /// </summary>
        private StringBuilder summaryReportBuilder, classReportBuilder;

        /// <summary>
        /// Begins the summary report.
        /// </summary>
        /// <param name="title">The title.</param>
        public void BeginSummaryReport(string title)
        {
            this.reportBuilder = this.summaryReportBuilder = new StringBuilder();

            string start = string.Format(
                CultureInfo.InvariantCulture,
                LatexStart,
                this.GetType().Assembly.GetName().Name,
                this.GetType().Assembly.GetName().Version);

            this.reportBuilder.AppendLine(start);
        }

        /// <summary>
        /// Begins the class report.
        /// </summary>
        /// <param name="className">Name of the class.</param>
        public void BeginClassReport(string className)
        {
            if (this.classReportBuilder == null)
            {
                this.classReportBuilder = new StringBuilder();
            }

            this.reportBuilder = this.classReportBuilder;
            this.reportBuilder.AppendLine(@"\newpage");

            className = string.Format(CultureInfo.InvariantCulture, @"\section{{{0}}}", EscapeLatexChars(className));
            this.reportBuilder.AppendLine(className);
        }

        /// <summary>
        /// Adds a header to the report.
        /// </summary>
        /// <param name="text">The text.</param>
        public void Header(string text)
        {
            text = string.Format(
                CultureInfo.InvariantCulture,
                @"\{0}section{{{1}}}",
                this.reportBuilder == this.classReportBuilder ? "sub" : string.Empty,
                EscapeLatexChars(text));
            this.reportBuilder.AppendLine(text);
        }

        /// <summary>
        /// Adds a file of a class to a report.
        /// </summary>
        /// <param name="path">The path of the file.</param>
        public void File(string path)
        {
            if (path == null)
            {
                throw new ArgumentNullException("path");
            }

            if (path.Length > 78)
            {
                path = path.Substring(path.Length - 78);
            }

            path = string.Format(CultureInfo.InvariantCulture, @"\subsubsection{{{0}}}", EscapeLatexChars(path));
            this.reportBuilder.AppendLine(path);
        }

        /// <summary>
        /// Adds a paragraph to the report.
        /// </summary>
        /// <param name="text">The text.</param>
        public void Paragraph(string text)
        {
            this.reportBuilder.AppendLine(EscapeLatexChars(text));
        }

        /// <summary>
        /// Adds a table with two columns to the report.
        /// </summary>
        public void BeginKeyValueTable()
        {
            this.reportBuilder.AppendLine(@"\begin{longtable}[l]{ll}");
        }

        /// <summary>
        /// Adds a summary table to the report.
        /// </summary>
        public void BeginSummaryTable()
        {
            this.reportBuilder.AppendLine(@"\begin{longtable}[l]{ll}");
        }

        /// <summary>
        /// Adds a metrics table to the report.
        /// </summary>
        /// <param name="headers">The headers.</param>
        public void BeginMetricsTable(IEnumerable<string> headers)
        {
            string columns = "|" + string.Join("|", headers.Select(h => "l")) + "|";

            this.reportBuilder.AppendLine(@"\begin{longtable}[l]{" + columns + "}");
            this.reportBuilder.AppendLine(@"\hline");
            this.reportBuilder.Append(string.Join(" & ", headers.Select(h => @"\textbf{" + EscapeLatexChars(h) + "}")));
            this.reportBuilder.AppendLine(@"\\");
            this.reportBuilder.AppendLine(@"\hline");
        }

        /// <summary>
        /// Adds a file analysis table to the report.
        /// </summary>
        /// <param name="headers">The headers.</param>
        public void BeginLineAnalysisTable(IEnumerable<string> headers)
        {
            this.reportBuilder.AppendLine(@"\begin{longtable}[l]{lrrl}");
            this.reportBuilder.Append(string.Join(" & ", headers.Select(h => @"\textbf{" + EscapeLatexChars(h) + "}")));
            this.reportBuilder.AppendLine(@"\\");
        }

        /// <summary>
        /// Adds a table row with two cells to the report.
        /// </summary>
        /// <param name="key">The text of the first column.</param>
        /// <param name="value">The text of the second column.</param>
        public void KeyValueRow(string key, string value)
        {
            string row = string.Format(
                CultureInfo.InvariantCulture,
                @"\textbf{{{0}}} & {1}\\",
                ShortenString(key),
                EscapeLatexChars(value));

            this.reportBuilder.AppendLine(row);
        }

        /// <summary>
        /// Adds a table row with two cells to the report.
        /// </summary>
        /// <param name="key">The text of the first column.</param>
        /// <param name="files">The files.</param>
        public void KeyValueRow(string key, IEnumerable<string> files)
        {
            files = files.Select(f => { return f.Length > 78 ? f.Substring(f.Length - 78) : f; });

            string row = string.Format(
                CultureInfo.InvariantCulture,
                @"\textbf{{{0}}} & \begin{{minipage}}[t]{{12cm}}{{{1}}}\end{{minipage}} \\",
                ShortenString(key),
                string.Join(@"\\", files.Select(f => EscapeLatexChars(f))));

            this.reportBuilder.AppendLine(row);
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

            string metrics = string.Join(" & ", metric.Metrics.Select(m => m.Value));

            string row = string.Format(
                CultureInfo.InvariantCulture,
                @"\textbf{{{0}}} & {1}\\",
                EscapeLatexChars(ShortenString(metric.Name, 20)),
                metrics);

            this.reportBuilder.AppendLine(row);
            this.reportBuilder.AppendLine(@"\hline");
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

            string formattedLine = analysis.LineContent
                .Replace(((char)11).ToString(), "  ") // replace tab
                .Replace(((char)9).ToString(), "  ") // replace tab
                .Replace("~", " "); // replace '~' since this used for the \verb command

            formattedLine = ShortenString(formattedLine);

            string lineVisitStatus = "gray";

            if (analysis.LineVisitStatus == LineVisitStatus.Covered)
            {
                lineVisitStatus = "green";
            }
            else if (analysis.LineVisitStatus == LineVisitStatus.NotCovered)
            {
                lineVisitStatus = "red";
            }

            string row = string.Format(
                CultureInfo.InvariantCulture,
                @"\cellcolor{{{0}}} & {1} & \verb~{2}~ & \verb~{3}~\\",
                lineVisitStatus,
                analysis.LineVisitStatus != LineVisitStatus.NotCoverable ? analysis.LineVisits.ToString(CultureInfo.InvariantCulture) : string.Empty,
                analysis.LineNumber,
                formattedLine);

            this.reportBuilder.AppendLine(row);
        }

        /// <summary>
        /// Finishes the current table.
        /// </summary>
        public void FinishTable()
        {
            this.reportBuilder.AppendLine(@"\end{longtable}");
        }

        /// <summary>
        /// Adds the coverage information of an assembly to the report.
        /// </summary>
        /// <param name="assembly">The assembly.</param>
        public void SummaryAssembly(Assembly assembly)
        {
            string row = string.Format(
                CultureInfo.InvariantCulture,
                @"\textbf{{{0}}} & \textbf{{{1}\%}}\\",
                EscapeLatexChars(assembly.Name),
                assembly.CoverageQuota);

            this.reportBuilder.AppendLine(row);
        }

        /// <summary>
        /// Adds the coverage information of a class to the report.
        /// </summary>
        /// <param name="clazz">The class.</param>
        public void SummaryClass(Class clazz)
        {
            string row = string.Format(
                CultureInfo.InvariantCulture,
                @"{0} & {1}\%\\",
                EscapeLatexChars(clazz.Name),
                clazz.CoverageQuota);

            this.reportBuilder.AppendLine(row);
        }

        /// <summary>
        /// Saves a summary report.
        /// </summary>
        /// <param name="targetDirectory">The target directory.</param>
        public void SaveSummaryReport(string targetDirectory)
        {
            if (this.classReportBuilder != null)
            {
                this.summaryReportBuilder.Append(this.classReportBuilder.ToString());
            }

            this.summaryReportBuilder.Append(LatexEnd);

            string targetPath = Path.Combine(targetDirectory, "Summary.tex");

            try
            {
                System.IO.File.WriteAllText(targetPath, this.summaryReportBuilder.ToString(), Encoding.Default);
            }
            catch (IOException ex)
            {
                logger.ErrorFormat("Report '{0}' could not be saved: {1}", targetPath, ex.Message);
            }

            this.reportBuilder.Clear();
            this.reportBuilder = null;
        }

        /// <summary>
        /// Saves a class report.
        /// </summary>
        /// <param name="targetDirectory">The target directory.</param>
        /// <param name="assemblyName">Name of the assembly.</param>
        /// <param name="className">Name of the class.</param>
        public void SaveClassReport(string targetDirectory, string assemblyName, string className)
        {
        }

        /// <summary>
        /// Shortens the given string.
        /// </summary>
        /// <param name="text">The text to shorten.</param>
        /// <returns>The shortened string.</returns>
        private static string ShortenString(string text)
        {
            return ShortenString(text, 78);
        }

        /// <summary>
        /// Shortens the given string.
        /// </summary>
        /// <param name="text">The text to shorten.</param>
        /// <param name="maxLength">Maximum length.</param>
        /// <returns>The shortened string.</returns>
        private static string ShortenString(string text, int maxLength)
        {
            if (text.Length > maxLength)
            {
                return text.Substring(0, maxLength);
            }

            return text;
        }

        /// <summary>
        /// Escapes the latex chars.
        /// </summary>
        /// <param name="text">The text.</param>
        /// <returns>The text with escaped latex chars.</returns>
        private static string EscapeLatexChars(string text)
        {
            return text
                .Replace(@"\", @"\textbackslash ")
                .Replace("%", @"\%")
                .Replace("#", @"\#")
                .Replace("_", @"\_");
        }
    }
}
