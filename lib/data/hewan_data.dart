/// Model Hewan — PRD D.2 (20 hewan umum, PRD B.2.4)
class HewanItem {
  final String nama;
  final String kategori; // "darat" | "air" | "terbang"
  final String suara;    // "Meong!"
  final String fakta;    // 1 kalimat sederhana
  final String emoji;    // ilustrasi placeholder
  final String audioPath;
  final String imagePath;
  HewanItem(this.nama, this.kategori, this.suara, this.fakta, this.emoji)
      : audioPath = 'assets/audio/hewan/${nama.toLowerCase().replaceAll('-', '').replaceAll(' ', '')}.mp3',
        imagePath = 'assets/images/hewan/${nama.toLowerCase().replaceAll('-', '').replaceAll(' ', '')}.png';
}

final List<HewanItem> daftarHewan = [
  HewanItem('Kucing', 'darat', 'Meong!', 'Kucing suka makan ikan.', '🐱'),
  HewanItem('Anjing', 'darat', 'Guk guk!', 'Anjing adalah sahabat manusia.', '🐶'),
  HewanItem('Sapi', 'darat', 'Moo!', 'Sapi suka makan rumput.', '🐄'),
  HewanItem('Ayam', 'darat', 'Kukuruyuk!', 'Ayam bisa bertelur.', '🐔'),
  HewanItem('Kambing', 'darat', 'Mbek!', 'Kambing suka makan rumput.', '🐐'),
  HewanItem('Kuda', 'darat', 'Hiiin!', 'Kuda bisa berlari kencang.', '🐴'),
  HewanItem('Kelinci', 'darat', 'Hop hop!', 'Kelinci suka makan wortel.', '🐰'),
  HewanItem('Bebek', 'air', 'Kwek kwek!', 'Bebek suka berenang di kolam.', '🦆'),
  HewanItem('Ikan', 'air', 'Blup blup!', 'Ikan bernapas di dalam air.', '🐟'),
  HewanItem('Burung', 'terbang', 'Cip cip!', 'Burung bisa terbang tinggi.', '🐦'),
  HewanItem('Gajah', 'darat', 'Prett!', 'Gajah punya belalai panjang.', '🐘'),
  HewanItem('Harimau', 'darat', 'Aum!', 'Harimau adalah kucing besar.', '🐯'),
  HewanItem('Monyet', 'darat', 'Ook ook!', 'Monyet suka makan pisang.', '🐵'),
  HewanItem('Kura-kura', 'air', 'Sss', 'Kura-kura berjalan lambat.', '🐢'),
  HewanItem('Katak', 'air', 'Krek krek!', 'Katak bisa melompat jauh.', '🐸'),
  HewanItem('Semut', 'darat', 'Cicit!', 'Semut kuat mengangkat beban.', '🐜'),
  HewanItem('Lebah', 'terbang', 'Bzzz!', 'Lebah membuat madu.', '🐝'),
  HewanItem('Kupu-kupu', 'terbang', 'Pip pip!', 'Kupu-kupu suka hinggap di bunga.', '🦋'),
  HewanItem('Ulat', 'darat', 'Cicit!', 'Ulat berubah menjadi kupu-kupu.', '🐛'),
  HewanItem('Kepiting', 'air', 'Klik klik!', 'Kepiting berjalan menyamping.', '🦀'),
];
