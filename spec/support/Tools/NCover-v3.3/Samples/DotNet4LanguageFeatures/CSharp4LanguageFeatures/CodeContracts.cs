using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics.Contracts;

namespace CSharp4LanguageFeatures
{
    static class CodeContracts
    {
        // must download and install the static and dynamic code contract tools to have the contract mean anything
        // http://msdn.microsoft.com/en-us/devlabs/dd491992.aspx
        // the vidoe on the page above is a very helpful introduction to code contracts

        public static int NextEven(int number)
        {
            Contract.Ensures(number > Contract.OldValue(number));
            Contract.Ensures(Contract.Result<int>() % 2 == 0);

            number = number % 2 == 0
                ? number + 2
                : number + 1;

            return number;
        }

        public static int NextOdd(int number)
        {
            Contract.Ensures(number > Contract.OldValue(number));
            Contract.Ensures(Contract.Result<int>() % 2 == 1);

            number = number % 2 == 1
                ? number + 2
                : number + 1;

            return number;
        }
    }
}
