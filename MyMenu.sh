#!/bin/bash
show_menu()
{
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[37m"` #Blue
    NUMBER=`echo "\033[34m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    ENTER_LINE=`echo "\033[33m"`
    echo -e "${MENU}\n\n\n\n\t\t\t\t\t Analyzing H1B APPLICATIONS using Hadoop\n ${NORMAL}"
    echo -e "${MENU}${NUMBER} 1) ${MENU} Is the number of petitions with Data Engineer job title increasing over time?${NORMAL}"
    echo -e "${MENU}${NUMBER} 2) ${MENU} Find top 5 job titles who are having highest avg growth in applications. ${NORMAL}"
    echo -e "${MENU}${NUMBER} 3) ${MENU} Which part of the US has the most Data Engineer jobs for each year? ${NORMAL}"
    echo -e "${MENU}${NUMBER} 4) ${MENU} Find top 5 locations in the US who have got certified visa for each year.${NORMAL}"
    echo -e "${MENU}${NUMBER} 5) ${MENU} Which industry has the most number of Data Scientist positions?${NORMAL}"
    echo -e "${MENU}${NUMBER} 6) ${MENU} Which top 5 employers file the most petitions each year? ${NORMAL}"
    echo -e "${MENU}${NUMBER} 7) ${MENU} Find the most popular top 10 job positions for H1B visa applications for each year?${NORMAL}"
    echo -e "${MENU}${NUMBER} 8) ${MENU} Find the most popular top 10 job positions for H1B visa applications for each year only for certified applications?${NORMAL}"
    echo -e "${MENU}${NUMBER} 9) ${MENU} Find the percentage and the count of each case status on total applications for each year. \n\t Create a graph depicting the pattern of All the cases over the period of time.${NORMAL}"
    echo -e "${MENU}${NUMBER} 10) ${MENU} Create a bar graph to depict the number of applications for each year.${NORMAL}"
    echo -e "${MENU}${NUMBER} 11) ${MENU}Find the average Prevailing Wage for each Job for each Year (take part time and full time separate) arrange output in descending order.${NORMAL}"
    echo -e "${MENU}${NUMBER} 12) ${MENU} Which are the employers who have success rate more than 70% in petitions and total petitions filed more than 1000?${NORMAL}"
    echo -e "${MENU}${NUMBER} 13) ${MENU} Which are the job positions which have the  success rate more than 70% in petitions and total petitions filed more than 1000? ${NORMAL}"
    echo -e "${MENU}${NUMBER} 14) ${MENU}Export result for option no 13 to MySQL database.\n${NORMAL}"
    echo -e "${MENU}\t\t\t\t NIIT Project By rAhuL sIhAg copyright 2018\n${NORMAL}"
    echo -e "${ENTER_LINE}Please enter a menu option and enter or ${RED_TEXT}enter to exit. ${NORMAL}"
    read opt
}
function option_picked() 
{
    COLOR='\033[01;31m' # bold red
    RESET='\033[00;00m' # normal white
    MESSAGE="$1"  #modified to post the correct option selected
    echo -e "${COLOR}${MESSAGE}${RESET}"
}
clear
show_menu
	while [ opt != '' ]
    do
    if [[ $opt = "" ]]; then 
            exit;
    else
        case $opt in

1)	option_picked "1 a) Is the number of petitions with Data Engineer job title increasing over time?";
	start-all.sh
	hive -e " select year,count(year) as Count from visa.h1b_final where job_title like '%DATA ENGINEER%' group by year order by year asc;" 
        show_menu;
	;;  
        
2)	option_picked "1 b) Find top 5 job titles who are having highest avg growth in applications. ";
        stop-all.sh
	pig -x local /home/rahul/project/Pig/question1b.pig
        show_menu;
        ;;  

3)	option_picked "2 a) Which part of the US has the most Data Engineer jobs for each year?";
        stop-all.sh
	pig -x local /home/rahul/project/Pig/question2a.pig
        show_menu;
        ;;  

4)	option_picked "2 b) find top 5 locations in the US who have got certified visa for each year.";
        start-all.sh
        echo -e "Enter the year (2011,2012,2013,2014,2015,2016)"
	read var
	hive -e " select year, worksite,count(case_status) as allcase_status from visa.h1b_final where year =$var and case_status='CERTIFIED' group by worksite,year order by allcase_status desc limit 5;" 
        show_menu;
        ;;

5)	option_picked "3) Which industry has the most number of Data Scientist positions?";
	start-all.sh
        hive -e " select soc_name,count(soc_name) as total_data_scientists from visa.h1b_final where job_title LIKE '%DATA SCIENTIST%' group by soc_name order by total_data_scientists desc;"
        show_menu;
        ;;

6)	option_picked "4)Which top 5 employers file the most petitions each year?";
        start-all.sh
	hive -e "create view topemp as select employer_name,year, count(case_status) as petition_filed from visa.h1b_final where year in ('2011','2012','2013','2014','2015','2016') group by year, employer_name sort by year, petition_filed desc;

select year, employer_name, petition_filed ,rank from(select year, employer_name, rank() over (partition by year order by petition_filed desc) as rank,petition_filed from topemp) ranked_table where ranked_table.rank <=5;" 
        show_menu;
        ;;

7)	option_picked "5a) Find the most popular top 10 job positions for H1B visa applications for each year?";
        start-all.sh
	echo -e "Enter the year (2011,2012,2013,2014,2015,2016)"
	read var
	echo "Find the most popular top 10 job positions for H1B visa applications for each year?";
	hive -e "select job_title,year,count(case_status ) as no_of_jobs from visa.h1b_final where year= $var group by job_title,year  order by no_of_jobs desc limit 10; "
        show_menu;
        ;;

8)	option_picked "5b) Find the most popular top 10 job positions for H1B visa applications for each year only certified position?";
        start-all.sh
	echo -e "Enter the year (2011,2012,2013,2014,2015,2016)"
	read var
	echo "Find the most popular top 10 job positions for H1B visa applications for each year?";
	hive -e "select job_title,year,count(case_status ) as no_of_jobs from visa.h1b_final where year= $var and case_status='CERTIFIED' group by job_title,year  order by no_of_jobs desc limit 10; "
        show_menu;
        ;;

9)	stop-all.sh
	option_picked "6) Find the percentage and the count of each case status on total applications for each year. Create a graph depicting the pattern of all the cases over the period of time.";
	pig -x local /home/rahul/project/Pig/question6.pig
        show_menu;
        ;;

10)	start-all.sh
	sleep 6
        option_picked "7) Create a bar graph to depict the number of applications for each year.";
	hive -e "select year,count(*) as applications  from visa.h1b_final where year like '201%' group by  year;"
        show_menu;
        ;;

11)	option_picked "8) Find the average Prevailing Wage for each Job for each Year (take part time and full time separate) arrange output in descending order";
	hive -f /home/rahul/project/Hive/question8.sql
        show_menu;
        ;;

12)	option_picked "9) Which are the employers along with the number of petitions who have the success rate more than 70%  in petitions. (total petitions filed 1000 OR more than 1000)?"
	stop-all.sh
	pig -x local /home/rahul/project/Pig/question9.pig
        show_menu;
        ;;

13)	option_picked "10) Which are the  job positions along with the number of petitions which have the success rate more than 70%  in petitions (total petitions filed 1000 OR more than 1000)?"
	stop-all.sh
	rm -r /home/rahul/project/Pig/question10
	pig -x local /home/rahul/project/Pig/question10.pig
	cat /home/rahul/project/Pig/question10/p*
        show_menu;
        ;;

14)	option_picked "11) Export result for question no 10 *(Which are the  job positions along with the number of petitions which have the success rate more than 70%  in petitions (total petitions filed 1000 OR more than 1000)?)* to MySql database."
	start-all.sh
	bash /home/rahul/project/Sqoop/question11.sh
        show_menu;
        ;;

\n) exit;   
	;;
        *) clear;
        option_picked "Pick an option from the menu";
        show_menu;
        ;;
    esac
fi
done
