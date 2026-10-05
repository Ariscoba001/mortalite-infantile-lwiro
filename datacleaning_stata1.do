/*=======================================================================
*
*   Projet : Logiciels Statistiques (STATA & SPSS) – ISE2 – 2026
*   Objet  : Apurement et préparation de la base de données
*   Groupe : STATA 1
*   Enseignant : M. Dyvail Junior OLOUMANE
*
*=======================================================================*/


/*-----------------------------------------------------------------------
*   I. CRÉATION DE L'ENVIRONNEMENT DE TRAVAIL
*-----------------------------------------------------------------------*/

* Définition du répertoire de travail
global dir "CHEMIN\VERS\LE\DOSSIER\DE\TRAVAIL"  // a adapter
cd "$dir"

* Ouverture du fichier log
capture log close
log using "datacleaning_stata1.log", replace text


/*-----------------------------------------------------------------------
*   II. COLLECTE DES DONNÉES : CHARGEMENT ET STANDARDISATION
*
*   Les données sont réparties en dix bases de formats variés
*   (.dta, .xls, .xlsx, .sav). Avant de les fusionner, chaque base
*   est standardisée selon le dictionnaire de données.
*
*   Observation préalable sur les variables alb et durhosp :
*   L'exploration des bases révèle que la variable "alb" (albumine
*   sérique en g/L) correspond exactement à la variable N°4 du
*   dictionnaire, tant par ses valeurs [4,9–53,6] que par son type.
*   La variable "durhosp" présente dans les fichiers bruts est quant
*   à elle hors dictionnaire. Elle est donc supprimée, et "alb" est
*   renommée en "durhosp" pour respecter le code officiel.
*   Les variables "ivri" et "var" sont également hors dictionnaire
*   et supprimées systématiquement.
*-----------------------------------------------------------------------*/

* ── Base 1 : enfant1.dta (observations 1 à 100) ─────────────────────
use "enfant1.dta", clear
sort id

drop var ivri durhosp
rename alb durhosp

save "enfant1_clean.dta", replace


* ── Base 2 : enfant2.dta (observations 101 à 150) ───────────────────
use "enfant2.dta", clear
sort id

* La variable "sexe" est nommée "sexee" dans cette base
rename sexee sexe

drop var ivri durhosp
rename alb durhosp

save "enfant2_clean.dta", replace


* ── Base 3 : enfant3.dta (observations 151 à 300) ───────────────────
use "enfant3.dta", clear
sort id

* La variable "v18" est nommée "v17" dans cette base
rename v17 v18

* La variable "cheveux" est absente du dictionnaire
drop cheveux ivri durhosp
rename alb durhosp

save "enfant3_clean.dta", replace


* ── Base 4 : enfant4.dta (observations 301 à 400) ───────────────────
use "enfant4.dta", clear
sort id

* La variable "etum" est nommée "etumm" dans cette base
rename etumm etum

* Certaines variables sont stockées en chaîne de caractères
destring id oed durhosp pbr, replace

drop ivri durhosp
rename alb durhosp

save "enfant4_clean.dta", replace


* ── Base 5 : enfant5.dta (observations 401 à 475) ───────────────────
use "enfant5.dta", clear
sort id

* La variable "etat" est nommée "etat_deces" dans cette base
rename etat_deces etat

* La plupart des variables sont en chaîne de caractères dans cette base
destring id rang sitmatm oed ivri diar peau mala v18 durhosp etat pbr, replace

drop var ivri durhosp
rename alb durhosp

save "enfant5_clean.dta", replace


* ── Base 6 : enfant6.xls (observations 476 à 600) ───────────────────
import excel "enfant6.xls", firstrow clear
sort id

* La variable "diar" est nommée "diarrhee" dans cette base
rename diarrhee diar

drop ivri durhosp
rename alb durhosp

save "enfant6_clean.dta", replace


* ── Base 7 : enfant7.xlsx (observations 601 à 700) ──────────────────
import excel "enfant7.xlsx", firstrow clear
sort id

drop ivri durhosp
rename alb durhosp

save "enfant7_clean.dta", replace


* ── Base 8 : enfant8.sav (observations 701 à 800) ───────────────────
import spss "enfant8.sav", clear
sort id

drop ivri durhosp
rename alb durhosp

save "enfant8_clean.dta", replace


* ── Base 9 : enfant9.sav (observations 801 à 900) ───────────────────
import spss "enfant9.sav", clear
sort id

rename etat_deces etat

drop ivri durhosp
rename alb durhosp

save "enfant9_clean.dta", replace


* ── Base 10 : enfant10.sav (observations 901 à 1129) ────────────────
import spss "enfant10.sav", clear
sort id

drop var ivri durhosp
rename alb durhosp

save "enfant10_clean.dta", replace


/*-----------------------------------------------------------------------
*   III. CONCATÉNATION DES DIX BASES
*-----------------------------------------------------------------------*/

use "enfant1_clean.dta", clear

append using      ///
    "enfant2_clean.dta"  ///
    "enfant3_clean.dta"  ///
    "enfant4_clean.dta"  ///
    "enfant5_clean.dta"  ///
    "enfant6_clean.dta"  ///
    "enfant7_clean.dta"  ///
    "enfant8_clean.dta"  ///
    "enfant9_clean.dta"  ///
    "enfant10_clean.dta"

sort id
describe
codebook

save "enfant_concat.dta", replace


/*-----------------------------------------------------------------------
*   IV. IDENTIFICATION ET GESTION DES DOUBLONS
*-----------------------------------------------------------------------*/

duplicates report
duplicates list

* Repérage des doublons sur l'identifiant
by id : gen doublon = cond(_N == 1, 0, _n)
tab doublon

* On conserve le premier exemplaire de chaque doublon
drop if doublon > 1
drop if id == .
drop doublon

save "enfant_concat.dta", replace


/*-----------------------------------------------------------------------
*   V. FUSION AVEC LA BASE CSD
*
*   La base CSD.dta contient les variables socio-démographiques
*   (sexe, age, etum, sitmatm, rang) pour l'ensemble des individus.
*   On l'utilise pour compléter les variables manquantes dans la base
*   concaténée, sans écraser les valeurs déjà renseignées.
*----------------------------------------------------------------------*/

* Préparation de la base CSD
use "CSD.dta", clear
sort id

destring id sexe age etum rang, replace

* La variable sitmatm est stockée en libellé dans CSD — recodage numérique
gen sitmatm_num = .
replace sitmatm_num = 0 if sitmatm == "célibataire"
replace sitmatm_num = 1 if sitmatm == "mariée"
replace sitmatm_num = 2 if sitmatm == "polygamie"
replace sitmatm_num = 3 if sitmatm == "veuve/veuf"
drop sitmatm
rename sitmatm_num sitmatm

keep id sexe age etum sitmatm rang

rename sexe    sexe_csd
rename age     age_csd
rename etum    etum_csd
rename sitmatm sitmatm_csd
rename rang    rang_csd

save "CSD_clean.dta", replace


* Fusion 1:1 sur l'identifiant
use "enfant_concat.dta", clear
merge 1:1 id using "CSD_clean.dta"
tab _merge

* Complétion des valeurs manquantes depuis CSD
replace sexe    = sexe_csd    if missing(sexe)    & !missing(sexe_csd)
replace age     = age_csd     if missing(age)     & !missing(age_csd)
replace etum    = etum_csd    if missing(etum)    & !missing(etum_csd)
replace sitmatm = sitmatm_csd if missing(sitmatm) & !missing(sitmatm_csd)
replace rang    = rang_csd    if missing(rang)    & !missing(rang_csd)

drop sexe_csd age_csd etum_csd sitmatm_csd rang_csd _merge

save "enfants_work.dta", replace


/*-----------------------------------------------------------------------
*   VI. DIAGNOSTIC DES VALEURS MANQUANTES
*-----------------------------------------------------------------------*/

use "enfants_work.dta", clear
misstable summarize


/*-----------------------------------------------------------------------
*   VII. IDENTIFICATION ET GESTION DES VALEURS ABERRANTES
*
*   On écarte toute valeur en dehors des plages définies dans le
*   dictionnaire de données, en la remplaçant par une valeur manquante
*   qui sera ensuite imputée à l'étape suivante.
*-----------------------------------------------------------------------*/

* durhosp — albumine sérique [4,9 – 53,6 g/L]
replace durhosp = . if durhosp < 4.9  | durhosp > 53.6

* age — âge à l'admission [0 – 199 mois]
replace age = . if age < 0 | age > 199

* pbr — périmètre brachial [70 – 252 mm]
replace pbr = . if pbr < 70 | pbr > 252

* rang — rang dans la fratrie [1 – 17]
replace rang = . if rang < 1 | rang > 17

* sitmatm — situation matrimoniale [0 – 3]
replace sitmatm = . if sitmatm < 0 | sitmatm > 3

* sexe [1 – 2]
replace sexe = . if sexe < 1 | sexe > 2

* v18 — classification de Waterlow [0 – 2]
replace v18 = . if v18 < 0 | v18 > 2

* Variables dichotomiques [0 – 1]
foreach var of varlist oed diar peau mala {
    replace `var' = . if `var' != 0 & `var' != 1
}

misstable summarize

save "enfants_work.dta", replace


/*-----------------------------------------------------------------------
*   VIII. IMPUTATION DES VALEURS MANQUANTES RÉSIDUELLES
*
*   Le choix de la méthode d'imputation tient compte du type de variable
*   et du taux de valeurs manquantes observé :
*     – Médiane pour les variables quantitatives (distributions asymétriques)
*     – Mode pour les variables qualitatives à faible taux de VM (< 10%)
*     – Tirage aléatoire selon la distribution empirique pour etum et v18,
*       dont les taux de VM sont plus élevés (respectivement ~23% et ~10%)
*-----------------------------------------------------------------------*/

use "enfants_work.dta", clear

* ── Variables quantitatives — imputation par la médiane ──────────────

sum durhosp, detail
replace durhosp = r(p50) if missing(durhosp)

sum pbr, detail
replace pbr = r(p50) if missing(pbr)

sum age, detail
replace age = r(p50) if missing(age)

sum rang, detail
replace rang = r(p50) if missing(rang)

* ── Variables qualitatives à faible taux de VM — mode ────────────────

* Mode = 0 pour les variables dichotomiques suivantes
foreach var of varlist oed diar peau mala {
    replace `var' = 0 if missing(`var')
}

replace sexe    = 1 if missing(sexe)     // mode : garçon
replace sitmatm = 0 if missing(sitmatm)  // mode : célibataire

* ── etum (~23% de VM) — tirage aléatoire selon distribution empirique ─
*
*   Distribution observée sur les non-manquants :
*       Pas d'étude (0)     : 64,70 %
*       Primaires (1)        : 16,90 %
*       Secondaires et + (2) : 18,40 %

set seed 20260611

gen u = runiform() if missing(etum)
replace etum = 0 if missing(etum) & u <  0.6470
replace etum = 1 if missing(etum) & u >= 0.6470 & u < 0.8360
replace etum = 2 if missing(etum) & u >= 0.8360
drop u

* ── v18 (~10% de VM) — tirage aléatoire selon distribution empirique ─
*
*   Distribution observée sur les non-manquants :
*       À risque (0)              : 70,60 %
*       À haut risque (1)         : 29,20 %
*       À très haut risque (2)    :  0,20 %

gen u = runiform() if missing(v18)
replace v18 = 0 if missing(v18) & u <  0.7060
replace v18 = 1 if missing(v18) & u >= 0.7060 & u < 0.9980
replace v18 = 2 if missing(v18) & u >= 0.9980
drop u

* Vérification : aucune valeur manquante ne doit subsister
misstable summarize

save "enfants_work.dta", replace


/*-----------------------------------------------------------------------
*   IX. RECODAGE DE LA VARIABLE DÉPENDANTE
*
*   Conformément à la consigne de l'encadreur, la valeur 1 désigne
*   la présence de l'événement étudié, c'est-à-dire le décès.
*   Dans les données brutes, etat = 1 correspond à "vivant" — on
*   procède donc à une inversion.
*-----------------------------------------------------------------------*/

use "enfants_work.dta", clear

tab etat

gen etat_new = 1 - etat
drop etat
rename etat_new etat

* Vérification : les décédés (~17,5%) doivent être codés 1
tab etat

save "enfants_work.dta", replace


/*-----------------------------------------------------------------------
*   X. ÉTIQUETAGE DES VARIABLES ET DES MODALITÉS
*-----------------------------------------------------------------------*/

use "enfants_work.dta", clear

label variable id       "Identifiant de l'enfant"
label variable etat     "État de l'enfant à la sortie (1=Décédé, 0=Vivant)"
label variable pbr      "Périmètre brachial (en mm)"
label variable age      "Âge à l'admission (en mois)"
label variable durhosp  "Albumine sérique (en g/L)"
label variable sitmatm  "Situation matrimoniale de la mère"
label variable sexe     "Sexe de l'enfant"
label variable etum     "Niveau d'étude de la mère"
label variable oed      "Situation des œdèmes"
label variable rang     "Rang de l'enfant dans la fratrie"
label variable diar     "Diarrhée à l'admission"
label variable peau     "Pli cutané sous-scapulaire à l'admission"
label variable mala     "Paludisme à l'admission"
label variable v18      "Classification de Waterlow (risque d'escarre)"

capture label drop etat_lbl
label define etat_lbl 0 "Vivant" 1 "Décédé"
label values etat etat_lbl

capture label drop sexe_lbl
label define sexe_lbl 1 "Garçon" 2 "Fille"
label values sexe sexe_lbl

capture label drop sitmatm_lbl
label define sitmatm_lbl 0 "Célibataire" 1 "Mariée" 2 "Polygamie" 3 "Veuve/Veuf"
label values sitmatm sitmatm_lbl

capture label drop etum_lbl
label define etum_lbl 0 "Pas d'étude" 1 "Primaires" 2 "Secondaires et plus"
label values etum etum_lbl

capture label drop oed_lbl
label define oed_lbl 0 "Absence" 1 "Présence"
label values oed oed_lbl

capture label drop diar_lbl
label define diar_lbl 0 "Non" 1 "Oui"
label values diar diar_lbl

capture label drop peau_lbl
label define peau_lbl 0 "Non" 1 "Oui"
label values peau peau_lbl

capture label drop mala_lbl
label define mala_lbl 0 "Non" 1 "Oui"
label values mala mala_lbl

capture label drop v18_lbl
label define v18_lbl 0 "Enfant à risque" 1 "Enfant à haut risque" 2 "Enfant à très haut risque"
label values v18 v18_lbl

save "enfants_work.dta", replace


/*------------------------------------
*   XI. CATÉGORISATIONS
------------------------------------*/

use "enfants_work.dta", clear

* Albumine sérique recodée en trois catégories
recode durhosp                          ///
    (4/22.99  = 0)                    ///
    (23/29.99 = 1)                    ///
    (30/55    = 2)

label define durhosp_lbl 0 "< 23 g/L" 1 "23-29.99 g/L" 2 "≥ 30 g/L", replace
label values durhosp durhosp_lbl
label variable durhosp "Albumine sérique catégorisée (g/L)"
tab durhosp

* Périmètre brachial recodé en trois catégories
recode pbr                               ///
    (70/124.99  = 1)                   ///
    (125/134.99 = 2)                   ///
    (135/252    = 3)

label define pbr_lbl 1 "< 125 mm" 2 "125-134 mm" 3 "≥ 135 mm", replace
label values pbr pbr_lbl
label variable pbr "Périmètre brachial catégorisé (mm)"
tab pbr

* Rang dans la fratrie recodé en trois catégories
recode rang                              ///
    (1/2  = 1)                         ///
    (3/4  = 2)                         ///
    (5/17 = 3)

label define rang_lbl 1 "Rang 1-2" 2 "Rang 3-4" 3 "Rang 5+", replace
label values rang rang_lbl
label variable rang "Rang catégorisé dans la fratrie"
tab rang

/*-----------------------------------------------------------------------
*   XII. VÉRIFICATION ET SAUVEGARDE DE LA BASE APURÉE
*-----------------------------------------------------------------------*/

drop id

describe
sum
misstable summarize

save "Bas_apuree.dta", replace

di "Base apurée sauvegardée : " _N " observations, " c(k) " variables"

log close
