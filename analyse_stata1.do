/*=======================================================================
*
*   Projet : Logiciels Statistiques (STATA & SPSS) – ISE2 – 2026
*   Objet  : Analyse des données – Mortalité infantile à Lwiro (1986-1988)
*   Groupe : STATA 1
*   Enseignant : M. Dyvail Junior OLOUMANE
*
*=======================================================================*/


/*-----------------------------------------------------------------------
*   I. ENVIRONNEMENT DE TRAVAIL
*-----------------------------------------------------------------------*/

global dir "CHEMIN\VERS\LE\DOSSIER\DE\TRAVAIL"  // a adapter
cd "$dir"

capture mkdir "Graphiques"
capture mkdir "Resultats"

capture log close
log using "Resultats\analyse_stata1.log", replace text

global c1  "26 82 118"
global c2  "52 143 165"
global c3  "196 110 55"
global c4  "108 117 125"

set scheme s1color


/*-----------------------------------------------------------------------
*   II. CHARGEMENT DE LA BASE ET PRÉPARATION ANALYTIQUE
*-----------------------------------------------------------------------*/

use "Bas_apuree.dta", clear

gen v18_2cat = (v18 >= 1)
label define v18_2cat_lbl 0 "À risque" 1 "Haut / très haut risque"
label values v18_2cat v18_2cat_lbl
label variable v18_2cat "Risque d'escarre (recodé en 2 catégories)"

di "Base chargée – " _N " observations, " c(k) " variables"


/*=======================================================================
*   III. ANALYSE DESCRIPTIVE
*=======================================================================*/

/*-----------------------------------------------------------------------
*   3.1 Variable dépendante
*-----------------------------------------------------------------------*/

tab etat

graph bar (percent), over(etat, label(labsize(medium)))                ///
    bar(1, color("$c2")) bar(2, color("$c3"))                          ///
    blabel(bar, format(%5.1f) size(small) color(white))                ///
    ytitle("Pourcentage (%)", size(medium))                            ///
    title("Répartition des enfants selon leur état à la sortie",       ///
          size(medium))                                                ///
    subtitle("Hôpital de Lwiro, 1986-1988", size(small))              ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\etat_enfant.png", replace width(1200)


/*-----------------------------------------------------------------------
*   3.2 Variables qualitatives
*-----------------------------------------------------------------------*/

* ── Sexe ─────────────────────────────────────────────────────────────
tab sexe
graph pie, over(sexe)                                                  ///
    plabel(_all percent, size(medium) color(white) format(%5.1f))      ///
    pie(1, color("$c1")) pie(2, color("$c2"))                          ///
    title("Répartition par sexe", size(medium))                        ///
    legend(size(small)) graphregion(color(white))
graph export "Graphiques\sexe.png", replace width(1000)


* ── Niveau d'étude de la mère ────────────────────────────────────────
tab etum
graph hbar (percent), over(etum, sort(1) descending                    ///
    label(labsize(small)))                                             ///
    bar(1, color("$c1"))                                               ///
    blabel(bar, format(%5.1f) size(small) color(white))                ///
    ytitle("Pourcentage (%)", size(medium))                            ///
    title("Niveau d'étude de la mère", size(medium))                   ///
    subtitle("Hôpital de Lwiro, 1986-1988", size(small))              ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\niveau_etude_mere.png", replace width(1200)


* ── Situation matrimoniale de la mère ────────────────────────────────
tab sitmatm
graph hbar (percent), over(sitmatm, sort(1) descending                 ///
    label(labsize(small)))                                             ///
    bar(1, color("$c2"))                                               ///
    blabel(bar, format(%5.1f) size(small) color(white))                ///
    ytitle("Pourcentage (%)", size(medium))                            ///
    title("Situation matrimoniale de la mère", size(medium))           ///
    subtitle("Hôpital de Lwiro, 1986-1988", size(small))              ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\situation_matrimoniale.png", replace width(1200)


* ── Rang dans la fratrie (catégorisé) ────────────────────────────────
tab rang
graph pie, over(rang)                                                  ///
    plabel(_all percent, size(medium) color(white) format(%5.1f))      ///
    pie(1, color("$c1")) pie(2, color("$c2")) pie(3, color("$c3"))     ///
    title("Catégories de rang dans la fratrie", size(medium))          ///
    legend(size(small)) graphregion(color(white))
graph export "Graphiques\rang_naissance.png", replace width(1000)


* ── Œdèmes ───────────────────────────────────────────────────────────
tab oed
graph pie, over(oed)                                                   ///
    plabel(_all percent, size(medium) color(white) format(%5.1f))      ///
    pie(1, color("$c1")) pie(2, color("$c3"))                          ///
    title("Situation des œdèmes", size(medium))                        ///
    legend(size(small)) graphregion(color(white))
graph export "Graphiques\oedemes.png", replace width(1000)


* ── Diarrhée ─────────────────────────────────────────────────────────
tab diar
graph pie, over(diar)                                                  ///
    plabel(_all percent, size(medium) color(white) format(%5.1f))      ///
    pie(1, color("$c1")) pie(2, color("$c3"))                          ///
    title("Prévalence de la diarrhée à l'admission", size(medium))     ///
    legend(size(small)) graphregion(color(white))
graph export "Graphiques\diarrhee.png", replace width(1000)


* ── Pli cutané ───────────────────────────────────────────────────────
tab peau
graph bar (percent), over(peau, label(labsize(medium)))                ///
    bar(1, color("$c1"))                                               ///
    blabel(bar, format(%5.1f) size(small) color(white))                ///
    ytitle("Pourcentage (%)", size(medium))                            ///
    title("Pli cutané sous-scapulaire à l'admission", size(medium))    ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\pli_cutane.png", replace width(1200)


* ── Paludisme ────────────────────────────────────────────────────────
tab mala
graph pie, over(mala)                                                  ///
    plabel(_all percent, size(medium) color(white) format(%5.1f))      ///
    pie(1, color("$c1")) pie(2, color("$c3"))                          ///
    title("Prévalence du paludisme à l'admission", size(medium))       ///
    legend(size(small)) graphregion(color(white))
graph export "Graphiques\paludisme.png", replace width(1000)


* ── Classification de Waterlow ───────────────────────────────────────
tab v18
graph hbar (count), over(v18, label(labsize(small)))                   ///
    bar(1, color("$c2"))                                               ///
    blabel(bar, size(small) color(white))                              ///
    ytitle("Nombre d'enfants", size(medium))                           ///
    title("Classification de Waterlow du risque d'escarre",            ///
          size(medium))                                                ///
    subtitle("Hôpital de Lwiro, 1986-1988", size(small))              ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\waterlow.png", replace width(1200)


* ── Albumine sérique (catégorisée) ───────────────────────────────────
tab durhosp
graph bar (percent), over(durhosp, label(labsize(small)))              ///
    bar(1, color("$c1"))                                               ///
    blabel(bar, format(%5.1f) size(small) color(white))                ///
    ytitle("Pourcentage (%)", size(medium))                            ///
    title("Répartition selon le niveau d'albumine sérique",            ///
          size(medium))                                                ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\albumine_categories.png", replace width(1200)


* ── Périmètre brachial (catégorisé) ──────────────────────────────────
tab pbr
graph bar (percent), over(pbr, label(labsize(small)))                  ///
    bar(1, color("$c2"))                                               ///
    blabel(bar, format(%5.1f) size(small) color(white))                ///
    ytitle("Pourcentage (%)", size(medium))                            ///
    title("Répartition selon le périmètre brachial", size(medium))     ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\pbr_categories.png", replace width(1200)


/*-----------------------------------------------------------------------
*   3.3 Variable quantitative continue
*
*   Seul l'âge à l'admission demeure continu dans la base apurée :
*   durhosp, pbr et rang ont été recodées en catégories (cf. 3.2) et
*   sont désormais traitées comme des variables qualitatives ordinales.
*-----------------------------------------------------------------------*/

tabstat age, stat(n mean sd median p25 p75 min max skewness kurtosis) col(stat)

histogram age, freq normal                                             ///
    fcolor("$c1"%70) lcolor(white)                                     ///
    title("Distribution de l'âge à l'admission", size(medium))        ///
    xtitle("Âge (mois)") ytitle("Fréquence")                          ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\hist_age.png", replace width(1200)

graph box age, over(etat)                                              ///
    box(1, color("$c2")) box(2, color("$c3"))                          ///
    marker(1, mcolor("$c2") msymbol(circle_hollow))                   ///
    marker(2, mcolor("$c3") msymbol(circle_hollow))                   ///
    title("Âge selon l'état à la sortie", size(medium))               ///
    ytitle("Âge (mois)") graphregion(color(white)) bgcolor(white)
graph export "Graphiques\boxplot_age_etat.png", replace width(1200)

* ─3.4─ Taux de mortalité selon les catégories nutritionnelles et de rang ──

gen etat_pct = etat * 100
label variable etat_pct "Taux de mortalité (%)"

* Albumine sérique catégorisée
graph bar (mean) etat_pct, over(durhosp, label(labsize(small)))        ///
    bar(1, color("$c3"))                                               ///
    blabel(bar, format(%4.1f) size(small) color(white))                ///
    ytitle("Taux de mortalité (%)", size(medium))                      ///
    title("Mortalité selon le niveau d'albumine sérique", size(medium)) ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\mortalite_durhosp.png", replace width(1200)

* Périmètre brachial catégorisé
graph bar (mean) etat_pct, over(pbr, label(labsize(small)))            ///
    bar(1, color("$c3"))                                               ///
    blabel(bar, format(%4.1f) size(small) color(white))                ///
    ytitle("Taux de mortalité (%)", size(medium))                      ///
    title("Mortalité selon le périmètre brachial", size(medium))       ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\mortalite_pbr.png", replace width(1200)

* Rang dans la fratrie catégorisé
graph bar (mean) etat_pct, over(rang, label(labsize(small)))           ///
    bar(1, color("$c3"))                                               ///
    blabel(bar, format(%4.1f) size(small) color(white))                ///
    ytitle("Taux de mortalité (%)", size(medium))                      ///
    title("Mortalité selon le rang dans la fratrie", size(medium))     ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\mortalite_rang.png", replace width(1200)


/*=======================================================================
*   IV. ANALYSE INFÉRENTIELLE
*=======================================================================*/

/*-----------------------------------------------------------------------
*   4.1 Proportion d'enfants décédés et intervalle de confiance à 95 %
*-----------------------------------------------------------------------*/

di _newline "=== PROPORTION D'ENFANTS DÉCÉDÉS ==="
proportion etat, level(95)
ci proportions etat, wilson level(95)


/*-----------------------------------------------------------------------
*   4.2 Corrélations entre l'âge et les indicateurs ordinaux
*
*   durhosp, pbr et rang étant désormais catégorielles ordinales, la
*   corrélation de Pearson n'est plus appropriée : elle est remplacée
*   par la corrélation de rang de Spearman.
*-----------------------------------------------------------------------*/

di _newline "=== MATRICE DE CORRÉLATION DE SPEARMAN ==="
spearman age durhosp pbr rang, stats(rho p) star(0.05)


/*-----------------------------------------------------------------------
*   4.3 Associations entre les indicateurs de l'état nutritionnel
*
*   pbr étant désormais catégorielle, ses associations avec les autres
*   indicateurs qualitatifs sont testées par chi2 / V de Cramér plutôt
*   que par Mann-Whitney.
*-----------------------------------------------------------------------*/

di _newline "--- pbr × oed ---"
tabulate pbr oed, chi2 V expected

di _newline "--- pbr × peau ---"
tabulate pbr peau, chi2 V expected

di _newline "--- pbr × v18_2cat ---"
tabulate pbr v18_2cat, chi2 V expected

di _newline "--- oed × peau ---"
tabulate oed peau, chi2 V expected

di _newline "--- oed × v18_2cat ---"
tabulate oed v18_2cat, chi2 V expected

di _newline "--- peau × v18_2cat ---"
tabulate peau v18_2cat, chi2 V expected


/*-----------------------------------------------------------------------
*   4.4 Relation entre le rang de naissance et le paludisme
*-----------------------------------------------------------------------*/

di _newline "=== RANG × MALA ==="
tabulate rang mala, chi2 V expected


/*-----------------------------------------------------------------------
*   4.5 Association entre l'état à la sortie et chaque prédicteur
*-----------------------------------------------------------------------*/

di _newline "========================================================"
di "  TABLEAU SYNTHÉTIQUE : etat x chaque prédicteur       "
di "========================================================"

foreach var of varlist sexe etum sitmatm rang durhosp pbr              ///
                       oed diar peau mala v18_2cat {
    di _newline "--- `var' x etat ---"
    tabulate `var' etat, chi2 V expected
}

di _newline "--- age x etat ---"
quietly swilk age
local p_sw = r(p)
if `p_sw' >= 0.05 {
    di "  Shapiro-Wilk p = " string(`p_sw', "%6.4f") " -> normal -> ANOVA"
    anova age etat
}
else {
    di "  Shapiro-Wilk p = " string(`p_sw', "%6.4f") " -> non normal -> Mann-Whitney"
    ranksum age, by(etat)
}
bysort etat : tabstat age, stat(n mean median sd) col(stat)


/*=======================================================================
*   V. ANALYSE RESTREINTE : POPULATION INFANTILE (0-11 MOIS)
*
*   Conformément à la définition démographique de la mortalité infantile
*   (décès survenus avant le premier anniversaire), la modélisation
*   explicative est restreinte aux enfants âgés de moins de 12 mois à
*   l'admission. L'analyse descriptive globale (sections III et IV)
*   portait sur l'ensemble des 1 129 observations ; cette section porte
*   exclusivement sur le sous-échantillon des nourrissons.
*=======================================================================*/

/*-----------------------------------------------------------------------
*   5.1 RECHARGEMENT ET CONSTITUTION DU SOUS-ÉCHANTILLON
*-----------------------------------------------------------------------*/

use "Bas_apuree.dta", clear

* Recréation de v18_2cat sur le sous-échantillon
gen v18_2cat = (v18 >= 1)
label define v18_2cat_lbl 0 "À risque" 1 "Haut / très haut risque"
label values v18_2cat v18_2cat_lbl
label variable v18_2cat "Risque d'escarre (recodé en 2 catégories)"

gen etat_pct = etat * 100
label variable etat_pct "Taux de mortalité (%)"

* Application du filtre : nourrissons de 0 à 11 mois révolus
keep if age < 12

di _newline "======================================================"
di "  SOUS-ÉCHANTILLON : NOURRISSONS (0-11 MOIS)          "
di "======================================================"
di "  Effectif total         : " _N
count if etat == 1
di "  Dont décédés           : " r(N)
count if etat == 0
di "  Dont vivants           : " r(N)


/*-----------------------------------------------------------------------
*   5.2 TAUX DE MORTALITÉ SPÉCIFIQUE AUX NOURRISSONS
*
*   Ce taux est à comparer au taux global de 17,5 % obtenu sur
*   l'échantillon complet (section 4.1). L'écart éventuel justifie
*   le recentrage de la modélisation sur cette sous-population.
*-----------------------------------------------------------------------*/

di _newline "=== PROPORTION DE NOURRISSONS DÉCÉDÉS (IC 95 % Wilson) ==="
proportion etat, level(95)
ci proportions etat, wilson level(95)


/*-----------------------------------------------------------------------
*   5.3 PROFIL COMPARATIF : NOURRISSONS vs RESTE DE L'ÉCHANTILLON
*
*   Ce tableau compare les caractéristiques clés entre le sous-groupe
*   des nourrissons et l'ensemble de l'échantillon. Il constitue la
*   base empirique de la section 3.6 du rapport.
*-----------------------------------------------------------------------*/

di _newline "=== PROFIL DESCRIPTIF DES NOURRISSONS ==="

* Variable dépendante
tab etat

* Caractéristiques socio-démographiques
tab sexe
tab sitmatm
tab etum
tab rang

* Variables cliniques et nutritionnelles
tab oed
tab diar
tab peau
tab mala
tab v18
tab durhosp
tab pbr

* Seule variable continue restante
tabstat age, stat(n mean sd median p25 p75 min max skewness) col(stat)


/*-----------------------------------------------------------------------
*   5.4 STATISTIQUES DESCRIPTIVES VISUELLES SUR LES NOURRISSONS
*-----------------------------------------------------------------------*/

* Distribution de l'âge chez les nourrissons
histogram age, freq normal                                             ///
    fcolor("$c2"%70) lcolor(white)                                     ///
    title("Distribution de l'âge chez les nourrissons", size(medium)) ///
    xtitle("Âge (mois)") ytitle("Fréquence")                          ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\hist_age_nourrissons.png", replace width(1200)

* Répartition selon l'état à la sortie chez les nourrissons
graph bar (percent), over(etat, label(labsize(medium)))                ///
    bar(1, color("$c2")) bar(2, color("$c3"))                          ///
    blabel(bar, format(%5.1f) size(small) color(white))                ///
    ytitle("Pourcentage (%)", size(medium))                            ///
    title("État à la sortie — nourrissons (0-11 mois)",                ///
          size(medium))                                                ///
    subtitle("Hôpital de Lwiro, 1986-1988", size(small))              ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\etat_nourrissons.png", replace width(1200)

* Taux de mortalité selon l'albumine sérique — nourrissons
graph bar (mean) etat_pct, over(durhosp, label(labsize(small)))        ///
    bar(1, color("$c3"))                                               ///
    blabel(bar, format(%4.1f) size(small) color(white))                ///
    ytitle("Taux de mortalité (%)", size(medium))                      ///
    title("Mortalité selon l'albumine sérique — nourrissons",          ///
          size(medium))                                                ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\mortalite_alb_nourr.png", replace width(1200)

* Taux de mortalité selon le PBR — nourrissons
graph bar (mean) etat_pct, over(pbr, label(labsize(small)))            ///
    bar(1, color("$c3"))                                               ///
    blabel(bar, format(%4.1f) size(small) color(white))                ///
    ytitle("Taux de mortalité (%)", size(medium))                      ///
    title("Mortalité selon le périmètre brachial — nourrissons",       ///
          size(medium))                                                ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\mortalite_pbr_nourr.png", replace width(1200)

* Taux de mortalité selon les œdèmes — nourrissons
graph bar (mean) etat_pct, over(oed, label(labsize(small)))            ///
    bar(1, color("$c3"))                                               ///
    blabel(bar, format(%4.1f) size(small) color(white))                ///
    ytitle("Taux de mortalité (%)", size(medium))                      ///
    title("Mortalité selon la présence d'œdèmes — nourrissons",        ///
          size(medium))                                                ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\mortalite_oed_nourr.png", replace width(1200)


/*-----------------------------------------------------------------------
*   5.5 ASSOCIATIONS BIVARIÉES SUR LE SOUS-ÉCHANTILLON DES NOURRISSONS
*
*   Ces tests constituent le tableau synthétique de la section 3.6 du
*   rapport, équivalent du Tableau 7 mais restreint aux nourrissons.
*   Ils permettent d'identifier les prédicteurs pertinents à introduire
*   dans la régression et de vérifier que le sous-échantillon est
*   suffisamment riche pour soutenir la modélisation.
*-----------------------------------------------------------------------*/

di _newline "======================================================"
di "  ASSOCIATIONS BIVARIÉES — NOURRISSONS (0-11 MOIS)   "
di "======================================================"

* Variables qualitatives : chi² et V de Cramér
foreach var of varlist sexe etum sitmatm rang durhosp pbr              ///
                       oed diar peau mala v18_2cat {
    di _newline "--- `var' x etat (nourrissons) ---"
    tabulate `var' etat, chi2 V expected
}

* Variable quantitative : âge
di _newline "--- age x etat (nourrissons) ---"
quietly swilk age
local p_sw = r(p)
if `p_sw' >= 0.05 {
    di "  Shapiro-Wilk p = " string(`p_sw', "%6.4f") " -> normal -> ANOVA"
    anova age etat
}
else {
    di "  Shapiro-Wilk p = " string(`p_sw', "%6.4f") " -> non normal -> Mann-Whitney"
    ranksum age, by(etat)
}
bysort etat : tabstat age, stat(n mean median sd) col(stat)


/*-----------------------------------------------------------------------
*   5.6 VÉRIFICATION DE LA PUISSANCE STATISTIQUE
*
*   Règle empirique : au moins 10 événements (décès) par variable
*   explicative dans un modèle logistique. Ce bloc vérifie que le
*   nombre de décès chez les nourrissons est compatible avec le nombre
*   de variables envisagées dans le modèle.
*-----------------------------------------------------------------------*/

di _newline "=== VÉRIFICATION DE LA PUISSANCE ==="
count if etat == 1
local n_deces = r(N)
di "  Nombre de décès chez les nourrissons : " `n_deces'
di "  Nombre max de variables recommandé   : " int(`n_deces' / 10)
di "  (règle empirique : 10 événements par variable)"

/*=======================================================================
*   RÉGRESSION LOGISTIQUE — NOURRISSONS (0-11 MOIS)
*=======================================================================*/

/*-----------------------------------------------------------------------
*   1. SÉLECTION DES VARIABLES PAR PROCÉDURE BACKWARD
*-----------------------------------------------------------------------*/

stepwise, pr(.05): logit etat age i.rang i.durhosp i.pbr              ///
    i.sexe i.etum i.diar i.peau i.mala i.v18_2cat i.sitmatm i.oed

/*-----------------------------------------------------------------------
*   3. MODÈLE FINAL AVEC ODDS RATIOS
*-----------------------------------------------------------------------*/

logit etat age i.pbr i.durhosp, or


/*-----------------------------------------------------------------------
*   4. TESTS DE VALIDATION
*-----------------------------------------------------------------------*/

* Règle de pouce : D / v
scalar D        = -2 * e(ll)
scalar df_v     = e(N) - e(df_m) - 1
scalar ratio_Dv = D / df_v
di "D/v = " ratio_Dv

* Hosmer-Lemeshow
estat gof, group(10)

* Résidus de Pearson
predict res_pearson, residuals
quietly {
    gen res2        = res_pearson^2
    summarize res2
    scalar chi2_obs = r(sum)
    drop res2
}
scalar pval_res = chi2tail(e(N) - e(df_m) - 1, chi2_obs)
di "Chi² résidus de Pearson = " chi2_obs
di "p-valeur                = " pval_res

scatter res_pearson age,                                               ///
    yline( 2, lcolor(red) lpattern(dash))                              ///
    yline(-2, lcolor(red) lpattern(dash))                              ///
    mcolor("$c1"%60) msymbol(circle_hollow)                            ///
    title("Distribution des résidus de Pearson — nourrissons",         ///
          size(medium))                                                ///
    subtitle("Hôpital de Lwiro, 1986-1988", size(small))              ///
    xtitle("Âge (mois)") ytitle("Résidu de Pearson")                   ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\residus_nourrissons.png", replace width(1200)
drop res_pearson

* Linktest
linktest

* Matrice de classification
estat classification

* Courbe ROC
lroc,                                                                  ///
    title("Courbe ROC — nourrissons", size(medium))                    ///
    subtitle("Hôpital de Lwiro, 1986-1988", size(small))              ///
    graphregion(color(white)) bgcolor(white)
graph export "Graphiques\ROC_nourrissons.png", replace width(1200)

log close
