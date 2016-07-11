#! C:\Perl64\bin\perl.exe

use strict; 
use warnings; 
use DBI;
use POSIX qw/strftime/;

require './perlTraitement/config.pl';

## MISE EN FORME DU TEXTE ##

#Passe toute les cotes double cote
	#parametre d'entree: liste
	#Retourne un scalaire
sub doublecote{
	my $code=$_[0];
	$code=~s@'@''@g;
	$code=~s@&amp;@@ig;
	return ($code);
}


###########################################

## EXPLOITATION BASE DE DONNEES ##


#Ajout d'un tuple dans la table Requetes
	# Parametres d'entrées : recherche
	# Retourne l'id de la requete créée, la date et l'heure
sub insererRequetes {

	my $recherche=$_[0];
	
	my $date = strftime("%Y-%m-%d", localtime());
	my $heure = strftime("%H:%M:%S", localtime());
	
	#Connexion à la base de données
	my $con=&connexionBDD;

	# Insertion de la requete dans la table  Requetes
	my $requete = $con->prepare("INSERT INTO requetes (requete,dateR,timeR) VALUES ('".&doublecote($recherche)."','".$date."','".$heure."')");
	$requete->execute();
	
	#Récuperation de l'id de la requete créée
	$requete = $con->prepare("SELECT idRequetes FROM requetes WHERE dateR='". $date ."' AND timeR='". $heure . "'");
	$requete->execute();
	$requete->bind_columns(undef, \my $idRequetes);
	$requete->fetch();
	my $identifiant=$idRequetes;
	
	#Déconnexion de la BDD
	&deconnexionBDD($requete,$con);
	
	return ($identifiant, $date, $heure);
}

#Ajout d'un tuple dans la table Requetes_article
	# Parametres d'entrees : idRequetes, idArticle, rang, score, dateRD, timeRD, collection
	# Parametre de sortie : Aucun
sub insererRequeteArticle {
	my $idRequete=$_[0];	my $idArticle=$_[1];	my $rang=$_[2];
	my $score=$_[3];	my $dateRD=$_[4];	my $timeRD=$_[5];	my $collection=$_[6];
	
	my $con=&connexionBDD;
	# Insertion de la requete dans la table  Requetes
	my $requete = $con->prepare("INSERT INTO requetes_articles VALUES (".$idRequete.",".$idArticle.",".$rang.",".$score.",'".$dateRD."','".$timeRD."','".$collection."')");
	$requete->execute();
	
	#Deconnexion de la BDD
	&deconnexionBDD($requete,$con);
}

#Ajout d'un tuple dans la table notation
	# Parametres d'entrees : idArticle, collection, note, idRequete
	# Parametre de sortie : Aucun
sub noterArticle {
	my $idArticle=$_[0];
	my $collection=$_[1];
	my $note=$_[2];
	my $idRequete=$_[3];
	my $date = strftime("%Y-%m-%d", localtime());
	my $heure = strftime("%H:%M:%S", localtime());
	
	my $con=&connexionBDD;
	# Insertion de la requete dans la table  Requetes
	my $requete = "INSERT INTO notations VALUES (".$idRequete.",".$idArticle.",".$note.",'".$date."','".$heure."','".$collection."')";
	my $query_handle = $con->prepare($requete);
	$query_handle->execute();
	
	#Deconnexion de la BDD
	&deconnexionBDD($query_handle,$con);
}

#Modification d'un tuple dans la table notation
	# Parametres d'entrees : idArticle, collection, note, idRequete
	# Parametre de sortie : Aucun
sub modifierNoteArticle {
	my $idArticle=$_[0];
	my $collection=$_[1];
	my $note=$_[2];
	my $idRequete=$_[3];
	my $date = strftime("%Y-%m-%d", localtime());
	my $heure = strftime("%H:%M:%S", localtime());
	
	my $con=&connexionBDD;
	
	my $requete = "UPDATE notations SET note=".$note.", dateN='".$date."', timeN='".$heure."' WHERE idRequete=".$idRequete." AND idArticle=".$idArticle." AND collection like '".$collection."'";
	my $query_handle = $con->prepare($requete);
	$query_handle->execute();
	
	&deconnexionBDD($query_handle,$con);
}

#Regarde si une note a déjà été ajoutée
	# Parametres d'entrees : idRequete, idArticle, collection
	# Parametre de sortie : Aucun
sub dejaNote {
	my $idRequete=$_[0];
	my $idArticle=$_[1];
	my $collection=$_[2];
	
	my $dejaNote=0;
	my $con=&connexionBDD;
	
	my $requete = $con->prepare("SELECT COUNT(note) As requeteNbNote FROM notations WHERE idArticle=". $idArticle ." AND collection='". $collection . "' AND idRequete=".$idRequete." GROUP BY idArticle,collection");
	$requete->execute();
	$requete->bind_columns(undef, \my $requeteNbNote);
	$requete->fetch();
	my $nbNote=$requeteNbNote;

	if ($nbNote > 0){
		$dejaNote=1;
	}
	
	&deconnexionBDD($requete,$con);
	return $dejaNote;
}

#Récuperer la note moyenne d'un article
	# Parametres d'entrées : idArticle, collection
	# Retourne la moyenne
sub noteMoyenne {

	my $idArticle=$_[0];
	my $collection =$_[1];
	
	#Connexion à la base de données
	my $con=&connexionBDD;
	
	#Récuperation de l'id de la requete créée
	my $requete = $con->prepare("SELECT AVG(note) FROM notations WHERE idArticle=". $idArticle ." AND collection='". $collection . "' GROUP BY idArticle,collection");
	$requete->execute();
	$requete->bind_columns(undef, \my $moyenne);
	$requete->fetch();
	my $moyenneNote=$moyenne;
	
	#Déconnexion de la BDD
	&deconnexionBDD($requete,$con);
	return sprintf ("%0.1f",$moyenneNote);
}

#Récupère les informations sur l'article
	# Parametres d'entrées : idArticle, collection
	# Retourne les informations sur l'article
sub recupererInformations {
	my $idArticle=$_[0];
	my $collection=$_[1];
	
	#Connexion à la base de données
	my $con=&connexionBDD;
	
	#Récuperation de l'id de la requete créée
	my $requete = $con->prepare("SELECT titre, dateA, url FROM articles WHERE collection='".$collection."' AND idA=".$idArticle);
	$requete->execute();
	$requete->bind_columns(undef, \my $titreR, \my $dateR, \my $urlR);
	$requete->fetch();
	my ($titre, $date, $url)= ($titreR,$dateR,$urlR);
	
	#Déconnexion de la BDD
	&deconnexionBDD($requete,$con);
	return $titre, $date, $url;
}

#Récupère les catégories d'un article
	# Parametres d'entrées : idArticle, collection
	# Retourne les categories de l'article
sub recupererCategories {
	my $idArticle=$_[0];
	my $collection=$_[1];
	
	#Connexion à la base de données
	my $con=&connexionBDD;
	
	#Récuperation de l'id de la requete créée
	my $requete = $con->prepare("SELECT titreC FROM articles_categories AC, categories C WHERE C.idC=AC.idC AND AC.collection='".$collection."' AND C.collection='".$collection."' AND idA=".$idArticle);
	$requete->execute();
	$requete->bind_columns(undef, \my $titreC);
	my @listeCategorie;
	while ($requete->fetch()){
		@listeCategorie=(@listeCategorie,$titreC);
	}
	
	#Déconnexion de la BDD
	&deconnexionBDD($requete,$con);
	return @listeCategorie;
}

#Récupère les informations sur l'article
	# Parametres d'entrées : idArticle, collection
	# Retourne la moyenne
sub recupererTAG {
	my $idArticle=$_[0];
	my $collection=$_[1];
	
	#Connexion à la base de données
	my $con=&connexionBDD;
	
	#Récuperation de l'id de la requete créée
	my $requete = $con->prepare("SELECT tag FROM tags T, articles_tags AT WHERE T.idT=AT.idT AND AT.collection='".$collection."' AND T.collection='".$collection."' AND idA=".$idArticle);
	$requete->execute();
	$requete->bind_columns(undef, \my $tag);
	my @listeTAG;
	while ($requete->fetch()){
		@listeTAG=(@listeTAG,$tag);
	}
	
	#Déconnexion de la BDD
	&deconnexionBDD($requete,$con);
	return @listeTAG;
}

#Récupère seulement les documents correspondants aux critères de recherche
	# Parametres d'entrées : idDocument, collection, titre, categorie, $date
	# Retourne si le document pourrait être pertinant
sub pertinenceAvancee {

	my $idDocument=$_[0];
	my $collection=$_[1];
	my $titre=$_[2];
	my $categorie=$_[3];
	my $date=$_[4];
	
	my $pertinence;
	
	my $con=&connexionBDD();
	my$requete = $con->prepare("SELECT count(*) as Res FROM Articles A, Categories C, Articles_Categories AC WHERE A.idA = AC.idA AND AC.idC = C.idC AND A.collection = C.collection AND AC.collection = C.collection AND A.collection = AC.collection AND A.collection ='".$collection."' AND titre like '%".$titre."%' AND titreC LIKE '%".$categorie."%' AND dateA LIKE '%".$date."%' AND A.idA =".$idDocument);
	$requete->execute();
	$requete->bind_columns(undef, \my $res);
	$requete->fetch();
	
	if ($res > 0){
		$pertinence=1;
	}
	else {
		$pertinence=0;
	}
	&deconnexionBDD($requete,$con);
	return $pertinence;
}

1;