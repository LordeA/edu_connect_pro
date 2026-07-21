import 'package:flutter/material.dart';

class CourseLectureScreen extends StatefulWidget {
  final String chapterTitle;
  final int chapterNumero;

  const CourseLectureScreen({
    super.key,
    required this.chapterTitle,
    required this.chapterNumero,
  });

  @override
  State<CourseLectureScreen> createState() => _CourseLectureScreenState();
}

class _CourseLectureScreenState extends State<CourseLectureScreen> {
  // Simile plizyè paj oswa seksyon anndan menm chapit la (pa egzanp 3 pati)
  int _currentPage = 1;
  final int _totalPages = 3;

  // Map ki estoke kontni tèks pou chak nan 12 chapit yo an franse
  String _getChapterContent(int numero) {
    switch (numero) {
      case 1:
        return 'Flutter est un framework de développement d\'applications multiplateformes créé par Google. Il permet de concevoir des applications natives pour mobile, web et desktop à partir d\'une base de code unique.\n\n'
               'Grâce à son système de widgets riches et personnalisables, Flutter offre une fluidité d\'animation exceptionnelle et accélère considérablement le cycle de développement.';
      case 2:
        return 'Pour commencer à développer avec Flutter, vous devez installer le SDK officiel et configurer votre environnement de travail (Android Studio, VS Code ou Xcode).\n\n'
               'Il est également indispensable d\'ajouter le chemin du SDK Flutter aux variables d\'environnement de votre système afin de pouvoir exécuter des commandes dans le terminal.';
      case 3:
        return 'Dart est le langage de programmation orienté objet optimisé par Google qui alimente Flutter.\n\n'
               'Il supporte à la fois la compilation JIT (Just-In-Time) pour le rechargement à chaud (Hot Reload) lors du développement, et AOT (Ahead-Of-Time) pour des performances de production ultra-rapides.';
      case 4:
        return 'La Programmation Orientée Objet (POO) est un pilier fondamental en Dart. On y retrouve les concepts de classes, d\'objets, d\'héritage, d\'encapsulation et de polymorphisme.\n\n'
               'Maîtriser ces concepts vous permet d\'écrire du code propre, maintenable, réutilisable et bien structuré pour vos applications complexes.';
      case 5:
        return 'Les widgets de base constituent les éléments fondamentaux de l\'interface utilisateur (UI) dans Flutter. Tout est widget, qu\'il s\'agisse d\'une mise en page, d\'un texte ou d\'un bouton.\n\n'
               'On distingue principalement les StatelessWidget (widgets immuables) et les StatefulWidget (widgets dynamiques dont l\'état peut changer au cours du temps).';
      case 6:
        return 'Les layouts complexes s\'appuient sur l\'imbrication de widgets de disposition tels que Row (lignes), Column (colonnes), Stack (empilements) et ListView (listes défilantes).\n\n'
               'Savoir combiner ces structures permet de concevoir des interfaces graphiques adaptatives et ergonomiques pour différentes tailles d\'écrans.';
      case 7:
        return 'La gestion des états (State Management) est cruciale pour synchroniser l\'interface utilisateur avec les données de l\'application.\n\n'
               'Plusieurs solutions existent selon la complexité du projet, allant de setState natif jusqu\'aux approches avancées telles que Provider, Riverpod, BLoC ou GetX.';
      case 8:
        return 'La navigation et le routage permettent de passer facilement d\'un écran à un autre au sein de votre application mobile.\n\n'
               'Flutter propose une gestion native par pile (Navigator.push et Navigator.pop) ainsi que des systèmes de routage avancés basés sur des chemins nommés.';
      case 9:
        return 'La connexion aux APIs et aux services web permet à votre application mobile de communiquer avec un serveur distant pour récupérer ou envoyer des données.\n\n'
               'On utilise généralement le package http ou Dio pour effectuer des requêtes REST (GET, POST, PUT, DELETE) et parser des données au format JSON.';
      case 10:
        return 'Le stockage de données locales permet à une application de fonctionner hors ligne en sauvegardant des informations directement sur l\'appareil.\n\n'
               'Pour des structures relationnelles et complexes, on utilise des bases de données locales telles que SQFlite, tandis que pour de petites préférences, SharedPreferences est privilégié.';
      case 11:
        return 'L\'intégration de Firebase offre une suite complète de services cloud prêts à l\'emploi pour les applications mobiles.\n\n'
               'Cela inclut l\'authentification sécurisée des utilisateurs (Auth), le stockage de données en temps réel (Cloud Firestore) et la gestion des notifications push.';
      case 12:
        return 'Le déploiement est la dernière étape qui consiste à préparer votre application pour la mise en ligne sur les stores officiels.\n\n'
               'Cela comprend la configuration des signatures de code, la génération des fichiers de distribution (APK/App Bundle pour Android et IPA pour iOS) et la publication.';
      default:
        return 'Contenu détaillé pour ce chapitre en cours de rédaction.';
    }
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
          'Chapitre ${widget.chapterNumero} sur 12',
          style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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