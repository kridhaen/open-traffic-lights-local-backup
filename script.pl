use strict;
use warnings;

#my $regex =~ /<http:\/\/www.w3.org\/ns\/hydra\/core#previous>.<(https:\/\/lodi.ilabt.imec.be\/observer\/rawdata\/fragments\?time=(2019-02-14T11:58:09.754Z))>/g;

#`curl  https://lodi.ilabt.imec.be/observer/rawdata/latest`;
my $url = "https://lodi.ilabt.imec.be/observer/rawdata/latest";
system "curl ".$url." -o latest.trig";

my $filename = 'latest.trig';
my $content;
open(my $fh, '<', $filename) or die "could not open file";
{
    local $/;
    $content = <$fh>;
}
close($fh);
#print $content;
$content =~ /<http:\/\/www.w3.org\/ns\/hydra\/core#previous>.<(https:\/\/lodi.ilabt.imec.be\/observer\/rawdata\/fragments\?time=(.*))>/g;
my $previousUrl = $1;
my $previousName = $2;
$previousName=~s/:|\./_/g;
$previousName="fragment_".$previousName.".trig";
print "    ".$previousName."\n";
print "    ".$previousUrl."\n";

#alle previous ophalen:
while($previousUrl){
    system "curl ".$previousUrl." -o ".$previousName;
    print "done fetching ".$previousName."\n";
    open(my $fh, '<', $previousName) or die "could not open file";
    {
        local $/;
        $content = <$fh>;
    }
    #print "content is ".$content."\n";
    close($fh);
    $content =~ /<http:\/\/www.w3.org\/ns\/hydra\/core#previous>.<(https:\/\/lodi.ilabt.imec.be\/observer\/rawdata\/fragments\?time=(.*))>/g;
    $previousUrl = $1;
    $previousName = $2;
    $previousName=~s/:|\./_/g;
    $previousName="fragment_".$previousName.".trig";
    print "    ".$previousName."\n";
    print "    ".$previousUrl."\n";
}
