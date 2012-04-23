using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using log4net;

namespace Palmmedia.ReportGenerator.Parser
{
    /// <summary>
    /// Initiates the corresponding parser to the given report file.
    /// </summary>
    public static class ParserFactory
    {
        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog logger = LogManager.GetLogger(typeof(ParserFactory));

        /// <summary>
        /// Tries to initiate the correct parsers for the given reports. <c>null</c> is returned if no parser has been found.
        /// </summary>
        /// <param name="reportFiles">The report files to parse.</param>
        /// <returns>The IParser instance or <c>null</c> if no matching parser has been found.</returns>
        public static IParser CreateParser(IEnumerable<string> reportFiles)
        {
            if (reportFiles == null)
            {
                throw new ArgumentNullException("reportFiles");
            }

            var parsers = new List<IParser>();

            foreach (var report in reportFiles)
            {
                parsers.AddRange(GetParsersOfFile(report));
            }

            if (parsers.Count == 0)
            {
                return null;
            }
            else if (parsers.Count == 1)
            {
                return parsers[0];
            }
            else
            {
                return new MultiReportParser(parsers);
            }
        }

        /// <summary>
        /// Tries to initiate the correct parsers for the given report. An empty list is returned if no parser has been found.
        /// The report may contain serveral reports. For every report an extra parser is initiated.
        /// </summary>
        /// <param name="reportFile">The report file to parse.</param>
        /// <returns>The IParser instances or an empty list if no matching parser has been found.</returns>
        private static IEnumerable<IParser> GetParsersOfFile(string reportFile)
        {
            var parsers = new List<IParser>();

            XDocument report = null;
            try
            {
                logger.InfoFormat("Loading report '{0}'", reportFile);
                report = XDocument.Load(reportFile);
            }
            catch (Exception ex)
            {
                logger.ErrorFormat(" Error during reading report '{0}': {1}", reportFile, ex.Message);
                return parsers;
            }

            if (report.Descendants("PartCoverReport").Any())
            {
                // PartCover 2.2 and PartCover 2.3 reports differ in version attribute, so use this to determine the correct parser
                if (report.Descendants("PartCoverReport").First().Attribute("ver") != null)
                {
                    foreach (var item in report.Descendants("PartCoverReport"))
                    {
                        logger.Debug(" Initiating parser for PartCover 2.2");
                        parsers.Add(new PartCover22Parser(item));
                    }
                }
                else
                {
                    foreach (var item in report.Descendants("PartCoverReport"))
                    {
                        logger.Debug(" Initiating parser for PartCover 2.3");
                        parsers.Add(new PartCover23Parser(item));
                    }
                }
            }
            else if (report.Descendants("CoverageSession").Any())
            {
                foreach (var item in report.Descendants("CoverageSession"))
                {
                    logger.Debug(" Initiating parser for OpenCover");
                    parsers.Add(new OpenCoverParser(item));
                }
            }
            else if (report.Descendants("coverage").Any())
            {
                foreach (var item in report.Descendants("coverage"))
                {
                    logger.Debug(" Initiating parser for NCover");
                    parsers.Add(new NCoverParser(item));
                }
            }

            return parsers;
        }
    }
}
