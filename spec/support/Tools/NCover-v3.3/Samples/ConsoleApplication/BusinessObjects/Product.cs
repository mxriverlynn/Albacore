using System;
using System.Collections.Generic;
using System.Text;

namespace BusinessObjects {

    public class Product {

        private string _name;
        private decimal _cost;
        private decimal _price;
        private int _productId;

        /// <summary>
        /// The Name of the product
        /// </summary>
        public string Name {
            get {
                return _name;
            }
            set {
                //why not, lets see if they passed in a padded string.
                if (value != null)
                    value = value.Trim();
                if (string.IsNullOrEmpty(value))
                    throw new ArgumentNullException("The Name of the product must have a value.");
                _name = value;
            }
        }

        /// <summary>
        /// The cost of the product
        /// </summary>
        public decimal Cost {
            get {
                return _cost;
            }
            set {
                if (value == 0 || value < 0) {
                    throw new ArgumentOutOfRangeException("The value must be greater than 0.");
                }
                _cost = value;
            }
        }

        /// <summary>
        /// The price of the product
        /// </summary>
        public decimal Price {
            get {
                return _price;
            }
            set {
                if (value == 0 || value < 0) {
                    throw new ArgumentOutOfRangeException("The value must be greater than 0.");
                }
                _price = value;
            }
        }

        /// <summary>
        /// The product id.
        /// </summary>
        public int ProductId {
            get {
                return _productId;
            }
            set {
                if (value == 0 || value < 0) {
                    throw new ArgumentOutOfRangeException("The value must be greater than 0.");
                }
                _productId = value;
            }
        }
    }
}
