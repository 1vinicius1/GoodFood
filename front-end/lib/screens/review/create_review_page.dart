import 'package:flutter/material.dart';
import '../../state/app_state.dart';

class CreateReviewPage extends StatefulWidget {
  const CreateReviewPage({
    super.key,
    required this.appState,
    required this.restaurant,
  });

  final AppState appState;
  final Restaurant restaurant;

  @override
  State<CreateReviewPage> createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _textCtrl = TextEditingController();
  final _ticketCtrl = TextEditingController();

  int _stars = 5;
  int _atendimento = 5;

  static const _accent = Color(0xFFCE4E32);
  static const _bg = Color(0xFF1E1E1E);
  static const _panel = Color(0xFF3C3C3C);

  @override
  void dispose() {
    _textCtrl.dispose();
    _ticketCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final ticket = _ticketCtrl.text.trim().isEmpty
        ? null
        : double.tryParse(_ticketCtrl.text.trim().replaceAll(',', '.'));

    final review = Review(
      author: widget.appState.currentUserName,
      stars: _stars,
      text: _textCtrl.text.trim(),
      ticketMedio: ticket,
      atendimento: _atendimento,
      createdAt: DateTime.now(),
    );

    widget.appState.addReview(widget.restaurant.id, review);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Nova avaliação'),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: _panel,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.restaurant.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 14),

                      _StarsPicker(
                        label: 'Nota',
                        value: _stars,
                        onChanged: (v) => setState(() => _stars = v),
                      ),
                      const SizedBox(height: 12),

                      _StarsPicker(
                        label: 'Atendimento',
                        value: _atendimento,
                        onChanged: (v) => setState(() => _atendimento = v),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _ticketCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Ticket médio (opcional)',
                          hintText: 'Ex: 35,00',
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _textCtrl,
                        minLines: 3,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          labelText: 'Comentário',
                          hintText: 'Conte como foi sua experiência…',
                        ),
                        validator: (v) {
                          final s = (v ?? '').trim();
                          if (s.isEmpty) return 'Escreva um comentário';
                          if (s.length < 10) return 'Escreva um pouco mais (mín. 10)';
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      ElevatedButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.star),
                        label: const Text('Publicar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accent,
                          foregroundColor: const Color(0xFF1A1A1A),
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StarsPicker extends StatelessWidget {
  const _StarsPicker({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  static const _accent = Color(0xFFCE4E32);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF343434),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFDBDBDB),
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Row(
            children: List.generate(5, (i) {
              final star = i + 1;
              return IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => onChanged(star),
                icon: Icon(
                  star <= value ? Icons.star : Icons.star_border,
                  color: _accent,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
