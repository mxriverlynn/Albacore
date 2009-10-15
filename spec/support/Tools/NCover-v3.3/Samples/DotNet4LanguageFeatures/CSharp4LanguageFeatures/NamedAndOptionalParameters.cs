using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSharp4LanguageFeatures
{
    class NamedAndOptionalParameters
    {
        public int Quantity { get; set; }
        public string Name { get; set; }
        public Guid Id { get; set; }

        private NamedAndOptionalParameters(Guid myId, int quantity = 1, string name = "")
        {
            Id = myId;
            Quantity = quantity;
            Name = name;
        }

        public static NamedAndOptionalParameters Create(Guid id)
        {
            return new NamedAndOptionalParameters(id);
        }

        public static NamedAndOptionalParameters Create(Guid id, int q)
        {
            return new NamedAndOptionalParameters(id, quantity : q);
        }

        public static NamedAndOptionalParameters Create(Guid id, string n)
        {
            return new NamedAndOptionalParameters(id, name:n);
        }

        public static NamedAndOptionalParameters Create(Guid id, int q, string n)
        {
            return new NamedAndOptionalParameters(id, name:n, quantity:q);
        }

        public override string ToString()
        {
            return string.Format("Id: {0}, Name: '{1}', Quantity: {2}", Id.ToString(), Name, Quantity);
        }
    }
}
