DROP TABLE IF EXISTS `building`;

CREATE TABLE `building` (
  `build_name` varchar(15) NOT NULL,
  `address` varchar(255) NOT NULL,
  `rooms` int DEFAULT NULL,
  PRIMARY KEY (`build_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `building`
VALUES
('Packard','101 Main Street', 120),
('Painter','456 Sub Street',80),
('Taylor','789 Cross Street',90),
('Watson','100 Center',60);

DROP TABLE IF EXISTS `department`;

CREATE TABLE `department` (
	`dept_name` varchar(20) NOT NULL,
	`building` varchar(15) DEFAULT NULL,
	`budget` decimal(12,2) DEFAULT NULL,
	PRIMARY KEY (`dept_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `department`
VALUES
('Biology','Watson',90000.00),
('Comp. Sci.','Taylor',100000.00),
('Elec. Eng.','Taylor',85000.00),
('Finance','Painter',120000.00),
('History','Painter',50000.00),
('Music','Packard',80000.00),
('Physics','Watson',70000.00);

DROP TABLE IF EXISTS `instructor`;

CREATE TABLE `instructor` (
	`ID` char(5)  NOT NULL,
	`name` varchar(20) NOT NULL,
	`dept_name`  varchar(20) NOT NULL, 
	`salary` decimal(8,2) DEFAULT NULL, 
	PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `instructor`
VALUES
('10101','Srinivasan','Comp. Sci.',65000.00),
('12121','Wu','Finance',90000.00),
('15151','Mozart','Music',40000.00),
('22222','Einstein','Physics',95000.00),
('32343','El Said','History',60000.00),
('33456','Gold','Physics',87000.00),
('45565','Katz','Comp. Sci.',75000.00),
('58583','Califieri','History',62000.00),
('76543','Singh','Finance',80000.00),
('76766','Crick','Biology',72000.00),
('83821','Brandt','Comp. Sci.',92000.00),
('98345','Kim','Elec. Eng.',80000.00);

DROP TABLE IF EXISTS `student`;

CREATE TABLE `student` (
  `ID` varchar(5) NOT NULL,
  `name` varchar(20) NOT NULL,
  `dept_name` varchar(20),
  `tot_cred` int,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `student`
VALUE
('00000', 'ShinHwan Kang', 'Comp. Sci.', 100),
('00001', 'HoeHoon Jung', 'Comp. Sci.', 100),
('00128','Zhang','Comp. Sci.',102),
('12345','Shankar','Comp. Sci.',32),
('19991','Brandt','History',80),
('23121','Chavez','Finance',110),
('44553','Peltier','Physics',56),
('45678','Levy','Physics',46),
('54321','Williams','Comp. Sci.',54),
('55739','Sanchez','Music',38),
('70557','Snow','Physics',0),
('76543','Brown','Comp. Sci.',58),
('76653','Aoi','Elec. Eng.',60),
('98765','Bourikas','Elec. Eng.',98),
('98988','Tanaka','Biology',120);
