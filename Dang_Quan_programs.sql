/********************************************************** 
****** Stored Programs for Assn.2, 2019 *******************
********** Quan Dang 45240221 ************************
******************* 28/10/2019 **********************************
** I declare that the code provided below is my own work **
******* Any help received is duely acknowledged here ******
				Trang Ngan Bui 44332637
**********************************************************/

/********* Trigger TR_OVERDUE ************/

delimiter //
drop trigger if exists tr_overdue
//

create trigger tr_overdue 
after update on invoice 
	for each row
    begin
		if New.`STATUS` = 'OVERDUE' then
        insert into alerts (message_no, message_date, origin, message)
			VALUES (message_no, now(), current_user(), concat("Invoice with number: ",OLD.invoiceno, " is  now overdue!"));
    end if;
    end
//

/************* Helper Functions ****************/

drop function if exists rate_on_date //

create function rate_on_date(staff_id int, given_date date) 
returns float

reads sql data
DETERMINISTIC
begin
declare hour_rate numeric;
select hourlyrate into hour_rate
from salarygrade, staffongrade
where staffongrade.grade=salarygrade.grade and staffno = staff_id and given_date >= STARTDATE and (FINISHDATE>=given_date or FINISHDATE is null);
return hour_rate;
end //

drop function if exists cost_of_campaign
//
create function cost_of_campaign (camp_id int) returns float
reads sql data
DETERMINISTIC
begin
declare total_cost numeric;
select sum(rate_on_date(staffno,`wdate`)*workson.HOUR) into total_cost 
	FROM workson
	WHERE CAMPAIGN_NO =camp_id;
return total_cost;
end//

/************ Procedure SP_FINISH_CAMPAIGN******************/
set foreign_key_checks=0;
drop trigger if exists tr_invoice//
create trigger tr_invoice
after update on campaign
for each row
begin
if new.campaignfinishdate is not null then
	insert into invoice (`CAMPAIGN_NO`, `DATEISSUED`, `BALANCEOWING`, `STATUS`)
    values (OLD.CAMPAIGN_NO,CURRENT_DATE(), NEW.ACTUALCOST, 'UNPAID');
    END IF;
end//

drop procedure if exists sp_finish_campaign //
create procedure sp_finish_campaign (in c_title varchar(30))
begin
declare `found` int default 0;
select 1 into `found` from campaign
where TITLE = c_title;
if `found` = 1 then
update campaign
set `CAMPAIGNFINISHDATE` =  current_date(),
 `ACTUALCOST`= cost_of_campaign(campaign_no)
where title = c_title;
else 
	select 'ERROR! Campaign title does not exist' as Message;
end if;
end//

/************ Procedure SYNC_INVOICE******************/
SET SQL_SAFE_UPDATES =0;
drop procedure if exists sync_invoice//
CREATE procedure sync_invoice()
begin
declare OLDSTATUS CHAR(20);
declare finish int default 0;
declare 1_dateissued numeric;
declare sync cursor for 
select STATUS, dateissued from invoice;
declare continue handler for not found set finish =1;
open sync;
repeat
fetch sync into oldstatus, 1_dateissued;
IF OLDSTATUS = 'UNPAID' and datediff(current_date(),1_dateissued) >30 THEN
update invoice
set `STATUS` = 'OVERDUE'
where STATUS = 'UNPAID' AND DATEDIFF(NOW(),DATEISSUED)>30;
END IF;
until finish
end repeat;
close sync;
END//

delimiter ;


