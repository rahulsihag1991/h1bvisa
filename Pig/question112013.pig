--11) Find the average Prevailing Wage for each Job for each Year (take part time and full time separate) arrange output in descending order.

REGISTER '/home/rahul/jar/piggybank.jar';--Register external jar 'Piggy Bank.jar'
REGISTER '/home/rahul/jar/piggybank.jar';--Register external jar 'Piggy Bank.jar'
DEFINE CSVExcelStorage org.apache.pig.piggybank.storage.CSVExcelStorage;  -- within the jar define a function CSVExcelStorage()  

a = LOAD '/home/rahul/project/h1b.csv' USING CSVExcelStorage() as 
(s_no:int,
case_status:chararray,
employer_name:chararray,
soc_name:chararray,
job_title:chararray,
full_time_position:chararray,
prevailing_wage:int,
year:chararray,
worksite:chararray,
longitute:double,
latitute:double);		--load data

b = filter a by year=='2013';
c = foreach b generate $4, $5, $6, $7;
d = group c by ($0, $1);
e = foreach d generate group as job_title, COUNT(c),SUM(c.prevailing_wage);
 f = foreach e generate $0, ($2/$1)as avg;
g = order f by $0 desc;
h = limit g 10;
dump h;
