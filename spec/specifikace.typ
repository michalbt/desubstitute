#set par(justify: true)
#show heading: set block(below: 0.8em)
#show link: underline

#title[Specifikace zápočtového programu]

Michal Bernat \
Univerzita Karlova, Matematicko-fyzikální fakulta \
Neprocedurální programování (NPRG005) \
2025/2026

= Základní popis projektu

Cílem je vytvořit nástroj pro rozluštění substitučních šifer s pomocí frekvenční analýzy jazyka textu.

= Podrobný popis projektu

== Řešený problém

Vstupem je text v některém přirozeném jazyce zašifrovaný _substituční šifrou_ -- procesem, při němž je každý znak textu nahrazen jiným znakem podle pevné _substituce_. V našem případě bude substituce vždy tvořit permutaci na abecedě daného jazyka nezahrnující mezery (ty zůstanou v textu nezměněny).

Úkolem je tento text _dešifrovat_, tedy získat původní text v přirozeném jazyce a použitou substituci. Přesněji, cílem je najít ze všech možných substitucí takovou, jejíž inverze při aplikaci na vstup produkuje text nejvěrohodněji odpovídající textu v daném jazyce.

Pro posouzení věrohodnosti textu jsou k dispozici _frekvenční statistiky_ daného jazyka. Tento program bude využívat frekvence znaků a _bigramů_, tedy dvojic po sobě jdoucích znaků, případně četnosti slov v nějakém rozsáhlém textu či souboru textů.

== Algoritmus

Program bude využívat algoritmus popsaný v #link("https://www.researchgate.net/profile/Thomas-Jakobsen-6/publication/266714630_A_fast_method_for_cryptanalysis_of_substitution_ciphers/links/56ebe4fe08aefd0fc1c718ef/A-fast-method-for-cryptanalysis-of-substitution-ciphers.pdf")[článku T. Jakobsena] @jakobsen. Ten nejprve zkonstruuje počáteční substituci podle frekvencí výskytu znaků v daném jazyce (tj. nejčastější znak v jazyce bude odpovídat nejčastějšímu znaku zašifrovaného textu a podobně). Následně tuto substituci iterativně zpřesňuje prohazováním znaků a porovnáváním frekvencí bigramů v textu s očekávanou frekvencí v jazyce.

Pokud by tento algoritmus neprodukoval dostatečně dobré výsledky, bude upraven tak, aby využíval i četnosti slov v daném jazyce.

== Rozhraní

Program se bude chovat jako nástroj příkazové řádky, vstupní (zašifrovaný) text tedy bude číst ze standardního vstupu a na standardní výstup bude vypisovat odhad původního textu. Soubory s frekvenční analýzou jazyka budou ve formátu CSV a cesta k nim bude předána jako parametr příkazové řádky. Dalšími parametry bude možné provést přesnější nastavení (např. počet iterací před zastavením nebo vypsání použité substituce).

== Technologie

Program bude napsán v jazyce Haskell. Pro zpracování parametrů příkazové řádky bude využívat knihovnu #link("https://github.com/pcapriotti/optparse-applicative")[optparse-applicative] nebo jinou podobnou.

Projekt bude vyvíjen ve veřejném repozitáři na platformě #link("https://github.com/michalbt/desubstitute")[GitHub].

#bibliography("citace.bib", title: "Reference")
