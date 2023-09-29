import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globoapp/constants/assets.dart';
import 'package:globoapp/screens/auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  late final user = auth.currentUser;

  Stream<QuerySnapshot<Map<String, dynamic>>> _getLocations() {
    final firestore = FirebaseFirestore.instance;

    final reference = firestore
        .collection(
          'users/qfhNLuhFEsYVd7cEOzb7EEyomiA2/locations',
        )
        .orderBy('name');

    return reference.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GloboApp'),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                onTap: () {},
                title: const Text('Home'),
              ),
              const Spacer(),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: FilledButton.tonal(
                  onPressed: () async {
                    await auth.signOut();
                    if (!mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text('Sair'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _getLocations(),
        builder: (context, snapshot) {
          print(snapshot.data?.size);

          if (snapshot.hasError) {
            return const Center(
              child: Text('Ops! Ocorreu um erro inesperado!'),
            );
          }

          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SvgPicture.asset(emptyStateImage, height: 240),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma localização encontrada!',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Card(
                    margin: const EdgeInsets.all(0),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Lembre sempre de verificar o tempo antes de sair em uma viagem!',
                        style: TextStyle(
                          fontSize: 18,
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final document = snapshot.data!.docs[index];
                        return Text(document.data()['name']);
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
