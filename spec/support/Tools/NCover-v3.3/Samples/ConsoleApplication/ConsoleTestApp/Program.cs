using System;
using System.Collections.Generic;
using System.Text;
using SampleLogic;

namespace ConsoleTestApp {

    internal sealed class Program {

        static void Main(string[] args) {

            //we have four switches
            //l //m //h //c coverage

            //any other switch will assume nothing and will exit.
            DisplayHeader();

            if (args.Length == 0 || args[0].Length < 2) {
                DisplayHelp();
                Console.WriteLine("");
                Console.WriteLine("");
                Console.WriteLine("Invalid switch.");
                return;
            }
            string flag = args[0].Substring(1).ToLower();

            //just to see what was executed.
            OrderTests ot = new OrderTests();

            ot.VerifyGetOrderNoItemsNoProductsNoCustomer();

            if (flag == "l") {
                Console.WriteLine("Low Coverage Complete.");
                return;
            }

            ot.VerifyGetOrderWithItemsAndProductAndCustomer();
            if (flag == "m") {
                Console.WriteLine("Medium Coverage Complete.");
                return;
            }

            ot.VerifyGetAdditionalCoveragePart1();
            if (flag == "h") {
                Console.WriteLine("High Coverage Complete.");
                return;
            }

            ot.VerifyGetAdditionalCoveragePart2();
            Console.WriteLine("All Coverage Complete.");
        }

        public static void DisplayHeader() {
            Console.WriteLine("NCover sample command line application.");
            Console.WriteLine("The purpose is to allow you to demonstrate trends or coverage at specific points.");
            Console.WriteLine("");
        }

        public static void DisplayHelp() {

            Console.WriteLine("/l Low coverage. Shows an Order many unvisited points.");
            Console.WriteLine("/m Medium coverage. Shows an order with products and customer.");
            Console.WriteLine("/h High coverage. Shows /m testing everthing possible without testing exceptions.");
            Console.WriteLine("/c Complete coverage. Test everything including invalid data.");
            Console.WriteLine("");
            Console.WriteLine("Use the following command to call this application:");
            Console.WriteLine("ncover.console.exe ConsoleTestApp.exe //at Trends.trend //x Coverage.xml");
        }

    }
}
