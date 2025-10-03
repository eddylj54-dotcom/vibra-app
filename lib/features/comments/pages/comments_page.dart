import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Modelos de Datos ---
class GiftOption {
  final String id;
  final String name;
  final String icon;
  final double value;

  const GiftOption({
    required this.id,
    required this.name,
    required this.icon,
    required this.value,
  });
}

class ChatMessage {
  final String id;
  final String user;
  final String message;
  final bool isGift;
  final double? giftValue;

  ChatMessage({
    required this.id,
    required this.user,
    required this.message,
    this.isGift = false,
    this.giftValue,
  });
}

// --- Constantes ---
const List<GiftOption> _giftOptions = [
  GiftOption(id: '1', name: 'Café', icon: '☕', value: 0.10),
  GiftOption(id: '2', name: 'Corazón', icon: '❤️', value: 0.50),
  GiftOption(id: '3', name: 'Rosa', icon: '🌹', value: 1.00),
  GiftOption(id: '4', name: 'Estrella', icon: '⭐', value: 2.00),
  GiftOption(id: '5', name: 'Fuego', icon: '🔥', value: 5.00),
  GiftOption(id: '6', name: 'Corona', icon: '👑', value: 10.00),
];

// --- Paleta de Colores (simulando soulGlow) ---
class SoulGlow {
  static const Color deepOrange = Color(0xFFA855F7); // Es un morado
  static const Color softRed = Color(0xFFEC4899);    // Es un rosa
  static const Color darkOrange = Color(0xFF9333EA); // Es un morado oscuro
  static const Color black = Color(0xFF0A0A0A);
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color charcoal = Color(0xFF2A2A2A);
  static const Color warmGlow = Color(0xFFC084FC);
  static const Color amber = Color(0xFFF0ABFC);      // Es un rosa/morado claro
  static const Color white = Color(0xFFFFFFFF);
  static const Color softWhite = Color(0xFFF5F5F5);
  static const Color glassBlack = Color.fromRGBO(0, 0, 0, 0.4);
}

// --- Widget Principal ---
class CommentsPage extends StatefulWidget {
  final String? postId;

  const CommentsPage({super.key, this.postId});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> with SingleTickerProviderStateMixin {
  int _viewerCount = 127;
  final List<ChatMessage> _messages = [
    ChatMessage(id: '1', user: 'María', message: '¡Hola a todos!'),
    ChatMessage(id: '2', user: 'Carlos', message: 'Excelente transmisión'),
  ];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _giftAnimationController;
  late Animation<double> _giftAnimation;

  @override
  void initState() {
    super.initState();
    // Simular cambio de espectadores
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _viewerCount += Random().nextInt(3) - 1;
        });
      } else {
        timer.cancel();
      }
    });

    _giftAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _giftAnimation = CurvedAnimation(
      parent: _giftAnimationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _giftAnimationController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          id: DateTime.now().toString(),
          user: 'Tú',
          message: _messageController.text.trim(),
        ));
        _messageController.clear();
      });
      _scrollToBottom();
    }
  }

  void _sendGift(GiftOption gift) {
    Navigator.of(context).pop(); // Cierra el modal de regalos
    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().toString(),
        user: 'Tú',
        message: 'envió ${gift.icon} ${gift.name}',
        isGift: true,
        giftValue: gift.value,
      ));
    });
    _scrollToBottom();
    
    // Inicia la animación del regalo
    _giftAnimationController.forward(from: 0.0);
  }
  
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showGiftsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildGiftModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SoulGlow.black,
      body: Stack(
        children: [
          _buildVideoPlaceholder(),
          _buildTopOverlay(),
          _buildGiftAnimation(),
          Column(
            children: [
              const Spacer(),
              _buildChat(),
              _buildBottomBar(),
            ],
          ),
        ],
      ),
    );
  }

  // --- Widgets Secundarios ---

  Widget _buildVideoPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [SoulGlow.black, SoulGlow.darkGray],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Text(
          'Transmisión en vivo',
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: SoulGlow.softWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTopOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black54, Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCloseButton(),
            const SizedBox(width: 16),
            _buildStreamerInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).canPop() ? Navigator.of(context).pop() : null,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: SoulGlow.glassBlack,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Icon(FontAwesomeIcons.xmark, color: SoulGlow.white, size: 22),
      ),
    );
  }

  Widget _buildStreamerInfo() {
    return Expanded(
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'),
            backgroundColor: SoulGlow.deepOrange,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.postId != null ? 'Post: ${widget.postId}' : 'Live',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: SoulGlow.white,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: SoulGlow.glassBlack,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(FontAwesomeIcons.users, color: SoulGlow.white, size: 12),
                    const SizedBox(width: 6),
                    Text(
                      '$_viewerCount',
                      style: GoogleFonts.poppins(
                        color: SoulGlow.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChat() {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final msg = _messages[index];
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: msg.isGift ? SoulGlow.deepOrange.withAlpha(77) : SoulGlow.glassBlack,
                borderRadius: BorderRadius.circular(16),
                border: msg.isGift ? Border.all(color: SoulGlow.deepOrange) : null,
              ),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(fontSize: 14, color: SoulGlow.white),
                  children: [
                    TextSpan(
                      text: '${msg.user}: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: msg.isGift ? SoulGlow.amber : SoulGlow.softWhite,
                      ),
                    ),
                    TextSpan(
                      text: msg.message,
                      style: TextStyle(
                        color: msg.isGift ? SoulGlow.amber : SoulGlow.white,
                      ),
                    ),
                    if (msg.isGift)
                      TextSpan(
                        text: ' (\$${msg.giftValue?.toStringAsFixed(2)})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: SoulGlow.deepOrange,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 30),
      decoration: const BoxDecoration(
        color: SoulGlow.black,
        border: Border(top: BorderSide(color: SoulGlow.darkOrange, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildMessageInput()),
          const SizedBox(width: 12),
          _buildGiftButton(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: SoulGlow.darkGray,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SoulGlow.charcoal),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: GoogleFonts.inter(color: SoulGlow.white, fontSize: 15),
              decoration: InputDecoration(
                hintText: "Escribe un mensaje...",
                hintStyle: GoogleFonts.inter(color: SoulGlow.charcoal),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.paperPlane, color: SoulGlow.deepOrange, size: 20),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildGiftButton() {
    return GestureDetector(
      onTap: _showGiftsModal,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: SoulGlow.deepOrange,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: FaIcon(FontAwesomeIcons.gift, color: SoulGlow.white, size: 22),
        ),
      ),
    );
  }
  
  Widget _buildGiftAnimation() {
    return ScaleTransition(
      scale: _giftAnimation,
      child: const Center(
        child: Text('🎁', style: TextStyle(fontSize: 80)),
      ),
    );
  }

  Widget _buildGiftModal() {
    return Container(
      decoration: const BoxDecoration(
        color: SoulGlow.darkGray,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(color: SoulGlow.darkOrange, width: 2),
          left: BorderSide(color: SoulGlow.darkOrange, width: 1),
          right: BorderSide(color: SoulGlow.darkOrange, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enviar regalo',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: SoulGlow.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.xmark, color: SoulGlow.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(color: SoulGlow.charcoal, height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: _giftOptions.map((gift) {
                return GestureDetector(
                  onTap: () => _sendGift(gift),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 28,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: SoulGlow.charcoal,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: SoulGlow.darkOrange, width: 2),
                    ),
                    child: Column(
                      children: [
                        Text(gift.icon, style: const TextStyle(fontSize: 40)),
                        const SizedBox(height: 8),
                        Text(
                          gift.name,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: SoulGlow.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: SoulGlow.deepOrange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '\$${gift.value.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: SoulGlow.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}