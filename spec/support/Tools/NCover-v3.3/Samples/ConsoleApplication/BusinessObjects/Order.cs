using System;
using System.Collections.Generic;
#if !vs2005
using System.Linq;
#endif
using System.Text;

namespace BusinessObjects {

    public class Order {

        private static DateTime MIN_ORDER_DATE = new DateTime(2009, 1, 1);

        private int _orderID;
        private DateTime _orderDate;
        private Customer _customer;
        private List<OrderDetail> _orderDetails = new List<OrderDetail>();

        /// <summary>
        /// The Order ID
        /// </summary>
        public int OrderID {
            get {
                return _orderID;
            }
            set {
                //show how we perform validation and the code is not executed until the value is < 0
                if (value <= 0) {
                    throw new ArgumentOutOfRangeException("The value must be greater than 0.");
                }

                _orderID = value;
            }
        }

        /// <summary>
        /// The date that the order was placed
        /// </summary>
        public DateTime OrderDate {
            get {
                return _orderDate;
            }
            set {
                if (value < MIN_ORDER_DATE) {
                    throw new ArgumentOutOfRangeException(string.Format("The value must be greater than {0}.", MIN_ORDER_DATE));
                }
                _orderDate = value;
            }
        }

        /// <summary>
        /// The customer for the order.
        /// </summary>
        public Customer Customer {
            get {
                return _customer;
            }
            set {
                if (value == null) {
                    throw new ArgumentNullException();
                }
                _customer = value;
            }
        }

        /// <summary>
        /// The Order Details
        /// </summary>
        public List<OrderDetail> OrderDetails {
            get {
                return _orderDetails;
            }
        }

        /// <summary>
        /// How many items are in the Order?
        /// </summary>
        /// <returns></returns>
        public int TotalItems() {
#if vs2005
            int retVal = 0;
            foreach (OrderDetail var in OrderDetails) {
              retVal += var.Quantity;
            }
            return retVal;
#else
            //show how this can be done with linq.
            return OrderDetails.Sum(i => i.Quantity);
#endif
        }

        /// <summary>
        /// What is the Total Price of the Order
        /// </summary>
        /// <returns></returns>
        public decimal TotalPrice() {
#if vs2005
          decimal retVal = 0;
          foreach (OrderDetail var in OrderDetails) {
            retVal += (var.UnitPrice * var.Quantity);
          }
          return retVal;
#else
            //show how this can be done with linq.
            return OrderDetails.Sum(i => i.UnitPrice * i.Quantity);
#endif
        }

        /// <summary>
        /// What is the Total Cost of the Order
        /// </summary>
        /// <returns></returns>
        public decimal TotalCost() {
 #if vs2005
          decimal retVal = 0;
          foreach (OrderDetail var in OrderDetails) {
            retVal += (var.Quantity * var.Product.Cost);
          }
          return retVal;
#else
           //show how this can be done with linq.
            return OrderDetails.Sum(i => i.Quantity * i.Product.Cost);
#endif
        }

        /// <summary>
        /// Remove the customer from the order
        /// </summary>
        public void ClearCustomer() {
            _customer = null;
        }

    }
}
