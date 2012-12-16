
namespace Palmmedia.ReportGenerator.Reporting
{
    /// <summary>
    /// Default factory for <see cref="IReportRenderer"/>.
    /// </summary>
    internal class RendererFactory : IRendererFactory
    {
        /// <summary>
        /// Type of the report.
        /// </summary>
        private readonly ReportType reportType;

        /// <summary>
        /// The cached renderer. Required for reusing an <see cref="IReportRenderer"/> for generating reports containing all classes.
        /// </summary>
        private IReportRenderer cachedRenderer;

        /// <summary>
        /// Initializes a new instance of the <see cref="RendererFactory"/> class.
        /// </summary>
        /// <param name="reportType">Type of the report.</param>
        public RendererFactory(ReportType reportType)
        {
            this.reportType = reportType;
        }

        /// <summary>
        /// Gets a value indicating whether class reports can be generated in parallel.
        /// </summary>
        /// <value></value>
        public bool SupportsParallelClassReports
        {
            get
            {
                return this.reportType != ReportType.Latex;
            }
        }

        /// <summary>
        /// Creates the renderer for the summary report.
        /// </summary>
        /// <returns>The renderer for the summary report.</returns>
        public IReportRenderer CreateSummaryRenderer()
        {
            if (this.reportType == ReportType.HtmlSummary
                || this.reportType == ReportType.Html)
            {
                return new HtmlRenderer();
            }
            else if (this.reportType == ReportType.XmlSummary
                || this.reportType == ReportType.Xml)
            {
                return new XmlRenderer();
            }
            else
            {
                if (this.cachedRenderer == null)
                {
                    this.CreateCachedRendererInstance();
                }

                return this.cachedRenderer;
            }
        }

        /// <summary>
        /// Creates the renderer for the class report.
        /// </summary>
        /// <returns>The renderer for the class report.</returns>
        public IReportRenderer CreateClassRenderer()
        {
            if (this.reportType == ReportType.HtmlSummary
                || this.reportType == ReportType.XmlSummary
                || this.reportType == ReportType.LatexSummary)
            {
                return null;
            }
            else if (this.reportType == ReportType.Html)
            {
                return new HtmlRenderer();
            }
            else if (this.reportType == ReportType.Xml)
            {
                return new XmlRenderer();
            }
            else
            {
                if (this.cachedRenderer == null)
                {
                    this.CreateCachedRendererInstance();
                }

                return this.cachedRenderer;
            }
        }

        /// <summary>
        /// Creates the cached renderer instance.
        /// </summary>
        private void CreateCachedRendererInstance()
        {
            if (this.reportType == ReportType.Latex
                || this.reportType == ReportType.LatexSummary)
            {
                this.cachedRenderer = new LatexRenderer();
            }
        }
    }
}
