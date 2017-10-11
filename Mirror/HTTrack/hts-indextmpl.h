/* ------------------------------------------------------------ */
/*
HTTrack Website Copier, Offline Browser for Windows and Unix
Copyright (C) 1998-2015 Xavier Roche and other contributors

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

Important notes:

- We hereby ask people using this source NOT to use it in purpose of grabbing
emails addresses, or collecting any other private information on persons.
This would disgrace our work, and spoil the many hours we spent on it.

Please visit our Website: http://www.httrack.com
*/

/* ------------------------------------------------------------ */
/* File: Index.html templates file                              */
/* Author: Xavier Roche                                         */
/* ------------------------------------------------------------ */

#ifndef HTTRACK_DEFTMPL
#define HTTRACK_DEFTMPL

/* Index for each project */
/*
regen:
(for i in *; do echo $i; cat $i | sed -e 's/"/\\"/g' | sed -e 's/^\(.*\)$/  "\1"LF\\/'; done) > /tmp/1.txt
*/
/* %s = INFO */
#define HTS_INDEX_HEADER \
  "<!-- Note: Template file not found, using internal one -->"LF\
  "<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"en\">"LF\
  ""LF\
  "<head>"LF\
  "	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"LF\
  "	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"LF\
  "	<meta name=\"description\" content=\"Miroir mirrors website using HTTrack. Links are saved relatively so that you can read websites offline easily\" />"LF\
  "	<meta name=\"keywords\" content=\"httrack, HTTRACK, HTTrack, Miroir, offline browser, web mirror utility, aspirateur web, surf offline, web capture, www mirror utility, browse offline, local  site builder, website mirroring, aspirateur www, internet grabber, capture de site web, internet tool, hors connexion, Mac OS X, iMac, Mavericks, Mountain Lion, Lion, Snow Leopard, Yosemite, Macintosh, HTS, HTGet, web aspirator, web aspirateur, libre, GPL, GNU, free software\" />"LF\
  "	<title>Local Project Index - Miroir</title>"LF\
  "  %s"LF\
  "	<style type=\"text/css\">"LF\
  "	<!--"LF\
  ""LF\
  "body {"LF\
  "	margin: 0;  padding: 0;  margin-bottom: 15px;  margin-top: 8px;"LF\
  "}"LF\
  "body, td {"LF\
  "	text-align:center; font: 14px Didot, \"Didot LT STD\", \"Hoefler Text\", Garamond, \"Times New Roman\", serif;"LF\
  "	}"LF\
  ""LF\
  "#subTitle {"LF\
  "	background: #000;  color: #fff;  padding: 4px;  font-weight: bold; "LF\
  "	}"LF\
  ""LF\
  "#siteNavigation a, #siteNavigation .current {"LF\
  "	font-weight: bold;  color: #448;"LF\
  "	}"LF\
  "#siteNavigation a:link    { text-decoration: none; }"LF\
  "#siteNavigation a:visited { text-decoration: none; }"LF\
  ""LF\
  "#siteNavigation .current { background-color: #ccd; }"LF\
  ""LF\
  "#siteNavigation a:hover   { text-decoration: none;  background-color: #fff;  color: #000; }"LF\
  "#siteNavigation a:active  { text-decoration: none;  background-color: #ccc; }"LF\
  ""LF\
  ""LF\
  "a:link    { text-decoration: underline;  color: #00f; }"LF\
  "a:visited { text-decoration: underline;  color: #000; }"LF\
  "a:hover   { text-decoration: underline;  color: #c00; }"LF\
  "a:active  { text-decoration: underline; }"LF\
  ""LF\
  "#pageContent {"LF\
  "	clear: both;"LF\
  "	"LF\
  "	padding: 10px;  padding-top: 20px;"LF\
  "	line-height: 1.65em;"LF\
	" background-repeat: no-repeat;"LF\
	" background-position: top right;"LF\
  "	}"LF\
  ""LF\
  "#pageContent, #siteNavigation {"LF\
  "	"LF\
  "	}"LF\
  ""LF\
  ""LF\
  ".imgLeft  { float: left;   margin-right: 10px;  margin-bottom: 10px; }"LF\
  ".imgRight { float: right;  margin-left: 10px;   margin-bottom: 10px; }"LF\
  ""LF\
  "hr { height: 1px;  color: #000;  background-color: #000;  margin-bottom: 15px; }"LF\
  ""LF\
  "h1 { margin: 0;  font-weight: bold;  font-size: 2em; }"LF\
  "h2 { margin: 0;  font-weight: bold;  font-size: 1.6em; }"LF\
  "h3 { margin: 0;  font-size: 1.3em; }"LF\
  "h4 { margin: 0;  font-weight: bold;  font-size: 1.18em; }"LF\
  ""LF\
  ".blak {  }"LF\
  ".hide { display: none; }"LF\
  ".tableWidth { min-width: 400px; }"LF\
  ""LF\
  ".tblRegular       { border-collapse: collapse; }"LF\
  ".tblRegular td    { padding: 6px;  }"LF\
  ".tblHeaderColor, .tblHeaderColor td {  }"LF\
  ".tblNoBorder td   { border: 0; }"LF\
  ""LF\
  ""LF\
  "// -->"LF\
  "</style>"LF\
  ""LF\
  "</head>"LF\
  ""LF\
  "<table style=\"display:none;\" width=\"76%%\" border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"3\" class=\"tableWidth\">"LF\
  "	<tr>"LF\
  "	<td id=\"subTitle\">Miroir - offline browser</td>"LF\
  "	</tr>"LF\
  "</table>"LF\
  "<table width=\"76%%\" border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"0\" class=\"tableWidth\">"LF\
  "<tr class=\"blak\">"LF\
  "<td>"LF\
  "	<table width=\"100%%\" border=\"0\" align=\"center\" cellspacing=\"1\" cellpadding=\"0\">"LF\
  "	<tr>"LF\
  "	<td colspan=\"6\"> "LF\
  "		<table width=\"100%%\" border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"10\">"LF\
  "		<tr> "LF\
  "		<td id=\"pageContent\"> "LF\
  "<!-- ==================== End prologue ==================== -->"LF\
  ""LF\
  "<center>"LF\
  "<img src=\"data:image/png;base64,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\" width=\"50\">"LF\
  "</center><br><br>"LF\
  "	<center>"LF\
  "<H3 ALIGN=Center>%s</H3><br><br>"LF\
  "</center>"LF\
  "  <TABLE BORDER=\"0\" WIDTH=\"100%%\" CELLSPACING=\"1\" CELLPADDING=\"0\">"LF

/* %s = URL */
/* %s = TITLE */
#define HTS_INDEX_BODY \
  "<!-- Note: Template file not found, using internal one -->"LF\
  "		<TR>"LF\
  "			<TD style=\"text-align: center;\">"LF\
  "				&middot;"LF\
  "					<A HREF=\"%s\">"LF\
  "						%s"LF\
  "					</A>		"LF\
  "			</TD>"LF\
  "		</TR>"LF

#define HTS_INDEX_BODYCAT \
  "<!-- Note: Template file not found, using internal one -->"LF\
  "		<TH>"LF\
  "		<BR/>"LF\
  "			%s"LF\
  "		</TH>"LF

/* %s = INFO */
#define HTS_INDEX_FOOTER \
  "<!-- Note: Template file not found, using internal one -->"LF\
  "	</TABLE>"LF\
  "	<BR>"LF\
  "	<BR>"LF\
  "	<BR>"LF\
  " <H6 ALIGN=\"RIGHT\">"LF\
  "	"LF\
  "	</H6>"LF\
  "	%s"LF\
  "	<!-- Thanks for using Miroir! -->"LF\
  ""LF\
  "<!-- ==================== Start epilogue ==================== -->"LF\
  "		</td>"LF\
  "		</tr>"LF\
  "		</table>"LF\
  "	</td>"LF\
  "	</tr>"LF\
  "	</table>"LF\
  "</td>"LF\
  "</tr>"LF\
  "</table>"LF\
  ""LF\
  "<table width=\"76%%\" border=\"0\" align=\"center\" valign=\"bottom\" cellspacing=\"0\" cellpadding=\"0\">"LF\
  "	<tr>"LF\
  "	<td id=\"footer\"><small>This project was created by Miroir, a Mac OS application to mirror websites. It uses Xavier Roche's HTTrack library. &copy; 2015.</small></td>"LF\
  "	</tr>"LF\
  "</table>"LF\
  ""LF\
  "</body>"LF\
  ""LF\
  "</html>"LF\
  ""LF\
  ""LF

/* Index for all projects (top index) */
/* %s = INFO */
#define HTS_TOPINDEX_HEADER \
  "<!-- Note: Template file not found, using internal one -->"LF\
  "<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"en\">"LF\
  ""LF\
  "<head>"LF\
  "	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"LF\
  "	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"LF\
  "	<meta name=\"description\" content=\"Miroir mirrors website using HTTrack. Links are saved relatively so that you can read websites offline easily\" />"LF\
  "	<meta name=\"keywords\" content=\"httrack, HTTRACK, HTTrack, Miroir, offline browser, web mirror utility, aspirateur web, surf offline, web capture, www mirror utility, browse offline, local  site builder, website mirroring, aspirateur www, internet grabber, capture de site web, internet tool, hors connexion, Mac OS X, iMac, Mavericks, Mountain Lion, Lion, Snow Leopard, Yosemite, Macintosh, HTS, HTGet, web aspirator, web aspirateur, libre, GPL, GNU, free software\" />"LF\
  "	<title>List of available projects - Miroir</title>"LF\
  "	%s"LF\
  ""LF\
  "	<style type=\"text/css\">"LF\
  "	<!--"LF\
  ""LF\
  "body {"LF\
  "	margin: 0;  padding: 0;  margin-bottom: 15px;  margin-top: 8px;"LF\
  "	background: #77b;"LF\
  "}"LF\
  "body, td {"LF\
  "	font: 14px \"Trebuchet MS\", Verdana, Arial, Helvetica, sans-serif;"LF\
  "	}"LF\
  ""LF\
  "#subTitle {"LF\
  "	background: #000;  color: #fff;  padding: 4px;  font-weight: bold; "LF\
  "	}"LF\
  ""LF\
  "#siteNavigation a, #siteNavigation .current {"LF\
  "	font-weight: bold;  color: #448;"LF\
  "	}"LF\
  "#siteNavigation a:link    { text-decoration: none; }"LF\
  "#siteNavigation a:visited { text-decoration: none; }"LF\
  ""LF\
  "#siteNavigation .current { background-color: #ccd; }"LF\
  ""LF\
  "#siteNavigation a:hover   { text-decoration: none;  background-color: #fff;  color: #000; }"LF\
  "#siteNavigation a:active  { text-decoration: none;  background-color: #ccc; }"LF\
  ""LF\
  ""LF\
  "a:link    { text-decoration: underline;  color: #00f; }"LF\
  "a:visited { text-decoration: underline;  color: #000; }"LF\
  "a:hover   { text-decoration: underline;  color: #c00; }"LF\
  "a:active  { text-decoration: underline; }"LF\
  ""LF\
  "#pageContent {"LF\
  "	clear: both;"LF\
  "	border-bottom: 6px solid #000;"LF\
  "	padding: 10px;  padding-top: 20px;"LF\
  "	line-height: 1.65em;"LF\
	" background-repeat: no-repeat;"LF\
	" background-position: top right;"LF\
  "	}"LF\
  ""LF\
  "#pageContent, #siteNavigation {"LF\
  "	background-color: #ccd;"LF\
  "	}"LF\
  ""LF\
  ""LF\
  ".imgLeft  { float: left;   margin-right: 10px;  margin-bottom: 10px; }"LF\
  ".imgRight { float: right;  margin-left: 10px;   margin-bottom: 10px; }"LF\
  ""LF\
  "hr { height: 1px;  color: #000;  background-color: #000;  margin-bottom: 15px; }"LF\
  ""LF\
  "h1 { margin: 0;  font-weight: bold;  font-size: 2em; }"LF\
  "h2 { margin: 0;  font-weight: bold;  font-size: 1.6em; }"LF\
  "h3 { margin: 0;  font-weight: bold;  font-size: 1.3em; }"LF\
  "h4 { margin: 0;  font-weight: bold;  font-size: 1.18em; }"LF\
  ""LF\
  ".blak { background-color: #000; }"LF\
  ".hide { display: none; }"LF\
  ".tableWidth { min-width: 400px; }"LF\
  ""LF\
  ".tblRegular       { border-collapse: collapse; }"LF\
  ".tblRegular td    { padding: 6px;  border: 2px solid #99c; }"LF\
  ".tblHeaderColor, .tblHeaderColor td { background: #99c; }"LF\
  ".tblNoBorder td   { border: 0; }"LF\
  ""LF\
  ""LF\
  "// -->"LF\
  "</style>"LF\
  ""LF\
  "</head>"LF\
  ""LF\
  "<table width=\"76%%\" border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"3\" class=\"tableWidth\">"LF\
  "	<tr>"LF\
  "	<td id=\"subTitle\">Miroir - offline browser</td>"LF\
  "	</tr>"LF\
  "</table>"LF\
  "<table width=\"76%%\" border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"0\" class=\"tableWidth\">"LF\
  "<tr class=\"blak\">"LF\
  "<td>"LF\
  "	<table width=\"100%%\" border=\"0\" align=\"center\" cellspacing=\"1\" cellpadding=\"0\">"LF\
  "	<tr>"LF\
  "	<td colspan=\"6\"> "LF\
  "		<table width=\"100%%\" border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"10\">"LF\
  "		<tr> "LF\
  "		<td id=\"pageContent\"> "LF\
  "<!-- ==================== End prologue ==================== -->"LF\
  ""LF\
  ""LF\
  "<h1 ALIGN=Center>Index of locally available projects:</H1>"LF\
  "  <table border=\"0\" width=\"100%%%\" cellspacing=\"1\" cellpadding=\"0\">"LF

/* %s = URL */
/* %s = TITLE */
#define HTS_TOPINDEX_BODY \
  "<!-- Note: Template file not found, using internal one -->"LF\
  "		<TR>"LF\
  "		  <TD>"LF\
  "                    &middot; <A HREF=\"%s/index.html\">%s</A>"LF\
  "   		  </TD>"LF\
  "		</TR>"LF

/* %s = INFO */
#define HTS_TOPINDEX_FOOTER \
  "<!-- Note: Template file not found, using internal one -->"LF\
  "	</TABLE>"LF\
  "	<BR>"LF\
  "	<H6 ALIGN=\"RIGHT\">"LF\
  "         <I>Mirror and index made by Miroir</I>"LF\
  "	</H6>"LF\
  "	%s"LF\
  "	<!-- Thanks for using Miroir! -->"LF\
  ""LF\
  "<!-- ==================== Start epilogue ==================== -->"LF\
  "		</td>"LF\
  "		</tr>"LF\
  "		</table>"LF\
  "	</td>"LF\
  "	</tr>"LF\
  "	</table>"LF\
  "</td>"LF\
  "</tr>"LF\
  "</table>"LF\
  ""LF\
  "<table width=\"76%%\" border=\"0\" align=\"center\" valign=\"bottom\" cellspacing=\"0\" cellpadding=\"0\">"LF\
  "	<tr>"LF\
  "	<td id=\"footer\"><small>&copy; 2015.</small></td>"LF\
  "	</tr>"LF\
  "</table>"LF\
  ""LF\
  "</body>"LF\
  ""LF\
  "</html>"LF\
  ""LF\
  ""LF

/* Other files (fade and backblue images) */

#define HTS_LOG_SECURITY_WARNING "note:\tthe "LOG_FILE_NAME" file, and "CACHE_DIRECTORY_NAME" folder, may contain sensitive information,"LF\
  "\tsuch as username/password authentication for websites mirrored in this project"LF\
  "\tdo not share these files/folders if you want these information to remain private"LF

#define HTS_DATA_UNKNOWN_HTML "<html>"LF\
  "<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"en\">"LF\
  ""LF\
  "<head>"LF\
  "	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"LF\
  "	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"LF\
  "	<meta name=\"description\" content=\"Miroir mirrors website using HTTrack. Links are saved relatively so that you can read websites offline easily\" />"LF\
  "	<meta name=\"keywords\" content=\"httrack, HTTRACK, HTTrack, Miroir, offline browser, web mirror utility, aspirateur web, surf offline, web capture, www mirror utility, browse offline, local  site builder, website mirroring, aspirateur www, internet grabber, capture de site web, internet tool, hors connexion, Mac OS X, iMac, Mavericks, Mountain Lion, Lion, Snow Leopard, Yosemite, Macintosh, HTS, HTGet, web aspirator, web aspirateur, libre, GPL, GNU, free software\" />"LF\
  "	<title>Page not retrieved! - Miroir</title>"LF\
  "  %s"LF\
  "	<style type=\"text/css\">"LF\
  "	<!--"LF\
  ""LF\
  "body {"LF\
  "	margin: 0;  padding: 0;  margin-bottom: 15px;  margin-top: 8px;"LF\
  "	background: #77b;"LF\
  "}"LF\
  "body, td {"LF\
  "	font: 14px \"Trebuchet MS\", Verdana, Arial, Helvetica, sans-serif;"LF\
  "	}"LF\
  ""LF\
  "#subTitle {"LF\
  "	background: #000;  color: #fff;  padding: 4px;  font-weight: bold; "LF\
  "	}"LF\
  ""LF\
  "#siteNavigation a, #siteNavigation .current {"LF\
  "	font-weight: bold;  color: #448;"LF\
  "	}"LF\
  "#siteNavigation a:link    { text-decoration: none; }"LF\
  "#siteNavigation a:visited { text-decoration: none; }"LF\
  ""LF\
  "#siteNavigation .current { background-color: #ccd; }"LF\
  ""LF\
  "#siteNavigation a:hover   { text-decoration: none;  background-color: #fff;  color: #000; }"LF\
  "#siteNavigation a:active  { text-decoration: none;  background-color: #ccc; }"LF\
  ""LF\
  ""LF\
  "a:link    { text-decoration: underline;  color: #00f; }"LF\
  "a:visited { text-decoration: underline;  color: #000; }"LF\
  "a:hover   { text-decoration: underline;  color: #c00; }"LF\
  "a:active  { text-decoration: underline; }"LF\
  ""LF\
  "#pageContent {"LF\
  "	clear: both;"LF\
  "	border-bottom: 6px solid #000;"LF\
  "	padding: 10px;  padding-top: 20px;"LF\
  "	line-height: 1.65em;"LF\
	" background-repeat: no-repeat;"LF\
	" background-position: top right;"LF\
  "	}"LF\
  ""LF\
  "#pageContent, #siteNavigation {"LF\
  "	background-color: #ccd;"LF\
  "	}"LF\
  ""LF\
  ""LF\
  ".imgLeft  { float: left;   margin-right: 10px;  margin-bottom: 10px; }"LF\
  ".imgRight { float: right;  margin-left: 10px;   margin-bottom: 10px; }"LF\
  ""LF\
  "hr { height: 1px;  color: #000;  background-color: #000;  margin-bottom: 15px; }"LF\
  ""LF\
  "h1 { margin: 0;  font-weight: bold;  font-size: 2em; }"LF\
  "h2 { margin: 0;  font-weight: bold;  font-size: 1.6em; }"LF\
  "h3 { margin: 0;  font-weight: bold;  font-size: 1.3em; }"LF\
  "h4 { margin: 0;  font-weight: bold;  font-size: 1.18em; }"LF\
  ""LF\
  ".blak { background-color: #000; }"LF\
  ".hide { display: none; }"LF\
  ".tableWidth { min-width: 400px; }"LF\
  ""LF\
  ".tblRegular       { border-collapse: collapse; }"LF\
  ".tblRegular td    { padding: 6px;  border: 2px solid #99c; }"LF\
  ".tblHeaderColor, .tblHeaderColor td { background: #99c; }"LF\
  ".tblNoBorder td   { border: 0; }"LF\
  ""LF\
  ""LF\
  "// -->"LF\
  "</style>"LF\
  ""LF\
  "</head>"LF\
  ""LF\
  "<table width=\"76%%\" border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"3\" class=\"tableWidth\">"LF\
  "	<tr>"LF\
  "	<td id=\"subTitle\">HTTrack Website Copier - Open Source offline browser</td>"LF\
  "	</tr>"LF\
  "</table>"LF\
  "<table width=\"76%%\" border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"0\" class=\"tableWidth\">"LF\
  "<tr class=\"blak\">"LF\
  "<td>"LF\
  "	<table width=\"100%%\" border=\"0\" align=\"center\" cellspacing=\"1\" cellpadding=\"0\">"LF\
  "	<tr>"LF\
  "	<td colspan=\"6\"> "LF\
  "		<table width=\"100%%\" border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"10\">"LF\
  "		<tr> "LF\
  "		<td id=\"pageContent\"> "LF\
  "<!-- ==================== End prologue ==================== -->"LF\
  "<h1><strong><u>Oops!...</u></strong></h1>"LF\
  "<h3>This page has <font color=\"red\"><em>not</em></font> been retrieved by HTTrack Website Copier. </h3>"LF\
  "<script language=\"Javascript\">"LF\
  "<!--"LF\
  "  var loc=document.location.toString();"LF\
  "  if (loc) {"LF\
  "    var pos=loc.indexOf('link=');"LF\
  "    if (pos>0) {"LF\
  "      document.write('Clic to the link <b>below</b> to go to the online location!<br><a href=\"'+loc.substring(pos+5)+'\">'+loc.substring(pos+5)+'</a><br>');"LF\
  "    } else"LF\
  "      document.write('(no location defined)');"LF\
  "  }"LF\
  "// -->"LF\
  "</script>"LF\
  "<h6 align=\"right\">Miroir's Mirror</h6>"LF\
  "<!-- ==================== Start epilogue ==================== -->"LF\
  "		</td>"LF\
  "		</tr>"LF\
  "		</table>"LF\
  "	</td>"LF\
  "	</tr>"LF\
  "	</table>"LF\
  "</td>"LF\
  "</tr>"LF\
  "</table>"LF\
  ""LF\
  "<table width=\"76%%\" height=\"100%%\" border=\"0\" align=\"center\" valign=\"bottom\" cellspacing=\"0\" cellpadding=\"0\">"LF\
  "	<tr>"LF\
  "	<td id=\"footer\"><small>&copy; 2015</small></td>"LF\
  "	</tr>"LF\
  "</table>"LF\
  ""LF\
  "</body>"LF\
  ""LF\
  "</html>"LF\
  ""LF\
  ""LF

#define HTS_DATA_UNKNOWN_HTML_LEN 0

#define HTS_DATA_ERROR_HTML "<html>"LF\
  "<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"en\">"LF\
  ""LF\
  "<head>"LF\
  "	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"LF\
  "	<meta name=\"description\" content=\"Miroir mirrors website using HTTrack. Links are saved relatively so that you can read websites offline easily\" />"LF\
  "	<meta name=\"keywords\" content=\"httrack, HTTRACK, HTTrack, Miroir, offline browser, web mirror utility, aspirateur web, surf offline, web capture, www mirror utility, browse offline, local  site builder, website mirroring, aspirateur www, internet grabber, capture de site web, internet tool, hors connexion, Mac OS X, iMac, Mavericks, Mountain Lion, Lion, Snow Leopard, Yosemite, Macintosh, HTS, HTGet, web aspirator, web aspirateur, libre, GPL, GNU, free software\" />"LF\
  "	<title>Page not retrieved! - Miroir</title>"LF\
  "	<style type=\"text/css\">"LF\
  "	<!--"LF\
  ""LF\
  "body {"LF\
  "	margin: 0;  padding: 0;  margin-bottom: 15px;  margin-top: 8px;"LF\
  "	background: #77b;"LF\
  "}"LF\
  "body, td {"LF\
  "	font: 14px \"Trebuchet MS\", Verdana, Arial, Helvetica, sans-serif;"LF\
  "	}"LF\
  ""LF\
  "#subTitle {"LF\
  "	background: #000;  color: #fff;  padding: 4px;  font-weight: bold; "LF\
  "	}"LF\
  ""LF\
  "#siteNavigation a, #siteNavigation .current {"LF\
  "	font-weight: bold;  color: #448;"LF\
  "	}"LF\
  "#siteNavigation a:link    { text-decoration: none; }"LF\
  "#siteNavigation a:visited { text-decoration: none; }"LF\
  ""LF\
  "#siteNavigation .current { background-color: #ccd; }"LF\
  ""LF\
  "#siteNavigation a:hover   { text-decoration: none;  background-color: #fff;  color: #000; }"LF\
  "#siteNavigation a:active  { text-decoration: none;  background-color: #ccc; }"LF\
  ""LF\
  ""LF\
  "a:link    { text-decoration: underline;  color: #00f; }"LF\
  "a:visited { text-decoration: underline;  color: #000; }"LF\
  "a:hover   { text-decoration: underline;  color: #c00; }"LF\
  "a:active  { text-decoration: underline; }"LF\
  ""LF\
  "#pageContent {"LF\
  "	clear: both;"LF\
  "	border-bottom: 6px solid #000;"LF\
  "	padding: 10px;  padding-top: 20px;"LF\
  "	line-height: 1.65em;"LF\
	" background-repeat: no-repeat;"LF\
	" background-position: top right;"LF\
  "	}"LF\
  ""LF\
  "#pageContent, #siteNavigation {"LF\
  "	background-color: #ccd;"LF\
  "	}"LF\
  ""LF\
  ""LF\
  ".imgLeft  { float: left;   margin-right: 10px;  margin-bottom: 10px; }"LF\
  ".imgRight { float: right;  margin-left: 10px;   margin-bottom: 10px; }"LF\
  ""LF\
  "hr { height: 1px;  color: #000;  background-color: #000;  margin-bottom: 15px; }"LF\
  ""LF\
  "h1 { margin: 0;  font-weight: bold;  font-size: 2em; }"LF\
  "h2 { margin: 0;  font-weight: bold;  font-size: 1.6em; }"LF\
  "h3 { margin: 0;  font-weight: bold;  font-size: 1.3em; }"LF\
  "h4 { margin: 0;  font-weight: bold;  font-size: 1.18em; }"LF\
  ""LF\
  ".blak { background-color: #000; }"LF\
  ".hide { display: none; }"LF\
  ".tableWidth { min-width: 400px; }"LF\
  ""LF\
  ".tblRegular       { border-collapse: collapse; }"LF\
  ".tblRegular td    { padding: 6px;  border: 2px solid #99c; }"LF\
  ".tblHeaderColor, .tblHeaderColor td { background: #99c; }"LF\
  ".tblNoBorder td   { border: 0; }"LF\
  ""LF\
  ""LF\
  "// -->"LF\
  "</style>"LF\
  ""LF\
  "</head>"LF\
  ""LF\
  "<table width=\"76%%\" border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"3\" class=\"tableWidth\">"LF\
  "	<tr>"LF\
  "	<td id=\"subTitle\">HTTrack Website Copier - Open Source offline browser</td>"LF\
  "	</tr>"LF\
  "</table>"LF\
  "<table width=\"76%%\" border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"0\" class=\"tableWidth\">"LF\
  "<tr class=\"blak\">"LF\
  "<td>"LF\
  "	<table width=\"100%%\" border=\"0\" align=\"center\" cellspacing=\"1\" cellpadding=\"0\">"LF\
  "	<tr>"LF\
  "	<td colspan=\"6\"> "LF\
  "		<table width=\"100%%\" border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"10\">"LF\
  "		<tr> "LF\
  "		<td id=\"pageContent\"> "LF\
  "<!-- ==================== End prologue ==================== -->"LF\
  "<h1><strong><u>Oops!...</u></strong></h1>"LF\
  "<h3>This page has <font color=\"red\"><em>not</em></font> been retrieved by HTTrack Website Copier (%s). </h3>"LF\
  "<script language=\"Javascript\">"LF\
  "<!--"LF\
  "  var loc=document.location.toString();"LF\
  "  if (loc) {"LF\
  "    var pos=loc.indexOf('link=');"LF\
  "    if (pos>0) {"LF\
  "      document.write('Click on the link <b>below</b> to go to the online location!<br><a href=\"'+loc.substring(pos+5)+'\">'+loc.substring(pos+5)+'</a><br>');"LF\
  "    } else"LF\
  "      document.write('(no location defined)');"LF\
  "  }"LF\
  "// -->"LF\
  "</script>"LF\
  "<h6 align=\"right\">Mirror by HTTrack Website Copier</h6>"LF\
  "</body>"LF\
  "</html>"LF\
  "<!-- ==================== Start epilogue ==================== -->"LF\
  "		</td>"LF\
  "		</tr>"LF\
  "		</table>"LF\
  "	</td>"LF\
  "	</tr>"LF\
  "	</table>"LF\
  "</td>"LF\
  "</tr>"LF\
  "</table>"LF\
  ""LF\
  "<table width=\"76%%\" height=\"100%%\" border=\"0\" align=\"center\" valign=\"bottom\" cellspacing=\"0\" cellpadding=\"0\">"LF\
  "	<tr>"LF\
  "	<td id=\"footer\"><small>&copy; 2015.</small></td>"LF\
  "	</tr>"LF\
  "</table>"LF\
  ""LF\
  "</body>"LF\
  ""LF\
  "</html>"LF\
  ""LF\
  ""LF

// image gif "unknown"
#define HTS_DATA_UNKNOWN_GIF \
  "\x47\x49\x46\x38\x39\x61\x20\x0\x20\x0\xf7\xff\x0\xc0\xc0\xc0\xff\x0\x0\xfc\x3\x0\xf8\x6\x0\xf6\x9\x0\xf2\xc\x0\xf0\xf\x0\xf0\xe\x0\xed\x11\x0\xec\x13\x0\xeb\x14\x0\xe9\x15\x0\xe8\x18\x0\xe6\x18\x0\xe5\x1a\x0\xe3\x1c\x0\xe2\x1d\x0\xe1\x1e\x0\xdf\x20\x0\xdd\x23\x0\xdd\x22\x0\xdb\x23\x0\xda\x25\x0\xd9\x25\x0\xd8\x27\x0\xd6\x29\x0\xd5\x2a\x0\xd3\x2c\x0\xd2\x2d\x0"\
  "\xd1\x2d\x0\xd0\x2f\x0\xcf\x30\x0\xce\x31\x0\xcb\x34\x0\xcb\x33\x0\xc8\x36\x0\xc5\x3b\x0\xc2\x3c\x0\xc0\x3f\x0\xbc\x43\x0\xba\x45\x0\xb7\x48\x0\xb4\x4c\x0\xb1\x4e\x0\xad\x51\x0\xaa\x55\x0\xa8\x58\x0\xa4\x5a\x0\xa1\x5e\x0\x9f\x60\x0\x99\x66\x0\x96\x68\x0\x93\x6c\x0\x90\x6e\x0\x8d\x72\x0\x8b\x74\x0\x8a\x75\x0\x88\x78\x0\x85\x79\x0\x82\x7d\x0\x7e\x80\x0\x7d\x82\x0\x79"\
  "\x86\x0\x77\x88\x0\x73\x8b\x0\x72\x8d\x0\x70\x8e\x0\x6e\x91\x0\x6a\x95\x0\x68\x97\x0\x65\x9a\x0\x63\x9d\x0\x62\x9e\x0\x60\xa0\x0\x5d\xa2\x0\x5c\xa3\x0\x5a\xa5\x0\x57\xa9\x0\x57\xa7\x0\x54\xab\x0\x53\xac\x0\x52\xad\x0\x51\xae\x0\x4f\xb0\x0\x4e\xb1\x0\x4d\xb2\x0\x4c\xb4\x0\x49\xb6\x0\x48\xb8\x0\x46\xba\x0\x45\xbb\x0\x43\xbd\x0\x43\xbc\x0\x40\xbf\x0\x3f\xc0\x0\x3e\xc1"\
  "\x0\x3d\xc2\x0\x3a\xc5\x0\x39\xc5\x0\x38\xc7\x0\x37\xc8\x0\x35\xca\x0\x34\xcb\x0\x32\xcc\x0\x31\xce\x0\x30\xd0\x0\x30\xce\x0\x2f\xd1\x0\x2e\xd1\x0\x2c\xd2\x0\x2b\xd4\x0\x2a\xd5\x0\x29\xd6\x0\x27\xd8\x0\x26\xda\x0\x26\xd8\x0\x25\xdb\x0\x24\xdc\x0\x21\xde\x0\x20\xdf\x0\x1f\xe1\x0\x1e\xe1\x0\x1c\xe3\x0\x1b\xe5\x0\x19\xe6\x0\x18\xe7\x0\x15\xeb\x0\x15\xea\x0\x14\xec\x0"\
  "\x12\xed\x0\x10\xef\x0\xf\xf0\x0\xd\xf2\x0\xa\xf5\x0\x9\xf6\x0\x7\xf8\x0\x5\xfa\x0\x3\xfb\x0\x1\xfd\x0\x0\xfe\x2\x0\xfb\x4\x0\xf8\x7\x0\xf6\xa\x0\xf3\xd\x0\xee\x12\x0\xaa\x54\x0\xa5\x5a\x0\xa2\x5d\x0\xa0\x60\x0\x9c\x62\x0\x99\x66\x0\x98\x67\x0\x94\x6b\x0\x92\x6d\x0\x91\x6e\x0\x8f\x70\x0\x8c\x74\x0\x8a\x75\x0\x86\x79\x0\x83\x7c\x0\x81\x7e\x0\x7e\x82\x0"\
  "\x7b\x83\x0\x79\x87\x0\x76\x8a\x0\x73\x8c\x0\x70\x8f\x0\x6a\x95\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0"\
  "\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0"\
  "\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x21\xf9\x4\x1\x0\x0\x0\x0\x2c\x0\x0\x0\x0\x20\x0\x20\x0\x40\x8"\
  "\xff\x0\x1\x8\x1c\x48\xb0\x60\x82\x7\x16\x3a\x8c\x30\x91\x82\xc5\x8b\x82\x10\x23\xa\xa4\x81\x83\xa0\x92\x27\x56\xb6\x88\x51\x23\xb1\xa3\xc0\x38\x78\xfe\x10\x4a\xe4\xb1\xa4\xc9\x93\x1e\xf\x30\x90\x90\x41\xa2\x8e\x1e\x40\x88\x20\x41\x29\xf1\x4b\x99\x36\x75\xf6\xd0\x8c\xe8\x8\xd2\xce\x92\x94\x2e\x6d\xf2\x14\x8a\xd4\xcf\x92\x1\x4\x14\x58\x10\x1\xc3\x87\x82\x32\x6a\xe4\xe0\x81\x72\xc2\x86\x10"\
  "\x1d\x83\x14\x49\xd2\x84\x8a\x96\xa3\x5\xa3\x5c\xe9\x42\x66\x8d\x1c\xb0\x4\xcf\xbc\xb1\xd3\x67\x10\x5a\x82\x80\xa\x29\x6a\xf4\xb6\xee\xce\x48\x93\x2c\x69\xb2\x4b\x50\x54\xa9\x53\x7c\x25\x6\x18\x60\xa0\x1\x5\xd\x22\x4a\xa0\x58\xe1\x22\xc6\xc\x1b\x34\x3\x10\x40\xe0\xa0\x2\x87\x88\x37\x76\xf8\x10\x82\x52\x1\x84\xb\x1e\x3a\xfe\x18\x62\x64\x9\x14\x94\x20\x48\x9c\x50\xd1\x2\x6\xc4\x23\x4c"\
  "\xa4\x60\xf1\x12\xd8\xc9\x94\x2c\x60\xcc\xb8\xe1\x5b\x85\x4b\x18\x34\x70\xee\x4\x1e\x93\x66\x4e\x1e\x3f\x81\xd9\xd0\xd1\x13\xc8\x50\x60\x0\x7c\x4\x1d\x5a\xf4\x1c\x0\x22\x46\x8f\xaa\x6b\xdf\xce\xbd\xa3\xa4\x4a\x98\x38\x7d\xb\x7a\x9e\xa9\x13\xa8\x51\xa6\xba\xbf\xd\x8\x0\x3b\xff"
#define HTS_DATA_UNKNOWN_GIF_LEN 1070

/* hexdump bg_rings.gif | cut -c9- - | sed -e 's/\([0-9a-f][0-9a-f]\)\([0-9a-f][0-9a-f]\)/\\x\2 \\x\1/g' | sed -e 's/ //g' | sed -e 's/^\(.*\)$/  \"\1\" \\/' */
#define HTS_DATA_BACK_GIF \
  "\x47\x49\x46\x38\x39\x61\xf5\x01\xc8\x01\xa2\x00\x00\xcc\xcc\xdd" \
  "\xc7\xc7\xda\xc4\xc4\xd7\xbe\xbe\xd3\xbd\xbd\xd2\xb9\xb9\xd0\xfe" \
  "\x01\x02\x00\x00\x00\x21\xf9\x04\xfd\x14\x00\x06\x00\x2c\x00\x00" \
  "\x00\x00\xf5\x01\xc8\x01\x40\x03\xff\x08\xba\xdc\xfe\x30\xca\x49" \
  "\xab\xbd\x38\xeb\xcd\xbb\xff\x60\x28\x8e\x64\x69\x9e\x68\xaa\xae" \
  "\x6c\xeb\xbe\x70\x2c\xcf\x74\x6d\xdf\x62\x20\x08\x43\xe1\xff\xc0" \
  "\xa0\x70\x48\x2c\x1a\x8f\xc8\xa4\xd2\x38\x68\x06\x02\xb8\xa8\x74" \
  "\x4a\xad\xc2\x74\x84\xa5\x76\xcb\xed\x7a\xbf\xe0\x30\xd8\x69\x2d" \
  "\x9b\xcf\xe8\x40\x4f\xcc\x6e\xbb\xdf\xf0\xb8\x9c\x4d\x20\x40\xd1" \
  "\xf8\xbc\x79\x3d\xef\xfb\xff\x42\x4d\x3b\x77\x7a\x12\x4f\x3b\x4d" \
  "\x80\x6d\x03\x02\x85\x8e\x8f\x0f\x02\x8a\x93\x94\x43\x02\x84\x90" \
  "\x99\x1f\x58\x95\x05\x8d\x9a\xa0\x24\x92\x9d\xa4\x6e\x03\xa1\xa8" \
  "\xa1\x3c\x73\x9f\xa9\x8e\x59\xa5\xb1\x5b\xad\xae\xb5\xb6\x20\x02" \
  "\xb0\x62\xb4\xb7\x28\xba\xb2\xc0\x43\xa7\xbd\xc4\xc5\x36\x7c\x5d" \
  "\xc3\xc6\x10\xc8\xc1\xce\x98\xcb\xd1\xd2\x67\xa3\x5c\xbc\x8e\xd5" \
  "\xce\xc0\xd7\xd3\xdd\xde\xa1\x01\xbf\x49\xdc\x33\x01\xda\xc1\xdf" \
  "\xe9\xea\xe9\xe1\x4b\x76\x29\xd9\xe7\x9d\xeb\xf4\x14\x3a\xcd\xf2" \
  "\x71\x82\xd0\xc4\xf1\x46\xe4\x13\xc4\xe5\x03\xa4\xac\x5e\x3f\x81" \
  "\x03\x13\xca\x61\x84\xcd\x88\x04\x7c\x0a\xe7\xf0\x33\xa8\xc7\x5c" \
  "\xc4\x71\x00\x7b\x71\x1a\x33\x91\xff\xca\x45\x82\x14\xf1\x20\x4c" \
  "\xd8\x31\xe4\x89\x5c\x4b\x32\x96\x80\xf8\xd1\x94\xc9\x29\x23\xb5" \
  "\x95\x7c\x89\x47\xcd\x91\x82\x1b\x5a\xfa\x51\x49\x33\x45\x4c\x60" \
  "\x33\x7b\x2e\x6b\x47\x84\x1c\x4b\x9d\x62\x70\x0a\x85\x47\x72\xa9" \
  "\xd3\x07\x3d\x18\x1c\x45\x0a\x86\xe7\x53\x0e\x3f\x4b\x05\xbd\xca" \
  "\x75\x2a\xd5\x2f\x5c\x49\x0c\x54\x1a\xb6\x6c\x83\xaf\x72\xcc\x7a" \
  "\xf0\x87\x4e\xad\xdb\x07\x59\xd1\x5a\x7b\x9b\x61\x2c\xdd\xbb\x0b" \
  "\xd8\xca\xad\x8a\x97\x82\x57\x52\x5b\xfb\x3a\xd5\xbb\x17\xac\x60" \
  "\x66\x76\x0f\xdf\x2d\x0c\x47\xb1\x83\xb8\xa4\x1c\xd3\xb5\xc8\xb8" \
  "\x8d\x55\xb5\x94\xf3\x49\xa6\x5b\xf9\x4d\x60\xb5\x11\x37\xbb\x25" \
  "\xdc\x99\x0b\xd9\xbe\x11\x09\x88\x36\x4b\xba\xf4\xac\xcd\xad\xb7" \
  "\xad\x0e\xeb\xfa\xcd\xe6\xcc\x0a\x3f\xcf\x66\x57\xdb\x8d\x6a\xc9" \
  "\xb8\x15\x9e\xde\x4d\x2f\x78\x6f\x30\xba\xc3\xc6\x3e\x97\x9c\x78" \
  "\xb1\xe5\xc7\x97\x34\xef\xfa\xf5\xb7\x73\x75\xd0\xa3\x2b\x19\x8e" \
  "\xd7\x78\xcb\x77\xd7\xa7\x41\xd6\xbe\x84\x7b\xdf\xbf\x17\xcd\x87" \
  "\xcf\xe4\x9d\x3c\xdf\xdd\x44\x4b\xab\x5f\x7f\x06\xbd\xfb\x2d\xf3" \
  "\x05\x67\x97\x3b\x60\x3a\xfd\x17\xff\xe3\xdd\x87\xdf\x7f\xf1\x09" \
  "\x18\x04\x43\xff\xc1\xb0\x9f\x81\x5a\xe4\x27\x9a\x4d\x0c\xce\x21" \
  "\xc8\x0e\x97\x3c\x61\xa1\x21\x16\x1e\xc2\x43\x13\x53\xd1\xb4\x60" \
  "\x84\x5a\x5c\x76\x1d\x4a\x20\x86\x16\x56\x81\x25\xc6\xe1\x1f\x7d" \
  "\x10\xa6\x38\xc7\x61\x28\xba\xa8\xcf\x8a\x09\x52\xb0\x43\x80\xd1" \
  "\x5d\xd7\x9e\x8c\x72\x88\x58\xe3\x8f\x4b\xd9\xc7\x63\x1c\x3e\x02" \
  "\x69\x24\x3d\x1f\x0e\xc9\xca\x91\x4c\xbe\x94\xa4\x92\x94\xf4\xd7" \
  "\xe4\x94\xd3\x3c\x09\xe5\x39\x64\x50\xa9\x25\x24\x56\x5e\xe9\x1a" \
  "\x87\x4f\x14\x77\xa3\x61\x5b\x3e\xd2\xa2\x97\x68\xa2\x59\xe6\x34" \
  "\x67\xa6\xe9\x66\x6d\x6b\x5e\x45\xe2\x9b\x74\x9e\x13\x27\x71\x73" \
  "\xd6\xa9\x27\x18\x77\xf6\x99\x57\x9e\x7b\x42\xe9\xe7\xa0\x29\x1c" \
  "\x22\x64\xa0\x7d\x30\x42\x23\xa1\x8c\xaa\x93\xe1\xa3\x90\x46\xfa" \
  "\x68\xa3\x94\x56\x6a\xe9\x94\x19\x52\xb8\x21\x87\x89\x84\xc1\xe9" \
  "\x84\x14\x66\x78\xe9\xa8\x43\x01\x8a\xa8\x36\xfb\x90\xea\xa7\x0e" \
  "\xa7\xb6\x5a\x44\x96\xaa\x52\xd4\xa6\xab\xb4\x02\x43\x40\x91\xb1" \
  "\xb6\x70\x68\xad\x3e\x28\x3a\xdb\x3d\xbb\x2e\x84\x6b\xac\x3b\x22" \
  "\x8a\x60\xae\x1c\x6c\x94\xe8\xa2\xff\x23\xba\x3a\x2c\xb2\x36\xac" \
  "\x62\x0a\xb3\x4b\xe1\x98\x22\xb5\xd0\xda\x22\xed\x7b\x1e\xd2\xe9" \
  "\x60\xb6\x93\x05\xfb\x03\xb6\x55\x74\x19\x1d\xb9\xe0\xee\xf6\x21" \
  "\x78\x67\x58\xeb\x1e\xba\xe9\x6e\x39\x2b\x13\x32\x98\xeb\x1a\xbc" \
  "\xf1\x66\x60\x21\x85\x9f\x0a\xf9\xa9\xa6\x17\x72\x95\xdd\xb7\x86" \
  "\x5c\x49\x70\xae\xf3\xf2\xda\xeb\xb3\x53\x64\x17\x94\xbd\x9d\x65" \
  "\x0b\xb1\x70\x8c\x5c\x12\x83\x86\x9d\xca\x71\xab\x19\x05\x46\xe0" \
  "\xee\x71\x95\xc6\xf8\x11\xc3\xf5\x28\x9b\x52\x14\x1f\xd7\x76\x30" \
  "\x8b\x2d\x91\x1c\x9e\xa9\x96\x98\x30\x71\x61\xf2\xa6\x96\x6f\x04" \
  "\x53\x39\x58\xac\x81\x4d\xce\x6c\xdb\xcd\x24\x88\x2c\x95\x92\x2e" \
  "\xdf\xb5\x73\x64\x40\xd7\x20\xae\xca\x35\x0e\x64\x5d\xd2\x35\xf8" \
  "\x2c\x57\xd1\x65\xa5\x2c\x21\xd4\x52\x48\x8d\xd6\xca\x6e\x2d\x7d" \
  "\x35\xd6\x52\x1c\x2d\x20\xd5\x4e\x25\x06\x76\xd6\x06\xc3\x67\xf6" \
  "\xd9\x51\x88\x3d\xf6\x6c\x56\x7f\xcd\xb6\x14\x5e\xf7\x46\xf6\x4b" \
  "\x75\x2f\x39\x37\xdd\x68\xe2\x6b\x50\xdc\x7d\xec\x8d\x36\x9a\x77" \
  "\xcb\x1a\x91\xdf\x82\x6b\x90\x37\xc8\x9b\xa5\x97\x78\xb4\x6f\x22" \
  "\xbe\xce\x47\x5c\x3f\x0e\x02\xe0\xff\xd1\x3d\x0d\xe3\x77\x96\xc7" \
  "\xb0\xb8\x76\xa2\x61\x0e\x52\xe7\x2c\x68\xfd\xa5\x68\x9f\x2b\xa2" \
  "\x39\xe9\xa2\xec\xb9\xfa\x61\xa6\xfb\x21\x79\xe2\x6e\xf3\x58\xf9" \
  "\x53\xb1\x03\x32\x3b\xd8\xa9\x0b\xb8\x3b\x92\xf2\xfd\x0e\x6e\xee" \
  "\xe7\x3a\x47\x7c\x29\x85\x67\x2b\x3a\x88\xb7\xab\xd5\xfb\x45\x16" \
  "\xef\xfd\x3c\x88\xc2\xd3\x34\x7d\x65\xb0\x5a\x2a\xb2\xb3\x4c\x1e" \
  "\xaf\x70\x10\x4f\x2d\x4f\xf4\x9a\xdb\x7e\xaf\xc5\x64\xe2\xa7\x1d" \
  "\x32\xcc\x74\xae\x76\x3d\xe1\x73\xeb\xb0\x21\x52\xa9\x02\xe9\xbd" \
  "\x97\xc9\xb3\x9e\xed\xfb\xa7\xe6\xaf\xff\xa5\xb5\x33\x5f\x79\xfc" \
  "\xf7\xbf\x3e\xf1\x4f\x80\xaf\xaa\x5e\x01\x59\x94\x3e\x04\xbe\x21" \
  "\x7b\xeb\xb9\xc7\x0f\x16\x38\x01\xf6\x39\xd0\x5b\xfd\x3a\xe0\x8b" \
  "\x28\x98\x03\x0d\x5e\xf0\x83\x0e\xe1\x20\x0d\x12\x06\xc2\x12\x26" \
  "\x41\x84\x99\xb0\xa0\x09\x69\x85\xc2\x75\x48\x70\x85\x43\x6a\x21" \
  "\x70\x54\x08\x43\x3b\xc9\x90\x54\x18\xf3\x20\xf6\x7c\x75\xc3\x1e" \
  "\xfa\xf0\x87\x40\x0c\xa2\x10\x87\x48\xc4\x22\x76\x2e\x87\x0c\x02" \
  "\x55\x98\x8c\x88\xb5\x17\xd6\x10\x09\xf5\x63\x62\x78\x4c\xf6\xc4" \
  "\x60\x40\x50\x8a\x25\xd3\x61\x15\xff\x65\x51\x07\x05\x62\xb1\x04" \
  "\x24\xdc\xa2\x9b\x76\xf0\xc5\x7a\x89\x51\x8c\xc7\x2a\x23\x06\xc2" \
  "\x78\xc6\x06\x81\x6a\x10\x93\x5a\xe3\xa3\x34\xb5\x29\x2d\x52\x62" \
  "\x63\x5f\xbc\x5f\x9a\xa2\xd8\x13\x43\xd9\x31\x44\x5e\xa4\xd4\xf6" \
  "\x04\x78\xab\x40\x3a\xc5\x89\x9d\xc0\x23\xd8\x02\x58\xa7\xe8\xe5" \
  "\x8b\x8a\x7d\x20\x20\x7d\xfe\x58\x1b\x45\x8a\x10\x92\x2e\x89\xd3" \
  "\x20\xe9\x24\x49\xd2\xb1\xb1\x0b\x9d\x0c\xd2\xa9\x9a\xa7\x46\x05" \
  "\xd0\x30\x44\xa1\x0b\x94\x21\xd5\x58\xbe\x2f\x84\xd2\x16\x0d\xac" \
  "\xcd\x2b\x4b\xc9\x81\x53\x1a\x81\x5d\x21\xa1\x24\x52\x56\x49\xcb" \
  "\x11\xd8\xb2\x28\xe9\xe0\x64\x2f\xa5\xf1\x24\x52\x52\x81\x91\xbe" \
  "\x1b\x26\x45\x92\x64\x4c\x19\xb8\x89\x97\xca\xd4\x43\xb0\x66\xc9" \
  "\x01\x5d\x0a\x27\x9a\x7d\x59\x50\x33\x3f\x00\x3f\x6c\xae\x66\x3f" \
  "\xb8\x5c\x81\x1e\x1d\xe7\xcd\xff\x08\x29\x9c\x22\x18\xa7\x89\x7a" \
  "\x28\x3f\x6b\x7a\x81\x43\x8e\xc4\x4e\x79\x70\xa1\xbe\xc7\x21\x12" \
  "\x83\xd0\x44\x41\x76\x8a\x54\xcf\xa4\xfd\xf2\x82\x57\xcc\xc3\x72" \
  "\xfc\x02\xa5\x6d\x52\x49\x9d\x84\xa4\xa6\x07\x20\x32\x81\x2b\x21" \
  "\xcc\x9d\xfa\x88\xa7\x23\x80\x35\xff\xad\x72\xf9\x20\x02\xc8\xec" \
  "\x8d\x41\x23\x58\x18\x89\x86\x04\x93\x49\x90\x92\x45\x95\x94\x4f" \
  "\xb5\x20\xf4\x0b\x22\x15\xcd\x3f\x0b\x90\xd2\x18\x9c\x54\x1e\x83" \
  "\xca\x68\x25\x36\x8a\x97\x56\x16\x21\x94\x32\xbd\x97\x26\x29\x37" \
  "\xaa\x53\xde\x0d\x4a\x25\xed\x09\x44\x91\xf0\xba\xfd\x1d\x61\x58" \
  "\x43\xb5\xa2\x96\x5e\x4a\xd4\xce\x4d\x45\x25\x39\x2d\x4d\x50\x0d" \
  "\x12\x55\xbd\x71\x90\x30\xbc\x60\xaa\x33\x8a\x4a\x1f\xad\xde\x74" \
  "\x88\xc8\x18\xda\x90\x68\x5a\x16\xaf\x12\xa1\x97\x49\x95\xcd\x8f" \
  "\x12\xa2\xcc\x82\xd6\xc8\xac\x42\x50\xa8\xe0\xd2\x0a\x8c\x04\xd1" \
  "\x35\x08\x53\xf5\x27\x50\xbb\x3a\x90\x72\x56\x15\x7b\x1c\xcd\x87" \
  "\x5c\x2d\x77\xd7\x58\xe4\xd5\x18\x85\x9d\x60\x39\x01\xf0\xd7\xca" \
  "\x84\x67\x6d\xde\x84\x6b\x5d\x9d\x03\x59\x6f\x26\xb6\x14\xce\xb9" \
  "\x6c\x01\x16\xcb\x00\x2f\xe1\x69\x20\x83\x65\x9d\x97\x0e\x6b\x8b" \
  "\xa6\x70\x56\x01\xb1\xdc\xda\xaf\xd8\x7a\x5a\x05\x68\x16\x69\x2a" \
  "\x35\xed\x69\x25\x0b\x0c\xb2\x96\x2c\x21\xb6\x95\x61\x37\x1b\x27" \
  "\x5b\xce\xd2\x16\x28\xa8\x53\x48\x6b\x15\x90\x26\xd2\xa2\x62\x9d" \
  "\x9c\x6d\x6c\x69\x42\x6b\x0c\xe4\xff\x2e\xf6\xb7\x6a\x75\x8c\x72" \
  "\xe1\xc0\x5c\xc2\xba\x49\x34\x17\x31\x2e\xd4\x5e\x6b\xd8\xcd\x70" \
  "\xf7\xa2\xbe\x7d\xd3\x6d\x3e\xa2\xdd\x9b\x4d\x77\xb9\xb0\x19\xd9" \
  "\x62\x85\x29\x99\xef\xfa\x80\xab\xac\xa4\x53\x79\x33\xe1\xde\x5e" \
  "\x79\xb3\x91\xe9\x6d\x49\x6e\x59\x07\x5d\x54\x8d\x57\x27\xf0\x65" \
  "\x62\x7d\x63\x11\x5b\xa4\x54\x37\x69\xa9\x45\xaf\x77\xbf\x72\xe0" \
  "\x7c\x05\xca\x7d\x68\x69\x30\xb8\x02\xb5\x5f\x79\xca\x65\xbe\x94" \
  "\x4a\xf0\xe9\x56\xa3\xe1\x3e\xa0\xf3\x87\x03\xae\xed\x6a\x19\x23" \
  "\x61\xed\x9d\x2a\xc0\xdd\x51\x70\x0f\x3b\x5c\x1b\x0c\x87\x22\xc4" \
  "\x50\x94\xe1\x79\xdd\x53\xe1\x7a\xf4\x97\x23\x14\x84\xb1\x33\x4a" \
  "\x6c\x8c\x1b\x27\xc5\xc5\xeb\xd1\xf1\x33\xa6\xc8\xe2\xda\x02\x99" \
  "\xc3\xbc\x3a\x72\x2a\x7c\xcc\x0a\x25\xdf\x45\xc8\xda\xe0\x71\x95" \
  "\xa0\xd4\xc5\x5c\x41\x59\x1b\x28\x5e\xcd\x27\x95\x54\x87\x41\x58" \
  "\xc1\xc9\x60\x14\xa0\x94\xd3\x71\xe5\x18\xe6\x12\x81\x63\x76\x54" \
  "\x99\x05\x24\x94\x19\xbb\x28\xcd\x36\x2e\x72\x9d\x04\xf6\xc1\x1a" \
  "\x4f\x66\xa5\xb5\x1a\x4d\x09\xe1\xdc\x66\x3c\xa7\x29\x9b\x2b\xe4" \
  "\xf3\x89\x6c\xea\x50\xc7\x30\x19\xff\xb0\x8f\x44\x04\x9b\x7f\x25" \
  "\x67\x1e\x09\x1a\x48\xfb\xe2\xd7\xa7\x92\x40\x80\x7f\x85\x6a\x89" \
  "\x71\x3a\xb4\x2c\x87\x6b\xc0\x36\xb2\x14\xcc\x9c\x96\xc6\x9a\x19" \
  "\xd3\xd2\x50\x1b\x69\xd4\x2a\x36\xf5\x5b\x3d\x7d\x13\x50\xab\x5a" \
  "\x13\x5b\x66\xf5\xa7\x5f\x4d\x9c\x4d\xca\x9a\x08\x69\xa4\xb5\x60" \
  "\x6c\x7d\xeb\x90\xba\x5a\xd7\x38\x40\xb5\x9b\x02\x0a\x6c\x93\xf8" \
  "\xb9\xd7\x49\xe1\xe1\x64\x40\xaa\xd8\x16\x6a\x1a\xd9\x3f\x50\xa2" \
  "\x8b\x73\xa8\x41\x22\x1e\x1b\xda\xc8\x2e\xe5\xb3\xb1\xed\xa2\xe7" \
  "\x36\x9a\xdb\xd7\x55\x75\xac\xc1\xad\xb0\x62\x3b\x60\xdc\xe4\x6e" \
  "\x9f\xb9\x2f\x80\xee\x74\xa7\x68\xdd\xbe\xfc\xb6\xbb\x61\x0a\xef" \
  "\x16\xec\x60\xde\xa0\xab\x77\xdb\x08\x8d\x6f\xe1\xea\x7b\xa2\xfc" \
  "\xee\xf7\x24\xfe\x1d\x8d\x7b\x0a\x1c\x3f\x1e\x25\x38\x4d\xda\x79" \
  "\xc6\x8a\x29\x7c\x55\xf2\xdb\x14\xa9\x2b\x56\xa1\x87\x5b\xfc\xe2" \
  "\x18\xcf\xb8\xc6\x37\xce\xf1\x8e\x7b\xfc\xe3\x20\x0f\xb9\xc8\x47" \
  "\x4e\x72\xfd\x69\x48\xe2\xdf\x81\x27\x1c\x4b\x7e\x27\x3f\x62\xd0" \
  "\x09\xbf\x66\xf9\x14\x5c\xfe\x44\x3e\xca\xdc\x85\x01\x07\xb7\xcd" \
  "\x6f\x0e\xeb\x6b\x0b\xbc\xcb\x31\xff\xef\x78\xce\x0f\x6e\x8a\x84" \
  "\xf3\xfc\x04\x6a\x10\xf6\x19\xab\x7c\x74\x0f\xb4\x9b\xe8\x5b\xfd" \
  "\x70\xd3\x4d\x29\x6f\xa8\x2b\x22\xd7\x23\xf7\xb9\xd5\x0b\x83\x75" \
  "\x8b\x6b\x7d\xeb\xda\x29\x75\xb1\x95\x0e\xf6\x49\x74\x7d\xb1\x4f" \
  "\x2f\x3b\x9d\x2c\xd9\xcb\xb4\x6f\xb1\x0e\xb7\xaa\x90\x71\x23\x3d" \
  "\xbf\xc2\xb0\xbd\x88\xdb\x26\x4f\xc5\x82\xde\x01\x8c\x51\x8e\xef" \
  "\x35\xe2\xf5\x05\x81\x6e\x34\x83\x47\x77\x81\x79\xe7\x8f\xd1\xe1" \
  "\x53\xf7\x58\x88\x7d\x6e\x64\xc7\x12\xe0\x87\x92\x74\x52\x3c\x3e" \
  "\x5f\x91\xdf\xc6\xe4\x3f\xfa\xf5\x06\x6d\xde\x7a\x08\xbc\xfc\xcd" \
  "\x86\x6e\x99\x58\x25\x5e\xb0\x14\xbc\xf7\x4e\x1a\xe5\x66\x01\x89" \
  "\x5e\x84\xa4\x7f\xe7\xe7\x6d\x91\x79\x40\x3c\xfa\x52\xb1\x9f\x0b" \
  "\x93\x5a\xaf\x9d\xdb\x0f\x6f\x7a\xaf\xff\x66\xab\xec\x2c\xc3\xce" \
  "\x47\x7b\xf6\x55\xa8\xfa\x85\xf5\xed\xf6\x98\x49\x46\xf9\x54\x21" \
  "\x7e\x7c\xd9\xe0\xfb\x32\xf0\x3e\xd5\x1f\x87\x58\xf5\x51\xa6\x27" \
  "\xe9\x0f\xb7\xf9\x3f\xd8\xbe\x0c\xa0\xff\x91\x2c\x97\x1c\xfc\xc1" \
  "\xf7\x46\xed\x4b\x3f\x75\x1b\x59\xcd\xfb\x0d\x5b\x7b\xfb\x37\xd0" \
  "\x7c\xf1\x83\xe0\xfa\x7b\xb1\x3f\xff\xad\x97\x96\x7e\x50\x90\x3f" \
  "\x37\xf3\x77\x12\x5e\xa0\x7f\x36\x12\x39\x01\x58\x3a\xc9\x30\x79" \
  "\xff\x37\x10\xc8\x07\x6f\x49\x42\x80\x8c\xf5\x4c\x07\x78\x03\xc1" \
  "\x02\x7f\xd5\x54\x5c\x13\x38\x73\xbb\xd2\x7f\x33\x90\x26\x10\xc8" \
  "\x73\x78\x46\x5a\xf8\x87\x14\xe6\x97\x81\xc1\xf6\x1a\x90\x33\x5a" \
  "\x26\xc8\x25\x38\xc2\x5c\xeb\xd7\x05\x25\xb8\x82\x65\x70\x28\x0a" \
  "\xb5\x80\x32\x21\x83\xb5\xb0\x1f\xa1\x64\x83\xce\x80\x83\xc4\x20" \
  "\x78\x3e\xe0\x3f\x5e\x62\x81\xc8\x82\x44\x8e\x47\x71\x98\x26\x2b" \
  "\x01\x72\x37\x3c\x78\x78\xa9\x97\x7b\xf4\xa3\x6c\xdd\x20\x24\xcc" \
  "\xd2\x84\xb2\xd0\x80\x46\x63\x7c\x9d\xb1\x73\xb5\x60\x1f\x52\x17" \
  "\x10\x57\x82\x85\x83\x66\x85\x24\x78\x77\xa0\x60\x1f\xdf\xf2\x82" \
  "\x5b\xc0\x36\xac\x52\x43\x4c\xa7\x09\xf6\x51\x01\xa7\x97\x16\x49" \
  "\x03\x7e\x0e\xc4\x81\x61\x93\x15\xf6\x10\x86\xf9\xa2\x85\x2b\x64" \
  "\x86\x5f\x56\x04\x14\xc0\x87\x12\x53\x22\x6f\x24\x2a\x15\x90\x29" \
  "\x92\xf6\x47\x80\x38\x38\x40\x30\x01\x6a\x78\x32\xb9\xe2\x87\xa8" \
  "\xb2\x78\x37\xc0\x70\x70\x70\x76\x14\xd8\x6c\x91\xe0\x56\xaa\xa2" \
  "\x74\x52\xe8\x0a\x14\xb5\x0b\xc7\xff\x04\x5f\x85\x76\x29\xa3\xf6" \
  "\x81\x23\xc0\x6c\xe3\x80\x06\x91\xa8\x04\x62\x88\x58\xfc\x11\x8b" \
  "\xa2\x20\x2e\x8d\x58\x0e\x50\xa2\x8a\xe9\x30\x87\xba\xb8\x6f\xd6" \
  "\x82\x87\x28\xf0\x8a\x27\xc4\x28\x30\x06\x8c\x77\xb1\x52\xa1\x35" \
  "\x82\xd0\x13\x53\x06\x76\x24\xe3\x46\x4d\xc2\x88\x04\xab\xa2\x13" \
  "\xb4\xa8\x09\xd0\xd1\x49\xb9\xd8\x72\x2d\x51\x8d\xb5\xb0\x65\xc9" \
  "\x33\x87\x8d\xb1\x26\xca\xe8\x4a\xa6\x97\x15\x5f\x88\x01\x64\xd8" \
  "\x09\xbd\xd8\x0b\xee\xc5\x8d\x64\x26\x8d\xc9\xb2\x57\x4b\x65\x33" \
  "\x58\xe3\x15\xcd\x01\x8e\x3f\x43\x25\xe9\xf8\x03\x31\x68\x54\x5f" \
  "\x55\x01\xd1\xf8\x0f\x54\x32\x8e\x5b\xd0\x8f\x89\xf6\x2a\x0d\x45" \
  "\x52\x53\xe2\x63\xee\xa8\x67\x44\x80\x4e\x04\xc9\x5a\x4c\xf2\x5a" \
  "\x44\x48\x29\x47\xc1\x00\xf8\xe8\x06\x4d\xb2\x8f\x05\xd0\x90\x86" \
  "\x26\x04\x18\xa9\x24\x15\x19\x12\xfe\x36\x44\xd5\x20\x56\xb6\x73" \
  "\x24\xb8\x85\x45\x98\x10\x90\x08\x09\x24\xfb\x38\x92\x40\xe3\x92" \
  "\xc0\xf4\x23\x9a\x25\x93\x33\x39\x3e\xab\x96\x0f\x38\x09\x34\x1c" \
  "\x39\x09\xeb\xf8\x08\x12\xd9\x4b\x3f\x79\x75\x35\xb2\x8f\xd8\x44" \
  "\x93\xc2\x90\x20\x11\xd9\x8a\xd1\xff\xa4\x94\x43\x90\x20\x48\x99" \
  "\x94\x82\xc2\x32\xa8\x87\x4d\x19\xd9\x06\x1e\x79\x0c\x7d\xe5\x4d" \
  "\x4d\x79\x95\x8f\x05\x96\xd8\x44\x65\x81\x25\x0f\x5b\xc9\x24\x45" \
  "\xa9\x08\x67\x69\x46\x9a\xb1\x58\x50\x19\x57\xe1\x71\x59\x3d\x79" \
  "\x36\x59\xd9\x06\x61\x29\x0f\x73\x79\x36\x84\x48\x1c\x95\xf5\x94" \
  "\x9e\xc8\x97\x3c\x39\x5b\x7b\x39\x1b\x7d\x19\x4d\xfd\xb4\x1a\x43" \
  "\x59\x4e\x75\xc9\x06\x6b\xe9\x02\x9a\xd5\x5a\x5f\x19\x98\xea\xc2" \
  "\x80\xad\xf5\x96\x42\xd0\x98\x08\x28\x99\xc9\xe5\x59\xbb\x91\x98" \
  "\xe5\x64\x99\x07\xb2\x1b\x9a\x15\x94\x96\xa2\x82\xc2\xd7\x95\x82" \
  "\x79\x8a\xd8\x05\x5a\xc3\x35\x84\xb3\x71\x63\xc3\xb5\x98\xd4\x47" \
  "\x98\xac\x59\x99\xa6\x99\x5f\xf9\x80\x99\x4c\xa2\x26\x88\xe9\x99" \
  "\x91\xc5\x9b\xb8\x89\x97\xc3\x05\x9a\x20\x19\x5c\x85\x19\x4d\x69" \
  "\x39\x09\x06\xc9\x15\x0a\x41\x9a\x95\x82\x26\x79\x99\x0a\x91\x89" \
  "\x04\xce\xd9\x28\xb2\xc9\x06\xd1\x89\x0a\x3e\x56\x9d\x8c\x72\x9d" \
  "\x49\x51\x60\xb5\xc9\x59\xc4\x19\x9a\x0b\xb6\x92\xa7\x95\x9c\x94" \
  "\x60\x9c\xc7\x39\x4c\xe8\x39\x70\xe5\xe9\x9b\x86\xf9\x67\xef\x49" \
  "\x99\x9c\x25\x81\xed\x15\x11\xdc\xff\x39\x28\x63\x14\x9c\xf9\xb0" \
  "\x9c\x45\x34\x6c\xfc\x99\x9b\xf5\x19\x6e\xd2\x45\x4e\xe5\x64\x80" \
  "\xcf\x97\x5d\x8b\xd5\x9e\x40\x39\x9f\x4e\xb3\xa0\xe2\x05\x1c\xea" \
  "\x65\x59\x08\xea\x18\xc9\xa9\x9b\xff\xe1\x9d\x8b\x10\xa0\xa8\xa9" \
  "\x4c\x1a\xaa\x95\xbc\x75\x11\xfe\xf9\x43\xd3\x89\x9f\x1c\xaa\x99" \
  "\xc3\x34\x67\x9b\x81\x9e\xd9\x99\x2e\xe3\x89\x6b\x27\x8a\xa2\xda" \
  "\x56\x27\x18\xba\x12\x3a\xd1\xa2\xd0\x52\xa2\xf4\x98\xa0\x9c\x43" \
  "\x94\xf8\x25\xa1\xbb\x44\x4b\x1f\xea\x06\x35\xda\x3a\xcd\x58\x4a" \
  "\x7a\x32\xa2\xa2\x44\x3f\xa5\xf4\xa2\xff\x78\x9f\x54\x51\xa4\x40" \
  "\xfa\xa3\x50\xca\xa4\x5f\xc4\xa0\x80\xa1\x9e\x41\x2a\x45\x3a\x2a" \
  "\xa2\x10\x56\x1d\x58\xe4\xa4\x45\xa0\xa4\x4b\x01\x8e\x38\x2a\x48" \
  "\x14\xa6\x65\xf9\x67\x44\x62\xfa\x92\xb7\x81\xa5\x40\x90\x9f\xf4" \
  "\x61\x2c\xb3\xb1\x66\x72\xda\x2c\x69\x7a\x9a\x7b\x71\xa6\x7d\x02" \
  "\xa7\x96\xb7\x1b\x7e\x0a\x04\xe7\xb8\x40\x5d\xda\xa3\x7a\xda\x51" \
  "\x3e\x34\xa4\x71\x40\xa6\x4f\x21\x6c\xc6\x38\x57\xad\x22\xa5\x26" \
  "\x50\xa8\xdf\xd9\x42\x81\x4a\x0a\x77\x7a\x03\xde\xc9\xa7\xce\xe8" \
  "\x2a\x9c\xfa\x62\x1a\x95\x7a\xae\xff\xc2\xa8\x57\x51\x7b\x8f\x3a" \
  "\x7a\xb4\x22\xa9\xc1\xd8\x7b\xac\xd3\xa6\x4e\x99\x59\xe4\x71\x8b" \
  "\xdb\x45\x2b\x83\xaa\x18\xaf\x28\xab\xf9\x72\xa9\xb1\x90\xa9\x8e" \
  "\x78\x1f\x96\x08\x2e\xba\x5a\x0a\xb5\xaa\x18\x94\x08\x3d\xaa\xda" \
  "\x0b\xc1\x8a\x3c\xe6\xe4\x22\xa7\xea\x27\xae\x2a\x1d\x19\x2a\x92" \
  "\xbc\x3a\x0d\xcf\xba\x1d\x35\x22\xa6\x5d\x86\x8a\xdf\x33\xad\x55" \
  "\x50\xad\xbd\xd2\x1f\xc7\x1a\x7f\xdf\x13\xae\x2c\x60\x87\x86\xb8" \
  "\x0f\x5e\xe4\x77\xe0\xb5\x8b\x02\x44\xae\xe5\xea\xad\x1f\x71\x5b" \
  "\xe6\x33\xac\xa2\x09\x76\x21\x91\xac\x22\xd6\x3d\xf8\xea\x1e\x78" \
  "\x13\x7a\x07\x35\x6f\x3d\xa1\xa8\x33\xe5\xae\x17\x03\xaf\xe9\xd9" \
  "\x66\xfb\x6a\x2b\x04\x2b\x03\xe6\xca\x2b\xa5\xfa\x41\x0b\x4b\x03" \
  "\xc5\xaa\x6e\x57\x41\xa9\xd8\x27\x2f\x02\x3b\x59\x65\x61\xb0\xa6" \
  "\x41\x28\xac\xd8\x2a\x6f\x91\xb1\x5a\x41\x29\x50\x08\x9c\x6f\xc1" \
  "\xb1\xc9\xd0\x53\x22\x2b\x06\xbb\x06\x43\x11\x9b\x06\x63\xa2\x9a" \
  "\xe7\x01\x43\x9f\xea\x16\xf2\x93\xb0\x4a\xf0\xa6\x35\xc4\xad\x25" \
  "\x33\x8a\x1b\x06\x9e\x30\xc4\xb3\x4b\x61\x84\xa5\x30\x21\x49\x18" \
  "\xad\x55\x24\xb4\x3e\x08\x89\x62\xff\xa4\xb4\x4b\xfb\x00\x40\x88" \
  "\x66\x4f\x5b\x1c\x9e\x56\xb3\x53\x1b\x66\x55\xfb\xb2\x37\xb7\xb2" \
  "\x09\xe1\xb4\x4f\xcb\xb5\x09\x81\xab\x57\xab\x9d\xd0\xd6\xac\x63" \
  "\x5b\x13\xdc\x66\xb6\x67\x6b\x7d\x38\x4b\x6a\x5e\x3b\x81\x28\x5b" \
  "\x09\x6f\x3b\x7f\x60\xfb\x15\x9a\xb8\xb6\x02\x75\x70\x6a\x8b\xb7" \
  "\x34\x10\xb7\x46\xc6\xb7\x85\x50\xb7\x9d\x51\x48\x80\x7b\x06\x0d" \
  "\x5b\xb5\x73\x9b\x7d\x6a\x17\x04\x84\x5b\xb8\x51\xe0\xb7\xfa\xb5" \
  "\xb7\x8e\xdb\x77\x90\x6b\xb7\xbf\xca\x22\x89\xeb\x21\x6d\x5b\x27" \
  "\x30\xf7\x2b\x84\x26\xaa\x8b\x8b\x9d\xa1\xb8\x70\x86\x27\x88\x28" \
  "\x24\xb8\xc3\x87\xae\xb7\xd0\x4e\xbd\x93\xa8\xa1\x8b\x2a\x87\x88" \
  "\x88\xf7\xa7\x88\x75\x44\x60\x41\x34\xb1\xaf\x0b\xb2\x45\x74\xb8" \
  "\xb9\x7b\x2a\x65\x54\xb9\xbd\xdb\x05\xbd\x84\xbb\xc1\xcb\x23\x14" \
  "\x5a\xbc\x02\x34\x5b\xc0\x8b\xbc\x9b\x15\x6a\xc4\xcb\xbc\xae\x01" \
  "\x6c\xcf\x0b\xbd\x72\x51\x6f\xd3\x4b\xbd\xf1\xaa\x70\x25\x8b\xbd" \
  "\x11\x93\x71\xbc\xcb\xbd\x1d\xca\x71\xdb\x0b\xbe\xce\x15\x72\xd7" \
  "\x4b\xbe\x74\xc8\x73\x1f\x8b\xbe\x3d\x38\x81\xe3\xcb\xbe\x7e\xb0" \
  "\xb4\xeb\x0b\xbf\x1b\x74\xb6\x95\x58\x47\xbf\x7f\x30\xb9\x0a\x30" \
  "\xbf\xf8\xbb\x04\xfa\x1b\x01\xef\xdb\xbf\xcd\xfb\xbf\x89\x78\xbf" \
  "\x02\x7c\x56\x04\xec\x74\x8d\x47\xbf\x56\xdb\x74\x86\xd2\xbb\xa3" \
  "\x9b\xc0\x0c\xab\x68\x69\x4b\x46\x12\xdc\x73\x0b\xfc\x3d\x5c\x78" \
  "\xc1\xdd\x40\xb4\xcc\xb3\x77\x5a\xcb\xc1\xfa\x72\x72\x75\xf4\x47" \
  "\x9c\x02\x30\x47\x2b\xc2\x2a\xbc\xc2\x2c\xdc\xc2\x2e\x0c\x6f\x09" \
  "\x00\x00\x3b\x00"

#define HTS_DATA_BACK_GIF_LEN 4243

#define HTS_DATA_FADE_GIF \
  "\x47\x49\x46\x38\x39\x61\x8\x0\x8\x0\xf7\x0\x0\x0\x0\x0\x0\x0\x33\x0\x0\x66\x0\x0\x99\x0\x0\xcc\x0\x0\xff\x0\x33\x0\x0\x33\x33\x0\x33\x66\x0\x33\x99\x0\x33\xcc\x0\x33\xff\x0\x66\x0\x0\x66\x33\x0\x66\x66\x0\x66\x99\x0\x66\xcc\x0\x66\xff\x0\x99\x0\x0\x99\x33\x0\x99\x66\x0\x99\x99\x0\x99\xcc\x0\x99\xff\x0\xcc\x0\x0\xcc\x33\x0\xcc\x66\x0\xcc\x99\x0\xcc\xcc"\
  "\x0\xcc\xff\x0\xff\x0\x0\xff\x33\x0\xff\x66\x0\xff\x99\x0\xff\xcc\x0\xff\xff\x33\x0\x0\x33\x0\x33\x33\x0\x66\x33\x0\x99\x33\x0\xcc\x33\x0\xff\x33\x33\x0\x33\x33\x33\x33\x33\x66\x33\x33\x99\x33\x33\xcc\x33\x33\xff\x33\x66\x0\x33\x66\x33\x33\x66\x66\x33\x66\x99\x33\x66\xcc\x33\x66\xff\x33\x99\x0\x33\x99\x33\x33\x99\x66\x33\x99\x99\x33\x99\xcc\x33\x99\xff\x33\xcc\x0\x33\xcc\x33\x33"\
  "\xcc\x66\x33\xcc\x99\x33\xcc\xcc\x33\xcc\xff\x33\xff\x0\x33\xff\x33\x33\xff\x66\x33\xff\x99\x33\xff\xcc\x33\xff\xff\x66\x0\x0\x66\x0\x33\x66\x0\x66\x66\x0\x99\x66\x0\xcc\x66\x0\xff\x66\x33\x0\x66\x33\x33\x66\x33\x66\x66\x33\x99\x66\x33\xcc\x66\x33\xff\x66\x66\x0\x66\x66\x33\x66\x66\x66\x66\x66\x99\x66\x66\xcc\x66\x66\xff\x66\x99\x0\x66\x99\x33\x66\x99\x66\x66\x99\x99\x66\x99\xcc\x66\x99"\
  "\xff\x66\xcc\x0\x66\xcc\x33\x66\xcc\x66\x66\xcc\x99\x66\xcc\xcc\x66\xcc\xff\x66\xff\x0\x66\xff\x33\x66\xff\x66\x66\xff\x99\x66\xff\xcc\x66\xff\xff\x99\x0\x0\x99\x0\x33\x99\x0\x66\x99\x0\x99\x99\x0\xcc\x99\x0\xff\x99\x33\x0\x99\x33\x33\x99\x33\x66\x99\x33\x99\x99\x33\xcc\x99\x33\xff\x99\x66\x0\x99\x66\x33\x99\x66\x66\x99\x66\x99\x99\x66\xcc\x99\x66\xff\x99\x99\x0\x99\x99\x33\x99\x99\x66"\
  "\x99\x99\x99\x99\x99\xcc\x99\x99\xff\x99\xcc\x0\x99\xcc\x33\x99\xcc\x66\x99\xcc\x99\x99\xcc\xcc\x99\xcc\xff\x99\xff\x0\x99\xff\x33\x99\xff\x66\x99\xff\x99\x99\xff\xcc\x99\xff\xff\xcc\x0\x0\xcc\x0\x33\xcc\x0\x66\xcc\x0\x99\xcc\x0\xcc\xcc\x0\xff\xcc\x33\x0\xcc\x33\x33\xcc\x33\x66\xcc\x33\x99\xcc\x33\xcc\xcc\x33\xff\xcc\x66\x0\xcc\x66\x33\xcc\x66\x66\xcc\x66\x99\xcc\x66\xcc\xcc\x66\xff\xcc"\
  "\x99\x0\xcc\x99\x33\xcc\x99\x66\xcc\x99\x99\xcc\x99\xcc\xcc\x99\xff\xcc\xcc\x0\xcc\xcc\x33\xcc\xcc\x66\xcc\xcc\x99\xcc\xcc\xcc\xcc\xcc\xff\xcc\xff\x0\xcc\xff\x33\xcc\xff\x66\xcc\xff\x99\xcc\xff\xcc\xcc\xff\xff\xff\x0\x0\xff\x0\x33\xff\x0\x66\xff\x0\x99\xff\x0\xcc\xff\x0\xff\xff\x33\x0\xff\x33\x33\xff\x33\x66\xff\x33\x99\xff\x33\xcc\xff\x33\xff\xff\x66\x0\xff\x66\x33\xff\x66\x66\xff\x66"\
  "\x99\xff\x66\xcc\xff\x66\xff\xff\x99\x0\xff\x99\x33\xff\x99\x66\xff\x99\x99\xff\x99\xcc\xff\x99\xff\xff\xcc\x0\xff\xcc\x33\xff\xcc\x66\xff\xcc\x99\xff\xcc\xcc\xff\xcc\xff\xff\xff\x0\xff\xff\x33\xff\xff\x66\xff\xff\x99\xff\xff\xcc\xff\xff\xff\x21\xe\x9\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0"\
  "\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x21\xf9\x4\x1\x0\x0\xd8\x0\x2c\x0\x0\x0\x0\x8\x0\x8\x0\x0\x8"\
  "\x19\x0\xaf\x61\x13\x48\x10\xdb\xc0\x83\x4\xb\x16\x44\x88\x50\xe1\x41\x86\x9\x21\x1a\x74\x78\x2d\x20\x0\x3b\xff"
#define HTS_DATA_FADE_GIF_LEN 828

#endif
