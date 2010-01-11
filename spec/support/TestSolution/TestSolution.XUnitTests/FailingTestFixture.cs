using Xunit;

namespace TestSolution.XUnitTests
{
	public class FailingTestFixture
	{

		[Fact]
		public void FailingTest()
		{
			Assert.True(false);
		}
	}
}