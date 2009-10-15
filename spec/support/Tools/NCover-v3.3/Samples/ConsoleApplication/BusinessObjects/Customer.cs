using System;
using System.Collections.Generic;
using System.Text;

namespace BusinessObjects {

    public class Customer {

        private int _customerId;
        private string _customerName;

        /// <summary>
        /// The Customer Id
        /// </summary>
        public int CustomerId {
            get {
                return _customerId;
            }
            set {
                _customerId = value;
            }
        }

        /// <summary>
        /// The Customer Name
        /// </summary>
        public string CustomerName {
            get {
                return _customerName;
            }
            set {
                if (value != null)
                    value = value.Trim();
                if (string.IsNullOrEmpty(value))
                    throw new ArgumentNullException("The Name of the Customer must have a value.");
                _customerName = value;
            }
        }

    }
}
