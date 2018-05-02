#11) Export result for question no 10 *(Which are the  job positions along with the number of petitions which have the success rate more than 70%  in petitions (total petitions filed 1000 OR more than 1000)?)* to MySql database.
#Create a Database in mysql and create a table in it
hadoop fs -rm -r -f /Pig/Question10
hadoop fs -mkdir -p /Pig/Question10
hadoop fs -put /home/rahul/project/Pig/question10/p* /Pig/Question10/
mysql -u root -p -e 'create database if not exists question11;use question11;create table question11(job_title varchar(100),success_rate float,petitions int);';
sqoop export --connect jdbc:mysql://localhost/question11 --username root --password 'macbook' --table question11 --export-dir /Pig/Question10/ --input-fields-terminated-by '\t' ;
echo -e '\n\nDisplay contents from MySQL Database.\n\n'
echo -e '\n10) Which are the top job positions that have  success rate more than 70% in petitions and total petitions filed more than 1000?\n\n'
mysql -u root -p -e 'select * from question11.question11';
