using NUnit.Framework;
using TechTalk.SpecFlow;

namespace TestSolution.SpecFlow
{
    [Binding]
    public class StepDefinition
    {
        private Class1 myclass;
        private string _result;

        [Given(@"I create a Class1")]
        public void GivenICreateAClass1()
        {
            myclass = new Class1();
        }

        [When(@"I call Foo")]
        public void WhenICallFoo()
        {
            _result = myclass.Foo();
        }

        [Then(@"I should get ""(.*)""")]
        public void ThenIShouldGetBar(string value)
        {
            Assert.That(_result, Is.EqualTo(value));
        }
    }
}
