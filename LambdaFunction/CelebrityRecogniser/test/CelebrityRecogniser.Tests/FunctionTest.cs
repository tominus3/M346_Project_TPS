using Xunit;
using Amazon.Lambda.Core;
using Amazon.Lambda.TestUtilities;

namespace CelebrityRecogniser.Tests;

public class FunctionTest
{
    [Fact]
    public void TestCelebritiesInImage()
    {
        CelebritiesInImage.Example().Wait();
    }
}
