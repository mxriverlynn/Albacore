using System;
using System.Collections.Generic;
using System.Linq;

namespace Palmmedia.ReportGenerator.Parser.Filesearch
{
    public static class CommonStringSearcher
    {
        /// <summary>
        /// Gets the common prefix.
        /// </summary>
        /// <param name="values">The values.</param>
        /// <returns></returns>
        public static string GetCommonPrefix(IEnumerable<string> values)
        {
            if (values == null)
            {
                throw new ArgumentNullException("values");
            }

            if (!values.Any())
            {
                return null;
            }

            string commonPrefix = string.Empty;

            char[] firstValueChars = values.First().ToCharArray();

            foreach (var currentChar in firstValueChars)
            {
                string currentPrefix = commonPrefix + currentChar;

                if (values.Any(v => !v.StartsWith(currentPrefix)))
                {
                    return commonPrefix;
                }
                else
                {
                    commonPrefix = currentPrefix;
                }
            }

            return commonPrefix;
        }
    }
}
