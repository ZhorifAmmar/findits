import 'package:flutter/material.dart';

// ===== main.dart =====
void main() => runApp(const FindItsApp());

class FindItsApp extends StatelessWidget {
  const FindItsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FindIts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF8E2C55),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

// ===== models/item.dart =====
enum ItemType { hilang, temuan }

enum ItemStatus { dilaporkan, ditemukan, dalamVerifikasi, diserahkan }

extension ItemStatusLabel on ItemStatus {
  String get label {
    switch (this) {
      case ItemStatus.dilaporkan:
        return 'Dilaporkan';
      case ItemStatus.ditemukan:
        return 'Ditemukan';
      case ItemStatus.dalamVerifikasi:
        return 'Dalam Verifikasi';
      case ItemStatus.diserahkan:
        return 'Diserahkan';
    }
  }
}

class Item {
  final String id;
  final ItemType tipe;
  final String judul;
  final String deskripsi;
  final String kategori;
  final String lokasi;
  final DateTime waktu;
  final ItemStatus status;

  const Item({
    required this.id,
    required this.tipe,
    required this.judul,
    required this.deskripsi,
    required this.kategori,
    required this.lokasi,
    required this.waktu,
    required this.status,
  });
}

const List<String> kategoriList = [
  'Dompet',
  'HP',
  'Kunci',
  'Kartu',
  'Tas',
  'Laptop',
  'Lainnya',
];

// Data dummy sementara. Minggu 12-13 diganti data dari Supabase (tabel items).
final List<Item> dummyItems = [
  Item(
    id: '1',
    tipe: ItemType.hilang,
    judul: 'Dompet kulit hitam',
    deskripsi: 'Berisi KTM dan kartu ATM, hilang setelah kuliah pagi.',
    kategori: 'Dompet',
    lokasi: 'Gedung Departemen Sistem Informasi',
    waktu: DateTime(2026, 11, 13, 10, 30),
    status: ItemStatus.dilaporkan,
  ),
  Item(
    id: '2',
    tipe: ItemType.temuan,
    judul: 'Kunci motor Honda',
    deskripsi: 'Ditemukan di dekat parkiran, gantungan kunci warna biru.',
    kategori: 'Kunci',
    lokasi: 'Parkiran Gerbang Utama',
    waktu: DateTime(2026, 11, 13, 15, 0),
    status: ItemStatus.ditemukan,
  ),
  Item(
    id: '3',
    tipe: ItemType.hilang,
    judul: 'Laptop ASUS abu-abu',
    deskripsi: 'Tertinggal di meja baca lantai 2, ada stiker kucing.',
    kategori: 'Laptop',
    lokasi: 'Perpustakaan ITS',
    waktu: DateTime(2026, 11, 12, 16, 45),
    status: ItemStatus.dalamVerifikasi,
  ),
  Item(
    id: '4',
    tipe: ItemType.temuan,
    judul: 'Kartu Tanda Mahasiswa',
    deskripsi: 'KTM ditemukan di lantai koridor, sudah dititipkan ke satpam.',
    kategori: 'Kartu',
    lokasi: 'Koridor Gedung Teknik Informatika',
    waktu: DateTime(2026, 11, 12, 9, 15),
    status: ItemStatus.diserahkan,
  ),
  Item(
    id: '5',
    tipe: ItemType.hilang,
    judul: 'Tas ransel hitam',
    deskripsi: 'Ransel merk Eiger, berisi buku catatan dan charger.',
    kategori: 'Tas',
    lokasi: 'Kantin Pusat',
    waktu: DateTime(2026, 11, 11, 12, 0),
    status: ItemStatus.dilaporkan,
  ),
  Item(
    id: '6',
    tipe: ItemType.temuan,
    judul: 'HP Samsung layar retak',
    deskripsi: 'Ditemukan di bangku taman, casing transparan.',
    kategori: 'HP',
    lokasi: 'Taman Alumni',
    waktu: DateTime(2026, 11, 11, 17, 20),
    status: ItemStatus.ditemukan,
  ),
];

// ===== widgets/status_badge.dart =====
class StatusBadge extends StatelessWidget {
  final ItemStatus status;

  const StatusBadge({super.key, required this.status});

  Color get _color {
    switch (status) {
      case ItemStatus.dilaporkan:
        return Colors.blueGrey;
      case ItemStatus.ditemukan:
        return Colors.orange;
      case ItemStatus.dalamVerifikasi:
        return Colors.indigo;
      case ItemStatus.diserahkan:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}

// ===== widgets/item_card.dart =====
class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback? onTap;

  const ItemCard({super.key, required this.item, this.onTap});

  IconData _icon(String kategori) {
    switch (kategori) {
      case 'Dompet':
        return Icons.account_balance_wallet;
      case 'HP':
        return Icons.smartphone;
      case 'Kunci':
        return Icons.vpn_key;
      case 'Kartu':
        return Icons.badge;
      case 'Tas':
        return Icons.backpack;
      case 'Laptop':
        return Icons.laptop;
      default:
        return Icons.inventory_2;
    }
  }

  String _fmt(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final mi = d.minute.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year} $hh:$mi';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLost = item.tipe == ItemType.hilang;
    final tipeColor = isLost ? Colors.red : Colors.teal;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _icon(item.kategori),
                  size: 32,
                  color: cs.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: tipeColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isLost ? 'HILANG' : 'TEMUAN',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusBadge(status: item.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.judul,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.place, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.lokasi,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          _fmt(item.waktu),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== screens/login_screen.dart =====
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO minggu 12: ganti dengan supabase.auth.signInWithPassword()
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: cs.primaryContainer,
                    child: Icon(Icons.search, size: 48, color: cs.primary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'FindIts',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Temukan barangmu kembali di lingkungan ITS'),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!v.contains('@')) return 'Format email tidak valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _password,
                    obscureText: _hidePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () =>
                            setState(() => _hidePassword = !_hidePassword),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password wajib diisi';
                      if (v.length < 6) return 'Minimal 6 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Text('Masuk'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RegisterScreen()),
                    ),
                    child: const Text('Belum punya akun? Daftar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===== screens/register_screen.dart =====
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _nrp = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _nama.dispose();
    _nrp.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO minggu 12: supabase.auth.signUp() lalu insert ke tabel profiles
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun berhasil dibuat. Silakan masuk.')),
      );
      Navigator.pop(context);
    }
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      );

  String? _required(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nama,
                  textCapitalization: TextCapitalization.words,
                  decoration: _dec('Nama lengkap', Icons.person_outline),
                  validator: (v) => _required(v, 'Nama'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nrp,
                  keyboardType: TextInputType.number,
                  decoration: _dec('NRP / identitas', Icons.badge_outlined),
                  validator: (v) => _required(v, 'NRP'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _dec('Email', Icons.email_outlined),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Email wajib diisi';
                    }
                    if (!v.contains('@')) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _password,
                  obscureText: _hidePassword,
                  decoration: _dec('Password', Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _hidePassword = !_hidePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password wajib diisi';
                    if (v.length < 6) return 'Minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirm,
                  obscureText: true,
                  decoration:
                      _dec('Konfirmasi password', Icons.lock_reset_outlined),
                  validator: (v) =>
                      v != _password.text ? 'Password tidak sama' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _submit,
                    child: const Text('Daftar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===== screens/home_screen.dart =====
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  ItemType? _tipe; // null = semua
  String _kategori = 'Semua';

  List<Item> get _filtered {
    final q = _query.toLowerCase();
    return dummyItems.where((i) {
      final matchQuery = q.isEmpty ||
          i.judul.toLowerCase().contains(q) ||
          i.deskripsi.toLowerCase().contains(q);
      final matchTipe = _tipe == null || i.tipe == _tipe;
      final matchKategori = _kategori == 'Semua' || i.kategori == _kategori;
      return matchQuery && matchTipe && matchKategori;
    }).toList();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    final kategoriOptions = ['Semua', ...kategoriList];

    return Scaffold(
      appBar: AppBar(
        title: const Text('FindIts'),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _snack('Form laporan dikerjakan di minggu 12'),
        icon: const Icon(Icons.add),
        label: const Text('Lapor'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Cari barang...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Semua'),
                  selected: _tipe == null,
                  onSelected: (_) => setState(() => _tipe = null),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Hilang'),
                  selected: _tipe == ItemType.hilang,
                  onSelected: (_) => setState(() => _tipe = ItemType.hilang),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Temuan'),
                  selected: _tipe == ItemType.temuan,
                  onSelected: (_) => setState(() => _tipe = ItemType.temuan),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: kategoriOptions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final k = kategoriOptions[i];
                return FilterChip(
                  label: Text(k),
                  selected: _kategori == k,
                  onSelected: (_) => setState(() => _kategori = k),
                );
              },
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('Tidak ada laporan yang cocok'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: items.length,
                    itemBuilder: (_, i) => ItemCard(
                      item: items[i],
                      onTap: () =>
                          _snack('Detail Barang dikerjakan di minggu 12-13'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

