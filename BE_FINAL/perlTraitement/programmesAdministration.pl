#! C:\Perl64\bin\perl.exe

use DBI;
require './perlTraitement/config.pl';

sub Minuscule{
	my($fichier)=$_[0];
	return lc$fichier;
}

sub RemplacerPonctuation{
	my($fichier)=$_[0];
	$fichier=~ s/[,;:\'\"\!\%\+\*\-\^\|\/\\\.\?\(\)\[\]]/ /gi;
	$fichier=~ s/ \s+/ /g;
	$fichier=~ s/^\s+//;
	$fichier=~ s/ \s+$//;
	$fichier=~ s/é/e/g;
	$fichier=~ s/è/e/g;
	$fichier=~ s/à/a/g;
	$fichier=~ s/â/a/g;
	$fichier=~ s/î/i/g;
	$fichier=~ s/ç/c/g;
	$fichier=~ s/ù/u/g;
	$fichier=~ s/û/u/g;
	return $fichier;
}

sub EliminerMotsVides {
	my($fichier,@vide)=@_;
	foreach my $mot (@vide){
		$fichier=~ s/\b$mot\b//ig;
	}
	return $fichier;
}

sub Segmenter{ 
	my($fichier)=$_[0];
	my(@liste)=split(' ',$fichier);
	return @liste;
}

sub Troncaturer{
	my(@liste)=@_;
	my($ligne);
	foreach $ligne (@liste){
		$ligne=substr($ligne,0,7);
	}
	return @liste;
}

sub Preparer{
	my($requete)=@_;
	
	my($texte)=&RemplacerPonctuation(&Minuscule($requete));
	my(@motsVides)=qw(a b c d e f g h i j k l m n o p q r s t u v w x y z où a de à lors au aux aucuns aussi autre avant avec avoir bon car cette ce cela ces ceux chaque ci comme comment dans des du dedans dehors depuis deux devrait doit donc dos droite début elle elles en encore essai est et eu fait faites fois font force haut hors ici il ils je juste la le les leur là ma maintenant mais mes mine moins mon mot même ni nommés notre nous nouveaux ou où par parce parole pas personnes peut peu pièce plupart pour pourquoi quand que quel quelle quelles quels qui sa sans ses seulement si sien son sont sous soyez sujet sur ta tandis tellement tels tes ton tous tout trop très tu valeur voie voient vont votre vous vu ça étaient état étions été être l m s se d du un une unes uns);

	$texte=&EliminerMotsVides($texte,@motsVides);
	my(@mots)=&Troncaturer(&Segmenter($texte));
	return @mots;
}


sub ExtraireLigne{
	my($id,$fichier)=@_;
 $id=~s/ //;
	open FILE,$fichier
	      or die "Le fichier $fichier ne peut être ouvert :$!";
	while(<FILE>){
	      chomp;
	
				return $_ if(/^$id\t.*/);
	      # }
	}
	close FILE;
	return "ko";
}

sub Documents{
	my($terme,$chemin)=@_;
	my $ligne=&ExtraireLigne($terme,$chemin);
	my(@liste)=split('\t',$ligne);
	

	my($cle);
	
	my(@listeDoc);
	my($cle);
	my(@liste2)=split(',',$liste[1]);
	foreach $cle (@liste2){
 
	      if ($cle=~m@(\d+):\d+@ig){
 		 # print $1."\n";
		  push(@listeDoc,$1);
		
	      }
	}
	return @listeDoc;
	
}

sub Nt{
      my($terme,$chemin)=@_;
      my(@doc)=&Documents($terme,$chemin);
     # print @doc;
      my($nombre) = $#doc+1;
      return $nombre;
}

sub SommeOc{
      my($terme,$numdoc,$chemin)=@_;
      my($ligne)=&ExtraireLigne($terme,$chemin);
	my(@liste)=split('\t',$ligne);
	my($cle);
	my $occ;
      my(@liste2)=split(',',$liste[1]);
	foreach $cle (@liste2){
	      if ($cle=~m@$numdoc:(\d+)@ig){
			$occ=$1;
			  
		  return $occ;
		
	      }
	}
}


sub RetourDoc{
my $id=$_[0];

my $con = &connexionBDD();

# REQUETE
my $req = $con->prepare('SELECT * FROM requetes_articles WHERE idrequete='.$id); #==> de l'id requete vers les docs retournés

# EXECUTE THE QUERY
$req->execute();

# BIND TABLE COLUMNS TO VARIABLES
$req->bind_columns(undef, \$idrequete, \$idarticle, \$rang, \$score, \$dateRD, \$timeRD, \$collection);

#LOOP THROUGH RESULTS
my @docs;
while($req->fetch()) {
	push(@docs,$idarticle);
}

# DECONNEXION
$req -> finish;
$con -> disconnect;

return @docs;

}

sub RetourTermes{
my $id=$_[0];

my $con = &connexionBDD();
# REQUETE
my $req = $con->prepare('SELECT * FROM requetes WHERE idrequetes='.$id); #==> de l'id requete vers les docs retournés

# EXECUTE THE QUERY
$req->execute();

# BIND TABLE COLUMNS TO VARIABLES
$req->bind_columns(undef, \$idrequetes, \$requete, \$dateR, \$timeR);

#LOOP THROUGH RESULTS
my @termes;
while($req->fetch()) {
	push(@termes,$requete);
}

# DECONNEXION
$req -> finish;
$con -> disconnect;

return @termes;

}

sub RetourRang{
my $id=$_[0];

my $con = &connexionBDD();
# REQUETE
my $req = $con->prepare('SELECT * FROM requetes_articles WHERE idrequete='.$id); #==> de l'id requete vers les docs retournés

# EXECUTE THE QUERY
$req->execute();

# BIND TABLE COLUMNS TO VARIABLES
$req->bind_columns(undef, \$idrequete, \$idarticle, \$rang, \$score, \$dateRD, \$timeRD, \$collection);

#LOOP THROUGH RESULTS
my %scores;
while($req->fetch()) {
	$scores{$rang}=$score*100+1;
}

# DECONNEXION
$req -> finish;
$con -> disconnect;

return %scores;

}


sub ModifMod{
my $mod=$_[0];
my $con = &connexionBDD();
my $res;
my $valeur=&methodeCalculScore();

	if ($valeur eq $mod){
		$res=0;
	}
	else{
		my $query = "UPDATE config SET valeur=\"$mod\" WHERE attribut=\"modele\"";
		my $query_handle = $con->prepare($query);
		$query_handle->execute();
		$query_handle -> finish;
		$res=1;
	}
 

# DECONNEXION
$con -> disconnect;

}

sub ModifColl{
my $coll=$_[0];
my $con = &connexionBDD();

my $valeur= &nomCollection;
my $cheminCollection=&collectionUtilisee;
my $res;
#LOOP THROUGH RESULTS
if ($valeur eq $coll){
	$res=0;
}
else{
	$cheminCollection=~s/$valeur/$coll/ig;
	my $query = "UPDATE config SET valeur=\"$cheminCollection\" WHERE attribut=\"indexPath\"";
	my $query_handle = $con->prepare($query);
	$query_handle->execute();
	$res=1;
	# DECONNEXION
	$query_handle -> finish;
} 
$con -> disconnect;
return $res;
}

sub Maximum{
	my $ligne=$_[0];
	my @liste=split(/,/,$ligne);
	my $max=0;
	foreach my $e (@liste){
			if ($e>$max){
					$max=$e;
			}
	}
	return $max;	
}
1;