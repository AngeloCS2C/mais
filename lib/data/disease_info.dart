class DiseaseInfo {
  static Map<String, Map<String, dynamic>> treatmentDetails = {
    'northern_leaf_blight': {
      'scientificName': {'en': 'Bipolaris zeicola', 'tl': 'Bipolaris zeicola'},
      'description': {
        'en':
            'Northern Leaf Spot is a fungal disease that affects corn. It causes elongated, brownish spots on the leaves, leading to reduced photosynthesis and poor plant health.',
        'tl':
            'Ang Northern Leaf Spot ay isang fungal na sakit na nakakaapekto sa mais. Ito ay nagdudulot ng pahabang, kayumangging mga mantsa sa mga dahon na nagdudulot ng pagkabawas ng photosynthesis at mahinang kalusugan ng halaman.'
      },
      'effects': {
        'en':
            'If not controlled, Northern Leaf Spot can result in reduced yields due to the loss of photosynthesis, weakening of the plant, and poor grain quality.',
        'tl':
            'Kung hindi makontrol, ang Northern Leaf Spot ay maaaring magdulot ng pagbawas ng ani dahil sa pagkawala ng photosynthesis, panghihina ng halaman, at mahinang kalidad ng butil.'
      },
      'recommendations': {
        'en': [
          {
            'text':
                '1. Choose the Right Corn: Start by planting corn varieties that naturally resist this disease.',
            'image': 'assets/images/northern_leaf_blight_tip1_en.png',
            'explanation':
                'Start by planting corn varieties that naturally resist this disease. It’s one of the easiest ways to stay ahead of the problem.', // Added empty explanation
          },
          {
            'text':
                '2. Rotate Your Crops: Don’t plant corn in the same spot year after year.',
            'image': 'assets/images/northern_leaf_blight_tip2_en.png',
            'explanation':
                ' Don’t plant corn in the same spot year after year. Switch it up with crops like soybeans to give the soil a break and keep the disease at bay.', // Added empty explanation
          },
          {
            'text':
                '3. Clean Up After Harvest: After you harvest, make sure to remove any leftover corn stalks or leaves.',
            'image': 'assets/images/northern_leaf_blight_tip3_en.png',
            'explanation':
                'After you harvest, make sure to remove any leftover corn stalks or leaves. The disease can hide in that debris and come back the next year.', // Added empty explanation
          },
          {
            'text':
                '4. Use Fungicides When Needed: If you spot signs of the disease early, use fungicides.',
            'image': 'assets/images/northern_leaf_blight_tip4_en.png',
            'explanation':
                'If you spot signs of the disease early, like dark spots on the leaves, use fungicides with ingredients like strobilurins or triazoles to stop it from spreading. ', // Added empty explanation
          },
          {
            'text':
                '5. Give Your Plants Some Space: Don’t overcrowd your corn plants.',
            'image': 'assets/images/northern_leaf_blight_tip5_en.png',
            'explanation':
                '''Don’t overcrowd your corn plants. If they’re too close together, it creates a damp environment that can encourage disease.\n\n
 By following these steps, you’ll help keep your corn healthy and reduce the risk of northern leaf spot''', // Added empty explanation
          }
        ],
        'tl': [
          {
            'text':
                '1. Pumili ng Tamang Mais: Magsimula sa pagtatanim ng mga uri ng mais na lumalaban sa sakit.',
            'image': 'assets/images/northern_leaf_blight_tip1_tl.png',
            'explanation':
                ' Magsimula sa pagtatanim ng mga uri ng mais na natural na lumalaban sa sakit na ito. Isa ito sa pinakamadaling paraan upang makasabay sa problema.', // Added empty explanation
          },
          {
            'text':
                '2. I-rotate ang Iyong Pananim: Huwag magtanim ng mais sa parehong lugar taon-taon.',
            'image': 'assets/images/northern_leaf_blight_tip2_tl.png',
            'explanation':
                'Huwag magtanim ng mais sa parehong lugar taon-taon. Palitan ito ng mga pananim tulad ng soybeans upang bigyan ang lupa ng pahinga at mapanatiling ligtas ang sakit.', // Added empty explanation
          },
          {
            'text':
                '3. Linisin Pagkatapos ng Pag-aani: Siguraduhing alisin ang mga natitirang tangkay o dahon ng mais.',
            'image': 'assets/images/northern_leaf_blight_tip3_tl.png',
            'explanation':
                'Pagkatapos mong umani, siguraduhing alisin ang anumang natitirang tangkay o dahon ng mais. Maaaring magtago ang sakit sa mga labi na iyon at muling bumalik sa susunod na taon.', // Added empty explanation
          },
          {
            'text':
                '4. Gumamit ng Fungicides: Kung makita ang sakit sa maagang yugto, gumamit ng fungicides.',
            'image': 'assets/images/northern_leaf_blight_tip4_tl.png',
            'explanation':
                'Kung makikita mo ang mga senyales ng sakit nang maaga, tulad ng madidilim na mantsa sa mga dahon, gumamit ng mga fungicides na may mga sangkap tulad ng strobilurins o triazoles upang mapigilan ang pagkalat nito.', // Added empty explanation
          },
          {
            'text':
                '5. Bigyan ng Espasyo ang Iyong mga Halaman: Huwag pagdikitin ang mga halaman.',
            'image': 'assets/images/northern_leaf_blight_tip5_tl.png',
            'explanation':
                'Huwag pagdikitin ang iyong mga halaman ng mais. Kung masyadong malapit sila sa isa’t isa, nagiging damp environment ito na maaaring magtaguyod ng sakit.', // Added empty explanation
          }
        ]
      }
    },
    'common_rust': {
      'scientificName': {'en': 'Puccinia sorghi', 'tl': 'Puccinia sorghi'},
      'description': {
        'en':
            'Common rust is a fungal disease that produces rust-colored pustules on corn leaves.',
        'tl':
            'Ang Common rust ay isang fungal na sakit na nagdudulot ng mga pustula na kulay-kalawang sa mga dahon ng mais.'
      },
      'effects': {
        'en':
            'In severe cases, common rust can cause early leaf death and significant yield losses.',
        'tl':
            'Sa malalang mga kaso, ang Common rust ay maaaring magdulot ng maagang pagkamatay ng dahon at pagbawas ng ani.'
      },
      'recommendations': {
        'en': [
          {
            'text': '1. Plant Resistant Hybrids.',
            'image': 'assets/images/common_rust_tip1_en.png',
            'explanation':
                '''Choose corn varieties that naturally resist common rust.\nNK8840 (Syngenta) – Known for its high yield and resistance to common diseases, including rust.\n
Pioneer® P30W30 (Pioneer) – A popular hybrid in the Philippines, bred for resistance to common rust and other diseases.\n
Dekalb® 9919S (Dekalb) – This variety has excellent disease resistance, including against common rust.\n
Bioseed® 9909 (Bioseed) – Known for good adaptability in the Philippines and resistance to rust and other diseases.''', // Added empty explanation
          },
          {
            'text': '2. Use Fungicides like azoxystrobin or propiconazole.',
            'image': 'assets/images/common_rust_tip3_en.png',
            'explanation':
                ' Apply fungicides like azoxystrobin or propiconazole early (V5 to tasseling) if you spot rust, especially in cool, wet conditions.', // Added empty explanation
          },
          {
            'text': '3. Rotate Crops to break the rust cycle.',
            'image': 'assets/images/common_rust_tip2_en.png',
            'explanation':
                'Swap corn with other crops like soybeans to break the rust cycle', // Added empty explanation
          },
          {
            'text': '4. Tillage to prevent rust spores from surviving.',
            'image': 'assets/images/common_rust_tip4_en.png',
            'explanation':
                'Turn under old crop debris to prevent rust spores from surviving.', // Added empty explanation
          },
          {
            'text': '5. Monitor Weather & Scout for early signs of rust.',
            'image': 'assets/images/common_rust_tip5_en.png',
            'explanation':
                '''Keep an eye on weather—rust loves cool and damp—and check your fields regularly for early signs.\nManage Water: Avoid over-irrigating to reduce leaf wetness where rust thrives.\n
These steps together can keep your corn healthy and rust-free!''', // Added empty explanation
          }
        ],
        'tl': [
          {
            'text': '1. Magtanim ng Mga Hybrid na Laban sa Sakit.',
            'image': 'assets/images/common_rust_tip1_tl.png',
            'explanation':
                '''Piliin ang mga barayti ng mais na natural na lumalaban sa karaniwang kalawang.\n\nNK8840 (Syngenta) – Kilala sa mataas na ani at paglaban sa mga karaniwang sakit, kabilang ang kalawang.\n

Pioneer® P30W30 (Pioneer) – Isang tanyag na hybrid sa Pilipinas, pinalaki para labanan ang karaniwang kalawang at iba pang sakit.\n

Dekalb® 9919S (Dekalb) – Ang barayting ito ay may mahusay na resistensya sa sakit, kabilang ang laban sa karaniwang kalawang.\n

Bioseed® 9909 (Bioseed) – Kilala sa magandang adaptasyon sa Pilipinas at resistensya sa kalawang at iba pang sakit.''', // Added empty explanation
          },
          {
            'text':
                '2. Gumamit ng Fungicides tulad ng azoxystrobin o propiconazole.',
            'image': 'assets/images/common_rust_tip2_tl.png',
            'explanation':
                'Mag-apply ng fungicides tulad ng azoxystrobin o propiconazole nang maaga (V5 hanggang tasseling) kung mapansin mo ang kalawang, lalo na sa malamig at basang kondisyon.', // Added empty explanation
          },
          {
            'text': '3. Magpalit ng Pananim upang masira ang cycle ng rust.',
            'image': 'assets/images/common_rust_tip3_tl.png',
            'explanation':
                'Magpalit ng mais sa ibang mga pananim tulad ng soybeans upang putulin ang siklo ng kalawang.', // Added empty explanation
          },
          {
            'text':
                '4. Gawin ang Tillage upang maiwasan ang pagkalat ng spores.',
            'image': 'assets/images/common_rust_tip4_tl.png',
            'explanation':
                'Ibaon ang lumang mga labi ng pananim upang maiwasan ang pag-survive ng mga spores ng kalawang.', // Added empty explanation
          },
          {
            'text':
                '5. Subaybayan ang Panahon at tingnan ang mga maagang palatandaan.',
            'image': 'assets/images/common_rust_tip5_tl.png',
            'explanation':
                '''Bantayan ang panahon—gustong-gusto ng kalawang ang malamig at mamasa-masa—at regular na suriin ang iyong mga taniman para sa mga maagang palatandaan.\n
Pamahalaan ang Tubig: Iwasan ang sobrang pagdidilig upang mabawasan ang pagkabasa ng dahon kung saan umuusbong ang kalawang.\n\nAng mga hakbang na ito ay magkasamang makakatulong na panatilihing malusog at walang kalawang ang iyong mais!''', // Added empty explanation
          }
        ]
      }
    },
    'gray_leaf_spot': {
      'scientificName': {
        'en': 'Cercospora zeae-maydis',
        'tl': 'Cercospora zeae-maydis'
      },
      'description': {
        'en':
            'Grey Leaf Spot is a fungal disease that affects corn, causing rectangular, grey lesions.',
        'tl':
            'Ang Grey Leaf Spot ay isang fungal na sakit na nagdudulot ng mga parihabang, kulay-abong sugat sa mais.'
      },
      'effects': {
        'en':
            'Severe infections can lead to significant loss of leaf tissue, reducing yields and overall plant health.',
        'tl':
            'Ang malalang impeksyon ay maaaring magdulot ng pagbawas ng tisyu ng dahon, pagbawas ng ani, at pangkalahatang kalusugan ng halaman.'
      },
      'recommendations': {
        'en': [
          {
            'text': '1. Choose Resistant Varieties',
            'image': 'assets/images/gray_leaf_spot_tip1_en.png',
            'explanation':
                ''' Plant corn hybrids that can naturally fight off gray leaf spot.\nDekalb® DKC67-44 – Widely available in the Philippines and known for its resistance to gray leaf spot and other diseases.\n
Pioneer® P1637 – A popular choice in the Philippines due to its high yield potential and resistance to gray leaf spot.\n
Bioseed® 9909 – Known for good adaptability in the Philippines, this variety is resistant to gray leaf spot as well as other common diseases.''', // Added empty explanation
          },
          {
            'text': '2. Use Fungicides',
            'image': 'assets/images/gray_leaf_spot_tip2_en.png',
            'explanation':
                'Apply fungicides like azoxystrobin or propiconazole at tasseling (VT) to silking (R1) if conditions are warm and humid.', // Added empty explanation
          },
          {
            'text': '3. Rotate Crops.',
            'image': 'assets/images/gray_leaf_spot_tip3_en.png',
            'explanation':
                'Rotate corn with other crops like soybeans to reduce the fungus in the soil.', // Added empty explanation
          },
          {
            'text':
                '4. Manage Field Debris to reduce overwintering fungal spores.',
            'image': 'assets/images/gray_leaf_spot_tip4_en.png',
            'explanation':
                'Turn under last season’s crop debris to get rid of the fungus that causes the disease.', // Added empty explanation
          },
          {
            'text': '5. Monitor Plant Health regularly.',
            'image': 'assets/images/gray_leaf_spot_tip5_en.png',
            'explanation':
                '''Keep an eye on your fields—catching the disease early makes treatment more effective.\nManage Water: Avoid overwatering to keep leaves dry and reduce disease spread.\n\n
These steps will help keep gray leaf spot under control and protect your corn!''', // Added empty explanation
          }
        ],
        'tl': [
          {
            'text': '1. Magtanim ng Mga Hybrid na Laban sa Sakit.',
            'image': 'assets/images/gray_leaf_spot_tip1_tl.png',
            'explanation':
                '''Magtanim ng mga hybrid na mais na natural na lumalaban sa gray leaf spot.\nDekalb® DKC67-44 – Malawakang makukuha sa Pilipinas at kilala sa resistensya nito sa gray leaf spot at iba pang sakit.\n

Pioneer® P1637 – Isang tanyag na pagpipilian sa Pilipinas dahil sa mataas na potensyal ng ani at resistensya sa gray leaf spot.\n

Bioseed® 9909 – Kilala sa magandang adaptasyon sa Pilipinas, ang barayting ito ay lumalaban sa gray leaf spot pati na rin sa iba pang karaniwang sakit.''', // Added empty explanation
          },
          {
            'text':
                '2. Gumamit ng Fungicides kapag ang kondisyon ay pabor sa sakit.',
            'image': 'assets/images/gray_leaf_spot_tip2_tl.png',
            'explanation':
                'Magpalit ng mais sa ibang pananim tulad ng soybeans upang mabawasan ang fungus sa lupa', // Added empty explanation
          },
          {
            'text':
                '3. I-rotate ang Pananim upang mabawasan ang presyon ng sakit.',
            'image': 'assets/images/gray_leaf_spot_tip3_tl.png',
            'explanation':
                'Magpalit ng mais sa ibang pananim tulad ng soybeans upang mabawasan ang fungus sa lupa.', // Added empty explanation
          },
          {
            'text':
                '4. Pamahalaan ang mga Labi ng Bukid upang mabawasan ang mga spores.',
            'image': 'assets/images/gray_leaf_spot_tip4_tl.png',
            'explanation':
                'Ibaon ang mga labi ng pananim mula sa nakaraang season upang maalis ang fungus na nagdudulot ng sakit.', // Added empty explanation
          },
          {
            'text': '5. Subaybayan ang Kalusugan ng Halaman.',
            'image': 'assets/images/gray_leaf_spot_tip5_tl.png',
            'explanation':
                '''Laging suriin ang iyong mga taniman—ang maagang pagkakahuli sa sakit ay nagpapahusay ng paggamot.\nPamahalaan ang Tubig: Iwasan ang sobrang pagdidilig upang panatilihing tuyo ang mga dahon at mabawasan ang pagkalat ng sakit.\nAng mga hakbang na ito ay makakatulong upang mapanatiling kontrolado ang gray leaf spot at maprotektahan ang iyong mais!''', // Added empty explanation
          }
        ]
      }
    },
    // Placeholder for other diseases
    'banded_leaf': {
      'scientificName': {'en': 'Unknown', 'tl': 'Hindi alam'},
      'description': {
        'en': 'Description for banded leaf.',
        'tl': 'Deskripsyon para sa banded leaf.'
      },
      'effects': {
        'en': 'Effects of banded leaf.',
        'tl': 'Mga epekto ng banded leaf.'
      },
      'recommendations': {
        'en': [
          {
            'text': '1. Recommendation 1 for banded leaf.',
            'image': 'assets/images/banded_leaf_tip1_en.png',
            'explanation': '', // Added empty explanation
          },
          {
            'text': '2. Recommendation 2 for banded leaf.',
            'image': 'assets/images/banded_leaf_tip2_en.png',
            'explanation': '', // Added empty explanation
          }
        ],
        'tl': [
          {
            'text': '1. Rekomendasyon 1 para sa banded leaf.',
            'image': 'assets/images/banded_leaf_tip1_tl.png',
            'explanation': '', // Added empty explanation
          },
          {
            'text': '2. Rekomendasyon 2 para sa banded leaf.',
            'image': 'assets/images/banded_leaf_tip2_tl.png',
            'explanation': '', // Added empty explanation
          }
        ]
      }
    },
    'corn_mosaic': {
      'scientificName': {'en': 'Unknown', 'tl': 'Hindi alam'},
      'description': {
        'en': 'Description for corn mosaic.',
        'tl': 'Deskripsyon para sa corn mosaic.'
      },
      'effects': {
        'en': 'Effects of corn mosaic.',
        'tl': 'Mga epekto ng corn mosaic.'
      },
      'recommendations': {
        'en': [
          {
            'text': '1. Recommendation 1 for corn mosaic.',
            'image': 'assets/images/corn_mosaic_tip1_en.png',
            'explanation': '', // Added empty explanation
          },
          {
            'text': '2. Recommendation 2 for corn mosaic.',
            'image': 'assets/images/corn_mosaic_tip2_en.png',
            'explanation': '', // Added empty explanation
          }
        ],
        'tl': [
          {
            'text': '1. Rekomendasyon 1 para sa corn mosaic.',
            'image': 'assets/images/corn_mosaic_tip1_tl.png',
            'explanation': '', // Added empty explanation
          },
          {
            'text': '2. Rekomendasyon 2 para sa corn mosaic.',
            'image': 'assets/images/corn_mosaic_tip2_tl.png',
            'explanation': '', // Added empty explanation
          }
        ]
      }
    },
    'downy_mildew': {
      'scientificName': {'en': 'Unknown', 'tl': 'Hindi alam'},
      'description': {
        'en': 'Description for downy mildew.',
        'tl': 'Deskripsyon para sa downy mildew.'
      },
      'effects': {
        'en': 'Effects of downy mildew.',
        'tl': 'Mga epekto ng downy mildew.'
      },
      'recommendations': {
        'en': [
          {
            'text': '1. Recommendation 1 for downy mildew.',
            'image': 'assets/images/downy_mildew_tip1_en.png',
            'explanation': '', // Added empty explanation
          },
          {
            'text': '2. Recommendation 2 for downy mildew.',
            'image': 'assets/images/downy_mildew_tip2_en.png',
            'explanation': '', // Added empty explanation
          }
        ],
        'tl': [
          {
            'text': '1. Rekomendasyon 1 para sa downy mildew.',
            'image': 'assets/images/downy_mildew_tip1_tl.png',
            'explanation': '', // Added empty explanation
          },
          {
            'text': '2. Rekomendasyon 2 para sa downy mildew.',
            'image': 'assets/images/downy_mildew_tip2_tl.png',
            'explanation': '', // Added empty explanation
          }
        ]
      }
    },
    'healthy': {
      'scientificName': {'en': '', 'tl': ''},
      'description': {
        'en': 'Your plant is healthy!',
        'tl': 'Ang iyong halaman ay malusog!'
      },
      'effects': {'en': 'No adverse effects.', 'tl': 'Walang masamang epekto.'},
      'recommendations': {
        'en': [
          {
            'text': 'Keep monitoring your crops to ensure good health.',
            'image': 'assets/images/healthy_tip_en.png',
            'explanation': '', // Added empty explanation
          }
        ],
        'tl': [
          {
            'text':
                'Patuloy na subaybayan ang iyong mga pananim upang masiguro ang mabuting kalusugan.',
            'image': 'assets/images/healthy_tip_tl.png',
            'explanation': '', // Added empty explanation
          }
        ]
      }
    }
  };
}
