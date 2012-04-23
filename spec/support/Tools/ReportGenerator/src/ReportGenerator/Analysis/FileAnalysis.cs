using System.Collections.Generic;

namespace Palmmedia.ReportGenerator.Analysis
{
    /// <summary>
    /// Coverage information of a source file.
    /// </summary>
    public class FileAnalysis
    {
        /// <summary>
        /// The coverage information of the lines in the source file.
        /// </summary>
        private readonly List<LineAnalysis> lineAnalysis = new List<LineAnalysis>();

        /// <summary>
        /// Initializes a new instance of the <see cref="FileAnalysis"/> class.
        /// </summary>
        /// <param name="fileName">Name of the file.</param>
        public FileAnalysis(string fileName)
        {
            this.FileName = fileName;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="FileAnalysis"/> class.
        /// </summary>
        /// <param name="fileName">Name of the file.</param>
        /// <param name="error">The error.</param>
        public FileAnalysis(string fileName, string error)
            : this(fileName)
        {
            this.Error = error;
        }

        /// <summary>
        /// Gets the name of the file.
        /// </summary>
        public string FileName { get; private set; }

        /// <summary>
        /// Gets the error.
        /// </summary>
        public string Error { get; private set; }

        /// <summary>
        /// Gets the coverage information of the lines in the file.
        /// </summary>
        public IEnumerable<LineAnalysis> Lines
        {
            get
            {
                return this.lineAnalysis;
            }
        }

        /// <summary>
        /// Adds the given line analysis to the file analysis.
        /// </summary>
        /// <param name="lineAnalysis">The line analysis.</param>
        public void AddLineAnalysis(LineAnalysis lineAnalysis)
        {
            this.lineAnalysis.Add(lineAnalysis);
        }
    }
}
