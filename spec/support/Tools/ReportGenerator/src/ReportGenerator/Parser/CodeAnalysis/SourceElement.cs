using ICSharpCode.NRefactory.Ast;

namespace Palmmedia.ReportGenerator.Parser.CodeAnalysis
{
    /// <summary>
    /// Represents an element in a source code file.
    /// </summary>
    internal abstract class SourceElement
    {
        /// <summary>
        /// Determines whether the given <see cref="ICSharpCode.NRefactory.Ast.INode"/> matches the <see cref="SourceElement"/>.
        /// </summary>
        /// <param name="node">The node.</param>
        /// <returns>A <see cref="SourceElementPosition"/> or <c>null</c> if <see cref="SourceElement"/> does not match the <see cref="ICSharpCode.NRefactory.Ast.INode"/>.</returns>
        public abstract SourceElementPosition GetSourceElementPosition(INode node);
    }
}
