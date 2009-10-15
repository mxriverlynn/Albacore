ncover.console.exe bin\debug\ConsoleTestApp.exe /l //at output\Trends.trend  //p "My Test Application" //x output\coverage-low.xml
ncover.console.exe bin\debug\ConsoleTestApp.exe /m //at output\Trends.trend  //p "My Test Application" //x output\coverage-medium.xml
ncover.console.exe bin\debug\ConsoleTestApp.exe /h //at output\Trends.trend  //p "My Test Application" //x output\coverage-high.xml
ncover.console.exe bin\debug\ConsoleTestApp.exe /c //at output\Trends.trend  //p "My Test Application" //x output\coverage-complete.xml