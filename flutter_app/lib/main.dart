import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SocketService.initSocket();
  runApp(const MemoryPartyApp());
}

const bg = Color(0xFF0B0918);
const panel = Color(0xFF17132A);
const violet = Color(0xFF9B6CFF);
const cyan = Color(0xFF54E6D3);
const gold = Color(0xFFFFD27A);
const muted = Color(0xFFAAA4C3);

class SocketService {
  static late IO.Socket socket;
  static void initSocket() {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'], 'autoConnect': true,
    });
    socket.on('connect', (_) => debugPrint('Connected to backend'));
    socket.on('disconnect', (_) => debugPrint('Disconnected from backend'));
  }
}

class MemoryPartyApp extends StatelessWidget {
  const MemoryPartyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MEMORY Party', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(seedColor: violet, brightness: Brightness.dark),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: panel, modalBackgroundColor: panel)),
    home: const MainNavigation(),
  );
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override State<MainNavigation> createState() => _MainNavigationState();
}
class _MainNavigationState extends State<MainNavigation> {
  int tab = 0;
  final pages = const [HomePage(), ExplorePage(), MessagesPage(), ProfilePage()];
  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: tab, children: pages),
    bottomNavigationBar: NavigationBar(backgroundColor: const Color(0xFF110E20), indicatorColor: violet.withOpacity(.22),
      selectedIndex: tab, onDestinationSelected: (v) => setState(() => tab = v),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: violet), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore, color: violet), label: 'Explore'),
        NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble, color: violet), label: 'Messages'),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: violet), label: 'Profile'),
      ]),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(18, 14, 18, 24), children: [
    Row(children: [
      Container(width: 44, height: 44, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), gradient: const LinearGradient(colors: [violet, Color(0xFF5633C7)])), child: const Icon(Icons.graphic_eq, size: 27)),
      const SizedBox(width: 11), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('MEMORY', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        Text('VOICE PARTY', style: TextStyle(color: cyan, fontSize: 9, letterSpacing: 2.2, fontWeight: FontWeight.bold)),
      ])),
      _RoundAction(icon: Icons.search, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExplorePage()))),
      const SizedBox(width: 8), _RoundAction(icon: Icons.notifications_none, onTap: () => toast(context, 'No new notifications.')),
    ]),
    const SizedBox(height: 20),
    Container(height: 180, padding: const EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF51338F), Color(0xFF20183D), Color(0xFF102033)])),
      child: Stack(children: [
        Positioned(right: -8, top: 0, child: Icon(Icons.auto_awesome, size: 120, color: Colors.white.withOpacity(.08))),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: cyan.withOpacity(.15), borderRadius: BorderRadius.circular(20)), child: const Text('✦ LIVE VOICE PARTY', style: TextStyle(color: cyan, fontSize: 10, fontWeight: FontWeight.bold))),
          const Spacer(), const Text('Your people.\nYour vibe.', style: TextStyle(fontSize: 28, height: 1.08, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12), FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VoiceRoom())),
            icon: const Icon(Icons.headphones, size: 17), label: const Text('Join the party'), style: FilledButton.styleFrom(backgroundColor: violet)),
        ]),
      ]),
    ),
    const SizedBox(height: 24), const Text('Explore your vibe', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
    const SizedBox(height: 12), SizedBox(height: 43, child: ListView(scrollDirection: Axis.horizontal, children: const [
      _Chip(icon: Icons.bolt, text: 'For You', active: true), _Chip(icon: Icons.music_note, text: 'Music'),
      _Chip(icon: Icons.sports_esports, text: 'Games'), _Chip(icon: Icons.favorite_outline, text: 'Friends'), _Chip(icon: Icons.nightlight, text: 'Chill'),
    ])),
    const SizedBox(height: 23), Row(children: const [Expanded(child: Text('Trending rooms', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800))), Text('● LIVE NOW', style: TextStyle(color: Color(0xFFFF83AC), fontSize: 10, fontWeight: FontWeight.w900))]),
    const SizedBox(height: 13),
    GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .88,
      children: [
        _RoomCard(title: 'Royal Lounge', subtitle: 'Good vibes only', viewers: '1.2K', icon: Icons.workspace_premium, colors: const [Color(0xFF5E3BA6), Color(0xFF251746)], onTap: () => joinRoom(context)),
        _RoomCard(title: 'Late Night Talks', subtitle: 'Meet new friends', viewers: '864', icon: Icons.nightlight, colors: const [Color(0xFF174C60), Color(0xFF14213D)], onTap: () => joinRoom(context)),
        _RoomCard(title: 'Ludo Legends', subtitle: 'Play together', viewers: '526', icon: Icons.casino, colors: const [Color(0xFF74502C), Color(0xFF35203E)], onTap: () => joinRoom(context)),
        _RoomCard(title: 'Music & Chill', subtitle: 'Requests open', viewers: '309', icon: Icons.music_note, colors: const [Color(0xFF8B356D), Color(0xFF351D50)], onTap: () => joinRoom(context)),
      ]),
  ]));
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
    const Text('Explore', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
    const SizedBox(height: 6), const Text('Find a room that feels like you.', style: TextStyle(color: muted)),
    const SizedBox(height: 20), const TextField(decoration: InputDecoration(hintText: 'Search rooms, people, games', prefixIcon: Icon(Icons.search), filled: true)),
    const SizedBox(height: 24), const Text('Popular games', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)), const SizedBox(height: 12),
    for (final game in ['🎲  Ludo Classic', '🃏  Teen Patti VIP', '🔴  Carrom Master', '🁣  Domino King'])
      Card(color: panel, child: ListTile(title: Text(game), trailing: const Icon(Icons.chevron_right, color: cyan), onTap: () => joinRoom(context))),
    const SizedBox(height: 18), const Text('Live rooms', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
    for (final room in ['Royal Lounge', 'Late Night Talks', 'Music & Chill']) ListTile(leading: const CircleAvatar(backgroundColor: violet, child: Icon(Icons.graphic_eq)), title: Text(room), subtitle: const Text('10-seat voice room · Live'), trailing: const Icon(Icons.arrow_forward_ios, size: 14), onTap: () => joinRoom(context)),
  ]));
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
    const Text('Messages', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), const SizedBox(height: 7),
    const Text('Stay close to your people.', style: TextStyle(color: muted)), const SizedBox(height: 20),
    const TextField(decoration: InputDecoration(hintText: 'Search conversations', prefixIcon: Icon(Icons.search), filled: true)),
    const SizedBox(height: 14),
    for (final entry in [('Ayesha Khan', 'That room was so fun! 🎉'), ('Rahul Kumar', 'Come join our room tonight'), ('Sami Ahmed', 'Sent you a gift 🌹')])
      Card(color: panel, child: ListTile(leading: const CircleAvatar(backgroundColor: Color(0xFF47336B), child: Icon(Icons.person)), title: Text(entry.$1), subtitle: Text(entry.$2, style: const TextStyle(color: muted)), trailing: const Icon(Icons.chevron_right), onTap: () => toast(context, 'Messaging UI preview. A chat backend is required for real messages.'))),
  ]));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
    const Text('My profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), const SizedBox(height: 20),
    Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), gradient: const LinearGradient(colors: [Color(0xFF45317D), Color(0xFF1C1833)])),
      child: const Column(children: [
        CircleAvatar(radius: 42, backgroundColor: Color(0xFF30244F), child: Icon(Icons.person, size: 44, color: gold)),
        SizedBox(height: 12), Text('Your Party Profile', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
        SizedBox(height: 5), Text('ID: 10000001  •  Level 12', style: TextStyle(color: muted, fontSize: 12)),
        SizedBox(height: 18), LinearProgressIndicator(value: .68, minHeight: 6, backgroundColor: Color(0xFF3B3154), color: cyan),
        SizedBox(height: 8), Text('680 / 1,000 XP to Level 13', style: TextStyle(color: muted, fontSize: 11)),
      ])),
    const SizedBox(height: 16), Row(children: const [
      Expanded(child: _Balance(icon: Icons.monetization_on, title: 'Gold Coins', value: '10.2K', color: gold)),
      SizedBox(width: 8), Expanded(child: _Balance(icon: Icons.diamond, title: 'Diamonds', value: '250', color: cyan)),
      SizedBox(width: 8), Expanded(child: _Balance(icon: Icons.circle, title: 'Rubies', value: '80', color: Color(0xFFFF668D))),
    ]),
    const SizedBox(height: 22),
    _Option(icon: Icons.workspace_premium, title: 'VIP Membership', subtitle: 'Discover premium benefits', color: gold, onTap: () => toast(context, 'VIP service needs backend integration.')),
    _Option(icon: Icons.account_balance_wallet_outlined, title: 'Wallet & transactions', subtitle: 'Balance overview', color: cyan, onTap: () => showWallet(context)),
    _Option(icon: Icons.settings_outlined, title: 'Settings & privacy', subtitle: 'Account, safety and preferences', color: violet, onTap: () => toast(context, 'Settings UI can be connected next.')),
  ]));
}

class VoiceRoom extends StatefulWidget {
  const VoiceRoom({super.key});
  @override State<VoiceRoom> createState() => _VoiceRoomState();
}
class _VoiceRoomState extends State<VoiceRoom> {
  bool mic = true, speaker = true;
  final message = TextEditingController();
  final messages = <String>['Mina: Welcome everyone 💜', 'King Rahul: Let’s have fun!'];
  String banner = 'Welcome to Royal Lounge — good vibes only!';
  @override void dispose() { message.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: const Color(0xFF100B20), body: SafeArea(child: Column(children: [
    Padding(padding: const EdgeInsets.fromLTRB(8, 8, 14, 12), child: Row(children: [
      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.keyboard_arrow_down, size: 29)),
      Container(width: 43, height: 43, decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: const LinearGradient(colors: [violet, Color(0xFF5431A0)])), child: const Icon(Icons.workspace_premium, color: gold)),
      const SizedBox(width: 10), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Royal Lounge', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
        SizedBox(height: 3), Text('ID 862019  •  328 online', style: TextStyle(color: muted, fontSize: 11)),
      ])),
      _RoundAction(icon: Icons.share_outlined, onTap: () => toast(context, 'Room sharing needs a share link.')),
      const SizedBox(width: 6), _RoundAction(icon: Icons.more_horiz, onTap: () => toast(context, 'Room options')),
    ])),
    Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10), decoration: BoxDecoration(color: const Color(0xFF2C2042), borderRadius: BorderRadius.circular(14), border: Border.all(color: gold.withOpacity(.18))),
      child: Row(children: [const Icon(Icons.campaign, color: gold, size: 18), const SizedBox(width: 9), Expanded(child: Text(banner, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Color(0xFFE7DDFB))))])),
    const SizedBox(height: 14),
    Expanded(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 14), child: Column(children: [
      Container(width: double.infinity, padding: const EdgeInsets.fromLTRB(8, 15, 8, 14), decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF281C47), Color(0xFF171127)]), border: Border.all(color: violet.withOpacity(.17))),
        child: Column(children: [
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.graphic_eq, color: cyan, size: 17), SizedBox(width: 7), Text('VOICE STAGE', style: TextStyle(color: cyan, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2))]),
          const SizedBox(height: 16), GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 5, mainAxisSpacing: 13, crossAxisSpacing: 3, childAspectRatio: .72,
            children: List.generate(10, (i) => _Seat(index: i, occupied: [0, 1, 3, 5, 7].contains(i), muted: i == 3, onTap: () => toast(context, i == 0 ? 'Host seat.' : 'Seat requests need live server permissions.')))),
        ])),
      const SizedBox(height: 13), Container(width: double.infinity, padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.forum_outlined, color: violet, size: 17), SizedBox(width: 7), Text('Room chat', style: TextStyle(fontWeight: FontWeight.w800)), Spacer(), Text('LIVE', style: TextStyle(color: cyan, fontSize: 9, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 10), for (final msg in messages.take(5)) Padding(padding: const EdgeInsets.only(bottom: 7), child: Text(msg, style: const TextStyle(fontSize: 12, color: Color(0xFFE0DAF0)))),
          Wrap(spacing: 10, children: ['💜','😂','🔥','👏','🌹','🎉'].map((e) => InkWell(onTap: () => setState(() => banner = 'You reacted ' + e + ' in the room'), child: Text(e, style: const TextStyle(fontSize: 20))).toList()),
        ])),
    ]))),
    Container(padding: const EdgeInsets.fromLTRB(10, 9, 10, 12), decoration: const BoxDecoration(color: Color(0xFF0C0917), border: Border(top: BorderSide(color: Color(0x332F2850)))),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _Control(icon: mic ? Icons.mic : Icons.mic_off, label: 'Mic', active: mic, onTap: () => setState(() => mic = !mic)),
          _Control(icon: speaker ? Icons.volume_up : Icons.volume_off, label: 'Speaker', active: speaker, onTap: () => setState(() => speaker = !speaker)),
          _Control(icon: Icons.card_giftcard, label: 'Gifts', color: const Color(0xFFFF6EA8), onTap: () => _showGifts(context)),
          _Control(icon: Icons.sports_esports, label: 'Games', color: cyan, onTap: () => _showGames(context)),
          _Control(icon: Icons.logout, label: 'Leave', color: const Color(0xFFFF7589), onTap: () => Navigator.pop(context)),
        ]),
        const SizedBox(height: 10), Row(children: [
          Expanded(child: TextField(controller: message, onSubmitted: (_) => _send(), decoration: const InputDecoration(hintText: 'Say something nice...', contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 11), isDense: true))),
          const SizedBox(width: 8), Container(decoration: BoxDecoration(color: violet, borderRadius: BorderRadius.circular(15)), child: IconButton(onPressed: _send, icon: const Icon(Icons.send, color: Colors.white, size: 20))),
        ]),
      ])),
  ])));
  void _send() { final value = message.text.trim(); if (value.isEmpty) return; setState(() { messages.add('You: ' + value); message.clear(); }); }
  void _showGifts(BuildContext context) => showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => _GiftPanel(onSelect: (gift) {
    setState(() => banner = 'Selected ' + gift + ' — wallet validation required.');
    toast(context, 'Gift UI preview only. Real wallet/payment processing is not enabled.');
  }));
  void _showGames(BuildContext context) => showModalBottomSheet(context: context, builder: (_) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Padding(padding: EdgeInsets.all(18), child: Text('Mini-games', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900))),
    for (final game in ['🎲 Ludo Classic', '🃏 Teen Patti VIP', '🔴 Carrom Master', '🁣 Domino King']) ListTile(title: Text(game), trailing: const Icon(Icons.chevron_right), onTap: () { Navigator.pop(context); toast(context, 'Game preview; multiplayer game logic must be connected.'); }),
  ])));
}

class _GiftPanel extends StatefulWidget {
  final ValueChanged<String> onSelect;
  const _GiftPanel({required this.onSelect});
  @override State<_GiftPanel> createState() => _GiftPanelState();
}
class _GiftPanelState extends State<_GiftPanel> {
  int selected = 0;
  static const gifts = [('🌹','Rose','10'),('👑','Crown','1,000'),('🚀','Rocket','500'),('💍','Diamond Ring','2,000'),('🏎️','Super Car','5,000'),('🏰','Castle','10,000')];
  @override
  Widget build(BuildContext context) => SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(18, 18, 18, 22), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Send a gift', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 5), const Text('Choose a gift to light up the room.', style: TextStyle(color: muted, fontSize: 12)), const SizedBox(height: 17),
    GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: gifts.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.16, crossAxisSpacing: 9, mainAxisSpacing: 9),
      itemBuilder: (context, i) => InkWell(onTap: () => setState(() => selected = i), child: Container(decoration: BoxDecoration(color: selected == i ? violet.withOpacity(.20) : const Color(0xFF211A3A), borderRadius: BorderRadius.circular(16), border: Border.all(color: selected == i ? violet : Colors.white10)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(gifts[i].$1, style: const TextStyle(fontSize: 27)), const SizedBox(height: 4), Text(gifts[i].$2, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)), const SizedBox(height: 4), Text(gifts[i].$3 + ' coins', style: const TextStyle(color: gold, fontSize: 10))])))),
    const SizedBox(height: 15), SizedBox(width: double.infinity, child: FilledButton(onPressed: () { final gift = gifts[selected].$2; Navigator.pop(context); widget.onSelect(gift); }, style: FilledButton.styleFrom(backgroundColor: violet), child: const Text('Select gift'))),
  ])));
}

class _Chip extends StatelessWidget {
  final IconData icon; final String text; final bool active;
  const _Chip({required this.icon, required this.text, this.active = false});
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(right: 8), child: Container(padding: const EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: active ? violet : panel, borderRadius: BorderRadius.circular(22)),
    child: Row(children: [Icon(icon, size: 16, color: active ? Colors.white : muted), const SizedBox(width: 7), Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: active ? Colors.white : muted))])));
}
class _RoomCard extends StatelessWidget {
  final String title, subtitle, viewers; final IconData icon; final List<Color> colors; final VoidCallback onTap;
  const _RoomCard({required this.title, required this.subtitle, required this.viewers, required this.icon, required this.colors, required this.onTap});
  @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(22), child: Container(clipBehavior: Clip.antiAlias, decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors), border: Border.all(color: Colors.white12)),
    child: Stack(children: [
      Positioned(right: -12, top: -12, child: Icon(icon, size: 95, color: Colors.white.withOpacity(.08))),
      Padding(padding: const EdgeInsets.all(13), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('● LIVE', style: TextStyle(color: Color(0xFFFF8CAF), fontSize: 9, fontWeight: FontWeight.w900)), const Spacer(),
        Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withOpacity(.14), borderRadius: BorderRadius.circular(13)), child: Icon(icon)),
        const SizedBox(height: 9), Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        const SizedBox(height: 4), Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.white70)),
        const SizedBox(height: 10), Row(children: [const Icon(Icons.headphones, size: 13, color: cyan), const SizedBox(width: 4), Text(viewers, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)), const Spacer(), const Icon(Icons.arrow_forward, size: 15)]),
      ])),
    ]));
}
class _Seat extends StatelessWidget {
  final int index; final bool occupied, muted; final VoidCallback onTap;
  const _Seat({required this.index, required this.occupied, required this.muted, required this.onTap});
  @override Widget build(BuildContext context) {
    const names = ['KING', 'Mina', 'Seat 3', 'Ayan', 'Seat 5', 'Rafi', 'Seat 7', 'Lia', 'Seat 9', 'Seat 10'];
    const colors = [Color(0xFF9B6CFF), Color(0xFF3A8C9D), Color(0xFFB15D88), Color(0xFFB17A3B)];
    final king = index == 0;
    return InkWell(onTap: onTap, child: Column(children: [
      Container(padding: const EdgeInsets.all(3), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: king ? gold : occupied ? colors[index % colors.length] : const Color(0xFF55496E), width: king ? 2.5 : 1.5), boxShadow: king ? [BoxShadow(color: gold.withOpacity(.2), blurRadius: 12)] : null),
        child: CircleAvatar(radius: king ? 22 : 19, backgroundColor: occupied ? colors[index % colors.length].withOpacity(.28) : const Color(0xFF29223B),
          child: occupied ? Icon(king ? Icons.workspace_premium : Icons.person, size: king ? 22 : 20, color: king ? gold : Colors.white70) : const Icon(Icons.add, size: 19, color: muted))),
      const SizedBox(height: 5), Text(occupied ? names[index] : 'Empty seat', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: king ? gold : occupied ? Colors.white : muted)),
      const SizedBox(height: 3), Icon(muted ? Icons.mic_off : occupied ? Icons.graphic_eq : Icons.circle_outlined, size: 11, color: muted ? const Color(0xFFFF7C90) : occupied ? cyan : const Color(0xFF55496E)),
    ]));
  }
}
class _Control extends StatelessWidget {
  final IconData icon; final String label; final Color color; final bool active; final VoidCallback onTap;
  const _Control({required this.icon, required this.label, required this.onTap, this.color = muted, this.active = false});
  @override Widget build(BuildContext context) => InkWell(onTap: onTap, child: SizedBox(width: 56, child: Column(children: [
    Container(width: 42, height: 42, decoration: BoxDecoration(color: (active ? violet : color).withOpacity(.15), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: active ? Colors.white : color, size: 21)),
    const SizedBox(height: 5), Text(label, style: const TextStyle(fontSize: 10, color: muted)),
  ])));
}
class _RoundAction extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _RoundAction({required this.icon, required this.onTap});
  @override Widget build(BuildContext context) => Material(color: panel, borderRadius: BorderRadius.circular(14), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14), child: SizedBox(width: 40, height: 40, child: Icon(icon, size: 20, color: Colors.white70))));
}
class _Balance extends StatelessWidget {
  final IconData icon; final String title, value; final Color color;
  const _Balance({required this.icon, required this.title, required this.value, required this.color});
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(18)), child: Column(children: [
    Icon(icon, color: color), const SizedBox(height: 7), Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)), const SizedBox(height: 4), Text(title, style: const TextStyle(fontSize: 9, color: muted), textAlign: TextAlign.center),
  ]));
}
class _Option extends StatelessWidget {
  final IconData icon; final String title, subtitle; final Color color; final VoidCallback onTap;
  const _Option({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});
  @override Widget build(BuildContext context) => Card(color: panel, child: ListTile(onTap: onTap, leading: Icon(icon, color: color), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(subtitle, style: const TextStyle(color: muted, fontSize: 11)), trailing: const Icon(Icons.chevron_right, color: muted)));
}
void toast(BuildContext context, String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating));
void joinRoom(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => const VoiceRoom()));
void showWallet(BuildContext context) => showModalBottomSheet(context: context, builder: (_) => SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: const [
  Text('Wallet overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), SizedBox(height: 8),
  Text('Design preview balances only — not live account data.', style: TextStyle(color: muted, fontSize: 12)), SizedBox(height: 18),
  Row(children: [Expanded(child: _Balance(icon: Icons.monetization_on, title: 'Gold Coins', value: '10.2K', color: gold)), SizedBox(width: 8), Expanded(child: _Balance(icon: Icons.diamond, title: 'Diamonds', value: '250', color: cyan)), SizedBox(width: 8), Expanded(child: _Balance(icon: Icons.circle, title: 'Rubies', value: '80', color: Color(0xFFFF668D)))]),
  SizedBox(height: 20),
])));
