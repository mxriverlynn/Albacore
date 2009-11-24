<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
    <xsl:output method="html" />
    <xsl:param name="reportnameoverride" />

    <!--This gets passed in from the transform so we are able to determine the type-->
    <xsl:variable name="root" select="//trendcoveragedata" />
    <xsl:variable name="reportType" select="//./params[@name = 'reporttype']/@value" />
    <xsl:variable name="date" select="//./params[@name = 'date']/@value" />
    <xsl:variable name="time" select="//./params[@name = 'time']/@value" />
    <xsl:variable name="fulltags" select="string(//./params[@name = 'ishtml']/@value) = '1'" />

    <!--
    Hide elements above what percent? The number must be between 0 and 1 and this is why we divide by 100 so we can use normal numbers
    The example below shows all data, if you changed atmostpercent to 20, only items between 0 and 20 would be displayed.
    -->
    <xsl:variable name="atleastpercent" select="0 div 100" />
    <xsl:variable name="atmostpercent" select="100 div 100" />

    <!--
    Possible values (symbol,branch)
    WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING  WARNING WARNING WARNING WARNING
    The string must be in single quotes or it will default to symbol
    WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING  WARNING WARNING WARNING WARNING
    -->
    <xsl:variable name="atleastpercenttype" select="'symbol'" />
    <!--<xsl:variable name="atleastpercenttype" select="'branch'" />-->
    <!--
    NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE
    The baseimagepath is set up for cc.net by default. You may remove this option or set your own
    path if you do not like /ccnet/images/ as the base.
    NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE 
    -->
    <xsl:variable name="baseimagepath" xml:space="preserve"><xsl:choose>
                                                        <xsl:when test="not ($fulltags)">/ccnet/images/</xsl:when>
                                                        <xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable>
    <!--
    The width of the widest graph in pixels
    The Class in .8 of that and methods are .7
    -->
    <xsl:variable name="graphscale">75</xsl:variable>
    <xsl:variable name="projectstats" select="$root/stats[last()]"></xsl:variable>
    <xsl:variable name="execution" select="$root/execution[last()]"></xsl:variable>
    <xsl:variable name="acceptable" select="$execution/satisfactorycoveragethreshold"></xsl:variable>
    <xsl:variable name="acceptableFunction" select="$execution/satisfactoryfunctionthreshold"></xsl:variable>
    <xsl:variable name="reportName" xml:space="preserve"><xsl:choose>
        <xsl:when test="string($reportnameoverride) != ''"><xsl:value-of select="$reportnameoverride"/></xsl:when>
        <xsl:otherwise><xsl:choose>
            <xsl:when test="string(//./params[@name = 'reportname']/@value) != ''"><xsl:value-of select="//./params[@name = 'reportname']/@value" /></xsl:when>
            <xsl:otherwise><xsl:value-of select="$execution/projectname" /></xsl:otherwise></xsl:choose>
        </xsl:otherwise></xsl:choose></xsl:variable>
    <xsl:variable name="isFunctionReport" select="$reportType = 'MethodModule'
                                                    or $reportType = 'MethodModuleNamespace'
                                                    or $reportType = 'MethodModuleNamespaceClass'
                                                    or $reportType = 'MethodModuleNamespaceClassMethod'
                                                    or $reportType = 'MethodSourceCode'
                                                    or $reportType = 'MethodSourceCodeClass'
                                                    or $reportType = 'MethodSourceCodeClassMethod'
                                                    or $reportType = 'MethodCCModuleClassFailedCoverageTop'
                                                    or $reportType = 'MethodCCModuleClassCoverageTop'"/>
    <xsl:variable name="isDocumentReport" select="$reportType = 'SymbolSourceCode'
                                                    or $reportType = 'SymbolSourceCodeClass'
                                                    or $reportType = 'SymbolSourceCodeClassMethod'
                                                    or $reportType = 'MethodSourceCode'
                                                    or $reportType = 'MethodSourceCodeClass'
                                                    or $reportType = 'MethodSourceCodeClassMethod'"/>
    <xsl:variable name="isDiffReport" select="$reportType = 'Diff'"/>
    <xsl:variable name="isTrendReport" select="$reportType = 'Trends'"/>
    <xsl:variable name="trendCoverageMetric" select="string(//./params[@name = 'trendcoveragemetric']/@value)" />
    <!--params(diffatleast=-.2)-->
    <xsl:variable name="diffAtLeast" xml:space="preserve"><xsl:choose><xsl:when test="string(//./params[@name = 'diffatleast']/@value) != '' and string(number(//./params[@name = 'diffatleast']/@value)) != 'NaN'"><xsl:value-of select="number(//./params[@name = 'diffatleast']/@value)" /></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>
    <!--params(showallitems=true)-->
    <xsl:variable name="showAllItems" select="translate(string(//./params[@name = 'showallitems']/@value),'TRUE','true') = 'true'
                                                or string(//./params[@name = 'showallitems']/@value) = '1'"/>
    <xsl:variable name="reportBranchPoints" select="$projectstats/@vbp" />
    <xsl:variable name="reportVisitCounts" select="$isFunctionReport and $projectstats/@svc" />
    <!--We have specific function CC reports that need the extra column-->
    <xsl:variable name="pointCCReport" select="$reportType = 'SymbolCCModuleClassFailedCoverageTop'
                                                or $reportType = 'SymbolCCModuleClassCoverageTop'" />
    <xsl:variable name="functionalCCReport" select="$reportType = 'SymbolCCModuleClassFailedCoverageTop'
                                                or $reportType = 'SymbolCCModuleClassCoverageTop'" />
    <xsl:variable name="ccnodeExists" select="$projectstats/@ccavg" />
    <xsl:variable name="ccdataExists" select="$projectstats/@ccavg > 0" />
    <xsl:variable name="trendsdataexist" select="count($projectstats/tp) > 0" />
    <xsl:variable name="reportCC" xml:space="preserve" select="($functionalCCReport and $ccdataExists)
                                                                or    ($projectstats/@ccavg and $ccdataExists and not ($isFunctionReport))" />
    <xsl:variable name="vcColumnCount" xml:space="preserve"><xsl:choose>
                                                            <xsl:when test="$reportVisitCounts">2</xsl:when>
                                                            <xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>
    <xsl:variable name="ccClassCount" xml:space="preserve"><xsl:choose>
                                                            <xsl:when test="$reportType = 'SymbolCCModuleClassFailedCoverageTop'">20</xsl:when>
                                                            <xsl:when test="$reportType = 'SymbolCCModuleClassCoverageTop'">20</xsl:when>
                                                            <xsl:otherwise>20</xsl:otherwise></xsl:choose></xsl:variable>
    <xsl:variable name="ccColumnCount" xml:space="preserve"><xsl:choose>
                                                            <xsl:when test="$reportCC">1</xsl:when>
                                                            <xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>
    <xsl:variable name="tablecolumns" xml:space="preserve"><xsl:choose>
                                                            <xsl:when test="$isDiffReport">16</xsl:when>
                                                            <xsl:when test="$isTrendReport">6</xsl:when>
                                                            <xsl:when test="not ($isFunctionReport) and $reportBranchPoints"><xsl:value-of select="9 + $ccColumnCount" /></xsl:when>
                                                            <xsl:otherwise><xsl:value-of select="5 + $ccColumnCount + $vcColumnCount" /></xsl:otherwise></xsl:choose></xsl:variable>
    <xsl:variable name="reportTitle">
        <xsl:choose xml:space="preserve">
            <xsl:when test="$reportType = 'MethodModule'">Method Module</xsl:when>
            <xsl:when test="$reportType = 'MethodModuleNamespace'">Method Module and Namespace</xsl:when>
            <xsl:when test="$reportType = 'MethodModuleNamespaceClass'">Method Module, Namespace and Classes</xsl:when>
            <xsl:when test="$reportType = 'MethodModuleNamespaceClassMethod'">Method Module, Namespace, Class and Methods</xsl:when>
            <xsl:when test="$reportType = 'MethodSourceCode'">Method Source File</xsl:when>
            <xsl:when test="$reportType = 'MethodSourceCodeClass'">Method Source File and Class</xsl:when>
            <xsl:when test="$reportType = 'MethodSourceCodeClassMethod'">Method Source Code, Class and Methods</xsl:when>
            <xsl:when test="$reportType = 'SymbolModule'">Symbol Module</xsl:when>
            <xsl:when test="$reportType = 'SymbolModuleNamespace'">Symbol Module and Namespace</xsl:when>
            <xsl:when test="$reportType = 'SymbolModuleNamespaceClass'">Symbol Module, Namespace and Class</xsl:when>
            <xsl:when test="$reportType = 'SymbolModuleNamespaceClassMethod'">Symbol Module, Namespace, Class and Methods</xsl:when>
            <xsl:when test="$reportType = 'SymbolSourceCode'">Source Code</xsl:when>
            <xsl:when test="$reportType = 'SymbolSourceCodeClass'">Source Code and Class</xsl:when>
            <xsl:when test="$reportType = 'SymbolSourceCodeClassMethod'">Source Code, Class and Methods</xsl:when>
            <!--We may need to change this-->
            <xsl:when test="$reportType = 'SymbolCCModuleClassFailedCoverageTop'">
                Cyclomatic Complexity Coverage Top <xsl:value-of select="$ccClassCount" /> Failing Coverage
            </xsl:when>
            <xsl:when test="$reportType = 'SymbolCCModuleClassCoverageTop'">
                Cyclomatic Complexity Coverage Top <xsl:value-of select="$ccClassCount" />
            </xsl:when>
            <xsl:when test="$reportType = 'MethodCCModuleClassFailedCoverageTop'">
                Cyclomatic Complexity Function Coverage Top <xsl:value-of select="$ccClassCount" /> Failing Coverage
            </xsl:when>
            <xsl:when test="$reportType = 'MethodCCModuleClassCoverageTop'">
                Cyclomatic Complexity Function Coverage Top <xsl:value-of select="$ccClassCount" />
            </xsl:when>
            <xsl:when test="$reportType = 'Trends'">Trends Report</xsl:when>
            <xsl:when test="$reportType = 'Diff'">Diff Report</xsl:when>
            <xsl:otherwise>Unkown Report</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vFilterStyle" select="//./params[@name = 'filterstyle']/@value" />
    <xsl:variable name="vSortStyle">
        <xsl:choose>
            <xsl:when test="$pointCCReport or $functionalCCReport">CC</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="//./params[@name = 'sortstyle']/@value" />
            </xsl:otherwise>
        </xsl:choose>

    </xsl:variable>

    <xsl:variable name="filterStyle">
        <xsl:choose>
            <xsl:when test="$vFilterStyle = 'HideFullyCovered'">Hide Fully Covered</xsl:when>
            <xsl:when test="$vFilterStyle = 'HideThresholdCovered'">Hide Threshold Covered</xsl:when>
            <xsl:when test="$vFilterStyle = 'HideUnvisited'">Hide Unvisited</xsl:when>
            <xsl:when test="$vFilterStyle = 'None'">None</xsl:when>
            <xsl:otherwise>Unknown</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="sortStyle">
        <xsl:choose>
            <xsl:when test="$vSortStyle = 'ClassLine'">Class Line</xsl:when>
            <xsl:when test="$vSortStyle = 'CoveragePercentageAscending'">Coverage Percentage Ascending</xsl:when>
            <xsl:when test="$vSortStyle = 'CoveragePercentageDescending'">Coverage Percentage Descending</xsl:when>
            <xsl:when test="$vSortStyle = 'FunctionCoverageAscending'">Function Coverage Ascending</xsl:when>
            <xsl:when test="$vSortStyle = 'FunctionCoverageDescending'">Function Coverage Descending</xsl:when>
            <xsl:when test="$vSortStyle = 'Name'">Name</xsl:when>
            <xsl:when test="$vSortStyle = 'UnvisitedSequencePointsAscending'">Unvisited Sequence Point Ascending</xsl:when>
            <xsl:when test="$vSortStyle = 'UnvisitedSequencePointsDescending'">Unvisited Sequence Point Descending</xsl:when>
            <xsl:when test="$vSortStyle = 'VisitCountAscending'">Visit Count Ascending</xsl:when>
            <xsl:when test="$vSortStyle = 'VisitCountDescending'">Visit Count Descending</xsl:when>
            <xsl:when test="$vSortStyle = 'CC'">Cyclomatic Complexity Descending</xsl:when>
            <xsl:otherwise>Unknown</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="/" xml:space="preserve">
        <xsl:choose>
            <xsl:when test="$fulltags">
                <html>
                    <head>
                        <title>
                            <xsl:value-of select="$reportTitle"/> - <xsl:value-of select="$filterStyle"/>  - <xsl:value-of select="$sortStyle"/>
                        </title>
                        <xsl:comment>NCover 3.0 Template</xsl:comment>
                        <xsl:comment>Generated by the Joe Feser joe@ncover.com on the NCover team and inspired by the original template by Grant Drake</xsl:comment>
                        <xsl:call-template name="style" />
                    </head>
                    <body>
                        <table class="coverageReportTable" cellpadding="2" cellspacing="0">
                            <tbody>
                                <xsl:apply-templates select="$root" />
                            </tbody>
                        </table>
                    </body>
                </html>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="style" />
                <xsl:apply-templates select="$root" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Main Project Section -->
    <xsl:template match="trendcoveragedata">
        <xsl:variable name="threshold">
            <xsl:choose>
                <xsl:when test="$isFunctionReport">
                    <xsl:value-of select="$acceptableFunction" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$acceptable" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="unvisitedTitle">
            <xsl:choose>
                <xsl:when test="$isFunctionReport">U.V.</xsl:when>
                <xsl:otherwise>U.V.</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="excludedTitle">
            <xsl:choose>
                <xsl:when test="$isFunctionReport">Functions</xsl:when>
                <xsl:otherwise>SeqPts</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="coverageTitle">
            <xsl:choose>
                <xsl:when test="$isFunctionReport">Function Coverage</xsl:when>
                <xsl:otherwise>Coverage</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:call-template name="header" />

        <xsl:choose>
            <xsl:when test="$isDiffReport">
                <xsl:call-template name="diffProjectSummary">
                    <xsl:with-param name="threshold" select="$threshold" />
                    <xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
                    <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$isTrendReport">
                <xsl:call-template name="trendsProjectSummary">
                    <xsl:with-param name="threshold" select="$threshold" />
                    <xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
                    <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="projectSummary">
                    <xsl:with-param name="threshold" select="$threshold" />
                    <xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
                    <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>


        <!--SymbolCCModuleClassFailedCoverageTop we show everything sorted by cc desc and coverage asc-->
        <xsl:if test="$reportType = 'SymbolCCModuleClassFailedCoverageTop' 
                        or $reportType = 'SymbolCCModuleClassCoverageTop'
                        or $reportType = 'MethodCCModuleClassFailedCoverageTop'
                        or $reportType = 'MethodCCModuleClassCoverageTop'">
            <xsl:call-template name="cyclomaticComplexitySummaryCommon">
                <xsl:with-param name="threshold" select="$threshold" />
                <xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
                <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                <xsl:with-param name="printClasses">True</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <!--Output the top level module information moduleSummary-->
        <xsl:if test="$reportType = 'SymbolModule' or $reportType = 'MethodModule'">
            <xsl:call-template name="moduleSummary">
                <xsl:with-param name="threshold" select="$threshold" />
                <xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
                <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                <xsl:with-param name="printClasses">True</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <!--Output the top level module information moduleSummary-->
        <xsl:if test="$reportType = 'SymbolSourceCode' or $reportType = 'MethodSourceCode'">
            <xsl:call-template name="documentSummary">
                <xsl:with-param name="threshold" select="$threshold" />
                <xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
                <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                <xsl:with-param name="printClasses">True</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <!--Output the top level module information moduleSummary-->
        <xsl:if test="$reportType = 'SymbolSourceCodeClass' 
                                or $reportType = 'MethodSourceCodeClass'
                                or $reportType = 'SymbolSourceCodeClassMethod' 
                                or $reportType = 'MethodSourceCodeClassMethod'">
            <xsl:call-template name="documentSummaryCommon">
                <xsl:with-param name="threshold" select="$threshold" />
                <xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
                <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                <xsl:with-param name="printClasses">True</xsl:with-param>
                <xsl:with-param name="printMethods">
                    <xsl:choose xml:space="preserve">
                        <xsl:when test="$reportType = 'SymbolSourceCodeClassMethod' or $reportType = 'MethodSourceCodeClassMethod'">True</xsl:when>
                        <xsl:otherwise>False</xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <!--if the report is namespace based, then output the namespace information.-->
        <xsl:if test="$reportType = 'SymbolModuleNamespace' or $reportType = 'MethodModuleNamespace'">
            <xsl:call-template name="summaryCommon">
                <xsl:with-param name="threshold" select="$threshold" />
                <xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
                <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                <xsl:with-param name="printClasses">False</xsl:with-param>
                <xsl:with-param name="printMethods">False</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="($reportType = 'SymbolModuleNamespaceClass') or ($reportType = 'MethodModuleNamespaceClass')">
            <xsl:call-template name="summaryCommon">
                <xsl:with-param name="threshold" select="$threshold" />
                <xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
                <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                <xsl:with-param name="printClasses">True</xsl:with-param>
                <xsl:with-param name="printMethods">False</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="($reportType = 'SymbolModuleNamespaceClassMethod') or ($reportType = 'MethodModuleNamespaceClassMethod')">
            <xsl:call-template name="summaryCommon">
                <xsl:with-param name="threshold" select="$threshold" />
                <xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
                <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                <xsl:with-param name="printClasses">True</xsl:with-param>
                <xsl:with-param name="printMethods">True</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="($reportType = 'Diff')">
            <xsl:call-template name="diffSummaryCommon">
                <xsl:with-param name="threshold" select="$threshold" />
                <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                <xsl:with-param name="printClasses">True</xsl:with-param>
                <xsl:with-param name="printMethods">True</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="($reportType = 'Trends')">
            <xsl:call-template name="trendsSummaryCommon">
                <xsl:with-param name="threshold" select="$threshold" />
                <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                <xsl:with-param name="printClasses">True</xsl:with-param>
                <xsl:with-param name="printMethods">True</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="count($root/exclusions/exclusion) != 0">
            <xsl:call-template name="exclusionsSummary" >
                <xsl:with-param name="excludedTitle" select="$excludedTitle" />
            </xsl:call-template>
        </xsl:if>

        <xsl:call-template name="footer2" />

        <!--This is used by the trend file.-->
        <span id="trendGraph" style="display: none"></span>
    </xsl:template>

    <!-- Report Header -->
    <xsl:template name="header">
        <tr>
            <td class="projectTable reportHeader" colspan="{$tablecolumns}">
                <table width="100%">
                    <tbody>
                        <tr>
                            <td valign="top">
                                <h1 class="titleText">
                                    NCover Report - <xsl:value-of select="$reportName" />&#160;-&#160;<xsl:value-of select="$reportTitle" />
                                </h1>
                                <table cellpadding="1" class="subtitleText">
                                    <tbody>
                                        <xsl:if test="string(//./params[@name = 'coveragedate']/@value) != ''">
                                            <tr>
                                                <td class="heading">Coverage generated on:</td>
                                                <td>
                                                    <xsl:value-of select="string(//./params[@name = 'coveragedate']/@value)" />&#160;at&#160;<xsl:value-of select="string(//./params[@name = 'coveragetime']/@value)" />
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <tr>
                                            <td class="heading">Report generated on:</td>
                                            <td>
                                                <xsl:value-of select="$date" />&#160;at&#160;<xsl:value-of select="$time" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="heading">NCover Profiler version:</td>
                                            <td>
                                                <xsl:value-of select="$execution/profilerversion" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="heading">Filtering / Sorting:</td>
                                            <td>
                                                <xsl:value-of select="$filterStyle" />&#160;/&#160;<xsl:value-of select="$sortStyle" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="heading">Report version:</td>
                                            <td>
                                                2009.06.23.12.20
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                            <td class="projectStatistics" align="right" valign="top">
                                <table cellpadding="1" class="subtitleText">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="true" class="heading">
                                                <xsl:attribute name="rowspan" xml:space="preserve"><xsl:choose><xsl:when test="$reportBranchPoints">5</xsl:when><xsl:otherwise>4</xsl:otherwise></xsl:choose></xsl:attribute>
                                                Project Statistics:
                                            </td>
                                            <td align="right" class="heading">Files:</td>
                                            <td align="right">
                                                <xsl:value-of select="count($root/doc)" />
                                            </td>
                                            <td>
                                                <xsl:attribute name="rowspan" xml:space="preserve"><xsl:choose><xsl:when test="$reportBranchPoints">5</xsl:when><xsl:otherwise>4</xsl:otherwise></xsl:choose></xsl:attribute>
                                                &#160;
                                            </td>
                                            <td align="right" class="heading">NCLOC:</td>
                                            <td align="right">
                                                <xsl:value-of select="$projectstats/@ul + $projectstats/@vl" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" class="heading">Classes:</td>
                                            <td align="right">
                                                <xsl:value-of select="count($root/mod/ns/class)" />
                                            </td>
                                            <td align="right" class="heading">&#160;</td>
                                            <td align="right">&#160;</td>
                                        </tr>
                                        <tr>
                                            <td align="right" class="heading">Functions:</td>
                                            <td align="right">
                                                <xsl:value-of select="$projectstats/@vm + $projectstats/@um" />
                                            </td>
                                            <td align="right" class="heading">Unvisited:</td>
                                            <td align="right">
                                                <xsl:value-of select="$projectstats/@um" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" class="heading">Seq Pts:</td>
                                            <td align="right">
                                                <xsl:value-of select="$projectstats/@usp + $projectstats/@vsp" />
                                            </td>
                                            <td align="right" class="heading">Unvisited:</td>
                                            <td align="right">
                                                <xsl:value-of select="$projectstats/@usp" />
                                            </td>
                                        </tr>
                                        <xsl:if test="$reportBranchPoints">
                                            <tr>
                                                <td align="right" class="heading">Branch Pts:</td>
                                                <td align="right">
                                                    <xsl:value-of select="$projectstats/@ubp + $projectstats/@vbp" />
                                                </td>
                                                <td align="right" class="heading">Unvisited:</td>
                                                <td align="right">
                                                    <xsl:value-of select="$projectstats/@ubp" />
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="$ccnodeExists and not ($ccdataExists)">
                                            <tr>
                                                <td colspan="6" align="right" class="heading">Cyclomatic complexity data does not exist</td>
                                            </tr>
                                        </xsl:if>

                                        <xsl:if test="count($root/doc[@id != 0]) = 0 or $projectstats/@usp + $projectstats/@vsp = 0">
                                            <tr>
                                                <td colspan="6" align="right" class="heading">
                                                    Symbols were not available for this execution.<br />The sequence points coverage data will not be available.
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test ="(not ($trendsdataexist) and $isTrendReport) or (string($projectstats/@dvsp) = '' and $isDiffReport)">
                                            <tr>
                                                <td colspan="6" align="right" class="heading">
                                                    Trend or Diff data does not exist and the report will not render correctly.
                                                </td>
                                            </tr>
                                        </xsl:if>
                                    </tbody>
                                </table>
                            </td>
                        </tr>

                        <xsl:if test="name(.) != 'trendcoveragedata' or not ($root)">
                            <tr>
                                <td>
                                    <b>
                                        The input file used to generate the report must start with 'trendcoveragedata' and the file provided started with '<xsl:value-of select="name(.)"/>'
                                    </b>
                                </td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="name(.) = 'coverage'">
                            <tr>
                                <td>
                                    <b>
                                        The input file used to generate the report is a coverage file and not a report file. Please use ncover.reporting to generate an xml file format that may be used with this xsl file.
                                    </b>
                                </td>
                            </tr>
                        </xsl:if>

                    </tbody>
                </table>
            </td>
        </tr>
    </xsl:template>

    <!-- Project Summary -->
    <xsl:template name="projectSummary">
        <xsl:param name="threshold" />
        <xsl:param name="unvisitedTitle" />
        <xsl:param name="coverageTitle" />
        <!--The Total points or methods-->
        <xsl:variable name="total">
            <xsl:call-template name="gettotal">
                <xsl:with-param name="stats" select="$projectstats" />
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="sectionTableHeader">
            <xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
            <xsl:with-param name="coverageTitle" select="$coverageTitle" />
            <xsl:with-param name="sectionTitle">Project</xsl:with-param>
            <xsl:with-param name="cellClass">projectTable</xsl:with-param>
            <xsl:with-param name="showThreshold">True</xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="coverageDetail">
            <xsl:with-param name="name">
                <xsl:choose>
                    <xsl:when test="string-length($reportName) > 0">
                        <xsl:value-of select="$reportName" />
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="stats" select="$projectstats" />
            <xsl:with-param name="showThreshold">True</xsl:with-param>
            <xsl:with-param name="showBottomLine">True</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!--Build the header for each of the sections.
    It removes the complexity of building the multi table headers for the project and then the modules-->
    <xsl:template name="sectionTableHeader">
        <xsl:param name="unvisitedTitle" />
        <xsl:param name="coverageTitle" />
        <xsl:param name="sectionTitle" />
        <xsl:param name="cellClass" />
        <xsl:param name="showThreshold" />

        <!--We want to determine how many items can be shows above a percent-->
        <xsl:variable xml:space="preserve" name="qualifiedmethods"><xsl:call-template name="qualifiednodes" /></xsl:variable>
        <xsl:if test="$qualifiedmethods > 0">
            <!--white space-->
            <tr>
                <td colspan="{$tablecolumns}">&#160;</td>
            </tr>
            <!--Top row showing SP and BP Data-->
            <xsl:if test="not ($isFunctionReport)">
                <tr>
                    <td class="{$cellClass} mtHdLeftTop">&#160;</td>
                    <td class="{$cellClass} mtHdRightTop">
                        <xsl:attribute name="colspan" xml:space="preserve"><xsl:choose><xsl:when test="$showThreshold = 'True'">4</xsl:when><xsl:otherwise>3</xsl:otherwise></xsl:choose></xsl:attribute>Sequence Points
                    </td>
                    <xsl:if test="$reportBranchPoints">
                        <td class="{$cellClass} mtHdRightTop">
                            <xsl:attribute name="colspan" xml:space="preserve"><xsl:choose><xsl:when test="$showThreshold = 'True'">4</xsl:when><xsl:otherwise>3</xsl:otherwise></xsl:choose></xsl:attribute>Branch Points
                        </td>
                    </xsl:if>
                    <xsl:if test="$reportCC">
                        <td class="{$cellClass} mtHdRightTop">C. C.</td>
                    </xsl:if>
                </tr>
            </xsl:if>
            <tr>
                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:value-of select="$cellClass" /><xsl:choose><xsl:when test="$isFunctionReport"> mtHdLeftFunc</xsl:when><xsl:otherwise> mtHdLeft</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:value-of select="$sectionTitle" disable-output-escaping="yes" />
                </td>
                <td class="{$cellClass} mtHd">Acceptable</td>
                <td class="{$cellClass} mtHd">
                    <xsl:value-of select="$unvisitedTitle" />
                </td>
                <!--This cell contains both the text and the chart.-->
                <td class="{$cellClass} mtgHd" style="text-align: center;" colspan="2">
                    <xsl:value-of select="$coverageTitle" />
                </td>

                <xsl:if test="not ($isFunctionReport) and $reportBranchPoints">
                    <td class="{$cellClass} mtHd">Acceptable</td>
                    <td class="{$cellClass} mtHd">
                        <xsl:value-of select="$unvisitedTitle" />
                    </td>
                    <!--This cell contains both the text and the chart.-->
                    <td class="{$cellClass} mtgHd" style="text-align: center;" colspan="2">
                        <xsl:value-of select="$coverageTitle" />
                    </td>
                </xsl:if>
                <xsl:if test="$reportCC">
                    <td class="{$cellClass} mtHd">
                        <xsl:if test="$functionalCCReport">
                            C.C.<br />
                        </xsl:if> Avg / Max
                    </td>
                </xsl:if>
                <xsl:if test="$reportVisitCounts">
                    <td class="{$cellClass} mtHd">Visit Count</td>
                    <td class="{$cellClass} mtHd">V.C. %</td>
                </xsl:if>
            </tr>
        </xsl:if>
    </xsl:template>

    <!-- Modules Summary -->
    <xsl:template name="moduleSummary">
        <xsl:param name="threshold" />
        <xsl:param name="unvisitedTitle" />
        <xsl:param name="coverageTitle" />

        <xsl:call-template name="sectionTableHeader">
            <xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
            <xsl:with-param name="coverageTitle" select="$coverageTitle" />
            <xsl:with-param name="sectionTitle">Modules</xsl:with-param>
            <xsl:with-param name="cellClass">primaryTable</xsl:with-param>
            <xsl:with-param name="showThreshold">True</xsl:with-param>
        </xsl:call-template>



        <xsl:for-each select="$root/mod[string(stats/@ex) != '1']">
            <xsl:variable name="stats" select="stats[last()]" />
            <!--The Total points or methods-->
            <xsl:variable name="total">
                <xsl:call-template name="gettotal">
                    <xsl:with-param name="stats" select="$stats" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:call-template name="coverageDetail">
                <xsl:with-param name="name" select="assembly" />
                <xsl:with-param name="stats" select="$stats" />
                <xsl:with-param name="showThreshold">True</xsl:with-param>
                <xsl:with-param name="showBottomLine">True</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!--Document Summary-->

    <xsl:template name="documentSummary">
        <xsl:param name="threshold" />
        <xsl:param name="unvisitedTitle" />
        <xsl:param name="coverageTitle" />

        <xsl:call-template name="sectionTableHeader">
            <xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
            <xsl:with-param name="coverageTitle" select="$coverageTitle" />
            <xsl:with-param name="sectionTitle">Documents</xsl:with-param>
            <xsl:with-param name="cellClass">primaryTable</xsl:with-param>
            <xsl:with-param name="showThreshold">True</xsl:with-param>
        </xsl:call-template>

        <xsl:for-each select="$root/doc[string(stats/@ex) != '1' and string(@id) != '0']">
            <!--<xsl:sort select="en"/>-->
            <xsl:variable name="stats" select="stats[last()]" />
            <xsl:call-template name="coverageDetail">
                <xsl:with-param name="name" select="en" />
                <xsl:with-param name="stats" select="$stats" />
                <xsl:with-param name="showThreshold">True</xsl:with-param>
                <xsl:with-param name="showBottomLine">True</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!--Helper templates-->

    <!-- Coverage detail row in main grid displaying a name, statistics and graph bar -->
    <xsl:template name="coverageDetail">
        <xsl:param name="name" />
        <xsl:param name="stats" />
        <xsl:param name="showThreshold" />
        <xsl:param name="showBottomLine" />
        <!--By default this needs to be unvisited count-->
        <xsl:param name="countText">
            <xsl:call-template name="unvisiteditems">
                <xsl:with-param name="stats" select="$stats" />
            </xsl:call-template>
        </xsl:param>
        <xsl:param name="styleTweak" />
        <xsl:param name="scale" select="$graphscale" />
        <xsl:variable name="total">
            <xsl:call-template name="gettotal">
                <xsl:with-param name="stats" select="$stats" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="totalbranch">
            <xsl:call-template name="gettotal">
                <xsl:with-param name="stats" select="$stats" />
                <xsl:with-param name="branch" select="'True'" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="unvisitedcount">
            <xsl:call-template name="unvisiteditems">
                <xsl:with-param name="stats" select="$stats" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="unvisitedcountbranch">
            <xsl:value-of select="$stats/@ubp" />
        </xsl:variable>
        <xsl:variable name="coverage">
            <xsl:choose>
                <xsl:when test="$total = 0">N/A</xsl:when>
                <xsl:when test="$isFunctionReport">
                    <xsl:value-of select="($stats/@vm div $total) * 100" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="($stats/@vsp div $total) * 100" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="coveragebranch">
            <xsl:choose>
                <xsl:when test="$totalbranch = 0">N/A</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="($stats/@vbp div $totalbranch) * 100" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="threshold">
            <xsl:choose>
                <xsl:when test="$isFunctionReport">
                    <xsl:value-of select="$stats/@afp" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$stats/@acp" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="thresholdbranch">
            <xsl:choose>
                <xsl:when test="$isFunctionReport">
                    <xsl:value-of select="$stats/@afp" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$stats/@abp" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!--We want to determine how many items can be shows above a percent-->
        <xsl:variable xml:space="preserve" name="qualifiedmethods"><xsl:call-template name="qualifiednodes" /></xsl:variable>
        <xsl:if test="$qualifiedmethods > 0">
            <tr>
                <xsl:choose>
                    <xsl:when test="$showThreshold='True'">
                        <td>
                            <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mtcItem</xsl:attribute>
                            <xsl:if test="$styleTweak != ''" xml:space="preserve"><xsl:attribute name="style"><xsl:value-of select="$styleTweak"/></xsl:attribute></xsl:if>
                            <div class="mtDiv">
                                <xsl:value-of select="$name" />
                            </div>
                        </td>
                        <td>
                            <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                            <xsl:value-of select="concat(format-number($threshold,'#0.0'), ' %')" />
                        </td>
                    </xsl:when>
                    <xsl:otherwise>
                        <td colspan="2">
                            <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mtcItem</xsl:attribute>
                            <xsl:if test="$styleTweak != ''" xml:space="preserve"><xsl:attribute name="style"><xsl:value-of select="$styleTweak"/></xsl:attribute></xsl:if>
                            <div class="mtDiv">
                                <xsl:value-of select="$name" />
                            </div>
                        </td>
                    </xsl:otherwise>
                </xsl:choose>
                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                    <xsl:value-of select="$countText" />
                </td>
                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mPt</xsl:attribute>
                    <xsl:call-template name="printcoverage">
                        <xsl:with-param name="coverage" select="$coverage"></xsl:with-param>
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>tmcGraph</xsl:attribute>
                    <xsl:call-template name="coverageBarChart">
                        <xsl:with-param name="notVisited" select="$unvisitedcount" />
                        <xsl:with-param name="total" select="$total" />
                        <xsl:with-param name="threshold" select="$threshold" />
                        <xsl:with-param name="scale" select="$scale" />
                    </xsl:call-template>
                </td>
                <!--This section can be hard coded to branch points since that is all that it does.-->
                <xsl:if test="not ($isFunctionReport) and $reportBranchPoints">
                    <td>
                        <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$showThreshold='True'">
                                <xsl:value-of select="concat(format-number($thresholdbranch,'#0.0'), ' %')" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text disable-output-escaping="yes">&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                    <td>
                        <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                        <xsl:value-of select="$unvisitedcountbranch" />
                    </td>
                    <td>
                        <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mPt</xsl:attribute>
                        <xsl:call-template name="printcoverage">
                            <xsl:with-param name="coverage" select="$coveragebranch"></xsl:with-param>
                        </xsl:call-template>
                    </td>
                    <td>
                        <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>tmcGraph</xsl:attribute>
                        <xsl:call-template name="coverageBarChart">
                            <xsl:with-param name="notVisited" select="$unvisitedcountbranch" />
                            <xsl:with-param name="total" select="$totalbranch" />
                            <xsl:with-param name="threshold" select="$thresholdbranch" />
                            <xsl:with-param name="scale" select="$scale" />
                        </xsl:call-template>
                    </td>
                </xsl:if>
                <xsl:if test="$reportCC">
                    <td>
                        <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                        <xsl:value-of select="$stats/@ccavg" /> / <xsl:value-of select="$stats/@ccmax" />
                    </td>
                </xsl:if>
                <xsl:if test="$reportVisitCounts">
                    <xsl:variable name="count" select="$stats/@svc" />
                    <td>
                        <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$count > 0">
                                <xsl:value-of select="$count" />
                            </xsl:when>
                            <xsl:otherwise>-</xsl:otherwise>
                        </xsl:choose>
                    </td>
                    <td>
                        <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$count > 0">
                                <xsl:call-template name="printcoverage">
                                    <xsl:with-param name="coverage" select="($count div $projectstats/@svc) * 100"></xsl:with-param>
                                    <xsl:with-param name="twoplaces" select="'1'" />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>-</xsl:otherwise>
                        </xsl:choose>
                    </td>
                </xsl:if>
            </tr>
        </xsl:if>
    </xsl:template>

    <!-- Exclusions Summary Not supported at this time.-->
    <xsl:template name="exclusionsSummary">
        <xsl:param name="excludedTitle" />
        <!--<tr>
            <td colspan="{$tablecolumns}">&#160;</td>
        </tr>
        <tr>
            <td class="exclusionTable mtHdLeft" colspan="1">Exclusion In Module</td>
            <td class="exclusionTable mtgHd" colspan="3">Item Excluded</td>
            <td class="exclusionTable mtgHd" colspan="1">All Code Within</td>
            <td class="exclusionTable mtgHd2" colspan="1">
                <xsl:value-of select="$excludedTitle" />
            </td>
        </tr>
        <xsl:for-each select="./exclusions/exclusion">
            <tr>
                <td class="mb etcItem exclusionCell" colspan="1">
                    <xsl:value-of select="@m" />
                </td>
                <td class="mb tmcGraph exclusionCell" colspan="3">
                    <xsl:value-of select="@n" />
                </td>
                <td class="mb tmcGraph exclusionCell" colspan="1">
                    <xsl:value-of select="@cat" />
                </td>
                <td class="mb mtcData exclusionCell" colspan="1">
                    <xsl:value-of select="@fp" />
                </td>
            </tr>
        </xsl:for-each>
        <tr>
            <td colspan="4">&#160;</td>
            <td class="exclusionTable mtHdLeft">Total</td>
            <td class="exclusionTable mtgHd2">
                <xsl:value-of select="sum(./exclusions/exclusion/@fp)"/>
            </td>
        </tr>-->
    </xsl:template>

    <!-- Footer -->
    <xsl:template name="footer2">
        <tr>
            <td colspan="{$tablecolumns}">&#160;</td>
        </tr>
    </xsl:template>

    <!-- Draw % Green/Red/Yellow Bar -->
    <xsl:template name="coverageBarChart">
        <xsl:param name="notVisited" />
        <xsl:param name="total" />
        <xsl:param name="threshold" />
        <xsl:param name="scale" />
        <xsl:variable name="nocoverage" select="$total = 0 and $notVisited = 0" />
        <xsl:variable name="visited" select="$total - $notVisited" />
        <xsl:variable name="coverage" select="$visited div $total * 100"/>
        <!--Fix rounding issues in the graph since we can only do whole numbers-->
        <xsl:variable name="right" select="format-number($coverage div 100 * $scale, '0') - 1" />
        <xsl:variable name="left" select="format-number($scale - $right, '0')" />
        <xsl:choose>
            <xsl:when test="$nocoverage">
                &#160;
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$notVisited = 0">
                    <img src="{$baseimagepath}g.png" height="14" width="{format-number($scale, '0')}" />
                </xsl:if>
                <xsl:if test="($visited != 0) and ($notVisited != 0)">
                    <img src="{$baseimagepath}g.png" height="14" width="{$right}" />
                </xsl:if>
                <xsl:if test="$notVisited != 0">
                    <xsl:if test="$coverage &gt;= $threshold">
                        <img src="{$baseimagepath}y.png" height="14" width="{$left}" />
                    </xsl:if>
                    <xsl:if test="$coverage &lt; $threshold">
                        <img src="{$baseimagepath}r.png" height="14" width="{$left}" />
                    </xsl:if>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--Summary for document reports that contain methods-->
    <xsl:template name="cyclomaticComplexitySummaryCommon">
        <xsl:param name="threshold" />
        <xsl:param name="unvisitedTitle" />
        <xsl:param name="coverageTitle" xml:space="preserve">Coverage</xsl:param>
        <xsl:param name="printClasses" />
        <xsl:param name="printMethods" />

        <xsl:for-each select="$root/mod[string(stats/@ex) != '1']">
            <xsl:sort select="stats[last()]/@ccmax" order="descending" data-type ="number" />
            <xsl:variable name="docstats" select="stats[last()]" />
            <xsl:variable name="documentID" select="@id" />
            <!--
            To make a nice clean report we want to see if we actually have a count before we continue.
            -->
            <xsl:variable name="classcount">
                <xsl:choose xml:space="preserve">
                    <xsl:when test="$reportType = 'SymbolCCModuleClassFailedCoverageTop'"><xsl:value-of select="count(ns/class[string(stats/@ex) != '1' and stats/@ccmax > 0 and
                                        (
                                        (stats/@vsp div (stats/@usp + stats/@vsp)) * 100 &lt; stats/@acp
                                        or (stats/@vbp div (stats/@ubp + stats/@vbp)) * 100 &lt; stats/@acp
                                        )
                                        ])"/></xsl:when>
                    <xsl:when test="$reportType = 'MethodCCModuleClassFailedCoverageTop'"><xsl:value-of select="count(ns/class[string(stats/@ex) != '1' and stats/@ccmax > 0 and
                                        (stats/@vm div (stats/@um + stats/@vm)) * 100 &lt; stats/@afp])" /></xsl:when>
                    <xsl:when test="$reportType = 'MethodCCModuleClassCoverageTop'"><xsl:value-of select="count(ns/class[string(stats/@ex) != '1' and stats/@ccmax > 0])" /></xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <!--If we have something to show then show it-->
            <xsl:if test="$classcount > 0">
                <xsl:call-template name="sectionTableHeader">
                    <xsl:with-param name="unvisitedTitle" select="'U.V.'" />
                    <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                    <xsl:with-param name="sectionTitle">Module</xsl:with-param>
                    <xsl:with-param name="cellClass">secondaryTable</xsl:with-param>
                    <xsl:with-param name="showThreshold">True</xsl:with-param>
                </xsl:call-template>

                <xsl:call-template name="coverageDetail">
                    <xsl:with-param name="name" select="assembly" />
                    <xsl:with-param name="stats" select="$docstats" />
                    <xsl:with-param name="showThreshold">True</xsl:with-param>
                </xsl:call-template>
                <tr>
                    <td class="secondaryChildTable ctHeader" colspan="{$tablecolumns}">
                        Classes <xsl:if test="$printMethods = 'True'"> / Methods</xsl:if>
                    </td>
                </tr>
                <xsl:choose>
                    <xsl:when test="$reportType = 'SymbolCCModuleClassFailedCoverageTop'">
                        <!--Grab the first 10 classes where the sp or bp % is less than acceptable-->
                        <xsl:for-each select="ns/class[string(stats/@ex) != '1' and stats/@ccmax > 0 and
                                        (
                                        (stats/@vsp div (stats/@usp + stats/@vsp)) * 100 &lt; stats/@acp
                                        or (stats/@vbp div (stats/@ubp + stats/@vbp)) * 100 &lt; stats/@acp
                                        )
                                        ]">
                            <xsl:sort select="stats[last()]/@ccmax" order="descending" data-type ="number" />
                            <!--Not sure why the position above works so we are going to limit it here-->
                            <xsl:if test="position() &lt;= $ccClassCount">
                                <xsl:call-template name="classCommon">
                                    <xsl:with-param name="printMethods" select="$printMethods" />
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="$reportType = 'MethodCCModuleClassFailedCoverageTop'">
                        <!--Grab the first 10 classes where the sp or bp % is less than acceptable-->
                        <xsl:for-each select="ns/class[string(stats/@ex) != '1' and stats/@ccmax > 0 and
                                        (stats/@vm div (stats/@um + stats/@vm)) * 100 &lt; stats/@afp]">
                            <xsl:sort select="stats[last()]/@ccmax" order="descending" data-type ="number" />
                            <!--Not sure why the position above works so we are going to limit it here-->
                            <xsl:if test="position() &lt;= $ccClassCount">
                                <xsl:call-template name="classCommon">
                                    <xsl:with-param name="printMethods" select="$printMethods" />
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!--Grab the first 10 classes where the sp or bp %-->
                        <xsl:for-each select="ns/class[string(stats/@ex) != '1']">
                            <xsl:sort select="stats[last()]/@ccmax" order="descending" data-type ="number" />
                            <!--Not sure why the position above works so we are going to limit it here-->
                            <xsl:if test="position() &lt;= $ccClassCount and stats[last()]/@ccmax > 0">
                                <xsl:call-template name="classCommon">
                                    <xsl:with-param name="printMethods" select="$printMethods" />
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!--Summary for document reports that contain methods-->
    <xsl:template name="documentSummaryCommon">
        <xsl:param name="threshold" />
        <xsl:param name="unvisitedTitle" />
        <xsl:param name="coverageTitle">Coverage</xsl:param>
        <xsl:param name="printClasses" />
        <xsl:param name="printMethods" />

        <xsl:for-each select="$root/doc[string(stats/@ex) != '1' and string(@id) != '0']">
            <xsl:variable name="docstats" select="stats[last()]" />
            <xsl:variable name="documentID" select="@id" />

            <xsl:call-template name="sectionTableHeader">
                <xsl:with-param name="unvisitedTitle" select="'U.V.'" />
                <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                <xsl:with-param name="sectionTitle">Document</xsl:with-param>
                <xsl:with-param name="cellClass">secondaryTable</xsl:with-param>
                <xsl:with-param name="showThreshold">True</xsl:with-param>
            </xsl:call-template>

            <xsl:call-template name="coverageDetail">
                <xsl:with-param name="name" select="en" />
                <xsl:with-param name="stats" select="$docstats" />
                <xsl:with-param name="showThreshold">True</xsl:with-param>
            </xsl:call-template>
            <tr>
                <td class="secondaryChildTable ctHeader" colspan="{$tablecolumns}">
                    Classes <xsl:if test="$printMethods = 'True'"> / Methods</xsl:if>
                </td>
            </tr>

            <!--For each class that is used for the document [string(stats/@ex) != '1']-->
            <xsl:for-each select="$root/mod/ns/class[string(stats/@ex) != '1']">
                <xsl:variable name="doc" select="stats/doc = $documentID" />
                <xsl:if test="$doc">
                    <xsl:call-template name="classCommon">
                        <xsl:with-param name="printMethods" select="$printMethods" />
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <!-- Common Summary Header information -->
    <xsl:template name="summaryCommon">
        <xsl:param name="threshold" />
        <xsl:param name="unvisitedTitle" />
        <xsl:param name="coverageTitle">Coverage</xsl:param>
        <xsl:param name="printClasses" />
        <xsl:param name="printMethods" />
        <xsl:for-each select="$root/mod[string(stats/@ex) != '1']">
            <!--We want to determine how many items can be shows above a percent-->
            <xsl:variable xml:space="preserve" name="qualifiedmethods"><xsl:call-template name="qualifiednodes" /></xsl:variable>
            <xsl:if test="$qualifiedmethods > 0">
                <xsl:variable name="modstats" select="stats[last()]" />

                <xsl:call-template name="sectionTableHeader">
                    <xsl:with-param name="unvisitedTitle" select="'U.V.'" />
                    <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                    <xsl:with-param name="sectionTitle">Module</xsl:with-param>
                    <xsl:with-param name="cellClass">secondaryTable</xsl:with-param>
                    <xsl:with-param name="showThreshold">True</xsl:with-param>
                </xsl:call-template>

                <xsl:call-template name="coverageDetail">
                    <xsl:with-param name="name" select="assembly" />
                    <xsl:with-param name="stats" select="$modstats" />
                    <xsl:with-param name="showThreshold">True</xsl:with-param>
                </xsl:call-template>
                <tr>
                    <td class="secondaryChildTable ctHeader" colspan="{$tablecolumns}">
                        Namespace <xsl:if test="$printClasses = 'True'"> / Classes</xsl:if>
                    </td>
                </tr>
                <!--print the Namespaces classes and methods-->
                <xsl:call-template name="namespaceClassMethodSummary">
                    <xsl:with-param name="printClasses" select="$printClasses" />
                    <xsl:with-param name="printMethods" select="$printMethods" />
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!--print the Namespaces classes and methods-->
    <xsl:template name="namespaceClassMethodSummary">
        <xsl:param name="printClasses" />
        <xsl:param name="printMethods" />
        <xsl:for-each select="ns[string(stats/@ex) != '1']">
            <xsl:variable name="nsstats" select="stats[last()]" />

            <xsl:choose>
                <xsl:when test="$isDiffReport">
                    <!--Modified to support threshold on the node-->
                    <xsl:call-template name="diffCoverageDetail">
                        <xsl:with-param name="name" select="name" />
                        <xsl:with-param name="stats" select="$nsstats" />
                        <xsl:with-param name="styleTweak">padding-left:20px;font-weight:bold</xsl:with-param>
                        <xsl:with-param name="showThreshold">True</xsl:with-param>
                        <xsl:with-param name="showBottomLine">True</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$isTrendReport">
                    <!--Modified to support threshold on the node-->
                    <xsl:call-template name="trendsCoverageDetail">
                        <xsl:with-param name="name" select="name" />
                        <xsl:with-param name="stats" select="$nsstats" />
                        <xsl:with-param name="styleTweak">padding-left:20px;font-weight:bold</xsl:with-param>
                        <xsl:with-param name="showTrendGraph">True</xsl:with-param>
                        <xsl:with-param name="showThreshold">True</xsl:with-param>
                        <xsl:with-param name="showBottomLine">True</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <!--Modified to support threshold on the node-->
                    <xsl:call-template name="coverageDetail">
                        <xsl:with-param name="name" select="name" />
                        <xsl:with-param name="stats" select="$nsstats" />
                        <xsl:with-param name="styleTweak">padding-left:20px;font-weight:bold</xsl:with-param>
                        <xsl:with-param name="showThreshold">True</xsl:with-param>
                        <xsl:with-param name="showBottomLine">True</xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="$printClasses = 'True'">
                <xsl:for-each select="class[string(stats/@ex) != '1']">
                    <xsl:call-template name="classCommon">
                        <xsl:with-param name="printMethods" select="$printMethods" />
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!--Print the class and method as needed.-->
    <xsl:template name="classCommon">
        <xsl:param name="printMethods" />
        <xsl:variable name="clsstats" select="stats[last()]" />
        <xsl:choose>
            <xsl:when test="$isDiffReport">
                <xsl:call-template name="diffCoverageDetail">
                    <xsl:with-param name="name" select="name" />
                    <xsl:with-param name="stats" select="$clsstats" />
                    <xsl:with-param name="styleTweak">padding-left:30px</xsl:with-param>
                    <xsl:with-param name="scale">
                        <xsl:value-of select ="$graphscale * .8" />
                    </xsl:with-param>
                    <xsl:with-param name="showThreshold">True</xsl:with-param>
                    <xsl:with-param name="showBottomLine">True</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$isTrendReport">
                <xsl:call-template name="trendsCoverageDetail">
                    <xsl:with-param name="name" select="name" />
                    <xsl:with-param name="stats" select="$clsstats" />
                    <xsl:with-param name="styleTweak">padding-left:30px</xsl:with-param>
                    <xsl:with-param name="scale">
                        <xsl:value-of select ="$graphscale * .8" />
                    </xsl:with-param>
                    <xsl:with-param name="showThreshold">True</xsl:with-param>
                    <xsl:with-param name="showBottomLine">True</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="coverageDetail">
                    <xsl:with-param name="name" select="name" />
                    <xsl:with-param name="stats" select="$clsstats" />
                    <xsl:with-param name="styleTweak">padding-left:30px</xsl:with-param>
                    <xsl:with-param name="scale">
                        <xsl:value-of select ="$graphscale * .8" />
                    </xsl:with-param>
                    <xsl:with-param name="showThreshold">True</xsl:with-param>
                    <xsl:with-param name="showBottomLine">True</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>


        <xsl:if test="$printMethods = 'True'">
            <xsl:for-each select="method[string(stats/@ex) != '1']">
                <xsl:call-template name="methodDetails" />
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xsl:template name="methodDetails">
        <xsl:variable name="methstats" select="stats[last()]" />
        <xsl:variable name="countTextDisplay">
            <xsl:choose>
                <xsl:when test="$isFunctionReport">-</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$methstats/@usp"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$isDiffReport">
                <xsl:call-template name="diffCoverageDetail">
                    <xsl:with-param name="name" select="name" />
                    <xsl:with-param name="stats" select="$methstats" />
                    <xsl:with-param name="countText" select="$countTextDisplay" />
                    <xsl:with-param name="styleTweak">padding-left:40px;font-style:italic</xsl:with-param>
                    <xsl:with-param name="scale">
                        <xsl:value-of select ="$graphscale * .7" />
                    </xsl:with-param>
                    <xsl:with-param name="showBottomLine">True</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$isTrendReport">
                <xsl:call-template name="trendsCoverageDetail">
                    <xsl:with-param name="name" select="name" />
                    <xsl:with-param name="stats" select="$methstats" />
                    <xsl:with-param name="countText" select="$countTextDisplay" />
                    <xsl:with-param name="styleTweak">padding-left:40px;font-style:italic</xsl:with-param>
                    <xsl:with-param name="scale">
                        <xsl:value-of select ="$graphscale * .7" />
                    </xsl:with-param>
                    <xsl:with-param name="showBottomLine">True</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="coverageDetail">
                    <xsl:with-param name="name" select="name" />
                    <xsl:with-param name="stats" select="$methstats" />
                    <xsl:with-param name="countText" select="$countTextDisplay" />
                    <xsl:with-param name="styleTweak">padding-left:40px;font-style:italic</xsl:with-param>
                    <xsl:with-param name="scale">
                        <xsl:value-of select ="$graphscale * .7" />
                    </xsl:with-param>
                    <xsl:with-param name="showBottomLine">True</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--Start Diff Templates-->

    <!-- Common Summary Header information -->
    <xsl:template name="diffSummaryCommon">
        <xsl:param name="threshold" />
        <xsl:param name="unvisitedTitle" />
        <xsl:param name="coverageTitle">Coverage</xsl:param>
        <xsl:param name="printClasses" />
        <xsl:param name="printMethods" />

        <xsl:for-each select="$root/mod[string(stats/@ex) != '1']">
            <!--We want to determine how many items can be shows above a percent-->
            <xsl:variable xml:space="preserve" name="qualifiedmethods"><xsl:call-template name="qualifiednodes" /></xsl:variable>
            <xsl:if test="$qualifiedmethods > 0">
                <xsl:variable name="modstats" select="stats[last()]" />

                <xsl:call-template name="diffSectionTableHeader">
                    <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                    <xsl:with-param name="sectionTitle">Module</xsl:with-param>
                    <xsl:with-param name="cellClass">secondaryTable</xsl:with-param>
                    <xsl:with-param name="showThreshold">True</xsl:with-param>
                </xsl:call-template>

                <xsl:call-template name="diffCoverageDetail">
                    <xsl:with-param name="name" select="assembly" />
                    <xsl:with-param name="stats" select="$modstats" />
                    <xsl:with-param name="showThreshold">True</xsl:with-param>
                </xsl:call-template>
                <tr>
                    <td class="secondaryChildTable ctHeader" colspan="{$tablecolumns}">
                        Namespace <xsl:if test="$printClasses = 'True'"> / Classes</xsl:if>
                    </td>
                </tr>
                <!--print the Namespaces classes and methods-->
                <xsl:call-template name="namespaceClassMethodSummary">
                    <xsl:with-param name="printClasses" select="$printClasses" />
                    <xsl:with-param name="printMethods" select="$printMethods" />
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- Project Summary diff report-->
    <xsl:template name="diffProjectSummary">
        <xsl:param name="threshold" />
        <xsl:param name="unvisitedTitle" />
        <xsl:param name="coverageTitle" />
        <!--The Total points or methods-->
        <xsl:variable name="total">
            <xsl:call-template name="gettotal">
                <xsl:with-param name="stats" select="$projectstats" />
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="diffSectionTableHeader">
            <xsl:with-param name="coverageTitle" select="$coverageTitle" />
            <xsl:with-param name="sectionTitle">Project</xsl:with-param>
            <xsl:with-param name="cellClass">projectTable</xsl:with-param>
            <xsl:with-param name="showThreshold">True</xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="diffCoverageDetail">
            <xsl:with-param name="name">
                <xsl:choose>
                    <xsl:when test="string-length($reportName) > 0">
                        <xsl:value-of select="$reportName" />
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="stats" select="$projectstats" />
            <xsl:with-param name="showThreshold">True</xsl:with-param>
            <xsl:with-param name="showBottomLine">True</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!--Build the header for each of the sections.
    It removes the complexity of building the multi table headers for the project and then the modules-->
    <xsl:template name="diffSectionTableHeader">
        <xsl:param name="coverageTitle" />
        <xsl:param name="sectionTitle" />
        <xsl:param name="cellClass" />
        <xsl:param name="showThreshold" />

        <!--We want to determine how many items can be shows above a percent-->
        <xsl:variable xml:space="preserve" name="qualifiedmethods"><xsl:call-template name="qualifiednodes" /></xsl:variable>
        <xsl:if test="$qualifiedmethods > 0">
            <!--white space-->
            <tr>
                <td colspan="{$tablecolumns}">&#160;</td>
            </tr>

            <!--Top row showing SP and BP Data-->
            <tr>
                <td class="{$cellClass} mtHdLeftTop">&#160;</td>
                <td class="{$cellClass} mtHdRightTop" colspan="3">
                    Sequence Points %
                </td>
                <xsl:if test="$reportBranchPoints">
                    <td class="{$cellClass} mtHdRightTop" colspan="3">
                        Branch Points %
                    </td>
                </xsl:if>
                <td class="{$cellClass} mtHdRightTop" colspan="3">
                    Line Visits %
                </td>
                <td class="{$cellClass} mtHdRightTop" colspan="3">
                    Method Visits %
                </td>
                <xsl:if test="$reportCC">
                    <td class="{$cellClass} mtHdRightTop" colspan="3">
                        C.C.
                    </td>
                </xsl:if>
            </tr>


            <tr>
                <td class="{$cellClass} mtHdLeft">
                    <xsl:value-of select="$sectionTitle" disable-output-escaping="yes" />
                </td>
                <td class="{$cellClass} mtHd">Was</td>
                <td class="{$cellClass} mtHd">Now</td>
                <td class="{$cellClass} mtHd">Diff</td>


                <xsl:if test="$reportBranchPoints">
                    <td class="{$cellClass} mtHd">Was</td>
                    <td class="{$cellClass} mtHd">Now</td>
                    <td class="{$cellClass} mtHd">Diff</td>
                </xsl:if>

                <td class="{$cellClass} mtHd">Was</td>
                <td class="{$cellClass} mtHd">Now</td>
                <td class="{$cellClass} mtHd">Diff</td>

                <td class="{$cellClass} mtHd">Was</td>
                <td class="{$cellClass} mtHd">Now</td>
                <td class="{$cellClass} mtHd">Diff</td>

                <xsl:if test="$reportCC">
                    <td class="{$cellClass} mtHd">Was</td>
                    <td class="{$cellClass} mtHd">Now</td>
                    <td class="{$cellClass} mtHd">Diff</td>
                </xsl:if>
            </tr>
        </xsl:if>
    </xsl:template>

    <xsl:template name="diffCoverageDetail">
        <xsl:param name="name" />
        <xsl:param name="stats" />
        <xsl:param name="showThreshold" />
        <xsl:param name="showBottomLine" />
        <!--By default this needs to be unvisited count-->
        <xsl:param name="countText">
            <xsl:call-template name="unvisiteditems">
                <xsl:with-param name="stats" select="$stats" />
            </xsl:call-template>
        </xsl:param>
        <xsl:param name="styleTweak" />
        <xsl:param name="scale" select="$graphscale" />

        <xsl:variable name="totalsymbol" select="$stats/@vsp + $stats/@usp" />
        <xsl:variable name="totalsymbol-diff" select="$stats/@dvsp + $stats/@dusp" />
        <xsl:variable name="totalbranch" select="$stats/@vbp + $stats/@ubp" />
        <xsl:variable name="totalbranch-diff" select="$stats/@dvbp + $stats/@dubp" />
        <xsl:variable name="totalline" select="$stats/@vl + $stats/@ul" />
        <xsl:variable name="totalline-diff" select="$stats/@dvl + $stats/@dul" />
        <xsl:variable name="totalmethod" select="$stats/@vm + $stats/@um" />
        <xsl:variable name="totalmethod-diff" select="$stats/@dvm + $stats/@dum" />

        <xsl:variable name="coveragesymbol">
            <xsl:choose>
                <xsl:when test="$totalsymbol = 0">-</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="($stats/@vsp div $totalsymbol) * 100" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="coveragesymbol-diff">
            <xsl:choose>
                <xsl:when test="$totalsymbol-diff = 0">-</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="($stats/@dvsp div $totalsymbol-diff) * 100" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="coveragebranch">
            <xsl:choose>
                <xsl:when test="$totalbranch = 0">-</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="($stats/@vbp div $totalbranch) * 100" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="coveragebranch-diff">
            <xsl:choose>
                <xsl:when test="$totalbranch-diff = 0">-</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="($stats/@dvbp div $totalbranch-diff) * 100" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="coverageline">
            <xsl:choose>
                <xsl:when test="$totalline = 0">-</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="($stats/@vl div $totalline) * 100" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="coverageline-diff">
            <xsl:choose>
                <xsl:when test="$totalline-diff = 0">-</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="($stats/@dvl div $totalline-diff) * 100" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="coveragemethod">
            <xsl:choose>
                <xsl:when test="$totalmethod = 0">-</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="($stats/@vm div $totalmethod) * 100" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="coveragemethod-diff">
            <xsl:choose>
                <xsl:when test="$totalmethod-diff = 0">-</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="($stats/@dvm div $totalmethod-diff) * 100" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!--We want to determine how many items can be shows above a percent-->
        <xsl:variable xml:space="preserve" name="qualifiedmethods"><xsl:call-template name="qualifiednodes" /></xsl:variable>
        <xsl:if test="$qualifiedmethods > 0">
            <tr>
                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mtcItem</xsl:attribute>
                    <xsl:if test="$styleTweak != ''" xml:space="preserve"><xsl:attribute name="style"><xsl:value-of select="$styleTweak"/></xsl:attribute></xsl:if>
                    <div class="mtDiv">
                        <xsl:value-of select="$name" />
                    </div>
                </td>

                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                    <xsl:call-template name="printcoverage">
                        <xsl:with-param name="coverage" select="$coveragesymbol-diff"></xsl:with-param>
                        <xsl:with-param name="nopercent" select="'1'"/>
                    </xsl:call-template>
                </td>

                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                    <xsl:call-template name="printcoverage">
                        <xsl:with-param name="coverage" select="$coveragesymbol"></xsl:with-param>
                        <xsl:with-param name="nopercent" select="'1'"/>
                    </xsl:call-template>
                </td>

                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR1 <xsl:choose><xsl:when test="$coveragesymbol - $coveragesymbol-diff &lt; 0"> dn</xsl:when><xsl:when test="$coveragesymbol - $coveragesymbol-diff &gt; 0"> up</xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:call-template name="printcoverage">
                        <xsl:with-param name="coverage" select="$coveragesymbol - $coveragesymbol-diff"></xsl:with-param>
                        <xsl:with-param name="nopercent" select="'1'"/>
                    </xsl:call-template>
                </td>

                <!--This section can be hard coded to branch points since that is all that it does.-->
                <xsl:if test="$reportBranchPoints">
                    <td>
                        <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                        <xsl:call-template name="printcoverage">
                            <xsl:with-param name="coverage" select="$coveragebranch-diff"></xsl:with-param>
                            <xsl:with-param name="nopercent" select="'1'"/>
                        </xsl:call-template>
                    </td>

                    <td>
                        <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                        <xsl:call-template name="printcoverage">
                            <xsl:with-param name="coverage" select="$coveragebranch"></xsl:with-param>
                            <xsl:with-param name="nopercent" select="'1'"/>
                        </xsl:call-template>
                    </td>

                    <td>
                        <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR1 <xsl:choose><xsl:when test="$coveragebranch - $coveragebranch-diff &lt; 0"> dn</xsl:when><xsl:when test="$coveragebranch - $coveragebranch-diff &gt; 0"> up</xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:call-template name="printcoverage">
                            <xsl:with-param name="coverage" select=" $coveragebranch - $coveragebranch-diff"></xsl:with-param>
                            <xsl:with-param name="nopercent" select="'1'"/>
                        </xsl:call-template>
                    </td>
                </xsl:if>

                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                    <xsl:call-template name="printcoverage">
                        <xsl:with-param name="coverage" select="$coverageline-diff"></xsl:with-param>
                        <xsl:with-param name="nopercent" select="'1'"/>
                    </xsl:call-template>
                </td>

                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                    <xsl:call-template name="printcoverage">
                        <xsl:with-param name="coverage" select="$coverageline"></xsl:with-param>
                        <xsl:with-param name="nopercent" select="'1'"/>
                    </xsl:call-template>
                </td>

                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR1 <xsl:choose><xsl:when test="$coverageline - $coverageline-diff &lt; 0"> dn</xsl:when><xsl:when test="$coverageline - $coverageline-diff &gt; 0"> up</xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:call-template name="printcoverage">
                        <xsl:with-param name="coverage" select="$coverageline - $coverageline-diff"></xsl:with-param>
                        <xsl:with-param name="nopercent" select="'1'"/>
                    </xsl:call-template>
                </td>


                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                    <xsl:call-template name="printcoverage">
                        <xsl:with-param name="coverage" select="$coveragemethod-diff"></xsl:with-param>
                        <xsl:with-param name="nopercent" select="'1'"/>
                    </xsl:call-template>
                </td>

                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                    <xsl:call-template name="printcoverage">
                        <xsl:with-param name="coverage" select="$coveragemethod"></xsl:with-param>
                        <xsl:with-param name="nopercent" select="'1'"/>
                    </xsl:call-template>
                </td>

                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR1 <xsl:choose><xsl:when test="$coveragemethod - $coveragemethod-diff &lt; 0"> dn</xsl:when><xsl:when test="$coveragemethod - $coveragemethod-diff &gt; 0"> up</xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:call-template name="printcoverage">
                        <xsl:with-param name="coverage" select="$coveragemethod - $coveragemethod-diff"></xsl:with-param>
                        <xsl:with-param name="nopercent" select="'1'"/>
                    </xsl:call-template>
                </td>

                <xsl:if test="$reportCC">
                    <td>
                        <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$stats/@diffdata = 1">
                                <xsl:value-of select="format-number($stats/@dccavg,'#0.0')" /> / <xsl:value-of select="$stats/@dccmax" />
                            </xsl:when>
                            <xsl:otherwise>
                                -
                            </xsl:otherwise>
                        </xsl:choose>

                    </td>

                    <td>
                        <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                        <xsl:value-of select="format-number($stats/@ccavg,'#0.0')" /> / <xsl:value-of select="$stats/@ccmax" />
                    </td>


                    <td>
                        <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR <xsl:choose><xsl:when test="$stats/@ccmax - $stats/@dccmax &lt; 0"> dn</xsl:when><xsl:when test="$stats/@ccmax - $stats/@dccmax &gt; 0"> up</xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$stats/@diffdata = 1">
                                <xsl:value-of select="format-number($stats/@ccavg - $stats/@dccavg,'#0.0')" /> / <xsl:value-of select="$stats/@ccmax - $stats/@dccmax" />
                            </xsl:when>
                            <xsl:otherwise>
                                -
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>

                </xsl:if>
            </tr>
        </xsl:if>
    </xsl:template>

    <!--End Diff Templates-->

    <!--Begin Trends Templates-->
    <!--summaryCommon-->
    <xsl:template name="trendsSummaryCommon">
        <xsl:param name="threshold" />
        <xsl:param name="unvisitedTitle" />
        <xsl:param name="coverageTitle">Coverage</xsl:param>
        <xsl:param name="printClasses" />
        <xsl:param name="printMethods" />
        <!--Don't show anything if the data does not exist.-->
        <xsl:if test="$trendsdataexist">
            <xsl:for-each select="$root/mod[string(stats/@ex) != '1']">
                <!--We want to determine how many items can be shows above a percent-->
                <xsl:variable xml:space="preserve" name="qualifiedmethods"><xsl:call-template name="qualifiednodes" /></xsl:variable>
                <xsl:if test="$qualifiedmethods > 0">
                    <xsl:variable name="modstats" select="stats[last()]" />

                    <xsl:call-template name="trendsSectionTableHeader">
                        <xsl:with-param name="unvisitedTitle" select="'U.V.'" />
                        <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                        <xsl:with-param name="sectionTitle">Module</xsl:with-param>
                        <xsl:with-param name="cellClass">secondaryTable</xsl:with-param>
                        <xsl:with-param name="showThreshold">True</xsl:with-param>
                    </xsl:call-template>

                    <xsl:call-template name="trendsCoverageDetail">
                        <xsl:with-param name="name" select="assembly" />
                        <xsl:with-param name="stats" select="$modstats" />
                        <xsl:with-param name="showTrendGraph">True</xsl:with-param>
                        <xsl:with-param name="showThreshold">True</xsl:with-param>
                    </xsl:call-template>
                    <tr>
                        <td class="secondaryChildTable ctHeader" valign="bottom">
                            <xsl:attribute name="colspan" xml:space="preserve"><xsl:choose><xsl:when test="$threshold = 'True'"><xsl:value-of select="$tablecolumns"/></xsl:when><xsl:otherwise><xsl:value-of select="$tablecolumns"/></xsl:otherwise></xsl:choose></xsl:attribute>
                            Namespace <xsl:if test="$printClasses = 'True'"> / Classes</xsl:if>
                        </td>
                    </tr>
                    <!--print the Namespaces classes and methods-->
                    <xsl:call-template name="namespaceClassMethodSummary">
                        <xsl:with-param name="printClasses" select="$printClasses" />
                        <xsl:with-param name="printMethods" select="$printMethods" />
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xsl:template name="trendTDAttributes">
        <xsl:param name="stats" />
        <xsl:param name="threshold" />
        <xsl:attribute name="colspan" xml:space="preserve"><xsl:choose><xsl:when test="$threshold = 'True'">6</xsl:when><xsl:otherwise>5</xsl:otherwise></xsl:choose></xsl:attribute>
        <xsl:attribute xml:space="preserve" name="data"><xsl:for-each select="$stats/tp"><xsl:value-of select="format-number(@v,'#0')"/><xsl:if test="position() != last()">,</xsl:if></xsl:for-each></xsl:attribute>
        <xsl:attribute xml:space="preserve" name="min"><xsl:call-template name="trendThreshold"><xsl:with-param name="stats" select="$stats" /></xsl:call-template></xsl:attribute>
        Enable Javascript for Trend Graph (see IE Warning on top of browser)
    </xsl:template>

    <!-- projectSummary -->
    <xsl:template name="trendsProjectSummary">
        <xsl:param name="threshold" />
        <xsl:param name="unvisitedTitle" />
        <xsl:param name="coverageTitle" />
        <!--The Total points or methods-->
        <xsl:variable name="total">
            <xsl:call-template name="gettotal">
                <xsl:with-param name="stats" select="$projectstats" />
            </xsl:call-template>
        </xsl:variable>

        <!--Don't show anything if the data does not exist.-->
        <xsl:if test="$trendsdataexist">
            <xsl:call-template name="trendsSectionTableHeader">
                <xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
                <xsl:with-param name="coverageTitle" select="$coverageTitle" />
                <xsl:with-param name="sectionTitle">Project</xsl:with-param>
                <xsl:with-param name="cellClass">projectTable</xsl:with-param>
                <xsl:with-param name="showThreshold">True</xsl:with-param>
            </xsl:call-template>

            <xsl:call-template name="trendsCoverageDetail">
                <xsl:with-param name="name">
                    <xsl:choose>
                        <xsl:when test="string-length($reportName) > 0">
                            <xsl:value-of select="$reportName" />
                        </xsl:when>
                        <xsl:otherwise>&#160;</xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="stats" select="$projectstats" />
                <xsl:with-param name="showTrendGraph">True</xsl:with-param>
                <xsl:with-param name="showThreshold">True</xsl:with-param>
                <xsl:with-param name="showBottomLine">True</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


    <!-- sectionTableHeader -->
    <!--Build the header for each of the sections.
    It removes the complexity of building the multi table headers for the project and then the modules-->
    <xsl:template name="trendsSectionTableHeader">
        <xsl:param name="unvisitedTitle" />
        <xsl:param name="coverageTitle" />
        <xsl:param name="sectionTitle" />
        <xsl:param name="cellClass" />
        <xsl:param name="showThreshold" />

        <!--We want to determine how many items can be shows above a percent-->
        <xsl:variable xml:space="preserve" name="qualifiedmethods"><xsl:call-template name="qualifiednodes" /></xsl:variable>
        <xsl:if test="$qualifiedmethods > 0">
            <!--white space-->
            <tr>
                <td colspan="{$tablecolumns}">&#160;</td>
            </tr>

            <tr>
                <td class="{$cellClass} mtHdLeftTop">&#160;</td>
                <td class="{$cellClass} mtHdRightTop">
                    <xsl:attribute name="colspan" xml:space="preserve"><xsl:choose><xsl:when test="$showThreshold = 'True'">5</xsl:when><xsl:otherwise>4</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$trendCoverageMetric = 'SequencePoints' or $trendCoverageMetric = 'SymbolCoverage'">Symbol Coverage</xsl:when>
                        <xsl:when test="$trendCoverageMetric = 'BranchPoints' or $trendCoverageMetric = 'BranchCoverage'">Branch Coverage</xsl:when>
                        <xsl:when test="$trendCoverageMetric = 'MethodCoverage'">Method Coverage</xsl:when>
                        <xsl:when test="$trendCoverageMetric = 'LineCoverage'">Line Coverage</xsl:when>
                        <xsl:when test="$trendCoverageMetric = 'CyclomaticComplexity'">Cyclomatic Complexity Coverage</xsl:when>
                        <xsl:otherwise>Unknown Coverage</xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>

            <tr>
                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:value-of select="$cellClass" /><xsl:choose><xsl:when test="$isFunctionReport"> mtHdLeftFunc</xsl:when><xsl:otherwise> mtHdLeft</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:value-of select="$sectionTitle" disable-output-escaping="yes" />
                </td>
                <xsl:if test="$showThreshold = 'True'">
                    <td class="{$cellClass} mtHd">Accept</td>
                </xsl:if>
                <td class="{$cellClass} mtHd">
                    Min %
                </td>
                <td class="{$cellClass} mtHd">
                    Max %
                </td>
                <td class="{$cellClass} mtHd">
                    Cov %
                </td>
                <td class="{$cellClass} mtHd">
                    Trend
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <!-- coverageDetail -->
    <!-- Coverage detail row in main grid displaying a name, statistics and graph bar -->
    <xsl:template name="trendsCoverageDetail">
        <xsl:param name="name" />
        <xsl:param name="stats" />
        <xsl:param name="showTrendGraph" />
        <xsl:param name="showThreshold" />
        <xsl:param name="showBottomLine" />
        <!--By default this needs to be unvisited count-->
        <xsl:param name="countText">
            <xsl:call-template name="unvisiteditems">
                <xsl:with-param name="stats" select="$stats" />
            </xsl:call-template>
        </xsl:param>
        <xsl:param name="styleTweak" />
        <xsl:param name="scale" select="$graphscale" />
        <xsl:variable name="total">
            <xsl:choose xml:space="preserve">
                <xsl:when test="$trendCoverageMetric = 'SequencePoints' or $trendCoverageMetric = 'SymbolCoverage'"><xsl:value-of select="$stats/@usp + $stats/@vsp" /></xsl:when>
                <xsl:when test="$trendCoverageMetric = 'BranchPoints' or $trendCoverageMetric = 'BranchCoverage'"><xsl:value-of select="$stats/@ubp + $stats/@vbp" /></xsl:when>
                <xsl:when test="$trendCoverageMetric = 'MethodCoverage'"><xsl:value-of select="$stats/@um + $stats/@vm" /></xsl:when>
                <xsl:when test="$trendCoverageMetric = 'LineCoverage'"><xsl:value-of select="$stats/@ul + $stats/@vl" /></xsl:when>
                <xsl:when test="$trendCoverageMetric = 'CyclomaticComplexity'"><xsl:value-of select="$stats/@ccmax" /></xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="coverage">
            <xsl:choose xml:space="preserve">
                <xsl:when test="$total = 0">-</xsl:when>
                <xsl:when test="$trendCoverageMetric = 'SequencePoints' or $trendCoverageMetric = 'SymbolCoverage'"><xsl:value-of select="($stats/@vsp div $total) * 100" /></xsl:when>
                <xsl:when test="$trendCoverageMetric = 'BranchPoints' or $trendCoverageMetric = 'BranchCoverage'"><xsl:value-of select="($stats/@vbp div $total) * 100" /></xsl:when>
                <xsl:when test="$trendCoverageMetric = 'MethodCoverage'"><xsl:value-of select="($stats/@vm div $total) * 100" /></xsl:when>
                <xsl:when test="$trendCoverageMetric = 'LineCoverage'"><xsl:value-of select="($stats/@vl div $total) * 100" /></xsl:when>
                <xsl:when test="$trendCoverageMetric = 'CyclomaticComplexity'">-</xsl:when>
                <xsl:otherwise>-</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="threshold">
            <xsl:call-template name="trendThreshold">
                <xsl:with-param name="stats" select="$stats" />
            </xsl:call-template>
        </xsl:variable>
        <!--We need to set the class for the coverage-->
        <xsl:variable name="coverageclass" xml:space="preserve"><xsl:choose><xsl:when test="$coverage = '-' or threshold = '-'"></xsl:when><xsl:when test="$coverage &gt;= $threshold">up</xsl:when><xsl:when test="$coverage &lt; $threshold">dn</xsl:when></xsl:choose></xsl:variable>
        <xsl:variable name="min" xml:space="preserve"><xsl:call-template name="min"><xsl:with-param name="pSeq" select="$stats/tp[@v > -1]/@v"></xsl:with-param></xsl:call-template></xsl:variable>
        <xsl:variable name="max" xml:space="preserve"><xsl:call-template name="max"><xsl:with-param name="pSeq" select="$stats/tp/@v"></xsl:with-param></xsl:call-template></xsl:variable>
        <xsl:variable name="firsttrend" xml:space="preserve"><xsl:choose><xsl:when test="$stats/tp[position() = 1]/@v = -1">0</xsl:when><xsl:otherwise><xsl:value-of select="$stats/tp[position() = 1]/@v"/></xsl:otherwise></xsl:choose></xsl:variable>
        <xsl:variable name="lasttrend" xml:space="preserve"><xsl:choose><xsl:when test="$stats/tp[position() = last()]/@v = -1">0</xsl:when><xsl:otherwise><xsl:value-of select="$stats/tp[position() = last()]/@v"/></xsl:otherwise></xsl:choose></xsl:variable>
        <xsl:variable name="fulltrendamount" xml:space="preserve"><xsl:value-of select="$lasttrend - $firsttrend"/></xsl:variable>
        <xsl:variable name="fulltrendclass" xml:space="preserve"><xsl:choose><xsl:when test="$fulltrendamount &gt; 0">up</xsl:when><xsl:when test="$fulltrendamount &lt; 0">dn</xsl:when></xsl:choose></xsl:variable>

        <!--We want to determine how many items can be shows above a percent-->
        <xsl:variable xml:space="preserve" name="qualifiedmethods"><xsl:call-template name="qualifiednodes" /></xsl:variable>
        <xsl:if test="$qualifiedmethods > 0">
            <tr>
                <xsl:choose>
                    <xsl:when test="$showThreshold='True'">
                        <td>
                            <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mtcItem</xsl:attribute>
                            <xsl:attribute name="style">padding-right:0px;<xsl:value-of select="$styleTweak"/></xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="$showTrendGraph='True'">
                                    <table width="100%" padding="0" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <div class="trendTitle">
                                                    <xsl:value-of select="$name" />
                                                </div>
                                            </td>
                                            <td align="right">
                                                <div class="trGr" style="width:200px;border: 1px solid black;">
                                                    <xsl:call-template name="trendTDAttributes">
                                                        <xsl:with-param name="stats" select="./stats" />
                                                        <xsl:with-param name="threshold" select="$showThreshold" />
                                                    </xsl:call-template>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </xsl:when>
                                <xsl:otherwise>
                                    <div class="mtDiv">
                                        <xsl:value-of select="$name" />
                                    </div>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td>
                            <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                            <xsl:value-of select="concat(format-number($threshold,'#0.0'), ' %')" />
                        </td>
                    </xsl:when>
                    <xsl:otherwise>
                        <td colspan="2">
                            <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mtcItem</xsl:attribute>
                            <xsl:if test="$styleTweak != ''" xml:space="preserve"><xsl:attribute name="style"><xsl:value-of select="$styleTweak"/></xsl:attribute></xsl:if>
                            <div class="mtDiv">
                                <xsl:value-of select="$name" />
                            </div>
                        </td>
                    </xsl:otherwise>
                </xsl:choose>
                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="string($min) = ''">-</xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="format-number($min,'#0.0')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mR</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="string($max) = ''">-</xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="format-number($max,'#0.0')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if> mR <xsl:value-of select="$coverageclass"/></xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="string($coverage) = 'NaN' or $coverage = '-'">
                            -
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="format-number($coverage,'#0.0')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
                <td>
                    <xsl:attribute xml:space="preserve" name="class"><xsl:if test="$showBottomLine = 'True'">mb </xsl:if>mPt mR <xsl:value-of select="$fulltrendclass"/></xsl:attribute>
                    <!--<xsl:attribute xml:space="preserve" name="data"><xsl:if test="name(.) != 'class' and name(.) != 'method'"><xsl:for-each select="./stats/tp"><xsl:value-of select="format-number(@v,'#0')"/><xsl:if test="position() != last()">,</xsl:if></xsl:for-each></xsl:if></xsl:attribute>-->
                    <xsl:value-of select="format-number($fulltrendamount,'#0.0')"/>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <xsl:template name="trendThreshold">
        <xsl:param name="stats" />
        <xsl:choose xml:space="preserve">
            <xsl:when test="$trendCoverageMetric = 'SequencePoints' or $trendCoverageMetric = 'SymbolCoverage'"><xsl:value-of select="$stats/@acp" /></xsl:when>
            <xsl:when test="$trendCoverageMetric = 'BranchPoints' or $trendCoverageMetric = 'BranchCoverage'"><xsl:value-of select="$stats/@abp" /></xsl:when>
            <xsl:when test="$trendCoverageMetric = 'MethodCoverage'"><xsl:value-of select="$stats/@afp" /></xsl:when>
            <xsl:when test="$trendCoverageMetric = 'LineCoverage'">-</xsl:when>
            <xsl:when test="$trendCoverageMetric = 'CyclomaticComplexity'"><xsl:value-of select="$stats/@acc" /></xsl:when>
        <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--End Trends Templates-->

    <xsl:template name="min">
        <xsl:param name="pSeq"/>
        <xsl:variable name="vLen" select="count($pSeq)"/>
        <xsl:if test="$vLen > 0">
            <xsl:choose>
                <xsl:when test="$vLen = 1">
                    <xsl:value-of select="$pSeq[1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="vHalf" select="floor($vLen div 2)"/>
                    <xsl:variable name="v1">
                        <xsl:call-template name="min">
                            <xsl:with-param name="pSeq" select="$pSeq[not(position() > $vHalf)]"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="v2">
                        <xsl:call-template name="min">
                            <xsl:with-param name="pSeq" select="$pSeq[position() > $vHalf]"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$v1 &lt;= $v2">
                            <xsl:value-of select="$v1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$v2"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="max">
        <xsl:param name="pSeq"/>
        <xsl:variable name="vLen" select="count($pSeq)"/>
        <xsl:if test="$vLen > 0">
            <xsl:choose>
                <xsl:when test="$vLen = 1">
                    <xsl:value-of select="$pSeq[1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="vHalf" select="floor($vLen div 2)"/>
                    <xsl:variable name="v1">
                        <xsl:call-template name="max">
                            <xsl:with-param name="pSeq" select="$pSeq[not(position() > $vHalf)]"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="v2">
                        <xsl:call-template name="max">
                            <xsl:with-param name="pSeq" select="$pSeq[position() > $vHalf]"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$v1 >= $v2">
                            <xsl:value-of select="$v1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$v2"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="printcoverage">
        <xsl:param name="coverage" />
        <xsl:param name="twoplaces" select="'0'" />
        <xsl:param name="nopercent" select="'0'" />
        <xsl:choose>
            <xsl:when test="$coverage = 'N/A'">
                <xsl:value-of select="$coverage" />
            </xsl:when>
            <xsl:when test="string($coverage) = '-'">
                -
            </xsl:when>
            <xsl:when test="string($coverage) = 'NaN'">
                -
            </xsl:when>
            <xsl:when test="string($twoplaces) = '1'">
                <xsl:choose>
                    <xsl:when test="$nopercent = '1'">
                        <xsl:value-of select="format-number($coverage,'#0.00')" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(format-number($coverage,'#0.00'), ' %')" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$nopercent = '1'">
                        <xsl:value-of select="format-number($coverage,'#0.0')" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(format-number($coverage,'#0.0'), ' %')" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--Get the total items based on the report-->
    <xsl:template name="gettotal">
        <xsl:param name="stats" />
        <xsl:param name="branch" />
        <xsl:choose>
            <xsl:when test="$isFunctionReport">
                <xsl:value-of select="$stats/@um + $stats/@vm" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$branch = 'True'">
                        <xsl:value-of select="$stats/@ubp + $stats/@vbp" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$stats/@usp + $stats/@vsp" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--Get the total visited items based on the report-->
    <xsl:template name="visiteditems">
        <xsl:param name="stats" />
        <xsl:choose>
            <xsl:when test="$isFunctionReport">
                <xsl:value-of select="$stats/@vm" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$stats/@vsp" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--Get the total visited items based on the report-->
    <xsl:template name="unvisiteditems">
        <xsl:param name="stats" />
        <xsl:choose>
            <xsl:when test="$isFunctionReport">
                <xsl:value-of select="$stats/@um" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$stats/@usp" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--How many nodes qualify-->
    <xsl:template name="qualifiednodes" xml:space="preserve"><xsl:choose>
        <!--If show all item exist, then we need to just return 1-->
        <xsl:when test="$isDiffReport"><xsl:choose>
            <xsl:when test="$showAllItems">1</xsl:when>
            <!--One of the items must be at least this diff amount-->
            <xsl:when test="$diffAtLeast &lt; 0"><xsl:value-of select="count(.//stats[
                                                            @diffexists='1'
                                                            and
                                                            (
                                                                (@vsp div (@vsp + @usp)) - (@dvsp div (@dvsp + @dusp)) &lt;= $diffAtLeast div 100
                                                            or
                                                                (@vbp div (@vbp + @ubp)) - (@dvbp div (@dvbp + @dubp)) &lt;= $diffAtLeast div 100
                                                            or
                                                                (@vl div (@vl + @ul)) - (@dvl div (@dvl + @dul)) &lt;= $diffAtLeast div 100
                                                            or
                                                                (@vm div (@vm + @um)) - (@dvm div (@dvm + @dum)) &lt;= $diffAtLeast div 100
                                                            or
                                                                (@ccmax - @dccmax) &lt;= $diffAtLeast
                                                            )
                                                            ])" /></xsl:when>
            <xsl:when test="$diffAtLeast &gt; 0"><xsl:value-of select="count(.//stats[
                                                            @diffexists='1'
                                                            and
                                                            (
                                                                (@vsp div (@vsp + @usp)) - (@dvsp div (@dvsp + @dusp)) &gt;= $diffAtLeast div 100
                                                            or
                                                                (@vbp div (@vbp + @ubp)) - (@dvbp div (@dvbp + @dubp)) &gt;= $diffAtLeast div 100
                                                            or
                                                                (@vl div (@vl + @ul)) - (@dvl div (@dvl + @dul)) &gt;= $diffAtLeast div 100
                                                            or
                                                                (@vm div (@vm + @um)) - (@dvm div (@dvm + @dum)) &gt;= $diffAtLeast div 100
                                                            or
                                                                (@ccmax - @dccmax) &gt;= $diffAtLeast
                                                            )
                                                            ])" /></xsl:when>
           <xsl:otherwise><xsl:value-of select="count(.//stats[@diffexists='1'])" /></xsl:otherwise>
        </xsl:choose></xsl:when>
        <xsl:when test="$isTrendReport">1</xsl:when>
        <xsl:when test="string($atleastpercenttype) = 'branch'"><xsl:choose>
            <xsl:when test="name(.) = 'method'"><xsl:value-of select="count(stats[(@vbp div (@ubp + @vbp)) >= $atleastpercent and (@vbp div (@ubp + @vbp)) &lt;= $atmostpercent])" /></xsl:when>
            <!--if rdf is used we have no way to show the data.-->
            <xsl:when test="count(.//method) = 0">1</xsl:when>
            <xsl:otherwise><xsl:value-of select="count(.//method/stats[(@vbp div (@ubp + @vbp)) >= $atleastpercent and (@vbp div (@ubp + @vbp)) &lt;= $atmostpercent])" /></xsl:otherwise>
        </xsl:choose></xsl:when>
        <xsl:otherwise><xsl:choose>
           <xsl:when test="name(.) = 'method'"><xsl:value-of select="count(stats[(@vsp div (@usp + @vsp)) >= $atleastpercent and (@vsp div (@usp + @vsp)) &lt;= $atmostpercent])" /></xsl:when>
           <!--if rdf is used we have no way to show the data.-->
           <xsl:when test="count(.//method) = 0">1</xsl:when>
           <xsl:otherwise><xsl:value-of select="count(.//method/stats[(@vsp div (@usp + @vsp)) >= $atleastpercent and (@vsp div (@usp + @vsp)) &lt;= $atmostpercent])" /></xsl:otherwise>
        </xsl:choose></xsl:otherwise>
    </xsl:choose></xsl:template>

    <xsl:template name="style" xml:space="preserve">
        <style>
            <xsl:text disable-output-escaping="yes">
            body                    { font: small verdana, arial, helvetica; color:#000000;    }
            .coverageReportTable    { font-size: 9px; }
            .reportHeader           { padding: 5px 8px 5px 8px; font-size: 12px; border: 1px solid; margin: 0px;    }
            .titleText              { font-weight: bold; font-size: 12px; white-space: nowrap; padding: 0px; margin: 1px; }
            .subtitleText           { font-size: 9px; font-weight: normal; padding: 0px; margin: 1px; white-space: nowrap; }
            .projectStatistics      { font-size: 10px; border-left: #649cc0 1px solid; white-space: nowrap; width: 40%;    }
            .heading                { font-weight: bold; }
            .trendTitle             { font-weight: bold; font-size: 10px;}
            
            .mtHdLeftTop        {
                                border-top: #dcdcdc 1px solid;
                                border-left: #dcdcdc 1px solid;  
                                border-right: #dcdcdc 1px solid; 
                                font-weight: bold;
                                padding-left: 5px;
                                }
            .mtHdRightTop       {
                                border-top: #dcdcdc 1px solid;
                                border-right: #dcdcdc 1px solid; 
                                font-weight: bold;
                                padding-left: 5px;
                                text-align: center;
                                }
            .mtHdLeftFunc { 
                            border: #dcdcdc 1px solid; 
                            font-weight: bold;    
                            padding-left: 5px; 
                          }
            .mtHdLeft     {
                            border-bottom: #dcdcdc 1px solid;
                            border-left: #dcdcdc 1px solid;  
                            border-right: #dcdcdc 1px solid; 
                            font-weight: bold;
                            padding-left: 5px;
                            }
            .mtHd             { border-bottom: 1px solid; border-top: 1px solid; border-right: 1px solid;    text-align: center;    }
            
            .mtHdLeft2         { font-weight: bold;    padding-left: 5px; }
            .mtHd2             { text-align: center;    }
            
            .mtgHd            { border-bottom: 1px solid; border-top: 1px solid; border-right: 1px solid;    text-align: left; font-weight: bold; }
            .mtgHd2         { border-bottom: 1px solid; border-top: 1px solid; border-right: 1px solid;    text-align: center; font-weight: bold; }
            .mtDiv            {width:500px;overflow: hidden;}
            
            .mtcItem             { background: #ffffff; border-left: #dcdcdc 1px solid; border-right: #dcdcdc 1px solid; padding-left: 10px; padding-right: 10px; font-weight: bold; font-size: 10px; }
            .mtcData             { background: #ffffff; border-right: #dcdcdc 1px solid;    text-align: center;    white-space: nowrap; }
            .mR { background: #ffffff; border-right: #dcdcdc 1px solid;    text-align: right;    white-space: nowrap; }
            .mR1 { background: #ffffff; border-right: #999999 1px solid;    text-align: right;    white-space: nowrap; }
            .mPt         { background: #ffffff; font-weight: bold; white-space: nowrap; text-align: right; padding-left: 10px; }
            .tmcGraph         { background: #ffffff; border-right: #dcdcdc 1px solid; padding-right: 5px; }
            .mb        { border-bottom: #dcdcdc 1px solid;    }
            .ctHeader             { border-top: 1px solid; border-bottom: 1px solid; border-left: 1px solid; border-right: 1px solid;    font-weight: bold; padding-left: 10px; }
            .ctciItem { background: #ffffff; border-left: #dcdcdc 1px solid; border-right: #dcdcdc 1px solid; padding-right: 10px; font-size: 10px; }
            .etcItem     { background: #ffffff; border-left: #dcdcdc 1px solid; border-right: #dcdcdc 1px solid; padding-left: 10px; padding-right: 10px; }
            .projectTable                { background: #a9d9f7; border-color: #649cc0; }
            .primaryTable                { background: #d7eefd; border-color: #a4dafc; }
            .secondaryTable             { background: #f9e9b7; border-color: #f6d376; }
            .secondaryChildTable         { background: #fff6df; border-color: #f5e1b1; }
            .exclusionTable                { background: #e1e1e1; border-color: #c0c0c0; }
            .exclusionCell                { background: #f7f7f7; }
            .up                            { color: #008000; }
            .dn                         { color: #c80000; }
            #tooltip {
                position: absolute;
                z-index: 3000;
                border: 1px solid #111;
                background-color: #eee;
                padding: 5px;
                opacity: 0.85;
            }
            #tooltip h3, #tooltip div { margin: 0; }
        </xsl:text>
        </style>
        <xsl:if test="$isTrendReport">
            <script src="{baseimagepath}jquery-1.3.2.min.js" type="text/javascript"></script>
            <script src="{baseimagepath}trends.js" type="text/javascript"></script>
            
            <script type="text/javascript">
            <xsl:text disable-output-escaping="yes" xml:space="preserve">
            <![CDATA[$(function(){

                $('.trGr').each(function(){
                    var t = $(this);
                    t.sparkline(t.attr('data').split(','),
                                        {
                                            minSpotColor : '#000000',
                                            maxSpotColor : '#000000',
                                            marginBottom: '0px',
                                            height:30,
                                            width: '100%', 
                                            lineColor: '#000000',
                                            spotColor:'#0000ff',
                                            barColor:'#ffffff',
                                            fillColor: null,
                                            normalRangeColor: '#00cd00',
                                            normalRangeMin: t.attr('min'),
                                            normalRangeMax: 100,
                                            chartRangeMin: -1,
                                            chartRangeMax: 100
                                        }
                                    );
                            });
            });]]>
            </xsl:text>
            </script>

        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
