-------------------
use database COURSE_52985_DB_F6D6117876A54AEB8C3BCDCE19F322C2;
select * from logistics.staging_shipments;
truncate table  logistics.staging_shipments;
INSERT INTO logistics.staging_shipments VALUES
('STG-0011','EMEA','LONDON_WH','DHL','2026-04-21','2026-04-24',3,'ON_TIME',10.50,0.0220),
('STG-0012','EMEA','FRANKFURT_WH','UPS','2026-04-21','2026-04-28',7,'DELAYED',18.00,0.0310);

---------------- 

