import 'package:flutter/material.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'language_model.dart';

class LocaleText {
  Map<LanguageName, String> _map = Map();

  LocaleText({
    @required thai,
    @required english,
    @required chinese,
    @required japanese,
    @required korean,
    @required lao,
    @required myanmar,
    @required vietnamese,
    @required khmer,
    @required malay,
    @required indonesian,
    //@required filipino,
  }) {
    _map[LanguageName.thai] = thai;
    _map[LanguageName.english] = english;
    _map[LanguageName.chinese] = chinese;
    _map[LanguageName.japanese] = japanese;
    _map[LanguageName.korean] = korean;
    _map[LanguageName.lao] = lao;
    _map[LanguageName.myanmar] = myanmar;
    _map[LanguageName.vietnamese] = vietnamese;
    _map[LanguageName.khmer] = khmer;
    _map[LanguageName.malay] = malay;
    _map[LanguageName.indonesian] = indonesian;
    //_map[LanguageName.filipino] = filipino;
  }

  String ofLanguage(LanguageName languageName) {
    return _map[languageName] ?? _map[LanguageName.english];
  }

  factory LocaleText.home() {
    return LocaleText(
      thai: 'หน้าหลัก',
      english: 'Home',
      chinese: "首页",
      japanese: "ホーム",
      korean: "홈",
      lao: "ໜ້າຫຼັກ",
      vietnamese: "Trang Chủ",
      myanmar: "ပင္ပမ်က္ႏွာစာ",
      khmer: "ទំព័រមេ",
      malay: "Laman utama",
      indonesian: "Beranda",
    );
  }

  factory LocaleText.aboutUs() {
    return LocaleText(
      thai: "เกี่ยวกับเรา",
      english: "About Us",
      chinese: "关于我们",
      japanese: "このサイトに関して",
      korean: "우리에 대해",
      lao: "ກ່ຽວ​ກັບ​ພວກ​ເຮົາ",
      vietnamese: "Về chúng tôi",
      myanmar: "ကိုယ္တို႔အေၾကာင္း",
      khmer: "អំពី​ពួក​យើង",
      malay: "Tentang kita",
      indonesian: "Tentang kami",
    );
  }

  factory LocaleText.questionnaire() {
    return LocaleText(
      thai: "แบบสอบถาม",
      english: "Questionnaire",
      chinese: "疑问句",
      japanese: "アンケート",
      korean: "순순히 질문하다",
      lao: "ແບບສອບຖາມ",
      vietnamese: "Bảng câu hỏi",
      myanmar: "ေမးခြန္းလႊာ",
      khmer: "កម្រងសំណួរ",
      malay: "Soal selidik",
      indonesian: "Daftar pertanyaan",
    );
  }

  factory LocaleText.help() {
    return LocaleText(
      thai: "ช่วยเหลือ",
      english: "Help",
      chinese: "救命",
      japanese: "問い合わせ",
      korean: "돕다",
      lao: "ຊ່ວຍເຫຼືອ",
      vietnamese: "Cứu giúp",
      myanmar: "အကူအညီ",
      khmer: "ជួយ",
      malay: "Membantu",
      indonesian: "Membantu",
    );
  }

  factory LocaleText.widget() {
    return LocaleText(
      thai: "วิดเจ็ต",
      english: "Widget",
      chinese: "小部件",
      japanese: "ウィジェット",
      korean: "위젯",
      lao: "ວິດເຈັດ",
      vietnamese: "Widget",
      myanmar: "ဝစ္ဂ်က္",
      khmer: "ធាតុក្រាហ្វិក",
      malay: "Widget",
      indonesian: "Widget",
    );
  }

  factory LocaleText.settings() {
    return LocaleText(
      thai: "ตั้งค่า",
      english: "Settings",
      chinese: "设置",
      japanese: "設定",
      korean: "설정",
      lao: "ຕັ້ງ​ຄ່າ",
      vietnamese: "Cài đặt",
      myanmar: "တပ္ဆင္ရန္",
      khmer: "ការកំណត់",
      malay: "Tetapan",
      indonesian: "Seting",
    );
  }

  factory LocaleText.faq() {
    return LocaleText(
      thai: "คำถามที่พบบ่อย",
      english: "FAQ",
      chinese: "常问问题",
      japanese: "よくある質問",
      korean: "자주하는 질문",
      lao: "ຄຳ ຖາມທີ່ຖືກຖາມເລື້ອຍໆ",
      vietnamese: "câu hỏi thường gặp",
      myanmar: "အမြဲမေးလေ့ရှိသောမေးခွန်းများ",
      khmer: "សំណួរដែលសួរជាញឹកញាប់",
      malay: "Soalan Lazim",
      indonesian: "pertanyaan yang sering ditanyakan",
    );
  }

  factory LocaleText.search() {
    return LocaleText(
      thai: 'ค้นหา',
      english: 'Search',
      chinese: '搜索',
      japanese: '探す',
      korean: '검색',
      lao: 'ຄົ້ນຫາ',
      vietnamese: 'Tìm kiếm',
      myanmar: 'ရှာဖွေသည်',
      khmer: 'ស្វែងរក',
      malay: 'cari',
      indonesian: 'Cari',
    );
  }

  factory LocaleText.searchService() {
    return LocaleText(
      thai: 'ค้นหาบริการ',
      english: 'Search Service',
      chinese: '搜索服务',
      japanese: '検索サービス',
      korean: '검색 서비스',
      lao: 'ບໍລິການຄົ້ນຫາ',
      vietnamese: 'dịch vụ tìm kiếm',
      myanmar: 'ရှာဖွေရေးဝန်ဆောင်မှု',
      khmer: 'សេវាកម្មស្វែងរក',
      malay: 'perkhidmatan carian',
      indonesian: 'layanan pencarian',
    );
  }

  factory LocaleText.searchPlace() {
    return LocaleText(
      thai: 'ค้นหาเส้นทาง',
      english: 'Search Place',
      chinese: '搜索地点',
      japanese: '検索場所',
      korean: '장소 검색',
      lao: 'ສະຖານທີ່ຄົ້ນຫາ',
      vietnamese: 'địa điểm tìm kiếm',
      myanmar: 'ရှာသောအရပ်',
      khmer: 'កន្លែងស្វែងរក',
      malay: 'mencari tempat',
      indonesian: 'mencari tempat',
    );
  }

  factory LocaleText.notification() {
    return LocaleText(
      thai: 'การแจ้งเตือน',
      english: 'Notification',
      chinese: "通知",
      japanese: "通知",
      korean: "알림",
      lao: "ຄໍາປະກາດ",
      vietnamese: "Thông báo",
      myanmar: "အသိေပးခ်က္",
      khmer: "ការជូនដំណឹង",
      malay: "Pemberitahuan",
      indonesian: "Pemberitahuan",
    );
  }

  factory LocaleText.incident() {
    return LocaleText(
      thai: 'เหตุการณ์',
      english: 'Incident',
      chinese: "事件",
      japanese: "事件",
      korean: "사건",
      lao: "ເຫດການ",
      vietnamese: "Biến cố",
      myanmar: "အျဖစ္အပ်က္",
      khmer: "ឧប្បត្តិហេតុ",
      malay: "Kejadian",
      indonesian: "Kejadian",
    );
  }

  factory LocaleText.route() {
    return LocaleText(
      thai: 'เส้นทาง',
      english: 'Route',
      chinese: "航线",
      japanese: "ルート",
      korean: "경로",
      lao: "ເສັ້ນທາງ",
      vietnamese: "Tuyến đường",
      myanmar: "လမ္းေၾကာင္း",
      khmer: "ផ្លូវ",
      malay: "Laluan",
      indonesian: "Rute",
    );
  }

  factory LocaleText.favorite() {
    return LocaleText(
      thai: 'รายการโปรด',
      english: 'Favorite',
      chinese: "最爱",
      japanese: "お気に入る",
      korean: "마음에 드는",
      lao: "ມັກ",
      vietnamese: "Yêu thích",
      myanmar: "အၾကိဳက္",
      khmer: "ចូលចិត្ត",
      malay: "Kegemaran",
      indonesian: "Favorit",
    );
  }

  factory LocaleText.yes() {
    return LocaleText(
      thai: 'ใช่',
      english: 'YES',
      chinese: '是',
      japanese: 'はい',
      korean: '예',
      lao: 'ແມ່ນແລ້ວ',
      vietnamese: 'Đúng',
      myanmar: 'ဟုတ်တယ်',
      khmer: 'បាទ / ចាស',
      malay: 'iya',
      indonesian: 'Iya',
    );
  }

  factory LocaleText.restartNow() {
    return LocaleText(
      thai: 'เริ่มใหม่เดี๋ยวนี้',
      english: 'RESTART NOW',
      //chinese: '现在重启',
      chinese: '是',
      japanese: 'はい',
      korean: '예',
      lao: 'ແມ່ນແລ້ວ',
      vietnamese: 'Đúng',
      myanmar: 'ဟုတ်တယ်',
      khmer: 'បាទ / ចាស',
      malay: 'iya',
      indonesian: 'Iya',
    );
  }

  factory LocaleText.no() {
    return LocaleText(
      thai: 'ไม่ใช่',
      english: 'NO',
      chinese: '没有',
      japanese: '番号',
      korean: '아니',
      lao: 'ບໍ່',
      vietnamese: 'Không',
      myanmar: 'မဟုတ်ဘူး',
      khmer: 'ទេ',
      malay: 'tidak',
      indonesian: 'tidak',
    );
  }

  factory LocaleText.confirmExit() {
    return LocaleText(
      thai: 'แน่ใจว่าต้องการออกจาก ${Constants.App.NAME}?',
      english: 'Are you sure you want to exit?',
      chinese: '你确定要离开？',
      japanese: '本当に終了してもよろしいですか？',
      korean: '종료 하시겠습니까?',
      lao: 'ທ່ານແນ່ໃຈບໍ່ວ່າທ່ານຕ້ອງການອອກ?',
      vietnamese: 'Bạn có chắc bạn muốn thoát?',
      myanmar: 'မင်းထွက်ချင်တာသေချာလား',
      khmer: 'តើអ្នកពិតជាចង់ចាកចេញមែនទេ?',
      malay: 'Anda pasti untuk keluar?',
      indonesian: 'Anda yakin ingin keluar?',
    );
  }

  factory LocaleText.confirmRestart() {
    return LocaleText(
      thai:
          '${Constants.App.NAME} จำเป็นต้องเริ่มการทำงานใหม่เมื่อมีการเปลี่ยนภาษา คุณต้องการให้เริ่มการทำงานใหม่เดี๋ยวนี้หรือไม่',
      english: 'Restart required. Do you want to restart ${Constants.App.NAME} now?',
      chinese: '需要重新启动。 您要立即重新启动${Constants.App.NAME}吗？',
      japanese: '再起動が必要です。 今すぐEXATを再起動しますか？',
      korean: '다시 시작해야합니다. 지금 EXAT를 다시 시작 하시겠습니까?',
      lao: 'ຕ້ອງການເລີ່ມ ໃໝ່. ທ່ານຕ້ອງການເລີ່ມ ໃໝ່ EXAT ແລ້ວບໍ?',
      vietnamese: 'Yêu cầu khởi động lại. Bạn có muốn khởi động lại EXAT ngay bây giờ không?',
      myanmar: 'ပြန်လည်စတင်ရန်လိုအပ်သည်။ သင်ယခု EXAT ကိုပြန်လည်စတင်လိုပါသလား။',
      khmer: 'ទាមទារការចាប់ផ្តើមឡើងវិញ។ តើអ្នកចង់ចាប់ផ្តើម EXAT ឡើងវិញទេ?',
      malay: 'Mulakan semula diperlukan. Adakah anda mahu memulakan semula EXAT sekarang?',
      indonesian: 'Perlu restart. Apakah Anda ingin memulai ulang EXAT sekarang?',
    );
  }

  factory LocaleText.language() {
    return LocaleText(
      thai: 'ภาษา',
      english: 'Language',
      chinese: '语言',
      japanese: '言語',
      korean: '언어',
      lao: 'ພາສາ',
      vietnamese: 'ngôn ngữ',
      myanmar: 'ဘာသာစကား',
      khmer: 'ភាសា',
      malay: 'bahasa',
      indonesian: 'bahasa',
    );
  }

  factory LocaleText.videoStreaming() {
    return LocaleText(
      thai: 'ภาพเคลื่อนไหว',
      english: 'Video Streaming',
      chinese: '视频流',
      japanese: 'ビデオストリーミング',
      korean: '비디오 스트리밍',
      lao: 'ການຖ່າຍທອດວີດີໂອ',
      vietnamese: 'phát trực tuyến video',
      myanmar: 'ဗွီဒီယို streaming',
      khmer: 'ការចាក់វីដេអូ',
      malay: 'penstriman video',
      indonesian: 'streaming video',
    );
  }

  factory LocaleText.photo() {
    return LocaleText(
      thai: 'ภาพนิ่ง',
      english: 'Photo',
      chinese: '照片',
      japanese: '写真',
      korean: '사진',
      lao: 'ຮູບພາບ',
      vietnamese: 'ảnh',
      myanmar: 'ဓာတ်ပုံ',
      khmer: 'រូបថត',
      malay: 'gambar',
      indonesian: 'foto',
    );
  }

  factory LocaleText.emergencyCall() {
    return LocaleText(
      thai: "เบอร์โทรฉุกเฉิน",
      english: "Emergency Call",
      chinese: "紧急电话",
      japanese: '緊急通話',
      korean: '긴급 전화',
      lao: 'ໂທສຸກເສີນ',
      vietnamese: 'cuộc gọi khẩn cấp',
      myanmar: 'အရေးပေါ်ခေါ်ဆိုမှု',
      khmer: 'ហៅ​ទៅកាន់​ផ្នែក​សង្គ្រោះ​បន្ទាន់',
      malay: 'panggilan kecemasan',
      indonesian: 'telepon darurat',
    );
  }

  factory LocaleText.termsAndConditions() {
    return LocaleText(
      thai: "ข้อตกลงและเงื่อนไข",
      english: "Terms And Conditions",
      chinese: "附带条约",
      japanese: '規約と条件',
      korean: '이용 약관',
      lao: 'ຂໍ້ ກຳ ນົດແລະເງື່ອນໄຂ',
      vietnamese: 'các điều khoản và điều kiện',
      myanmar: 'စည်းကမ်းနှင့်သတ်မှတ်ချက်များ',
      khmer: 'ល័ក្ខខ័ណ្ឌ',
      malay: 'terma dan syarat',
      indonesian: 'syarat dan ketentuan',
    );
  }

  factory LocaleText.expressWay() {
    return LocaleText(
      thai: 'ทางพิเศษ',
      english: 'Expressway',
      chinese: '高速公路',
      japanese: '高速道路',
      korean: '고속도로',
      lao: 'ທາງດ່ວນ',
      vietnamese: 'đường cao tốc',
      myanmar: 'အမြန်လမ်း',
      khmer: 'ផ្លូវល្បឿនលឿន',
      malay: 'lebuh raya',
      indonesian: 'jalan tol',
    );
  }

  factory LocaleText.fourWheels() {
    return LocaleText(
      thai: '4 ล้อ',
      english: '4 Wheels',
      chinese: "4轮",
      japanese: "4輪",
      korean: "바퀴 4개",
      lao: "ລົດ 4 ລໍ້",
      vietnamese: "Bánh xe 4 ",
      myanmar: "ကား 4 ဘီး",
      khmer: "4 កង់",
      malay: "4 Roda",
      indonesian: "4 roda",
    );
  }

  factory LocaleText.sixToTenWheels() {
    return LocaleText(
      thai: '6-10 ล้อ',
      english: '6-10 Wheels',
      chinese: "6-10轮",
      japanese: "6-10輪",
      korean: "바퀴 6-10개",
      lao: "ລົດ 6-10 ລໍ້",
      vietnamese: "Bánh xe 6-10",
      myanmar: "ကား 6-10 ဘီး",
      khmer: "6-10 កង់",
      malay: "6-10 Roda ",
      indonesian: "6-10 roda",
    );
  }

  factory LocaleText.overTenWheels() {
    return LocaleText(
      thai: 'เกิน 10 ล้อ',
      english: 'Over 10 Wheels',
      chinese: '超过10个轮子',
      japanese: '10を超える車輪',
      korean: '10 개 이상의 바퀴',
      lao: 'ເກີນ 10 ລໍ້',
      vietnamese: 'trên 10 bánh xe',
      myanmar: 'ဘီး ၁၀ ခုကျော်',
      khmer: 'លើសពី ១០ កង់',
      malay: 'lebih dari 10 roda',
      indonesian: 'lebih dari 10 roda',
    );
  }

  factory LocaleText.totalTolls() {
    return LocaleText(
      thai: 'ค่าผ่านทางรวม',
      english: 'Total tolls',
      chinese: '工具总数',
      japanese: 'トータルツール',
      korean: '총 도구',
      lao: 'ເຄື່ອງມືທັງ ໝົດ',
      vietnamese: 'tổng số công cụ',
      myanmar: 'စုစုပေါင်း tools များ',
      khmer: 'ឧបករណ៍សរុប',
      malay: 'jumlah alat',
      indonesian: 'alat total',
    );
  }

  factory LocaleText.baht() {
    return LocaleText(
      thai: 'บาท',
      english: 'Baht',
      chinese: '铢',
      japanese: 'バーツ',
      korean: '바트',
      lao: 'ບາດ',
      vietnamese: 'baht',
      myanmar: 'ဘတ်',
      khmer: 'បាត',
      malay: 'baht',
      indonesian: 'baht',
    );
  }

  factory LocaleText.lane() {
    return LocaleText(
      thai: 'ช่อง',
      english: 'lane',
      chinese: '车道',
      japanese: 'Lane',
      korean: '레인',
      lao: 'ຊ່ອງທາງ',
      vietnamese: 'làn đường',
      myanmar: 'လမ်း',
      khmer: 'ផ្លូវតូច',
      malay: 'lorong',
      indonesian: 'jalur',
    );
  }

  factory LocaleText.distanceBasedTolls() {
    return LocaleText(
      thai: 'ค่าผ่านทางตามระยะทาง',
      english: 'Distance-based tolls',
      chinese: '基于距离的通行费',
      japanese: '距離ベースの通行料',
      korean: '거리 기반 통행료',
      lao: 'ຄ່າໂທຕາມໄລຍະທາງ',
      vietnamese: 'Phí cầu đường dựa trên khoảng cách',
      myanmar: 'အကွာအဝေး -based သေဆုံးသူ',
      khmer: 'ចំនួនទឹកប្រាក់ផ្អែកលើចម្ងាយ',
      malay: 'Tol berdasarkan jarak',
      indonesian: 'Tol berbasis jarak',
    );
  }
}
