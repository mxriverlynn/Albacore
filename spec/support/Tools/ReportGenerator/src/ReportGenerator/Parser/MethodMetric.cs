using System.Collections.Generic;

namespace Palmmedia.ReportGenerator.Parser
{
    /// <summary>
    /// Represents the metrics of a method.
    /// </summary>
    public class MethodMetric
    {
        /// <summary>
        /// List of metrics.
        /// </summary>
        private readonly List<Metric> metrics = new List<Metric>();

        /// <summary>
        /// Initializes a new instance of the <see cref="MethodMetric"/> class.
        /// </summary>
        /// <param name="name">The name.</param>
        public MethodMetric(string name)
        {
            this.Name = name;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MethodMetric"/> class.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="metrics">The metrics.</param>
        public MethodMetric(string name, IEnumerable<Metric> metrics)
        {
            this.Name = name;
            this.AddMetrics(metrics);
        }

        /// <summary>
        /// Gets the list of metrics.
        /// </summary>
        public IEnumerable<Metric> Metrics
        {
            get
            {
                return this.metrics;
            }
        }

        /// <summary>
        /// Gets the name of the method.
        /// </summary>
        public string Name { get; private set; }

        /// <summary>
        /// Adds the given metrics.
        /// </summary>
        /// <param name="metrics">The metrics to add.</param>
        public void AddMetrics(IEnumerable<Metric> metrics)
        {
            this.metrics.AddRange(metrics);
        }
    }
}
