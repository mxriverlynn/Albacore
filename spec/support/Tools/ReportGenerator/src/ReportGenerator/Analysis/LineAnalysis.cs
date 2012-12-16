
namespace Palmmedia.ReportGenerator.Analysis
{
    /// <summary>
    /// Coverage information of a line in a source file.
    /// </summary>
    public class LineAnalysis
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="LineAnalysis"/> class.
        /// </summary>
        /// <param name="lineVisits">The line visits.</param>
        /// <param name="lineNumber">The line number.</param>
        /// <param name="lineContent">Content of the line.</param>
        public LineAnalysis(int lineVisits, int lineNumber, string lineContent)
        {
            this.LineVisits = lineVisits;
            this.LineNumber = lineNumber;
            this.LineContent = lineContent;
        }

        /// <summary>
        /// Gets the line visit status.
        /// </summary>
        public LineVisitStatus LineVisitStatus
        {
            get
            {
                if (this.LineVisits == 0)
                {
                    return LineVisitStatus.NotCovered;
                }
                else if (this.LineVisits > 0)
                {
                    return LineVisitStatus.Covered;
                }
                else
                {
                    return LineVisitStatus.NotCoverable;
                }
            }
        }

        /// <summary>
        /// Gets the line visits.
        /// </summary>
        public int LineVisits { get; private set; }

        /// <summary>
        /// Gets the line number.
        /// </summary>
        public int LineNumber { get; private set; }

        /// <summary>
        /// Gets the content of the line.
        /// </summary>
        /// <value>
        /// The content of the line.
        /// </value>
        public string LineContent { get; private set; }
    }
}
