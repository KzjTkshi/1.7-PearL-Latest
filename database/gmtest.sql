-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 30, 2022 at 08:52 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gmtest`
--

-- --------------------------------------------------------

--
-- Table structure for table `banned`
--

CREATE TABLE `banned` (
  `pID` int(12) NOT NULL,
  `UCP` varchar(255) NOT NULL,
  `Banned` int(3) NOT NULL DEFAULT 0,
  `BannedBy` varchar(24) NOT NULL DEFAULT 'Admin',
  `BannedReason` varchar(32) NOT NULL DEFAULT 'Undefined',
  `BannedTime` int(8) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `survivors`
--

CREATE TABLE `survivors` (
  `pID` int(12) NOT NULL,
  `Name` varchar(64) NOT NULL,
  `PosX` float NOT NULL DEFAULT 0,
  `PosY` float NOT NULL DEFAULT 0,
  `PosZ` float NOT NULL DEFAULT 0,
  `UCP` varchar(22) NOT NULL,
  `Age` int(5) NOT NULL DEFAULT 0,
  `Origin` varchar(22) NOT NULL DEFAULT '',
  `Gender` int(3) NOT NULL DEFAULT 0,
  `Skin` int(4) NOT NULL DEFAULT 0,
  `AdminLevel` int(5) NOT NULL DEFAULT 0,
  `Money` int(12) NOT NULL DEFAULT 0,
  `Gun1` int(6) NOT NULL DEFAULT 0,
  `Gun2` int(6) NOT NULL DEFAULT 0,
  `Gun3` int(6) NOT NULL DEFAULT 0,
  `Gun4` int(6) NOT NULL DEFAULT 0,
  `Gun5` int(6) NOT NULL DEFAULT 0,
  `Gun6` int(6) NOT NULL DEFAULT 0,
  `Gun7` int(6) NOT NULL DEFAULT 0,
  `Gun8` int(6) NOT NULL DEFAULT 0,
  `Gun9` int(6) NOT NULL DEFAULT 0,
  `Gun10` int(6) NOT NULL DEFAULT 0,
  `Ammo1` int(6) NOT NULL DEFAULT 0,
  `Ammo2` int(6) NOT NULL DEFAULT 0,
  `Ammo3` int(6) NOT NULL DEFAULT 0,
  `Ammo4` int(6) NOT NULL DEFAULT 0,
  `Ammo5` int(6) NOT NULL DEFAULT 0,
  `Ammo6` int(6) NOT NULL DEFAULT 0,
  `Ammo7` int(6) NOT NULL DEFAULT 0,
  `Ammo8` int(6) NOT NULL DEFAULT 0,
  `Ammo9` int(6) NOT NULL DEFAULT 0,
  `Ammo10` int(6) NOT NULL DEFAULT 0,
  `JailTime` int(8) NOT NULL DEFAULT 0,
  `JailReason` varchar(32) NOT NULL,
  `JailedBy` varchar(24) NOT NULL,
  `Exp` int(8) NOT NULL DEFAULT 0,
  `Level` int(8) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `survivors`
--

INSERT INTO `survivors` (`pID`, `Name`, `PosX`, `PosY`, `PosZ`, `UCP`, `Age`, `Origin`, `Gender`, `Skin`, `AdminLevel`, `Money`, `Gun1`, `Gun2`, `Gun3`, `Gun4`, `Gun5`, `Gun6`, `Gun7`, `Gun8`, `Gun9`, `Gun10`, `Ammo1`, `Ammo2`, `Ammo3`, `Ammo4`, `Ammo5`, `Ammo6`, `Ammo7`, `Ammo8`, `Ammo9`, `Ammo10`, `JailTime`, `JailReason`, `JailedBy`, `Exp`, `Level`) VALUES
(3, 'Takashi', 0, 0, 0, 'Kazuji_Takashi', 0, '', 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `ucpsystem`
--

CREATE TABLE `ucpsystem` (
  `ID` int(12) NOT NULL,
  `UCP` varchar(22) NOT NULL,
  `Password` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ucpsystem`
--

INSERT INTO `ucpsystem` (`ID`, `UCP`, `Password`) VALUES
(9, 'Kazuji_Takashi', '$2y$12$ZX4d9XCXyAfcXmxZmDQC1OgF1loITWc5DAZO0qtY9gJxn1R8RopvO');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `banned`
--
ALTER TABLE `banned`
  ADD PRIMARY KEY (`pID`);

--
-- Indexes for table `survivors`
--
ALTER TABLE `survivors`
  ADD PRIMARY KEY (`pID`);

--
-- Indexes for table `ucpsystem`
--
ALTER TABLE `ucpsystem`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `banned`
--
ALTER TABLE `banned`
  MODIFY `pID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `survivors`
--
ALTER TABLE `survivors`
  MODIFY `pID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `ucpsystem`
--
ALTER TABLE `ucpsystem`
  MODIFY `ID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
