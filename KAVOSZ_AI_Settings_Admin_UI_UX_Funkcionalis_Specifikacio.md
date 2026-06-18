# KAVOSZ AI Platform: Beállítások és Admin UI/UX és funkcionális specifikáció

**Belső fejlesztői specifikáció**
Verzió: 1.0 (fejlesztésre kész) · Dátum: 2026-06-17 · Tulajdonos: Bendi / 1337 Partners
Státusz: fejlesztésre kész — a 14. fejezet összes döntése lezárva

---

## 1. Bevezetés

### 1.1 A dokumentum célja

Ez a dokumentum a KAVOSZ AI platform **Beállítások** rétegének és **Admin** rendszerének teljes UI, UX és funkcionális leírása. Párdokumentuma a már elkészült **Workspace** specifikációnak (`KAVOSZ_AI_Workspace_UI_UX_Funkcionalis_Specifikacio.md`, v0.3), és **ugyanazt a logikát, designrendszert és granularitást** követi. A két dokumentum jelenleg **párhuzamosan** fut; később **egyesítjük** őket egyetlen platformspecifikációvá (lásd 1.6).

A jelenlegi kód (a `kavosz-ai-site` repo `index.html` bundle, ezen belül a `settings.jsx`, `admin.jsx`, `secondary.jsx`, `agents.jsx` modulok) egy értékesítési demó. **Ez a specifikáció felülírja a demót** minden ponton, ahol eltér tőle. Ahol a demó tartalmaz olyan kész felületet, amit ez a spec nem visz tovább MVP-be, az a Függelék A-ban (12) szerepel halasztott vagy hatókörön kívüli tételként.

A dokumentum a forrás-draftnál (Bendi megrendelői jegyzeteinél) **granulárisabb**: minden elemhez megadja a célt, a pozíciót, az állapotokat, az interakciókat, az átmeneteket és a magyar microcopy-t. Ahol a draft nem rendelkezett, **iparági jó gyakorlatot** javaslok, és a kérdéses pontot a **14. Döntési napló**-ban gyűjtöm össze, hogy Bendi egyben tudja megválaszolni.

### 1.2 Hatókör

**Hatókörben (in scope):**

- **Fiók (felhasználói beállítások):** Profil, Preferenciák, Értesítések, Saját használat (bővített dashboard), Első lépések. Ez a Workspace-spec 10. fejezetét **kiterjeszti és felülírja** (lásd 1.6 és 5. fejezet).
- **Admin rendszer teljes felülete:**
  - **Adminisztráció:** Tagok, Csoportok, Biztonság, Adatvédelem, Szabályzat.
  - **Kimutatások:** Analitika, Használat, Auditnapló.
  - **Képességek:** Modellek és szolgáltatók, Rendszerprompt, Általános, Promptok, Skillek, RAGok, Sablonok, Konnektorok.
  - **Egyéb:** Greetings, Prompt-példák, Feedbackek, Leaderboard-kapcsoló.
- **Jogosultsági modell (RBAC):** a képesség- és modell-engedélyek öröklődése csoport- és tagszinten (10. fejezet).

**Hivatkozásként, nem újra definiálva:** a Workspace-spec 3. fejezete (designrendszer) **kanonikus**; itt csak az admin-specifikus mintákat egészítem ki (3. fejezet).

**Hatókörön kívül (out of scope), Függelék A:** Builder/Folyamatok (Coming), Embeddings admin (Ügyfél & Ügyintéző fázis), Ügynök- és Workflow-kezelő felületek mély specifikációja (Basics/Coming — itt csak a Képességek-beli horgonyt jelölöm), mentett Projektek. Backend (osztályozó-pontosság, SCIM/SIEM-integráció mechanizmusa, adattárolás) szintén külön dokumentum.

### 1.3 Célközönség

Frontend és UX fejlesztők, terméktulajdonos, QA, valamint a megfelelőségi (compliance) és IT-üzemeltetési stakeholderek, akik az admin kontrollokat fogják használni. A dokumentum React + komponensalapú gondolkodást feltételez, de framework-független.

### 1.4 Kapcsolódó források

- **Workspace-spec (testvérdokumentum):** `KAVOSZ_AI_Workspace_UI_UX_Funkcionalis_Specifikacio.md` v0.3. A designrendszer (3), a globális minták (3.5–3.8) és a Fiók (10) forrása. Erre `WS §x.y` formában hivatkozom.
- **Roadmap (single source of truth):** `Kavosz AI Roadmap` Google Sheet. A taxonómia (Rendszer › Modul › Elem › Feature), a fázisbesorolás és az adat-típus szabályok forrása. Minden admin-elem fázisát a `Elemek` és `Featureök` fülről horgonyozom (lásd 11).
- **Jelenlegi kód:** `kavosz-ai-site/index.html` (bundled React + Babel, 16 modul). Admin-érintett modulok: `settings.jsx`, `admin.jsx`, `secondary.jsx`, `agents.jsx`, `sidebar.jsx`, `modals.jsx`, `auth.jsx`.

### 1.5 Olvasási útmutató

A felépítés a Workspace-spec logikáját tükrözi, alulról felfelé:

1. **Fogalomtár** (2): admin-specifikus kifejezések, a WS-glosszárium kiegészítése.
2. **Admin designrendszer-kiegészítések** (3): csak az admin-specifikus minták (táblázat, drawer, szűrősáv, breakdown-kártya, chart-hover, export-popup, hárompozíciós engedélykapcsoló). A WS §3 alapok kanonikusak.
3. **Globális elrendezés** (4): a Beállítások réteg vázszerkezete, belépés, navigáció, kilépés, ki mit lát.
4. **Fiók** (5): a felhasználói beállítások.
5. **Admin modulok** (6–9): Adminisztráció, Kimutatások, Képességek, Egyéb.
6. **Jogosultsági modell** (10) és **Fázis-besorolás** (11).
7. **Függelékek** (12–14): halasztott funkciók, eltérések a kódtól, döntési napló.

> **Konvenció:** ha egy viselkedés a Workspace-specben már definiált, ide csak hivatkozom (`WS §3.5`), nem ismétlem. Saját szakaszra `§6.2` formában hivatkozom.

### 1.6 Viszony a Workspace-spechez és az egyesítés

A két dokumentum egyesítésekor a következő illesztések érvényesek:

1. **Designrendszer:** egyetlen közös 3. fejezet lesz. Ennek a dokumentumnak a 3. fejezete **csak kiegészítés**; egyesítéskor beolvad a WS §3 alá (mint §3.9–3.13).
2. **Fiók:** a WS §10 és ennek a dokumentumnak az 5. fejezete **ugyanazt az elemet** írja le. Ez a dokumentum a **részletesebb** (bővített Saját használat dashboard, Leaderboard), ezért **egyesítéskor ez a verzió él**. A WS §10.4/§10.5-höz képesti bővítéseket az 5. fejezet jelöli.
3. **Konfigurációs források:** a WS §11 ("Konfigurációs források") egy szándékosan rövid horgony, amely ide mutat. Egyesítéskor a WS §11 helyére a 8. (Képességek) és 9. (Egyéb) fejezet kerül.
4. **Belépési pont:** a Beállítások réteg a Workspace bal paneljének Workspace-menüjéből nyílik (`WS §7.2`). Ez a belépés mindkét specben azonos.

---

## 2. Fogalomtár (kiegészítés a WS-glosszáriumhoz)

| Fogalom | Jelentés |
|---|---|
| **Beállítások réteg** | A teljes képernyős konfigurációs felület, amely a Fiókot és (admin jognál) az Admin rendszert tartalmazza. Bal oldali sávval (rail) navigál, és visszavisz a chatbe. |
| **Admin rendszer** | A Roadmap szerinti `Admin` rendszer. Modulok: Adminisztráció, Kimutatások, Képességek, Egyéb (és később Embeddings, Builder). Ideális felhasználó: menedzser, vezető. |
| **Rail** | A Beállítások réteg bal oldali, szekciókba rendezett navigációs sávja (a `SettingsRail`). Nem azonos a Workspace bal paneljével. |
| **Képesség (capability)** | Csoporthoz/taghoz rendelhető, kapcsolható funkció: általános képesség (webes keresés, modellválasztás), Skill, RAG, Prompt, Sablon, Ügynök. Az admin engedélyezi; a Workspace-en „kivetül". |
| **Engedély-öröklődés** | A képesség tényleges (effektív) állapota egy felhasználónál: a csoport-hozzárendelések **uniója**, amelyet a tagszintű felülírás (Be/Ki) felülbír. Lásd 10. |
| **Hárompozíciós engedélykapcsoló (PermissionControl)** | Tagszintű, három állású vezérlő: **Csoport** (öröklés), **Be** (kényszerített be), **Ki** (kényszerített ki). Lásd 3.6 és 10. |
| **Token-keret (token quota)** | Felhasználható token havi felső korlátja, csoport- és tagszinten állítható (görgő/slider). Lásd 6.1.4, 6.2.3, 10.4. |
| **Drawer** | Jobbról becsúszó részletpanel (nem modal), amely egy rekord (felhasználó, audit-hívás) teljes adatát mutatja. Lásd 3.5. |
| **Breakdown-kártya** | Csökkenő sorrendű, rangsoroló kártya/táblázat (`#`, név, érték), pl. csoport- vagy felhasználónkénti tokenfogyás. Lásd 3.7, 7.2. |
| **Proaktív kategorizálás (NO-AI)** | Küldés ELŐTTI, kliensoldali mintaillesztés, amely a banktitkot felismeri és blokkolja (lásd WS §8.10, és 6.4). Nem AI. |
| **Reaktív kategorizálás (DLP)** | Küldés UTÁNI, AI-alapú osztályozás, amely az auditba/Adatvédelemba flageli a tényleges adattípust. Lásd 6.4, 7.3. |
| **Adattípus** | A Roadmap `Adat típusok` szerinti négy kategória: **Publikus**, **Üzleti titok**, **Személyes**, **Banktitok**. Mindegyikhez tartozik feldolgozási és DLP-szabály (lásd 6.4). |
| **SSO / Entra ID** | Microsoft Entra ID egyszeri bejelentkezés. A tagok forrása; nincs kézi felvétel/törlés. |
| **SCIM** | Felhasználó-szinkron protokoll: az AD/Entra ID-ből automatikusan provisionál tagokat és csoportokat. |
| **SIEM** | Biztonsági naplógyűjtő rendszer, ahova az audit log exportálható/streamelhető. |
| **Leaderboard** | Adminból kapcsolható, token-alapú nyilvános használati rangsor a Fiók profil-területén (lásd 5.4.4, 9.5). |
| **Szabályzat (Policy)** | Az AI-használati szabályzat dokumentum és annak verziói; az onboarding 1. lépésében kötelező elfogadni (`WS §6.2`). Lásd 6.5. |

---

## 3. Admin designrendszer-kiegészítések

A teljes vizuális és interakciós nyelv a **Workspace-spec 3. fejezetében** kanonikus: színek (`WS §3.1`), tipográfia (`WS §3.2`), térköz/rádiusz/árnyék (`WS §3.3`), mozgás (`WS §3.4`), **interakciós állapotok alapszabálya** (`WS §3.5` — sima elem: hover világosszürke `ink-50`, kattintott világoszöld `brand-50`, szöveg `ink-900`, ikon/akcentcsík `brand-700`; színes elem: hover `brand-100`, kattintott `brand-700` border), megosztott komponensek (`WS §3.6`), popup/modal/box minták (`WS §3.7`), globális viselkedés (`WS §3.8`).

> **Színhelyesbítés (kötelező a fejlesztőnek):** a jelenlegi kód a régi `#0B6D78` brand-sz, valamint néhány helyen az `Admin` szót hibásan a Billing oldalra vezeti. A kanonikus brand-szín a `WS §3.1` szerinti **`brand-700 = #006159`**. Az admin felület minden zöldje erre képződik le.

Az alábbi minták **admin-specifikusak** (a WS-ben nincsenek, mert a Workspace nem használ sűrű táblázatot/drawer-t).

### 3.1 Oldal-fejléc (PageHead)

Minden admin-oldal teteje azonos: **bal oldalt** cím (h1, 24px) + egysoros leírás (`ink-500`); **jobb oldalt** az oldalszintű akciók (gombok, időszak-választó). A cím alatt 24px térköz, majd a tartalom. A PageHead nem ragad (nem sticky), a szűrősáv viszont igen (3.4).

### 3.2 Egy görgő szabálya (teljes oldal görget, nem a lista)

**Kötelező, a draft külön kiemelte.** Az admin-oldalakon **nincs külön belső görgetősáv a listához/táblázathoz.** A teljes oldal egyetlen görgetővel görget (a `<main>` saját görgetője), és ahogy az ember legörget az oldalon, vele görög a táblázat is. A táblázatnak nincs saját, az oldaltól független scrollja.

- **Kivétel 1 — fejléc rögzítése:** hosszú táblázatnál a **táblázat fejléce (és a szűrősáv) ragadhat** (sticky) az oldal tetejéhez, hogy görgetés közben is látszódjon az oszlopnév és a szűrő. A sorok az oldallal görögnek.
- **Kivétel 2 — drawer/box:** a jobbról becsúszó drawer (3.5) és a boxok (`WS §3.7`) saját, belső görgetést kaphatnak, mert lebegő rétegek.

### 3.3 Admin-táblázat

- **Sorok:** a `WS §3.5 A` szabály szerint. Hover → `ink-50`; ha a sor megnyit egy drawert/lapot, kattintásra `brand-50` kiemelés és `ink-900` szöveg.
- **Oszlopfejléc:** `eyebrow` stílus (11px, uppercase, `ink-500`), alul hajszálvonal (`ink-100`). Rendezhető oszlopnál hoverre megjelenik a rendezés-nyíl.
- **Sűrűség:** alap sormagasság a `comfy`/`regular` Preferenciák szerint (`WS §10.2`), de admin-alapértelmezés `regular`.
- **Sor menüje:** a sor jobb szélén **3-pont**, csak hoveren jelenik meg; kattintásra **box** nyílik (`WS §3.7`, kattintásra, nem hoverre). Boxon belül single és group tételek a WS-szabály szerint.
- **Üres állapot:** minden táblázatnak van rövid empty-state szövege (lásd az adott szakaszoknál).

### 3.4 Szűrősáv (filter bar)

A PageHead alatt, a táblázat fölött. Bal oldalt **kereső** (`⌘/Ctrl+F` az oldalon belül fókuszál), mellette **szűrő-szelektek** (pl. csoport, szerep, státusz). A szűrősáv **ragad** (sticky) az oldal tetejéhez görgetéskor (3.2 kivétel 1). A szűrők alatt **eredményszámláló** (`{N} eredmény`, `{N} felhasználó`). Élő (gépelés közbeni) szűrés. A szűrők állása az adott munkamenetben megmarad.

### 3.5 Drawer (jobbról becsúszó részletpanel)

Egy rekord teljes adatának megnyitása **nem** új oldalra navigál, hanem **jobbról becsúszó drawert** nyit (max. 440–520px szélesség, `bg-card` fehér, bal oldalon hajszálvonal, `lg` árnyék). A drawer mögött az oldal halványan látszik (nincs teljes dimmelés, mert nem blocking). Bezárás: `×`, `Escape`, vagy a drawer melletti területre kattintás. A drawer **saját görgetésű** (3.2 kivétel 2). Felépítés: fejléc (azonosító + cím + `×`), törzs (szekciók), lábléc (műveletgombok, a `WS §3.7` gombpozíció-konvencióval: destruktív balra-lent danger, megerősítő jobbra-lent).

> **Drawer vs. modal:** a **megtekintés/áttekintés** (audit-rekord, biztonsági felhasználó) **drawer**; a **szerkesztés/létrehozás** (tag profil, új csoport, új képesség) **modal** (`WS §3.7`). Indok: a drawer kontextust tart (a lista mögötte marad), a modal fókuszált, blokkoló műveletre való.

### 3.6 Hárompozíciós engedélykapcsoló (PermissionControl)

Tagszintű, **három állású szegmentált** vezérlő a képesség-felülíráshoz:

- **Csoport** (alapértelmezett): öröklés — a tag a csoportjai szerinti effektív értéket kapja (10). Aktív állapotban `brand-50` tint, `ink-900` szöveg, `brand-700` border (a `WS §3.5` „nincs zöld-a-zöldön" elv szerint).
- **Be:** kényszerített bekapcsolás, felülírja a csoportot.
- **Ki:** kényszerített kikapcsolás, felülírja a csoportot.

A kiválasztott szegmens kap kiemelést, a másik kettő fehér (`WS §3.5 A`). A logika és precedencia: 10. fejezet.

### 3.7 Breakdown-kártya és StatTile-sor

- **StatTile-sor:** az oldal tetején 2–4 `StatTile` (`WS §3.6`): mono nagy szám + felirat + opcionális delta (pozitív zöld / negatív danger / semleges `ink-500`).
- **Breakdown-kártya:** csökkenő sorrendű rangsor. Oszlopok: `#` (mono sorszám), megnevezés (csoport/felhasználó/modell), érték (mono token vagy %), opcionális második érték (költség). Soronként **halvány kitöltés-sáv** a relatív arányhoz (a sor háttere `brand-50` tintbe megy az érték arányában, balról). A kártya fejléce megadja a bontást és a rendezést: pl. „Csoportonként · Havi · csökkenő sorrend".

### 3.8 Chart-minta és hover-szabály

A diagramok (oszlop/bar, trend) a `brand-700` színt használják (nem a régi kódszínt).

- **Hover-szabály (kötelező, a draft kiemelte):** ha az egérrel a **két oszlop közötti fehér résre** mutatunk, a chart **ne ugráljon** — mindig **az egyik vagy a másik oszlop** legyen kiválasztva, sose „a köztük lévő semmi". Gyakorlatban: a chart a kurzor x-pozícióját a **legközelebbi oszlop** sávjához rendeli (a teljes oszlopszélesség + a fél-fél köz a saját trefferzónája). Nincs „lyuk" a hover-zónák között.
- **Kiemelés:** a hoverelt oszlop **megtartja a `brand-700` színét**, az **összes többi oszlop elhalványul** (`opacity ~0.35`). Ez a kódbeli Analitika-charttal egyezik.
- **Tooltip:** a hoverelt oszlop fölött kis buborék a pontos adattal (lásd az adott chartoknál: Saját használat 5.4, Analitika 7.1, Használat 7.2).
- **Átlagvonal:** ahol releváns, szaggatott `átlag` vonal (`ink-300`).

### 3.9 Export-popup (időszakválasztással)

A CSV/JSON exportgomb (jobb felső sarok) **nem** azonnal tölt le, hanem **popupot** nyit (`WS §3.7` modal): időszak-választó (előre-beállított: „Utolsó 30 nap", „Utolsó negyedév", „Egyéni…" dátumtól-dátumig), formátum (CSV alap, ahol értelmezett JSON is), opcionális oszlopválasztás. Lábléc: bal „Mégse", jobb „Export" (`WS §3.7`). Letöltés indulásakor pozitív értesítés (`WS §3.8`, felül-közép).

### 3.10 Akciók visszajelzése

Minden admin-művelet (mentés, hozzárendelés, felfüggesztés, kapcsolás) a `WS §3.8` értesítési mintát követi: pozitív/semleges felül-közép pill (pl. „Változások mentve", „Szerep frissítve", „Felhasználó felfüggesztve"), hiba jobb felső sárga stack. Destruktív műveletnél előbb **ConfirmDialog** (`WS §3.7`).

---

## 4. Globális elrendezés (Beállítások réteg)

### 4.1 Belépés és kilépés

- **Belépés:** a Workspace bal paneljének tetején a **Workspace-menüből** (`WS §7.2`). A menü Fiók-belépői (Profil, Preferenciák, Értesítések, Saját használat, Első lépések) és — **admin jogú** felhasználónál — az Admin-belépők (Adminisztráció, Kimutatások, Képességek, Egyéb) ide nyitnak.
- **Megjelenés:** a Beállítások **teljes képernyős réteg**, amely a Workspace fölé úszik. Bal oldalt **rail** (szekciókba rendezett navigáció), jobbra a **tartalom** (egy görgővel görgő `<main>`, középre igazítva a `WS §3.3` max-szélesség konstansokkal; admin-táblázatos oldalak a `széles` 1024px-et használhatják).
- **Kilépés:** a rail tetején **„Vissza a beszélgetéshez"** (bal nyíl ikon) visszavisz a chatbe, oda, ahol a felhasználó volt. `Escape` az oldalon (ha nincs nyitott box/drawer/modal) szintén kiléptet.

### 4.2 Rail: szekciók és sorrend

A rail fentről lefelé. Minden rail-tétel a `WS §3.5 A` szabályt követi (aktív: `brand-50` háttér, `ink-900` szöveg, 3px `brand-700` bal akcentcsík).

**Fejléc:** „Vissza a beszélgetéshez" + cím „Beállítások".

1. **Fiók** (mindenki látja)
   - Profil · Preferenciák · Értesítések · Saját használat · Első lépések *(csak míg az onboarding nincs kész, `WS §10.5`)*
2. **Adminisztráció** *(csak admin)*
   - Tagok · Csoportok · Biztonság · Adatvédelem · Szabályzat
3. **Kimutatások** *(csak admin)*
   - Analitika · Használat · Auditnapló
4. **Képességek** *(csak admin)*
   - Modellek · Rendszerprompt · Általános · Promptok · Skillek · RAGok · Sablonok · Konnektorok
5. **Egyéb** *(csak admin)*
   - Greetings · Prompt-példák · Feedbackek

> **Megjegyzés (D4):** a **Leaderboard** kapcsolója és láthatósága **nem** az Egyébben, hanem a **Képességek → Általános** alatt van (általános képességként, csoport-láthatósággal, 8.3). A leaderboard maga a Fiók → Saját használatban jelenik meg (5.4.4).

**Lábléc:** „Kijelentkezés" (danger, ConfirmDialog `WS §3.7`) + `© 2026 KAVOSZ Zrt. · v{verzió}`.

> **Eltérés a kódtól:** a kódban a rail szekciói részben mások (Adminisztráció/Kimutatások/Képességek), a ⌘K-paletta megint más címkéket használ (Admin/Felhasználók), és a fájl-fejléc komment egy harmadik csoportosítást ír le. **Ez a fejezet a kanonikus.** Egységesíteni kell a rail, a ⌘K-paletta és minden belépő szekciócímkéit a fentire. (Lásd 14/D1.)

### 4.3 Ki mit lát (RBAC a felületen)

- **Member (alap felhasználó):** csak a **Fiók** szekciót látja a railben. Az Admin szekciók nem jelennek meg neki sehol (sem a railben, sem a Workspace-menüben, sem a ⌘K-palettában).
- **Admin:** minden szekciót lát.
- A szerepmodell **bináris**: Admin / Member (Roadmap `Tagonkénti szerep beállítása (Admin / Member)`). A kódbeli háromszintű `Member/Manager/Admin` mátrix és a külön „Szerepek" oldal **nincs** MVP-ben (lásd 14/D14 és Függelék A). A „ki mit csinálhat" a képesség- és csoport-engedélyekből jön, nem külön szerep-mátrixból.

### 4.4 Reszponzivitás és perzisztencia

- **Platform:** desktop-first, asztali böngésző (a `WS §4` szerint). Mobil/tablet egy későbbi körben.
- **Perzisztencia:** az utoljára megnyitott Beállítás-oldal és a szűrők állása a munkamenetben megmarad. A konfigurációs változások backend-perzisztensek (a demó localStorage-t használ).

---

## 5. Fiók (felhasználói beállítások)

A Fiók a felhasználó saját, **end-user** beállításainak rétege. **Nem admin** — minden felhasználó látja. A Roadmap szerint a Fiók a Workspace rendszerhez tartozik; ezt a fejezetet azért tartalmazza ez a dokumentum, mert a draft itt **részletesebb**, mint a `WS §10`, és mert a Beállítások réteg felépítése (rail, oldal-minták) közös. **Egyesítéskor ez a fejezet él** (lásd 1.6).

A szekciók sorrendje a railben: Profil, Preferenciák, Értesítések, Saját használat, Első lépések. Mindegyik a 3.1 PageHead-et és a `WS §3.5 A` interakciókat használja.

### 5.1 Profil

- **Cím:** „Profil". **Leírás:** „Kezeld a profil adataidat."
- **Profilkép-kártya:** avatar (alapból monogram, `WS §3.6`) + a felhasználó teljes neve + `{email} · {csoport(ok)}`. Gombok: **„Új kép feltöltése"** (fájlválasztó; siker → értesítés „Profilkép feltöltve") és **„Eltávolítás"** (értesítés „Profilkép eltávolítva").
- **Megszólítás (becenév):** szövegmező. Leírás: „Így szólít meg a KAVOSZ AI a chat tetején." Ez vezérli a chat-köszöntés `{megszólítás}` változóját (`WS §8.2`) és az onboarding 3. lépését (`WS §6.2`). Alapérték: az Entra ID keresztnév. Enter/blur commitál, értesítés „Megszólítás frissítve".
- **Csak olvasható mezők (Entra ID-ból):** **Név**, **E-mail**, **Munkakör**, **Csoporttagság**. Ezek **nem szerkeszthetők** (SSO/SCIM forrás).

> **Döntés (D2, eldöntve):** a `Munkakör` **csak olvasható** (Entra ID/SCIM). A **csoporttagság** is csak olvasható itt; szerkesztése **az adminban** történik (Tagok 6.1 / Csoportok 6.2).

### 5.2 Preferenciák

A `WS §10.2` szerint. Cím „Preferenciák", leírás „Megjelenés, viselkedés."

- **Nyelv:** magyar / angol (alapértelmezett magyar). Teljes UI i18n (`WS §10.2`).
- **Megjelenés (téma):** Világos / Sötét / Rendszer (a Világos a kanonikus, `WS §3.1`).
- **Sűrűség:** compact / regular / comfy (a listák/sorok térköze; admin-táblázatra is hat, 3.3).
- **Enter-küldés:** toggle. Be: „Enter elküldi az üzenetet, Shift+Enter új sor"; Ki: „Enter új sor, ⌘/Ctrl+Enter küldi" (`WS §3.8`, `WS §10.2`).

### 5.3 Értesítések

Cím „Értesítések", leírás „Mikor értesítsen a KAVOSZ AI."

- **Az egyetlen, felhasználó által állítható értesítés a „Kész chat":**
  - **Kész chat** — „Amikor a KAVOSZ AI befejezte a válaszgenerálást." Csatornánként be/ki: **In-app** (ez táplálja az Inboxot, `WS §7.5`) és **E-mail** (a céges Entra ID-fiókra). Alap: in-app be, e-mail ki.
- **Minden más értesítés rendszer-alapértelmezett, a felhasználó NEM állíthatja** (és nem is jelenik meg ezen az oldalon): rendszerhibák, szabályzat-frissítés, biztonsági események. Ezek a platform szabályai szerint mennek, fix beállítással.
- **Lábléc:** „Az e-mailek a céges fiókodra érkeznek (Microsoft Entra ID)."

> **Döntés (D3, eldöntve):** a felhasználó **kizárólag a „Kész chat"** értesítést kapcsolhatja (in-app/e-mail). Minden más értesítés fix, alapértelmezett; a felhasználói oldalon senki nem állítja.

### 5.4 Saját használat

A felhasználó **egyéni**, **csak olvasható** használati áttekintése. Cím „Saját használat", leírás „Személyes használat áttekintés." **Itt csak a felhasználó saját adata van, más felhasználóé nem** (a draft ezt kiemelte). Ez a szakasz a `WS §10.4` **bővítése**: a draft itt pontos hover-viselkedést és modell-eloszlást ír elő.

#### 5.4.1 StatTile-sor

Két `StatTile` (3.7): **Üzenet (havi)** (nagy mono szám + delta, pl. „+34 a héten") és **Tokenek** (pl. „412 K" + semleges felirat „átlag 1.6K/üzenet").

#### 5.4.2 Aktivitás-chart (a hover a kulcs)

Oszlopdiagram, **időszak-váltóval: Napi / Heti / Havi** (pill-szegmens, `WS §3.6 Tabs`). Fejléc: eyebrow „Aktivitás" + `{egység} · átlag {érték}` (pl. „üzenet / nap · átlag 12"). Szaggatott átlagvonal (3.8).

**Hover-viselkedés (a draft pontos elvárása):** ahogy a felhasználó ráhúz egy oszlopra (napi/heti/havi bontásban), a tooltipben jelenjen meg:

1. **Aznap (vagy az adott időszakban) hány üzenet** volt, és **hány token** — a pontosság kedvéért mindkettő.
2. **A top 2–3 modell**, amit aznap használt, modellenként **darabszámmal és tokenszámmal**.

A hoverelt oszlop **megtartja a `brand-700` színét**, az összes többi oszlop **elhalványul** (3.8). A két oszlop közötti résen a hover a legközelebbi oszlopra esik, nincs „lyuk" (3.8 hover-szabály).

#### 5.4.3 Modell-eloszlás (utolsó 30 nap)

Az aktivitás-chart alatt **modell-eloszlás** kártya, eyebrow „Modell-eloszlás", alcím „Utolsó 30 nap". Soronként: modellnév + százalék + halvány arány-sáv (3.7). Pl. GPT 64%, Claude Sonnet 22%, Gemini 10%, Mistral 4%. **Más felhasználó adata itt nincs** (a draft kiemelte: „többi felhasználó, akik ide nem kellenek. Nincsen.").

#### 5.4.4 Leaderboard (használati rangsor) — feltételes

A Saját használat alján **Leaderboard** kártya, **csak ha az admin bekapcsolta** és a felhasználó csoportja láthatja (a kapcsoló és a csoport-láthatóság a **Képességek → Általános** alatt, általános képességként, 8.3).

- **Tartalom:** az **elmúlt 30 nap** összes token-fogyását nézi, és **név szerint rangsorolja** a felhasználókat csökkenő sorrendben (3.7 breakdown-kártya). A saját sor kiemelt (bold „Te").
- **Cél:** adopció-ösztönzés, transzparencia (token-alapú). Eyebrow „Használati rangsor", alcím „Top felhasználók · token (30 nap)", pill „Publikus · adminból kapcsolható".
- **Lábléc:** „Adopció-ösztönző, token-alapú. Bekapcsolása a vezetőséggel egyeztetve."
> **Döntés (D4, eldöntve):** az admin a **Képességek → Általános** alatt kapcsolja be a Leaderboardot, és **csoportonként állítja, mely csoport látja** a menüpontot (8.3). Megjelenés: token-alapú rangsor, elmúlt 30 nap, név szerint. **Roadmap:** Rendszer = Workspace (megjelenés) + Admin (kapcsoló), Modul = Fiók + Képességek/Általános, Fázis = MVP, alapból OFF. (Felvenni a Roadmap `Elemek` fülére.)

#### 5.4.5 Hatókör

A Saját használat **nem** tartalmaz költség-/admin-adatot (az Admin → Kimutatások alatt van, 7). Csak a saját üzenet/token/modell-bontás.

### 5.5 Első lépések (feltételes)

A `WS §10.5` és `WS §6` szerint. Csak akkor jelenik meg, ha az **onboarding nincs befejezve**. A hátralévő onboarding-tételek checklistje progress-jelzővel; teljesüléskor a tételek eltűnnek, 100%-nál a szekció eltűnik a railből és a panel-folytatás is (`WS §7.9`). 100%-nál konfetti + „Készen állsz!" banner + „Tovább a chathez".

> **Konzisztencia-javítás (D5, eldöntve):** a kódban **három különböző onboarding-számláló** van: 7 tétel az Első lépésekben, 9 lépés az onboarding-túrában, 5 kulcs a panel-progressben. Ezért ugyanaz a felhasználó három eltérő „hány %-on állsz" értéket láthat. **Az „egy forrás" ezt jelenti:** egyetlen kanonikus lépéslista (a `WS §6` 9 lépése), amelynek a teljesültségi állapotát **közösen olvassa** az Első lépések checklist, a panel-progress és az onboarding-túra. Így mindenhol ugyanaz a %.

---

## 6. Adminisztráció

A `Admin` rendszer `Adminisztráció` modulja. Felhasználókkal és használattal kapcsolatos beállítások. Elemek: Tagok, Csoportok, Biztonság, Adatvédelem, Szabályzat (Roadmap; az Adatvédelem új, lásd 6.4). Mind MVP.

### 6.1 Tagok

A workspace tagjainak címtára. **A tagság forrása az SSO/Entra ID + SCIM:** a felhasználók **automatikusan szinkronizálódnak az AD alapján**.

#### 6.1.1 Mit lehet és mit nem (a draft kötelező megkötései)

- **Nincs** új tag meghívása, **nincs** kézi felvétel, **nincs** törlés, **nincs** CSV-import. (Minden AD-szinkronból jön.)
- **Van** felfüggesztés (suspend) — ez az egyetlen destruktív tagművelet.
- **Van** export (max. 2–3 formátum, jellemzően CSV; lásd 3.9 export-popup).

> **Eltérés a kódtól (kötelező):** a kód `Meghívás` és `CSV import` gombokat tartalmaz a PageHeadben — **ezeket el kell távolítani.** Helyükre legfeljebb egy „Export" gomb kerül. (14/D6.)

#### 6.1.2 Lista, keresés, szűrés, görgetés

- **PageHead:** cím „Tagok", leírás dinamikus: „{N} tag · {X} aktív · {Y} felfüggesztve". Jobbra: „Export" (3.9).
- **Szűrősáv (3.4):** kereső „Keresés név vagy e-mail szerint…"; **szelektek**: **Csoport** (Mind + csoportlista), **Szerep** (Mind / Admin / Member), **Státusz** (Mind / Aktív / Meghívott / Felfüggesztve). Eredményszámláló: „{N} eredmény".
- **Egy görgő (3.2):** **nincs külön görgetősáv a tagok listájához** — az egész oldal egyetlen görgetővel görget, és vele görög a táblázat. (A draft ezt nyomatékosan kérte.) A táblázat fejléce és a szűrősáv ragadhat (sticky).

#### 6.1.3 Táblázat és sor

- **Oszlopok:** **Tag** (avatar + név + e-mail) · **Szerep** · **Csoportok** · **Státusz** · (3-pont).
  - **Sorrend a draft szerint:** a **Szerep előbb**, a **Csoport másodszor** (mind az oszlopsorrendben, mind a szerkesztő-modalban).
- **Tag-cellára (névre) kattintás:** **egyből a profil szerkesztésére ugrik** (megnyílik a tag-szerkesztő modal, 6.1.4). A draft külön kérte.
- **Szerep:** inline szelekt (Admin / Member); váltáskor értesítés „Szerep frissítve".
- **Csoportok:** kattintható pill-lista; kattintásra **box** (`WS §3.7`) a csoportok checkbox-listájával (group tétel; hosszúnál a box görget, nem nyit új boxot).
- **Státusz (D7, eldöntve):** `● Aktív` (zöld pötty) / `Meghívott` (**sárga**, gold — AD-ből provisionált, de még nem lépett be SSO-val) / `Felfüggesztve` (danger). **A státuszra szűrni lehet** (6.1.2).
- **3-pont box:** „Profil szerkesztése" (single) · elválasztó · „Felfüggesztés" (single, destruktív — ConfirmDialog). **Nincs „Eltávolítás".**

#### 6.1.4 Tag-szerkesztő modal (profil szerkesztése)

Modal (`WS §3.7`), fejléc: avatar + név + e-mail. Mezők és sorrend:

1. **Név** — **csak olvasható** (Entra ID).
2. **E-mail** — **csak olvasható** (Entra ID, mono).
3. **Szerep** — szegmentált (Member / Admin). **A szerep előbb van, mint a csoport** (draft).
4. **Csoportok** — pill-toggle az összes csoportra (kiválasztott ✓).
5. **Havi token-keret** — **görgő/slider** (a felhasználható token havi felső korlátja). **A képességek ELŐTT** van (draft). Öröklés/precedencia: 10.4. Megjelenítés: aktuális érték mono + slider; „Öröklés a csoporttól" opció (alapértelmezett).
6. **Engedélyek (képességek)** — szekciókra bontva (Általános, RAG-ok, Skillek, Promptok, Sablonok): képességenként ikon + cím + leírás + **hárompozíciós engedélykapcsoló** (Csoport / Be / Ki, 3.6). A precedencia: 10.
7. **Lábléc:** bal-lent **„Felfüggesztés"** (danger; a felfüggesztés az eltávolítási workflow helyén — a draft szerint „az eltávolítási workflow-ból lehet felfüggesztés"); jobbra „Mégse" / „Mentés" (`WS §3.7`). Felfüggesztés után a státusz „Felfüggesztve", a tag nem tud belépni a visszakapcsolásig. Értesítés „Felhasználó felfüggesztve".

> **Eltérés a kódtól:** a kódbeli `MemberEditModal` „Eltávolítás a workspace-ből" danger gombja **felfüggesztésre cserélendő** (eltávolítás nincs). A használt-de-halott `memberPerms` állapotot el kell hagyni; az egyetlen igaz felülírási út a tagszintű override (10.2).

### 6.2 Csoportok

Felhasználói csoportok és hozzáférések. A csoport az **engedélyezés elsődleges egysége** (RBAC, 10).

#### 6.2.1 Lista

- **PageHead:** cím „Csoportok", leírás „Felhasználói csoportok és hozzáférések." Jobbra: **„Új csoport"** (6.2.2).
- **Lista (táblázat vagy kártyák):** soronként **csoportnév** + **leírás** + **taglétszám**. **Nem lenyíló/accordion** — a draft kérte, hogy itt is **3-pontra** kattintva nyíljon egy **popup** (mint a tagoknál), ne a sor nyíljon ki. Egy görgő (3.2).
- **3-pont box:** „Szerkesztés" (megnyitja a csoport-modalt, 6.2.3) · „Törlés" (destruktív, ConfirmDialog; a csoport tagjai nem törlődnek, csak kikerülnek a csoportból).

#### 6.2.2 Új csoport (popup)

„Új csoport" gomb → **popup** (`WS §3.7`). Mezők:

- **Név** (kötelező).
- **Leírás** (rövid).
- **Tagok** — kik kerüljenek a csoportba: kereshető tag-választó (multi-select). (Opcionálisan üresen is létrehozható.)
- **Lábléc:** „Mégse" / „Létrehozás". Siker → értesítés „Csoport létrehozva", a csoport megjelenik a listában taglétszámmal.

#### 6.2.3 Csoport-modal (szerkesztés)

A draft: „ne egy lenyíló ablak legyen, hanem 3-pontra előjön egy hasonló pop-up, mint a tagoknál". Modal (`WS §3.7`), tartalma:

1. **Csoport neve** (szerkeszthető) + **Leírás** (szerkeszthető).
2. **Havi token-keret** — **görgő/slider**, a csoportban lévő emberekre érvényes havi token-felső-korlát. **A képességek ELŐTT** (draft). Precedencia tag vs. csoport: 10.4.
3. **Funkciók (képességek) kilistázva + állítási lehetőség:** csoportszintű képesség-hozzárendelés. Minden bekapcsolt képesség (Általános, RAG, Skill, Prompt, Sablon, Modell-hozzáférés) sora: ikon + cím + leírás + **toggle** (csoportra be/ki). Üres állapot: „Nincs aktív képesség. Bekapcsolás: Beállítások → Képességek."
4. **Modell-hozzáférés:** itt is állítható, **melyik modellhez fér hozzá a csoport** — **szinkronban a Modellek oldallal** (8.1). Amit itt állítok, az ott is látszik és fordítva.
5. **Tagok kilistázva + eltávolítás + hozzáadás:** a csoport tagjainak listája; tag eltávolítása a csoportból, és „Tag hozzáadása" (tag-választó). A tulajdonos (ha van) „Tulajdonos" pillt kap.
6. **Lábléc:** „Mégse" / „Mentés".

#### 6.2.4 Képesség-szinkron edge case-ek (a draft két kiemelt esete)

A csoport- és tagszintű kapcsolás öröklődése **kritikus**; a teljes modellt a **10. fejezet** rögzíti. A draft két esetét itt is kiemelem, mert a Csoportok oldalon merülnek fel:

- **(A) Több csoport — unió:** ha egy funkció a „A" csoportban **be** van, és én ott **kikapcsolom**, de a felhasználó egy másik („B") csoportban is benne van, ahol a funkció **be** van, akkor a felhasználónál a funkció **bekapcsolva marad** (a csoportok uniója dönt). Lásd 10.1.
- **(B) Tagszintű felülírás erősebb:** ha egy funkció a csoportnál **be** van, de előtte a tag oldalán a kapcsolót **Csoport → Be** állapotba állítottam, majd a csoportnál **kikapcsolom**, akkor a tagnál a funkció **bekapcsolva marad** (a tagszintű explicit „Be" felülírja a csoportot). Lásd 10.2.

### 6.3 Biztonság

User-szintű biztonsági állapot, **admin nézetből**. A draft kérése: **sokkal kevesebb, mint a jelenlegi kód** — csak a piaci standard, a legfontosabb dolgok, semmi felesleges. **A „Szabályzat" NEM külön aloldal/tab itt** (a Szabályzat önálló elem, 6.5).

#### 6.3.1 Dashboard (felül)

StatTile-sor (3.7), a legfontosabb mutatók:

- **Aktív munkamenetek** (összes eszközön).
- **SSO-kötött** (%) — Entra ID.
- **Kockázati jelzés** (db felhasználó, ami figyelmet igényel; danger, ha > 0).
- *(opcionális)* **MFA-lefedettség** (%), ha az Entra ID-ból elérhető.

#### 6.3.2 Jobb felső sarok: szervezeti konfiguráció

A draft: „SSO / Entra ID, SCIM, audit log / SIEM export — jobb felső sarok." Itt **kompakt** konfigurációs belépők (nem külön tab):

- **SSO / Entra ID** — státusz „Aktív · konfigurálva".
- **SCIM provisioning** — automatikus user-szinkron (státusz/kapcsoló).
- **Audit log / SIEM export** — „Konfigurálás" (a részletes export az Auditnaplóból, 7.3).

> **Döntés (D8, D9, eldöntve):** **nincs jelszó-kezelés, nincs IP-tartomány korlátozás** (a belépés kizárólag SSO/Entra ID). **Nincs adatmegőrzés-beállítás:** a beszélgetések **alapból örökre** megmaradnak (a `WS §4` szerint a törlésig), külön retention-kapcsoló nélkül. Így a Biztonság a fenti három belépőre + a felhasználói táblára + a munkamenet-kezelésre szorítkozik.

#### 6.3.3 Felhasználói tábla

- **Szűrősáv (3.4):** kereső „Keresés név vagy e-mail szerint…"; szelekt: **Kockázat** (Mind / Magas / Közepes / Alacsony).
- **Oszlopok:** **Felhasználó** · **Utolsó aktivitás** · **Munkamenet** (db) · **Szokatlan használat** (jelző) · **Kockázat** (RiskPill: Alacsony/Közepes/Magas). Magas→közepes→alacsony rendezés.
- **Egy görgő (3.2).** Üres: „Nincs találat a szűrőkre." Lábléc-hint: „Kattints egy felhasználóra a munkamenetek és műveletek megnyitásához."
- **Sorra kattintás → Drawer (6.3.4).**

#### 6.3.4 Felhasználó-drawer (3.5)

Jobbról becsúszó panel. Tartalom:

- **Fejléc:** avatar + név (+ „Admin" pill, ha admin) + `{e-mail} · {csoport}`.
- **Kockázati szint** (RiskPill).
- **Jelzések-rács:** **Utolsó aktivitás** (relatív idő), **Eszköz** (utolsó böngésző/OS), **Munkamenetek** (db), **Szokatlan használat** (lásd lent).
- **Kockázati jelzések (lista):** piaci standard, SSO-kontextusban: „Bejelentkezés szokatlan helyről", „{n} sikertelen SSO-belépés 24 órán belül", **„Szokatlan használat: kiugró token-fogyasztás"**, **„Szokatlan használat: munka a 7:00–18:00 sávon kívül"**.
- **Aktív munkamenetek ({N}):** soronként `{böngésző} — {OS}`, `{IP} · {város} · {idő}`, pillek „Jelenlegi"/„Szokatlan", soronkénti **„Lezárás"**. Fent „Összes lezárása". **Munkamenet-lezárás mindig ConfirmDialog-gal** (popup — a draft kérte: „biztosan popuppal"). Itt lehet **kiléptetni a usert eszközökről**.
- **Lábléc-műveletek (piaci standard, SSO-only):** „Kiléptetés" (összes munkamenet lezárása), „Felfüggesztés" (danger). **Nincs** jelszó-/MFA-visszaállítás (a belépés SSO/Entra ID, jelszó nincs).

#### 6.3.5 Szokatlan használat (unusual usage) jelzés

A draft nevesítette. Két alapszabály (admin-állítható küszöbökkel, backend):

1. **Egyszerre sok token** — kiugró token-fogyasztás (a felhasználó szokásos szórásához vagy a csoportátlaghoz képest).
2. **Idősávon kívüli munka** — a **7:00–18:00** munkasávon kívüli érdemi használat.

A jelzés piros (danger) jelölést kap a drawerben és beleszámít a „Kockázati jelzés" tile-ba (6.3.1). Ugyanezek a szokatlan minták az **Analitika** és **Használat** oldalon is piros jelzéssel megjelennek (lásd 7.1, 7.2).

#### 6.3.6 Naplózás

**Bejelentkezések és rendszeresemények naplózása** (a draft kérte). Ezek az **Auditnapló → Rendszeresemények** fülön jelennek meg (7.3); a Biztonság oldal csak összesít és a drawerben mutat.

### 6.4 Adatvédelem

**Új elem** (a draftban „Adatbiztonság"; az elnevezés eldöntve: **Adatvédelem**, D10). Cél: az **adattípus-feltöltések** naplózása és monitorozása. Ez **a feltöltött adatról szól, nem a chatről** (a draft kiemelte: „itt nem a chatről van szó, hanem a feltöltésről"). Hasonló az Auditnaplóhoz, de **feltöltött adattípus szerint** nézzük, nem input szerint.

> **Elnevezés (D10, eldöntve):** **„Adatvédelem"** (a Biztonság testvéreként), alcím „Adatkategóriák és DLP".

#### 6.4.1 Chart (felül)

A feltöltések **adatkategória szerinti** összesítése: **Publikus / Üzleti titok / Személyes / Banktitok**. **Összesen**, valamint **napi / heti / havi** bontásban (időszak-váltó, 3.8 chart-hover-szabállyal). Kategóriánként eltérő tónus (a banktitok danger-tónusú). Tooltip a pontos darabszámmal kategóriánként.

#### 6.4.2 Felhasználónkénti feltöltés-log (utolsó 30 nap)

Breakdown-kártya (3.7), **csökkenő sorrendben**: melyik felhasználó **mennyit töltött fel** az elmúlt 30 napban (kategóriánkénti bontással is). 

- **Banktitok-jelző oszlop (D24, eldöntve):** külön oszlopban **piros jelzés** azoknál, akiknél banktitok-feltöltési kísérlet volt. A pontos viselkedés:
  1. A felhasználó **banktitkot tartalmazó adatot** próbál feltölteni/beírni.
  2. **Értesítést kap, hogy módosítsa a promptot** (`WS §8.10` blokkoló popup) — az adat **nem megy el az AI-nak**.
  3. A kísérlet **a prompt szintjén naplózódik az auditba**, **output nélkül** (mivel nem futott le).
  4. Ez **egy banktitok-piros-jelzésnek számít** az adott felhasználónál, **egy hétre**. Ha a következő **7 napban nem ismétlődik**, a jelzés **lecseng** (gördülő 7 napos ablak).

#### 6.4.3 Feltöltési audit (alul)

A felhasználónkénti összesítés alatt **audit-lista**: **ki, mikor, milyen típusú adatot** töltött fel — **akkor is, ha erről nem chatelt** (a feltöltés ténye számít, nem a beszélgetés). Oszlopok: időbélyeg · felhasználó · adattípus (Publikus/Üzleti/Személyes/Banktitok) · forrás (fájl/beillesztés) · eredmény (feldolgozva / blokkolva). **Export jobb felső sarokból** (3.9 popup, időszakkal).

#### 6.4.4 Kategorizálás: proaktív (NO-AI) és reaktív (AI/DLP)

A draft két mechanizmust nevesít, ezek ide futnak be (a Roadmap `Adat típusok` szerint):

- **Proaktív kategorizálás (NO-AI):** a user input **banktitok** kategóriába sorolása **minta alapján, a chat ELŐTT** (kliensoldali mintaillesztés). Ez blokkol (`WS §8.10`), és **feltöltési kísérletként** rögzül itt (6.4.2 piros jelző).
- **Reaktív kategorizálás (AI/DLP):** miután az input elment a chatbe, az **AI utólag** osztályozza a tényleges adattípust, és **flageli az auditban** (itt és az Auditnaplóban, 7.3), hogy mi volt.

#### 6.4.5 Adattípus-szabályok (referencia)

A feldolgozási és DLP-szabályok a Roadmap `Adat típusok` szerint kanonikusak:

| Adattípus | Feldolgozás | DLP |
|---|---|---|
| Publikus | Cloud vagy self-hosted | – |
| Üzleti titok | DPA + no-training | Figyelmeztetés + naplózás |
| Személyes | DPA + no-training + ZDR | Figyelmeztetés + naplózás |
| Banktitok | Self-hosted on-prem | Felismerés + **blokkolás** + naplózás (proaktív NO-AI) |

> **Output-oldali DLP** (a válasz szűrése kiküldés előtt, RFP 7.3) a Roadmap szerint **Coming** fázis — nincs MVP-ben, itt csak jelzem (Függelék A).

### 6.5 Szabályzat (Policy)

Az AI-használati szabályzat dokumentum kezelése és verziózása. Az **aktív** szabályzat jelenik meg az onboarding 1. lépésében (`WS §6.2`), elfogadása kötelező.

#### 6.5.1 Felület

- **PageHead:** cím „Szabályzat", leírás „AI-használati szabályzat feltöltése és verziózása. Az aktív szabályzat megjelenik a workspace onboardingban, elfogadása kötelező." Jobbra: **„Új szabályzat feltöltése"** (3.9-szerű feltöltés, vagy fájlválasztó + metaadat-popup — **nem** natív `prompt()`, lásd 14/D11).
- **Feltöltés hatása:** a frissen feltöltött dokumentum **aktiválódik**; az eddig aktív **archív/deaktivált** lesz (sárga/szürke jelzés). Az aktív kártyán: doc-ikon + név + „Feltöltve: {idő} · {ki}" + pill „Aktív · megjelenik a workspace-ben".
- **Feltöltött verziók listája:** név + „{idő} · {ki}" + pill „Aktív" vagy „archív". 

#### 6.5.2 Verzió-popup (3-pont a verzió jobb oldalán)

A draft jó feature-je: a verzióra **3-pont** → **popup**:

- A **verzió leírása** (a dokumentum metaadata/összefoglaló).
- **„Verzió letöltése"** gomb — letölthető, nem kell a webappon megnézni a dokumentumot.
- Alatta **kilistázva, kik fogadták el és kik nem** (felhasználónként, státusszal).

#### 6.5.3 Elfogadások audit

Minden elfogadás auditálva, **időre visszamenőleg**, felhasználótól és szabályzattól függetlenül. **Kereshető és szűrhető**: felhasználó, verzió, idő, státusz szerint. Oszlopok: **Felhasználó** · **Elfogadott verzió** · **Időbélyeg** · **Státusz**. **Export** (CSV, 3.9).

- **Státusz-elnevezés (industry standard — eldöntve):** **„Elfogadva"** (zöld + pipa) / **„Függőben"** (gold) a nem-még-elfogadottra. (A „Függőben" a bevett megnevezés; a kód is ezt használja.) A státusz egy **switch**-csel állítható nézetben (Elfogadva / Függőben). Lásd 14/D12.
- Összegzés: „{X} / {Y} fogadta el a hatályos {verzió} szabályzatot."

#### 6.5.4 Megjelenés a felhasználóknál (kötelező elfogadás)

- **Onboarding 1. lépése:** a szabályzat az onboarding **első lépése** (`WS §6.2`): a felhasználó belép, megnyitja a szabályzatot, elfogadja, továbblép (majd jön a videó, aztán az interaktív túra). **Ugyanaz a popup-ablak és megjelenés**, mint az onboarding többi lépésénél; **az admin állítja, melyik fájl nyílik meg** (az aktív szabályzat, 6.5.1). A megnyitás történhet böngészőben is.
- **Új szabályzat feltöltésekor:** amint az admin feltölt egy új szabályzatot, az **azonnal felugrik** minden olyan felhasználónál, aki még nem fogadta el — **blokkoló popupként** (`WS §6.2` Policy-modal), a következő interakciókor, elfogadásig.
- **Nincs elutasítás:** a szabályzatot **kötelező elfogadni**; nincs „nem fogadom el" opció. A popup addig blokkol, amíg a felhasználó el nem fogadja.
- Minden elfogadás **logolódik** (idő, felhasználó, verzió) — a Biztonság/Auditnapló alá is (6.3.6, 7.3).

---

## 7. Kimutatások

A `Admin` rendszer `Kimutatások` modulja: használattal kapcsolatos kimutatások. Három elem: **Analitika** (aktivitás/minőség, token nélkül), **Használat** (minden tokenről), **Auditnapló** (interakció-szintű naplózás). Mind MVP.

**Közös minták mindhárom oldalon:**

- **Időszak-szűrő (filter date):** nap / hét / hó (és előre-beállított tartományok: 30 nap, negyedév, év). A teljes oldal a kiválasztott bontásra vált.
- **CSV-export:** jobb felső sarok, **export-popupban időszak-beállítással** (3.9).
- **Egy görgő (3.2).**

### 7.1 Analitika

**A platform-használatból eredő aggregált kimutatások**, NEM tokenről. A draft kiemelte: „itt nem kell token semmiből". Ez egy **sávozott (kártyákra/blokkokra bontott) oldal**, aktivitási és minőségi mutatókkal, **aggregált, feature- és user-szinten**.

- **PageHead:** cím „Analitika", leírás „Workspace-szintű használati és minőségi kimutatás." Jobbra: időszak-szelekt + „CSV export" (3.9).

#### 7.1.1 Alaphasználati StatTile-ok

| Mutató | Jelentés | Típus |
|---|---|---|
| **DAU** | Napi aktív felhasználó | szám |
| **WAU** | Heti aktív felhasználó | szám |
| **MAU** | Havi aktív felhasználó | szám |
| **Session length** | Átlagos chat-session hossza / user | szám (idő) |
| **Messages per user** | Átlagos üzenetszám / chat / user | szám |

Mellette **Top users** blokk: **üzenetszám / user** szerinti csökkenő rangsor (breakdown-kártya, 3.7). **Itt nincs token** (csak üzenetszám).

#### 7.1.2 Képességek WAU-ra bontva (külön chartokkal)

Minden képességhez **heti aktív használat (WAU)** és **saját használati chart** (3.8). A draft példái (de több is van):

| Képesség / mutató | Jelentés | Típus |
|---|---|---|
| Általános chat WAU — aktív userek | Aktív userek száma | szám |
| Általános chat WAU — arány | Aktív userek aránya az összesből | % |
| Általános chat WAU — üzenet/user/hét | Átlag üzenet / user / hét | szám |
| Termék RAG WAU — aktív userek | Aktív userek száma | szám |
| Termék RAG WAU — arány (ügyintézők) | Aktív userek aránya az ügyintézők csoportból | % |
| Termék RAG WAU — arány (helpdesk) | Aktív userek aránya a helpdesk csoportból | % |
| **Feature adoption** | File attach, web search… használat | % |
| **Thumbs up/down arány** | Pozitív/negatív feedback aránya | % |

Minden képességsorhoz tartozik egy kis trend-chart (a WAU időbeli alakulása), a 3.8 hover-szabállyal.

#### 7.1.3 Minőség (best practice, a kódból megtartva)

Külön kártya: **Pontosság (becslés)**, **Forrás-fedés**, **Visszajelzés (átlag)**, **Hibás futás (%)**. (Opcionális, de hasznos vezetői mutató.)

#### 7.1.4 Szokatlan használat jelzése

A 6.3.5 szerinti szokatlan minták (kiugró fogyasztás, idősávon kívüli munka) **piros jelzéssel** itt is megjelennek (a draft kérte: „az Analitika és Használat oldalon").

### 7.2 Használat

**Tokenesített** kimutatás: itt **minden tokenről szól**. A draft: „actually granular használat token szinten… hasonló mint az analitika, csak tokenesítve". 

- **PageHead:** cím „Használat", leírás „Token-fogyás idő- és bontás szerint." Jobbra: bontás-váltó (Napi / Heti / Havi) + „CSV export" (3.9).

#### 7.2.1 Token-szintek

1. **Aggregált token-használat** az időszakra — StatTile-ok (összes token, be/ki bontás) + token-trend chart (3.8).
2. **Feature-szintű token-használat** az időszakra — melyik képesség mennyi tokent fogyaszt (breakdown, 3.7).
3. **Modell-szintű token-használat** az időszakra — modellenkénti be/ki token és összesen (táblázat, opcionálisan költséggel — lásd lent).
4. **Felhasználónkénti token-használat** — csökkenő rangsor (breakdown, 3.7).
5. *(opcionálisan)* **Csoportonkénti token-használat** — csökkenő rangsor.

#### 7.2.2 Költség és token-keret (Roadmap-megfelelés)

A Roadmap `Használat` eleme tartalmaz **becsült költséget** és **fogyasztási korlátokat** is. Ezek itt jelennek meg, **a token mellett, teljes értékűen**:

- **Becsült költség** modellenként és összesen (Ft, EU-régiós listaár alapján), valamint **költség / 1M token**. 
- **Token-keret kihasználtság** csoport- és felhasználószinten (a 6.1.4/6.2.3 kereteihez képest).
- *(opcionálisan, a kódból)* **Lezárt hónapok** táblázat, hónaponkénti be/ki/összes/költség bontással.

> **Döntés (D13, eldöntve):** a Használat **tokent ÉS becsült költséget** is mutat (mindkettő kell). A token a fő nézet, a Ft-költség mellette **teljes értékű** (modellenként, csoportonként, felhasználónként, lezárt hónapok). A kódbeli külön „Billing" oldal **beolvad** ide; a két, „Saját használat" (Fiók, személyes, 5.4) és „Használat" (admin, 7.2) oldal egyértelműen szétválasztva.

#### 7.2.3 Szokatlan használat

A 6.3.5 piros jelzés itt is megjelenik (kiugró token-fogyasztás).

### 7.3 Auditnapló

Minden AI-hívás és rendszeresemény visszakövethető — exportálható, SIEM-be köthető. A draft: „minden interakció kilistázva, 3-pont a rekord szélén, rákattintásra pontos kimutatás".

- **PageHead:** cím „Auditnapló", leírás „Minden AI-hívás és rendszeresemény visszakövethető — exportálható, SIEM-be köthető." Jobbra: „CSV export" (3.9) + „SIEM beállítás".
- **Tabok:** **„AI-hívások"** (számláló) / **„Rendszeresemények"** (számláló).
- **Szűrősáv (3.4):** **időszak** (dátumtól–dátumig) + szelekt (AI-fülön: **modell**; rendszer-fülön: **esemény-típus**). Kereső: AI-fülön „Keresés bemenet, kimenet, felhasználó vagy ID szerint…"; rendszer-fülön „Keresés ID, művelet vagy név szerint…".

#### 7.3.1 AI-hívások lista és rekord-részlet

- **Sor:** időbélyeg + ID + avatar + felhasználónév + modell-pill + a bemenet rövidített szövege + csatolmány-számláló + (3-pont/chevron). Lábléc: „{N} AI-hívás · összesen {total} · kattints a teljes rekordért." Üres: „Nincs ilyen AI-hívás."
- **3-pont / sorra kattintás → Drawer (3.5): a hívás pontos kimutatása.** A draft elvárása szerint a rekord teljes kontextusa:
  - **Felhasználó**, **modell**, **időbélyeg**, **token** (be/ki), **IP**.
  - **Beállítások:** milyen **képességek voltak bekapcsolva** (webes keresés, kódfuttatás, RAG-források stb.), hőmérséklet, max token.
  - **Adattípus:** milyen típusú volt az adat — **Publikus / Üzleti titok / Személyes / Banktitok** (a reaktív DLP-osztályozásból, 6.4.4).
  - **Kontextus / szöveges bemenet** és **szöveges kimenet** (teljes).
  - **Fájl-bemenet** (csatolt fájlok listája).
  - **Lábléc:** „Beszélgetés megnyitása" + „Rekord export (JSON)".

#### 7.3.2 Rendszeresemények

Táblázat: **ID** · **Típus** · **Művelet** · **Felhasználó · IP** · **Idő**. Típusok (a kód `AUDIT_TYPES`): Login, Modell, Hozzáférés, Beszélgetés, Workflow, Integráció, Beállítás, Adatkezelés. Ide kerül a **bejelentkezések és rendszeresemények naplózása** (6.3.6) — pl. „SCIM provisioning bekapcsolva", „Adatmegőrzés módosítva", „Új modell engedélyezve", „GDPR export — {kérés}". Üres: „Nincs ilyen esemény." Lábléc: „{N} esemény · összesen {total}."

#### 7.3.3 Megőrzés és export

- **Megőrzés:** a Roadmap RFP 7.2 szerint **min. 24 hónap** (backend-policy).
- **Export (D15, eldöntve):** MVP-ben **CSV-export** (3.9 popup, időszak-beállítással) az AI-hívásokra és a rendszereseményekre. A **SIEM-integráció** és a per-rekord JSON-export **későbbi (Basics)**; addig a „SIEM beállítás" gomb „hamarosan" jelölésű.

---

## 8. Képességek

A `Admin` rendszer `Képességek` modulja: a Workspace-ben elérhető képességek beállításai. Ez **vetül ki** a Workspace Ügynökök szakaszára (`WS §7.6`), a Chatbox + menüjére (`WS §8.4`) és a modellválasztóra (`WS §8.9`). Elemek (és fázis): Modellek (MVP), Rendszerprompt (MVP), Általános (MVP), Promptok (Coming → MVP-be emelve, lásd lent), Skillek (MVP), RAGok (MVP), **Sablonok (új)**, Konnektorok (Basics). Az Ügynökök (Basics) és Workflowk (Coming) horgonyát a 8.9 jelöli.

### 8.0 Közös minta: képesség-katalógus

A **Promptok, Skillek, RAGok, Sablonok** azonos mintát követnek (a `CapabilityRow` kiterjesztése). Egyszer definiálom itt; az adott szakaszok csak az eltérést adják meg.

- **PageHead:** cím + leírás; jobbra **„Új {típus}"** gomb → **popup** (`WS §3.7`, **nem** natív `prompt()`).
- **Lista:** soronként ikon + **név** + rövid leírás + **csoport-hozzárendelő** (GroupAssignSelect: „Senki" / „Mindenki" / „{n} csoport") + **státusz-toggle (be/ki)**. A toggle ki állapotban a hozzárendelő letiltott.
- **Sorra/„Megnyitás"-ra kattintva:** a tétel **megnyílik** (modal vagy aloldal), ahol **látni lehet a tartalmát** (mi van beleírva / milyen dokumentumok vannak benne) és **módosítani is lehet** a meglévőt. Mentés → értesítés.
- **Csoport-hozzárendelés** = csoportszintű engedély; a tényleges láthatóságot a 10. RBAC-modell dönti (tagszintű felülírással).
- **Üres állapot:** „Még nincs {típus} — hozz létre egyet."
- **Lábléc-hint:** „A bekapcsolt {típus} automatikusan elérhető a kijelölt csoportoknál."

### 8.1 Modellek és szolgáltatók

A draft a leggranulárisabb itt. Cím „Modellek", leírás „Szolgáltatók, modellek és csoport-hozzáférés."

#### 8.1.1 Szolgáltatók (vendorok) és API-kulcsok

- **Vendor hozzáadása:** „Új szolgáltató" → popup: szolgáltató neve/típusa (OpenAI, Anthropic, Google, Mistral · EU, **self-hosted/on-prem**), és **API-kulcs bekötése** (vendoronként). A kulcs maszkolva tárolódik (backend secret); a felületen csak „beállítva / nincs beállítva" státusz + „Csere".
- **Új modell vagy szolgáltató bevonása konfigurációval, kódmódosítás nélkül** (Roadmap RFP 3.1, knock-out követelmény). Ezt a felület expliciten támogatja.

#### 8.1.2 Elérhető modellek vendoronként

Vendoronként **kiválasztható, mely modellek elérhetők** (engedélyezve a workspace-en). A nem engedélyezett modellek sehol nem jelennek meg. Soronként: modellnév + `{vendor} · EU` (vagy `on-prem`) + engedélyezés-toggle.

#### 8.1.3 Alapértelmezett modell

Az engedélyezett modellek közül **egy alapértelmezett** állítható (az előző lépésekben konfigurált listából). Ezt használja az új beszélgetés, és ezt mutatja a modellválasztó (`WS §8.9`).

#### 8.1.4 Csoport-hozzáférés modellenként (szinkron a Csoportok oldallal)

- **Modellenként** hozzáadható, **melyik csoport** használhatja az adott modellt (GroupAssignSelect vagy pill-lista + „+").
- **Szinkron a Csoportok oldallal (6.2.3/4):** ugyanaz az adat — a Csoportok oldalon csoport felől, itt modell felől szerkeszthető. A két nézet konzisztens.
- **Hatás a Workspace-re (`WS §8.9`):**
  - Ha egy felhasználó csoportja(i) szerint **csak 1 modell** elérhető (jellemzően a default), akkor a chatboxban **nem tudja a modellt választani** (statikus címke).
  - Ha **1-nél több** modell elérhető, akkor a beszélgetés elején **választhat** (`WS §8.9`, az első üzenetig).
- **Banktitok-routing:** a self-hosted on-prem modell **nem felhasználói választás** — automatikus routing kezeli (`WS §8.10`, Banktitok fázistól). A felületen jelölhető, hogy egy modell „on-prem / banktitok-képes".

> **Eltérés a kódtól:** a kód `ModelsPage`-e statikus (a hozzáférés-szerkesztés csak toast). Itt valódi, csoporttal szinkronizált hozzáférés-kezelés kell. A vendor/API-kulcs réteg a kódban nincs — új.

### 8.2 Rendszerprompt

Cím „Rendszerprompt", leírás „Munkaterületi alap-rendszerprompt, csoportonként felülírható."

- **Munkaterületi alap:** egy **fő** rendszerprompt, az egész munkaterületre érvényes. Textarea (mono) + karakterszámláló + „Mentés". Az „Alapértelmezett" csoportok ezt használják.
- **Csoportonkénti felülírás:** csoportonként **újraírható/módosítható, ha kell más**. Soronként **mód-kapcsoló** (Alapértelmezett / Egyedi); „Egyedi"-nél kinyíló textarea + „Alapból másolás" + „Mentés". Az „Egyedi" prompt **teljesen kiváltja** a munkaterületi alapot az adott csoport tagjainál.
- **Több csoport esetén:** az **alapértelmezett csoport** promptja érvényesül (10.5).

### 8.3 Általános

Cím „Általános", leírás „Általános képességek be/ki kapcsolása és csoport-szintű engedélyezés." Az általános képességek (nem Skill/RAG/Prompt/Sablon) listája `CapabilityRow`-ként: ikon + cím + leírás + GroupAssignSelect + master-toggle.

- **Képességek (MVP):** **Webes keresés**, **Modellválasztás** (a chatbeli modellváltás engedélye, `WS §8.9`), **Leaderboard**.
- **Leaderboard (D4):** a használati rangsor **be/ki** kapcsolása és **csoportonkénti láthatósága** (kik látják a Fiók → Saját használatban, 5.4.4). Alapból **OFF**.
- **Nincs** „webes keresés modellválasztás" itt — a draft kiemelte: ez a **Modellek** oldalon van lekezelve (8.1), nem itt.

### 8.4 Promptok

A chatbox **alatt megjelenő** prompt-tételek kezelése (`WS §8.3` prompt-javaslatok forrása). A 8.0 közös minta szerint.

- **Új prompt popup:** **elnevezés** + **a prompt leírása/szövege**.
- **Megnyitva:** látni és módosítani lehet, mi van beleírva.
- **Csoportonkénti assignolás**, **státusz be/ki**.
- **Vetülés a Workspace-re:** a bekapcsolt, a felhasználó csoportjához rendelt promptok jelennek meg a Chatbox alatti **kattintható javaslat-chipekként** (`WS §8.3`).

> **Reconciliáció (D17, eldöntve):** a Promptok a **Képességek modul eleme**. A bekapcsolt, csoporthoz rendelt promptok jelennek meg a Chatbox alatti kattintható javaslat-chipekként (`WS §8.3` „Prompt suggestions"). A `WS §11.2` „Prompt examples" (forgó placeholder ghost-text) **globális** marad az Egyéb alatt (9.2). A teljes user-oldali „mentett prompt könyvtár" marad Coming (Függelék A).

### 8.5 Skillek

Specializált skillek (dokumentum-sablonok, fordítás, képgenerálás) kezelése. A 8.0 közös minta szerint.

- **Új skill popup:** **elnevezés** + **skill leírása**.
- **Megnyitva:** látni/módosítani, mi van beleírva.
- **Csoportonkénti assignolás**, **státusz be/ki**.
- **Pre-built skillek (Roadmap):** Jogi szerződés, vizsgálati jelentés, oktatási anyag, finanszírozói válasz-vázlatok, fordítás, összefoglalás, dokumentum-generálás (HTML/DOCX/XLSX/CSV/MD).

> **Konszolidáció (D18):** a kódban három, átfedő „skill/képesség" felület van (`SkillsPage` stub; `SkillsView`/„Készségek" unmounted; `GeneralCapabilitiesPage`). A te struktúrád ezt **eleve feloldja:** **Általános** (8.3) az általános képességekre, **Skillek** (8.5) a skillekre — két külön elem, harmadik „Készségek" nézet nincs. A struktúrán nincs teendő; csak a duplikált kód-nézetet kell elhagyni.

### 8.6 RAGok

Belső tudásbázisok (RAG-indexek) létrehozása, kezelése. A 8.0 közös minta szerint, **dokumentum-csatolással**.

- **Új RAG popup:** **elnevezés** + **dokumentumok csatolása** + alatta **szabadszöveg** (leírás/kontextus a tudásbázishoz).
- **Megnyitva:** látni, **milyen dokumentumok vannak benne**, és **módosítani a meglévőket** (dokumentum hozzáadása/eltávolítása, szöveg szerkesztése, újraindexelés).
- **Csoportonkénti assignolás**, **státusz be/ki**.
- **Vetülés a Workspace-re:** a bekapcsolt RAG-ok a felhasználó csoportjánál a Chatbe és az Ügynökök szakaszba kerülnek (`WS §7.6`, `WS §9.4`).

### 8.7 Sablonok

**Új elem** (a draftban „Sablonok"; a Roadmap `Elemek` fülön még nincs — lásd 14/D19). Output-/dokumentum-sablonok kezelése. A 8.0 közös minta szerint.

- **Új sablon popup:** **elnevezés** + **a sablon beillesztése** (szöveges sablon, vagy dokumentum-sablon csatolása).
- **Megnyitva:** látni, **mi van beleírva vagy milyen dokumentum van benne**, és **módosítani**.
- **Csoportonkénti assignolás**, **státusz be/ki**.

> **Sablon vs. Skill vs. RAG (tisztázandó):** átfedés van. Javasolt elhatárolás: **RAG** = kérdezhető tudásbázis (forrás-hivatkozással); **Skill** = művelet/eszköz (pl. fordítás, képgen, prezentáció-generálás); **Sablon** = kész **kimeneti formátum/váz**, amit a modell kitölt (pl. jogi szerződés-sablon, vezetői beszámoló-sablon). A kódbeli pre-built skillek egy része (jogi szerződés, vizsgálati jelentés, oktatási anyag) valójában **Sablon**. A pontos határt Bendi döntse el — 14/D19.

### 8.8 Konnektorok

Külső rendszer-integrációk (M365, Dokutár, SZKP/LIZI). A draft: „ezek most is megvannak, csak legyenek interaktívak."

- **Lista:** soronként konnektor (SharePoint, OneDrive, Outlook, Teams, Joomla DMS/Dokutár, SZKP, LIZI, ERP…) + kategória + **státusz** (Csatlakoztatva / Nincs csatlakoztatva) + **„Beállítás" / „Csatlakoztatás"** (interaktív, nem csak címke).
- **Csoportonkénti engedélyezés** (mely csoport használhatja a konnektort).
- **Fázis:** a Roadmap szerint **Basics** (a teljes integráció). MVP-ben a **felület-váz és a státuszkezelés** áll, az élő integrációk Basics-ben élesednek. A banktitok-források (SZKP/LIZI ReportDB read-only) a **Banktitok** fázis (on-prem). Lásd 11.

### 8.9 Ügynökök és Workflowk (fázis-horgony)

- **Ügynökök (Agentek):** a Roadmap szerint **Basics** fázis (Admin-oldali létrehozás/kezelés). MVP-ben az ügynökök csak **kiválaszthatók** a Workspace-en (`WS §7.6`, `WS §8.5`); a **kezelőfelület** (létrehozás, prompt, források, csoport/user hozzáférés — a kód gazdag `AgentDetail`-je) **Basics**. Itt csak a horgony. Függelék A.
- **Workflowk:** a Builder-ben épített folyamatok kezelése a Képességek alatt — **Coming**. Függelék A.

---

## 9. Egyéb

A `Admin` rendszer `Egyéb` modulja: a Workspace-et vezérlő tartalmi konfigurációk, amelyek nem illenek a Képességek alá. Elemek: Greetings, Prompt-példák, Feedbackek, Leaderboard. Mind MVP (a Leaderboard kapcsolóval).

### 9.1 Greetings (köszöntések)

A Chatbox napszakfüggő köszöntésének forrása (`WS §8.2`).

- **Idősávok (time bands):** szerkeszthető lista. Minden sávhoz tartozik **kezdő–záró időpont** (állítható) és **típus** (pl. reggel/délelőtt/dél/délután/este/éjszaka). A draft: „set what are the options to which times".
- **Köszöntés-változatok sávonként:** sávonként **több** köszöntés-szöveg (a `WS §8.2` szerint kb. 3/sáv), `{megszólítás}` változóval. **Új változat hozzáadható** („Új köszöntés" a sávban).
- **Új sáv hozzáadható** (kezdő/záró idő + változatok).
- **Vetülés:** a Workspace új beszélgetésnél véletlenszerűen választ a megfelelő sáv változatai közül (`WS §8.2`).
- **Megjelenés:** sávonként összecsukható blokk; minden változat egy szerkeszthető sor `×`-szel (törlés) és inline szerkesztéssel.

### 9.2 Prompt-példák (prompt examples)

A Chatbox **forgó placeholder** ghost-text mondatai (`WS §8.3`), amelyek a lehetséges használatot illusztrálják (nem kattinthatók).

- **Lista:** szerkeszthető példamondatok; soronként inline szerkesztés + `×`.
- **„Új példa"** hozzáadható.
- **Megkülönböztetés:** ez NEM a Promptok (8.4, kattintható javaslat-chipek). A Prompt-példák a placeholderben forognak; a Promptok a Chatbox alatt kattinthatók. A `WS §8.3` mindkettőt nevesíti; a management itt (példák) és a Képességek → Promptok (8.4, javaslatok) alatt van.

### 9.3 Feedbackek

Minden beküldött visszajelzés **auditszerűen listázva**. Ide futnak be:

- a Workspace bal panel **visszajelzés-űrlapja** (`WS §7.9`), és
- az output **Tetszik/Nem tetszik** visszajelzései és azok szabadszöveges kommentjei (`WS §9.3`).

- **Lista (audit-stílus):** időbélyeg · felhasználó · típus (Visszajelzés / Tetszik / Nem tetszik) · kontextus (melyik beszélgetés/output, ha van) · szabadszöveg. **Kereshető, szűrhető** (típus, idő), **exportálható** (CSV, 3.9).
- **Csak olvasható** (nincs szerkesztés). A thumbs up/down arány az Analitikába is beszámít (7.1.2).

### 9.4 Leaderboard (kapcsoló és láthatóság)

A Saját használat alatti Leaderboard (5.4.4) **bekapcsolása és láthatóságának beállítása** itt történik (a draft: „ezt az egyébnél lehet majd beállítani a leaderboard menüpont alatt, hogy kinek lehet ezt látnia").

- **Bekapcsolás:** master-toggle (alapból **OFF**; bekapcsolása a vezetőséggel egyeztetve).
- **Láthatóság:** **kik láthatják** a leaderboardot — mindenki, vagy csak kijelölt csoportok (GroupAssignSelect).
- **Anonimizálás (best practice):** opció, hogy a rangsor **névvel** vagy **anonimizáltan** (csoport/álnév) jelenjen meg. Lásd 14/D4.
- **Adatalap:** elmúlt 30 nap, token-alapú rangsor (5.4.4).

---

## 10. Jogosultsági modell (RBAC) és öröklődés

Ez a fejezet a teljes engedély-öröklődést rögzíti. **Kritikus**, mert a draft több edge case-t nevesített, és a kód három rétegű, részben definiálatlan modellt használ. Ez a fejezet a kanonikus.

### 10.1 A három réteg és az effektív érték

Egy képesség (általános képesség, Skill, RAG, Prompt, Sablon, modell-hozzáférés) tényleges állapotát egy felhasználónál három réteg adja, az alábbi precedenciával (fentről erősebb):

1. **Tagszintű felülírás** (6.1.4, hárompozíciós kapcsoló): ha **Be** vagy **Ki**, ez **dönt** (felülír mindent). Ha **Csoport** (öröklés), tovább a 2. réteghez.
2. **Csoport-hozzárendelések uniója:** a felhasználó **összes** csoportját nézzük; ha **bármelyik** csoportban a képesség **be** van, akkor a képesség **be** (logikai VAGY / unió).
3. **Workspace-alap:** ha a képesség workspace-szinten ki van kapcsolva, akkor mindenkinél ki (a 2. réteg sem kapcsolhatja be).

> **Formálisan:** `effektív = (tag == Be) ? be : (tag == Ki) ? ki : VAGY(csoportok hozzárendelései)`, a workspace-engedély által felülről korlátozva.

### 10.2 A draft két edge case-e (levezetve)

- **(A) Unió több csoportnál:** funkció „A" csoportban be → kikapcsolom „A"-ban, de „B" csoportban (ahol a user szintén tag) be van → a usernél **be marad**. *Indok:* 10.1/2. réteg (unió). ✔
- **(B) Tagszintű „Be" erősebb:** funkció a csoportnál be → a tagnál a kapcsolót Csoport→**Be**-re állítom → a csoportnál kikapcsolom → a tagnál **be marad**. *Indok:* 10.1/1. réteg (tag-override felülírja a csoportot). ✔

### 10.3 Modell-hozzáférés öröklődése

A modell-hozzáférés ugyanezt az **uniós** logikát követi: ha a felhasználó bármelyik csoportja hozzáfér egy modellhez, a felhasználó használhatja. Ennek a Workspace-re gyakorolt hatása (1 vs. >1 elérhető modell → modellválasztó tiltva/engedélyezve): 8.1.4, `WS §8.9`. A hozzáférés a Modellek (8.1) és a Csoportok (6.2.3) oldalon szinkronban szerkeszthető.

### 10.4 Token-keret öröklődése

A havi token-keret tag- és csoportszinten állítható (6.1.4, 6.2.3). Precedencia:

1. **Tagszintű explicit keret** felülír (ha be van állítva).
2. Egyébként a **csoport-keret**; több csoport esetén a **legmagasabb** (legmegengedőbb) keret érvényes — konzisztensen a 10.1 uniós elvvel.
3. Egyébként a **workspace-alapkeret** (vagy korlátlan).

**Túllépés viselkedése (D22, eldöntve):** a havi keret **80%-ánál** a felhasználó **értesítést** kap; a keret **elérésekor (100%) kemény blokk** — nem küldhet több üzenetet, amíg az admin keretet nem emel, vagy új hónap nem indul. A kihasználtság a Használatban látszik (7.2.2).

> **Döntés (D20, eldöntve):** több csoport esetén a **legmagasabb** (megengedő) keret érvényes. A tagszintű explicit keret mindig felülír.

### 10.5 Alapértelmezett csoport (rendszerprompthoz)

A csoportszintű **rendszerprompt** (8.2) nem uniózható (egy prompt érvényes). Ezért minden tagnak van egy **alapértelmezett csoportja** (a kód „Alapértelmezett" terminológiájával összhangban — D16, eldöntve):

- A tag profiljában (6.1.4) egy **„Alapértelmezett csoport"** jelölő. Alapérték: az **Általános** csoport (mindenki tagja), illetve az AD elsődleges szervezeti csoportja, ha van.
- A tagra a **saját alapértelmezett csoportjának** rendszerprompja érvényesül. Ha az alapértelmezett csoport „Alapértelmezett" módban van (nem egyedi), a munkaterületi alap-prompt él (8.2).
- A kódban nincs explicit jelölés (csak `groups[]` tömb); ezt be kell vezetni.

### 10.6 Szerep (Admin/Member) vs. képességek

- A **szerep bináris** (Admin/Member, 4.3). A szerep **csak** azt dönti el, hogy a felhasználó látja-e az Admin rendszert. A „ki mit használhat a chatben" a **képesség/csoport** rétegből jön (10.1), nem a szerepből.
- **Nincs** külön „Szerepek" oldal / jogosultság-mátrix MVP-ben (a kódbeli `RolesPage` orphan és Manager-szintet vezet be, ami nincs a tag-modellben). Lásd 14/D14 és Függelék A.

### 10.7 Felfüggesztés

A felfüggesztett (suspended) tag **nem tud belépni** (SSO blokk), a munkamenetei lezárhatók (6.3.4). A felfüggesztés a státuszban „Felfüggesztve" (6.1.3). A képesség/keret-beállításai megmaradnak (visszakapcsoláskor élnek). **Eltávolítás nincs** (csak AD-deprovisionálás → a tag kikerül a szinkronból).

---

## 11. Fázis-besorolás (roadmap-illesztés)

A `kavosz-ai` skill előírja: minden elemet a Roadmaphoz kell horgonyozni. Az alábbi tábla a Beállítások/Admin elemeket a Roadmap `Elemek`/`Fázisok` szerint sorolja be. **A spec MVP-fókuszú**; a Basics/Coming elemeket csak horgonyként tartalmazza.

| Elem (spec §) | Rendszer | Modul | Fázis | MVP-státusz a specben |
|---|---|---|---|---|
| Profil, Preferenciák, Értesítések, Saját használat, Első lépések (5) | Workspace | Fiók | **MVP** | Teljes |
| Leaderboard (5.4.4, 8.3) | Workspace+Admin | Fiók+Képességek/Általános | **MVP** | Kapcsoló az Általánosban, csoport-láthatóság, alap OFF (D4) |
| Tagok (6.1) | Admin | Adminisztráció | **MVP** | Teljes |
| Csoportok (6.2) | Admin | Adminisztráció | **MVP** | Teljes |
| Biztonság (6.3) | Admin | Adminisztráció | **MVP** | Teljes (karcsúsított) |
| Adatvédelem (6.4) | Admin | Adminisztráció | **MVP*** | Teljes. *Új elem, 14/D10/D19 |
| Szabályzat (6.5) | Workspace+Admin | Onboarding+Adminisztráció | **MVP** | Teljes |
| Analitika (7.1) | Admin | Kimutatások | **MVP** | Teljes |
| Használat (7.2) | Admin | Kimutatások | **MVP** | Teljes |
| Auditnapló (7.3) | Admin | Kimutatások | **MVP** | Teljes |
| Modellek (8.1) | Admin | Képességek | **MVP** | Teljes (vendor/API-kulcs új) |
| Rendszerprompt (8.2) | Admin | Képességek | **MVP** | Teljes |
| Általános (8.3) | Admin | Képességek | **MVP** | Teljes |
| Skillek (8.5) | Workspace+Admin | Chat+Képességek | **MVP** | Teljes |
| RAGok (8.6) | Admin | Képességek | **MVP** | Teljes |
| Promptok (8.4) | Workspace+Admin | Panel+Képességek | Coming → **MVP-be emelt** | Csoport-assignolható javaslatok MVP; teljes prompt-könyvtár Coming. 14/D17 |
| Sablonok (8.7) | Admin | Képességek | **MVP*** | *Új elem, 14/D19 |
| Konnektorok (8.8) | Workspace+Admin | Képességek | **Basics** | Csak váz MVP-ben; integráció Basics |
| Greetings, Prompt-példák, Feedbackek (9) | Admin | Egyéb | **MVP** | Teljes |
| Ügynökök/Agentek (8.9) | Workspace+Admin | Panel+Képességek | **Basics** | Horgony; kezelőfelület Basics |
| Workflowk/Folyamatok (8.9) | Admin/Builder | Képességek/Builder | **Coming** | Horgony |
| Embeddings | Admin+Embeddings | Embeddings | **Ügyfél & Ügyintéző** | Hatókörön kívül |

> **Konfliktus-jelzés (a `kavosz-ai` skill szerint):** három elem **nincs vagy nem MVP** a Roadmapen, de a draft MVP-be teszi: **Adatvédelem** (új elem), **Sablonok** (új elem), **Promptok** (Coming). Ezeket a Roadmap `Elemek`/`Featureök` fülén rögzíteni kell, hogy a sheet maradjon a single source of truth. A **Konnektorok** Basics, a draft viszont „most is megvannak" alapon MVP-vázat kér — ez konzisztens (váz MVP, integráció Basics). Lásd 14/D17, D19.

---

## 12. Függelék A: Halasztott és hatókörön kívüli funkciók

Az alábbi admin-érintett felületek a kódban léteznek vagy a Roadmap későbbi fázisába tartoznak; **ebből a spec MVP-fókuszából kimaradnak** (csak horgony).

| Funkció | Roadmap-besorolás | Hol van a kódban | Megjegyzés |
|---|---|---|---|
| **Szerepek (jogosultság-mátrix)** | Nincs MVP-ben | `admin.jsx` `RolesPage` (orphan) | Háromszintű Member/Manager/Admin mátrix. MVP: bináris szerep (4.3, 10.6). Lásd 14/D14. |
| **Ügynök-kezelő (létrehozás/szerkesztés)** | Basics | `agents.jsx` (`AgentsView`, `AgentDetail`) | MVP-ben csak kiválasztás a Workspace-en (`WS §7.6`). |
| **Workflowk / Builder (Folyamatok)** | Coming | `workflows.jsx`, Builder | Vizuális workflow-építő + a Képességek alatti workflow-kezelés. |
| **Embeddings admin** | Ügyfél & Ügyintéző | (nincs külön modul a kódban) | Beágyazott modulok (ügyfél/ügyintéző chat, meeting-összefoglaló) admin beállításai. |
| **Mentett Promptok (teljes könyvtár)** | Coming | `secondary.jsx` `PromptsView` (unmounted) | A csoport-assignolható javaslat-promptok MVP-ben (8.4); a teljes user-könyvtár Coming. |
| **Integrációk marketplace** | Basics+ | `secondary.jsx` `IntegrationsView` (unmounted) | A Konnektorok MVP-váza (8.8) ezt részben kiváltja. |
| **Output-oldali DLP** | Coming | – | A válasz szűrése kiküldés előtt (RFP 7.3). |
| **Számlázás/Billing önálló oldalként** | – | `settings.jsx` `BillingPage` | Beolvad a Használatba (7.2.2). A fizetés az appon kívül. |

---

## 13. Függelék B: Eltérések a jelenlegi kódtól

A fejlesztőknek a demóhoz képest a következő érdemi változásokat kell megvalósítaniuk (nem teljes diff):

1. **Brand-szín:** a régi `#0B6D78` helyett a kanonikus `brand-700 = #006159` (és a teljes `WS §3.1` skála) az admin minden zöldjére.
2. **Rail / ⌘K / szekciócímkék egységesítése** a 4.2 szerint (a kód három eltérő csoportosítást használ). A „Beállítások" railben: Fiók / Adminisztráció / Kimutatások / Képességek / Egyéb.
3. **Tagok:** „Meghívás" és „CSV import" gombok **eltávolítása**; csak „Export". Az „Eltávolítás" tagművelet **felfüggesztésre** cserélve. A halott `memberPerms` állapot elhagyása (egyetlen igaz override-út: tagszintű, 10.2).
4. **Egy görgő szabálya (3.2):** a Tagok (és minden admin-tábla) az **oldal** görgetőjével görög, nincs külön lista-scroll.
5. **Biztonság karcsúsítása:** a kódbeli „Szabályzat" tab **kikerül** a Biztonságból (a Szabályzat önálló elem, 6.5); a szervezeti konfiguráció a jobb felső sarokba kerül (6.3.2); a halott (no-op) toggle-ök funkcionálissá vagy elrejtve.
6. **Adatvédelem:** **új oldal** (6.4) — a kódban nincs.
7. **Natív `prompt()` megszüntetése:** a RAG- és Szabályzat-feltöltés (és minden létrehozás) **modallal/popuppal** (`WS §3.7`), nem böngésző-prompttal.
8. **Analitika vs. Használat szétválasztása:** Analitika **token nélkül** (7.1); a token-chart átkerül a Használatba. A két, „Használat" címmel futó oldal (személyes `usage` és admin `billing`) **egyértelmű szétválasztása**: „Saját használat" (Fiók, 5.4) vs. „Használat" (Kimutatások, 7.2).
9. **Modellek:** vendor + API-kulcs réteg hozzáadása (8.1.1); a hozzáférés valódi, csoporttal szinkronizált kezelése (a kód statikus).
10. **Skill/Capabilities konszolidáció:** egyetlen modell (Általános 8.3 + Skillek 8.5); a duplikált „Készségek"/`SkillsView` elhagyása (8.5).
11. **Sablonok:** új Képesség-elem (8.7).
12. **Export-popup (3.9):** minden CSV/JSON export időszak-választó popupon át; a stub export-gombok funkcionálissá tétele (vagy egyértelmű „hamarosan").
13. **Onboarding-számláló egységesítése** (5.5): egyetlen forrás a 7 helyett/9/5 helyett.
14. **Engedély-öröklődés (10):** a hárompozíciós kapcsoló + unió + tag-override precedencia explicit implementációja; alapértelmezett csoport bevezetése (10.5).

---

## 14. Döntési napló (lezárva)

A 0.1-es kérdéseket Bendi megválaszolta; az alábbi a lezárt állapot, a spec-helyekre hivatkozva. Minden döntés lezárva.

**Felület és navigáció**

- **D1 — Szekciócímkék:** eldöntve, **igen.** Rail/⌘K/belépők egységesen: Fiók / Adminisztráció / Kimutatások / Képességek / Egyéb (4.2).
- **D21 — Admin nyitóoldal:** **nem kell.** Mindenki a Fiókot látja; az admin ráadásként látja a többi szekciót, külön admin-dashboard nyitóoldal nélkül (4.3).

**Fiók**

- **D2 — Munkakör:** **csak olvasható** (Entra ID/SCIM); a csoporttagság is csak olvasható itt, az adminban szerkeszthető (5.1).
- **D3 — Értesítés-típusok:** a felhasználó **kizárólag a „Kész chat"** értesítést állíthatja (in-app/e-mail). Minden más értesítés fix, alapértelmezett, nem felhasználó-állítható (5.3).
- **D4 — Leaderboard:** kapcsoló + csoport-láthatóság a **Képességek → Általános** alatt (8.3), megjelenés a Saját használatban (5.4.4), alap **OFF**. Anonimizált mód: **nem kell** (a „10 no need" alapján).
- **D5 — Onboarding-számláló:** **egy forrás.** *(„Egy forrás" = a `WS §6` 9 lépésének közös teljesültségi állapota, amit az Első lépések, a panel-progress és a túra együtt olvas, így mindenhol ugyanaz a %. A kódban most 3 eltérő számláló fut, 5.5.)*

**Adminisztráció — Tagok / Csoportok**

- **D6 — Tagok:** eldöntve. Nincs meghívás / CSV / hozzáadás / törlés; csak Export és Felfüggesztés (6.1.1).
- **D7 — Státusz:** **„Meghívott" sárgával** (Aktív / Meghívott / Felfüggesztve), 6.1.3.
- **D16 — Alapértelmezett csoport:** rövidebb néven **„alapértelmezett csoport"** (a kód „Alapértelmezett" terminológiája), nem „elsődleges"; alap: Általános (10.5).
- **D20 — eldöntve: a legmagasabb (megengedő) keret** érvényes több csoport esetén; a tagszintű explicit keret mindig felülír (10.4).
- **D22 — Token-keret túllépés:** **80%-nál értesítés, 100%-nál kemény blokk** (10.4).

**Adminisztráció — Biztonság / Adatvédelem / Szabályzat**

- **D8 — Biztonság:** **SSO-only.** Nincs jelszó-/IP-kezelés; marad SSO/SCIM/SIEM + felhasználói tábla + munkamenet-kezelés + szokatlan-használat-jelzés (6.3).
- **D9 — Megőrzés:** **örökre, alapból, beállítás nélkül** (6.3.2).
- **D10 — Elnevezés:** **„Adatvédelem"** (6.4).
- **D24 — Banktitok-jelző:** feltöltési kísérlet → „módosítsd a promptot" értesítés, auditba logolva output nélkül, 1 piros jelzés/felhasználó, gördülő 7 napos ablakban lecseng (6.4.2).
- **D11 — Szabályzat:** a szabályzat az **onboarding 1. lépése**, ugyanaz a popup-megjelenés; **az admin állítja, melyik fájl nyílik** (böngészőben is megnyílhat). Új szabályzat feltöltésekor **azonnal felugrik** minden még-nem-elfogadónál, **kötelező elfogadás, nincs elutasítás** (6.5.4).
- **D12 — Elfogadási státusz:** **„Függőben"** (vs. „Elfogadva"), 6.5.3. *(A „még nem fogadta el" állapot iparági neve „Függőben"; a kód is ezt használja.)*

**Kimutatások**

- **D13 — Használat:** **token ÉS költség (Ft) is**; a Billing beolvad (7.2.2).
- **D15 — Audit export:** **CSV** MVP-ben; SIEM/JSON Basics (7.3.3).

**Képességek**

- **D14 — Szerepek oldal:** **nincs külön oldal** MVP-ben; bináris Admin/Member + képesség/csoport-réteg (4.3, 10.6). A Képességek modul tartalma a draft szerint (8). *(A 14-es válaszban a teljes Képességek-draftot beillesztetted; a 8. fejezet ezzel egyezik.)*
- **D17 — Promptok:** **a Képességek modul eleme** (8.4); a bekapcsolt, csoporthoz rendelt promptok adják a chatbox alatti javaslat-chipeket.
- **D18 — eldöntve (megerősítve a Képességek-draft újraküldésével):** Általános ≠ Skillek, nincs harmadik „Készségek" nézet; a 8. fejezet a draft szerinti struktúra (Általános, Promptok, Skillek, RAGok, Sablonok, Konnektorok). A duplikált kód-nézet elhagyandó (8.5).
- **D19 — Sablonok:** **megtartva külön elemként** (8.7). Elhatárolás: RAG = kérdezhető tudásbázis, Skill = művelet/eszköz, Sablon = kimeneti váz.

**Egyéb**

- **D23 — Feedbackek:** **tiszta audit-lista** MVP-ben (9.3).

**Nyitott teendők**

1. Roadmap `Elemek` fül kiegészítése új sorokkal: **Adatvédelem**, **Sablonok**, **Leaderboard**, **Promptok** (rendszer/modul/fázis). Csak jelzem; a sheetet engedély nélkül nem írom.

---

*A dokumentum vége. Verzió 1.0 (fejlesztésre kész), 2026-06-17. Minden döntés lezárva.*

