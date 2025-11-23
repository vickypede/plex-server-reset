[![Plex](https://support.plex.tv/wp-content/themes/plex/assets/img/plex-logo.svg)](https://www.plex.tv/)

[ ]

**Free Movies & TV**Live TV**Features**Download

**Explore**

* [Featured](https://watch.plex.tv/)
* 
* [Movies &amp; TV Shows](https://watch.plex.tv/movies-and-shows)
* [Live TV Channels](https://watch.plex.tv/live-tv)
* 
* [Most Popular](https://watch.plex.tv/movies-and-shows/list/trending)
* [Leaving Soon](https://watch.plex.tv/movies-and-shows/list/expiring)
* [What to Watch](https://www.plex.tv/what-to-watch/)

**Explore**

* [Browse Channels](https://watch.plex.tv/live-tv)
* 

**Plex for All**

* [600+ Free Live TV Channels**Tune in anytime, on any device.**](https://www.plex.tv/watch-free-tv/)
* [Free Movies &amp; Shows**Stream 50,000+ titles on demand.**](https://www.plex.tv/watch-free/)
* [Ready, Set, Rent **New**Browse new releases and cult classics.](https://www.plex.tv/rentals/)
* [Experience Discover on Plex**Find a movie. Find a show. Find your friends.**](https://www.plex.tv/discover/)
* [Stream on Almost Any Device**Download our free app to start.**](https://www.plex.tv/apps-devices/)

**Plex for Pros**

* [Add Your Personal Media**Organize & stream your own collection.**](https://www.plex.tv/your-media/)
* [Choose a Plan**Upgrade to stream your personal media remotely & more.**](https://www.plex.tv/plans/)
* [Plexamp**Experience the app made for audiophiles.**](https://www.plex.tv/plexamp/)
* [Ultimate DVR (Plex Pass Exclusive)**Watch & record broadcast TV.**](https://www.plex.tv/tv/)

**Get the App**

* [For TVs**Roku, Fire TV, Samsung & more**](https://www.plex.tv/media-server-downloads/#plex-app)
* [For Mobile**iOS & Android**](https://www.plex.tv/media-server-downloads/#plex-app)
* [For Consoles**PlayStation & Xbox**](https://www.plex.tv/media-server-downloads/#plex-app)
* [For Desktop**Mac, Windows & Web**](https://www.plex.tv/media-server-downloads/#plex-app)

**Plex Pro Downloads**

* [Plex Media Server**Create, organize, and store your collections.**](https://www.plex.tv/media-server-downloads/#plex-media-server)
* [Plexamp**Experience the app made for audiophiles.**](https://www.plex.tv/plexamp/#downloads)
* [Plex Photos **New**All your photo collections. One easy app.](https://www.plex.tv/media-server-downloads/#plex-plexphotos)
* [Plex Dash (Plex Pass Exclusive)**A custom app for remote server monitoring.**](https://www.plex.tv/media-server-downloads/#plex-plexdash)

![victor4685](https://plex.tv/users/d54886539b2cea96/avatar?c=1763864035)

# Support Articles

[Support](https://support.plex.tv/ "Plex Support")  [Articles](https://support.plex.tv/articles/ "Articles")  **Why am I locked out of Server Settings and how do I get in?**

# Why am I locked out of Server Settings and how do I get in?

In some rare situations, you may find yourself “locked out” from being able to access your Plex Media Server and unable to directly access the server settings. One of the most common causes for this is if your server is signed in to one account (perhaps one used with an old, previous installation) and your web app is signed in with a different account that doesn’t have permission to connect to the server.

It can also occur after you change your password, remove your server “Device” entry, or otherwise invalidate the existing authentication token that your server uses.

You’ll often see this exhibited as a “`You do not have permission to access this server`” or sometimes a “`No soup for you`” message when viewing in the Plex Web App.

The most straightforward way to regain access is typically to remove the current account/authentication information from the server, which will then allow you to sign in or claim the server with your desired account. Correctly following these instructions will not wipe out a server installation or make you have to re-create libraries.

[]()## Access Special Server Settings

There are a number of “hidden” special settings related to your Plex Media Server, which are stored in a special location that varies by operating system. You’ll first need to go open those settings.

### Windows

Certain Plex Media Server settings are stored in the Registry on Windows. In the Registry, they’re located under:

```
HKEY_CURRENT_USER\Software\Plex, Inc.\Plex Media Server
```

 **Tip!** : We strongly encourage you to make a standard backup of either the full Rregistry or only the specific “Plex Media Server” Registry key prior to making any changes.

 **Related Page** : [Microsoft – Back up the registry](https://support.microsoft.com/en-us/help/322756/how-to-back-up-and-restore-the-registry-in-windows)
 **Related Page** : [How to Modify the Windows Registry](https://support.microsoft.com/en-us/help/256986/windows-registry-information-for-advanced-users)

### macOS

Using the Finder’s “Go” menu, select Go To Folder… then enter the following in the dialog box that pops up:

```
~/Library/Preferences/
```

The file in question is the `com.plexapp.plexmediaserver.plist` file.

 **Tip!** : We strongly encourage you to make a backup of the `com.plexapp.plexmediaserver.plist` file prior to making any changes.

### Linux

In Linux, the `Preferences.xml` file in the main Plex Media Server data directory contains the corresponding settings.

 **Related Page** : [Where is the Plex Media Server data directory located?](https://support.plex.tv/articles/202915258-where-is-the-plex-media-server-data-directory-located/)

 **Tip!** : We strongly encourage you to make a backup of the `Preferences.xml` file prior to making any changes.

Open that file in a standard text editor.

[]()## Remove Certain Entries

Once you’ve opened the special settings for editing, you’ll need to remove some specific entries there.

### Windows

1. Quit/exit your Plex Media Server, so it’s not actively running
2. Open the appropriate Registry area (as noted above) to edit
3. Highlight the following entries and delete them:
   * `PlexOnlineHome`
   * `PlexOnlineMail`
   * `PlexOnlineToken`
   * `PlexOnlineUsername`
4. Launch your Plex Media Server

 **Tip!** : Scared of dealing with the registry? You can check out [this forum topic](https://forums.plex.tv/t/you-need-to-reclaim-your-server-but-dont-dare-to-touch-the-windows-registry/809720) for information on using a registry script to make the changes for you.

### macOS

1. Quit/exit your Plex Media Server, so it’s not actively running
2. Open the macOS “Terminal”application
3. Run the following *individual* commands in Terminal
   * `defaults delete com.plexapp.plexmediaserver PlexOnlineHome`
   * `defaults delete com.plexapp.plexmediaserver PlexOnlineMail`
   * `defaults delete com.plexapp.plexmediaserver PlexOnlineToken`
   * `defaults delete com.plexapp.plexmediaserver PlexOnlineUsername`
4. Launch your Plex Media Server

### Linux

1. Quit/exit your Plex Media Server, so it’s not actively running
2. In your text editor, remove the following attribute/key pairs from the `Preferences.xml` file:
   * `PlexOnlineHome="1"`
   * `PlexOnlineMail="jane@example.com"`
   * `PlexOnlineToken="RanD0MHex1DecIm4LtoKeNheR3"`
   * `PlexOnlineUsername="ExampleUser"`
3. Save the edited file
4. Launch your Plex Media Server

[]()## Restore Access to Your Plex Media Server

Now that you’ve removed the values, you just need to get back in to your Plex Media Server. You can sign in to/claim your Plex Media Server with your Plex account as normal. See the related page for specific details.

 **Related Page** : [Sign in to Your Plex Account](https://support.plex.tv/articles/200878643-sign-in-to-your-plex-account/)

**Share this*** [](https://twitter.com/share?url=https://support.plex.tv/articles/204281528-why-am-i-locked-out-of-server-settings-and-how-do-i-get-in/&text=Why%20am%20I%20locked%20out%20of%20Server%20Settings%20and%20how%20do%20I%20get%20in?&via=plex)

* [](https://www.facebook.com/share.php?u=https://support.plex.tv/articles/204281528-why-am-i-locked-out-of-server-settings-and-how-do-i-get-in/&title=Why%20am%20I%20locked%20out%20of%20Server%20Settings%20and%20how%20do%20I%20get%20in?)
* [](https://www.linkedin.com/shareArticle?url=https://support.plex.tv/articles/204281528-why-am-i-locked-out-of-server-settings-and-how-do-i-get-in/&title=Why%20am%20I%20locked%20out%20of%20Server%20Settings%20and%20how%20do%20I%20get%20in?)

**Was this article helpful?**[Yes](https://support.plex.tv/articles/204281528-why-am-i-locked-out-of-server-settings-and-how-do-i-get-in/#vote) [No](https://support.plex.tv/articles/204281528-why-am-i-locked-out-of-server-settings-and-how-do-i-get-in/#)

Last modified on: June 6, 2025

[ ] Select LanguageAbkhazAcehneseAcholiAfarAfrikaansAlbanianAlurAmharicArabicArmenianAssameseAvarAwadhiAymaraAzerbaijaniBalineseBaluchiBambaraBaouléBashkirBasqueBatak KaroBatak SimalungunBatak TobaBelarusianBembaBengaliBetawiBhojpuriBikolBosnianBretonBulgarianBuryatCantoneseCatalanCebuanoChamorroChechenChichewaChinese (Simplified)Chinese (Traditional)ChuukeseChuvashCorsicanCrimean Tatar (Cyrillic)Crimean Tatar (Latin)CroatianCzechDanishDariDhivehiDinkaDogriDombeDutchDyulaDzongkhaEsperantoEstonianEweFaroeseFijianFilipinoFinnishFonFrenchFrench (Canada)FrisianFriulianFulaniGaGalicianGeorgianGermanGreekGuaraniGujaratiHaitian CreoleHakha ChinHausaHawaiianHebrewHiligaynonHindiHmongHungarianHunsrikIbanIcelandicIgboIlocanoIndonesianInuktut (Latin)Inuktut (Syllabics)IrishItalianJamaican PatoisJapaneseJavaneseJingpoKalaallisutKannadaKanuriKapampanganKazakhKhasiKhmerKigaKikongoKinyarwandaKitubaKokborokKomiKonkaniKoreanKrioKurdish (Kurmanji)Kurdish (Sorani)KyrgyzLaoLatgalianLatinLatvianLigurianLimburgishLingalaLithuanianLombardLugandaLuoLuxembourgishMacedonianMadureseMaithiliMakassarMalagasyMalayMalay (Jawi)MalayalamMalteseMamManxMaoriMarathiMarshalleseMarwadiMauritian CreoleMeadow MariMeiteilon (Manipuri)MinangMizoMongolianMyanmar (Burmese)Nahuatl (Eastern Huasteca)NdauNdebele (South)Nepalbhasa (Newari)NepaliNKoNorwegianNuerOccitanOdia (Oriya)OromoOssetianPangasinanPapiamentoPashtoPersianPolishPortuguese (Brazil)Portuguese (Portugal)Punjabi (Gurmukhi)Punjabi (Shahmukhi)QuechuaQʼeqchiʼRomaniRomanianRundiRussianSami (North)SamoanSangoSanskritSantali (Latin)Santali (Ol Chiki)Scots GaelicSepediSerbianSesothoSeychellois CreoleShanShonaSicilianSilesianSindhiSinhalaSlovakSlovenianSomaliSpanishSundaneseSusuSwahiliSwatiSwedishTahitianTajikTamazightTamazight (Tifinagh)TamilTatarTeluguTetumThaiTibetanTigrinyaTivTok PisinTonganTshilubaTsongaTswanaTuluTumbukaTurkishTurkmenTuvanTwiUdmurtUkrainianUrduUyghurUzbekVendaVenetianVietnameseWarayWelshWolofXhosaYakutYiddishYorubaYucatec MayaZapotecZulu

Powered by [![Google Translate](https://www.gstatic.com/images/branding/googlelogo/1x/googlelogo_color_42x16dp.png)Translate](https://translate.google.com/)

### Table of Contents

* [Access Special Server Settings](https://support.plex.tv/articles/204281528-why-am-i-locked-out-of-server-settings-and-how-do-i-get-in/#toc-0)
* [Remove Certain Entries](https://support.plex.tv/articles/204281528-why-am-i-locked-out-of-server-settings-and-how-do-i-get-in/#toc-1)
* [Restore Access to Your Plex Media Server](https://support.plex.tv/articles/204281528-why-am-i-locked-out-of-server-settings-and-how-do-i-get-in/#toc-2)

### Recently Viewed

* [Log Files](https://support.plex.tv/articles/201869908-log-files/)
* [Plex Media Server can’t sign in to Plex account or be claimed](https://support.plex.tv/articles/203841316-plex-media-server-can-t-sign-in-to-plex-account-or-be-claimed/)
* [Is Plex legal?](https://support.plex.tv/articles/is-plex-legal/)
* [Server Settings – Bandwidth and Transcoding Limits](https://support.plex.tv/articles/227715247-server-settings-bandwidth-and-transcoding-limits/)
* [Why can’t the Plex app find or connect to my Plex Media Server?](https://support.plex.tv/articles/204604227-why-can-t-the-plex-app-find-or-connect-to-my-plex-media-server/)

[![Plex](https://support.plex.tv/wp-content/themes/plex/assets/img/plex-logo.svg)](https://www.plex.tv/)

* [Company](https://www.plex.tv/about/)
  * [About](https://www.plex.tv/about/)
  * [Careers](https://www.plex.tv/careers/)
  * [Our Culture](https://www.plex.tv/about/culture/)
  * [Giving](https://www.plex.tv/about/giving/)
  * [Partners](https://www.plex.tv/about/partners/)
  * [News](https://www.plex.tv/press/)
  * [Plex Gear](https://plex-gear.myshopify.com/)
  * [The Plex Blog](https://www.plex.tv/blog/)
  * [Advertise with Us](https://www.plex.tv/advertising/)
* [Go Premium](https://www.plex.tv/plex-pass/)
* [Plans](https://www.plex.tv/plans/)
* [Plexamp](https://www.plex.tv/plexamp/)
* [Plex Labs](https://www.plex.tv/plex-labs/)
* [Get Perks](https://www.plex.tv/plex-pass/perks/)
* [Downloads](https://www.plex.tv/media-server-downloads/)
* [Plex Media Server](https://www.plex.tv/media-server-downloads/#plex-media-server)
* [Plex](https://www.plex.tv/media-server-downloads/#plex-app)
* [Plexamp](https://www.plex.tv/media-server-downloads/#plex-plexamp)
* [Plex Photos](https://www.plex.tv/media-server-downloads/#plex-plexphotos)
* [Plex Dash](https://www.plex.tv/media-server-downloads/#plex-plexdash)
* [Where to Watch](https://www.plex.tv/apps-devices/)
* [Support](https://support.plex.tv/)
* [Finding Help](https://support.plex.tv/)
* [Support Library](https://support.plex.tv/articles)
* [Community Forums](https://forums.plex.tv/)
* [Community Guidelines](https://www.plex.tv/about/community-guidelines/)
* [Billing Questions](https://www.plex.tv/contact/?option=plex-pass-billing)
* [Status](https://status.plex.tv/)
* [Bug Bounty](https://support.plex.tv/articles/reporting-security-issues/)
* [CordCutter](https://cordcutter.plex.tv/)
* [Get in Touch](https://www.plex.tv/contact/)
* [Watch Free](https://watch.plex.tv/movies-and-shows)
* [Discover on Plex](https://www.plex.tv/discover/)
* [TV Channel Finder](https://www.plex.tv/live-tv-channels/)
* [What to Watch](https://www.plex.tv/what-to-watch/)
* [What To Watch on Netflix](https://www.plex.tv/what-to-watch/netflix/)
* [What To Watch on Hulu](https://www.plex.tv/what-to-watch/hulu/)
* [A24 Movies](https://www.plex.tv/a24-movies/)
* [Valentine’s Day Movies](https://www.plex.tv/valentines-day-movies/)
* [Christmas Movies](https://www.plex.tv/best-christmas-movies/)

**Copyright © 2025 Plex** * [Privacy &amp; Legal](https://www.plex.tv/about/privacy-legal/)

* [Accessibility](https://www.plex.tv/accessibility-statement/)
* [Manage Cookies](https://support.plex.tv/articles/204281528-why-am-i-locked-out-of-server-settings-and-how-do-i-get-in/#)
* [](https://www.instagram.com/plex.tv/)
* [](https://www.tiktok.com/@plex.tv)
* [](https://twitter.com/plex)
* [](https://bsky.app/profile/plex.tv)
* [](https://www.facebook.com/plexapp)
* [](https://www.linkedin.com/company/plex-inc)
* [](https://www.youtube.com/user/plextvapp)
