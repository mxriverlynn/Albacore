using System;
using System.Collections.Generic;
using ICSharpCode.NRefactory.Ast;

namespace Palmmedia.ReportGenerator.Parser.CodeAnalysis
{
    /// <summary>
    /// Helper class to determine the begin and end line number of source code elements within a source code file.
    /// </summary>
    internal static class SourceCodeAnalyzer
    {
        /// <summary>
        /// The name of the last source code file that has successfully been parsed.
        /// </summary>
        private static string lastFilename;

        /// <summary>
        /// The <see cref="ICSharpCode.NRefactory.Ast.INode"/> of the last source code file that has successfully been parsed.
        /// </summary>
        private static INode lastNode;

        /// <summary>
        /// Searches the given source code file for a source element matching the given <see cref="SourceElement"/>.
        /// If the source element can be found, a <see cref="SourceElementPosition"/> containing the start and end line numbers is returned.
        /// Otherwise <c>null</c> is returned.
        /// </summary>
        /// <param name="filename">The filename.</param>
        /// <param name="sourceElement">The source element.</param>
        /// <returns>A <see cref="SourceElementPosition"/> or <c>null</c> if source element can not be found.</returns>
        public static SourceElementPosition FindSourceElement(string filename, SourceElement sourceElement)
        {
            if (filename == null)
            {
                throw new ArgumentNullException("filename");
            }

            if (sourceElement == null)
            {
                throw new ArgumentNullException("sourceElement");
            }

            // Is the node available in cache?
            if (filename.Equals(lastFilename))
            {
                return FindSourceElement(new INode[] { lastNode }, sourceElement);
            }
            else
            {
                try
                {
                    using (var parser = ICSharpCode.NRefactory.ParserFactory.CreateParser(filename))
                    {
                        if (parser == null)
                        {
                            return null;
                        }

                        parser.Parse();

                        if (parser.Errors.Count != 0 || parser.CompilationUnit == null || parser.CompilationUnit.CurrentBock == null)
                        {
                            return null;
                        }
                        else
                        {
                            // Cache the node
                            lastFilename = filename;
                            lastNode = parser.CompilationUnit.CurrentBock;

                            return FindSourceElement(new INode[] { parser.CompilationUnit.CurrentBock }, sourceElement);
                        }
                    }
                }
                catch (System.IO.IOException)
                {
                    return null;
                }
            }
        }

        /// <summary>
        /// Searches the given <see cref="ICSharpCode.NRefactory.Ast.INode">INodes</see> recursivly for the given <see cref="SourceElement"/>.
        /// </summary>
        /// <param name="nodes">The nodes.</param>
        /// <param name="sourceElement">The source element.</param>
        /// <returns>A <see cref="SourceElementPosition"/> or <c>null</c> if source element can not be found.</returns>
        private static SourceElementPosition FindSourceElement(IEnumerable<INode> nodes, SourceElement sourceElement)
        {
            foreach (var node in nodes)
            {
                var sourceElementPosition = sourceElement.GetSourceElementPosition(node);
                if (sourceElementPosition != null)
                {
                    return sourceElementPosition;
                }
            }

            foreach (var node in nodes)
            {
                var sourceElementPosition = FindSourceElement(node.Children, sourceElement);
                if (sourceElementPosition != null)
                {
                    return sourceElementPosition;
                }
            }

            return null;
        }
    }
}
