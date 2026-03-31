#单表查询练习
#创建数据库test04_lib
CREATE DATABASE IF NOT EXISTS test_lib CHARACTER SET utf8;
USE test_lib;
#创建表books，表结构如下
CREATE TABLE books(
id INT,
NAME VARCHAR(50),
AUTHORS VARCHAR(100),
price FLOAT,
pubdate YEAR,
note VARCHAR(100),
num INT
);
#向books表中插入记录
 #1)不指定字段名称，插入第一条记录
INSERT INTO books
VALUES(1,'Tal of AAA','Dickes',23,1995,'novel',11);
 #2)指定所有字段名称，插入第二记录
INSERT INTO books
(id,NAME,AUTHORS,price,pubdate,note,num)
VALUES(2,'EmmaT','JaneLura',35,1993,'joke',22);
 #3)同时插入多条记录(剩下的所有记录）
INSERT INTO books
(id,NAME,AUTHORS,price,pubdate,note,num)
VALUES(3,'Story of Jane','JaneTime',40,2001,'novel',0),
(4,'Lovey Day','GeorgeByron',20,2005,'novel',30),
(5,'Old Land','HonoreBlade',30,2010,'law',0),
(6,'The Battle','UptonSara',30,1999,'medicine',40),
(7,'Rose Hood','Richard haggard',28,2008,'cartoon',28);
#将小说类型(nove)的书的价格都增加5。
UPDATE books SET price=price+5 WHERE note='novel';
#5、将名称为EmmaT的书的价格改为40.并将说明改为drama。
UPDATE books SET price=40,note='drama'WHERE id=2;
#6、删除库存为0的记录
DELETE FROM books WHERE num=0;
#7、统计书名中包含a字母的书
SELECT *FROM books WHERE NAME LIKE'%a%';
#8、统计书名中包含a字母的书的数量和库存总量
SELECT SUM(num),COUNT(*)FROM books WHERE NAME LIKE '%a%';
#9、找出nover类型的书，按照价格降序排列
SELECT* FROM books WHERE note='novel' ORDER BY price DESC;
#10、查询图书信息，按照库存量降序排列，如果库存量相同的按照note升序排列
SELECT * FROM books ORDER BY num DESC,note;
#11、按照note分类统计书的数量
SELECT note,COUNT(*)FROM books GROUP BY note;
#12按照note分类统计书的库存量，显示库存量超过30本的
SELECT note,SUM(num)nu FROM books GROUP BY note HAVING nu>30;#!!!
#13、查询所有图书，每页显示5本，显示第二页
SELECT*FROM books LIMIT 5,5;
#14按照note分类统计书的库存量，显示库存量最多的
SELECT note,SUM(num)nm FROM books GROUP BY note ORDER BY nm DESC LIMIT 1;
/*15查询书名达到10个字符的书，不包括里面的空格
char_length(统计字符串长度)，replace（字符串,'目标','替换的值'）
用string函数 先用replace将空格替换，再用char_length：用来计算字符串长度*/
SELECT*FROM books WHERE CHAR_LENGTH(REPLACE(NAME,' ',''))>10;
/*16查询书名和类型，其中note值为novel显示小说，law显示法律，medicine显示医药
cartoon显示卡通，joke显示笑话*/
SELECT NAME,note,
CASE note
WHEN'novel'THEN'小说'
WHEN'law'THEN'法律'
WHEN'medicine'THEN'医药'
WHEN'cartoon'THEN'卡通'
WHEN'joke'THEN'笑话'
ELSE 0
END AS newnote
FROM books;
#17、查询书名、库存，其中num值超过30本的，显示滞销，大于0并低于10的、显示畅销
#为0的显示无货
SELECT NAME,num,
CASE 
WHEN num>30 THEN '滞销'
WHEN num>0 AND num<=30 THEN '正常'
WHEN num>0 AND num<=10 THEN '畅销'
else '无库存'
end as salenum
from books;
/*
CASE两种写法总结：
1. 简单CASE（等值匹配，如CASE note）：字符串常量有单引号分隔，可省略空格；
2. 搜索CASE（范围判断，如CASE num）：数字/关键字无天然分隔符，必须加空格，避免语法错误。
统一加空格是最安全规范的写法。
*/
#18、统计每一种note的库存量，并合计总量
select note,sum(num) sumnum from books group by note;
#19统计每一种note的数量，并合计总量
select note,count(*) from books group by note with rollup;
#20、统计库存量前三名的图书
select *from books order by num desc limit 3;
#21、找出最早出版的一本书
select*from books order by pubdate limit 1;
#22、找出novel中价格最高的一本书
select *from books  where note='novel' order by price desc limit 1;
#23·找出书名中字数最多的一本书，不含空格
SELECT *FROM books ORDER BY CHAR_LENGTH(REPLACE(NAME,' ','')) DESC LIMIT 1; 
/*18题,19题解法优化*/
#with rollup sql查询的子句，用于生成数据汇总行
SELECT ifnull(note,'总量'),SUM(num) sumnum FROM books GROUP BY note WITH ROLLUP;
SELECT ifnull(note,'总量'),COUNT(*) FROM books GROUP BY note WITH ROLLUP;