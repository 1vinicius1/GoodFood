import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../restaurant/restaurant_details_page.dart';
import '../search/search_page.dart';
import '../profile/profile_page.dart';
import '../timeline/timeline_page.dart';
import '../lists/lists_page.dart';
import '../friends_activity/friends_activity_page.dart';
import '../login/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.appState});
  final AppState appState;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  static const _accent = Color(0xFFCE4E32);
  static const _panel = Color(0xFF3C3C3C);
  static const _muted = Color(0xFFB7B7B7);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openProfileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MenuItem(
                  title: 'Perfil',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProfilePage(appState: widget.appState),
                      ),
                    );
                  },
                ),
                const _Divider(),
                _MenuItem(
                  title: 'Linha do Tempo',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TimelinePage(appState: widget.appState),
                      ),
                    );
                  },
                ),
                const _Divider(),
                _MenuItem(
                  title: 'Listas',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ListsPage(appState: widget.appState),
                      ),
                    );
                  },
                ),
                const _Divider(),
                _MenuItem(
                  title: 'Atividade amigos',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            FriendsActivityPage(appState: widget.appState),
                      ),
                    );
                  },
                ),
                const _Divider(),
                _MenuItem(
                  title: 'Sair',
                  onTap: () {
                    Navigator.of(context).pop(); // fecha o bottom sheet
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => LoginPage(appState: widget.appState),
                      ),
                      (route) => false, // limpa tudo pra não voltar com "back"
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openRestaurant(Restaurant r) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            RestaurantDetailsPage(appState: widget.appState, restaurant: r),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final items = widget.appState.restaurants;

        return Scaffold(
          backgroundColor: const Color(0xFF1E1E1E),
          floatingActionButton: FloatingActionButton(
            backgroundColor: _accent,
            foregroundColor: const Color(0xFF1A1A1A),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abra um restaurante e avalie ⭐')),
              );
            },
            child: const Icon(Icons.star, size: 28),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: _panel,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _openProfileMenu,
                              child: const CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xFF2A2A2A),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Center(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.2,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Good',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: 'Food',
                                        style: TextStyle(color: _accent),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        SearchPage(appState: widget.appState),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.search,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: _accent,
                          unselectedLabelColor: Colors.black54,
                          indicatorColor: _accent,
                          indicatorWeight: 3,
                          tabs: const [
                            Tab(text: 'Seguindo'),
                            Tab(text: 'Em alta'),
                            Tab(text: 'Recente'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _Grid(items: items, onTap: _openRestaurant),
                            _Grid(
                              items: items.reversed.toList(),
                              onTap: _openRestaurant,
                            ),
                            _Grid(items: items, onTap: _openRestaurant),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text(
                          'GoodFood • comunidade real',
                          style: TextStyle(color: _muted, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.items, required this.onTap});

  final List<Restaurant> items;
  final void Function(Restaurant r) onTap;

  static const _accent = Color(0xFFCE4E32);

  @override
  Widget build(BuildContext context) {
    final appState =
        (context.findAncestorStateOfType<_HomePageState>()!).widget.appState;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.95,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final r = items[i];
        final avg = appState.averageStarsOf(r.id);

        return GestureDetector(
          onTap: () => onTap(r),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(r.imageUrl, fit: BoxFit.cover),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [Color(0xCC000000), Color(0x00000000)],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _StarsRow(value: avg, size: 14, color: _accent),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StarsRow extends StatelessWidget {
  const _StarsRow({
    required this.value,
    required this.size,
    required this.color,
  });

  final double value;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final full = value.floor();
    final hasHalf = (value - full) >= 0.5;

    return Row(
      children: List.generate(5, (i) {
        IconData icon;
        if (i < full)
          icon = Icons.star;
        else if (i == full && hasHalf)
          icon = Icons.star_half;
        else
          icon = Icons.star_border;
        return Icon(icon, size: size, color: color);
      }),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF1A1A1A)),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFE2E2E2));
  }
}
