
namespace Palmmedia.ReportGenerator.Reporting
{
    /// <summary>
    /// Interface for <see cref="IReportRenderer"/> factories.
    /// </summary>
    public interface IRendererFactory
    {
        /// <summary>
        /// Gets a value indicating whether class reports can be generated in parallel.
        /// </summary>
        bool SupportsParallelClassReports { get; }

        /// <summary>
        /// Creates the renderer for the summary report.
        /// </summary>
        /// <returns>The renderer for the summary report.</returns>
        IReportRenderer CreateSummaryRenderer();

        /// <summary>
        /// Creates the renderer for the class report.
        /// </summary>
        /// <returns>The renderer for the class report.</returns>
        IReportRenderer CreateClassRenderer();
    }
}
