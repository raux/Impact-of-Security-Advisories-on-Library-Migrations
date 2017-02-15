## Do Developers Update Their Library Dependencies? An Empirical Study on the Impact of Security Advisories on Library Migration

(Replication Package for Empirical Software Engineering Journal Manuscript)

Third-party library reuse has become common practice in contemporary software development as it includes several benefits for developers.
Library dependencies are constantly evolving, with newly added features and patches to fix bug in older versions.
To take full advantage of third-party reuse, developers should always keep up to date with the latest versions of their library dependencies.
In this paper, we investigate the extent of which developers update their library dependencies.
Therefore, we conducted an empirical study on library migration that covers over 4,600 GitHub software projects and 2,700 library dependencies.
Results show that although many of these systems rely heavily on dependencies, 81.5% of the studied systems still keep their outdated dependencies.
In the case of updating a vulnerable dependency, the study reveals that affected developers are not likely to respond to a security advisory.
Surveying these developers, we find that 69% of the interviewees claimed to be unaware of their vulnerable dependencies.
Furthermore, developers are not likely to prioritize library updates, citing it as extra effort and added responsibility.
This study draws the conclusions that even though third-party reuse is commonplace, the practice of updating a dependency is not as common for many developers.

### Research Tool References

For the experiments, we used Projects from GitHub.

#### Mining Tools:

Our Dependency Extraction Tool for Maven Libraries: [PomWalker](https://github.com/raux/PomWalker)

Java Library to mine and extract Library Migrations
[JGit](http://www.eclipse.org/jgit/)


#### Library Migration Plot (LMP) Tools :

R statistics Tool [R](https://www.r-project.org/)

Notable Packages used [ggplot2](http://ggplot2.org/), [plyr](https://cran.r-project.org/web/packages/plyr/index.html),
[sqldf](https://cran.r-project.org/web/packages/sqldf/),
[gridExtra](https://cran.r-project.org/web/packages/gridExtra/gridExtra.pdf)

#### Datasets

```markdown
1. Raw List of Java Projects (10,851 projects: Before pre-processing quality check)
```
[Download Projects.csv](http://ggplot2.org/)

Column | Description
------------ | -------------
url | GitHub url link of the project respository
authors | # of authors that are part of the project
name | Name of the project repository in GitHub

```markdown
2. Library Migration Dependencies (852,322 Dependency Migrations)
```
###### 2.1. Download and Import LibraryMigrations into R as 'GitHubData'

[Download LibraryMigrations.csv](http://ggplot2.org/)

Column | Description
------------ | -------------
repo | Content from cell 2
repoSys | Content from cell 2
dependsDate | Content from cell 2
initial | Content from cell 2
latest | Content from cell 2
type | Content from cell 2
libSum| Content from cell 2
artifactLib | Content from cell 2

###### 2.2. Download and Load R function to generate an LMP

Load this function into R

> Download LMPCurve.r](http://ggplot2.org/)


###### 2.3. Load required library packages

```R
library(ggplot2)
library(gridExtra)
library(sqldf)
library(plyr)
require(stringr)
```
###### 2.4. Generate LMP Plot

Our function parameters are as follows:

> function(lib1, lib2, lib3, dataSet, projectThreshold, 1Annotate, 2Annotate)

For example, we test for _guava_ versions 16.0.1, 17.0, 18.0 and we only plot projects that are active till 2015-01-01 and we annotate dates "2014-04-01" (release month of 17.0) and "2014-08-01" (release month of 18.0)

```R
lib.getThreeCurve("com.google.guava-guava-16.0.1",
"com.google.guava-guava-17.0",
"com.google.guava-guava-18.0",
"GitHubData",
 as.Date("2015-01-01", "%Y-%m-%d"),
 as.Date("2014-04-01", "%Y-%m-%d"),
 as.Date("2014-08-01", "%Y-%m-%d"))
```
The resulting Plot is shown below:


```markdown
3. Library Migration Plots  (LMP _2,949 LMP LU Metrics Including Latest Versions_)
```
[Download Library Migration Plot Curves](http://ggplot2.org/)

Column | Description
------------ | -------------
Domain_Libname_Version | Content from cell 2
Peak_LU | Content from cell 2
Current_LU | Content from cell 2
Pre_Peak| Content from cell 2
Post_Peak | Content from cell 2
Library_Residue | Content from cell 2

### Support or Contact
