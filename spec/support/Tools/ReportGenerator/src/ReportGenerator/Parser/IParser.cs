using System.Collections.Generic;

namespace Palmmedia.ReportGenerator.Parser
{
    /// <summary>
    /// Interface for different parsers.
    /// </summary>
    public interface IParser
    {
        /// <summary>
        /// Determine all covered files.
        /// </summary>
        /// <returns>All covered files.</returns>
        IEnumerable<string> Files();

        /// <summary>
        /// Determine all covered assemblies.
        /// </summary>
        /// <returns>All covered assemblies.</returns>
        IEnumerable<string> Assemblies();

        /// <summary>
        /// Determine all covered classes within an assembly.
        /// </summary>
        /// <param name="assemblyName">The name of the assembly.</param>
        /// <returns>All covered classes within an assembly.</returns>
        IEnumerable<string> ClassesInAssembly(string assemblyName);

        /// <summary>
        /// Determine all files a class is defined in.
        /// </summary>
        /// <param name="assemblyName">The name of the assembly.</param>
        /// <param name="className">The name of the class.</param>
        /// <returns>All files a class is defined in.</returns>
        IEnumerable<string> FilesOfClass(string assemblyName, string className);

        /// <summary>
        /// Determine how often a line of code has been covered.
        /// If line could not be covered at all -1 is returned.
        /// </summary>
        /// <param name="assemblyName">The name of the assembly.</param>
        /// <param name="className">The name of the class.</param>
        /// <param name="fileName">The name of the file.</param>
        /// <param name="lineNumber">The number of the line (starting with 1, not zero based).</param>
        /// <returns>Number of visits.</returns>
        int NumberOfLineVisits(string assemblyName, string className, string fileName, int lineNumber);

        /// <summary>
        /// Gets the coverage quota of a class.
        /// This method is used to get coverage quota if line coverage is not available.
        /// </summary>
        /// <param name="assemblyName">The name of the assembly.</param>
        /// <param name="className">The name of the class.</param>
        /// <returns>The coverage quota.</returns>
        decimal GetCoverageQuotaOfClass(string assemblyName, string className);

        /// <summary>
        /// Determine the available method metrics.
        /// </summary>
        /// <param name="assemblyName">The name of the assembly.</param>
        /// <param name="className">The name of the class.</param>
        /// <returns>The method metrics.</returns>
        IEnumerable<MethodMetric> MethodMetrics(string assemblyName, string className);
    }
}
