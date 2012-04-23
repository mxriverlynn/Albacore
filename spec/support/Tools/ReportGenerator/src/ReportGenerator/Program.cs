using System;
using System.IO;
using System.Linq;
using log4net;
using Palmmedia.ReportGenerator.Parser;
using Palmmedia.ReportGenerator.Reporting;

namespace Palmmedia.ReportGenerator
{
    /// <summary>
    /// Command line access to the ReportBuilder.
    /// </summary>
    internal class Program
    {
        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog logger = LogManager.GetLogger(typeof(Program));

        /// <summary>
        /// The main method.
        /// </summary>
        /// <param name="args">The arguments.</param>
        /// <returns>Return code indicating success/failure.</returns>
        internal static int Main(string[] args)
        {
            var appender = new log4net.Appender.ConsoleAppender();
            appender.Layout = new log4net.Layout.PatternLayout("%message%newline");
            log4net.Config.BasicConfigurator.Configure(appender);

            if (args.Length < 2 || args.Length > 3)
            {
                ShowHelp();
                return 1;
            }

            var reportFiles = args[0].Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries);
            var targetDirectory = args[1];
            var reportType = ReportType.Html;

            if (args.Length > 2 && !Enum.TryParse<ReportType>(args[2], true, out reportType))
            {
                logger.Error("Unknown ReportType.");
                return 1;
            }

            // Check whether report exists
            if (!reportFiles.Any())
            {
                logger.Error("No report files specified.");
                return 1;
            }

            foreach (var file in reportFiles)
            {
                if (!File.Exists(file))
                {
                    logger.ErrorFormat("The report file '{0}' does not exist.", file);
                    return 1;
                }
            }

            // Create target directory
            if (!Directory.Exists(targetDirectory))
            {
                try
                {
                    Directory.CreateDirectory(targetDirectory);
                }
                catch (Exception ex)
                {
                    logger.ErrorFormat("The target directory '{0}' could not be created: {1}", targetDirectory, ex.Message);
                    return 1;
                }
            }

            var stopWatch = new System.Diagnostics.Stopwatch();
            stopWatch.Start();

            // Initiate parser
            var parser = ParserFactory.CreateParser(reportFiles);

            if (parser == null)
            {
                logger.Error("No matching parser found.");
                stopWatch.Stop();
                return 1;
            }

            new ReportBuilder(parser, new RendererFactory(reportType), targetDirectory).CreateReport();

            stopWatch.Stop();
            logger.InfoFormat("Report generation took {0} seconds", stopWatch.ElapsedMilliseconds / 1000);

            return 0;
        }

        /// <summary>
        /// Shows the help of the programm.
        /// </summary>
        private static void ShowHelp()
        {
            Console.WriteLine(string.Empty);
            Console.WriteLine("Parameters:");
            Console.WriteLine("    Reportfile(s) Targetdirectory [Reporttype]");

            Console.WriteLine(string.Empty);
            Console.WriteLine("Explanations:");
            Console.WriteLine("   Reportfile(s): The reports that should be parsed (separated by semicolon)");
            Console.WriteLine("   Targetdirectory: The directory where the report should be saved");
            Console.WriteLine("   Reporttype: The output format and scope (" + string.Join(", ", Enum.GetNames(typeof(ReportType))) + ")");

            Console.WriteLine(string.Empty);
            Console.WriteLine("Default values:");
            Console.WriteLine("   Reporttype: " + ReportType.Html);

            Console.WriteLine(string.Empty);
            Console.WriteLine("Examples:");
            Console.WriteLine("   \"Partcover.xml\" \"C:\\report\"");
            Console.WriteLine("   \"Partcover.xml\" \"C:\\report\" " + ReportType.Latex);
            Console.WriteLine("   \"Partcover1.xml;PartCover2.xml\" \"report\"");
        }
    }
}
