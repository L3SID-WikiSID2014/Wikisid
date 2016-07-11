#! C:\Perl64\bin\perl.exe

use DBI;
use CGI qw(:all);
# use strict;
use warnings;
require './perlTraitement/config.pl';

#entete
print("Content-type: text/html \n
<html>
<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf8\" />

<script type=\"text/javascript\" src=\"bootstrap/js/jquery.min.js\"></script>
<script type=\"text/javascript\" src=\"bootstrap/js/jquery.awesomeCloud-0.2.min.js\"></script>
<script type=\"text/javascript\" src=\"bootstrap/js/Chart.js\" ></script>
<script type=\"text/javascript\" src=\"bootstrap/js/stat.js\"></script>
<link rel=\"stylesheet\" type=\"text/css\" href=\"bootstrap/css/stat.css\" />
<meta name=\"description\" content=\"Wiki GEEK SID - Statistiques\" />\n
<meta name=\"keywords\" content=\"Wiki GEEK SID Statistiques\" />\n
<title>Wiki GEEK SID - Statistiques</title>\n
</head>
<body id=\"stat_logo\">");

###connection bdd
my $con=&connexionBDD();

#constantes
# @colors=split(/;/,"\"#D97041\";\"#C7604C\";\"#21323D\";\"#9D9B7F\";\"#7D4F6D\";\"#584A5E\";\"#48A497\";\"#48A4D1\"");
@colors=split(/;/,"#D97041;#C7604C;#21323D;#9D9B7F;#7D4F6D;#584A5E;#48A497;#48A4D1");
$longeur_graph=800;
$hauteur_graph=450;
$nbMotMaxCloud=400;
%nomsite=q();
$nomsite{'wiki'}="wikinews";
$nomsite{'JDG'}="journal du geek";

#récupération des paramètres dans l'url
$idRequete=NULL;
$idDocument=NULL;
$collection=NULL;
$TYPE=NULL;
$idRequete=param("requete");
$idDocument=param("idDocument");
$collection=param("collection");
if (($idRequete)&&(!$idDocument)&&(!$collection)) {
	$TYPE=1;
} elsif ((!$idRequete)&&($idDocument)&&($collection)) {
	$TYPE=2;
} else {
	print("erreur de paramètres");
}

###sous-programmes
sub Doughnut_score {
	my ($id,$w,$h,$scoref)=@_;
	print("
				<canvas id=\"Doughnut_score$id\" width=\"$w\" height=\"$h\"></canvas>
				<script>
					var Data = [ { value : $scoref, color: \"#99AA61\" }, { value : 1-$scoref, color: \"#C7604C\" } ]
					var option = { segmentStrokeWidth : 1, percentageInnerCutout : 35, animation : false }
					var Doughnut_score$id = document.getElementById(\"Doughnut_score$id\").getContext(\"2d\");
					new Chart(Doughnut_score$id).Doughnut(Data,option);
				</script>
	");
}

sub build_wordclound {
	my (%freqmot)=@_;
	my @listemots=();
	my @listepoids=();
	foreach my $mot (reverse sort { $freqmot{$a} cmp $freqmot{$b} } keys %freqmot){
		push(@listemots,$mot);
		push(@listepoids,(int($freqmot{$mot})));
	}
	
	#rangement dans l'ordre décroissant des poids
	my %TMPpoids=();
	my %TMPmots=();
	for (my $i=0;$i<@listepoids;$i++){
		my ($ent,$dec) = split(/,/,$listepoids[$i]);
		my $l=length($ent);
		if (!exists $TMPpoids{$l}){
			$TMPpoids{$l}=join("",$listepoids[$i],";");
			$TMPmots{$l}=join("",$listemots[$i],";");
		} else {
			$TMPpoids{$l}=join($listepoids[$i],$TMPpoids{$l},";");
			$TMPmots{$l}=join($listemots[$i],$TMPmots{$l},";");
		}
	}
	@listemots=();
	@listepoids=();
	foreach my $t (reverse sort keys %TMPpoids) {
		push(@listepoids,split(/;/,$TMPpoids{$t}));
		push(@listemots,split(/;/,$TMPmots{$t}));
	}

	#changement d'intervalle des poids (lissage)
	@listepoids=interv_change(@listepoids);

	my @bloc=();
	foreach (my $i=0;$i<@listemots;$i++){
			if ($i<$nbMotMaxCloud){
			my $tmp = "<span data-weight=\"$listepoids[$i]\">$listemots[$i]</span>";
			push(@bloc,$tmp);
		}
	}
	my $bloc = join('', @bloc);
	
	return ($bloc,@listemots);
}

sub interv_change {
	my(@listepoids)=@_;
	my $max=-1;
	foreach my $n (@listepoids){
		$n=log($n**8+exp(4));
		if ($n>$max) {$max=$n;}
	}
	foreach my $n (@listepoids){
		$n=$n/$max;
		$n=exp($n+4)-exp(4);
	}
	return @listepoids;
}

sub wordcloud {
	my ($blocMots)=@_;
	print("
		<div class =\"graphs\" id=\"wdc\">$blocMots</div>
		<script>
			\$(document).ready(function(){
				\$(\"#wdc\").awesomeCloud({
					\"size\" : {
						\"grid\" : 16,
						\"factor\" : 1
					},
					\"options\" : {
						\"color\" : \"random-dark\",
						\"rotationRatio\" : 0.35,
					},
					\"font\" : \"'Times New Roman', Times, serif\",
					\"shape\" : \"square\"
				});
			});
		</script>
	");
}

sub graph_mots {
	my($longeur_graph,$hauteur_graph,$scaleSteps,$scaleStepWidth,$scaleStartValue,$labels,%datab)=@_;
	print("\n\t\t<canvas class =\"graphs\" id=\"g_m\" width=\"$longeur_graph\" height=\"$hauteur_graph\"></canvas>
		<script>
			var barData = {
				labels : [$labels],
				datasets : [
	");
	my @datasets=();
	my $i=0;
	foreach my $idA (keys %datab){
		push(@datasets,"
					{
						fillColor : \"$colors[$i]\",
						data : [$datab{$idA}]
					}");
		$i++;
	}
	$datasets=join(',',@datasets);
	
	print("$datasets");
	print("
				]
			}
			var option = {	
				scaleOverride : true,
				scaleSteps : $scaleSteps,
				scaleStepWidth : $scaleStepWidth,
				scaleStartValue : $scaleStartValue,
				barStrokeWidth : 1,
				barValueSpacing : 16,
				barDatasetSpacing : 1,
				animation : false
			}
			var g_m = document.getElementById(\"g_m\").getContext(\"2d\");
			new Chart(g_m).Bar(barData,option);
		</script>
	");
}

sub graph_cat {
my($longeur_graph,$hauteur_graph,$scaleSteps,$scaleStepWidth,$scaleStartValue,$labels,$listepoids)=@_;
print("\n\t\t<canvas class =\"graphs\" id=\"g_c\" width=\"$longeur_graph\" height=\"$hauteur_graph\"></canvas>
		<script>
			var barData = {
				labels : [$labels],
				datasets : [ 
					{
						fillColor : \"rgba(73,188,170,0.4)\",
						data : [$listepoids]
					}
				]
			}
			var option = {
				scaleOverride : true,
				scaleSteps : $scaleSteps,
				scaleStepWidth : $scaleStepWidth,
				scaleStartValue : $scaleStartValue,
				scaleLineColor : \"rgba(50,50,50,0.2)\",
				animation : false
			}
			var g_c = document.getElementById(\"g_c\").getContext(\"2d\");
			new Chart(g_c).Radar(barData,option);
		</script>\n");
}

sub shuffled {
	my @ordered = @_;
	my @shuffled = ();
	while (@ordered) {
		my $i = int(rand() * @ordered);
		push @shuffled, $ordered[$i];
		splice(@ordered, $i, 1);
	}
	return @shuffled;
}

###Affichage du menu
if ($TYPE==1){
	print("
	<div class=\"menu\">
		<div class=\"bouton\" id=\"btn_requete\" onclick=\"javascript:cacher();javascript:afficher('requete');\">Liste des articles</div>
		<div class=\"bouton\" id=\"btn_wordcloud\" onclick=\"javascript:cacher();javascript:afficher('wordcloud');\">Nuage de mots</div>
		<div class=\"bouton\" id=\"btn_graph_mots\" onclick=\"javascript:cacher();javascript:afficher('graph_mots');\">Répartition des mots</div>
		<div class=\"bouton\" id=\"btn_graph_cat\" onclick=\"javascript:cacher();javascript:afficher('graph_cat');\">Catégories</div>
		<div class=\"bouton\" id=\"btn_all\" onclick=\"javascript:afficher('btn_all');\">Afficher tout</div>
		<div class=\"clear\"></div>
	</div>
	");
}
elsif ($TYPE==2){
	print("
	<div class=\"menu\">
		<div class=\"bouton\" id=\"btn_wordcloud\" onclick=\"javascript:cacher2();javascript:afficher2('wordcloud');\">Nuage de mots</div>
		<div class=\"bouton\" id=\"btn_graph_mots\" onclick=\"javascript:cacher2();javascript:afficher2('graph_mots');\">Répartition des mots</div>
		<div class=\"bouton\" id=\"btn_all\" onclick=\"javascript:afficher2('btn_all');\">Afficher tout</div>
		<div class=\"clear\"></div>
	</div>
	");
}
print("<div class=\"corps\" id=\"corps\">\n");
###corps de la page
if ($TYPE==1){
##################
##
##	si requête
##
##################
	###récupération et affichage de la requête
	my $req = $con->prepare('SELECT requete 
							FROM requetes 
							WHERE idrequetes = '.$idRequete);
	$req->execute();
	my $nomR;
	$req->bind_columns(\$nomR);
	$req->fetch();
	print("\t\t<div class=\"description_page\" id=\"description_page\">
			<span class=\"gauche\">Requête :</span><span id=\"titre\">\"$nomR\"</span><div class=\"clear\"></div>
		</div>
		<h1 id=\"titre_description\">Ensemble des statistiques de la requête</h1>\n");
	$req -> finish;
	
	###construction de la liste des articles pertinents
	my %HashIndDir=();
	my %Rang=();
	my $req = $con->prepare('SELECT R.idrequete, R.idarticle, R.rang, R.score, R.dateRD, A.collection, A.titre
							FROM requetes_articles R, articles A
							WHERE A.idA = R.idarticle and A.collection=R.collection and idrequete = '.$idRequete);
	$req->execute();
	my $idR, $idA, $rang, $score, $date, $tps, $col, $titreA;
	my $somme_scores=0;
	$req->bind_columns(\$idR,\$idA,\$rang,\$score,\$date,\$col,\$titreA);
	while($req->fetch()) {
		$HashIndDir{$idA}=$rang;
		$Rang{$rang}="$idA;$score;$titreA;$col";
		$somme_scores+=$score;
	}
	$req -> finish;
	
	#dans l'ordre:
	my %TMP=();
	my @Articles=();
	foreach my $id (sort keys %Rang){
		my $l=length($id);
		if (!exists $TMP{$l}){
			$TMP{$l}=join("",$id,";");
		} else {
			$TMP{$l}=join($id,$TMP{$l},";");
		}
	}
	foreach my $t (sort keys %TMP) {
		push(@tmp,split(/;/,$TMP{$t}));
	}

	print("\t\t<div class=\"requete\" id=\"requete\"><div class=\"stats\"><ul>
			<div class=\"head\"><span title=\"ID article\" class=\"id\">id article</span><span title=\"ID article\" class=\"titre\">titre</span><span title=\"(rang,score)\" class=\"graph_score\">score</span><div class=\"clear\"></div></div>\n");
	
	%TitreArticle=(); #utile pour les légendes plus tard
	foreach my $rang (@tmp){
		my ($idA,$score,$titreA,$col)=split(";",$Rang{$rang});
		push(@Articles,$idA);
		$TitreArticle{$idA}=$titreA;
		print("\t\t\t<li><span class=\"id\">$idA</span><div class=\"titre\"><a href=\"stat.pl?idDocument=$idA&collection=$col\">$titreA</a></div>
			<span title=\"rang:$rang, score:$score\" class=\"graph_score\">")
		;&Doughnut_score($idA,45,45,$score);
		print("	</span><div class=\"clear\"></div></li>\n");
	}
	print("	<div class=\"end\"></div>\n	</ul></div></div>\n");

	###lecture du posting, construction, et affichage du wordcloud
	my %ArMF=();
	my %freqmot=();
	my $indexDirect=&collectionUtilisee()."indexDirect.txt";
	open(P,$indexDirect) || print("Erreur d'ouverture du fichier indexDirect");
	while (<P>) {
		chomp;
		my ($id,$list) = split(/\t/,$_);
		my @listePaires=();
		foreach my $idA (keys %HashIndDir){
			if ($idA==$id) {
				@listePaires = split(/,/,$list);
				my %tmp=();
				foreach my $paire (@listePaires){
					my ($mot,$freq) = split(/:/,$paire);
					$freqmot{$mot}+=int($freq);
					$tmp{$mot}=$freq;
				}
				$ArMF{$idA}=\%tmp;
			}
		}
	}
	close (P);
	my ($bloc,@listemots)=build_wordclound(%freqmot);
	print("	<div class=\"bloc_graphs\" id=\"wordcloud\">");
	&wordcloud($bloc);
	print("<div class=\"legende\">Nuage de mots de tous les articles</div></div>\n");
	
	###construction et affichage du graphique des mots les plus fréquents des 5 premiers articles
	my $NBRMOTS=10;	#nombre de mots à étudier
	my $NBRART=5;	#nombre d'articles à afficher (max 5)
	my @topmots=();
	foreach (my $i=0;$i<@listemots;$i++) {
		if ((length($listemots[$i])>1)&&(@topmots<$NBRMOTS)) { #longeur du mot > 1
			push(@topmots,$listemots[$i]);
		}
	}
	my $labels=join("\"\,\"",@topmots);
	my $labels=join($labels,"\"","\"");
	my @topArticles=();
	foreach (my $i=0;$i<@Articles;$i++) {
		if (@topArticles<$NBRART) {
			push(@topArticles,$Articles[$i]);
		}
	}
	my %data=();
	my $poidsmax=0;
	foreach my $idA (@topArticles){
		my @data=();
		foreach my $mot (@topmots){
			if (exists ${$ArMF{$idA}}{$mot}){
				push (@data,${$ArMF{$idA}}{$mot}+1);# +1 car pb d'affichage dans le graph sinon
				if (${$ArMF{$idA}}{$mot}>$poidsmax) {$poidsmax=${$ArMF{$idA}}{$mot};}
			} else {
				push (@data,0);
			}
		}
		$data=join(',',@data);
		$data{$idA}=$data;
	}
	my $scaleSteps=$poidsmax;
	my $scaleStepWidth=1;
	my $scaleStartValue=1;
	print("	<div class=\"bloc_graphs\" id=\"graph_mots\">");
	&graph_mots($longeur_graph,$hauteur_graph,$scaleSteps,$scaleStepWidth,$scaleStartValue,$labels,%data);
	for (my $i=1;$i<@topArticles+1;$i++){
		print("	<div class=\"puce\" style=\"background:$colors[$i-1];\"></div><div class=\"nom\">Article $i : \"$TitreArticle{$topArticles[$i-1]}\"</div><div class=\"clear\"></div>");
	}
	print("\n\t<div class=\"legende\">Fréquences des termes les plus employés par article</div></div>
	");

	###construction et affichage du graphique des catégories les plus fréquentes des articles
	my $NBRCAT=10;	#nombre de catégories à afficher
	my $articles=join(',',@Articles);
	$articles=join($articles,"(",")");
	
	my $req = $con->prepare('SELECT AC.ida, AC.idC, C.titreC FROM articles_categories AC, categories C where AC.idC = C.idC and AC.collection=C.collection and AC.ida in '.$articles);
	$req->execute();
	my ($pidA,$pidC,$ptitreC);
	$req->bind_columns(\$pidA,\$pidC,\$ptitreC);

	my %CatFreq=();
	while($req->fetch()) {
		if (!exists $CatFreq{$ptitreC}){
			$CatFreq{$ptitreC}=1;
		} else {
			$CatFreq{$ptitreC}+=1;
		}
	}
	$req -> finish;

	#dans l'ordre:
	my %TMP=();
	foreach my $cat (keys %CatFreq){
		my $l=length($CatFreq{$cat});
		my $catfreq=join(':',$CatFreq{$cat},$cat);
		if (!exists $TMP{$l}){
			$TMP{$l}=join("",$catfreq,';');
		} else {
			$TMP{$l}=join($catfreq,$TMP{$l},';');
		}
	}
	my @listecat=();
	my @listepoids=();
	foreach my $l (reverse sort keys %TMP) {
		my @tmp=split(/;/,$TMP{$l});
		foreach my $l (reverse sort @tmp) {
			my($freq,$c)=split(/:/,$l);
			push(@listecat,$c);
			push(@listepoids,$freq);
		}
	}
	
	#selection et troncature (pb d'affichage sinon)
	my @topcats=();
	foreach (my $i=0;$i<@listecat;$i++) {
		if ((length($listecat[$i])>1)&&(@topcats<$NBRCAT)) {
			my $mot=$listecat[$i];
			if (length($mot)>15){
				$mot=substr($mot,0,12);
				$mot=join("",$mot,'...');
			}
			push(@topcats,$mot);
		}
	}
	my $labels=join("\"\,\"",@topcats);
	my $labels=join($labels,"\"","\"");
	my $listepoids=join(',',@listepoids[0..$NBRCAT-1]);
	my $scaleStartValue=$listepoids[$NBRCAT-1]-1;
	if ($scaleStartValue<0){$scaleStartValue=0;}
	my $scaleSteps=5;
	my $scaleStepWidth=(($listepoids[0]+1-$scaleStartValue)/$scaleSteps);

	#mélange pour meilleur effet dans le graph
	my @listecat_shuffled=();
	my @listepoids_shuffled=();
	my @shuff=(0..$NBRCAT-1);
	@shuff=&shuffled(@shuff);
	foreach (my $i=0;$i<@shuff;$i++) {
		$listecat_shuffled[$shuff[$i]]=$topcats[$i];
		$listepoids_shuffled[$shuff[$i]]=$listepoids[$i];
	}
	@listecat=@listecat_shuffled;
	@listepoids=@listepoids_shuffled;
	my $listepoids=join(',',@listepoids[0..$NBRCAT-1]);
	my $labels=join("\"\,\"",@listecat);
	my $labels=join($labels,"\"","\"");
	print("<div class=\"bloc_graphs\" id=\"graph_cat\">");
	&graph_cat($longeur_graph,$hauteur_graph,$scaleSteps,$scaleStepWidth,$scaleStartValue,$labels,$listepoids);
	print("		<div class=\"legende\">Catégories des résultats de la recherche</div>
	</div>");

}
elsif ($TYPE==2){
##################
##
##	si document
##
##################
	my $req2 = $con->prepare('SELECT titre, dateA, url FROM articles WHERE idA= '.$idDocument." and collection='".$collection."'");
	$req2->execute();
	my ($titre,$date,$url);
	$req2->bind_columns(\$titre,\$date,\$url);
	$req2->fetch();
	print("
		<div class=\"description_page\" id=\"description_page\">
		<span class=\"gauche\">Titre de l'article :</span><h2 class=\"droite\" id=\"titre\"><a href =\"$url\">$titre</a></h2><div class=\"clear\"></div>
		<span class=\"gauche\">Date de publication :</span><h2 class=\"droite\" id=\"titre\">$date</h2><div class=\"clear\"></div>
		<span class=\"gauche\">Collection :</span><h2 class=\"droite\" id=\"titre\">$nomsite{$collection}</h2><div class=\"clear\"></div>
	");
	$req2 -> finish;
	
	my @categ;
	my $req3 = $con->prepare('SELECT C.titreC
							FROM categories C, articles_categories A 
							WHERE A.idC = C.idC
							and A.ida = '.$idDocument." and A.collection=C.collection and A.collection='".$collection."'");
	$req3->execute();
	my ($titreC);
	$req3->bind_columns(\$titreC);
	while($req3->fetch()) {
		push(@categ,$titreC);
	}
	my $categ=join(', ',@categ);
	print("	<span class=\"gauche\">Catégories :</span><h2 class=\"droite\" id=\"titre\">$categ</h2><div class=\"clear\"></div>\n");
	$req3 -> finish;
	
	print("	</div>\n	<h1 id=\"titre_description\">Ensemble des statistiques du document</h1>\n");
	###lecture du posting, construction, et affichage du wordcloud
	my %freqmot=();
	my $indexDirect=&collectionUtilisee()."indexDirect.txt";
	open(P,$indexDirect) || print("Erreur d'ouverture du fichier posting");
	while (<P>) {
		chomp;
		my ($id,$list) = split(/\t/,$_);
		my @listePaires=();
		if ($idDocument==$id) {
			@listePaires = split(/,/,$list);
			foreach my $paire (@listePaires){
				my ($mot,$freq) = split(/:/,$paire);
				$freqmot{$mot}=int($freq);
			}
		}
	}
	close (P);
	my ($bloc,@listemots)=build_wordclound(%freqmot);
	print("	<div class=\"bloc_graphs\" id=\"wordcloud\">");
	&wordcloud($bloc);
	print("<div class=\"legende\">Nuage de mots de l'article</div></div>
	");

	###construction et affichage du graphique des mots les plus fréquents
	my $NBRMOTS=15;	#nombre de mots à étudier
	my @topmots=();
	foreach (my $i=0;$i<@listemots;$i++) {
		if ((length($listemots[$i])>1)&&(@topmots<$NBRMOTS)) { #longeur du mot > 1
			push(@topmots,$listemots[$i]);
		}
	}
	my $labels=join("\"\,\"",@topmots);
	my $labels=join($labels,"\"","\"");
	my $poidsmax=0;
	my %data=();
	my @data=();
	foreach my $mot (@topmots){
		if (exists $freqmot{$mot}){
			push (@data,$freqmot{$mot}+1);# +1 car pb d'affichage dans le graph sinon
			if ($freqmot{$mot}>$poidsmax) {$poidsmax=$freqmot{$mot};}
		} else {
			push (@data,0);
		}
	}
	$data=join(',',@data);
	$data{$idA}=$data;
	my $scaleSteps=$poidsmax;
	my $scaleStepWidth=1;
	my $scaleStartValue=1;
	print("<div class=\"bloc_graphs\" id=\"graph_mots\">");
	&graph_mots($longeur_graph,$hauteur_graph,$scaleSteps,$scaleStepWidth,$scaleStartValue,$labels,%data);
	print("<div class=\"legende\">Fréquences des termes les plus employés dans l'article</div></div>");
}
print("<div class=\"clear\"></div></div>");#/corps
$con -> disconnect;
print("
</body>
</html>\n"
);
