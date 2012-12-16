using System;

namespace Palmmedia.ReportGenerator.Analysis
{
    /// <summary>
    /// Represents a class.
    /// </summary>
    public class Class
    {
        /// <summary>
        /// The coverage quota.
        /// </summary>
        private decimal? coverageQuota;

        /// <summary>
        /// Initializes a new instance of the <see cref="Class"/> class.
        /// </summary>
        /// <param name="assemblyName">The name of the assembly.</param>
        /// <param name="name">The name of the class.</param>
        public Class(string assemblyName, string name)
        {
            this.AssemblyName = assemblyName;
            this.Name = name;
        }

        /// <summary>
        /// Gets the name of the assembly.
        /// </summary>
        public string AssemblyName { get; private set; }

        /// <summary>
        /// Gets the short name of the assembly.
        /// </summary>
        /// <value>The short name of the assembly.</value>
        public string ShortAssemblyName
        {
            get
            {
                string shortAssemblyName = this.AssemblyName.Replace("/", "\\");
                return shortAssemblyName.Substring(shortAssemblyName.LastIndexOf('\\') + 1);
            }
        }

        /// <summary>
        /// Gets the name of the class.
        /// </summary>
        public string Name { get; private set; }

        /// <summary>
        /// Gets or sets the coverage type.
        /// </summary>
        public CoverageType CoverageType { get; set; }

        /// <summary>
        /// Gets or sets the number of covered lines.
        /// </summary>
        public int CoveredLines { get; set; }

        /// <summary>
        /// Gets or sets the number of coverable lines.
        /// </summary>
        public int CoverableLines { get; set; }

        /// <summary>
        /// Gets or sets the number of total lines.
        /// </summary>
        public int TotalLines { get; set; }

        /// <summary>
        /// Gets or sets the coverage quota of the class.
        /// </summary>
        public decimal CoverageQuota
        {
            get
            {
                if (this.coverageQuota.HasValue)
                {
                    return this.coverageQuota.Value;
                }
                else
                {
                    return (this.CoverableLines == 0) ? 0 : (decimal)Math.Truncate(1000 * (double)this.CoveredLines / (double)this.CoverableLines) / 10;
                }
            }

            set
            {
                this.coverageQuota = value;
            }
        }

        /// <summary>
        /// Determines whether the specified <see cref="System.Object"/> is equal to this instance.
        /// </summary>
        /// <param name="obj">The <see cref="System.Object"/> to compare with this instance.</param>
        /// <returns>
        ///   <c>true</c> if the specified <see cref="System.Object"/> is equal to this instance; otherwise, <c>false</c>.
        /// </returns>
        public override bool Equals(object obj)
        {
            if (obj == null || !obj.GetType().Equals(typeof(Class)))
            {
                return false;
            }
            else
            {
                var clazz = (Class)obj;
                return clazz.AssemblyName.Equals(this.AssemblyName) && clazz.Name.Equals(this.Name);
            }
        }

        /// <summary>
        /// Returns a hash code for this instance.
        /// </summary>
        /// <returns>
        /// A hash code for this instance, suitable for use in hashing algorithms and data structures like a hash table. 
        /// </returns>
        public override int GetHashCode()
        {
            return this.AssemblyName.GetHashCode() + this.Name.GetHashCode();
        }
    }
}
