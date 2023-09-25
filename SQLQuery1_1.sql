DECLARE @Table1 table (Id_Client int, Value money) -- клиенты
-- Id_Client Ц идентификатор клиента, Value Ц размер кредита
†
INSERT INTO @Table1 (Id_Client, Value)
SELECT 1, 24
UNION SELECT 2, 13
UNION SELECT 3, 2
UNION SELECT 4, 5
†
DECLARE @Table2 table (Id_Client int, DocDate datetime, Amount money, Caption varchar(6)) -- покупки
--†Id_Client Ц идентификатор клиента, Amount Ц сумма покупки, DocDate Ц дата покупки, Caption - наименование покупки
†
INSERT INTO @Table2 (Id_Client, Amount, DocDate, Caption)
†
SELECT 1, 5, '20051024', 'qh'
UNION SELECT 1, 9,  '20051019', 'wj'
UNION SELECT 1, 3,  '20051022', 'ek'
UNION SELECT 1, 8,  '20051004', 'rl'
UNION SELECT 1, 6,  '20051018', 'tz'
UNION SELECT 1, 5,  '20050929', 'yx'
UNION SELECT 2, 11, '20051023', 'uc'
UNION SELECT 2, 6,  '20051021', 'iv'
UNION SELECT 2, 45, '20051018', 'ob'
UNION SELECT 3, 4,  '20051030', 'pn'
UNION SELECT 3, 2,  '20051028', 'am'
UNION SELECT 4, 4,  '20051021', 'sq'
UNION SELECT 4, 6,  '20051023', 'dw'
UNION SELECT 4, 8,  '20051023', 'fe'
UNION SELECT 4, 9,  '20051023', 'gr'


select
b.Id_Client, b.DocDate,
case
when a.Value >= c.s then b.Amount
when a.Value < c.s and d.cr>=0 then d.cr
when a.Value < c.s and d.cr<0 then a.Value
end ,
b.Caption
from
@Table1 a join
@Table2 b on b.Id_Client = a.Id_Client cross apply
(select sum(Amount) from @Table2 where Id_Client = b.Id_Client and DocDate >= b.DocDate) c(s) cross apply
(select a.Value - (c.s - b.Amount)) as d(cr) cross apply
(select max(DocDate) from @Table2 where Id_Client = b.Id_Client) as m(cr) cross apply
(select max(Amount) from @Table2 where DocDate = m.cr and Id_Client=b.Id_Client) as t(tr)
Where d.cr>=0 or ( d.cr<0 and m.cr=b.DocDate and b.Amount=t.tr)
order by
b.Id_Client, b.DocDate desc;
