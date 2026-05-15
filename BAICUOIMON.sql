create database baicuoimon;

use baicuoimon;


create table PATIENTS(
patient_id int primary key,
full_name varchar(50) not null,
phone_number varchar(11) unique ,
gender enum('Female','Male') not null ,
date_of_birth date not null default (current_date)
);


create table DOCTORS  (
doctor_id int primary key,
full_name  varchar(50) not null,
specialty varchar(50) not null, 
phone_number varchar(11) unique ,
rating  float default 5.0

);


create table APPOINTMENTS(
appointment_id varchar(5) primary key,
patient_id int ,
doctor_id int ,
appointment_time date not null,
fee int ,
status enum('Booked', 'Completed', 'Cancelled'),
foreign key (patient_id) references PATIENTS (patient_id),
foreign key (doctor_id) references DOCTORS (doctor_id)
);
 
create table MEDICAL_RECORDS(
record_id int primary key ,
appointment_id varchar(5) ,
symptoms varchar (30) not null ,
diagnosis varchar (30) not null ,
prescription text ,
record_date date ,
foreign key (appointment_id) references APPOINTMENTS (appointment_id)
);

create table VISIT_LOG(
log_id int primary key ,
record_id int,
doctor_id int, 
log_time date not null,
note text,
foreign key (record_id) references MEDICAL_RECORDS (record_id),
foreign key (doctor_id) references DOCTORS (doctor_id)
);


insert into PATIENTS
values (1,'Nguyen Thi Lan','901234567','Female','1999-3-12'),
(2,'Tran Van Minh','902345678','Male','1996-11-25'),
(3,'Le Hoai Phuong','913456789','Female','2001-7-8'),
(4,'Pham Duc Anh','984567890','Male','1998-1-19'),
(5,'Hoang Ngoc Mai','975678901','Female','2000-9-30');


insert into DOCTORS
values (1,'BS. Nguyen Van Hai','Noi','931112223',4.8),
(2,'BS. Tran Thu Ha','Nhi','932223334',5.0),
(3,'BS. Le Quoc Tuan','Ngoai','933334445',4.6),
(4,'BS. Pham Minh Chau','Da lieu','934445556',4.9),
(5,'BS. Hoang Gia Bao','Tim mach','935556667',4.7);

insert into APPOINTMENTS 
values ('7001',1,1,'2024-5-20',200000,'Booked'),
('7002',2,2,'2024-5-20',250000,'Completed'),
('7003',3,3,'2024-5-20',300000,'Booked'),
('7004',4,5,'2024-5-21',350000,'Completed'),
('7005',5,4,'2024-5-21',220000,'Cancelled');

insert into MEDICAL_RECORDS
values (8001,'7002','Sốt cao, ho','Viêm họng','Paracetamol + siro ho','2024-5-20'),
(8002,'7004','Đau ngực nhẹ','Theo dõi tim mạch','Vitamin + tái khám','2024-5-20'),
(8003,'7001','Đau bụng','Rối loạn tiêu hóa','Men tiêu hóa','2024-5-20'),
(8004,'7003','Đau vai gáy','Căng cơ','Giảm đau + nghỉ ngơi','2024-5-21'),
(8005,'7005','Ngứa da','Dị ứng','Thuốc bôi ngoài da','2024-5-21');

insert into VISIT_LOG
values (1,8003,1,'2024-5-20','Đã khám lần đầu'),
(2,8001,2,'2024-5-20','Hoàn tất khám'),
(3,8004,3,'2024-5-20',' vấn vật lý trị liệu'),
(4,8002,5,'2024-5-21','Hướng dẫn tái khám'),
(5,8005,4,'2024-5-21','Bệnh nhân hủy hẹn');


-- Câu 2 – UPDATE & DELETE (10 điểm)
-- Viết câu lệnh tăng 10% phí khám cho các phiếu hẹn thỏa mãn đồng thời:
-- Có trạng thái Completed
-- Thuộc bệnh nhân có năm sinh < 2000


-- Viết câu lệnh xóa các bản ghi trong visit_log thỏa mãn:
-- Có log_time trước ngày 20/05/2024
update APPOINTMENTS
set fee = fee * 1.1 
where status = 'Completed' ;

delete from VISIT_LOG 
where log_time < 20/05/2024;


-- PHẦN 3: TRUY VẤN CƠ BẢN (15 ĐIỂM)
--    Câu 1 (5 điểm): Liệt kê các thông tin bác sĩ gồm full_name, specialty và 
--    rating của những bác sĩ có rating lớn hơn 4.7 hoặc thuộc chuyên khoa “Nhi”.
--    Câu 2 (5 điểm): Liệt kê các thông tin bệnh nhân gồm full_name 
--    và phone_number của những bệnh nhân có ngày sinh trong khoảng từ 1998-01-01 đến 
--    2001-12-31 và số điện thoại bắt đầu bằng “090”.
--    Câu 3 (5 điểm): Liệt kê các phiếu hẹn gồm appointment_id, 
--    appointment_time và fee, trong đó danh sách được sắp xếp theo fee giảm dần và 
--    chỉ hiển thị 2 phiếu ở trang thứ hai.

select full_name,specialty,rating 
from DOCTORS where rating > 4.7 or specialty = 'Nhi';

select full_name , phone_number from PATIENTS
where date_of_birth between 1998-01-01 and 2001-12-31 and phone_number like '090%';

select appointment_id,appointment_time , fee from APPOINTMENTS
order by fee desc 
limit 2;

-- PHẦN 4: TRUY VẤN NÂNG CAO (15 ĐIỂM)
--    Câu 1 (5 điểm): Liệt kê các thông tin khám gồm họ tên bệnh nhân
--    , họ tên bác sĩ, chuyên khoa, phí khám và thời điểm hẹn khám, 
--    với dữ liệu được lấy từ các bảng liên quan trong hệ thống.
--    Câu 2 (5 điểm): Liệt kê các thông tin bác sĩ gồm họ tên bác sĩ
--    và tổng phí khám mà bác sĩ đó đã thực hiện (chỉ tính phiếu Completed), 
--    chỉ hiển thị những bác sĩ có tổng phí lớn hơn 500.000.
--    Câu 3 (5 điểm): Liệt kê các thông tin bác sĩ gồm doctor_id, 
--    full_name và rating của những bác sĩ có điểm đánh giá cao nhất.

select p.full_name,d.full_name, d.specialty, a.appointment_time from PATIENTS p
join APPOINTMENTS a on p.patient_id = a.patient_id 
join DOCTORS d on a.doctor_id = d.doctor_id;

select d.full_name, sum(fee) as sum_fee from  DOCTORS d
join APPOINTMENTS a on d.doctor_id = a.doctor_id ;

select doctor_id,full_name,rating 
from DOCTORS 
order by rating desc
limit 3;



-- PHẦN 5: INDEX & VIEW (10 ĐIỂM)
--    Câu 1 (5 điểm): Tạo một chỉ mục trên bảng appointments dựa trên hai thông tin
--    là trạng thái hẹn khám và phí khám nhằm phục vụ việc tối ưu truy vấn.

create index index_appointments  
on APPOINTMENTS (status,fee);

--    Câu 2 (5 điểm): Tạo một khung nhìn dữ liệu hiển thị họ tên 
--    bác sĩ, tổng số phiếu hẹn mà bác sĩ đã nhận và tổng doanh thu 
--    phí khám mà bác sĩ đó mang lại, trong đó không tính các phiếu bị hủy.

create view select_name_and_sumappointments as
select  d.full_name,count(appointment_id),sum(fee)
from DOCTORS d join APPOINTMENTS a on d.doctor_id = a.doctor_id
group by d.fullname ;

select * from select_name_and_sumappointments;

-- PHẦN 6: TRIGGER (10 ĐIỂM)
--   Câu 1 (5 điểm): Viết một trigger sao cho khi trạng thái của 
--   một phiếu hẹn trong bảng appointments được cập nhật sang giá trị Completed 
--   thì hệ thống tự động thêm một bản ghi mới vào bảng visit_log với các thông tin sau:
-- appointment_id/record_id: hồ sơ tương ứng của phiếu vừa cập nhật
-- doctor_id: bác sĩ của phiếu hẹn
-- note: Visit completed
-- log_time: thời gian hiện tại của hệ thống


delimiter //
create trigger status_trigger_update 
after update on appointments
for each row 
begin 

update visit_log
set appointment_id = new.appointment_id and 
doctor_id = old.doctor_id and
note = ' Visit completed' and
log_time = date.log_time;

end //
delimiter ;



--   Câu 2 (5 điểm): Viết một trigger sao cho khi thêm
--   mới một bản ghi vào bảng appointments có trạng thái Completed 
--   thì hệ thống tự động tăng điểm đánh giá của bác sĩ tương ứng trong bảng
--   doctors thêm 0.1, nhưng đảm bảo điểm đánh giá không vượt quá 5.0.

delimiter //
create trigger status_trigger_update 
after update on appointments
for each row 
begin 
  if status = 'Completed' then
  update DOCTORS
  set raiting = raiting + 0.1 and raiting < 5.0 ;
end if; 
end //
delimiter ;




