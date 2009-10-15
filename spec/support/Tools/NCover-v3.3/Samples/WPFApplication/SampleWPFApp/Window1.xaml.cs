using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using SampleLogic;

namespace SampleWPFApp {

    /// <summary>
    /// Interaction logic for Window1.xaml
    /// </summary>
    public partial class Window1 : Window {

        public Window1() {
            InitializeComponent();
        }

        private void sampleTextBoxForChangeEvent_TextChanged(object sender, TextChangedEventArgs e) {
            var i = 0;
            int.TryParse(charactersTypedLabel.Text, out i);
            charactersTypedLabel.Text = (++i).ToString();
        }

        private void buttonOne_Click(object sender, RoutedEventArgs e) {
            var ot = new OrderTests();
            ot.VerifyGetOrderNoItemsNoProductsNoCustomer();
        }

        private void buttonTwo_Click(object sender, RoutedEventArgs e) {
            var ot = new OrderTests();
            ot.VerifyGetOrderWithItemsAndProductAndCustomer();
        }

        private void buttonThree_Click(object sender, RoutedEventArgs e) {
            var ot = new OrderTests();
            ot.VerifyGetAdditionalCoveragePart1();
        }

        private void buttonFour_Click(object sender, RoutedEventArgs e) {
            var ot = new OrderTests();
            ot.VerifyGetAdditionalCoveragePart2();
        }
    }
}
