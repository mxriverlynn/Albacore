using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using log4net;
using Palmmedia.ReportGenerator.Analysis;
using Palmmedia.ReportGenerator.Parser;

namespace Palmmedia.ReportGenerator.Reporting
{
    /// <summary>
    /// HTML report renderer.
    /// </summary>
    public class HtmlRenderer : RendererBase, IReportRenderer
    {
        #region HTML Snippets

        /// <summary>
        /// The head of each generated HTML file.
        /// </summary>
        private const string HtmlStart = @"<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Strict//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"">
<html><head><title>{0} - Coverage Report</title>
<meta http-equiv=""content-type"" content=""text/html; charset=UTF-8"" />
<link rel=""stylesheet"" type=""text/css"" href=""report.css"" />
{1}
</head><body><div class=""container"">";

        /// <summary>
        /// The java script for the summary report.
        /// </summary>
        private const string SummaryJavaScript = @"<script type=""text/javascript"">
/* <![CDATA[ */
document.getElementsByClassName = function(cl) {
  var retnode = [];
  var myclass = new RegExp('\\b'+cl+'\\b');
  var elem = this.getElementsByTagName('*');
  for (var i = 0; i < elem.length; i++) {
    var classes = elem[i].className;
    if (myclass.test(classes)) {
      retnode.push(elem[i]);
    }
  }
  return retnode;
}; 

function getSiblingNode(element) {
    do {
        element = element.nextSibling;
    } while (element && element.nodeType != 1);
    return element;
}

function toggleAssemblyDetails() {
  var popup = getSiblingNode(this); 
  if (popup.style.display == 'block') { 
    popup.style.display = 'none'; 
  }
  else {
    var popups = document.getElementsByClassName('detailspopup');
    for (var i = 0, j = popups.length; i < j; i++) { 
      popups[i].style.display = 'none';
    }
    popup.style.display = 'block'; 
  }
  return false;
}

function collapseAllClasses() {
  var classRows = document.getElementsByClassName('classrow');
  for (var i = 0, j = classRows.length; i < j; i++) {
    classRows[i].style.display = 'none';
  }
  var expandedRows = document.getElementsByClassName('expanded');
  for (var i = 0, j = expandedRows.length; i < j; i++) {
    expandedRows[i].className = 'collapsed';
  }
  return false;
}

function expandAllClasses() {
  var classRows = document.getElementsByClassName('classrow');
  for (var i = 0, j = classRows.length; i < j; i++) {
    classRows[i].style.display = '';
  }
  var collapsedRows = document.getElementsByClassName('collapsed');
  for (var i = 0, j = collapsedRows.length; i < j; i++) {
    collapsedRows[i].className = 'expanded';
  }
  return false;
}

function toggleClassesInAssembly() {
  var assemblyRow = this.parentNode.parentNode;
  assemblyRow.className = assemblyRow.className == 'collapsed' ? 'expanded' : 'collapsed';
  var classRow = getSiblingNode(assemblyRow);
  while (classRow && classRow.className == 'classrow') {
    classRow.style.display = classRow.style.display == 'none' ? '' : 'none';
    classRow = getSiblingNode(classRow);
  }
  return false;
}

function init() {
  var toggleAssemblyDetailsLinks = document.getElementsByClassName('toggleAssemblyDetails');
  for (var i = 0, j = toggleAssemblyDetailsLinks.length; i < j; i++) {
    toggleAssemblyDetailsLinks[i].onclick = toggleAssemblyDetails;
  }

  document.getElementById('collapseAllClasses').onclick = collapseAllClasses;
  document.getElementById('expandAllClasses').onclick = expandAllClasses;

  var toggleClassesInAssemblyLinks = document.getElementsByClassName('toggleClassesInAssembly');
  for (var i = 0, j = toggleClassesInAssemblyLinks.length; i < j; i++) {
    toggleClassesInAssemblyLinks[i].onclick = toggleClassesInAssembly;
  }
}

window.onload = init;
/* ]]> */
</script>";

        /// <summary>
        /// The default css.
        /// </summary>
        private const string DefaultCss = @"html { font-family: sans-serif; margin: 20px; font-size: 0.9em; background-color: #f5f5f5; }
h1 { font-size: 1.2em; font-weight: bold; margin: 20px 0 15px 0; padding: 0; }
h2 { font-size: 1.0em; font-weight: bold; margin: 10px 0 15px 0; padding: 0; }
th { text-align: left; }
a { color: #cc0000; text-decoration: none; }
a:hover { color: #000000; text-decoration: none; }
.container { margin: auto; width: 960px; border: solid 1px #a7bac5; padding: 0 20px 20px 20px; background-color: #ffffff; }
.overview { border: solid 1px #a7bac5; border-collapse: collapse; width: 100%; word-wrap: break-word; table-layout:fixed; }
.overview th { border: solid 1px #a7bac5; border-collapse: collapse; padding: 2px 5px 2px 5px; background-color: #d2dbe1; }
.overview td { border: solid 1px #a7bac5; border-collapse: collapse; padding: 2px 5px 2px 5px; }
.coverage { border: solid 1px #a7bac5; border-collapse: collapse; font-size: 5px; }
.coverage td { padding: 0; }
.toggleClasses { font-size: 0.7em; padding: 0 0 0 5px; margin: 0 0 3px 0; }
tr.expanded a.toggleClassesInAssembly { width: 12px; height: 12px; display: inline-block; background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAadEVYdFNvZnR3YXJlAFBhaW50Lk5FVCB2My41LjEwMPRyoQAAAClJREFUKFNj+P//PwMpmCTFIIMHo4YzQFeRghlIUQxSOxg9TUoskxVxAAc+kbB1wVv5AAAAAElFTkSuQmCC); }
tr.collapsed a.toggleClassesInAssembly { width: 12px; height: 12px; display: inline-block; background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAadEVYdFNvZnR3YXJlAFBhaW50Lk5FVCB2My41LjEwMPRyoQAAACdJREFUKFNj+P//PwM6ZmBg+A/CWOWGgwaYB0mgISFCNB4OoUSqHwDx71a4nIsouAAAAABJRU5ErkJggg==); }
.toggleAssemblyDetails { float:right; font-size: 0.7em; margin-top: 3px; }
.detailspopup { border: solid 1px #a7bac5; width: 250px; position: absolute; background-color: #ffffff; margin: 2px 0 0 517px; padding: 10px; display: none; font-weight: normal; }
.right { text-align: right; padding-right: 8px; }
.light { color: #888888; }
.leftmargin { padding-left: 5px; }
.green { background-color: #00ff21; }
.red { background-color: #ff0000; }
.gray { background-color: #dcdcdc; }
.footer { font-size: 0.7em; text-align: center; margin-top: 35px; }";

        /// <summary>
        /// The end of each generated HTML file.
        /// </summary>
        private const string HtmlEnd = "</div></body></html>";

        #endregion

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog logger = LogManager.GetLogger(typeof(HtmlRenderer));

        /// <summary>
        /// The report builder.
        /// </summary>
        private StringBuilder reportBuilder;

        /// <summary>
        /// Begins the summary report.
        /// </summary>
        /// <param name="title">The title.</param>
        public void BeginSummaryReport(string title)
        {
            this.reportBuilder = new StringBuilder();
            this.reportBuilder.AppendFormat(HtmlStart, WebUtility.HtmlEncode(title), SummaryJavaScript);
        }

        /// <summary>
        /// Begins the class report.
        /// </summary>
        /// <param name="className">Name of the class.</param>
        public void BeginClassReport(string className)
        {
            this.reportBuilder = new StringBuilder();
            this.reportBuilder.AppendFormat(HtmlStart, WebUtility.HtmlEncode(className), string.Empty);
        }

        /// <summary>
        /// Adds a header to the report.
        /// </summary>
        /// <param name="text">The text.</param>
        public void Header(string text)
        {
            this.reportBuilder.AppendFormat("<h1>{0}</h1>", WebUtility.HtmlEncode(text));
        }

        /// <summary>
        /// Adds a file of a class to a report.
        /// </summary>
        /// <param name="path">The path of the file.</param>
        public void File(string path)
        {
            this.reportBuilder.AppendFormat("<h2 id=\"{0}\">{1}</h2>", WebUtility.HtmlEncode(ReplaceInvalidXmlChars(path)), WebUtility.HtmlEncode(path));
        }

        /// <summary>
        /// Adds a paragraph to the report.
        /// </summary>
        /// <param name="text">The text.</param>
        public void Paragraph(string text)
        {
            this.reportBuilder.AppendFormat("<p>{0}</p>", WebUtility.HtmlEncode(text));
        }

        /// <summary>
        /// Adds a table with two columns to the report.
        /// </summary>
        public void BeginKeyValueTable()
        {
            this.reportBuilder.AppendLine("<table class=\"overview\">");
            this.reportBuilder.AppendLine("<colgroup>");
            this.reportBuilder.AppendLine("<col width=\"130\" />");
            this.reportBuilder.AppendLine("<col />");
            this.reportBuilder.AppendLine("</colgroup>");
        }

        /// <summary>
        /// Adds a summary table to the report.
        /// </summary>
        public void BeginSummaryTable()
        {
            this.reportBuilder.AppendLine("<p class=\"toggleClasses\"><a id=\"collapseAllClasses\" href=\"#\">Collapse all classes</a> | <a id=\"expandAllClasses\" href=\"#\">Expand all classes</a></p>");

            this.reportBuilder.AppendLine("<table class=\"overview\">");
            this.reportBuilder.AppendLine("<colgroup>");
            this.reportBuilder.AppendLine("<col />");
            this.reportBuilder.AppendLine("<col width=\"60\" />");
            this.reportBuilder.AppendLine("<col width=\"105\" />");
            this.reportBuilder.AppendLine("</colgroup>");
        }

        /// <summary>
        /// Adds a metrics table to the report.
        /// </summary>
        /// <param name="headers">The headers.</param>
        public void BeginMetricsTable(IEnumerable<string> headers)
        {
            if (headers == null)
            {
                throw new ArgumentNullException("headers");
            }

            this.reportBuilder.AppendLine("<table class=\"overview\">");
            this.reportBuilder.AppendLine("<tr>");

            foreach (var header in headers)
            {
                this.reportBuilder.AppendFormat("<th>{0}</th>", WebUtility.HtmlEncode(header));
            }

            this.reportBuilder.AppendLine("</tr>");
        }

        /// <summary>
        /// Adds a file analysis table to the report.
        /// </summary>
        /// <param name="headers">The headers.</param>
        public void BeginLineAnalysisTable(IEnumerable<string> headers)
        {
            if (headers == null)
            {
                throw new ArgumentNullException("headers");
            }

            this.reportBuilder.AppendLine("<table>");
            this.reportBuilder.AppendLine("<tr>");

            foreach (var header in headers)
            {
                this.reportBuilder.AppendFormat("<th>{0}</th>", WebUtility.HtmlEncode(header));
            }

            this.reportBuilder.AppendLine("</tr>");
        }

        /// <summary>
        /// Adds a table row with two cells to the report.
        /// </summary>
        /// <param name="key">The text of the first column.</param>
        /// <param name="value">The text of the second column.</param>
        public void KeyValueRow(string key, string value)
        {
            this.reportBuilder.AppendFormat(
                "<tr><th>{0}</th><td>{1}</td></tr>",
                WebUtility.HtmlEncode(key),
                WebUtility.HtmlEncode(value));
        }

        /// <summary>
        /// Adds a table row with two cells to the report.
        /// </summary>
        /// <param name="key">The text of the first column.</param>
        /// <param name="files">The files.</param>
        public void KeyValueRow(string key, IEnumerable<string> files)
        {
            string value = string.Join("<br />", files.Select(v => string.Format(CultureInfo.InvariantCulture, "<a href=\"#{0}\">{1}</a>", WebUtility.HtmlEncode(ReplaceInvalidXmlChars(v)), WebUtility.HtmlEncode(v))));

            this.reportBuilder.AppendFormat(
                "<tr><th>{0}</th><td>{1}</td></tr>",
                WebUtility.HtmlEncode(key),
                value);
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

            this.reportBuilder.Append("<tr>");

            this.reportBuilder.AppendFormat("<td>{0}</td>", WebUtility.HtmlEncode(metric.Name));

            foreach (var metricValue in metric.Metrics.Select(m => m.Value))
            {
                this.reportBuilder.AppendFormat("<td>{0}</td>", metricValue);
            }

            this.reportBuilder.Append("</tr>");
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
                .Replace(((char)9).ToString(), "  "); // replace tab

            if (formattedLine.Length > 120)
            {
                formattedLine = formattedLine.Substring(0, 120);
            }

            formattedLine = WebUtility.HtmlEncode(formattedLine);
            formattedLine = formattedLine.Replace(" ", "&nbsp;");

            string lineVisitStatus = "gray";

            if (analysis.LineVisitStatus == LineVisitStatus.Covered)
            {
                lineVisitStatus = "green";
            }
            else if (analysis.LineVisitStatus == LineVisitStatus.NotCovered)
            {
                lineVisitStatus = "red";
            }

            this.reportBuilder.AppendLine("<tr>");

            this.reportBuilder.AppendFormat(
                CultureInfo.InvariantCulture,
                "<td class=\"{0}\">&nbsp;</td>",
                lineVisitStatus);
            this.reportBuilder.AppendFormat(
                CultureInfo.InvariantCulture,
                "<td class=\"leftmargin right\">{0}</td>",
                analysis.LineVisitStatus != LineVisitStatus.NotCoverable ? analysis.LineVisits.ToString(CultureInfo.InvariantCulture) : string.Empty);
            this.reportBuilder.AppendFormat(
                CultureInfo.InvariantCulture,
                "<td class=\"right\"><code>{0}</code></td>",
                analysis.LineNumber);
            this.reportBuilder.AppendFormat(
                CultureInfo.InvariantCulture,
                "<td{0}><code>{1}</code></td>",
                analysis.LineVisitStatus == LineVisitStatus.NotCoverable ? " class=\"light\"" : string.Empty,
                formattedLine);

            this.reportBuilder.AppendLine("</tr>");
        }

        /// <summary>
        /// Finishes the current table.
        /// </summary>
        public void FinishTable()
        {
            this.reportBuilder.AppendLine("</table>");
        }

        /// <summary>
        /// Adds the coverage information of an assembly to the report.
        /// </summary>
        /// <param name="assembly">The assembly.</param>
        public void SummaryAssembly(Assembly assembly)
        {
            this.reportBuilder.AppendFormat(
                CultureInfo.InvariantCulture,
                "<tr class=\"expanded\"><th><a href=\"#\" class=\"toggleClassesInAssembly\" title=\"Collapse/Expand classes\"> </a> {0} {1}</th><th title=\"{2}\">{3}%</th><td>{4}</td></tr>",
                WebUtility.HtmlEncode(assembly.Name),
                CreateAssemblyPopup(assembly),
                CoverageType.LineCoverage,
                assembly.CoverageQuota,
                CreateCoverageTable(assembly.CoverageQuota));
        }

        /// <summary>
        /// Adds the coverage information of a class to the report.
        /// </summary>
        /// <param name="clazz">The class.</param>
        public void SummaryClass(Class clazz)
        {
            this.reportBuilder.AppendFormat(
                CultureInfo.InvariantCulture,
                "<tr class=\"classrow\"><td><a href=\"{0}\">{1}</a></td><td title=\"{2}\">{3}%</td><td>{4}</td></tr>",
                WebUtility.HtmlEncode(ReplaceInvalidPathChars(clazz.ShortAssemblyName + "_" + clazz.Name) + ".htm"),
                WebUtility.HtmlEncode(clazz.Name),
                clazz.CoverageType,
                clazz.CoverageQuota,
                CreateCoverageTable(clazz.CoverageQuota));
        }

        /// <summary>
        /// Saves a summary report.
        /// </summary>
        /// <param name="targetDirectory">The target directory.</param>
        public void SaveSummaryReport(string targetDirectory)
        {
            this.SaveReport(targetDirectory, "index.htm");
            this.SaveCss(targetDirectory);
        }

        /// <summary>
        /// Saves a class report.
        /// </summary>
        /// <param name="targetDirectory">The target directory.</param>
        /// <param name="assemblyName">Name of the assembly.</param>
        /// <param name="className">Name of the class.</param>
        public void SaveClassReport(string targetDirectory, string assemblyName, string className)
        {
            this.SaveReport(targetDirectory, ReplaceInvalidPathChars(assemblyName + "_" + className) + ".htm");
        }

        /// <summary>
        /// Builds a table showing the coverage quota with red and green bars.
        /// </summary>
        /// <param name="coverage">The coverage quota.</param>
        /// <returns>Table showing the coverage quota with red and green bars.</returns>
        private static string CreateCoverageTable(decimal coverage)
        {
            var stringBuilder = new StringBuilder();
            int covered = (int)Math.Round(coverage, 0);
            int uncovered = 100 - covered;

            if (covered == 100)
            {
                covered = 103;
            }

            if (uncovered == 100)
            {
                uncovered = 103;
            }

            stringBuilder.Append("<table class=\"coverage\"><tr>");
            if (covered > 0)
            {
                stringBuilder.Append("<td class=\"green\" style=\"width: " + covered + "px;\">&nbsp;</td>");
            }

            if (uncovered > 0)
            {
                stringBuilder.Append("<td class=\"red\" style=\"width: " + uncovered + "px;\">&nbsp;</td>");
            }

            stringBuilder.Append("</tr></table>");
            return stringBuilder.ToString();
        }

        /// <summary>
        /// Builds a table containing information about an assembly.
        /// </summary>
        /// <param name="assembly">The assembly.</param>
        /// <returns>Table containing information about an assembly</returns>
        private static string CreateAssemblyPopup(Assembly assembly)
        {
            var stringBuilder = new StringBuilder();

            stringBuilder.AppendLine("<a href=\"#\" class=\"toggleAssemblyDetails\" title=\"Show details of assembly\">Details</a>");
            stringBuilder.AppendLine("<div class=\"detailspopup\">");
            stringBuilder.AppendLine("<table class=\"overview\">");
            stringBuilder.AppendLine("<colgroup>");
            stringBuilder.AppendLine("<col width=\"130\" />");
            stringBuilder.AppendLine("<col />");
            stringBuilder.AppendLine("</colgroup>");
            stringBuilder.AppendFormat("<tr><th>Classes:</th><td>{0}</td></tr>", assembly.Classes.Count());
            stringBuilder.AppendFormat("<tr><th>Coverage:</th><td>{0}%</td></tr>", assembly.CoverageQuota);
            stringBuilder.AppendFormat("<tr><th>Covered lines:</th><td>{0}</td></tr>", assembly.CoveredLines);
            stringBuilder.AppendFormat("<tr><th>Coverable lines:</th><td>{0}</td></tr>", assembly.CoverableLines);
            stringBuilder.AppendFormat("<tr><th>Total lines:</th><td>{0}</td></tr>", assembly.TotalLines);
            stringBuilder.AppendLine("</table>");
            stringBuilder.AppendLine("</div>");

            return stringBuilder.ToString();
        }

        /// <summary>
        /// Saves the report.
        /// </summary>
        /// <param name="targetDirectory">The target directory.</param>
        /// <param name="fileName">Name of the file.</param>
        private void SaveReport(string targetDirectory, string fileName)
        {
            this.FinishReport();

            string targetPath = Path.Combine(targetDirectory, fileName);

            try
            {
                System.IO.File.WriteAllText(targetPath, this.reportBuilder.ToString(), Encoding.UTF8);
            }
            catch (IOException ex)
            {
                logger.ErrorFormat("Report '{0}' could not be saved: {1}", targetPath, ex.Message);
            }

            this.reportBuilder.Clear();
            this.reportBuilder = null;
        }

        /// <summary>
        /// Saves the CSS.
        /// </summary>
        /// <param name="targetDirectory">The target directory.</param>
        private void SaveCss(string targetDirectory)
        {
            string targetPath = Path.Combine(targetDirectory, "report.css");

            try
            {
                System.IO.File.WriteAllText(targetPath, DefaultCss, Encoding.UTF8);
            }
            catch (IOException ex)
            {
                logger.ErrorFormat("CSS '{0}' could not be saved: {1}", targetPath, ex.Message);
            }
        }

        /// <summary>
        /// Finishes the report.
        /// </summary>
        private void FinishReport()
        {
            this.reportBuilder.AppendFormat(
                CultureInfo.InvariantCulture,
                "<div class=\"footer\">Generated by: {0} {1}<br />{2} - {3}<br /><a href=\"http://www.palmmedia.de\">www.palmmedia.de</a></div>",
                this.GetType().Assembly.GetName().Name,
                this.GetType().Assembly.GetName().Version,
                DateTime.Now.ToShortDateString(),
                DateTime.Now.ToLongTimeString());

            this.reportBuilder.Append(HtmlEnd);
        }
    }
}
