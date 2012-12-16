using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;

namespace Palmmedia.ReportGenerator.Parser
{
    /// <summary>
    /// Parser that aggregates serveral parsers.
    /// </summary>
    public class MultiReportParser : IParser
    {
        /// <summary>
        /// The parsers to aggregate.
        /// </summary>
        private readonly IEnumerable<IParser> parsers;

        /// <summary>
        /// Initializes a new instance of the <see cref="MultiReportParser"/> class.
        /// </summary>
        /// <param name="parsers">The parsers.</param>
        public MultiReportParser(IEnumerable<IParser> parsers)
        {
            if (parsers == null)
            {
                throw new ArgumentNullException("parsers");
            }

            this.parsers = parsers;
        }

        /// <summary>
        /// Determine all covered files.
        /// </summary>
        /// <returns>All covered files.</returns>
        public IEnumerable<string> Files()
        {
            return this.parsers
                .SelectMany(p => p.Files())
                .Distinct()
                .OrderBy(p => p);
        }

        /// <summary>
        /// Determine all covered assemblies.
        /// </summary>
        /// <returns>All covered assemblies.</returns>
        public IEnumerable<string> Assemblies()
        {
            return this.parsers
                .SelectMany(p => p.Assemblies())
                .Distinct()
                .OrderBy(p => p);
        }

        /// <summary>
        /// Determine all covered classes within an assembly.
        /// </summary>
        /// <param name="assemblyName">The name of the assembly.</param>
        /// <returns>All covered classes within an assembly.</returns>
        public IEnumerable<string> ClassesInAssembly(string assemblyName)
        {
            return this.parsers
                .SelectMany(p => p.ClassesInAssembly(assemblyName))
                .Distinct()
                .OrderBy(p => p);
        }

        /// <summary>
        /// Determine all files a class is defined in.
        /// </summary>
        /// <param name="assemblyName">The name of the assembly.</param>
        /// <param name="className">The name of the class.</param>
        /// <returns>All files a class is defined in.</returns>
        public IEnumerable<string> FilesOfClass(string assemblyName, string className)
        {
            return this.parsers
                .SelectMany(p => p.FilesOfClass(assemblyName, className))
                .Distinct()
                .OrderBy(p => p);
        }

        /// <summary>
        /// Determine how often a line of code has been covered.
        /// If line could not be covered at all -1 is returned.
        /// </summary>
        /// <param name="assemblyName">The name of the assembly.</param>
        /// <param name="className">The name of the class.</param>
        /// <param name="fileName">The name of the file.</param>
        /// <param name="lineNumber">The number of the line (starting with 1, not zero based).</param>
        /// <returns>Number of visits.</returns>
        public int NumberOfLineVisits(string assemblyName, string className, string fileName, int lineNumber)
        {
            var result = -1;

            foreach (var parser in this.parsers)
            {
                var parserResult = parser.NumberOfLineVisits(assemblyName, className, fileName, lineNumber);

                if (parserResult >= 0)
                {
                    if (result == -1)
                    {
                        result = parserResult;
                    }
                    else
                    {
                        result += parserResult;
                    }
                }
            }

            return result;
        }

        /// <summary>
        /// Determine the available method metrics.
        /// </summary>
        /// <param name="assemblyName">The name of the assembly.</param>
        /// <param name="className">The name of the class.</param>
        /// <returns>The method metrics.</returns>
        public IEnumerable<MethodMetric> MethodMetrics(string assemblyName, string className)
        {
            var groupedMethodMetrics = this.parsers.SelectMany(p => p.MethodMetrics(assemblyName, className))
                .GroupBy(m => m.Name);

            Func<IEnumerable<Metric>, IEnumerable<Metric>> retrieveMaximumMetrics =
                m => m.GroupBy(mg => mg.Name).Select(mg => mg.OrderByDescending(me => me.Value).First());

            return groupedMethodMetrics
                .Select(mg => new MethodMetric(mg.Key, retrieveMaximumMetrics(mg.SelectMany(m => m.Metrics))))
                .ToArray();
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
            return this.parsers.Max(p => p.GetCoverageQuotaOfClass(assemblyName, className));
        }

        /// <summary>
        /// Returns a <see cref="System.String"/> that represents this instance.
        /// </summary>
        /// <returns>
        /// A <see cref="System.String"/> that represents this instance.
        /// </returns>
        public override string ToString()
        {
            StringBuilder sb = new StringBuilder(this.GetType().Name);
            sb.Append(" (");

            var groupedParsers = this.parsers.GroupBy(p => p.ToString()).OrderBy(pg => pg.Key);

            sb.Append(string.Join(
                ", ",
                groupedParsers.Select(pg => string.Format(CultureInfo.InvariantCulture, "{0}x {1}", pg.Count(), pg.Key))));

            sb.Append(")");
            return sb.ToString();
        }
    }
}
