-- phpMyAdmin SQL Dump
-- version 4.0.4
-- http://www.phpmyadmin.net
--
-- Client: localhost
-- Généré le: Dim 23 Mars 2014 à 18:33
-- Version du serveur: 5.6.12-log
-- Version de PHP: 5.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `be`
--
CREATE DATABASE IF NOT EXISTS `be` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `be`;

-- --------------------------------------------------------

--
-- Structure de la table `articles`
--

DROP TABLE IF EXISTS `articles`;
CREATE TABLE IF NOT EXISTS `articles` (
  `idA` int(11) NOT NULL DEFAULT '0',
  `titre` tinytext,
  `dateA` date DEFAULT NULL,
  `url` tinytext,
  `collection` varchar(4) CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (`idA`,`collection`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `articles_categories`
--

DROP TABLE IF EXISTS `articles_categories`;
CREATE TABLE IF NOT EXISTS `articles_categories` (
  `ida` int(11) NOT NULL DEFAULT '0',
  `idC` int(11) NOT NULL DEFAULT '0',
  `collection` varchar(4) CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (`ida`,`idC`,`collection`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `articles_sources`
--

DROP TABLE IF EXISTS `articles_sources`;
CREATE TABLE IF NOT EXISTS `articles_sources` (
  `ida` int(11) DEFAULT NULL,
  `titreS` tinytext,
  `collection` varchar(4) CHARACTER SET utf8 NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `articles_tags`
--

DROP TABLE IF EXISTS `articles_tags`;
CREATE TABLE IF NOT EXISTS `articles_tags` (
  `ida` int(11) NOT NULL DEFAULT '0',
  `idT` int(11) NOT NULL DEFAULT '0',
  `collection` varchar(3) CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (`ida`,`idT`,`collection`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `idC` int(11) NOT NULL DEFAULT '0',
  `titreC` tinytext,
  `collection` varchar(4) CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (`idC`,`collection`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `config`
--

DROP TABLE IF EXISTS `config`;
CREATE TABLE IF NOT EXISTS `config` (
  `attribut` text NOT NULL,
  `valeur` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `notations`
--

DROP TABLE IF EXISTS `notations`;
CREATE TABLE IF NOT EXISTS `notations` (
  `idrequete` int(11) NOT NULL DEFAULT '0',
  `idarticle` int(11) NOT NULL DEFAULT '0',
  `note` int(11) DEFAULT NULL,
  `dateN` date DEFAULT NULL,
  `timeN` time DEFAULT NULL,
  `collection` varchar(4) NOT NULL DEFAULT '',
  PRIMARY KEY (`idrequete`,`idarticle`,`collection`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `requetes`
--

DROP TABLE IF EXISTS `requetes`;
CREATE TABLE IF NOT EXISTS `requetes` (
  `idrequetes` int(11) NOT NULL AUTO_INCREMENT,
  `requete` text,
  `dateR` date DEFAULT NULL,
  `timeR` time NOT NULL,
  PRIMARY KEY (`idrequetes`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=280 ;

-- --------------------------------------------------------

--
-- Structure de la table `requetes_articles`
--

DROP TABLE IF EXISTS `requetes_articles`;
CREATE TABLE IF NOT EXISTS `requetes_articles` (
  `idrequete` int(11) NOT NULL DEFAULT '0',
  `idarticle` int(11) NOT NULL DEFAULT '0',
  `rang` int(11) DEFAULT NULL,
  `score` decimal(11,3) DEFAULT NULL,
  `dateRD` date NOT NULL,
  `timeRD` time NOT NULL,
  `collection` varchar(4) NOT NULL DEFAULT '',
  PRIMARY KEY (`idrequete`,`idarticle`,`collection`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `sources`
--

DROP TABLE IF EXISTS `sources`;
CREATE TABLE IF NOT EXISTS `sources` (
  `titreS` tinytext,
  `langue` tinytext,
  `auteur` tinytext,
  `date_source` date DEFAULT NULL,
  `lien` text,
  `collection` varchar(4) CHARACTER SET utf8 NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `tags`
--

DROP TABLE IF EXISTS `tags`;
CREATE TABLE IF NOT EXISTS `tags` (
  `idT` int(11) NOT NULL DEFAULT '0',
  `tag` tinytext,
  `collection` varchar(3) CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (`idT`,`collection`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
