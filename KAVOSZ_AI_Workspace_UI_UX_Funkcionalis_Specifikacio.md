# KAVOSZ AI Platform: Workspace UI/UX és funkcionális specifikáció

**Belső fejlesztői specifikáció**
Verzió: 0.3 (fejlesztésre kész) · Dátum: 2026-06-17 · Tulajdonos: Bendi / 1337 Partners
Státusz: fejlesztésre kész

---

## 1. Bevezetés

### 1.1 A dokumentum célja

Ez a dokumentum a KAVOSZ AI platform **Workspace** rendszerének teljes UI, UX és funkcionális leírása. A fejlesztőcsapat ebből építi a tényleges webalkalmazást. A jelenlegi kód (a `kavosz-ai-site` repo) egy értékesítési demó (sales demo); ez a specifikáció felülírja a demót minden ponton, ahol eltér tőle. Ahol a demó tartalmaz olyan kész funkciót, amit a specifikáció nem érint, az a Függelék A-ban szerepel halasztott tételként.

A dokumentum a forrás-szövegnél (a megrendelői draftnál) **granulárisabb**: minden elemhez megadja a célt, a pozíciót, az állapotokat (state), az interakciókat, az átmeneteket és a magyar microcopy-t.

### 1.2 Hatókör

**Hatókörben (in scope):** a Workspace rendszer end-user felületei.

- Login
- Onboarding
- Chat (Chatbox, Chatflow, References, dokumentumpanel)
- Bal panel (Ügynökök, Mappák, Beszélgetések, Keresés, Inbox, Új beszélgetés, visszajelzés és info)
- Fiók (felhasználói beállítások: Profil, Preferenciák, Értesítések, Saját használat, Első lépések)

**Hivatkozásként, nem teljes felületként:** azok a konfigurációs források (admin-oldali Beállítások: Képességek, Egyéb), amelyek a Workspace viselkedését vezérlik (lásd 11. fejezet). Az admin UI maga külön specifikáció tárgya.

**Hatókörön kívül (out of scope), Függelék A:** Admin rendszer teljes felülete, Tudásbázis/dokumentumtár böngésző, Workflows és Builder (Folyamatok), Agentek létrehozása/kezelése, mentett Promptok, Projektek. Ezeket a roadmap az Admin rendszerbe vagy későbbi fázisba (Basics, Coming) sorolja.

### 1.3 Célközönség

Frontend és UX fejlesztők, terméktulajdonos, QA. A dokumentum feltételezi a React + komponensalapú gondolkodást, de framework-független.

### 1.4 Kapcsolódó források

- **Roadmap (single source of truth):** `Kavosz AI Roadmap` Google Sheet. A Workspace taxonómiája (Rendszer › Modul › Elem › Feature) ezen alapul.
- **Jelenlegi kód:** `kavosz-ai-site/index.html` (bundled React + Babel prototípus, 16 modul).
- **Külső ajánlat:** „KAVOSZ AI Platform: Ajánlat" (Notion), ügyfél-oldali dokumentum. Nem keverendő ezzel a belső speccel.

### 1.5 Olvasási útmutató (hogyan épül fel)

A dokumentum egyszer definiál minden ismétlődő mintát, utána névvel hivatkozik rá. A felépítés alulról felfelé:

1. **Fogalomtár** (2): a használt szakkifejezések.
2. **Designrendszer és globális minták** (3): színek, tipográfia, interakciós állapotok, megosztott komponensek, popup- és box-minták, globális viselkedés. Minden későbbi fejezet ezekre hivatkozik.
3. **Globális elrendezés** (4): az alkalmazás vázszerkezete.
4. **Belépési folyamatok** (5–6): Login, Onboarding.
5. **Workspace felület** (7–9): Bal panel, Chatbox, Chatflow.
6. **Felhasználói beállítások** (10) és **konfigurációs források** (11).
7. **Függelékek** (12–14): halasztott funkciók, eltérések a kódtól, nyitott kérdések.

> **Konvenció:** ha egy viselkedés már definiálva van egy korábbi fejezetben, itt csak hivatkozunk rá („lásd 3.5"), nem ismételjük.

---

## 2. Fogalomtár

| Fogalom | Jelentés |
|---|---|
| **Workspace** | Az end-user munkaterület rendszer. Ennek a specifikációnak a tárgya. |
| **Admin** | Adminisztrátori konfigurációs rendszer. Külön spec; itt csak hivatkozás. |
| **Bal panel** | A bal oldali, fix navigációs sáv (left rail / sidebar). |
| **Chatbox** | A promptbeviteli mező (composer) az összes vezérlőjével. |
| **Chatflow** | Egy beszélgetés folyama: az elküldött inputok és a generált outputok sorozata. |
| **Output** | Az AI által generált válasz (text, táblázat, fájl). |
| **Ügynök (Agent)** | Admin által csoporthoz vagy userhez rendelt, specializált asszisztens. A user kiválasztja, nem szerkeszti. Az MVP-ben a Képességek „kivetülése" a Workspace-re (lásd 11.1). |
| **Skill** | Specializált képesség (dokumentum-sablon, fordítás, képgenerálás), amit a modell a chatben használ. Admin-oldalon kezelt; az MVP-ben nem külön chat-vezérlő (lásd Függelék C). |
| **RAG** | Belső tudásbázis-index, amelyből az AI hivatkozott forrásokat húz. |
| **DLP** | Data Loss Prevention. A banktitok-kategória proaktív, küldés előtti kezelése (lásd 8.9). |
| **Banktitok** | Banktitok adatkategória. Felhőmodellbe soha nem kerülhet; csak on-prem modell dolgozhatja fel. |
| **SSO** | Single Sign-On. A belépés Microsoft Entra ID-val történik. |
| **RBAC** | Csoportalapú jogosultságkezelés (role/group based access control). |
| **Chip** | Kis, lekerekített, eltávolítható címke a Chatboxban (pl. aktív ügynök, webes keresés). |
| **Box** | Lebegő lista, ami hover, jobbklikk vagy 3-pont kattintásra nyílik (popover / context menu). |
| **Glow** | Zöld, animált fénykeret egy elem körül, ami fókuszt vagy folyamatot jelez (loading, onboarding-túra). |
| **Streaming** | Az output fokozatos, karakterenkénti/blokkonkénti megjelenése generálás közben. |

## 3. Designrendszer és globális minták

Ez a fejezet egyszer definiálja a teljes vizuális és interakciós nyelvet. Minden későbbi fejezet erre hivatkozik. A jelenlegi kód design-tokenjei (Tailwind v4 `@theme` + CSS változók) kanonikusak; az alábbi értékek ezeket rögzítik.

### 3.1 Színek

A márkaszín egy **brand teal** (kékeszöld). A draft „zöld" megnevezései erre a skálára képződnek le. A világos téma a kanonikus; sötét téma a Preferenciákban kapcsolható (lásd 10.2).

**Brand teal**

| Token | Hex | Használat |
|---|---|---|
| `brand-800` | `#004D45` | brand-700 gomb hover/lenyomott (pressed) állapot; Login panel radiális mélység |
| `brand-700` | `#006159` | **Elsődleges márkaszín:** CTA, küldés, aktív ikon, aktív border, bal akcentcsík. A draft „sötétzöld"-je. |
| `brand-100` | `#D6EEF1` | színes elem (chip) hover (lásd 3.5) |
| `brand-50` | `#EBF5F7` | kiválasztott elem háttere, tint. A draft „világoszöld"-je. |

> **4 funkcionális zöldre szűkítve.** A `brand-600` és `brand-500` középteal redundáns volt; a `brand-900`-at is elhagytuk, mert a Login bal panel mostantól `brand-700` (lásd 5.1).

**Ink (neutrális)**

| Token | Hex | Használat |
|---|---|---|
| `ink-900` | `#0C2540` | elsődleges szövegszín (a draft „fekete"-je) |
| `ink-700` | `#2E3A4C` | nav-sor felirat (alap) |
| `ink-500` | `#5B6470` | másodlagos szöveg, caption, hint, eyebrow |
| `ink-300` | `#9AA2AD` | placeholder, letiltott szöveg |
| `ink-200` | `#D6DAE0` | letiltott kitöltés |
| `ink-100` | `#ECEEEA` | hajszálvonal-border, aktív-nav kitöltés (a draft „sötétebb szürke" vonalszíne) |
| `ink-50` | `#F7F7F8` | oldalháttér (krém off-white) (a draft „világos alap"-ja) |

> **7 fokra szűkítve.** Az `ink-400` beolvadt az `ink-500`-ba (közel azonos középszürke voltak). A többi szürkének külön, valós szerepe van (szöveg-hierarchia, border, háttér).

**Gold (upsell), Danger**

| Token | Hex | Használat |
|---|---|---|
| `gold-500` | `#E5A124` | „Kötelező" jelölés, prémium akcent |
| `gold-100` | `#FDE9C0` | gold háttér-tint |
| `danger-500` | `#D14B3B` | hiba, törlés, destruktív művelet |

**Szemantikus tokenek:** `bg-page` = ink-50; `bg-card` = `#FFFFFF`; `bg-hover` = ink-50; `bg-active` = ink-100; `bg-modal-dim` = `rgba(12,37,64,0.4)` (ink-900 @ 40%); `border-hairline` = ink-100; `fg-default` = ink-900; `fg-secondary` = ink-500; `fg-muted` = ink-500; `fg-placeholder` = ink-300; `fg-on-brand` = `#FFFFFF`; `fg-link` = brand-700.

**Igazítás a draft színmegnevezéseihez**

| Draft megnevezés | Token | Hex | Funkció |
|---|---|---|---|
| Basic background (light) | `ink-50` | `#F7F7F8` | oldalháttér; a felületek/kártyák fehérek (`#FFFFFF`) |
| hover: light grey | `ink-50` | `#F7F7F8` | sima (fehér) elem hover háttere |
| hover: light green | `brand-100` | `#D6EEF1` | színes (zöld) elem hover |
| click: light green | `brand-50` | `#EBF5F7` | sima elem kiválasztott/aktív háttere; avatar-tint |
| Button color / chart color (darker green) | `brand-700` | `#006159` | CTA, küldés, aktív ikon, chart, aktív border, **Login bal panel** |
| Push color (pressed) | `brand-800` | `#004D45` | gomb lenyomott / hover-fill; Login radiális mélység |
| Border color (active, darker green) | `brand-700` | `#006159` | kiválasztott/aktív border, 3px akcentcsík |
| Borders and lines (darker grey) | `ink-100` | `#ECEEEA` | hajszálvonal-border, elválasztó vonalak |
| (erősebb szürke kitöltés) | `ink-200` | `#D6DAE0` | letiltott (disabled) kitöltés |
| Text color / click color (black) | `ink-900` | `#0C2540` | elsődleges szöveg; a kijelölt elem szövege is |
| (nav szöveg) | `ink-700` | `#2E3A4C` | nav- és listasor-felirat |
| (másodlagos szöveg) | `ink-500` | `#5B6470` | másodlagos szöveg, caption, eyebrow |
| (placeholder) | `ink-300` | `#9AA2AD` | placeholder, letiltott szöveg |

A draftban nem szerepelt, de a rendszer használja: `gold-500` (`#E5A124`, „Kötelező"/upsell akcent), `gold-100` (`#FDE9C0`, tint), `danger-500` (`#D14B3B`, hiba/törlés/destruktív).

### 3.2 Tipográfia

- **Sans (alap):** Manrope (400, 500, 600, 700, 800). Fallback: ui-sans-serif, system-ui.
- **Mono (számok, badge, kód):** IBM Plex Mono. `font-feature-settings: "tnum"` a számoknál.

**Méretskála**

| Token | px | Használat |
|---|---|---|
| eyebrow | 11 | uppercase, `letter-spacing 0.06em`, ink-500 |
| caption | 11 | metaadat |
| meta | 12 | táblázat-másodlagos, chip-szöveg |
| small | 12.5 | kis törzsszöveg |
| body | 13 | nav, listasor, chip |
| base | 14 | alap törzsszöveg |
| input | 15 | composer textarea |
| h3 | 15 | medium súly |
| h2 | 16 | semibold |
| h1 | 24 | oldalcím, semibold, `letter-spacing -0.01em` |
| display | 28 | chat-kezdőoldal köszöntés |

**Súlyok:** regular 400, medium 500, semibold 600, bold 700. **Sortávok:** tight 1.15, snug 1.3, base 1.5, relaxed 1.65.

### 3.3 Térköz, rádiusz, árnyék

- **Térköz (4px alap):** 4, 8, 12, 16, 20, 24, 32, 40, 48, 64.
- **Rádiuszok:** sm 4; md 6 (input, nav-sor, kis gomb); lg 8 (kártya, listakonténer); xl 12 (modal-kártya); 2xl 16 (composer); pill 999 (chip, pill, avatar, toggle, státuszpont). **A popupok és boxok rádiusza azonos (lg vagy xl), borderük azonos (1px ink-100), lásd 3.7.**
- **Árnyékok:** sm `0 1px 2px rgba(12,37,64,.04)` (alap kártya); md `0 4px 12px rgba(12,37,64,.08)` (popover, box); lg `0 10px 32px rgba(12,37,64,.12)` (modal).
- **Layout konstansok:** bal panel szélesség 260px; topbar magasság 48px; tartalom max-szélesség: keskeny 720px, alap 820px, széles 1024px.

### 3.4 Mozgás (motion)

- **Időtartamok:** fast 0.12s; base 0.15s (fade-in, hover, értesítés); slow 0.25s.
- **Easing:** `cubic-bezier(0.2, 0.7, 0.2, 1)` (ease-out).
- **fadeIn:** opacity 0→1 + translateY 4px→0. **Értesítés beúszás:** pozitív/semleges felül-középről lefelé; negatív a jobb szélről befelé, a jobb felső sarokban gyűlve (lásd 3.8).
- **Streaming kurzor:** villogó `▎` (1s lépcsős), brand-700 szín, a generált blokk végén.

### 3.5 Interakciós állapotok (alapszabály)

Ez a legfontosabb globális szabály. Minden kattintható elem ezt követi, hacsak külön nincs jelezve.

**A. Sima (plain) elem**: fehér vagy semleges háttér (nav-sor, listasor, box-tétel, kártya):

- **Default:** átlátszó vagy fehér háttér, ink-700/ink-900 szöveg.
- **Hover:** háttér → **világosszürke** (`ink-50`). Kártyánál a border → brand-700.
- **Kattintott / kiválasztott (active):** háttér → **világoszöld** (`brand-50`), **szöveg → `ink-900`** (nem zöld), **ikon és 3px bal oldali akcentcsík → `brand-700`**, súly medium.
- **Szabály (nincs zöld-a-zöldön):** `brand-50`/`brand-100` tinten a szöveg mindig `ink`; a zöldet csak ikon, border vagy akcentcsík viszi. Telt `brand-700` háttéren a szöveg fehér.

**B. Színes (colored) elem**: eleve zöld kitöltésű vagy zöld keretű (CTA gomb, chip, aktív állapot):

- **Hover:** → **világoszöld** (`brand-100`), illetve kitöltött gombnál sötétebb fill (`brand-800`).
- **Kattintott:** → **sötétebb zöld border** (`brand-700`) jelzi a megerősített/aktív állapotot.

**Egyéb állapotok:**

- **Disabled:** kitöltés ink-200, szöveg ink-300, `cursor: not-allowed`, nincs hover-reakció.
- **Focus (billentyűzet):** brand-700 border vagy 2px brand-50 ring.
- **Loading / folyamat:** lásd **Glow-minta** (3.8).

### 3.6 Megosztott komponensek

Ezek a primitívek a teljes Workspace-ben újrahasznosulnak. Itt definiáljuk őket egyszer.

- **Button.** Variánsok: `primary` (brand-700 kitöltés, fehér szöveg, hover brand-800), `secondary` (fehér, ink-100 border, hover ink-50), `ghost` (csak szöveg/ikon), `danger` (danger-500). Méretek: sm, md. Rádiusz md. Ikon + szöveg gap 8px.
- **Pill / Chip.** Lekerekített (pill) címke. Tónusok: neutral (ink), brand (zöld), gold, danger. Méret sm/md. A **Chip** eltávolítható változat: hoverre jobb oldalt `×` jelenik meg (lásd 8.5, 8.6). **Aktív chip:** `brand-50` háttér, `ink-900` szöveg, `brand-700` ikon és border (3.5 elv, nincs zöld-a-zöldön).
- **Card.** Fehér háttér, ink-100 border, rádiusz lg, árnyék sm. `interactive` változat: hoverre border → brand-700.
- **Toggle.** Pill kapcsoló. Be: brand-700. Ki: ink-200. Disabled: ink-100.
- **Avatar.** Pill alak, monogram vagy kép. Tónus brand/ink/gold.
- **Tabs.** Aláhúzott vagy pill-szegmens; aktív tab brand-700. Opcionális számláló a felirat mellett.
- **StatTile.** Mono szám + felirat + opcionális delta (pozitív/negatív tónus).
- **Skeleton.** Töltődő placeholder sáv (ink-100), pulzáló.
- **Értesítés (notification).** Lásd 3.8.
- **Modal és ConfirmDialog.** Lásd 3.7.

### 3.7 Popup, modal és box minták

**Modal (popup).** Középre igazított kártya, mögötte elhalványított háttér (`bg-modal-dim`, ink-900 @ 40%, blur). Rádiusz xl, árnyék lg. Tartalom: cím, opcionális leírás, törzs, lábléc gombokkal. **Minden popup azonos rádiuszú és borderű.** Bezárás: háttérre kattintás, `×`, vagy `Escape`. Kötelező (blocking) popupnál a háttérre kattintás és az `Escape` nem zár (lásd Onboarding 6, Policy).

- **ConfirmDialog:** kétgombos megerősítő popup. Bal alsó: másodlagos/„Mégse"; jobb alsó: elsődleges/megerősítés. Destruktív műveletnél a megerősítő gomb danger tónusú. **Gombpozíció-konvenció az egész appban: bal alsó = elvető/másodlagos, jobb alsó = megerősítő/elsődleges.**

**Box (popover / context menu).** Lebegő lista, ami **kattintásra** nyílik: bal klikk a nyitóelemen (+ gomb, hivatkozás-gomb, Workspace-logó), 3-pont kattintás, vagy jobbklikk a rekordon. **Hover nem nyit boxot**; a hover csak affordanciát mutat (pl. a 3-pont vagy a chip × megjelenése). Fehér, ink-100 border, rádiusz lg, árnyék md. A nyitó elem a box sarka mögött helyezkedik el.

Két box-tétel típus:

- **Single tétel:** önálló akció (pl. „Fájl csatolása", „Webes keresés", „Mappa törlése", „Beszélgetés átnevezése").
- **Group tétel:** több rekordot listázó csoport (pl. a beszélgetések listája „Mappához adás"-kor, a mappák listája egy beszélgetés-rekordból, vagy a források a Reference-boxban).

**Box-szabályok (kötelező):**

1. **Nincs egymásba érő box.** Egy box nem nyit újabb boxot maga mellett.
2. **Magas group → görgethető box.** Ha egy group sok rekord miatt magas, az **egész box görgethetővé válik** (csak a group-rész görgethető), nem nyílik új box mellé.
3. **Pozíció:** a box a kiváltó elemhez tapad; ha nem fér ki a képernyőn, befelé igazodik, és legfeljebb a boxon belül jelenik meg egy görgetés.

### 3.8 Globális viselkedési minták

- **Glow-minta (loading / fókusz).** Animált zöld (brand-700) fénykeret az elem körül. Két használat: (1) **küldés/feldolgozás** közben a gomb vagy elem körül pulzál (lásd 8.9); (2) **onboarding interaktív túra** közben a soron következő, interakcióra váró elem körül kering (lásd 6).
- **Copy-visszajelzés (egységes).** Másoláskor: az érintett elem 1 pillanatra kicsit nagyobb lesz, a „Másolás" gomb bold-abbá válik, és (input-buboréknál) a border egy árnyalattal sötétebb, amíg a copy gomb meg nem nyomódik. Lásd 9.1, 9.3.
- **Drag-and-drop (egységes).** Megfogásra a rekord „kiemelkedik" (enyhe árnyék + emelés). Érvényes drop-célnál a cél kiemelődik. Vizuális segéd: világoszöld nyíl jelzi a mozgatás irányát, ahol releváns (lásd 6/7. lépés, 7.6, 7.7). Drop után az elem az új helyre kerül.
- **Értesítések / notifications (két csatorna).** **Pozitív és semleges** üzenetek (pl. „Gemini 2.5 Pro kiválasztva", „Másolva", „Mappa létrehozva", kész-válasz jelzés) **felül-középen**, pill/chip formában, auto-eltűnéssel. **Negatív** üzenetek (hiba, figyelmeztetés, banktitok-blokk kísérője) a **jobb felső** sarokban, **sárga/gold** (`gold-100` háttér, `ink-900` szöveg, `gold-500` szegély), **egymásra torlódva**, `×`-szel elvethetők, a kézi elvetésig maradnak.
- **Gyorsbillentyűk.** `⌘/Ctrl + K`: Keresés (lásd 7.4). `⌘/Ctrl + \`: bal panel ki/be (megjegyzés: a draft szerint a bal panel nem rejthető, lásd 7 és Függelék C). `⌘/Ctrl + Shift + O`: új beszélgetés. `Enter`: küldés; `Shift + Enter`: új sor (a Preferenciákban átállítható, lásd 10.2). `Escape`: nyitott box/modal zárása, illetve onboarding interaktív lépés megszakítása (lásd 6).
- **Üres, töltődő, hiba állapotok.** Minden listának és nézetnek van: **empty state** (rövid magyarázó szöveg + elsődleges akció), **loading state** (Skeleton vagy Glow), **error state**. A futásidejű hibák a **jobb felső sárga értesítés-stackben** jelennek meg (lásd fentebb), nem inline sávként. A destruktív megerősítések (törlés) maradnak `danger` pirosak.
- **Akadálymentesség.** Cél: **WCAG 2.1 AA**. Teljes billentyűzetes navigáció, látható fókusz, ARIA a boxokon és modálokon, fókuszcsapda modálban és az onboarding-túra alatt. A `gold` sosem szövegszín fehéren (a „Kötelező" pill `ink-900` szöveg `gold-100` háttéren). Kontraszt-ellenőrzés a brand-700 felületeken (fehér szöveg).

## 4. Globális elrendezés (App shell)

A bejelentkezett Workspace három fő régióra oszlik.

1. **Bal panel** (fix, 260px). Mindig látszik. **Nem mozgatható és nem rejthető el** (lásd 7). A navigáció és a beszélgetéslista helye.
2. **Fő tartalom** (rugalmas szélesség). A kontextustól függően: Chat-kezdőoldal (8), Chatflow (9), Inbox (7.5), Fiók (10). A tartalom vízszintesen középre igazul a 3.3 max-szélesség konstansokkal.
3. **Jobb oldali dokumentumpanel** (opcionális, csak fájl megnyitásakor). A Chatflow és a panel között mozgatható elválasztó (lásd 9.5).

**Platform:** desktop-first webalkalmazás. A primer célfelbontás asztali böngésző. (Reszponzív/mobil viselkedés: lásd Függelék C, nyitott kérdés.)

**Perzisztencia:** a kiválasztott nézet, a beszélgetések, a mappák és a felhasználói preferenciák megmaradnak munkamenetek között. **Megőrzés (retention):** a beszélgetések a felhasználó **törléséig** megmaradnak; az Inbox-értesítések megőrzési ideje admin/policy-kérdés. A végleges tárolás backend-kérdés (a demó localStorage-t használ).

---

## 5. Login

A belépés egyetlen lépés: **Microsoft Entra ID SSO**. A jogosultságok csoportalapúak (RBAC); a csoporttagság határozza meg az elérhető modelleket, ügynököket és képességeket.

### 5.1 Elrendezés

Két oszlop, teljes képernyőmagasság.

**Bal panel (márka, brand-700 háttér).**

- A panel **szélessége akkora, hogy a „Kavosz AI portál" felirat egy sorban elférjen.** A felirat nem törhet két sorba.
- **Logó:** nagy méretű, vízszintesen **középre** igazítva, a felirat **fölött**. A logó + felirat együtt a panel függőleges közepén, csoportként centrálva.
- **Cím:** „Kavosz AI portál", a logó alatt, semibold, világos (fehér) szöveg, brand-700 háttéren.
- **Lábléc:** „© 2026 KAVOSZ Zrt. Minden jog fenntartva." apró, halvány (brand-100 @ 60%) szöveg, a panel alján.
- Finom dekoráció: enyhe radiális `brand-800` fény (sötétebb mélység) a brand-700 háttéren, kb. 15% opacitás.

**Jobb panel (belépő).**

- Háttér **nem teljesen fehér**: világos, enyhén **fémes** hatás (pl. nagyon halvány, ferde lineáris gradient ink-50 és fehér között, vagy finom textúra). Világos marad, kontraszt a bal panel mély zöldjével.
- A belépő blokk **vízszintesen és függőlegesen középre** igazítva. Mivel a panel nagy és üres, a blokk **valamivel nagyobb**, mint egy szokásos login-kártya.
- Tartalom (középre igazítva, fentről lefelé):
  1. **Cím:** „Bejelentkezés" (h1, nagyobb méret).
  2. **Alcím:** „Egyetlen kattintás a céges fiókoddal." (ink-500).
  3. **SSO gomb:** teljes szélességű, brand-700 kitöltés, fehér szöveg, Microsoft-logó ikon + „Folytatás Microsoft Entra ID-val". Nagyobb függőleges padding. Hover: brand-800 (3.5 B).

### 5.2 Viselkedés

- A gomb megnyomása elindítja az Entra ID SSO-folyamatot. Sikeres belépés után:
  - **Első belépés:** Onboarding (6).
  - **Visszatérő, befejezett onboarding:** Chat-kezdőoldal (8).
  - **Visszatérő, befejezetlen onboarding:** Chat-kezdőoldal, a bal panelen aktív onboarding-folytatás belépővel (6.4) és AI-policy popuppal, ha még nem fogadta el.
- **Hiba állapot:** sikertelen SSO esetén danger tónusú üzenet a gomb alatt, újrapróbálás lehetőségével.

### 5.3 Munkamenet és lejárat

- Az Entra ID **token lejártakor** a rendszer **újra-hitelesítést** kér: nem-destruktív modal („A munkamenet lejárt, jelentkezz be újra"), vagy átirányítás a Loginra.
- A **be nem küldött input, a megnyitott nézet és a folyamatban lévő munka megőrződik**; sikeres újra-belépés után a felhasználó **ugyanoda tér vissza**.
- Háttérben futó generálás a token lejártakor megszakadhat; újra-belépés után a beszélgetés a Beszélgetésekből folytatható.

---

## 6. Onboarding

Az onboarding az **első belépés után** indul, egyszer. Célja: a kötelező megfelelőségi lépések teljesítése és a Workspace alapműveleteinek vezetett bemutatása. Kilenc lépésből áll. Az 1–4. lépés **középre igazított popup**; az 5–8. lépés **interaktív, in-app vezetett túra** (Glow-minta, 3.8); a 9. lépés **befejező popup** konfettivel.

### 6.1 Közös popup-minta (1–4. lépés)

- Középre igazított popup, mögötte **elhalványított, blurolt háttér** (3.7). A popup mérete lépésenként állandó marad (a videó nem nagyítható teljes képernyőre, lásd 6.2/2).
- **Lábléc gombok:**
  - **Bal alsó: „Kihagyom"** csak akkor jelenik meg, ha a lépés **nem kötelező**.
  - **Jobb alsó: „Tovább"** (a 4. lépésnél „Kezdés"). Akkor aktiválódik, amint a lépés feltétele teljesül (pl. policy elfogadva, videó megnézve, vagy a nem kötelező mezők kitölthetők/üresen hagyhatók).
- **Haladásjelző:** a popup tetején (és a túra coach-markján) lépés-indikátor (pl. „2 / 9").
- **Teljes kihagyás (teszt-fázis):** a lépés-indikátor mellett, a **jobb felső sarokban** végig elérhető a **„Onboarding kihagyása"** link. Ez **az egész onboardingot kihagyja** és belép az appba, **bármely lépésből** (a popupokról és a vezetett túráról egyaránt), beleértve az egyébként kötelező szabályzat- és videólépést is (6.2). Ez különbözik a bal alsó **„Kihagyom"**-tól, amely csak az **adott, nem kötelező lépést** ugorja át. A teljes kihagyás befejezetlen onboardingként követődik (6.4).
- Minden befejezett lépés automatikusan kipipálja a hozzá tartozó **Első lépések** checklist-tételt (10.5) és frissíti az onboarding-állapotot.

### 6.2 Lépések

**1. lépés: AI-szabályzat elfogadása (Kötelező).**

- Tartalom: rövid magyarázat + a teljes AI-szabályzat (AI policy) megnyitható dokumentumként, és egy **checkbox**: „Elolvastam és elfogadom a KAVOSZ AI használati szabályzatát."
- **Kötelező a fájl megnyitása:** a checkbox és a „Tovább" csak azután aktiválódik, hogy a felhasználó **megnyitotta** a szabályzat-fájlt.
- A checkbox bepipálása **logolódik** (idő, felhasználó) az Admin → Biztonság alá (11, hivatkozás).
- Nincs „Kihagyom". A szabályzat tartalma és verziója az Admin → AI-policy beállításból jön (módosítható).

**2. lépés: Használati videó (Kötelező).**

- Tartalom: rövid bemutató videó a Workspace használatáról, a popupban lejátszva.
- **Nem nagyítható teljes képernyőre; a popup mérete változatlan.**
- **Kötelező végignézni (éles rendszer):** a „Tovább" csak a videó végén aktiválódik, nincs „Kihagyom".
- **Prototípus-kivétel:** a demó HTML-ben **„Átugrás" gomb** van, hogy a bemutatónál ne kelljen végignézni. Éles build-ben ez kikapcsolt (a teljes videó megtekintése kötelező).

**3. lépés: Megszólítás (becenév) (nem kötelező).**

- Tartalom: szövegmező, „Hogyan szólítson meg a KAVOSZ AI?".
- Ha üresen marad, **az Entra ID belépésből húzott keresztnév** lesz az alapérték.
- „Kihagyom" elérhető. A megszólítás a Fiók → Profilba kerül (10.1), és a chat-köszöntésben jelenik meg (8.2).

**4. lépés: Bevezető + Kezdés (nem kötelező).**

- Tartalom: névre szóló üzenet (a 3. lépés megszólításával), pl. „Köszönjük, {megszólítás}! Nézzük meg, hogyan működik a munkaterület." 
- Jobb alsó gomb: **„Kezdés"** (a „Tovább" helyett). Megnyomása indítja az interaktív túrát (6.3). „Kihagyom" elérhető.

### 6.3 Interaktív vezetett túra (5–9. lépés)

**Túra-szabályok (közös):**

- A háttér **enyhén elhalványul** (halvány overlay), a soron következő, interakcióra váró elem körül **zöld Glow** kering (3.8).
- A túra **megkezdése után nem hagyható el**, kizárólag a billentyűzet **`Escape`** gombjával.
- A **következő elem csak akkor kezd világítani**, ha az aktuális lépés művelete megtörtént.
- Minden lépés a valós Workspace-elemen történik (nem szimulált), így a felhasználó éles műveletet végez.

**5. lépés: Első üzenet küldése.**

1. A **Chatbox** körül megjelenik a glow. A felhasználó **ír valamit** a beviteli mezőbe.
2. Ezután a **+ gomb** kezd világítani. A felhasználó megnyomja, és **hozzáad valamit**: fájlt, képet vagy webes keresést (8.4).
3. Ezzel a **küldés gomb** aktívvá válik és **zöldre vált** (brand-700). A felhasználó megnyomja.
4. Az üzenet elküldődik, a nézet Chatflow-ra vált (9).

**6. lépés: A válasz generálása.**

- A küldés után a nézet Chatflow-ra vált, és a spotlight a **válasz (output) területére** kerül. A felhasználó **végignézi, ahogy az AI legenerálja a választ** (streaming, 9.2).
- A túra **csak akkor lép tovább, amikor a generálás befejeződött** (`kv-generation-done` esemény). A mappa-lépés tehát **soha nem jelenik meg üres kezdőoldalon**, csak valós, lefutott chat után. Biztonsági időkorlát: ha a generálás kivételesen nem fejeződik be, a túra rövid várakozás után automatikusan továbblép.

**7. lépés: Mappa létrehozása.**

- A **Mappák melletti + gomb** (7.7) kezd világítani.
- A felhasználó létrehoz egy mappát, **elnevezi**, az hozzáadódik a panelhez.

**8. lépés: Beszélgetés mappába rendezése.**

- A **Beszélgetések** lista (7.8) kezd világítani.
- A felhasználó **felhúz egy beszélgetést és a mappára ejti**. A mozgatás irányát **világoszöld, mozgó nyíl** jelzi (felfelé húzás).

**9. lépés: Új beszélgetés.**

- Az **„Új beszélgetés"** elem (7.3) kezd világítani. Megnyomásra **új, üres Chatbox** (kezdőoldal) jelenik meg.

### 6.4 Befejezés és követés

**10. lépés: Befejezés.**

- Az onboarding kész. **Felülről lehulló konfetti** (a jelenlegi kódban `kvConfetti` animáció) és középen egy **gratuláló popup** (pl. „Készen vagy! Jó munkát a KAVOSZ AI-jal."). A popup bezárása után a felhasználó a Chat-kezdőoldalon van.
- Az onboarding **sikeres befejezésekor a chat-felületen is teljes képernyős konfetti pereg** (ugyanaz a `ConfettiBurst`, mint a Fiók → Első lépések checklist teljesítésekor, 10.5), ha a felhasználó éppen a chat-nézetben van.

**Kihagyás és követés (az egész onboarding-ra):**

- Ha **bármely lépés kimarad** (Kihagyom vagy a túra `Escape`-pel megszakad), az **követődik**: az onboarding befejezetlennek számít.
- **Befejezetlen onboarding → folytatás-belépő a bal panel alján**, közvetlenül a visszajelzés- és info-gomb **fölött** (7.9). Megjelenése: **sötétebb zöld, fémes hatású box**. Kattintásra az onboarding **ott folytatódik, ahol abbamaradt**.
- Ugyanez tételként megjelenik a **Fiók → Első lépések** alatt (10.5).
- Ahogy az egyes tételek teljesülnek, **eltűnnek** a Fiók-listából és a panel-belépőből is. Minden tétel kész → a folytatás-belépő és az Első lépések tétel teljesen eltűnik.

## 7. Bal panel

A bal panel a Workspace fix navigációs kerete. Mindig látszik, **nem mozgatható és nem rejthető el**. Minden rekord a 3.5 A szabályt követi: **hover → világosszürke (ink-50); kattintás/kiválasztott → világoszöld (brand-50)**, az aktív elem szövege `ink-900`, ikonja és bal akcentcsíkja `brand-700` (3.5).

### 7.1 Áttekintés és sorrend

Fentről lefelé:

1. Kavosz logó + Workspace menü (7.2)
2. Új beszélgetés (7.3)
3. Keresés (7.4)
4. Inbox (7.5)
5. Ügynökök (7.6)
6. Mappák (7.7)
7. Beszélgetések (7.8), az egyetlen önállóan görgethető szakasz
8. (elválasztó vonal)
9. Panel alja: onboarding-folytatás (ha van), visszajelzés, info (7.9)

### 7.2 Kavosz logó és Workspace menü

- A panel tetején, balról jobbra: **Kavosz logó**, **„Kavosz AI"** felirat, **lenyíló nyíl** (a Workspace menühöz), és a **jobb szélen egy Fiók/user ikon**. A user ikonra kattintva a **Fiók → Profil** nyílik (10.1).
- A logó/felirat/nyíl részre **kattintva** **box** nyílik (Box-minta, 3.7, kattintás), a következő belépőkkel:
  - **Fiók** (a felhasználó profilja, 10.1), **Adminisztráció** (admin felület), **Kimutatások** (használati statisztikák), **Képességek** (connectorok, RAG, skillek), **Egyéb** (további preferenciák).
  - „Kijelentkezés" (single tétel; ConfirmDialog megerősítéssel, 3.7).
  - (Admin felhasználóknál admin belépők is megjelenhetnek; az admin felület hatókörön kívül, lásd Függelék A.)
- A box tételei a 3.5 A szabályt követik. A box hoverrel **nem nyit újabb boxot** (3.7/1).

### 7.3 Új beszélgetés

- Ikon (compose) + felirat „Új beszélgetés".
- **Kattintásra** új, üres Chatbox jelenik meg (Chat-kezdőoldal, 8). Ha éppen Chatflow-ban vagyunk, visszavált kezdőoldalra.
- Gyorsbillentyű: `⌘/Ctrl + Shift + O` (3.8).

### 7.4 Keresés

- Ikon (nagyító) + felirat „Keresés". Megnyitható kattintással vagy `⌘/Ctrl + K` (3.8).
- **Hatókör: kizárólag a beszélgetés-előzmény.** A keresés szó alapján illeszt a **beszélgetés nevére** és a **beszélgetés tartalmára**.
- **Eredmény:** a találatok a **beszélgetések neveit** listázzák. Élő (gépelés közbeni) szűrés.
- A találatban az **egyező szó kiemelve**. Egy eredményre kattintva az adott beszélgetés megnyílik (9), és a nézet **a találathoz görget**.
- **Empty/no-results state:** „Nincs találat erre: «{kifejezés}»." Üres mezőnél nincs lista, vagy a legutóbbi beszélgetések jelennek meg.

### 7.5 Inbox

- Ikon (inbox) + felirat „Inbox". Jobb oldalt **olvasatlan-számláló** badge (pl. „3").
- Tartalom: a korábbi **értesítések** listája, amelyek az **output-elkészülésekről** szólnak. Minden rekord a hozzá tartozó **beszélgetés nevét** mutatja, olvasatlan jelzéssel (kis brand-700 pötty).
- **Tab-ek:** „Olvasatlan" / „Összes" (3.6 Tabs).
- **„Mind olvasva"** akció a fejlécben: minden értesítést olvasottá tesz.
- **Kattintás egy rekordra:** elhagyja az Inboxot, **megnyitja a beszélgetést és az adott outputhoz görget** (9). A beszélgetés a **Beszélgetésekben** is kijelölődik. A rekord olvasottá válik.
- **Empty state:** „Nincs új értesítés."

### 7.6 Ügynökök

- Szakasz a panelen, ami ugyanazokat az **ügynököket listázza, mint a Chatbox + menüje** (8.4). Az **általános képességek** (webes keresés, modellválasztás) **nem** jelennek meg itt, csak az ügynökök (RAG/specializált asszisztensek).
- **Egy ügynökre kattintva** az hozzáadódik az aktuális Chatboxhoz **chipként** (ugyanaz a viselkedés, mint a + menüből, 8.5). Ha nincs nyitott Chatbox, új kezdőoldal nyílik és oda kerül a chip.
- Az ügynököket **admin rendeli** csoporthoz vagy userhez. A felhasználó **nem szerkeszti, nem nevezi át, nem törli** őket. A definíció és hozzárendelés forrása: Admin → Képességek (11.1).
- **Empty state:** ha a felhasználóhoz nincs ügynök rendelve, a szakasz nem jelenik meg, vagy halvány „Nincs elérhető ügynök" felirat.

### 7.7 Mappák

A mappák a beszélgetések csoportosítására szolgálnak. A „Mappák" felirat mellett jobbra egy **+ gomb**.

**Új mappa (+ gomb):**

- A + gomb megnyomására **popup** nyílik a mappa elnevezésére (szövegmező). Gombok: **bal „Mégse", jobb „Létrehozás"** (3.7 gombpozíció).
- Létrehozás után a mappa megjelenik a listában (alapból üresen, összecsukva).

**Mappa-rekord:**

- A mappa **kinyitható/összecsukható**; kinyitva a benne lévő beszélgetéseket mutatja.
- **Összecsukott mappa jelzése:** ha a mappában lévő egyik beszélgetés épp **generál** (animált pötty) vagy **olvasatlan/kész**, a becsukott mappán is megjelenik a megfelelő **pötty** (a 7.8 állapot tükrözése).
- A mappa **drop-cél**: beszélgetés ráhúzható (7.8).
- **Hover** a mappanéven → jobb oldalt **3 pont** ikon jelenik meg.
- **3 pontra kattintás vagy jobbklikk** → **box** nyílik (Box-minta, 3.7) a következő tételekkel:
  - **„Beszélgetés hozzáadása"** (group tétel): a **legutóbbitól a legrégebbiig** listázza a beszélgetéseket, **kihagyva azokat, amelyek már mappában vannak**. Ha hosszú, az egész box görgethető (3.7/2). Egy beszélgetésre kattintva az a mappába kerül.
  - **„Átnevezés"** (single): a mappanév **helyben szerkeszthető** a panel-rekordban (inline edit).
  - **„Törlés"** (single, destruktív): **ConfirmDialog** („Biztosan törlöd ezt a mappát?"). A mappában lévő beszélgetések nem törlődnek, csak kikerülnek a mappából.
- **Mappa-átrendezés:** a mappa-rekord **megfogva kiemelkedik** (3.8 drag-and-drop), és **más mappák közé átrendezhető** (sorrend változtatás).

**Beszélgetés mappába rendezésének módjai (összegzés):**

1. A mappa 3-pont boxból „Beszélgetés hozzáadása".
2. Drag-and-drop: beszélgetés behúzása a mappára a Beszélgetésekből vagy egy másik mappa alól.
3. A beszélgetés 3-pont boxából „Mappához adás" (7.8).

### 7.8 Beszélgetések

A teljes chat-előzmény tételes listája, a **legutóbbitól a legrégebbiig**. **Ez az egyetlen panel-szakasz, ami a többitől függetlenül görgethető.**

**Rekord létrejötte és állapotjelzők:**

- Új beszélgetés akkor kerül a listára, amikor egy Chatboxból **elküldték** az első üzenetet.
- **Cím:** a beszélgetés neve az **első üzenetből generált rövid cím** (tartalmi összefoglaló, nem nyers szövegcsonkolás). Később átnevezhető (lásd lent).
- **Generálás közben:** a név mellett jobbra **növekvő-csökkenő pötty** (ChatGPT-stílusú „dot" animáció).
- **Kész output:** a pötty helyén **sötétebb zöld, statikus pötty** (brand-700) jelenik meg (nem mozog).

**Interakció:**

- **Hover:** háttér világosszürke (3.5 A). Hoverkor a név mellett **3 pont** jelenik meg; **ha van állapot-pötty (generálás/kész), a 3 pont a pötty helyén jelenik meg, és a pötty hoverig elrejtődik**.
- **Kattintás:** a beszélgetés megnyílik (9), háttér világoszöld.
- **Tükrözött állapot (minden megjelenésen):** egy mappázott beszélgetés a **Beszélgetések** listában és a **mappájában** is megjelenik. Az **aktív/kijelölt** kiemelés (világoszöld) és a **generálás/kész pötty** minden megjelenésén **egyszerre** látszik. Egy nyitott, mappázott beszélgetés tehát a mappában és a Beszélgetésekben is kiemelt.
- **3 pont / jobbklikk → box** a rekordtól jobbra (Box-minta, 3.7):
  - **„Mappához adás"** (group tétel): a mappák listája. Ha a beszélgetés **már mappában van**, az a mappa **világoszöld** kiemeléssel jelenik meg a listában. Másik mappára kattintva a kiemelés **átkerül** az új mappára, és a beszélgetés az **új mappába** kerül.
    - Ha a beszélgetés **már mappában volt** és átrendezik, **ConfirmDialog**: „Ez a beszélgetés már egy mappában van. Biztosan áthelyezed?".
    - **Szabály:** egy beszélgetés **egyszerre egy mappában** lehet.
  - **„Eltávolítás a mappából"** (single, csak ha a beszélgetés mappában van): kiveszi a mappából, a beszélgetés **mappázatlan** lesz (a Beszélgetésekben marad).
  - **„Átnevezés"** (single): inline név-szerkesztés.
  - **„Törlés"** (single, destruktív): ConfirmDialog.
- **Drag-and-drop:** a beszélgetés-rekord **megfogva kiemelkedik** és **mappára ejthető**. A beszélgetés **a Beszélgetések listán belül nem rendezhető át** (a lista mindig a legutóbbitól a legrégebbiig rendezett). Ha mappába ejtik, ott rendeződik.
- **Empty state:** ha még nincs beszélgetés, halvány felirat: „Még nincs beszélgetésed. Indíts egy újat fent."

### 7.9 Panel alja

A Beszélgetésektől **vonallal elválasztva**, a panel alján.

- **Onboarding-folytatás (feltételes):** ha az onboarding még **nincs befejezve**, a vonal **fölött** egy **sötétebb zöld, fémes hatású box** jelenik meg. Kattintásra az onboarding **ott folytatódik, ahol abbamaradt** (6.4). Teljesüléskor eltűnik.
- **Visszajelzés gomb (bal):** megnyomásra **popup** nyílik egy egyszerű **szabadszöveges** űrlappal. Lábléc: **„Mégse" / „Küldés"** (3.7). Beküldés után értesítés a jobb felső sarokban (3.8).
- **Info ikon (a visszajelzés gomb mellett):** kattintásra **popover** jelenik meg a következő figyelmeztetéssel:
  > „Az AI kimenete nem mindig pontos. Mindig ellenőrizd gondosan a válasz helytállóságát. Egy kimenet helyességének elfogadása a felhasználó felelőssége. Ne tölts fel banktitkot tartalmazó adatot."

## 8. Chatbox (composer)

A Chatbox a promptbeviteli mező az összes vezérlőjével. Konténer: fehér, ink-100 border, rádiusz 2xl (16px), árnyék sm.

### 8.1 Pozíció és viselkedés

- A Chat-kezdőoldalon a Chatbox a **képernyő közepén** van, fölötte a köszöntés (8.2), alatta a prompt-javaslatok (8.3).
- **Küldéskor a Chatbox lecsúszik a képernyő aljára**, és a nézet Chatflow-ra vált (9). Onnantól a Chatbox végig az alsó sávban marad.
- A textarea **automatikusan magasodik** a tartalommal, egy maximumig (kb. 180px), utána belül görget.

### 8.2 Köszöntés (greeting)

- A Chatbox tetején (kezdőoldalon) **napszakfüggő köszöntés** jelenik meg, display méretben (28px).
- **Minden napszakhoz 3 változat tartozik**, amelyek közül **új beszélgetésnél véletlenszerűen** választ a rendszer (lehetőleg nem ismételve az előzőt).
- A sávok és szövegek az **Admin → Beállítások → Egyéb → Greetings** alatt szerkeszthetők (11.2). Az alábbi az **alapértelmezett készlet** (szabadon átírható):

| Idősáv | Köszöntés-változatok (· választja el) |
|---|---|
| 04:00–09:55 (reggel) | „Jó reggelt, {megszólítás}!" · „Szép reggelt, {megszólítás}! Kezdjük a napot." · „Üdv, {megszólítás}! Min dolgozzunk ma?" |
| 09:55–11:55 (délelőtt) | „Jó napot, {megszólítás}!" · „Üdv, {megszólítás}! Mi van soron?" · „Egy kávé mellett az új feladat is könnyebb, {megszólítás}." |
| 11:55–12:30 (dél) | „Jó napot, {megszólítás}!" · „Miben segíthetek, {megszólítás}?" · „Ebéd előtt még egy kör, {megszólítás}?" |
| 12:30–18:55 (délután) | „Üdv újra, {megszólítás}!" · „Vissza a feladatokhoz, {megszólítás}!" · „Miben segíthetek, {megszólítás}?" |
| 18:55–21:55 (este) | „Szép estét, {megszólítás}!" · „Jó estét, {megszólítás}! Min dolgozzunk?" · „Még egy feladat ma estére, {megszólítás}?" |
| 21:55–04:00 (éjszaka) | „Úgy tűnik, éjjeli bagoly vagy, {megszólítás}." · „Késő van, {megszólítás}. Miben segíthetek?" · „Jó éjszakát, {megszólítás}! Min dolgozzunk?" |

> A `{megszólítás}` a Fiók → Profil megszólítása (10.1), illetve az onboarding 3. lépéséből származó becenév, vagy az Entra ID keresztnév.

### 8.3 Üres chat: prompt-példák és prompt-javaslatok

Két, külön konfigurálható elem. **Ne keverendők.**

- **Prompt-példák (prompt examples):** a Chatbox **placeholder** szövegeként megjelenő, **forgó** példamondatok (ghost text), amelyek a lehetséges használatot illusztrálják. Nem kattinthatók. Forrás: Admin → Beállítások → Egyéb → Prompt examples (11.2). Példa: „Foglald össze a heti hitelportfólió változását...".
- **Prompt-javaslatok (prompt suggestions):** a Chatbox **alatt** megjelenő, **kattintható chipek**. Egy chipre kattintva a szövege a Chatboxba kerül, és **felülírja a mező jelenlegi tartalmát** (a kézzel beírt szöveget is). Másik javaslatra kattintva az is felülírja az előzőt. Forrás: Admin → Beállítások → Egyéb → Prompt suggestions (11.2).

### 8.4 + gomb és menü

- A **+ gomb** a Chatbox **bal alsó** sarkában. **Kattintásra nyílik** a menü-box (nem hoverre), billentyűzettel Enterrel is. Ismételt kattintás vagy `Escape` zárja.
- A box úgy pozicionál, hogy a **+ gomb a box bal alsó sarka mögött** legyen.
- **Nincs görgetés**, kivéve ha a box nem fér ki a képernyőn: akkor **egyetlen görgetés a boxon belül** (3.7/2).
- A box tartalma fentről lefelé:
  1. **Ügynökök** szakasz (group): a felhasználóhoz rendelt ügynökök listája. A szakasz **magassága az engedélyezett ügynökök számától függ**. Egy aktív (kiválasztott) ügynök sora **világoszöld** (3.5). Több ügynök egyszerre választható.
  2. **Fájl csatolása** (single, 8.8).
  3. **Kép csatolása** (single, 8.8).
  4. **Webes keresés** (single, 8.7). Ha a csoportnak nincs engedélyezve (11.1), a sor letiltott (ink-300, „Letiltva").

### 8.5 Ügynök kiválasztása és chip

- A + menü Ügynökök szakaszából (vagy a panel Ügynökök szakaszából, 7.6) **egy vagy több ügynök** választható.
- Minden kiválasztott ügynök **világoszöld chipként** jelenik meg a Chatbox **bal alján, a + gomb után**.
- **Hover a chipen** → jobb oldalt **`×`** jelenik meg; arra kattintva az ügynök **eltávolítható** (deaktiválható).
- A + menüben a kiválasztott ügynök sora világoszöld (aktív állapot).
- **Több ügynök együtt (viselkedés):** ha több ügynök aktív, a rendszer **összevont kontextusként** kezeli őket (a kiválasztott ügynökök tudásbázisainak/forrásainak uniója); a válasz bármelyikükből hivatkozhat (9.4). A konkrét orchestration (prioritás, súlyozás) backend-konfiguráció, a UX-re nincs hatással.

### 8.6 Webes keresés és chip

- A + menüből a **„Webes keresés"** bekapcsolható (ha engedélyezett, 11.1).
- Bekapcsolva **világoszöld chipként** jelenik meg a + gomb után (ugyanaz a chip-minta, mint 8.5).
- **Hover** → `×` a chip jobb oldalán; arra kattintva kikapcsol. A + menüben a sor világoszöld, amíg aktív.

### 8.7 Fájl- és képcsatolás

- **Fájl csatolása:** kattintásra megnyílik a számítógép **fájlválasztója** (finder). Elfogadott típusok: PDF, DOC/DOCX, XLS/XLSX, PPT/PPTX, TXT, MD, CSV.
- **Kép csatolása:** kattintásra megnyílik a **képválasztó**. Elfogadott: képformátumok (image/*).
- **Korlátok (alapértelmezett, admin-konfigból állítható):** fájlonként max **20 MB**, üzenetenként max **10** csatolmány, prompt max **~8 000 karakter**. Nem támogatott típus, túl nagy méret vagy túllépett limit esetén **sárga értesítés** (3.8), a művelet elmarad, a beírt szöveg megmarad.
- **Megjelenés (mindkettőre azonos):** a feltöltött elem a Chatbox **bal felső részén** jelenik meg **kompakt, szürke chipként** (a webes keresés chip mintájára, 8.6). Több elemnél **balról jobbra** sorakoznak.
  - A chip tartalma egy sorban: **fájl-ikon**, a **fájlnév eleje** (csonkolva), majd a **fájltípus** (pl. PDF, DOCX).
  - **Hoverre** a chip jobb szélén, a fájltípus mellett megjelenik az **`×`**, amivel az elem eltávolítható.

### 8.8 Drag-and-drop és beillesztés

- **Drag-and-drop:** ha a felhasználó **fájlt vagy képet húz a chatbe**, az ugyanúgy feltöltődik, mint a fájlválasztóból (8.7). Húzás közben a Chatbox kiemelődik (brand-700 border + brand-50 overlay, „Engedd el a csatoláshoz").
- **Beillesztés (copy-paste):** beillesztett tartalom **sima szövegként (plain text)** kerül a Chatboxba.

### 8.9 Modellválasztó

- A Chatbox jobb alsó részén, a küldés gomb előtt. A gombon a választott modell **szolgáltató-logója** (OpenAI, Anthropic, Google, Mistral) és **neve** látszik.
- **Ha a felhasználó csoportjának engedélyezett a „Modellválasztás" képesség** (11.1): a gomb kattintható, és a felhasználó **kizárólag az első üzenet elküldéséig** válthat modellt. **Az első üzenet elküldése után a gomb inaktív** a beszélgetés további részében (mutatja a választott modellt, de nem kattintható).
- **Ha nem engedélyezett:** az **alapértelmezett modell** statikus, nem kattintható címkeként látszik, tooltip: „A modellt az adminisztrátor rögzítette."
- A választható modellek és az alapértelmezett az Admin → Képességek → Modellek alól jönnek (11.1). **Példa készlet (admin által szabadon szerkeszthető):** alapértelmezett **GPT** (általános), egy második, erősebb **GPT**, **Claude Opus**, **Claude Sonnet**, és két **Gemini** variáns. A banktitok-fázis self-hosted on-prem modellje nem felhasználói választás: automatikus routing kezeli (8.10).

### 8.10 Küldés és adatkategória-ellenőrzés (DLP)

**Küldés gomb állapotai:**

- **Üres** (nincs szöveg és nincs csatolmány): letiltott (ink-200, `not-allowed`).
- **Van tartalom:** aktív, **zöld** (brand-700).
- **Küldés után (ellenőrzés alatt):** a gomb körül **Glow** pulzál (3.8), amíg az adatkategória-ellenőrzés tart (kb. 1 mp).
- **Generálás közben (streaming):** a küldés gomb **Stop gombbá** vált (**közepes szürke**, ink-400, hogy elkülönüljön a zöld küldés gombtól); megnyomása **leállítja** a generálást (az addig legenerált rész megmarad). A beviteli mező **le van tiltva** generálás közben: nem írható és nem küldhető új input, amíg a válasz fut (9.2).

**Adatkategória-ellenőrzés (a küldés pillanatában):**

1. A rendszer ellenőrzi a beírt szöveg és a csatolmányok **adatkategóriáját**: gyors **kliensoldali mintaillesztés** (proaktív NO-AI, pl. számlaszám, IBAN, ügyfélazonosító, kártyaszám, KYC, „banktitok" kulcsszó) és **backend-osztályozás**. A gomb a válaszig **glow**-ol.
2. **Ha banktitok:**
   - **A) On-prem modell nincs élesítve (MVP és Basics fázis):** **blokkoló popup**: „Ezt az üzenetet nem küldheted el, mert olyan adatot tartalmaz, amit egyelőre nem lehet az AI-nak elküldeni." Egyetlen gomb: „Értem". Bezárás után **minden visszaáll: a beírt szöveg és a csatolmányok a Chatboxban maradnak, semmi nem vész el.** A felhasználó kézzel törli az érintett adatot. **Nem jelöljük meg, pontosan melyik rész a tiltott adat** (a felhasználó tudja, miről van szó), és semmit nem küldünk az AI-nak.
   - **B) On-prem modell élesítve (Banktitok fázistól):** a kérés az **on-prem modellre** irányítódik, és **lefut**. Banktitok **soha nem kerül felhőmodellbe**.
3. **Ha nem banktitok:** a beszélgetés elindul, a Chatbox lecsúszik (8.1), és megkezdődik a Chatflow (9).

> **Egyéb adatkategóriák (üzleti titok, személyes adat):** a roadmap adat-típus szabályai szerint **figyelmeztetés + naplózás** (warn + log), nem blokkolás. A publikus adat szabad. A részletes szabályok és a naplózás az Admin oldalán (11), a roadmap `Adat típusok` szerint.

## 9. Chatflow

A Chatflow egy beszélgetés folyama: az elküldött user-inputok és a generált outputok váltakozó sorozata, fentről lefelé. A Chatbox az alsó sávban marad (8.1).

### 9.1 User-input megjelenítése

- **Megjelenés:** fekete szöveg (ink-900) **világoszöld** (brand-50) **buborékban**, **minden sarka egyformán lekerekített**, a beszélgetésben **jobbra igazítva**.
- **Csatolmányok:** ha az üzenethez fájl vagy kép tartozott, a buborékban is megjelennek a **fájl-boxok** (8.7 szerinti megjelenés), a szöveg fölött. Szerkesztéskor a csatolmányok **megmaradnak**, csak a szöveg módosítható.
- **Hover a buborékon (vagy a közelében):**
  - A buborék **fölött** megjelenik a **küldés időpontja** (nincs kattintásfunkció).
  - A buborék **alatt** megjelenik a **„Másolás"** gomb (minden inputon), és a **„Szerkesztés"** gomb **csak a legutolsó (legfrissebb) inputon**. Korábbi inputok nem szerkeszthetők.
- **Másolás:** a buborék **bordere kissé sötétebbre** vált, amíg a copy meg nem nyomódik; a „Másolás" gomb **boldabbá** válik nyomáskor (3.8 copy-visszajelzés).
- **Szerkesztés (edit-in-place):**
  - A „Szerkesztés" gomb halványabbá (balder) válik nyomáskor; a szerkesztés a **meglévő buborékban** történik, **nem** az alsó Chatboxban.
  - **Csak a szöveg módosítható**, semmi más (nincs új csatolás stb.).
  - A buborék **világosszürkére** vált szerkesztés közben.
  - A buborék **alatt két gomb:** **„Mégse"** és **„Módosítás"**.
    - **„Mégse":** nincs változás, a buborék visszavált zöldre.
    - **„Módosítás":** a buborék visszavált zöldre, az input frissül, és az **output újragenerálódik** (9.3 regenerálás).

### 9.2 Output generálása és megjelenítése

- **Generálás indulása előtt:** **szürke pötty** nő-csökken (ChatGPT-stílusú „thinking dot"), amíg a generálás el nem kezdődik.
- **Generálás közben:** a küldés gomb **Stop gomb** (8.10); a futás bármikor leállítható, az addig legenerált rész megmarad. Az **adott chat** beviteli mezője le van tiltva, amíg a válasza fut.
- **Háttér-generálás (egyidejű futás):** másik beszélgetésben is indítható kérdés, amíg egy generálás fut; a generálások **chatenként függetlenek**. A futást a Beszélgetések (és a mappa) **pöttye** jelzi (7.8). Ha a felhasználó **nincs** az adott chatben, a kész válasz **jobb felső értesítést** ad (3.8) és bekerül az Inboxba (7.5); ha **benne van**, csak látja a streamet, külön értesítés nélkül. A bevitel csak az **éppen generáló** chatben tiltott. **Nincs korlát** a párhuzamosan futó chatek számára; a felhasználónkénti **token-limitek** az admin panelben állíthatók (későbbi fázis).
- **Output szöveg:** **fekete** (ink-900), **keret nélkül**, **balra igazítva**, amint elérhető (streaming, 3.4). A fontos részek **bold**-ok. A streaming blokk végén villogó kurzor (3.4).
- **Támogatott blokkok:** bekezdés, alcím (h3), felsorolás (ul/ol), kód/mono blokk, **táblázat** (fejléc ink-50 háttér, sorok hajszálvonallal elválasztva).
- **Fájl-output:** ha az output **fájlt** generál, két művelet jelenik meg: **„Letöltés"** és **„Megnyitás"**.
  - **„Letöltés":** a böngésző letöltési folyamata indul (vizuálisan is).
  - **„Megnyitás":** a fájl a jobb oldali **dokumentumpanelben** nyílik meg (9.5).
- **Hover az outputon (vagy a közelében):**
  - **Bal felül** megjelenik az output **dátuma**.
  - A szöveg **alján** megjelennek a műveletek: **Másolás, Tetszik (like), Nem tetszik (dislike), Újragenerálás** (9.3).

### 9.3 Output-műveletek

- **Másolás:** nyomáskor a szöveg egy pillanatra **kicsit nagyobb** lesz, a „Másolás" gomb **boldabb** (3.8).
- **Tetszik (like):** a gomb boldabbá válik, és **popup** nyílik egy űrlappal:
  - Szöveg: „Köszönjük a visszajelzést! Szeretnél többet is megosztani?" + **szabadszöveges mező**.
  - Gombok: **bal „Nem köszi"**, **jobb „Küldés"** (3.7).
  - Ha írtak valamit és elküldték: „**Köszönjük szépen!**" felirat, majd a popup **3 másodperc múlva eltűnik**.
- **Nem tetszik (dislike):** ugyanaz a popup-folyamat, mint a like-nál.
- **Újragenerálás (regenerate):** **csak a legutolsó (legfrissebb) outputon** érhető el. A gomb boldabbá válik, és az **egész output újragenerálódik** (a streaming újraindul, 9.2). Ugyanez fut le a legutolsó input szerkesztése után (9.1). A **Másolás, Tetszik, Nem tetszik** minden outputon elérhető.

### 9.4 Hivatkozások (references)

**Szövegközi hivatkozás (inline citation):**

- A szövegben a hivatkozások **számozottak**; a szám **kerek, világosszürke háttéren** (felső indexként) jelenik meg. **A számozás a teljes beszélgetésen át folytonos és állandó:** egy forrás végig ugyanazt a számot viseli a teljes chat-előzményben, új outputnál nem áll vissza és nem számozódik újra.
- **Hover:** a kerek háttér **világoszöld**. **Kattintás:** a szám háttere **sötétebb zöld**, és a hivatkozott dokumentum megnyílik a **dokumentumpanelben** (9.5).

**Hivatkozás-gomb (reference button), jobb felül a Chatflow-ban:**

- **Dokumentum-ikon** + a **hivatkozások száma** (hány referencia volt az eddigi outputokban összesen).
- **Kattintás:** **box** nyílik (Box-minta, 3.7, kattintásra); a **gomb a box mögé kerül**, és a **szám eltűnik** a gombról.
- A box a **hivatkozott dokumentumokat listázza** (név + fájltípus) (group tétel; magasnál görget, 3.7/2).
- **Hover egy rekordon:** világosszürke. **Kattintás:** a rekord **sötétebb zöld bordert** kap, és a **dokumentumpanel jobbról becsúszik** (9.5).

### 9.5 Dokumentumpanel (jobb oldali panel)

- A dokumentumpanel **kizárólag fájl megnyitásakor** jelenik meg: output-fájlból (9.2), szövegközi hivatkozásból (9.4), vagy a jobb felső hivatkozás-gombból (9.4).
- **Egyszerre egy dokumentumpanel:** másik fájl vagy hivatkozás megnyitása a meglévő panel tartalmát **lecseréli**, nem nyit második panelt.
- **Megnyitható típusok:** a fő csatolható típusok (PDF, DOCX, XLSX, TXT, MD, CSV, kép) **megnyithatók és megtekinthetők** a panelben; a „Letöltés" minden típusnál elérhető.
- **Felépítés:**
  - **Felső sor:** a **fájl neve egyben legördülő választó** (nyíllal): rákattintva legördül a **hivatkozott dokumentumok listája** (görgethető), amelyből a felhasználó **átválthat egy másik referencia-doksira** (az aktuális kipipálva); mellette **„Letöltés" gomb** (a fájl letöltése), és a sor végén **`×`** a panel bezárásához.
  - A név **alatt: keresősor** (szókeresés a dokumentumon belül).
  - A maradék terület: a **dokumentum tartalma**.
- **A dokumentum nem szerkeszthető** (csak megtekintés és keresés).
- **Átméretezés:** a Chatflow és a dokumentumpanel közötti határ egy **szürke vonal**. **Hoverre** a vonal közepén **gomb** jelenik meg **két kis, balra-jobbra mutató nyíllal**; balra-jobbra húzva a felhasználó **egyszerre méretezi át** a Chatflow-t és a dokumentumpanelt.

## 10. Fiók (felhasználói beállítások)

A Fiók a felhasználó saját, **end-user** beállításainak rétege. **Nem admin.** Elérése a Workspace menüből (7.2). Teljes szélességű réteg, bal oldali navigációs sávval (rail), amely a Fiók szekcióit listázza; a „Kilépés" visszavisz a chatbe. A szekciók a 3.5 A szabályt követik.

Szekciók: Profil (10.1), Preferenciák (10.2), Értesítések (10.3), Saját használat (10.4), Első lépések (10.5, feltételes).

### 10.1 Profil

- **Profilkép:** feltölthető avatar; alapból monogram (3.6 Avatar).
- **Megszólítás (becenév):** szerkeszthető szövegmező. Ez vezérli a chat-köszöntés `{megszólítás}` változóját (8.2) és az onboarding 3. lépését (6.2). Alapérték: Entra ID keresztnév.
- Csak olvasható mezők: név, e-mail (Entra ID-ból), csoporttagság.

### 10.2 Preferenciák

- **Nyelv:** a felület nyelve **magyar és angol** közül választható (alapértelmezett magyar). A teljes UI-copy i18n-kulcsokon keresztül fordítható.
- **Megjelenés:**
  - **Téma:** Világos / Sötét / Rendszer. **A világos a kanonikus**; a sötét a 3.1 sötét tokeneket használja.
  - **Accent:** a brand-akcent variánsa (teal alap, plusz deep/navy a kódból). Opcionális.
  - **Sűrűség:** compact / regular / comfy (a bal panel sorainak térköze).
- **Enter-küldés:** toggle. Be: `Enter` küld, `Shift+Enter` új sor. Ki: `Enter` új sor, `⌘/Ctrl+Enter` küld (3.8).

### 10.3 Értesítések

- **Értesítés a kész válaszról (output completion):** csatornánként be/ki:
  - **In-app:** az **Inbox** (7.5) ezekből az értesítésekből táplálkozik.
  - **E-mail:** e-mail értesítés a kész válaszról.
- Típusonkénti finomhangolás (pl. csak hosszú futású outputok).

### 10.4 Saját használat

- A felhasználó **egyéni** használata, **csak olvasható**:
  - Üzenetek száma, **tokenfogyás**, modellenkénti bontás.
  - Időszak-váltó: **nap / hét / hó**, trend-diagrammal (3.6 StatTile + chart).
- Nem tartalmaz költség-/admin-adatot (az Admin → Kimutatások alatt van, 11/Függelék A).

### 10.5 Első lépések (feltételes)

- Csak akkor jelenik meg, ha az **onboarding nincs befejezve**.
- A hátralévő onboarding-tételek **checklist**-je. Egy tételre kattintva az onboarding ott folytatódik (6.4).
- Ahogy a tételek teljesülnek, **eltűnnek**; minden tétel kész → a szekció **eltűnik** a Fiókból és a panel-folytatás is (7.9).

---

## 11. Konfigurációs források (Beállítások)

Ez a fejezet azt rögzíti, **honnan jön** a Workspace-viselkedést vezérlő konfiguráció. **A teljes admin felület külön specifikáció tárgya (Függelék A);** itt csak a Workspace szempontjából releváns bemeneteket dokumentáljuk, ahogy a draft is jelölte (Beállítások: Képességek, Egyéb).

### 11.1 Képességek

Admin-oldali konfiguráció, csoport- vagy user-szintű engedélyezéssel (RBAC).

- **Ügynökök:** specializált asszisztensek létrehozása és **csoporthoz/userhez rendelése**. Ez vetül ki a Workspace **Ügynökök** szakaszára (7.6) és a Chatbox **+ menü** Ügynökök szakaszára (8.4). A felhasználó nem szerkeszti.
- **Általános képességek:**
  - **Modellválasztás:** ha a csoportnak engedélyezett, a felhasználó a beszélgetés elején modellt válthat (8.9).
  - **Webes keresés:** ha engedélyezett, megjelenik a + menüben és chipként (8.4, 8.6).
- **Modellek:** az elérhető modellek és az **alapértelmezett** modell. Új modell/szolgáltató bevonása **konfigurációval**, kódmódosítás nélkül. Ezt mutatja a modellválasztó (8.9).
- **Rendszerprompt, RAGok, Skillek:** a munkaterületi alap-rendszerprompt (csoportonként felülírható), a belső tudásbázis-indexek és a specializált skillek kezelése és csoportszintű hozzárendelése. Ezek a chat viselkedését és a hivatkozott forrásokat (9.4) befolyásolják. (Skillek a chatben: lásd Függelék C.)

### 11.2 Egyéb

A draft által nevesített, Workspace-et vezérlő tartalmi konfigurációk.

- **Greetings:** a napszak-sávok (idősávok) és a hozzájuk tartozó köszöntés-változatok listája, típusonként (kb. 3/sáv). Ezt használja a Chatbox köszöntése (8.2).
- **Prompt examples:** a Chatbox forgó placeholder-példamondatai (8.3).
- **Prompt suggestions:** a Chatbox alatti, kattintható javaslat-chipek szövegei (8.3).
- **Feedbacks:** a begyűjtött visszajelzések tárhelye/áttekintése: a panel visszajelzés-űrlapja (7.9) és az output like/dislike visszajelzései (9.3) ide futnak be.

---

## 12. Függelék A: Halasztott és hatókörön kívüli funkciók

Az alábbi felületek a jelenlegi demó-kódban **megépültek, de nem navigálhatók** (dormant), vagy a roadmap **Admin rendszerébe / későbbi fázisba** tartoznak. **Ebből a Workspace specifikációból kimaradnak**, hogy a fókusz a draft szerinti MVP-Workspace legyen. Itt rögzítjük őket, hogy semmi ne vesszen el; mindegyik külön spec tárgya.

| Funkció | Roadmap besorolás | Hol van a kódban (dormant) | Megjegyzés |
|---|---|---|---|
| **Tudásbázis / dokumentumtár böngésző** | Nincs a Workspace MVP-ben (a RAG-kezelés Admin/Képességek) | `library.jsx` (`LibraryView`) | User-oldali dokumentumtár-böngésző. Az MVP-ben a hivatkozott források a Chatflow-ban és a dokumentumpanelben jelennek meg (9.4, 9.5), nincs külön böngésző. |
| **Workflows / Builder (Folyamatok)** | Coming (jövőbeli fázis) | `workflows.jsx`, Builder | Vizuális, N8N-szerű workflow-építő FDE-knek és pro usereknek. A panelen a „Folyamatok" elem ekkor jelenik meg. |
| **Agentek kezelése (létrehozás/szerkesztés)** | Basics fázis, Admin-oldal | `agents.jsx` (`AgentsView`, `AgentDetail`) | Az MVP-ben az ügynökök csak **kiválaszthatók** (7.6, 8.5); a létrehozás/kezelés admin/Basics. |
| **Mentett Promptok** | Coming | `secondary.jsx` (`PromptsView`) | Nem keverendő a prompt-példákkal/-javaslatokkal (8.3), amelyek MVP-ben vannak. |
| **Projektek** | Coming | (nincs külön modul) | Mappák + kontextus (memory, fájlok, promptok, skillek, agentek) csoportosítása. |
| **Teljes Admin rendszer** | MVP–Coming, **Admin** rendszer | `settings.jsx`, `admin.jsx` | Adminisztráció (Tagok, Csoportok, Biztonság), Kimutatások (Analitika, Használat, Auditnapló), Képességek admin UI, Embeddings. A 11. fejezet csak a Workspace-et vezérlő bemeneteit hivatkozza. |
| **Skillek / Integrációk admin nézet** | MVP/Basics, Admin | `secondary.jsx` (`SkillsView`, `IntegrationsView`) | A chat a skilleket használja; a kezelésük admin. |

> A „Folytatás Microsoft Entra ID-val" SSO és a csoportalapú RBAC (5) az MVP része, de a **felhasználó- és csoportkezelés admin felülete** a fenti Admin specbe tartozik.

---

## 13. Függelék B: Eltérések a jelenlegi kódtól

A fejlesztőknek a demóhoz képest a következő érdemi változásokat kell megvalósítaniuk. (Ez nem teljes diff, hanem a fő irányok.)

1. **Login (5):** új elrendezés. Bal panel szélessége a „Kavosz AI portál" felirathoz igazítva (egy sor), nagy, középre igazított logó a felirat fölött; jobb panel világos, fémes hatású; nagyobb, középre igazított belépő blokk.
2. **Onboarding (6):** a jelenlegi **3 lépéses checklist** helyett **9 lépéses** folyamat (4 popup + 4 interaktív túra-lépés glow-val + befejező konfetti). A korábbi checklist a **Fiók → Első lépések** (10.5) és a **panel-folytatás** (7.9) szerepét veszi át.
3. **Köszöntés (8.2):** az egyetlen fix köszöntés helyett **6 napszak-sáv**, sávonként kb. **3 véletlenszerű** változat, konfigurálhatóan (11.2).
4. **Chatbox + menü (8.4):** az **Ügynökök** szakasz bekerül a + menübe (jelenleg csak fájl/kép/webes keresés). **Hoverre nyílik.**
5. **Több ügynök egyszerre (8.5):** a jelenlegi egyetlen aktív ügynök helyett **több** ügynök is aktív lehet párhuzamosan, mindegyik külön chipként.
6. **Modellválasztó (8.9):** a beszélgetés közbeni váltás **letiltva**; modell csak a beszélgetés **elején** állítható.
7. **DLP küldési folyamat (8.10):** küldéskor **glow** a gombon az osztályozás alatt; banktitok esetén **A/B elágazás** (blokkoló popup MVP-ben / on-prem futás a Banktitok fázistól).
8. **Input edit-in-place (9.1):** az elküldött üzenet **helyben** szerkeszthető (nem az alsó Chatboxban), majd az output **újragenerálódik**.
9. **Output-műveletek (9.3):** **like/dislike** visszajelző popupok és **újragenerálás** hozzáadása.
10. **Hivatkozások és dokumentumpanel (9.4, 9.5):** szövegközi számozott citációk + **jobb felső hivatkozás-gomb** boxszal; a dokumentum **jobb oldali panelben** nyílik, **átméretezhető** elválasztóval. (A jelenlegi `SourcesPanel` lebegő kártya ezt váltja fel.)
11. **Bal panel (7):** rögzített, **nem rejthető** sáv. A demó pin/peek/topbar logikája elhagyandó (lásd Függelék C megerősítés).
12. **Dormant nézetek (Függelék A):** a Tudásbázis, Workflows, Agent-kezelés, Promptok, Skillek/Integrációk nézetek **nincsenek** a Workspace MVP-navigációban.

---

## 14. Függelék C: Döntési napló

Minden korábban nyitott pont lezárva. Egyetlen tétel vár még tartalomra (a köszöntés végleges szövege), de a fejlesztés enélkül is indulhat.

### Eldöntve

- **Márkaszín (3.1):** **sötétzöld #006159** (a korábbi #0B6D78/#074751 helyett). Jóváhagyva.
- **Modellek (8.9):** default GPT; választóban GPT + második GPT, Claude Opus, Claude Sonnet, két Gemini. Nevek admin-konfigból.
- **Modellválasztás határa (8.9):** az **első üzenet elküldéséig** állítható; utána zárol a beszélgetésben.
- **Referencia-számozás (9.4):** a teljes beszélgetésen át folytonos és állandó.
- **Nyelv (10.2):** magyar + angol, Preferenciákban váltható; teljes UI i18n.
- **Sötét téma (10.2):** kell, MVP-ben elérhető.
- **Boxok (3.7, 7.2, 8.4, 9.4):** kattintásra nyílnak, nem hoverre.
- **Generálás (8.10, 9.2):** a küldés gomb Stop streaming közben; az adott chat bevitele tiltott.
- **Egyidejű generálás (9.2):** engedélyezett, **nincs párhuzamossági korlát**; token-limit per fő az admin panelben (később). Háttér-chat kész → értesítés + Inbox.
- **Értesítések (3.8):** pozitív/semleges felül-középen (pill); negatív jobb felső, sárga, torlódó, elvethető.
- **Szerkesztés/újragenerálás (9.1, 9.3):** csak a legfrissebb input/output.
- **Prompt-javaslat (8.3):** felülírja a Chatbox tartalmát.
- **DLP-blokk (8.10):** banktitoknál blokkoló popup, a szöveg megmarad, a tiltott részt nem jelöljük meg.
- **Dokumentumpanel (9.5):** Letöltés a fájlnév mellett; egyszerre egy panel; a fő típusok (PDF, DOCX, XLSX, TXT, MD, CSV, kép) megnyithatók a panelben.
- **Csatolható típusok (8.7):** PDF, DOCX, XLSX, TXT, MD, CSV, kép. Véglegesítve.
- **Onboarding videó (6.2):** élesben kötelező; prototípusban Átugrás.
- **Akadálymentesség (3.8):** WCAG 2.1 AA; gold nem szövegszín fehéren; fókusz-kezelés.
- **Mappa (7.7, 7.8):** „Eltávolítás a mappából" akció; mappázott chat mindkét helyen kiemelt; összecsukott mappán állapot-pötty.
- **Csatolmányok (9.1):** az elküldött user-buborékban is láthatók; szerkesztéskor megmaradnak.
- **Keresés (7.4):** beszélgetés-előzményre szűkítve, ⌘K nyitja; találat-kiemelés + görgetés.
- **Több ügynök (8.5):** összevont kontextus (forrás-unió).
- **Session/SSO lejárat (5.3):** re-auth, állapot megőrizve, ugyanoda visszatér.
- **Limitek (8.7):** max 20 MB/fájl, 10 csatolmány, ~8000 karakter prompt (alapértelmezett, állítható).
- **Megőrzés (4):** beszélgetés a törlésig megmarad.
- **Bal panel (7):** rögzített, nem rejthető; a demó pin/peek/topbar elhagyandó.
- **Skillek a chatben (11.1):** automatikus / admin-konfig, nem külön chat-vezérlő.
- **Reszponzivitás (4):** desktop-first MVP; mobil/tablet egy későbbi körben.

### Hátralévő (nem blokkoló)

1. **Köszöntés végleges copy (8.2):** a végleges szöveg és hangnem **Benditől érkezik** később. Addig az alapértelmezett 3/sáv készlet érvényes (szabadon szerkeszthető a Greetings konfigban).

### Külön specifikációban (nem ide tartozik)

- **Admin és beállítások:** külön készül (folyamatban). A Workspace MVP a 11. fejezet szerinti konfigurációs forrásokra hivatkozik.
- **Backend és integráció:** osztályozó-pontosság, feature-flag mechanizmus, adattárolás, SSO/SCIM, retention-policy. Ez a dokumentum kizárólag UX/UI/funkció.

---

*A dokumentum vége. Verzió 0.3, 2026-06-17.*







