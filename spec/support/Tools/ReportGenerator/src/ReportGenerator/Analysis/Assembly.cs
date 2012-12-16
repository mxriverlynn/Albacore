using System;
using System.Collections.Generic;
using System.Linq;

namespace Palmmedia.ReportGenerator.Analysis
{
    /// <summary>
    /// Represents one assembly.
    /// </summary>
    public class Assembly
    {
        /// <summary>
        /// List of classes in assembly.
        /// </summary>
        private readonly List<Class> classes = new List<Class>();

        /// <summary>
        /// Initializes a new instance of the <see cref="Assembly"/> class.
        /// </summary>
        /// <param name="name">The name of the assembly.</param>
        public Assembly(string name)
        {
            this.Name = name;
        }

        /// <summary>
        /// Gets the list of classes in assembly.
        /// </summary>
        public IEnumerable<Class> Classes
        {
            get
            {
                return this.classes;
            }
        }

        /// <summary>
        /// Gets the name of the assembly.
        /// </summary>
        public string Name { get; private set; }

        /// <summary>
        /// Gets the number of covered lines.
        /// </summary>
        public int CoveredLines
        {
            get
            {
                return this.classes.Sum(clazz => clazz.CoveredLines);
            }
        }

        /// <summary>
        /// Gets the number of coverable lines.
        /// </summary>
        public int CoverableLines
        {
            get
            {
                return this.classes.Sum(clazz => clazz.CoverableLines);
            }
        }

        /// <summary>
        /// Gets the number of total lines.
        /// </summary>
        public int TotalLines
        {
            get
            {
                return this.classes.Sum(clazz => clazz.TotalLines);
            }
        }

        /// <summary>
        /// Gets the coverage quota of the class.
        /// </summary>
        public decimal CoverageQuota
        {
            get
            {
                return (this.CoverableLines == 0) ? 0 : (decimal)Math.Truncate(1000 * (double)this.CoveredLines / (double)this.CoverableLines) / 10;
            }
        }

        /// <summary>
        /// Addes the given class to the assembly.
        /// </summary>
        /// <param name="clazz">The class to add.</param>
        public void AddClass(Class clazz)
        {
            this.classes.Add(clazz);
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
            if (obj == null || !obj.GetType().Equals(typeof(Assembly)))
            {
                return false;
            }
            else
            {
                var assembly = (Assembly)obj;
                return assembly.Name.Equals(this.Name);
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
            return this.Name.GetHashCode();
        }
    }
}
