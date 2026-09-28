import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';

String countryCodeToEmoji(String countryCode) {
  // Convertit un code ISO à 2 lettres (ex: "FR") en drapeaux Unicode
  final int firstLetter = countryCode.toUpperCase().codeUnitAt(0) - 0x41 + 0x1F1E6;
  final int secondLetter = countryCode.toUpperCase().codeUnitAt(1) - 0x41 + 0x1F1E6;
  return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
}



class FilterScreen extends StatefulWidget{
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}
class CountryItem {
  final String name;
  final String code;

  CountryItem({
    required this.name,
    required this.code,
  });
}

class RegionItem {
  final String name;
  final bool isContinent;
  final List<CountryItem>? countries;
  bool isExpanded;

  RegionItem({
    required this.name,
    required this.isContinent,
    this.countries,
    this.isExpanded = false,
  });
}


class _FilterScreenState extends State<FilterScreen> {

  final Map<String, IconData> categories = {
    'Transport' : Icons.airport_shuttle_outlined,
    'Borders crossing' : Icons.assignment_ind_outlined,
    'Restaurant' : Icons.restaurant, 
    'Bar' : Icons.local_drink_outlined,
    'Accomodation' : Icons.house_outlined,
    'Admistration' : Icons.local_police_outlined,
    'Others' : Icons.alt_route_outlined,
  };

  Set<String> selectedCategories = {};


  final List<RegionItem> regions = [
    RegionItem(
      name: 'Africa',
      isContinent: true,
      countries: [
        CountryItem(name: 'Algeria', code: 'DZ'),
        CountryItem(name: 'Angola', code: 'AO'),
        CountryItem(name: 'Benin', code: 'BJ'),
        CountryItem(name: 'Botswana', code: 'BW'),
        CountryItem(name: 'Burkina Faso', code: 'BF'),
        CountryItem(name: 'Burundi', code: 'BI'),
        CountryItem(name: 'Cabo Verde', code: 'CV'),
        CountryItem(name: 'Cameroon', code: 'CM'),
        CountryItem(name: 'Central African Republic', code: 'CF'),
        CountryItem(name: 'Chad', code: 'TD'),
        CountryItem(name: 'Comoros', code: 'KM'),
        CountryItem(name: 'Congo (Congo-Brazzaville)', code: 'CG'),
        CountryItem(name: 'Democratic Republic of the Congo', code: 'CD'),
        CountryItem(name: 'Djibouti', code: 'DJ'),
        CountryItem(name: 'Egypt', code: 'EG'),
        CountryItem(name: 'Equatorial Guinea', code: 'GQ'),
        CountryItem(name: 'Eritrea', code: 'ER'),
        CountryItem(name: 'Eswatini', code: 'SZ'),
        CountryItem(name: 'Ethiopia', code: 'ET'),
        CountryItem(name: 'Gabon', code: 'GA'),
        CountryItem(name: 'Gambia', code: 'GM'),
        CountryItem(name: 'Ghana', code: 'GH'),
        CountryItem(name: 'Guinea', code: 'GN'),
        CountryItem(name: 'Guinea-Bissau', code: 'GW'),
        CountryItem(name: 'Ivory Coast', code: 'CI'),
        CountryItem(name: 'Kenya', code: 'KE'),
        CountryItem(name: 'Lesotho', code: 'LS'),
        CountryItem(name: 'Liberia', code: 'LR'),
        CountryItem(name: 'Libya', code: 'LY'),
        CountryItem(name: 'Madagascar', code: 'MG'),
        CountryItem(name: 'Malawi', code: 'MW'),
        CountryItem(name: 'Mali', code: 'ML'),
        CountryItem(name: 'Mauritania', code: 'MR'),
        CountryItem(name: 'Mauritius', code: 'MU'),
        CountryItem(name: 'Morocco', code: 'MA'),
        CountryItem(name: 'Mozambique', code: 'MZ'),
        CountryItem(name: 'Namibia', code: 'NA'),
        CountryItem(name: 'Niger', code: 'NE'),
        CountryItem(name: 'Nigeria', code: 'NG'),
        CountryItem(name: 'Rwanda', code: 'RW'),
        CountryItem(name: 'Sao Tome and Principe', code: 'ST'),
        CountryItem(name: 'Senegal', code: 'SN'),
        CountryItem(name: 'Seychelles', code: 'SC'),
        CountryItem(name: 'Sierra Leone', code: 'SL'),
        CountryItem(name: 'Somalia', code: 'SO'),
        CountryItem(name: 'South Africa', code: 'ZA'),
        CountryItem(name: 'South Sudan', code: 'SS'),
        CountryItem(name: 'Sudan', code: 'SD'),
        CountryItem(name: 'Tanzania', code: 'TZ'),
        CountryItem(name: 'Togo', code: 'TG'),
        CountryItem(name: 'Tunisia', code: 'TN'),
        CountryItem(name: 'Uganda', code: 'UG'),
        CountryItem(name: 'Zambia', code: 'ZM'),
        CountryItem(name: 'Zimbabwe', code: 'ZW'),
      ],
    ),
    RegionItem(
      name: 'Asia',
      isContinent: true,
      countries: [
        CountryItem(name: 'Afghanistan', code: 'AF'),
        CountryItem(name: 'Armenia', code: 'AM'),
        CountryItem(name: 'Azerbaijan', code: 'AZ'),
        CountryItem(name: 'Bahrain', code: 'BH'),
        CountryItem(name: 'Bangladesh', code: 'BD'),
        CountryItem(name: 'Bhutan', code: 'BT'),
        CountryItem(name: 'Brunei', code: 'BN'),
        CountryItem(name: 'Cambodia', code: 'KH'),
        CountryItem(name: 'China', code: 'CN'),
        CountryItem(name: 'Cyprus', code: 'CY'),
        CountryItem(name: 'Georgia', code: 'GE'),
        CountryItem(name: 'India', code: 'IN'),
        CountryItem(name: 'Indonesia', code: 'ID'),
        CountryItem(name: 'Iran', code: 'IR'),
        CountryItem(name: 'Iraq', code: 'IQ'),
        CountryItem(name: 'Israel', code: 'IL'),
        CountryItem(name: 'Japan', code: 'JP'),
        CountryItem(name: 'Jordan', code: 'JO'),
        CountryItem(name: 'Kazakhstan', code: 'KZ'),
        CountryItem(name: 'Kuwait', code: 'KW'),
        CountryItem(name: 'Kyrgyzstan', code: 'KG'),
        CountryItem(name: 'Laos', code: 'LA'),
        CountryItem(name: 'Lebanon', code: 'LB'),
        CountryItem(name: 'Malaysia', code: 'MY'),
        CountryItem(name: 'Maldives', code: 'MV'),
        CountryItem(name: 'Mongolia', code: 'MN'),
        CountryItem(name: 'Myanmar', code: 'MM'),
        CountryItem(name: 'Nepal', code: 'NP'),
        CountryItem(name: 'North Korea', code: 'KP'),
        CountryItem(name: 'Oman', code: 'OM'),
        CountryItem(name: 'Pakistan', code: 'PK'),
        CountryItem(name: 'Palestine', code: 'PS'),
        CountryItem(name: 'Philippines', code: 'PH'),
        CountryItem(name: 'Qatar', code: 'QA'),
        CountryItem(name: 'Saudi Arabia', code: 'SA'),
        CountryItem(name: 'Singapore', code: 'SG'),
        CountryItem(name: 'South Korea', code: 'KR'),
        CountryItem(name: 'Sri Lanka', code: 'LK'),
        CountryItem(name: 'Syria', code: 'SY'),
        CountryItem(name: 'Taiwan', code: 'TW'),
        CountryItem(name: 'Tajikistan', code: 'TJ'),
        CountryItem(name: 'Thailand', code: 'TH'),
        CountryItem(name: 'Timor-Leste', code: 'TL'),
        CountryItem(name: 'Turkey', code: 'TR'),
        CountryItem(name: 'Turkmenistan', code: 'TM'),
        CountryItem(name: 'United Arab Emirates', code: 'AE'),
        CountryItem(name: 'Uzbekistan', code: 'UZ'),
        CountryItem(name: 'Vietnam', code: 'VN'),
        CountryItem(name: 'Yemen', code: 'YE'),
      ],
    ),
    RegionItem(
      name: 'Europe',
      isContinent: true,
      countries: [
        CountryItem(name: 'Albania', code: 'AL'),
        CountryItem(name: 'Andorra', code: 'AD'),
        CountryItem(name: 'Austria', code: 'AT'),
        CountryItem(name: 'Belarus', code: 'BY'),
        CountryItem(name: 'Belgium', code: 'BE'),
        CountryItem(name: 'Bosnia and Herzegovina', code: 'BA'),
        CountryItem(name: 'Bulgaria', code: 'BG'),
        CountryItem(name: 'Croatia', code: 'HR'),
        CountryItem(name: 'Czech Republic', code: 'CZ'),
        CountryItem(name: 'Denmark', code: 'DK'),
        CountryItem(name: 'Estonia', code: 'EE'),
        CountryItem(name: 'Finland', code: 'FI'),
        CountryItem(name: 'France', code: 'FR'),
        CountryItem(name: 'Germany', code: 'DE'),
        CountryItem(name: 'Greece', code: 'GR'),
        CountryItem(name: 'Hungary', code: 'HU'),
        CountryItem(name: 'Iceland', code: 'IS'),
        CountryItem(name: 'Ireland', code: 'IE'),
        CountryItem(name: 'Italy', code: 'IT'),
        CountryItem(name: 'Kosovo', code: 'XK'),
        CountryItem(name: 'Latvia', code: 'LV'),
        CountryItem(name: 'Liechtenstein', code: 'LI'),
        CountryItem(name: 'Lithuania', code: 'LT'),
        CountryItem(name: 'Luxembourg', code: 'LU'),
        CountryItem(name: 'Malta', code: 'MT'),
        CountryItem(name: 'Moldova', code: 'MD'),
        CountryItem(name: 'Monaco', code: 'MC'),
        CountryItem(name: 'Montenegro', code: 'ME'),
        CountryItem(name: 'Netherlands', code: 'NL'),
        CountryItem(name: 'North Macedonia', code: 'MK'),
        CountryItem(name: 'Norway', code: 'NO'),
        CountryItem(name: 'Poland', code: 'PL'),
        CountryItem(name: 'Portugal', code: 'PT'),
        CountryItem(name: 'Romania', code: 'RO'),
        CountryItem(name: 'Russia', code: 'RU'),
        CountryItem(name: 'San Marino', code: 'SM'),
        CountryItem(name: 'Serbia', code: 'RS'),
        CountryItem(name: 'Slovakia', code: 'SK'),
        CountryItem(name: 'Slovenia', code: 'SI'),
        CountryItem(name: 'Spain', code: 'ES'),
        CountryItem(name: 'Sweden', code: 'SE'),
        CountryItem(name: 'Switzerland', code: 'CH'),
        CountryItem(name: 'Ukraine', code: 'UA'),
        CountryItem(name: 'United Kingdom', code: 'GB'),
        CountryItem(name: 'Vatican City', code: 'VA'),
      ],
    ),
    RegionItem(
      name: 'North America',
      isContinent: true,
      countries: [
        CountryItem(name: 'Antigua and Barbuda', code: 'AG'),
        CountryItem(name: 'Bahamas', code: 'BS'),
        CountryItem(name: 'Barbados', code: 'BB'),
        CountryItem(name: 'Belize', code: 'BZ'),
        CountryItem(name: 'Canada', code: 'CA'),
        CountryItem(name: 'Costa Rica', code: 'CR'),
        CountryItem(name: 'Cuba', code: 'CU'),
        CountryItem(name: 'Dominica', code: 'DM'),
        CountryItem(name: 'Dominican Republic', code: 'DO'),
        CountryItem(name: 'El Salvador', code: 'SV'),
        CountryItem(name: 'Grenada', code: 'GD'),
        CountryItem(name: 'Guatemala', code: 'GT'),
        CountryItem(name: 'Haiti', code: 'HT'),
        CountryItem(name: 'Honduras', code: 'HN'),
        CountryItem(name: 'Jamaica', code: 'JM'),
        CountryItem(name: 'Mexico', code: 'MX'),
        CountryItem(name: 'Nicaragua', code: 'NI'),
        CountryItem(name: 'Panama', code: 'PA'),
        CountryItem(name: 'Saint Kitts and Nevis', code: 'KN'),
        CountryItem(name: 'Saint Lucia', code: 'LC'),
        CountryItem(name: 'Saint Vincent and the Grenadines', code: 'VC'),
        CountryItem(name: 'Trinidad and Tobago', code: 'TT'),
        CountryItem(name: 'United States', code: 'US'),
      ],
    ),
    RegionItem(
      name: 'South America',
      isContinent: true,
      countries: [
        CountryItem(name: 'Argentina', code: 'AR'),
        CountryItem(name: 'Bolivia', code: 'BO'),
        CountryItem(name: 'Brazil', code: 'BR'),
        CountryItem(name: 'Chile', code: 'CL'),
        CountryItem(name: 'Colombia', code: 'CO'),
        CountryItem(name: 'Ecuador', code: 'EC'),
        CountryItem(name: 'Guyana', code: 'GY'),
        CountryItem(name: 'Paraguay', code: 'PY'),
        CountryItem(name: 'Peru', code: 'PE'),
        CountryItem(name: 'Suriname', code: 'SR'),
        CountryItem(name: 'Uruguay', code: 'UY'),
        CountryItem(name: 'Venezuela', code: 'VE'),
      ],
    ),
    RegionItem(
      name: 'Oceania',
      isContinent: true,
      countries: [
        CountryItem(name: 'Australia', code: 'AU'),
        CountryItem(name: 'Fiji', code: 'FJ'),
        CountryItem(name: 'Kiribati', code: 'KI'),
        CountryItem(name: 'Marshall Islands', code: 'MH'),
        CountryItem(name: 'Micronesia', code: 'FM'),
        CountryItem(name: 'Nauru', code: 'NR'),
        CountryItem(name: 'New Zealand', code: 'NZ'),
        CountryItem(name: 'Palau', code: 'PW'),
        CountryItem(name: 'Papua New Guinea', code: 'PG'),
        CountryItem(name: 'Samoa', code: 'WS'),
        CountryItem(name: 'Solomon Islands', code: 'SB'),
        CountryItem(name: 'Tonga', code: 'TO'),
        CountryItem(name: 'Tuvalu', code: 'TV'),
        CountryItem(name: 'Vanuatu', code: 'VU'),
      ],
    ),
  ];

  Set<String> selectedRegions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceLight,
        scrolledUnderElevation: 0, 
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(20,0,0,0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            icon: Icon(Icons.arrow_back_ios_new_outlined)
          ),
        ),
        titleSpacing: 15,
        title: const Text("Filter",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            fontSize: 28,
          ),
        ),
      ),
      
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 0),
          child : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Ecart
              //Container(width: double.infinity, height: 20,color: AppColors.surfaceLight,),
              
              //Filter by category
              Container(
                width: double.infinity,
                color: AppColors.surfaceLight,   
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                child: const Text(
                  "CATEGORIES",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: AppColors.surfaceLight,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child :Wrap(
                  spacing: 10,  // Espace horizontal
                  runSpacing: 10,  // Espace vertical
                  children: categories.entries.map((entry) {
                      final name = entry.key;
                      final icon = entry.value;
                      final isSelected = selectedCategories.contains(name);

                      return FilterChip(
                        avatar: Icon(
                          icon,
                          color: isSelected ? Colors.transparent : Colors.grey,
                          size : 18,
                        ),
                        label: Text(name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedCategories.add(name);
                            } else {
                              selectedCategories.remove(name);
                            }
                          });
                        },
                      );
                    }
                  ).toList(),
                ),
              ),
              
              //Filter by Countries, Region
              Container(
                width: double.infinity, 
                color: AppColors.surfaceLight,   
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: const Text(
                  "REGIONS & COUNTRIES",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    letterSpacing: 1.5,
                  ),
                ),
              ),             
              Expanded(
                child : ListView.builder(
                  itemCount: regions.length,
                  itemBuilder: (context, index) {
                    final region = regions[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(region.name),
                          trailing: region.isContinent ? Icon(region.isExpanded ? Icons.expand_less : Icons.expand_more,) : null,
                          onTap: () {
                            setState(() {
                              region.isExpanded = !region.isExpanded;
                            });
                          },
                        ),
                        if (region.isExpanded && region.countries != null)
                          ...region.countries!.map((country) {
                            final isSelected = selectedRegions.contains(country.name);
                            
                            return Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: ListTile(
                                leading: Text(
                                  countryCodeToEmoji(country.code),
                                  style: const TextStyle(fontSize: 22), // Ajuste la taille de l'emoji
                                ),
                                title: Text(country.name),
                                trailing: Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedRegions.add(country.name);
                                      } else {
                                        selectedRegions.remove(country.name);
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          }),
                      ],
                    );
                  } 
                ),
              ),   
            ]
          )
          )
        ),
        bottomNavigationBar: BottomAppBar(
          color: AppColors.surfaceLight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: null,
                child: SizedBox(
                  width: 150,
                  height : 40,
                  child:Center(child: Text("Apply Filters")),
                ),
              ),


              ElevatedButton(
                onPressed: () {Navigator.pop(context);},
                child: SizedBox(
                  width: 150,
                  height : 40,
                  child:Center(child: Text("Cancel")),
                ),
              ),
              

            ],
          )
        )
      );
  }
}