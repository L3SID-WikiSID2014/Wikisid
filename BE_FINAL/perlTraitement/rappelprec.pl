#! C:\Perl64\bin\perl.exe
use strict;

my(%s);
my(%p);
my(%ps);
my(%precision);
my(%rappel);


sub LireTexte{
	my($fichier)=@_;
	my $texte = do{
	local$/=undef;
	open my$fh,"<",$fichier
	or die "Le fichier $fichier ne peut être ouvert:$!";
	<$fh>;
	};
	chomp $texte;
	return $texte;
}

sub Segmenter{ 
	my($fichier)=$_[0];
	$fichier=~s@\,@@ig;
	my(@liste)=split(' ',$fichier);
	return @liste;
}


sub Precision{
	my($ps,$p)=@_;
	print "<p>ps $ps</p>";
	print "<p>p $p</p>";
	if ($p==0){
	     return 0;
	} else {
	     return $ps/$p;
	}
}

sub Rappel{
	my($ps,$s)=@_;
	print "<p>ps $ps</p>";
	print "<p>s $s</p>";
	if ($s==0){
	    return 0;
	} else {
	    return $ps/$s;
	}
}


1;