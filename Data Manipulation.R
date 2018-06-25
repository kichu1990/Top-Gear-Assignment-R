#install SQLDf package and
#Select the rows from iris dataset where sepal length > 2.5
#and store that in subiris data frame

install.packages("sqldf")
install.packages("babynames")
install.packages("RSQLite")
library(babynames)
library(RSQLite)
library(sqldf)
View(iris)

#Select the rows from iris dataset where sepal length > 2.5
#and store that in subiris data frame

subiris=sqldf('select * from iris where "Sepal.Length" > 2.5')

#Calculate group wise mean from iris data and perform same using R base 
#counterpart aggregation

sqldf('select avg("Sepal.Length"),avg("Sepal.Width"),  
       avg("Petal.Length"),avg("Petal.Width"),"Species"
       from iris group by Species')

sqldf('select "Species"  from iris where "Species" like "v%" ')


#Create dept dataframe and emp dataframe and perform inner,leftouter,RightOuter 
#and FullOuter Joins using SQLDF

employee = data.frame(
  emp_id = c (1:6), 
  emp_name = c("Rick","Dan","Michelle","Ryan","Gary","Jay"),
  salary = c(623.3,515.2,611.0,729.0,843.25,563.23), 
  location = c("NY", "LG", "SING", "MALYSIA", "THAILAND","GHANA"),
  Dept = c(100,200,300,400,500,900),
  stringsAsFactors = FALSE
)

View(employee)

department = data.frame(
  Dept = c(100,200,300,400,500,600),
  Dept_name = c("IT","HR","Finance","Operations","Governance","Support"),
  stringsAsFactors = FALSE
)

View(emp.dept)

sqldf(
"SELECT 
 employee.emp_id
,employee.emp_name
,employee.salary
,department.Dept
,department.Dept_name 
FROM 
employee
INNER JOIN 
department 
ON 
employee.Dept = department.Dept")


sqldf(
  "SELECT 
 employee.emp_id
,employee.emp_name
,employee.salary
,department.Dept
,department.Dept_name 
FROM 
employee
LEFT JOIN 
department 
ON 
employee.Dept = department.Dept")

#For Right Outer Join we have to interchange the Tables
sqldf("
SELECT 
  employee.emp_id
  ,employee.emp_name
  ,employee.salary
  ,department.Dept_name 
  ,department.Dept
  FROM 
  department
  LEFT OUTER JOIN 
  employee 
  ON 
  employee.Dept = department.Dept")

sqldf("
SELECT 
employee.emp_id
,employee.emp_name
,employee.salary
,department.Dept_name 
,department.Dept
FROM 
department
LEFT OUTER JOIN 
employee 
ON 
employee.Dept = department.Dept
WHERE employee.Dept IS NULL;
")


#full Outer join
sqldf("
  SELECT 
  employee.emp_id
  ,employee.emp_name
  ,employee.salary
  ,department.Dept_name 
  ,department.Dept
  FROM 
  employee
  LEFT JOIN 
  department 
  ON 
  employee.Dept = department.Dept
  union all
  SELECT 
  employee.emp_id
 ,employee.emp_name
 ,employee.salary
 ,department.Dept_name 
 ,department.Dept
  FROM 
 department
 LEFT OUTER JOIN 
 employee 
  ON 
  employee.Dept = department.Dept
 WHERE employee.Dept IS NULL;
  ")
