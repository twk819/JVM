CREATE TABLE `tb_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL,
  `userid` int(11) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `sql` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=71 DEFAULT CHARSET=latin1;

CREATE TABLE `tb_user` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `USERNAME` varchar(32) NOT NULL,
  `PASSWORD` char(64) NOT NULL,
  `ROLE` char(1) NOT NULL,
  `DEPARTMENT` char(64) NOT NULL,
  `PHONE` varchar(16) DEFAULT NULL,
  `EMAIL` varchar(64) DEFAULT NULL,
  `LAST_LOGIN` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

INSERT INTO `schema`.`tb_user`
(`ID`,
`USERNAME`,
`PASSWORD`,
`ROLE`,
`DEPARTMENT`,
`PHONE`,
`EMAIL`,
`LAST_LOGIN`)
VALUES
(0,
'admin',
'admin',
1,
'IT',
'',
'',
null);

