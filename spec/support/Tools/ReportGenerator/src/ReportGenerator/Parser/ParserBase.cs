using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;

namespace Palmmedia.ReportGenerator.Parser
{
    /// <summary>
    /// Base class for the <see cref="IParser"/> implementations.
    /// </summary>
    public abstract class ParserBase
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ParserBase"/> class.
        /// </summary>
        /// <param name="report">The report file as XContainer.</param>
        protected ParserBase(XContainer report)
        {
            if (report == null)
            {
                throw new ArgumentNullException("report");
            }

            this.Report = report;
            this.LineCoverageByFileDictionary = new ConcurrentDictionary<string, int[]>();
            this.MethodMetricsByClass = new ConcurrentDictionary<string, IEnumerable<MethodMetric>>();
        }

        /// <summary>
        /// Gets the report file as XContainer.
        /// </summary>
        protected XContainer Report { get; private set; }

        /// <summary>
        /// Gets the dictionary containing the line coverage information by file.
        /// </summary>
        protected ConcurrentDictionary<string, int[]> LineCoverageByFileDictionary { get; private set; }

        /// <summary>
        /// Gets the metrics by class.
        /// </summary>
        protected ConcurrentDictionary<string, IEnumerable<MethodMetric>> MethodMetricsByClass { get; private set; }

        /// <summary>
        /// Determine the available method metrics.
        /// </summary>
        /// <param name="assemblyName">The name of the assembly.</param>
        /// <param name="className">The name of the class.</param>
        /// <returns>The method metrics.</returns>
        public IEnumerable<MethodMetric> MethodMetrics(string assemblyName, string className)
        {
            IEnumerable<MethodMetric> metrics = null;
            if (!this.MethodMetricsByClass.TryGetValue(assemblyName + "_" + className, out metrics))
            {
                return Enumerable.Empty<MethodMetric>();
            }
            else
            {
                return metrics.OrderBy(m => m.Name).ToArray();
            }
        }

        /// <summary>
        /// Gets the coverage quota of a class.
        /// This method is used to get coverage quota if line coverage is not available.
        /// </summary>
        /// <param name="assemblyName">The name of the assembly.</param>
        /// <param name="className">The name of the class.</param>
        /// <returns>The coverage quota.</returns>
        public virtual decimal GetCoverageQuotaOfClass(string assemblyName, string className)
        {
            return 0;
        }

        /// <summary>
        /// Returns a <see cref="System.String"/> that represents this instance.
        /// </summary>
        /// <returns>
        /// A <see cref="System.String"/> that represents this instance.
        /// </returns>
        public override string ToString()
        {
            return this.GetType().Name;
        }
    }
}
