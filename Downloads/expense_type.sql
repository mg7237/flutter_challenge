-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: easyleases-production.c00rif4ec40k.ap-south-1.rds.amazonaws.com
-- Generation Time: Dec 24, 2019 at 08:52 AM
-- Server version: 5.7.26-log
-- PHP Version: 7.1.32

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `easyleases_app_prod`
--

-- --------------------------------------------------------

--
-- Table structure for table `expense_type`
--

CREATE TABLE `expense_type` (
  `id` smallint(4) NOT NULL,
  `expense_code` varchar(10) NOT NULL,
  `expense_name` varchar(100) NOT NULL,
  `title` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `expense_type`
--

INSERT INTO `expense_type` (`id`, `expense_code`, `expense_name`, `title`) VALUES
(1, 'RNT', 'Rent', 'Rent'),
(2, 'ELC', 'Electricity', 'Electricity'),
(3, 'DTH', 'DTH', 'DTH'),
(4, 'WFI', 'Wifi', 'Wifi'),
(5, 'WTR', 'Water Tanker', 'Water Tanker'),
(6, 'BWB', 'BWSSB', 'BWSSB'),
(7, 'CXP', 'Cash Expenses', 'Cash Expenses'),
(8, 'GCR', 'Grocery', 'Grocery'),
(9, 'VEG', 'Veggie', 'Veggie'),
(10, 'MET', 'Meat', 'Meat'),
(11, 'LPG', 'LPG', 'LPG'),
(12, 'KTS', 'Kitchen Staff', 'Kitchen Staff'),
(13, 'HKS', 'Housekeeping Staff', 'Housekeeping Staff'),
(14, 'PNT', 'Painting', 'Painting'),
(15, 'DCL', 'Deep Cleaning', 'Deep Cleaning'),
(16, 'MTJ', 'Maintenance', 'Maintenance'),
(17, 'OTH', 'Others', 'Others'),
(18, 'BMP', 'BBMP', 'BBMP');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `expense_type`
--
ALTER TABLE `expense_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `expense_code` (`expense_code`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `expense_type`
--
ALTER TABLE `expense_type`
  MODIFY `id` smallint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
