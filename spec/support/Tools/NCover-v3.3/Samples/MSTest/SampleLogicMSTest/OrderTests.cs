using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SampleLogicMSTest {

    [TestClass]
    public class OrderTests {

        /// <summary>
        /// Running just this method will show you how a lambda is not covered in the Order Class.
        /// </summary>
        [TestMethod]
        public void VerifyGetOrderNoItemsNoProductsNoCustomer() {
            var orderDate = DateTime.Now;
            var order = OrderFactory.GetOrderNoItemsNoProductsNoCustomer(orderDate);
            Debug.Assert(order.OrderDate == orderDate, "The Order Date Must Match");
            Debug.Assert(order.Customer == null);
            Debug.Assert(order.TotalCost() == 0);
            Debug.Assert(order.TotalItems() == 0);
            Debug.Assert(order.TotalPrice() == 0);
        }

        [TestMethod]
        public void VerifyGetOrderWithItemsAndProductAndCustomer() {
            var orderDate = DateTime.Now;
            var order = OrderFactory.GetOrderWithItemsAndProductAndCustomer(orderDate);
            Debug.Assert(order.OrderDate == orderDate, "The Order Date Must Match");
            Debug.Assert(order.OrderID == 1);
            Debug.Assert(order.Customer != null);
            Debug.Assert(order.Customer.CustomerId == 1);
            Debug.Assert(order.TotalCost() == 43);
            Debug.Assert(order.TotalItems() == 9);
            Debug.Assert(order.TotalPrice() == 123);
        }

        [TestMethod]
        public void VerifyGetAdditionalCoveragePart1() {
            var orderDate = DateTime.Now;
            var order = OrderFactory.GetOrderWithItemsAndProductAndCustomer(orderDate);
            //verify the customer name
            Debug.Assert(order.Customer.CustomerId == 1);
            Debug.Assert(order.Customer.CustomerName == "Customer 1");
            var prod = order.OrderDetails[0];
            Debug.Assert(prod.Product.Cost == 7);
            Debug.Assert(prod.Product.Name == "Sample Product 1");
            Debug.Assert(prod.Product.Price == 11.50m);
            Debug.Assert(prod.Product.ProductId == 1);

            order.ClearCustomer();
            Debug.Assert(order.Customer == null);

            prod.ClearProduct();
            Debug.Assert(prod.Product == null);
        }

        //we want to complete the coverage by passing bad data.
        [TestMethod]
        public void VerifyGetAdditionalCoveragePart2() {
            try {
                var cust = OrderFactory.GetCustomer1();
                cust.CustomerName = null;
            }
            catch (ArgumentNullException ex) {
                Debug.Assert(ex.Message.IndexOf("The Name of the Customer") > -1);
            }
            var order = OrderFactory.GetOrderWithItemsAndProductAndCustomer(DateTime.Now);
            try {
                order.OrderID = 0;
            }
            catch (ArgumentOutOfRangeException ex) {
                Debug.Assert(ex.Message.IndexOf("The value must be greater than 0") > -1);
            }
            try {
                order.OrderDate = DateTime.Now.AddYears(-1);
            }
            catch (ArgumentOutOfRangeException ex) {
                Debug.Assert(ex.Message.IndexOf("The value must be greater than") > -1);
            }
            try {
                order.Customer = null;
            }
            catch (ArgumentNullException) {

            }
            var od = order.OrderDetails[0];
            //show how you don't have 100% coverage because of the quantity
            try {
                od.Quantity = 0;
            }
            catch (ArgumentOutOfRangeException) {

            }
            try {
                od.UnitPrice = 0;
            }
            catch (ArgumentOutOfRangeException) {

            }

            var prod = od.Product;

            try {
                od.Product = null;
            }
            catch (ArgumentNullException) {

            }

            //now try invalid content for the product

            try {
                prod.Name = string.Empty;
            }
            catch (ArgumentNullException ex) {
                Debug.Assert(ex.Message.IndexOf("The Name of the product must have a value") > -1);
            }

            try {
                prod.Cost = 0.0m;
            }
            catch (ArgumentOutOfRangeException ex) {
                Debug.Assert(ex.Message.IndexOf("The value must be greater than 0") > -1);
            }

            try {
                prod.Price = 0.0m;
            }
            catch (ArgumentOutOfRangeException ex) {
                Debug.Assert(ex.Message.IndexOf("The value must be greater than 0") > -1);
            }

            try {
                prod.ProductId = 0;
            }
            catch (ArgumentOutOfRangeException ex) {
                Debug.Assert(ex.Message.IndexOf("The value must be greater than 0") > -1);
            }
        }
    }
}
