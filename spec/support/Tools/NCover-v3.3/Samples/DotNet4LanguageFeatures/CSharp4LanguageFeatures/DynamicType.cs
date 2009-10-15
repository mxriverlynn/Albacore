using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Dynamic;
using System.Diagnostics.Contracts;

namespace CSharp4LanguageFeatures
{
    class DynamicMock : DynamicObject
    {
        private List<MethodCallInstance> _calls = new List<MethodCallInstance>();

        public void ExpectMethodCall(string name, int expectedCalls = 1, object returnValue = null, params object[] arguments)
        {
            Contract.Requires(!string.IsNullOrEmpty(name));
            Contract.Requires(expectedCalls > 0);

            var method = new MethodCallInstance(name, arguments) {
                ExpectedCallTimes = expectedCalls,
                DeliveredReturnValue = returnValue,
                DoesReturn = MethodType.ValueReturn
            };

            _calls.Add(method);
        }

        public override bool TryInvokeMember(InvokeMemberBinder binder, object[] args, out object result)
        {
            if (_calls.Count < 1)
            {
                throw new MissingMemberException("DynamicMock", binder.Name);
            }

            var methods = from m in _calls
                          where m.Name == binder.Name
                          && m.ExpectedParameters.Length == binder.CallInfo.ArgumentCount
                          select m;

            if (methods.Count() < 1)
            {
                throw new MissingMemberException("DynamicMock", binder.Name);
            }

            var desiredTypes = GetRuntimeTypes(args);
            var matchingMethods = from m in methods
                                 where AreStructurallyEqivalent(desiredTypes, GetRuntimeTypes(m.ExpectedParameters))
                                 select m;

            if (matchingMethods.Count() != 1)
            {
                throw new MissingMemberException("DynamicMock", binder.Name);
            }

            var method = matchingMethods.First();

            if (method.NumTimesCalled >= method.ExpectedCallTimes)
            {
                throw new MemberAccessException("Unexpected number of calls to " + binder.Name + ". Only expected " + method.ExpectedCallTimes + " number of calls.");
            }

            method.NumTimesCalled += 1;
            result = method.DeliveredReturnValue;
            return true;
        }

        private bool AreStructurallyEqivalent(List<Type> left, List<Type> right)
        {
            if (left.Count != right.Count)
                return false;

            var mismatches = left.Zip(right, (lT, rT) => lT == rT).Where(b => b == false);
            return mismatches.Count() < 1;
        }

        private List<Type> GetRuntimeTypes(object[] args)
        {
            if (args == null || args.Length < 1)
                return new List<Type>();

            return (from a in args
                    select a.GetType()).ToList();
        }

        private enum MethodType
        {
            VoidReturn,
            ValueReturn
        }

        private class MethodCallInstance
        {
            public int NumTimesCalled { get; set; }
            public int ExpectedCallTimes { get; set; }

            public object DeliveredReturnValue { get; set; }
            public object[] ExpectedParameters { get; set; }
            
            public MethodType DoesReturn { get; set; }
            public string Name { get; set; }

            public MethodCallInstance(string name, object[] arguments)
            {
                Name = name;
                ExpectedParameters = (arguments == null || arguments.Length < 1) ? new object[0] : arguments;
                DoesReturn = MethodType.VoidReturn;
                ExpectedCallTimes = 1;
            }
        }

    }
}
