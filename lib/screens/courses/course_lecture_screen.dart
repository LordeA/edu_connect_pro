import 'package:flutter/material.dart';
import '../auth/login_screen.dart'; // Asire w chemen sa a kòrèk pou retounen sou Login

class CourseLectureScreen extends StatefulWidget {
  final String courseTitle;
  final String chapterTitle;
  final int chapterNumero;
  final int totalChapters;

  const CourseLectureScreen({
    super.key,
    required this.courseTitle,
    required this.chapterTitle,
    required this.chapterNumero,
    required this.totalChapters,
  });

  @override
  State<CourseLectureScreen> createState() => _CourseLectureScreenState();
}

class _CourseLectureScreenState extends State<CourseLectureScreen> {
  // Simile plizyè paj oswa seksyon anndan menm chapit la (pa egzanp 3 pati)
  int _currentPage = 1;
  final int _totalPages = 3;

  // Map ki estoke kontni tèks pou chak kou ak chak chapit 
  String _getChapterContent(int numero) {
    switch (widget.courseTitle) {
      case 'Flutter & Dart':
        return _flutterContent(numero);
      case 'UI/UX Design':
        return _designContent(numero);
      case 'Marketing Digital':
        return _marketingContent(numero);
      case 'Gestion de Projet':
        return _projectContent(numero);
      default:
        return _defaultContent(numero);
    }
  }

  String _flutterContent(int numero) {
    switch (numero) {
      case 1:
        return 'Flutter & Dart se focalisent sur la création d’applications mobiles modernes et performantes avec une interface réactive.';
      case 2:
        return 'Installer Flutter et configurer votre environnement est la première étape avant de commencer à coder une application mobile.';
      case 3:
        return 'Dart est le langage de programmation utilisé par Flutter, avec une syntaxe simple et un support natif pour le hot reload.';
      case 4:
        return 'Les widgets sont les blocs de construction de l’interface Flutter. Ils définissent l’apparence et le comportement des écrans.';
      case 5:
        return 'Composer l’interface avec Row, Column, Stack et ListView permet de créer des écrans responsives et fluides.';
      case 6:
        return 'La gestion d’état avec Provider simplifie le partage de données entre plusieurs widgets de votre application.';
      case 7:
        return 'La navigation dans Flutter se fait avec Navigator et les routes, ce qui permet de passer d’un écran à un autre facilement.';
      case 8:
        return 'Se connecter à une API REST permet à votre application de récupérer et d’enregistrer des données en temps réel.';
      case 9:
        return 'Firebase Firestore sert à stocker des données structurées et à synchroniser les informations entre utilisateurs.';
      case 10:
        return 'Préparer votre application pour la publication sur Android et iOS demande de configurer les certificats et de générer les bons packages.';
      default:
        return 'Contenu détaillé pour ce chapitre en cours de rédaction.';
    }
  }

  String _designContent(int numero) {
    switch (numero) {
      case 1:
        return 'Le design centré utilisateur commence par comprendre les besoins, les objectifs et les comportements de votre public cible.';
      case 2:
        return 'Les grilles et la typographie aident à structurer l’information et à rendre les interfaces plus lisibles.';
      case 3:
        return 'Les couleurs et les contrastes déterminent l’émotion de l’interface et garantissent une bonne accessibilité.';
      case 4:
        return 'Concevoir une interface mobile efficace repose sur la simplicité, l’intuitivité et une hiérarchie visuelle claire.';
      case 5:
        return 'Le prototypage et les wireframes permettent de tester rapidement les idées avant de passer au développement.';
      case 6:
        return 'Les tests utilisateur offrent des retours concrets pour améliorer l’expérience et détecter les problèmes d’usage.';
      case 7:
        return 'L’accessibilité rend vos interfaces utilisables par un plus grand nombre de personnes, y compris celles en situation de handicap.';
      case 8:
        return 'Les micro-interactions ajoutent une sensation de fluidité et renforcent l’engagement lors de l’utilisation de l’application.';
      case 9:
        return 'L’identité visuelle et le brand design doivent être cohérents avec le message de la marque et le public visé.';
      case 10:
        return 'Créer un portfolio solide aide à présenter vos meilleurs projets et à convaincre des clients ou recruteurs.';
      default:
        return 'Contenu détaillé pour ce chapitre en cours de rédaction.';
    }
  }

  String _marketingContent(int numero) {
    switch (numero) {
      case 1:
        return 'Le marketing digital consiste à promouvoir des produits et services en ligne en utilisant des canaux numériques ciblés.';
      case 2:
        return 'Le SEO vise à améliorer la visibilité de votre site dans les résultats de recherche grâce à un contenu optimisé.';
      case 3:
        return 'Les campagnes sur les réseaux sociaux permettent de toucher précisément votre audience avec des visuels et messages adaptés.';
      case 4:
        return 'L’email marketing est un levier puissant pour fidéliser vos clients et proposer des offres pertinentes.';
      case 5:
        return 'Les analytics mesurent les performances de vos actions marketing et permettent d’ajuster la stratégie en temps réel.';
      case 6:
        return 'Le storytelling de marque aide à raconter une histoire cohérente et à créer de l’attachement chez vos internautes.';
      case 7:
        return 'Le tunnel de conversion structure le parcours client de la découverte à l’achat.';
      case 8:
        return 'Le community management consiste à animer vos communautés et à entretenir une relation durable avec vos abonnés.';
      case 9:
        return 'Le marketing automation automatise les messages et actions pour envoyer le bon contenu au bon moment.';
      case 10:
        return 'Gérer une campagne à petit budget demande créativité, ciblage précis et optimisation continue.';
      default:
        return 'Contenu détaillé pour ce chapitre en cours de rédaction.';
    }
  }

  String _projectContent(int numero) {
    switch (numero) {
      case 1:
        return 'La gestion de projet commence par définir clairement les objectifs, le périmètre et les résultats attendus.';
      case 2:
        return 'Les méthodes Agile et Scrum permettent de livrer par itérations et d’adapter le projet aux changements.';
      case 3:
        return 'La planification identifie les tâches, les jalons et les ressources nécessaires pour atteindre les objectifs.';
      case 4:
        return 'La gestion des risques consiste à anticiper les problèmes et à prévoir des mesures de mitigation.';
      case 5:
        return 'La communication d’équipe est essentielle pour garder tous les collaborateurs alignés sur le projet.';
      case 6:
        return 'Le suivi de l’avancement permet de mesurer le progrès et de corriger rapidement les écarts.';
      case 7:
        return 'Le contrôle du budget aide à maîtriser les dépenses et à s’assurer que le projet reste rentable.';
      case 8:
        return 'Les livrables doivent être vérifiés pour garantir leur qualité et leur conformité aux attentes.';
      case 9:
        return 'Le leadership motive l’équipe et facilite la prise de décision lors des moments critiques.';
      case 10:
        return 'La clôture du projet fait le bilan, retient les leçons et prépare les futures améliorations.';
      default:
        return 'Contenu détaillé pour ce chapitre en cours de rédaction.';
    }
  }

  String _defaultContent(int numero) {
    switch (numero) {
      case 1:
        return 'Introduction générale au cours et aux objectifs d’apprentissage.';
      case 2:
        return 'Présentation des concepts clés et de la structure du contenu.';
      case 3:
        return 'Approfondissement des notions principales et des bonnes pratiques.';
      case 4:
        return 'Études de cas et exemples concrets pour appliquer ce que vous avez appris.';
      case 5:
        return 'Résumé final et recommandations pour aller plus loin.';
      default:
        return 'Contenu détaillé pour ce chapitre en cours de rédaction.';
    }
  }

  // Fonksyon konfimasyon dekoneksyon an
  void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Dekoneksyon',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Èske w sèten ou vle dekonekte w nan aplikasyon an?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Anile', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Wi, dekonekte', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, _currentPage > 1),
        ),
        title: Text(
          'Chapitre ${widget.chapterNumero} sur ${widget.totalChapters}',
          style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // Bouton dekoneksyon nan AppBar la
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => showLogoutConfirmation(context),
            tooltip: 'Se déconnecter',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tit Chapit la
            Text(
              widget.chapterTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 20),

            // Zòn Tèks Leson an (Kote itilizatè a ap li a)
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _getChapterContent(widget.chapterNumero),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Seksyon Anba: Pwogresyon ak Bouton Navigasyon (Précédent / Suivant)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  // Endikatè pwogresyon ak nimewo paj
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Bar pwogresyon dinamik
                      ...List.generate(_totalPages, (index) {
                        bool isPassed = index < _currentPage;
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: isPassed ? const Color(0xFF0D47A1) : Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(width: 10),
                      Text(
                        '$_currentPage/$_totalPages',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Bouton Précédent ak Suivant
                  Row(
                    children: [
                      // Bouton Précédent
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _currentPage > 1
                                ? () {
                                    setState(() {
                                      _currentPage--;
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: const Text('Précédent', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),

                      // Bouton Suivant (oswa Terminer si nou nan dènye paj la)
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_currentPage < _totalPages) {
                                setState(() {
                                  _currentPage++;
                                });
                              } else {
                                // Lè li rive nan dènye paj la, retounen true pou valide chapit la kòm fini sou CourseDetailScreen
                                Navigator.pop(context, true);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D47A1),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _currentPage == _totalPages ? 'Terminer' : 'Suivant',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}