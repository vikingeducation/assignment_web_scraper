$.getScript('https://assets.dice.com/assets/scripts/omniture/s_code.js', function()
{

//define reporting profile, server, and pagename
var s=s_gi('diceprod');
s.trackingServer='sstats.dice.com';
s.pageName="Job_Search_Results";
s.channel="__SEEKER___";

//get search term and search location
s.eVar53 = _satellite.getVar('Job Search 2014 - Search Term');
s.eVar54= _satellite.getVar('Job Search 2014 - Search Location');
s.prop37 = _satellite.getVar('Job Search 2014 - Search Term');
s.prop38= _satellite.getVar('Job Search 2014 - Search Location');

//pull pagniation information from page and parse
var clsary = document.getElementsByClassName('pull-left posiCount sort');
var clsary2 = (clsary[0].innerHTML);
clsary2 = clsary2.split('</span>')[0];
s.prop40 = clsary2.substring(6);

//loop through all filter items, find which ones are checked and feed into deliminated list prop omniture can parse

var name3 = "";
var cnt = 1;
var positions = document.getElementsByClassName('fchk');
 for (var i=0;i<positions.length;i++){
   if ( positions[i].checked ) {
   var namet = positions[i].getAttribute("chkval");
   var namety = positions[i].getAttribute("chktyp");
   var name2 = namet.split("+").join(" ");
     var name2 = namety + ":" + name2;
     if (cnt>1) {
       name2 = "|" + name2;
     }
   name3 = name3 + name2;  
   cnt++;
   }   
  }
s.prop39 = name3;

//trigger a successful search event
s.events = 'event20';
s.pageType="COOL";

//make calll to Adobe Analytics
/************* DO NOT ALTER ANYTHING BELOW THIS LINE ! **************/
var s_code=s.t();if(s_code)document.write(s_code)

});
