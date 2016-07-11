#! C:\Perl64\bin\perl.exe
use strict;
require './perlTraitement/config.pl';

my @motsVides=qw(au aux a avec ce ces dans de des du elle en et eux il je la le leur lui ma mais me même mes moi mon ne nos notre nous on ou par pas pour qu que qui sa se ses son sur ta te tes toi ton tu un une unes vos votre vous c d j à m n s t y es est eu eue eus eues ai as ont avez eût ceci cela celà cet cette ici ils les leurs quel quels quelle quelles sans soi toi ça); 

#Lire les lignes d'un fichier texte
# Parametre d'entree : chemin du fichier
# Paramètre de sortie : scalaire
sub lirefichier {
  my($fichier)=@_;
  my($texte)=do{
    local $/ = undef;
    open my($fh), "<", $fichier or die "Le fichier $fichier ne peut être ouvert:$!";
    <$fh>;
 };
  return $texte;
}

# Transformer les lettres en minuscules
# Parametre d'entree : scalaire
# Paramètre de sortie : scalaire
sub minuscule {
  my ($fichier)=@_; # lit le premier parametre
  return lc $fichier;
}

# Remplacer la ponctuation
# Parametre d'entree : scalaire
# Paramètre de sortie : scalaire
sub remplacerponctuation{
  my($fichier)=$_[0];
  $fichier=~ s@[<>;,.:'’"!%+\*\-\|\/\\\?\(\)\[\]]@ @ig;
  $fichier=~s@È|É|Ê|Ë|è|é|ê|ë@e@ig;
  $fichier=~s@À|Á|Á|Â|Ã|Ä@a@ig;
  $fichier=~s@ç|Ç@c@ig;
  $fichier=~s@Ì|Í|Î|Ï|ì|í|î|ï@i@ig;
  $fichier=~s@Ò|Ó|Ô|Õ|Ö|ò|ó|ô|õ|ö@o@ig;
  $fichier=~s@Ù|Ú|Û|Ü|ù|ú|û|ü@u@ig;
  $fichier=~s@à|á|â|ã|ä|å@a@ig;
  $fichier=~ s@\s+@ @g;
  $fichier=~ s@̂\s+@@;
  $fichier=~ s@\s+$@@;
  return $fichier;
}

# Eliminer les mots vides d'un texte
# Parametre d'entree : scalaire, liste de mots vides
# Paramètre de sortie : scalaire
sub motsvides{
  my ($fichier,@liste)=@_;
  foreach my $mot(@liste){
    $fichier=~ s@\s$mot\s@ @ig;
  }
  $fichier=~ s@\s+@ @g;
  $fichier=~ s@̂ \s+@@;
  $fichier=~ s@\s+$@@;
  return $fichier;
}

#Segmenter
# Parametre d'entree : scalaire
# Paramètre de sortie : liste
sub segmenter{
  my($fichier)=$_[0];
  my @liste=split(' ',$fichier);
  return @liste;
}

# Troncature
# Parametre d'entree : liste
# Paramètre de sortie : liste
sub troncature{
  my(@fichier)=@_;
  foreach my $mot(@fichier){
    $mot=substr($mot,0,7);
  }
  return @fichier;
}

# Liste les documents d'une collection
# Parametre d'entree : scalaire contenant le chemin de la collection
# Paramètre de sortie : liste
sub listerDocuments {
  my ($collection)=@_;
  my $indexDirect=$collection . "indexDirect.txt";
  my @fichier=split("\n",&lirefichier($indexDirect));
  my @documents;
  foreach my $ligne (@fichier){
	$ligne=~m@(.*)\t@i;
	@documents=(@documents, $1);
  }
  return @documents;
}

# Préparer une requete
# Parametre d'entree : scalaire contenant la requete
# Paramètre de sortie : liste
sub preparer {
  my $requete=$_[0];
  $requete=&minuscule($requete);
  $requete=&remplacerponctuation($requete);
  $requete=&motsvides($requete,@motsVides); 
  my @liste=&segmenter($requete);
  @liste=&troncature(@liste);
  return @liste;
}

# Retourne la liste des documents qui contiennent le terme passé en paramètre
# Parametre d'entree : terme recherché, chemin de la collection utilisée
# Paramètre de sortie : liste de documents
sub documents {
   my $terme=$_[0];
   my $chemin=$_[1];
   my $posting=$chemin."posting.txt";
   my @documents;
   my $mot;
   open FILE,$posting;
   while(<FILE>){
     chomp;
      $mot=$_ if(/^$terme\s*\t/);
   }
   close FILE;
   chomp $mot;
   $mot=~s/^$terme\t//ig;
   $mot=~s/:[0-9]+//ig;
   @documents=split(',',$mot);
   return @documents;
}

# Calcul de  N
# Parametre d'entree : chemin de la collection
# Paramètre de sortie : nombre de documents dans la collection
sub N{
  my $nbDocuments=&listerDocuments($_[0]);
  return $nbDocuments;
}

# Calcul de  Nt
# Parametre d'entree : terme, chemin de la collection
# Paramètre de sortie : nombre
sub Nt{
  my $terme=$_[0];
  my $chemin=$_[1];
  my $nbDocuments=&documents($terme,$chemin);
  return $nbDocuments;
}

# Calcul du TF
# Parametre d'entree : document, terme, adresse de la collection
# Paramètre de sortie : nombre
sub TF{
  my $document=$_[0];
  my $terme=$_[1];
  my $indexDirect=$_[2]."indexDirect.txt";
  my $ligne='';
  my $tf;
  open FILE,$indexDirect;
   while(<FILE>){
     chomp;
      if(/^$document\t+/i){
	  $ligne=$_;
	  }
   }   
   close FILE;  
    if($ligne=~m/$terme:([0-9]+),/i) {
      $tf=$1;
    }
    else {
      $tf=0;
    }
	return $tf;
}

# Calcul du TFIDF
# Parametre d'entree : tf, Nt, N
# Paramètre de sortie : nombre
sub TFIDF{
 my $tf=$_[0];
  my $Nt=$_[1];
  my $N=$_[2];
  my $tfidf;
  if ($Nt == 0 or $tf == 0){
    $tfidf=0;
  }
  else {
    $tfidf=(1+log($tf))*log($N/$Nt);
  }
  return $tfidf;
}

# Calcul de la frequence d'un terme
# Parametre d'entree : terme, liste de terme
# Paramètre de sortie : nombre
sub frequenceTerme {
   my ($terme,@liste)=@_;
   my $frequence=0;
   my $nbMots=@liste;
   foreach my $mot(@liste){
      if ($mot=~m/$terme/i){
		$frequence++;
      }
   }
   $frequence=$frequence/$nbMots;
    return $frequence;
}

# Calcul du score Cosinus
# Parametre d'entree : idDocument, collection, requete
# Paramètre de sortie : score
sub scoreCosinus{
	my ($document, $collection, @requete)=@_;
	my $sommeqw=0;
	my $q2=0;
	my $w2=0;
	my $score=0;
	foreach my $mot (@requete){
		my $q=&frequenceTerme($mot,@requete); #Poids du mot dans la requete
		my $w=&TFIDF(&TF($document,$mot,$collection),&Nt($mot,$collection),&N($collection)); #Poids du mot dans la collection 
		$sommeqw=$sommeqw + ($q*$w);
		$q2=$q2+($q*$q);
		$w2=$w2+($w*$w);
	}
	if ($w2 != 0){
		my $x=$q2 * $w2;
		$x=sqrt($x);
		$score=$sommeqw / $x;
		return $score;
	}
	else {
		return 0;
	}
}

# Calcul du score Inner Product
# Parametre d'entree : idDocument, collection, requete
# Paramètre de sortie : score
sub scoreInnerProduct{
	my ($document, $collection, @requete)=@_;
	my $sommeqw=0;
	foreach my $mot (@requete){
		my $q=&frequenceTerme($mot,@requete); #Poids du mot dans la requete
		my $w=&TFIDF(&TF($document,$mot,$collection),&Nt($mot,$collection),&N($collection)); #Poids du mot dans la collection 
		$sommeqw=$sommeqw+($q*$w);
	}
	return $sommeqw;
}

# Evalue une requete
# Parametre d'entree : requete, collection, methode de calcul
# Paramètre de sortie : liste contenant le document
sub evaluerRequete{
	my ($requete,$collection, $methodeCalcul)=@_;
	my @documents=&listerDocuments($collection);
	my @requete=&preparer($requete);
	my @liste;
	
	if ($methodeCalcul eq 'InnerProduct'){
		foreach my $document (@documents){
			@liste=(@liste,[$document,sprintf ("%0.3f",&scoreInnerProduct($document,$collection, @requete))]);
		}
	}
	else {
		foreach my $document (@documents){
			@liste=(@liste,[$document,sprintf ("%0.3f",&scoreCosinus($document,$collection, @requete))]);
		}
	}
	@liste= reverse sort {$$a[1] <=>$$b[1]} @liste;
	return @liste;
}

#Affichage des résultats
sub afficher{
	my @pertinance=@_;
	my $nb=@pertinance-1;
	for (my $i = 0; $i <= $nb; $i++){
		print "<".$pertinance[$i][0].",".$pertinance[$i][1].">\n";
	}
}

  
# Normaliser les scores d'une requete
# Parametre d'entree : tableau de pertinence
# Paramètre de sortie : tableau de pertinence normalisee
sub normalisationScores{
	my @pertinence=@_;
	my @scoreNormalise;
	my $nb=@pertinence-1;
	my $sommesi;
	for (my $i = 0; $i <= $nb; $i++){
		$sommesi=$sommesi+$pertinence[$i][1];
	}
	if ($sommesi!=0){
	for (my $i = 0; $i <= $nb; $i++){
		my $score=($pertinence[$i][1])/$sommesi;
		@scoreNormalise=(@scoreNormalise,[$pertinence[$i][0],sprintf ("%0.3f",$score)]);
	}
	}
	return @scoreNormalise;
}

sub evaluerRequeteAvancee{
	my ($terme,$cheminCollection,$methodeCalcul,$dateA,$titreA,$categA)=@_;
	my @documents=&listerDocuments($cheminCollection);
	my @requete=&preparer($terme);
	my @liste;
	my $collection=&nomCollection();

	if ($methodeCalcul eq 'InnerProduct'){
		foreach my $document (@documents){			
			if (&pertinenceAvancee($document,$collection,$titreA,$categA,$dateA)){
				@liste=(@liste,[$document,sprintf ("%0.3f",&scoreInnerProduct($document, $cheminCollection, @requete))]);
			}
		}
	}
	else {
		foreach my $document (@documents){
			if (&pertinenceAvancee($document,$collection,$titreA,$categA,$dateA)){
				@liste=(@liste,[$document,sprintf ("%0.3f",&scoreCosinus($document, $cheminCollection, @requete))]);
			}
		}
	}
	
	@liste= reverse sort {$$a[1] <=>$$b[1]} @liste;
	return @liste;
}


#Teste les programmes
# sub test {
# my $collection=&collectionUtilisee('C:/wamp/www/BE/data/config.txt');
# my $calcul=&methodeCalculScore('C:/wamp/www/BE/data/config.txt');
# my @listeCollection=&listerDocuments($collection);
# print $calcul;
# my @res=&evaluerRequete("france echeque",$collection,$calcul);
# print "Scores : \n";
# &afficher(@res);
# print "\nScores normalisés";
# my @resNorm=&normalisationScores(@res);
# &afficher(@resNorm);
# }
# &test();
1;
