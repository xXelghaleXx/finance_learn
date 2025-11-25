import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final nombre = auth.user?['nombre'] ?? 'Usuario';

    messages.add({
      'sender': 'bot',
      'text': '¡Hola $nombre! 👋 Soy FinnChatBot. Estoy aquí para ayudarte con tus finanzas. ¿Qué deseas saber hoy?'
    });
  }

  String _respuestaIA(String pregunta) {
    pregunta = pregunta.toLowerCase();

    if (pregunta.contains("ahorrar") || pregunta.contains("ahorro")) {
      return "Lo ideal es ahorrar entre el 20% y 30% de tus ingresos mensuales si es posible. ¡Puedes comenzar poco a poco!";
    }

    if (pregunta.contains("gastos") || pregunta.contains("gastar")) {
      return "Para mejorar tus gastos, registra tus compras y clasifícalas. Identifica gastos hormiga y elimina los innecesarios.";
    }

    if (pregunta.contains("meta")) {
      return "Una meta financiera debe ser SMART: específica, medible, alcanzable, relevante y con límite de tiempo.";
    }

    if (pregunta.contains("deuda")) {
      return "La estrategia bola de nieve funciona bien: paga primero la deuda más pequeña mientras haces pagos mínimos en el resto.";
    }

    return "Interesante pregunta 🤔. Aún estoy aprendiendo, pero trataré de ayudarte. Intenta preguntarme sobre ahorro, gastos, metas o deudas.";
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'sender': 'user', 'text': text});
      messages.add({'sender': 'bot', 'text': _respuestaIA(text)});
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FinnChatBot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg['sender'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : const Color(0xFF00BFA5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg['text']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),

          // input
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Escribe tu mensaje...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF00BFA5)),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
