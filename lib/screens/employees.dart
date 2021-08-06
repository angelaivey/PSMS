import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ola_energy/models/EmptyState.dart';

class Employees extends StatefulWidget {
  const Employees({Key key}) : super(key: key);

  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  var myist = [
    "Adungosi   #OE50413",
    "Agenga  #OE40406",
    "Ahero   #OE40101",
    "Ainabkoi   #OE30101",
    "Akala  #OE40139",
    "Aluor   #OE40140",
    "Amagoro   #OE50244",
    "Amukura   #OE50403",
    "Andigo   #OE40136",
    "Angurai   #OE50412",
    "Anyiko  #OE40616",
    "Archer`s Post   #OE60302",
    "Arror   #OE30708",
    "Asembo Bay    #OE40619",
    "Asumbi  #OE40309",
    "Athi River  #OE00204",
    "Awach Tende    #OE40328",
    "Bahati   #OE20113",
    "Bamburi   #OE80101",
    "Banja  #OE50316",
    "Bar Ober   #OE50411",
    "Baragoi  #OE20601",
    "Baraton  #OE30306",
    "Baricho   #OE10302",
    "Bartolimo   #OE30412",
    "Barwesa  #OE30412",
    "Bissil   #OE01101",
    "Bokoli   #OE50206",
    "Bomet   #OE20400",
    "Bondeni   #OE20101",
    "Bondo   #OE40601",
    "Booker   #OE50137",
    "Boro    #OE40620",
    "Budalangi   #OE50415",
    "Bugar    #OE30702",
    "Buhuyi    #OE50416",
    "Bukembe  #OE50233",
    "Bukiri    #OE50417",
    "Bukura   #OE50105",
    "Bulimbo   #OE50109",
    "Bumala   #OE50404",
    "Bumutiru   #OE50418",
    "Bungoma   #OE50200",
    "Bunyore   #OE50301",
    "Bura Tana  #OE70104",
    "Burnt Forest   #OE30102",
    "Buru Buru   #OE00515",
    "Busia   #OE50400",
    "Butere  #OE50101",
    "Butula   #OE50405",
    "Buyofu  #OE50210",
    "Chamakanga  #OE50302",
    "Changamwe   #OE80102",
    "Chavakali   #OE50317",
    "Chebiemit   #OE30706",
    "Cheborge   #OE20215",
    "Chebororwa  #OE30125",
    "Chebunyo   #OE20401",
    "Chemamul   #OE20222",
    "Chemaner   #OE20407",
    "Chemase    #OE40143",
    "Chemelil  #OE40116",
    "Chemiron    #OE30206",
    "Chepareria   #OE30605",
    "Chepkorio    #OE30129",
    "Chepsonoi    #OE30309",
    "Cheptais   #OE50201",
    "Cheptalal    #OE20410",
    "Chepterwai   #OE30121",
    "Cheptongei   #OE30709",
    "Chepsinendet   #OE20217",
    "Chesoi   #OE30712",
    "Chiakanyinga   #OE60410",
    "Chaikariga   #OE60409",
    "Chogoria  #OE60401",
    "Chuka    #OE60400",
    "Chuvuli   #OE90219",
    "Chumvi   #OE90147",
    "Chumvini   #OE80314",
    "Chwele    #OE50202",
    "City Square    #OE00200",
    "Coast Gen Hsp  #OE80103",
    "Dadaab    #OE70103",
    "Dago    #OE40112",
    "Dandora   #OE00516",
    "Daraja Mbili    #OE40117",
    "Daystar University   #OE90145",
    "Dede    #OE40331",
    "Diani Beach    #OE80401",
    "Docks    #OE80104",
    "Dol Dol    #OE10401",
    "Dorofu   #OE50213",
    "Dudi   #OE40621",
    "Dundori    #OE20118",
    "Eastleigh   #OE00610",
    "Egerton University   #OE20115",
    "Ekalakala   #OE90139",
    "El Wak    #OE70301",
    "Elburgon    #OE20102",
    "Eldama Ravine   #OE20103",
    "Eldoret Airport   #OE30124",
    "Eldoret GPO  #OE30100",
    "Elementatita  #OE20119",
    "Elugulu    #OE50429",
    "Emali    #OE90121",
    "Embakasi    #OE00501",
    "Embu    #OE60100",
    "Emining    #OE20140",
    "Emuhaya   #OE50314",
    "Endarasha    #OE10107",
    "Endau    #OE90206",
    "Endebess    #OE30201",
    "Enosaen    #OE40703",
    "Enterprise Road   #OE00500",
    "Eregi   #OE50303",
    "Etago    #OE40208",
    "Ewaso Kedong    #OE00242",
    "Faza   #OE80501",
    "Fort Ternan   #OE20209",
    "Funyula    #OE50406",
    "Gacharage-ini    #OE10210",
    "Gachoka    #OE60119",
    "Gaitu   #OE60209",
    "Gakere Road   #OE10109",
    "Gakindu    #OE10111",
    "Gambogi    #OE50318",
    "Ganze    #OE80205",
    "Garba Tulla    #OE60301",
    "Garissa    #OE70100",
    "Garsen    #OE80201",
    "Gatara   #OE10212",
    "Gathiruini    #OE00239",
    "Gathugu    #OE00240",
    "Gatimbi    #OE60217",
    "Gatitu    #OE10114",
    "Gatondo    #OE10115",
    "Gatugura    #OE10305",
    "Gatukuyu    #OE01028",
    "Gatundu   #OE01030",
    "Gatunga   #OE60404",
    "Gatura   #OE01013",
    "Gede    #OE80208",
    "Gembe    #OE40312",
    "Gesima    #OE40503",
    "Gesusu    #OE40201",
    "Giakanja   #OE10108",
    "Gigiri    #OE00601",
    "Gikoe    #OE10213",
    "Gilgil    #OE20116",
    "Giribe    #OE40407",
    "Gisambai    #OE50304",
    "Githiga    #OE00903",
    "Githogo    #OE60205",
    "Githumu   #OE01032",
    "Githunguri   #OE00216",
    "Gitimene    #OE60212",
    "Gituamba    #OE01003",
    "Gitugi    #OE10209",
    "Gongini    #OE80206",
    "Gorgor   #OE20411",
    "Griftu    #OE70202",
    "Habaswein    #OE70201",
    "Hakati    #OE50407",
    "Hamisi    #OE50312",
    "Hawinga   #OE40640",
    "Highridge    #OE00612",
    "Hola   #OE70101",
    "Homa Bay    #OE40300",
    "Huruma    #OE30109",
    "Ichichi    #OE10227",
    "Igare   #OE40209",
    "Igoji    #OE60402",
    "Igwamiti    #OE20307",
    "Iiani    #OE90120",
    "Ikalaasa    #OE90135",
    "Ikerege    #OE40415",
    "Ikinu   #OE00904",
    "Ikonge   #OE40501",
    "Ikutha    #OE90207",
    "Ikuu    #OE60405",
    "Ilasit    #OE00214",
    "Ileho    #OE50111",
    "Imanga   #OE50112",
    "Ishiara    #OE60102",
    "Isibania   #OE40414",
    "Isinya   #OE01102",
    "Isiolo    #OE60300",
    "Isulu    #OE50114",
    "Iten    #OE30700",
    "Ithanga    #OE01015",
    "Itibo    #OE40504",
    "Itumbe    #OE40210",
    "Jebrok    #OE50319",
    "Juja Road    #OE00622",
    "Kaanwa    #OE60411",
    "Kabarak University   #OE20157",
    "Kabarnet   #OE30400",
    "Kabartonjo   #OE30401",
    "Kabati    #OE90205",
    "Kabazi   #OE20114",
    "Kabianga   #OE20201",
    "Kabiemit    #OE30130",
    "Kabiyet   #OE30303",
    "Kabujoi   #OE30305",
    "Kabula    #OE50214",
    "Kacheliba   #OE30601",
    "Kadel   #OE40314",
    "Kadongo    #OE40223",
    "Kaewa    #OE90150",
    "Kagio   #OE10306",
    "Kagumo    #OE10307",
    "Kagunduini    #OE01033",
    "Kagwe    #OE00223",
    "Kaheho   #OE20304",
    "Kahuhia    #OE10206",
    "Kahuro   #OE10201",
    "Kahuti    #OE10214",
    "Kaimosi    #OE50305",
    "Kainuk    #OE30604",
    "Kairo   #OE10215",
    "Kajiado   #OE01100",
    "Kakamega    #OE50100",
    "Kakemer   #OE50419",
    "Kakibora   #OE30216",
    "Kakoneni    #OE80209",
    "Kakuma   #OE30501",
    "Kakunga    #OE50115",
    "Kakuzi    #OE01014",
    "Kalamba    #OE90122",
    "Kalawa    #OE90126",
    "Kalimoni   #OE01001",
    "Kalokol    #OE30502",
    "Kaloleni    #OE80105",
    "Kamaget    #OE20218",
    "Kamahuha    #OE10217",
    "Kamara   #OE20134",
    "Kambiri   #OE50116",
    "Kambiti   #OE10226",
    "Kamiti    #OE00607",
    "Kampi Ya Samaki  #OE30406",
    "Kamuriai    #OE50408",
    "Kamuwongo    #OE90403",
    "Kamwaura    #OE20132",
    "Kamwosor    #OE30113",
    "Kandara   #OE01034",
    "Kandiege    #OE40304",
    "Kangari    #OE10218",
    "Kangema    #OE10202",
    "Kangemi    #OE00625",
    "Kangundo   #OE90115",
    "Kanja   #OE60118",
    "Kanjuku    #OE01004",
    "Kanyakine    #OE60206",
    "Kanyenyaini    #OE10220",
    "Kanyuambora   #OE60106",
    "Kapcheno   #OE30304",
    "Kapcherop    #OE30204",
    "Kapchorwa    #OE30311",
    "Kapedo    #OE30410",
    "Kapenguria    #OE30600",
    "Kapkatet    #OE20214",
    "Kapkelet    #OE20219",
    "Kapkenda    #OE30119",
    "Kapkugerwet   #OE20206",
    "Kapngetuny    #OE30111",
    "Kapsabet   #OE30300",
    "Kapsara    #OE30208",
    "Kapsoit   #OE20211",
    "Kapsokwony    #OE50203",
    "Kapsowar   #OE30705",
    "Kapsumbeiwa   #OE30313",
    "Kapsuser   #OE20207",
    "Kaptagat    #OE30114",
    "Kaptalamwa    #OE30710",
    "Kaptama    #OE50234",
    "Kaptarakwa   #OE30701",
    "Kaptebengwet   #OE20221",
    "Kaptel    #OE30312",
    "Kapteren    #OE30711",
    "Karaba    #OE60105",
    "Karandi   #OE20328",
    "Karatina    #OE10101",
    "Karatu    #OE00233",
    "Karen    #OE00502",
    "Karingari    #OE60107",
    "Kariobangi    #OE00615",
    "Kariua    #OE10231",
    "Karota    #OE40505",
    "Karungu     #OE40401",
    "Karuri    #OE00219",
    "Karurumo    #OE60117",
    "Kasarani   #OE00608",
    "Kasigau    #OE80307",
    "Kasikeu    #OE90123",
    "Katangi    #OE90106",
    "Kathiani    #OE90105",
    "Kathonzweni    #OE90302",
    "Kathwana    #OE60406",
    "Katito    #OE40118",
    "Katse    #OE90404",
    "Katutu    #OE90217",
    "Kaviani   #OE90107",
    "Kavuti    #OE90405",
    "Kayole    #OE00518",
    "Kebirigo   #OE40506",
    "Kedowa    #OE20220",
    "Keekorok    #OE20501",
    "Kegogi   #OE40515",
    "Kegonga   #OE40416",
    "Kehancha    #OE40413",
    "Kendu Bay   #OE40301",
    "Kenol (Makuyu)    #OE01020",
    "Kenyatta National Hospital   #OE00202",
    "Kenyatta University   #OE00609",
    "Kenyenya    #OE40211",
    "Kericho   #OE20200",
    "Keroka    #OE40202",
    "Kerugoya    #OE10300",
    "Kerwa    #OE00906",
    "Kesogon   #OE30215",
    "Kesses    #OE30132",
    "Keumbu    #OE40212",
    "Kevote    #OE60108",
    "Khayega    #OE50104",
    "Khumusalaba   #OE50306",
    "Khwisero   #OE50135",
    "Kiamariga    #OE10122",
    "Kiambere    #OE60109",
    "Kiambu    #OE00900",
    "Kiamokama    #OE40213",
    "Kiamutugu   #OE10309",
    "Kiamwangi   #OE00236",
    "Kiandu    #OE10123",
    "Kianjai    #OE60602",
    "Kianjokoma    #OE60122",
    "Kianyaga   #OE10301",
    "Kibigori    #OE40119",
    "Kibingoti   #OE10311",
    "Kibirichia   #OE60201",
    "Kibugu    #OE60112",
    "Kibwezi    #OE90137",
    "Kiganjo    #OE10102",
    "Kigumo    #OE10203",
    "Kihoya    #OE10207",
    "Kihuga Square    #OE30110",
    "Kiirua     #OE60207",
    "Kijabe     #OE00220",
    "Kikima    #OE90125",
    "Kikuyu    #OE00902",
    "Kilala     #OE90305",
    "Kilgoris    #OE40700",
    "Kilibwoni   #OE30315",
    "Kilifi    #OE8010",
    "Kilindini    #OE80107",
    "Kilingili    #OE50315",
    "Kimahuri   #OE10125",
    "Kimana    #OE00215",
    "Kimathi way    #OE10140",
    "Kimbimbi   #OE10310",
    "Kimilili     #OE50204",
    "Kiminini    #OE30209",
    "Kimoning   #OE30120",
    "Kimulot    #OE20225",
    "Kimunye    #OE10312",
    "Kimwarer    #OE30128",
    "Kinamba    #OE20320",
    "Kinango    #OE80405",
    "Kinari   #OE00227",
    "Kindaruma    #OE01031",
    "Kinoru     #OE60216",
    "Kionyo     #OE60211",
    "Kipevu     #OE80116",
    "Kipkabus    #OE30103",
    "Kipkarren River    #OE50241",
    "Kipkelion    #OE20202",
    "Kiplegetet    #OE30117",
    "Kipsaina     #OE30203",
    "Kipsaraman   ,   #OE30411",
    "Kiptabach    #OE30118",
    "Kiptagich    #OE30402",
    "Kiptangwanyi   #OE20133",
    "Kiptere   #OE20213",
    "Kiptugumo    #OE20208",
    "Kirengeti     #OE20131",
    "Kiriani    #OE10204",
    "Kiritiri   #OE60113",
    "Kiritu    #OE50313",
    "Kiriua    #OE01017",
    "Kiruara    #OE01018",
    "Kisanana     #OE20144",
    "Kisasi    #OE90204",
    "Kiserian    #OE00206",
    "Kisii    #OE40200",
    "Kisumu    #OE40100",
    "Kitale    #OE30200",
    "Kitengela   #OE00241",
    "Kithimani   #OE90124",
    "Kithimu    #OE60114",
    "Kithyoko   #OE90144",
    "Kitise    #OE90303",
    "Kitivo    #OE80316",
    "Kitui    #OE90200",
    "Kiunduani     #OE90148",
    "Kiusyani    #OE90218",
    "Kivaani   #OE90116",
    "Kivunga    #OE90111",
    "Kocholya    #OE50420",
    "Koilot   #OE30314",
    "Kojwang    #OE40317",
    "Kola    #OE90108",
    "Kombewa     #OE40102",
    "Kondele    #OE40103",
    "Kondik     #OE40121",
    "Koracha    #OE40639",
    "Koru    #OE40104",
    "Kosele    #OE40332",
    "Koyonzo    #OE50117",
    "Kuresoi    #OE20154",
    "Kutus    #OE10304",
    "Kwale    #OE80403",
    "Kwanza   #OE30210",
    "Kwavonza   #OE90215",
    "Kyatune    #OE90220",
    "Kyeni    #OE90209",
    "Kyuso    #OE90401",
    "Laare   #OE60601",
    "Ladhri Awasi    #OE40122",
    "Laikipia Campus  #OE20330",
    "Laisamis    #OE60502",
    "Lamu    #OE80500",
    "Lanet    #OE20112",
    "Langas    #OE30112",
    "Langata    #OE00509",
    "Lavington    #OE00603",
    "Leshau   #OE20310",
    "Lessos    #OE30302",
    "Likoni    #OE80110",
    "Limuru    #OE00217",
    "Lita      #OE90109",
    "Litein     #OE20210",
    "Lodwar    #OE30500",
    "Loitoktok    #OE00209",
    "Loiyangalani   #OE60501",
    "Lokichoggio   #OE30503",
    "Lokitaung   #OE30504",
    "Lokori    #OE30506",
    "Lolgorian    #OE40701",
    "Londian   #OE20203",
    "Longisa   #OE20402",
    "Lower Kabete  #OE00604",
    "Luanda   #OE50307",
    "Luandanyi    #OE50219",
    "Luandeti    #OE50240",
    "Lubao     #OE50118",
    "Lugari     #OE50108",
    "Lugingo    #OE40622",
    "Luhano    #OE40623",
    "Lukolis   #OE50421",
    "Lukore   #OE80408",
    "Lukume    #OE50132",
    "Lumakanda   #OE50242",
    "Lunga Lunga    #OE80402",
    "Lunza    #OE50119",
    "Lusingeti    #OE00905",
    "Lusiola    #OE50320",
    "Lutaso    #OE50121",
    "Lwakhakha    #OE50220",
    "Maai Mahiu    #OE20147",
    "Mabusi    #OE50235",
    "Machakos   #OE90100",
    "Madaraka   #OE01002",
    "Madiany    #OE40613",
    "Madina    #OE80207",
    "Magada   #OE50321",
    "Magadi    #OE00205",
    "Magena   #OE40516",
    "Mago    #OE50325",
    "Magombo    #OE40507",
    "Magumoni    #OE60403",
    "Magunga   #OE40307",
    "Magutuni   #OE60407",
    "Magwagwa   #OE40508",
    "Mahanga   #OE50322",
    "Mairo Inya    #OE20314",
    "Maji Mazuri    #OE20145",
    "Makimeny    #OE20418",
    "Makindu    #OE90138",
    "Makongeni    #OE00510",
    "Maktau    #OE80315",
    "Makueni   #OE90300",
    "Makumbi    #OE20149",
    "Makunga    #OE50133",
    "Makupa    #OE80112",
    "Makutano    #OE20141",
    "Makuyu    #OE01020",
    "Malaha    #OE50122",
    "Malakisi    #OE50209",
    "Malava    #OE50103",
    "Malindi    #OE80200",
    "Malinya    #OE50123",
    "Mandera   #OE70300",
    "Manga   #OE40509",
    "Manyani    #OE80301",
    "Manyatta   #OE60101",
    "Manyuanda   #OE40625",
    "Manyulia    #OE50126",
    "Maragoli    #OE50300",
    "Maragua    #OE10205",
    "Maralal   #OE20600",
    "Marani   #OE40214",
    "Mariakani      #OE80113",
    "Marigat      #OE30403",
    "Marima      #OE60408",
    "Marimanti      #OE60215",
    "Mariwa      #OE40408",
    "Marmanet      #OE20322",
    "Marsabit     #OE60500",
    "Masana      #OE50324",
    "Maseno      #OE40105",
    "Mashini      #OE80312",
    "Mashuru    #OE01103",
    "Masii      #OE90101",
    "Masimba     #OE40215",
    "Masinde Muliro University   #OE50139",
    "Masinga      #OE90141",
    "Matayos      #OE50422",
    "Matete     #OE50136",
    "Mathare Valley    #OE00611",
    "Mathuki    #OE90406",
    "Matiliku      #OE90140",
    "Matinyani      #OE90210",
    "Matuga      #OE80406",
    "Matunda      #OE30205",
    "Matuu      #OE90119",
    "Mau Narok     #OE20111",
    "Mau Summit    #OE20122",
    "Maua      #OE60600",
    "Maungu     #OE80317",
    "Mavindini    #OE90304",
    "Mawego     #OE40310",
    "Mazeras     #OE80114",
    "Mbagathi      #OE00503",
    "Mbakalo     #OE50236",
    "Mbari Ya Njiku    #OE00231",
    "Mbiri      #OE10233",
    "Mbita      #OE40305",
    "Mbitini      #OE90214",
    "Mbiuni      #OE90110",
    "Mbumbuni     #OE00127",
    "Mchumbi Road    #OE00504",
    "Menengai      #OE20104",
    "Merigi      #OE20419",
    "Merti     #OE60303",
    "Meru     #OE60200",
    "Mfangano     #OE40319",
    "Mgambonyi      #OE80313",
    "Mgange     #OE80306",
    "Miathene      #OE60604",
    "Migioini      #OE01029",
    "Migwani     #OE90402",
    "Miharati     #OE20301",
    "Mikayi      #OE40225",
    "Mikinduri      #OE60607",
    "Milimani      #OE50138",
    "Milton Siding      #OE20123",
    "Mirangine      #OE20124",
    "Mirogi     #OE40320",
    "Misikhu      #OE50207",
    "Misori     #OE40626",
    "Mitaboni     #OE90104",
    "Mitunguu      #OE60204",
    "Miu      #OE90112",
    "Miwani      #OE40106",
    "Mkomani      #OE80106",
    "Mobi Plaza     #OE00620",
    "Mochongoi     #OE20312",
    "Mogogosiek      #OE20403",
    "Mogotio      #OE20105",
    "Moi Airport      #OE80115",
    "Moi University      #OE30107",
    "Moi-ben      #OE30104",
    "moi`s Bridge     #OE30202",
    "Mokomoni      #OE40510",
    "Mokowe      #OE80502",
    "Molo     #OE20106",
    "Mombasa      #OE80100",
    "Mosoriot     #OE30307",
    "Moyale      #OE60700",
    "Mpeketoni      #OE80503",
    "Msambweni      #OE80404",
    "Mtito Andei      #OE90128",
    "Mtongwe   #OE80111",
    "Mtopanga    #OE80117",
    "Mtwapa     #OE80109",
    "Mubwayo   #OE50423",
    "Muddo Gashe   #OE70102",
    "Mudhiero   #OE40627",
    "Muguga     #OE00228",
    "Mugunda   #OE10129",
    "Muhoroni   #OE40107",
    "Muhotetu   #OE20323",
    "Muhuru Bay    #OE40409",
    "Mukerenju    #OE01023",
    "Mukeu      #OE20315",
    "Mukuro     #OE40410",
    "Mukurweini    #OE10103",
    "Mulango      #OE90216",
    "Muluanda   #OE50428",
    "Mumias     #OE50102",
    "Mundoro   #OE00235",
    "Mungatsi   #OE50425",
    "Muranga   #OE10200",
    "Muruka     #OE01024",
    "Murumba   #OE50426",
    "Murungaru    #OE20316",
    "Mururi     #OE60120",
    "Musanda   #OE50125",
    "Mutha     #OE90211",
    "Muthaiga   #OE00619",
    "Muthetheni   #OE90113",
    "Mutituni    #OE90117",
    "Mutomo    #OE90201",
    "Mutumbu   #OE40628",
    "Muumandu    #OE90114",
    "Mwala      #OE90102",
    "Mwatate     #OE80305",
    "Mweiga     #OE10104",
    "Mwingi     #OE90400",
    "Nairage Enkare   #OE20504",
    "Nairobi GPO   #OE00100",
    "Naishi      #OE20142",
    "Naitiri      #OE50211",
    "Naivasha     #OE20117",
    "Nakuru    #OE20100",
    "Namanga    #OE00207",
    "Nambacha    #OE50127",
    "Nambale   #OE50409",
    "Nandi Hills    #OE30301",
    "Nangili   #OE50239",
    "Nango    #OE40615",
    "Nanyuki    #OE10400",
    "Naro moru    #OE10105",
    "Narok    #OE20500",
    "Ndalani   #OE90118",
    "Ndalat    #OE30123",
    "Ndalu    #OE50212",
    "Ndanai   #OE20404",
    "Ndaragwa    #OE20306",
    "Ndenderu   #OE00230",
    "Ndere    #OE40629",
    "Nderu   #OE00229",
    "Ndhiwa    #OE40302",
    "Ndigwa    #OE40630",
    "Ndithini    #OE01016",
    "Ndooa    #OE90202",
    "Ndori    #OE40602",
    "Ndunyu Njeru   #OE20317",
    "Ngambwa    #OE80311",
    "Nganduri   #OE60115",
    "Ngara Road    #OE00600",
    "Ngecha    #OE00218",
    "Ngewa   #OE00901",
    "Nginyang    #OE30404",
    "Ngiya    #OE40603",
    "Ngong Hills    #OE00208",
    "Ngong Road   #OE00505",
    "Ngorika   #OE20126",
    "Nguni   #OE90407",
    "Nguyoini    #OE10224",
    "Ngwata    #OE90129",
    "Njipiship    #OE40702",
    "Njoro    #OE20107",
    "Nkondi    #OE60214",
    "Nkubu   #OE60202",
    "North Kinangop   #OE20318",
    "Nthongoini   #OE90149",
    "Ntimaru    #OE40417",
    "Nunguni    #OE90130",
    "Nuu    #OE90408",
    "Nyabondo    #OE40124",
    "Nyandorera    #OE40631",
    "Nyahururu    #OE20300",
    "Nyali   #OE80118",
    "Nyamache    #OE40203",
    "Nyamarambe    #OE40206",
    "Nyambunwa   #OE40205",
    "Nyamira    #OE40500",
    "Nyamonye    #OE40632",
    "Nyadhiwa    #OE40333",
    "Nyangande    #OE40126",
    "Nyangori    #OE40127",
    "Nyangusu    #OE40218",
    "Nyangweso    #OE40311",
    "Nyansiongo    #OE40502",
    "Nyaramba    #OE40514",
    "Nyaru    #OE30131",
    "Nyatike   #OE40402",
    "Nyawara    #OE40633",
    "Nyayo Stadium    #OE00506",
    "Nyeri   #OE10100",
    "Nyilima   #OE40611",
    "Nzeeka   #OE90136",
    "Nziu    #OE90143",
    "Nzoia    #OE50237",
    "Obekai    #OE50427",
    "Oboch    #OE40129",
    "Ogembo   #OE40204",
    "Ogen     #OE40130",
    "Ogongo    #OE40323",
    "Okia     #OE90301",
    "Ol Joro Orok    #OE20302",
    "Ol Kalou    #OE20303",
    "Olbutyo    #OE20421",
    "Olenguruone    #OE20152",
    "Olkurto     #OE20502",
    "Olololunga   #OE20503",
    "Oloomirani   #OE20424",
    "Oltepesi     #OE00213",
    "Omboga     #OE40306",
    "Omogonchoro    #OE40221",
    "Ongata Rongai    #OE00511",
    "Oriang      #OE40227",
    "Ortum     #OE30602",
    "Otaro    #OE40324",
    "Othaya     #OE10106",
    "Othoch Rakuom    #OE40411",
    "Othoro     #OE40224",
    "Otonglo    #OE40108",
    "Oyani-masii   #OE40334",
    "Oyugis     #OE40222",
    "Pala     #OE40329",
    "Pap Onditi    #OE40111",
    "Parklands    #OE00623",
    "Passenga    #OE20311",
    "Paw Akuche   #OE40131",
    "Pembe Tatu   #OE40113",
    "Plateau    #OE30116",
    "Port Victoria     #OE50410",
    "Quarry Road #OE00624",
    "Rabuor     #OE40132",
    "Racecourse Road    #OE00617",
    "Ragengni    #OE40604",
    "Rakwaro    #OE40325",
    "Ramba     #OE40330",
    "Ramula     #OE40142",
    "Ranen     #OE40412",
    "Rangala    #OE40634",
    "Rangwe    #OE40303",
    "Rapogi     #OE40403",
    "Ratta     #OE40137",
    "Reru    #OE40133",
    "Rhamu    #OE70302",
    "Rigoma    #OE40511",
    "Ringa    #OE40226",
    "Riochanda     #OE40512",
    "Riosiri     #OE40220",
    "Riruta     #OE00512",
    "Rodi Kopany   #OE40326",
    "Ronald Ngala Street     #OE00300",
    "Ronda     #OE20127",
    "Rongai    #OE20108",
    "Rongo    #OE40404",
    "Roret     #OE20204",
    "Ruaraka   #OE00618",
    "Ruiru     #OE00232",
    "Rumuruti     #OE20321",
    "Runyenjes    #OE60103",
    "Ruri    #OE20313",
    "Ruringu    #OE10133",
    "Rusinga   #OE40327",
    "Ruthangati      #OE10134",
    "Sabatia    #OE20143",
    "Saboti    #OE30211",
    "Sagalla    #OE80308",
    "Sagana    #OE10230",
    "Samburu    #OE80120",
    "Samitsi     #OE50128",
    "Sare     #OE40405",
    "Sarit Centre #OE00606",
    "Sasumua Road    #OE00513",
    "Sawagongo    #OE40612",
    "Sega    #OE40614",
    "Serem     #OE50308",
    "Seretunin   #OE30407",
    "Shabaab    #OE20150",
    "Shianda    #OE50106",
    "Shiatsala    #OE50129",
    "Shibuli    #OE50130",
    "Shimanyiro     #OE50131",
    "Shimba Hills #OE80407",
    "Shinyalu    #OE50107",
    "Siakago    #OE60104",
    "Siaya    #OE40600",
    "Sidindi     #OE40605",
    "Sifuyo    #OE40643",
    "Sigomre    #OE40635",
    "Sigor     #OE20405",
    "Sigoti     #OE40135",
    "Sigowet     #OE20212",
    "Sikinwa     #OE30217",
    "Silibwet     #OE20422",
    "Simat     #OE30127",
    "Sindo     #OE40308",
    "Singore     #OE30703",
    "Sio Port     #OE50401",
    "Sipili    #OE20326",
    "Sirembe     #OE40636",
    "Sirende     #OE30213",
    "Sirisia     #OE50208",
    "Sirongo    #OE40642",
    "Solai     #OE20128",
    "Sololo     #OE60701",
    "Sondu    #OE40109",
    "Songhor    #OE40110",
    "Sorget     #OE20223",
    "Sosiot    #OE20205",
    "Sotik     #OE20406",
    "South Horr    #OE20604",
    "South Kinangop   #OE20155",
    "South Kinangop   #OE20319",
    "Soy     #OE30105",
    "Suba Kuria    #OE40418",
    "Subukia    #OE20109",
    "Suguta Mar Mar    #OE20602",
    "Sulmac     #OE20151",
    "Sultan Hamud    #OE90132",
    "Suna    #OE40400",
    "Suwerwa     #OE30212",
    "Tabani     #OE30220",
    "Tabani     #OE50238",
    "Tala     #OE90131",
    "Tambach     #OE30704",
    "Tarasaa    #OE80203",
    "Tausa    #OE80309",
    "Taveta     #OE80302",
    "Tawa     #OE90133",
    "Tenges     #OE30405",
    "Thaara    #OE10110",
    "Thangathi     #OE10135",
    "Thare     #OE01026",
    "Thigio     #OE00210",
    "Thika    #OE01000",
    "Tigiji     #OE60210",
    "Timau     #OE10406",
    "Timber Mill Road    #OE20110",
    "Timboroa    #OE30108",
    "Tiriki    #OE50309",
    "Tom Mboya    #OE00400",
    "Tombe    #OE40513",
    "Tongaren     #OE30218",
    "Torongo     #OE20153",
    "Tot     #OE30707",
    "Tseikuru     #OE90409",
    "Tulia     #OE90203",
    "Tumu Tumu    #OE10136",
    "Tunyai     #OE60213",
    "Turbo     #OE30106",
    "Turi    #OE20129",
    "Uaso Nyiro     #OE10137",
    "Ugunja     #OE40606",
    "Uhuru Gardens     #OE00517",
    "Ukunda    #OE80400",
    "Ukwala    #OE40607",
    "Uplands     #OE00222",
    "Uranga     #OE40608",
    "Uriri     #OE40228",
    "Usenge     #OE40609",
    "Usigu    #OE40637",
    "Uthiru     #OE00605",
    "Valley Arcade   #OE00514",
    "Vihiga    #OE50310",
    "Village Market #OE00621",
    "Vipingo     #OE80119",
    "Vitengeni     #OE80211",
    "Viwandani    #OE00507",
    "Voi     #OE80300",
    "Voo     #OE90212",
    "Wagusu    #OE40638",
    "Waithaka    #OE00613",
    "Wajir    #OE70200",
    "Wamagana #OE10138",
    "Wamba    #OE20603",
    "Wamunyu #OE90103",
    "Wamwangi    #OE01010",
    "Wangige     #OE00614",
    "Wanguru #OE10303",
    "Wanjengi    #OE10225",
    "Wanjohi     #OE20305",
    "Watalii Road    #OE80204",
    "Watamu #OE80202",
    "Webuye #OE50205",
    "Weiwei     #OE30603",
    "Werugha    #OE80303",
    "Westlands   #OE00800",
    "Winam #OE40141",
    "Witu    #OE80504",
    "Wiyumiririe   #OE20329",
    "Wodanga   #OE50311",
    "Wundanyi    #OE80304",
    "Yala    #OE40610",
    "Yaya Towers    #OE00508",
    "Yoani   #OE90134",
    "Ziwa    #OE30214",
    "Zombe     #OE90213"
  ];
  locationWidget(text) {
    return Container(
      child: Center(child: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Station Locations'),
      ),
      body: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: myist.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewEmployees(location: myist[index])));
                },
                child: LocationWidget(location: myist[index]));
          },
        ),
      ),
    );
  }
}

class LocationWidget extends StatefulWidget {
  final String location;
  const LocationWidget({Key key, this.location}) : super(key: key);

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  var numberOfEmployees = 0;
  var numberOfReports = 0;
  var managerId = "not selected";
  @override
  @override
  void initState() {
    super.initState();
    fetchEmployeeNumber();
    fetchReportNumber();
    fetchManagerId();
  }

  fetchEmployeeNumber() {
    var document = FirebaseFirestore.instance
        .collection('users')
        // .where('date', isGreaterThanOrEqualTo: widget.start)
        // .where('date', isLessThanOrEqualTo: widget.end)
        .where('stationId', isEqualTo: widget.location);
    document.get().then((value) {
      if (value.docs.length > 0) {
        print(widget.location);
        setState(() {
          numberOfEmployees = value.docs.length;
        });
      }
    });
  }

  fetchManagerId() {
    var document = FirebaseFirestore.instance
        .collection('users')
        // .where('date', isGreaterThanOrEqualTo: widget.start)
        // .where('date', isLessThanOrEqualTo: widget.end)
        .where('stationId', isEqualTo: widget.location)
        .where('accountType', isEqualTo: 'Manager #OEEM01A');
    document.get().then((value) {
      if (value.docs.length > 0) {
        print(widget.location);
        setState(() {
          managerId = value.docs[0].data()["employeeId"];
        });
      }
    });
  }

  fetchReportNumber() {
    var document = FirebaseFirestore.instance
        .collection('fuels')
        // .where('date', isGreaterThanOrEqualTo: widget.start)
        // .where('date', isLessThanOrEqualTo: widget.end)
        .where('stationId', isEqualTo: widget.location);
    document.get().then((value) {
      if (value.docs.length > 0) {
        print(widget.location);
        setState(() {
          numberOfReports = value.docs.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.02),
      child: Material(
        elevation: 1.0,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  color: Color(0xff322C40),
                  child: Center(
                      child: Text(
                    widget.location,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ))),
              Container(
                height: MediaQuery.of(context).size.height * 0.12,
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('No. of Employees:'),
                        Text(numberOfEmployees.toString())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('No. of Reports:'),
                        Text(numberOfReports.toString())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('No. of Reports:'), Text(managerId)],
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Container circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10.0),
    child: SpinKitRotatingCircle(
      color: Color(0xff322C40),
      size: 40.0,
    ),
  );
}

class ViewEmployees extends StatefulWidget {
  final String location;

  const ViewEmployees({Key key, @required this.location}) : super(key: key);

  @override
  _ViewEmployeesState createState() => _ViewEmployeesState();
}

class _ViewEmployeesState extends State<ViewEmployees> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            //.where("date", isEqualTo: )
            // .where('date', isGreaterThanOrEqualTo: start)
            // .where('date', isLessThanOrEqualTo: end)
            // not limited to the user ID
            // .where('userId', isEqualTo: uid)
            .where("stationId", isEqualTo: widget.location)
            .orderBy("accountType", descending: true)
            .snapshots(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return Center(child: Text("Error!"));
          } else if (!asyncSnapshot.hasData) {
            return Center(
              child: Text('No Employyes registered yet'),
            );
          } else if (asyncSnapshot.hasData) {
            print("DATA CHUNK LENGTH ${asyncSnapshot.data.docs.length}");
            return asyncSnapshot.data.docs.length>0?ListView.builder(
              itemCount: asyncSnapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: EmployeeCard(
                    accType:
                        asyncSnapshot.data.docs[index].data()["accountType"],
                    employeeId:
                        asyncSnapshot.data.docs[index].data()["employeeId"],
                    docId: asyncSnapshot.data.docs[index].data()["uid"],
                  )),
            ):  Center(
              child: Text('No Employyes registered yet'),
            );
          } else if (asyncSnapshot.hasData &&
              asyncSnapshot.data.docs.length == 0) {
            return EmptyState();
          } else if (!asyncSnapshot.hasData) {
            return circularProgress();
          }
          return null;
        },
      ),
    );
  }
}

class EmployeeCard extends StatefulWidget {
  final String employeeId, accType, docId;

  const EmployeeCard(
      {Key key,
      @required this.employeeId,
      @required this.accType,
      @required this.docId})
      : super(key: key);

  @override
  _EmployeeCardState createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  var numberOfReports = 0;
  @override
  @override
  void initState() {
    super.initState();
    fetchReportNumber();
  }

  fetchReportNumber() {
    var document = FirebaseFirestore.instance
        .collection('fuels')
        // .where('date', isGreaterThanOrEqualTo: widget.start)
        // .where('date', isLessThanOrEqualTo: widget.end)
        .where('employeeId', isEqualTo: widget.employeeId);
    document.get().then((value) {
      if (value.docs.length > 0) {
        //print(widget.location);
        setState(() {
          numberOfReports = value.docs.length;
        });
      }
    });
  }

  makeManager() {
    Map<String, dynamic> promote = {
      // 'fuelId': widget.docsId,
      'accountType': 'Manager #OEEM01A'
    };
    Map<String, dynamic> demote = {
      // 'fuelId': widget.docsId,
      'accountType': 'Filling Station Attendant #OEEM02C'
    };
    var document = FirebaseFirestore.instance
        .collection('users')
        .where('accountType', isEqualTo: 'Manager #OEEM01A');
    document.get().then((value) {
      // find current manager
      var currentManager;
      currentManager = value.docs[0].data()["uid"];
      // demote the current manager
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentManager)
          .update(demote)
          .then((value) {
        // promote the new manager
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.docId)
            .update(promote)
            .then((value) {
          // show success
          Fluttertoast.showToast(
              msg: 'User Promoted',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xff322C40),
              textColor: Colors.white,
              fontSize: 16.0);
        });
      });
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.3,
          //style: ButtonStyle(),
          child: Center(
              child: Text(
            "Cancel",
            style: TextStyle(color: Colors.blue),
          )),
        ));
    Widget continueButton = GestureDetector(
        onTap: () {
          makeManager();
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.red,
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.3,
          //style: ButtonStyle(),
          child: Center(
              child: Text(
            "Proceed",
            style: TextStyle(color: Colors.white),
          )),
        ));
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Would you like to make " +
          widget.employeeId +
          " the manager? This would demote the current manager"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.02),
      child: Material(
        elevation: 1.0,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: widget.accType == 'Manager #OEEM01A'
              ? MediaQuery.of(context).size.height * 0.14
              : MediaQuery.of(context).size.height * 0.26,
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  color: widget.accType == 'Manager #OEEM01A'
                      ? Colors.black
                      : Color(0xff322C40),
                  child: Center(
                      child: Text(
                    widget.employeeId,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ))),
              Container(
                height: widget.accType == 'Manager #OEEM01A'
                    ? MediaQuery.of(context).size.height * 0.06
                    : MediaQuery.of(context).size.height * 0.08,
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('account Type'), Text(widget.accType)],
                    ),
                    widget.accType == 'Manager #OEEM01A'
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('No. of Reports:'),
                              Text(numberOfReports.toString())
                            ],
                          ),
                  ],
                )),
              ),
              widget.accType == 'Manager #OEEM01A'
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          showAlertDialog(context);
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.07,
                            decoration: BoxDecoration(
                                color: Color(0xff493548),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                                child: Text(
                              'Make Manager',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ))),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
