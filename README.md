# acs-constructicon
This repository represents a set of tools for crowd-sourcing generation of secondary measures constructed from the American Community Survey (ACS).

# Motivation for this Project
The motivation for this project is to develop a means to increase the accessibility of constructions of [American Community Survey (ACS)](https://www.census.gov/programs-surveys/acs/) data to both technical and non-technical users. The ACS has been conducted annually since 2005 to obtain information about individuals, housholds, and properties for communities across the United States on topics ranging from basic demographics, to education, employment, income, poverty status, marriage, family structure, transportation, national origin, take-up of public programs, property value, building age and so on.

The [Integrated Public Use Microdata Series (IPUMS)](https://www.ipums.org/) is a project of the Minnesota Population Center which offers an interface that allows users to shop for deidentified individual-level data from the annual ACS data samples. While these microdata sets are useful for skilled data researchers focused on constructing specific measures from data patterns, the most typical ACS resource of interest is the aggregate tables, which represent topic-specific counts, data summaries, and cross-tabs of measures for specified geographies.

Despite the helpfulness of these aggregations, the diversity of information in the ACS and potential topics of interest means that there are literally [hundreds of tables](https://www.socialexplorer.com/data/ACS2014/metadata/?ds=ACS14), each of which containing potentially dozens of pieces of information. For example, table B17020 represents information on "Poverty Status in the Past 12 Months By Age" and has 17 columns representing the count of individuals who had valid poverty status information, and counts of individuals who fell into a particular poverty category (below vs above the poverty line) and age category (under 6, 6-11, 12-17, 18-59, 60-74, 75-84, over 85).

There is a range of means for accessing ACS aggregate data tables:

* The [American FactFinder](http://factfinder.census.gov/faces/nav/jsf/pages/index.xhtml) has ways of easily browsing various Census data sets, including pulling up general summary facts for a specified geography. Its [Advanced Search](http://factfinder.census.gov/faces/nav/jsf/pages/searchresults.xhtml?refresh=t) allows for a click-based interface for selecting geographics, topics, and ordering specific tables of information.
* [DataFerret](http://dataferrett.census.gov/) is an older service similar to the American FactFinder which allows for click-based interactivity to building queries.
* The Census itself has developed an [API](https://www.census.gov/developers/) that would allow for script-based access of its holdings. Two (among likely many) projects that make use of this API include:
  * The [Census Reporter](http://censusreporter.org/) web resource, which has an attractive and interactive interface for searching or browsing for Census data by geographic or topic, [designed by Northwestern University's Knight Lab](http://www.knightfoundation.org/press-room/press-release/six-ventures-bring-data-public-winners-knight-news/). Though intended to allow citizens--notably journalists--easy access to Census data, it also has [an API](https://github.com/censusreporter/census-api) that would allow script-based access to its data.
  * The [`acs` package in R](https://cran.r-project.org/web/packages/acs/index.html) which allows R programmers to use the Census API to generate custom pulls of data.

What is interesting--and surprising--about all of these means of accessing ACS data is that they provide data that still likely needs basic processing to be useful. Users interested in rates of child poverty could use any of the above resources to pull the contents of table B17020 to get the 17 columns representing counts of individuals by poverty and age category, but none will offer a rate of child poverty. Thus, the process of going from an interest in child poverty for a given region will require:
* For non-programmers: many clicks of some user interface to find the topic of child poverty, clicks to download the data set, and operations (likely in a spreadsheet) to calculate the rate;
* For programmers: use (with potential need for up-front learning) of packages or APIs, specification of table and geography of interest to obtain a data table, the likely need to use table metadata to propose meaningful field names (since, for example, the default field names are `B17020_002` for individuals under 6 in poverty), and then the final calculations.

These types of operations are needlessly time consuming, especially since they often must be redone many times for different topics of interest, or to obtain updated numbers when new ACS data are available.

The motivation for this project is recognition of the value in reducing the redundancy of these operations. While there seem to be limitless constructions of interest that can be derived from the ACS aggregate tables--child poverty rate, teen birth rate,  employment rate by education, or by gender, or by age, etc--we believe that a single data user should be able to define that construction in a way that allows all other users to immediately reuse that construction, even if focusing on different years and geographies.

# Users and Use Cases

The ultimate goal of this project is to benefit three classes of users:

## Researchers with programming experience

These users would write programming scripts to pull constructed ACS measures for years, geographies and topics as needed, as an intermediate tool in other programming-based analyses. For example, adjacency of more and less poor neighborhoods could be used as a statistical predictor of the likelihood of crimes such as property theft or mugging.

## Application designers

These users would write programming scripts to source constructed measures for direct representation in web pages. For example, a web designer might generate a map of teen birth rates by census tract, overlaid by health clinics offering prenatal care.

## Non-technical users

These users would make use of an intuitive users interface to get direct access to constructions of interest, likely for direct representation in materials. For example, a non-profit might use a geojson front-end tool to select a geography reflecting their service area (which may likely span multiple census tracts), and select measures and years to aggregate. (See [plenar.io](http://plenar.io/explore/discover) for an example front-end.) For a more specific example, a non-profit providing language assistance to families in a given neighborhood might use this type of application to query the number and percentage of families with children who speak limited English, in the development of a grant application.

# Progression of Development

1. Establish basic proof of concept code for a small number of constructed ACS measures
2. Establish a package that allows programmers to load and use the library of functions to pull these measures. This would promote the use of the package.
3. Draft guides for how programmers could contribute to the project by adding code that the package could use to deliver new measures to users. This would allow for crowd-sourcing expansions of the code.
4. Work with front-end developers--such as those who developed [plenar.io](http://plenar.io/explore/discover) or [crimearound.us](http://crimearound.us/)--develop the necessary adaptations to perform spatial queries tailored to polygon-based data.
  * Note: tools like plenario rely on the fact that the underlying data are represented as pointed, which allows for straightforward aggregation of data when the user defines a polygon. In this case, when a user draws a polygon, points are simply either included or excluded. However, when data is attached to polygons (e.g. census tracts), when a user defined a polygon reflecting their custom-defined region, more handling is necessary which tracts should be included in their query, whether only those that are fully enclosed, those which have any intersection, those whose centroid is enclosed, or if portions of tracts should be included with only partial weight in the calculations. And when tracts are included, aggregation calculations must content with the fact that tract data may require unequal weights, such as a case where one tract has more teens than another, meaning that its teen birth rate should receive higher weight in created a combined average between these two tracts. While these considerations require more complexity, there are clear ways to proceed with sufficient time in working with developers.


