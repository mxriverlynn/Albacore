using System;
using ICSharpCode.NRefactory.Ast;

namespace Palmmedia.ReportGenerator.Parser.CodeAnalysis
{
    /// <summary>
    /// Represents a property in a source file.
    /// </summary>
    internal class PropertyElement : SourceElement
    {
        /// <summary>
        /// The name of the property.
        /// </summary>
        private readonly string name;

        /// <summary>
        /// Initializes a new instance of the <see cref="PropertyElement"/> class.
        /// </summary>
        /// <param name="name">The name of the property.</param>
        public PropertyElement(string name)
        {
            if (name == null)
            {
                throw new ArgumentNullException("name");
            }

            this.name = name.Substring(4);
        }

        /// <summary>
        /// Determines whether the given <see cref="ICSharpCode.NRefactory.Ast.INode"/> matches the <see cref="SourceElement"/>.
        /// </summary>
        /// <param name="node">The node.</param>
        /// <returns>
        /// A <see cref="SourceElementPosition"/> or <c>null</c> if <see cref="SourceElement"/> does not match the <see cref="ICSharpCode.NRefactory.Ast.INode"/>.
        /// </returns>
        public override SourceElementPosition GetSourceElementPosition(INode node)
        {
            PropertyDeclaration propertyDeclaration = node as PropertyDeclaration;

            if (propertyDeclaration != null && propertyDeclaration.Name.Equals(this.name))
            {
                return new SourceElementPosition(
                    propertyDeclaration.StartLocation.Line,
                    propertyDeclaration.EndLocation.Line);
            }

            return null;
        }
    }
}
