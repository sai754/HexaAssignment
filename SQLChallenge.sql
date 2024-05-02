use SQLChallenge;

create table Vehicle (
	vehicleID int,
	make varchar(255),
	model varchar(255),
	year int,
	dailyRate decimal(5,2),
	status int,
	passengerCapacity int,
	engineCapacity int
	primary key (vehicleID)
);

create table Customer (
	customerID int,
	firstName varchar(255),
	lastName varchar(255),
	email varchar(255),
	phoneNumber varchar(255),
	primary key (customerID)	
);

create table Lease (
	leaseID int,
	vehicleID int,
	customerID int,
	startDate date,
	endDate date,
	type varchar(255),
	primary key (leaseID),
	foreign key (vehicleID) references Vehicle(vehicleID),
	foreign key (customerID) references Customer(customerID)
);


create table Payment (
	paymentID int,
	leaseID int,
	paymentDate date,
	amount decimal(6,2),
	primary key (paymentID),
	foreign key (leaseID) references Lease(leaseID)
);

insert into Vehicle values
(1,'Toyota', 'Camry',2022,50.00,1,4,1450),
(2,'Honda', 'Civic',2023,45.00,1,7,1500),
(3,'Ford', 'Focus',2022,48.00,0,4,1400),
(4,'Nissan', 'Altima',2023,52.00,1,7,1200),
(5,'Cheverlot', 'Malibu',2022,47.00,1,4,1800),
(6,'Hyundai', 'Sonata',2023,49.00,0,7,1400),
(7,'BMW', '3 Series',2023,60.00,1,7,2499),
(8,'Mercedes', 'C-Class',2022,58.00,1,8,2599),
(9,'Audi', 'A4',2022,55.00,0,4,2500),
(10,'Lexus', 'ES',2023,54.00,1,4,2500);

insert into Customer values
(1,'John', 'Doe', 'johndoe@example.com','555-555-5555'),
(2,'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3,'Robert','Johnson', 'robert@example.com' ,'555-789-1234'),
(4,'Sarah','Brown','sarah@example.com' ,'555-456-7890'),
(5,'David','Lee','david@example.com', '555-987-6543'),
(6,'Laura','Hall', 'laura@example.com', '555-234-5678'),
(7,'Michael','Davis', 'michael@example.com', '555-876-5432'),
(8,'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia' ,'Adams', 'olivia@example.com','555-765-4321');

insert into Lease values
(1,1,1, '2023-01-01', '2023-01-05', 'Daily'),
(2,2,2, '2023-02-15', '2023-02-28', 'Monthly'),
(3,3,3, '2023-03-10', '2023-03-15', 'Daily'),
(4,4,4, '2023-04-20', '2023-04-30', 'Monthly'),
(5,5,5, '2023-05-05','2023-05-10','Daily'),
(6,4,3, '2023-06-15', '2023-06-30', 'Monthly'),
(7,7,7, '2023-07-01', '2023-07-10', 'Daily'),
(8,8,8, '2023-08-12', '2023-08-15', 'Monthly'),
(9,3,3, '2023-09-07', '2023-09-10', 'Daily'),
(10,10,10, '2023-10-10', '2023-10-31', 'Monthly');

insert into Payment values
(1,1,'2023-01-03',200.00),
(2,2,'2023-02-20',1000.00),
(3,3,'2023-03-12',75.00),
(4,4,'2023-04-25',900.00),
(5,5,'2023-05-07',60.00),
(6,6,'2023-06-18',1200.00),
(7,7,'2023-07-03',40.00),
(8,8,'2023-08-14',1100.00),
(9,9,'2023-09-09',80.00),
(10,10,'2023-10-25',1500.00);

--Tasks

--1. Update the daily rate for a Mercedes car to 68. 

select * from Vehicle where make = 'Mercedes';

update Vehicle
set dailyRate = 68.00 
where make = 'Mercedes';

--2. Delete a specific customer and all associated leases and payments. 

select * from Lease;
select * from Payment;
select * from Customer;

declare @cust int = 1;

delete from Payment where leaseID = 
(select leaseID from Lease where customerID = @cust);

delete from Lease where customerID = @cust;

delete from Customer where customerID = @cust;

--3. Rename the "paymentDate" column in the Payment table to "transactionDate".

alter table Payment
rename column paymentDate to transactionDate;

--4. Find a specific customer by email.

select * from Customer where email = 'robert@example.com';

--5. Get active leases for a specific customer. 

select * from Customer;
select * from Lease;
select * from Payment;

select l.leaseID, l.vehicleID, l.startDate, l.endDate from Lease l 
join Payment p on l.leaseID=p.leaseID where p.paymentDate < l.endDate and 
l.customerID = 2;

--6. Find all payments made by a customer with a specific phone number. 

select * from Payment;
select * from Lease;
select * from Customer;

select p.*, l.leaseID from Payment p join Lease l
on p.leaseID = l.leaseID join Customer c
on l.customerID = c.customerID where c.phoneNumber='555-123-4567';

--7. Calculate the average daily rate of all available cars. 

select * from Vehicle;

select avg(dailyRate) as AvgDaily from Vehicle where status =1;

--8. Find the car with the highest daily rate.

select vehicleID, make, model from Vehicle order by dailyRate desc
offset 0 rows fetch next 1 rows only;

--9. Retrieve all cars leased by a specific customer. 

select * from Customer;
select * from Vehicle;
select * from Lease;

select distinct v.vehicleID, v.make, v.model from Vehicle v join Lease l on
v.vehicleID = l.vehicleID where l.customerID = 3;

--10. Find the details of the most recent lease.

select * from Lease order by startDate desc offset 0 rows 
fetch next 1 rows only;

--11. List all payments made in the year 2023.

select * from Payment where year(paymentDate)='2023';

--12. Retrieve Car Details and Their Total Payments. 

select * from Vehicle;
select * from Lease;
select * from Payment;

select v.make, v.model, v.year, sum(p.amount) as TotalAmount from Vehicle v
join Lease l on v.vehicleID = l.vehicleID 
join Payment p on p.leaseID = l.leaseID group by v.make, v.model,v.year;

--13. Retrieve customers who have not made any payments. 

select * from Customer;
select * from Lease;
select * from Payment;

select * from Customer where customerID not in 
(select customerID from Lease join Payment on Lease.leaseID = Payment.leaseID);

--14. Calculate Total Payments for Each Customer. 

select * from Customer;
select * from Lease;
select * from Vehicle;

select c.customerID, c.firstName, c.lastName, sum(v.dailyRate * DATEDIFF(DAY,l.startDate,l.endDate)) 
as TotalSpent from Customer c join Lease l 
on c.customerID = l.customerID
join Vehicle v on v.vehicleID = l.vehicleID group by c.customerID,c.firstName,c.lastName;

--15. List Car Details for Each Lease. 

select * from Vehicle;
select * from Lease;

select l.leaseID, v.vehicleID, v.make, v.model, v.engineCapacity,v.passengerCapacity 
from Lease l join Vehicle v on l.vehicleID = v.vehicleID;

--16. Retrieve Details of Active Leases with Customer and Car Information.

select * from Customer;
select * from Lease;
select * from Payment;

select l.leaseID, c.* from Lease l join Customer C on
l.customerID = c.customerID join Payment p on
l.leaseID = p.leaseID where p.paymentDate < l.endDate;

--17. Find the Customer Who Has Spent the Most on Leases.

select * from Customer;
select * from Lease;
select * from Payment;

select * from Customer where customerID = 
(select l.customerID from Lease l where leaseID = 
(select top 1 leaseID from Payment group by leaseID order by sum(amount) desc));

select c.customerID, c.firstName, c.lastName, sum(p.amount) as TotalSpent
from Customer c join Lease l on c.customerID = l.customerID 
join Payment p on l.leaseID = p.leaseID group by c.customerID,c.firstName,c.lastName
order by TotalSpent desc
offset 0 rows fetch next 1 rows only;

--18.  List All Cars with Their Current Lease Information.

select * from Vehicle;
select * from Lease;

select v.make, v.model,v.dailyRate, l.startDate, l.endDate,l.type from Vehicle v
join Lease l on v.vehicleID = l.vehicleID;
