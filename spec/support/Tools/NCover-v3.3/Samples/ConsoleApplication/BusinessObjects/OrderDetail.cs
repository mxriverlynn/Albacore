using System;
using System.Collections.Generic;
using System.Text;

namespace BusinessObjects {

    public class OrderDetail {

        private int _quantity;
        private decimal _unitPrice;
        private Product _product;

        /// <summary>
        /// The product for the order item.
        /// </summary>
        public Product Product {
            get {
                return _product;
            }
            set {
                if (value == null) {
                    throw new ArgumentNullException();
                }
                _product = value;
            }
        }

        /// <summary>
        /// How many items?
        /// </summary>
        public int Quantity {
            get {
                return _quantity;
            }
            set {
                //show how to hit one of the two sequence points.
                if (value == 0 || value < 0) {
                    throw new ArgumentOutOfRangeException("The value must be greater than 0.");
                }
                _quantity = value;
            }
        }

        /// <summary>
        /// What is the unit prices of the item.
        /// </summary>
        public decimal UnitPrice {
            get {
                return _unitPrice;
            }
            set {
                //show how to hit one of the two sequence points.
                if (value == 0 || value < 0) {
                    throw new ArgumentOutOfRangeException("The value must be greater than 0.");
                }
                _unitPrice = value;
            }
        }

        /// <summary>
        /// Clear the product.
        /// </summary>
        public void ClearProduct() {
            _product = null;
        }
    }
}
