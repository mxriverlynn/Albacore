using System.IO;

namespace Palmmedia.ReportGeneratorTest
{
    internal static class FileManager
    {
        private const string TEMPDIRECTORY = @"C:\temp";

        internal static string GetReportDirectory()
        {
            return Path.Combine(GetFilesDirectory(), "Reports");
        }

        internal static string GetCodeAnalysisDirectory()
        {
            return Path.Combine(GetFilesDirectory(), "CodeAnalysis");
        }

        private static string GetFilesDirectory()
        {
            var baseDirectory = new DirectoryInfo(System.Reflection.Assembly.GetExecutingAssembly().Location).Parent.Parent.Parent.Parent.FullName;
            return Path.Combine(Path.Combine(baseDirectory, "ReportGeneratorTest"), "files");
        }

        internal static void CopyTestClasses()
        {
            string testClassesDirectory = Path.Combine(GetReportDirectory(), "TestClasses");

            if (!Directory.Exists(TEMPDIRECTORY))
            {
                Directory.CreateDirectory(TEMPDIRECTORY);
            }

            var files = new DirectoryInfo(testClassesDirectory).GetFiles("*.cs");

            foreach (var fileInfo in files)
            {
                File.Copy(fileInfo.FullName, Path.Combine(TEMPDIRECTORY, fileInfo.Name), true);
            }
        }

        internal static void DeleteTestClasses()
        {
            if (Directory.Exists(TEMPDIRECTORY))
            {
                var files = new DirectoryInfo(TEMPDIRECTORY).GetFiles("*.cs");

                foreach (var fileInfo in files)
                {
                    File.Delete(fileInfo.FullName);
                }

                if (new DirectoryInfo(TEMPDIRECTORY).GetFiles().Length == 0)
                {
                    Directory.Delete(TEMPDIRECTORY);
                }
            }
        }
    }
}
