MPLR.AddIBISLines( "Düsseldorf", {
	[ "74" ] = true,
	[ "75" ] = true,
	[ "76" ] = true,
	[ "77" ] = true,
	[ "78" ] = true,
	[ "79" ] = true,
	[ "80" ] = true,
	[ "81" ] = true,
} )

MPLR.AddIBISAnnouncementScript( "Düsseldorf", {
	--The general routine for announcement. Strings are from MPLR.AddIBISCommonFiles. Table listing index numbers dictate the order of announcements. Any arbitrary extra announcements defined in IBISCommonFiles can be prefixed or appended.
	[ 1 ] = "gong",
	[ 2 ] = "station",
} )

MPLR.AddIBISAnnouncementScript( "Düsseldorf Vintage", {
	--The general routine for announcement. Strings are from MPLR.AddIBISCommonFiles. Table listing index numbers dictate the order of announcements. Any arbitrary extra announcements defined in IBISCommonFiles can be prefixed or appended.
	[ 1 ] = "gong_old",
	[ 2 ] = "station",
} )

MPLR.AddIBISCommonFiles( "Düsseldorf", {
	[ "gong" ] = { "lilly/uf/IBIS/announcements/rheinbahn/common/gong.mp3", 1.2 },
	[ "gong_old" ] = { "lilly/uf/IBIS/announcements/rheinbahn/common/gong_vintage.mp3", 1.2 },
	[ "terminus" ] = { "lilly/uf/IBIS/announcements/rheinbahn/common/terminus.mp3", 1 },
	[ "request_stop" ] = { "lilly/uf/IBIS/announcements/rheinbahn/common/request_stop.mp3", 1.5 },
} )

MPLR.AddIBISDestinations( "Düsseldorf", {
	[ 001 ] = "Moorenstra?e",
	[ 002 ] = "Am Steinberg",
	[ 003 ] = "Kopernikusstr",
	[ 004 ] = "Auf'm Hennekamp",
	[ 005 ] = "Redinghovenstr",
	[ 006 ] = "D-Volksgarten S",
	[ 007 ] = "Kruppstra?e",
	[ 008 ] = "Fichtenstra?e",
	[ 009 ] = "Kettwiger Stra?e U",
	[ 010 ] = "D-Flingern S",
	[ 011 ] = "Schumannstra?e",
	[ 012 ] = "D-Zoo S",
	[ 013 ] = "Tu?mannstra?e",
	[ 014 ] = "Stockkampstra?e",
	[ 015 ] = "Marienhospital",
	[ 017 ] = "Sternstr",
	[ 018 ] = "Paul-Klee-Weg",
	[ 019 ] = "Karolingerplatz",
	[ 020 ] = "Kittelbachstra?e",
	[ 031 ] = "König-Heinrich-Pl. U",
	[ 032 ] = "Duisburg Hbf S U",
	[ 034 ] = "Victoriapl/Kl.Str U",
	[ 036 ] = "H.-Heine-Allee U",
	[ 056 ] = "DU-Meiderich Bf U",
	[ 066 ] = "Kremerstra?e",
	[ 067 ] = "Karl-Jarres-Stra?e",
	[ 069 ] = "Grunewald",
	[ 071 ] = "Kulturstra?e",
	[ 072 ] = "Im Schlenk",
	[ 073 ] = "Waldfriedhof",
	[ 074 ] = "Muenchener Str",
	[ 075 ] = "MERKUR ARENA/Mes.N.",
	[ 076 ] = "Muehlenkamp",
	[ 077 ] = "St.-Anna-Krankenhaus",
	[ 080 ] = "Ostraße U",
	[ 090 ] = "Elbruchstr",
	[ 091 ] = "Opladener Str",
	[ 092 ] = "Provinzialplatz",
	[ 093 ] = "Kaiserslaut. Str.",
	[ 094 ] = "D-Oberbilk S U",
	[ 133 ] = "Barbarossaplatz",
	[ 134 ] = "Luegplatz",
	[ 135 ] = "Comenius-Gymnasium",
	[ 136 ] = "Heerdter Sandberg",
	[ 137 ] = "Prinzenallee",
	[ 138 ] = "Lohweg",
	[ 139 ] = "Löricker Str",
	[ 140 ] = "Lörick",
	[ 141 ] = "Haus Meer",
	[ 142 ] = "Bovert",
	[ 143 ] = "Kamperweg",
	[ 150 ] = "Am Mühlenacker",
	[ 151 ] = "Wittlaer",
	[ 152 ] = "Froschenteich",
	[ 168 ] = "Heerdter Krhs",
	[ 201 ] = "Kalkum.Schlossallee",
	[ 203 ] = "Klemensplatz",
	[ 204 ] = "Lohausen",
	[ 205 ] = "Theodor-Heuss-Brücke",
	[ 206 ] = "D-Unterrath S",
	[ 234 ] = "Steinstr U",
	[ 235 ] = "Düsseldorf Hbf",
	[ 237 ] = "Handelszentrum U",
	[ 240 ] = "Ronsdorfer Str",
	[ 254 ] = "Oberbilker Markt U",
	[ 255 ] = "Ellerstr U",
	[ 257 ] = "Schlesiche Str",
	[ 258 ] = "Jägerstr",
	[ 259 ] = "D-Eller Mitte S",
	[ 260 ] = "Alt Eller",
	[ 261 ] = "Vennhauser Allee",
	[ 262 ] = "Benrath Btf",
	[ 263 ] = "D-Benrath S",
	[ 264 ] = "Urdenbacher Allee",
	[ 266 ] = "Holthausen",
	[ 267 ] = "Ickerswarder Str",
	[ 268 ] = "Werstener Dorfstr",
	[ 272 ] = "Handweiser",
	[ 273 ] = "Belsenplatz",
	[ 274 ] = "Forsthaus",
	[ 280 ] = "Büderich/Landsknecht",
	[ 281 ] = "Mes.Ost/St.Kirchstr.",
	[ 282 ] = "Golzheimer Platz",
	[ 285 ] = "D-Derendorf S",
	[ 288 ] = "Heesenstr",
	[ 295 ] = "Südpark",
	[ 296 ] = "Universität Ost",
	[ 388 ] = "Kesselsberg",
	[ 484 ] = "Auf dem Damm U",
	[ 565 ] = "Tonhalle/Ehrenhof",
	[ 580 ] = "Duissern U",
	[ 581 ] = "Steinische Gasse U",
	[ 582 ] = "Platanenhof",
	[ 583 ] = "Musfeldstr",
	[ 700 ] = "Hoterheide",
	[ 992 ] = "Grunewald Betriebshof",
	[ 163 ] = "König-Heinrich-Pl",
	[ 164 ] = "Duisburg Hbf",
	[ 165 ] = "Duissern",
	[ 177 ] = "Steinsche Gasse",
	[ 185 ] = "Meiderich Bf",
	[ 363 ] = "Auf Dem Damm",
	[ 670 ] = "Heinrich-Heine-Allee",
	[ 881 ] = "Messe Ost",
} )

MPLR.AddIBISAnnouncementMetadata( "Düsseldorf", {
	-- format: {[station] = {[line] = {[route] = {[audiofile] = seconds}}}} | Sets the "station" element announcement routine for each station on a basis of line, route
	[ 704 ] = {
		[ "07" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/uf/IBIS/announcements/ffm/ubahn/stations/704.mp3" ] = 1.8
				},
				[ 2 ] = {
					[ "lilly/uf/IBIS/announcements/ffm/ubahn/stations/704_interchange_06.mp3" ] = 16
				},
				[ 3 ] = {
					[ "lilly/uf/IBIS/announcements/ffm/ubahn/common/exit_left.mp3" ] = 2
				}
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/uf/IBIS/announcements/ffm/ubahn/stations/704.mp3" ] = 1.8
				},
				[ 2 ] = {
					[ "lilly/uf/IBIS/announcements/ffm/ubahn/stations/704_interchange_06.mp3" ] = 16
				},
				[ 3 ] = {
					[ "lilly/uf/IBIS/announcements/ffm/ubahn/common/exit_left.mp3" ] = 2
				}
			}
		},
		[ "06" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/uf/IBIS/announcements/ffm/ubahn/stations/704.mp3" ] = 1.8
				},
				[ 2 ] = {
					[ "lilly/uf/IBIS/announcements/ffm/ubahn/stations/704_interchange_06.mp3" ] = 16
				},
				[ 3 ] = {
					[ "lilly/uf/IBIS/announcements/ffm/ubahn/common/exit_left.mp3" ] = 2
				}
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/uf/IBIS/announcements/ffm/ubahn/stations/704.mp3" ] = 1.8
				},
				[ 2 ] = {
					[ "lilly/uf/IBIS/announcements/ffm/ubahn/stations/704_interchange_06.mp3" ] = 16
				},
				[ 3 ] = {
					[ "lilly/uf/IBIS/announcements/ffm/ubahn/common/exit_left.mp3" ] = 2
				}
			}
		},
	},
} )