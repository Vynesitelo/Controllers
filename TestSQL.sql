create database Store
use Store

--�������� ������ ��
begin
create table Agents(
	Id int identity(1,1) primary key,
	Name nvarchar(255) not null
)

create table Orders(
	Id int identity(1,1) primary key,
	AgentId int foreign key references Agents(Id),
	CreateDate date default getdate()
	)

create table Colors(	
	Id int identity(1,1) primary key,
	Name nvarchar(255) not null
	)
create table Goods(
	Id int identity(1,1) primary key,
	Name nvarchar(255) not null
)

create table GoodProperties(
	Id int identity(1,1) primary key,
	GoodId int foreign key references Goods(Id),
	ColorId int foreign key references Colors(Id),
	Bdate date,
	Edate date
)

create table OrderDetails(
	Id int identity(1,1) primary key,
	OrderId int foreign key references Orders(Id),
	GoodId int foreign key references Goods(Id),
	GoodCount int
)
end

--������� ������ � ��
begin
-- ������� ������ � ������� ������
INSERT INTO Agents (Name) VALUES
('����� 1'),
('����� 2'),
('����� 3'),
('����� 4'),
('����� 5'),
('����� 6'),
('����� 7'),
('����� 8'),
('����� 9'),
('����� 10'),
('����� 11'),
('����� 12'),
('����� 13'),
('����� 14'),
('����� 15');

-- ������� ������ � ������� �����
INSERT INTO Colors (Name) VALUES
('�������'),
('�������'),
('�����');

-- ������� ������ � ������� ������
INSERT INTO Goods (Name) VALUES
('����� 1'),
('����� 2'),
('����� 3'),
('����� 4'),
('����� 5'),
('����� 6'),
('����� 7'),
('����� 8'),
('����� 9'),
('����� 10');

-- ������� ������ � ������� ������
INSERT INTO Orders (AgentId, CreateDate) VALUES
(1, '2020-01-01'),
(2, '2020-02-01'),
(3, '2020-03-01'),
(4, '2020-04-01'),
(5, '2020-05-01'),
(6, '2020-03-01'),
(7, '2020-09-01'),
(8, '2020-01-31'),
(9, '2020-02-28'),
(10, '2020-03-31'),
(1, '2020-01-02'),
(2, '2020-02-02'),
(3, '2020-03-02'),
(4, '2020-04-02'),
(5, '2020-05-02'),
(6, '2020-03-02'),
(7, '2020-09-02'),
(8, '2020-01-12'),
(9, '2020-02-12'),
(10, '2020-03-02'),
(1, '2021-01-01'),
(2, '2021-02-01'),
(3, '2021-03-01'),
(4, '2021-04-01'),
(5, '2021-05-01'),
(6, '2021-03-01'),
(7, '2021-09-01'),
(8, '2021-01-31'),
(9, '2021-02-13'),
(10, '2021-03-31'),
(1, '2021-01-02'),
(2, '2021-02-02'),
(3, '2021-03-02'),
(4, '2021-04-02'),
(5, '2021-05-02'),
(6, '2021-03-02'),
(7, '2021-09-02'),
(8, '2021-01-12'),
(9, '2021-02-12'),
(10, '2021-03-02')

-- ������� ������ � ������� OrderDetails
begin
DECLARE @OrderId INT, @GoodId INT, @GoodCount INT, @NumDetails INT;
SET @OrderId = 1;

-- ���� �� �������
begin
WHILE @OrderId <= 40
BEGIN
    -- ��������� ���������� ���������� ����� ����������� ��� ������
    SET @NumDetails = FLOOR(1 + RAND() * (5 - 1 + 1));

    -- ��������� ��������� ����� ����������� ��� ������
    WHILE @NumDetails > 0
    BEGIN
        -- ��������� ���������� ������
        SET @GoodId = FLOOR(1 + RAND() * (10 - 1 + 1));

        -- ��������� ���������� ���������� ������
        SET @GoodCount = FLOOR(1 + RAND() * (10 - 1 + 1));

        -- ��������, ��� � ������ ��� ��� ������ ����������� ��� ������� ������
        IF NOT EXISTS (SELECT 1 FROM OrderDetails WHERE OrderId = @OrderId AND GoodId = @GoodId)
        BEGIN
            -- ������� ������ �����������
            INSERT INTO OrderDetails (OrderId, GoodId, GoodCount)
            VALUES (@OrderId, @GoodId, @GoodCount);

            SET @NumDetails = @NumDetails - 1;
        END
    END

    SET @OrderId = @OrderId + 1;
END
end
end

-- ������� ������ � ������� GoodProperties
INSERT INTO GoodProperties (GoodId, ColorId, Bdate, Edate) VALUES
(1, 1, '2023-01-01', '2023-03-31'),
(1, 2, '2023-04-01', '2023-06-30'),
(1, 3, '2023-07-01', '2023-09-30'),
(2, 1, '2023-02-01', '2023-04-30'),
(2, 2, '2023-05-01', '2023-07-31'),
(2, 3, '2023-08-01', '2023-10-31'),
(3, 1, '2023-03-01', '2023-05-31'),
(3, 2, '2023-06-01', '2023-08-30'),
(3, 3, '2023-09-01', '2023-11-30'),
(4, 1, '2023-04-01', '2023-06-30'),
(4, 2, '2023-07-01', '2023-09-29'),
(4, 3, '2023-10-01', '2023-12-31');
end

-- ������ �������, � ������� �� �������� ���� �� ����� ����.
SELECT
  g.Name AS �����
FROM Goods AS g
JOIN GoodProperties AS gp
  ON g.Id = gp.GoodId
WHERE
   gp.Bdate > '2023-03-08' or gp.Bdate = NULL;

--�������� ������������ ��������� ������: 
--� ������� ������ �� ����� ������� ������ ���� ����� ������ ���� ����. 
--������� ������, � ������� ���� ����������� �������� �������� �����.
SELECT g.Id AS ProductId, g.Name AS ProductName,
       p1.ColorId AS ColorId1, p1.Bdate AS Bdate1, p1.Edate AS Edate1,
       p2.ColorId AS ColorId2, p2.Bdate AS Bdate2, p2.Edate AS Edate2
FROM Goods AS g
JOIN GoodProperties AS p1 ON g.Id = p1.GoodId
JOIN GoodProperties AS p2 ON g.Id = p2.GoodId AND p1.ColorId <> p2.ColorId
WHERE p1.Bdate < p2.Edate AND p2.Bdate < p1.Edate;

--������ �������, ���������� ������� ������� �� 2022 ��� ����� 10.	
SELECT a.Name AS �����,
	COUNT(o.Id) AS �����������������
FROM Agents AS a JOIN Orders AS o ON a.Id = o.AgentId
WHERE o.CreateDate >= '2022-01-01' AND o.CreateDate < '2023-01-01'
GROUP BY a.Id, a.Name
HAVING COUNT(o.Id) > 10;

--������ �������, � ������� � ��������� ������ �� ���� ������1 ������2(������� � ��� ������). ����� ������� ��������� ���������� ������ ������� � ���� ������.
SELECT Agents.Name AS �����, Orders.Id AS �����������,
  SUM(OrderDetails.GoodCount) AS ��������������������������������
FROM Agents
JOIN Orders ON Agents.Id = Orders.AgentId
JOIN OrderDetails ON Orders.Id = OrderDetails.OrderId
WHERE
  NOT EXISTS (SELECT 1
    FROM OrderDetails
	join Goods on Goods.Id = OrderDetails.GoodId
	join GoodProperties on GoodProperties.GoodId = Goods.Id
    WHERE OrderDetails.OrderId = Orders.Id AND OrderDetails.GoodId = 1 AND GoodProperties.ColorId = 2
  )
GROUP BY Agents.Id, Agents.Name, Orders.Id;

--������ �������, � ������� � ��������� ������ �� ���� ������1 ������2. ����� ������� ��������� ���������� ������ ������� � ���� ������.
SELECT a.Name, SUM(DISTINCT od.GoodCount) AS TotalCount
FROM Agents a
JOIN Orders o ON a.Id = o.AgentId
LEFT JOIN OrderDetails od ON o.Id = od.OrderId
LEFT JOIN Goods g ON od.GoodId = g.Id
LEFT JOIN GoodProperties gp ON g.Id = gp.GoodId
LEFT JOIN Colors c ON gp.ColorId = c.Id
WHERE o.Id = (SELECT MAX(Id) FROM Orders WHERE AgentId = a.Id)
  AND NOT EXISTS (
      SELECT 1
      FROM OrderDetails od2
      JOIN Goods g2 ON od2.GoodId = g2.Id
      JOIN GoodProperties gp2 ON g2.Id = gp2.GoodId
      JOIN Colors c2 ON gp2.ColorId = c2.Id
      WHERE od2.OrderId = o.Id AND g2.Name = '�����1' AND c2.Name = '����2'
  )
GROUP BY a.Name;

--������� ���������� ��������� ������� ������������� ������ ��������� �� ������ � 01.01.2023 �� 31.03.2023. 
SELECT
    DATEADD(MONTH, DATEDIFF(MONTH, '2023-01-01', o.CreateDate), '2023-01-01') AS ����,
    g.Name AS ������������,
    SUM(od.GoodCount) AS �����������������,
    SUM(SUM(od.GoodCount)) OVER (ORDER BY DATEADD(MONTH, DATEDIFF(MONTH, '2023-01-01', o.CreateDate), '2023-01-01')) AS ����
FROM Goods AS g
JOIN OrderDetails AS od ON g.Id = od.GoodId
JOIN Orders AS o ON od.OrderId = o.Id
WHERE o.CreateDate BETWEEN '2023-01-01' AND '2023-03-31'
GROUP BY
    DATEADD(MONTH, DATEDIFF(MONTH, '2023-01-01', o.CreateDate), '2023-01-01'), g.Name
ORDER BY ����, ������������;

--������� (���������������� ��������� �� ��������� �� ��������� ����)
CREATE NONCLUSTERED INDEX IX_Agents_Name ON Agents (Name);

CREATE NONCLUSTERED INDEX IX_Orders_AgentId ON Orders (AgentId);
CREATE NONCLUSTERED INDEX IX_Orders_CreateDate ON Orders (CreateDate);

CREATE NONCLUSTERED INDEX IX_Colors_Name ON Colors (Name);

CREATE NONCLUSTERED INDEX IX_Goods_Name ON Goods (Name);

CREATE NONCLUSTERED INDEX IX_GoodProperties_GoodId ON GoodProperties (GoodId);
CREATE NONCLUSTERED INDEX IX_GoodProperties_Bdate_Edate ON GoodProperties (Bdate, Edate);

CREATE NONCLUSTERED INDEX IX_OrderDetails_OrderId ON OrderDetails (OrderId);
CREATE NONCLUSTERED INDEX IX_OrderDetails_GoodId ON OrderDetails (GoodId);
