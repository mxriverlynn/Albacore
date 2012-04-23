
namespace Palmmedia.ReportGenerator.Parser.CodeAnalysis
{
    /// <summary>
    /// Contains information about the postion of a method/property within a source code file.
    /// </summary>
    internal class SourceElementPosition
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="SourceElementPosition"/> class.
        /// </summary>
        /// <param name="start">The start line number.</param>
        /// <param name="end">The end line number.</param>
        public SourceElementPosition(int start, int end)
        {
            this.Start = start;
            this.End = end;
        }

        /// <summary>
        /// Gets the start line number.
        /// </summary>
        public int Start { get; private set; }

        /// <summary>
        /// Gets the end line number
        /// </summary>
        public int End { get; private set; }
    }
}
