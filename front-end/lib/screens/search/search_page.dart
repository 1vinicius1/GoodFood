import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../restaurant/restaurant_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.appState});

  final AppState appState;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  String _query = '';

  static const _accent = Color(0xFFCE4E32);
  static const _bg = Color(0xFF1E1E1E);
  static const _panel = Color(0xFF3C3C3C);
  static const _muted = Color(0xFFB7B7B7);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _query = _controller.text.trim());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Restaurant> _filtered() {
    if (_query.isEmpty) return widget.appState.restaurants;
    final q = _query.toLowerCase();
    return widget.appState.restaurants
        .where((r) => r.name.toLowerCase().contains(q))
        .toList();
  }

  void _openRestaurant(Restaurant r) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RestaurantDetailsPage(
          appState: widget.appState,
          restaurant: r,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final results = _filtered();

        return Scaffold(
          backgroundColor: _bg,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: _panel,
                  child: Column(
                    children: [
                      // Topo: back + campo de busca
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 10, 6, 8),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.black54),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                autofocus: true,
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                  hintText: 'Buscar restaurante...',
                                  filled: true,
                                  fillColor: const Color(0xFF343434),
                                  hintStyle:
                                      const TextStyle(color: _muted),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  suffixIcon: _query.isEmpty
                                      ? const Icon(Icons.search,
                                          color: _muted)
                                      : IconButton(
                                          onPressed: () {
                                            _controller.clear();
                                          },
                                          icon: const Icon(Icons.close,
                                              color: _muted),
                                        ),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                        ),
                      ),

                      // Header: contagem
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          children: [
                            Text(
                              _query.isEmpty
                                  ? 'Sugestões'
                                  : 'Resultados',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${results.length}',
                              style: const TextStyle(
                                color: _muted,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      Expanded(
                        child: results.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.search_off,
                                          color: _muted, size: 34),
                                      SizedBox(height: 10),
                                      Text(
                                        'Nenhum restaurante encontrado',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Tente outro nome.',
                                        style: TextStyle(color: _muted),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                    12, 0, 12, 12),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14,
                                  childAspectRatio: 0.95,
                                ),
                                itemCount: results.length,
                                itemBuilder: (_, i) {
                                  final r = results[i];
                                  final avg =
                                      widget.appState.averageStarsOf(r.id);

                                  return GestureDetector(
                                    onTap: () => _openRestaurant(r),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(18),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.network(r.imageUrl,
                                              fit: BoxFit.cover),
                                          Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.center,
                                                colors: [
                                                  Color(0xCC000000),
                                                  Color(0x00000000),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 10,
                                            right: 10,
                                            bottom: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  r.name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w900,
                                                    fontSize: 12,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                _StarsRow(
                                                  value: avg,
                                                  size: 14,
                                                  color: _accent,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
        if (i < full) icon = Icons.star;
        else if (i == full && hasHalf) icon = Icons.star_half;
        else icon = Icons.star_border;
        return Icon(icon, size: size, color: color);
      }),
    );
  }
}
