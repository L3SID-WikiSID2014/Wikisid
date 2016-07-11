#! C:\Perl64\bin\perl.exe


#Connexion a la base de donnees
	# #Parametres d'entrees : Driver, serveur, utilisateur, motDePasse, baseDeDonnee#
	# Parametre de sortie : configuration
sub connexionBDD {
	my $driver="DBI:mysql";
	my $serveur="localhost";
	my $utilisateur="root";
	my $motDePasse="";
	my $baseDeDonnee="be2013";
	#Connexion
	my $con = DBI->connect( $driver.":".$baseDeDonnee.";host=".$serveur,$utilisateur,$motDePasse) || die "probleme de connexion a la base de donnees : $DBI::errstr";
	return $con;
}

#Deconnexion de la base de donnees
	# Parametres d'entrees : requete, connexion
	# Parametre de sortie : configuration
sub deconnexionBDD {
	$_[0] -> finish;
	$_[1] -> disconnect;
}


#Récupère le nom de la collection utilisée
	# Parametres d'entrées :
	# Retourne le nom de la collection
sub nomCollection {
	my $adresse=&collectionUtilisee();
	
	if ($adresse=~m/wiki/i){
		return "wiki";
	}
	else {
		return "JDG";
	}
}

#Définit la collection utilisée
# Parametre d'entree :
# Paramètre de sortie : chemin de la collection utilisée
sub collectionUtilisee {
	my $con=&connexionBDD;
	my $requete = $con->prepare("SELECT valeur FROM config WHERE attribut like 'IndexPath'");
	$requete->execute();
	$requete->bind_columns(undef, \my $valeur);
	$requete->fetch();
	my $collection=$valeur;
	&deconnexionBDD($requete,$con);
	
	return $collection;
}

#Définit le calcul du score utilisée
# Parametre d'entree :
# Paramètre de sortie : methode de calcul du score
sub methodeCalculScore {
	my $con=&connexionBDD;
	my $requete = $con->prepare("SELECT valeur FROM config WHERE attribut like 'modele'");
	$requete->execute();
	$requete->bind_columns(undef, \my $valeur);
	$requete->fetch();
	my $modele=$valeur;
	&deconnexionBDD($requete,$con);
	return $modele;
 }
1;