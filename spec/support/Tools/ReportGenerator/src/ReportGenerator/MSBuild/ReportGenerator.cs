using System.Linq;
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;

namespace Palmmedia.ReportGenerator.MSBuild
{
    /// <summary>
    /// MSBuild Task for generating reports.
    /// </summary>
    /// <example>
    /// &lt;?xml version="1.0" encoding="utf-8"?&gt;<br/>
    /// &lt;Project DefaultTargets="Coverage" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0"&gt;<br/>
    ///   &lt;UsingTask TaskName="ReportGenerator" AssemblyFile="ReportGenerator.exe" /&gt;<br/>
    ///   &lt;ItemGroup&gt;<br/>
    ///       &lt;CoverageFiles Include="partcover.xml" /&gt;<br/>
    ///   &lt;/ItemGroup&gt;<br/>
    ///   &lt;Target Name="Coverage"&gt;<br/>
    ///     &lt;ReportGenerator ReportFiles="@(CoverageFiles)" TargetDirectory="report" ReportType="Html" /&gt;<br/>
    ///   &lt;/Target&gt;<br/>
    /// &lt;/Project&gt;
    /// </example>
    public class ReportGenerator : Task, ITask
    {
        /// <summary>
        /// Gets or sets the report files.
        /// </summary>
        [Required]
        public ITaskItem[] ReportFiles { get; set; }

        /// <summary>
        /// Gets or sets the directory the report will be created in. This must be a directory, not a file. If the directory does not exist, it is created automatically. 
        /// </summary>
        [Required]
        public string TargetDirectory { get; set; }

        /// <summary>
        /// Gets or sets the type of the report.
        /// </summary>
        /// <value>The type of the report.</value>
        public string ReportType { get; set; }

        /// <summary>
        /// When overridden in a derived class, executes the task.
        /// </summary>
        /// <returns>
        /// true if the task successfully executed; otherwise, false.
        /// </returns>
        public override bool Execute()
        {
            string reportFiles = string.Join(";", this.ReportFiles.Select(r => r.ItemSpec));

            string[] arguments = null;

            if (string.IsNullOrEmpty(this.ReportType))
            {
                arguments = new[] { reportFiles, this.TargetDirectory };
            }
            else
            {
                arguments = new[] { reportFiles, this.TargetDirectory, this.ReportType.ToString() };
            }

            int returnCode = Program.Main(arguments);

            return returnCode == 0;
        }
    }
}
