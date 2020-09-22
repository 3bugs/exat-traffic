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
      thai: "ข้อกำหนดและเงื่อนไข",
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

  factory LocaleText.amountBaht() {
    return LocaleText(
      thai: '%d บาท',
      english: '%d Baht',
      chinese: '%d泰铢',
      japanese: '%dバーツ',
      korean: '%d 바트',
      lao: '%d ບາດ',
      vietnamese: '%d Baht',
      myanmar: '%d Baht',
      khmer: '%d បាត',
      malay: '%d Baht',
      indonesian: '%d Baht',
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

  factory LocaleText.noData() {
    return LocaleText(
      thai: 'ไม่มีข้อมูล',
      english: 'No data',
      chinese: '没有数据',
      japanese: 'データなし',
      korean: '데이터 없음',
      lao: 'ບໍ່​ມີ​ຂໍ້​ມູນ',
      vietnamese: 'không có dữ liệu',
      myanmar: 'ဒေတာမရှိ',
      khmer: 'គ្មាន​ទិន្នន័យ',
      malay: 'tiada data',
      indonesian: 'tidak ada data',
    );
  }

  factory LocaleText.error() {
    return LocaleText(
      thai: 'ผิดพลาด',
      english: 'Error',
      chinese: '错误',
      japanese: 'エラー',
      korean: '오류',
      lao: 'ຄວາມຜິດພາດ',
      vietnamese: 'lỗi',
      myanmar: 'အမှား',
      khmer: 'កំហុស',
      malay: 'kesilapan',
      indonesian: 'kesalahan',
    );
  }

  factory LocaleText.errorPleaseTryAgain() {
    return LocaleText(
      thai: 'เกิดข้อผิดพลาด กรุณาลองอีกครั้ง',
      english: 'Error, please try again',
      chinese: '错误，请重试',
      japanese: 'エラー、もう一度やり直してください',
      korean: '오류, 다시 시도하십시오',
      lao: 'ຜິດພາດ, ກະລຸນາລອງ ໃໝ່ ອີກຄັ້ງ',
      vietnamese: 'Lỗi. Vui lòng thử lại',
      myanmar: 'ကျေးဇူးပြု၍ ထပ်မံကြိုးစားပါ',
      khmer: 'កំហុសសូមព្យាយាមម្តងទៀត',
      malay: 'ralat, sila cuba lagi',
      indonesian: 'kesalahan, coba lagi',
    );
  }

  factory LocaleText.tryAgain() {
    return LocaleText(
      thai: 'ลองอีกครั้ง',
      english: 'Try again',
      chinese: '再试一次',
      japanese: '再試行',
      korean: '다시 시도하십시오',
      lao: 'ລອງ​ອີກ​ຄັ້ງ',
      vietnamese: 'thử lại',
      myanmar: 'ထပ်ကြိုးစားပါ',
      khmer: 'ព្យាយាម​ម្តង​ទៀត',
      malay: 'cuba lagi',
      indonesian: 'coba lagi',
    );
  }

  factory LocaleText.cantFetchDataFromServer() {
    return LocaleText(
      thai: 'ไม่สามารถดึงข้อมูลจาก server',
      english: 'Can\'t fetch data from server.',
      chinese: '无法从服务器获取数据',
      japanese: 'サーバーからデータを取得できません',
      korean: '서버에서 데이터를 가져올 수 없습니다.',
      lao: 'ບໍ່ສາມາດດຶງຂໍ້ມູນຈາກເຊີບເວີໄດ້',
      vietnamese: 'không thể tìm nạp dữ liệu từ máy chủ',
      myanmar: 'ဆာဗာမှဒေတာများကို ရယူ၍ မရပါ',
      khmer: 'មិនអាចទៅយកទិន្នន័យពីម៉ាស៊ីនមេ',
      malay: 'tidak dapat mengambil data dari pelayan',
      indonesian: 'tidak dapat mengambil data dari server',
    );
  }

  factory LocaleText.locationNotAvailable() {
    return LocaleText(
      thai: "ขออภัย ฟังก์ชันนี้จำเป็นต้องใช้ข้อมูลตำแหน่งปัจจุบันของคุณในการทำงาน แต่ ${Constants.App.NAME} ไม่สามารถตรวจสอบตำแหน่งปัจจุบันได้ " +
          "อาจเป็นเพราะคุณไม่ได้เปิดการตั้งค่า Location หรือคุณไม่อนุญาตให้ ${Constants.App.NAME} เข้าถึงตำแหน่งปัจจุบันของคุณ\n" +
          "     กรุณาเปิดการตั้งค่า Location และอนุญาตให้ ${Constants.App.NAME} เข้าถึงตำแหน่งปัจจุบันของคุณ แล้วลองใหม่อีกครั้ง",
      english: 'Can\'t get your current location.',
      chinese: '无法获取您的当前位置',
      japanese: '現在地を取得できません',
      korean: '현재 위치를 알 수 없습니다',
      lao: 'ບໍ່ສາມາດຮັບທີ່ຢູ່ປະຈຸບັນຂອງທ່ານ',
      vietnamese: 'không thể có được vị trí hiện tại của bạn',
      myanmar: 'သင့်လက်ရှိတည်နေရာကိုမရနိုင်ပါ',
      khmer: 'មិនអាចទទួលបានទីតាំងបច្ចុប្បន្នរបស់អ្នក',
      malay: 'tidak dapat mendapatkan lokasi semasa anda',
      indonesian: 'tidak bisa mendapatkan lokasi Anda saat ini',
    );
  }

  factory LocaleText.selectEntrance() {
    return LocaleText(
      thai: 'เลือกทางเข้า',
      english: 'Select entrance',
      chinese: '选择入口',
      japanese: '入口を選択',
      korean: '선택 입구',
      lao: 'ເລືອກທາງເຂົ້າ',
      vietnamese: 'chọn lối vào',
      myanmar: 'ဝင်ပေါက်ကိုရွေးပါ',
      khmer: 'ជ្រើសរើសច្រកចូល',
      malay: 'pilih pintu masuk',
      indonesian: 'pilih pintu masuk',
    );
  }

  factory LocaleText.selectExit() {
    return LocaleText(
      thai: 'เลือกทางออก',
      english: 'Select exit',
      chinese: '选择退出',
      japanese: '出口を選択',
      korean: '종료 선택',
      lao: 'ເລືອກທາງອອກ',
      vietnamese: 'chọn lối ra',
      myanmar: 'ထွက်ကိုရွေးချယ်ပါ',
      khmer: 'ជ្រើសរើសច្រកចេញ',
      malay: 'pilih jalan keluar',
      indonesian: 'pilih keluar',
    );
  }

  factory LocaleText.enterPlaceName() {
    return LocaleText(
      thai: 'พิมพ์ชื่อสถานที่',
      english: 'Enter place name',
      chinese: '输入地名',
      japanese: '地名を入力してください',
      korean: '지명을 입력',
      lao: 'ໃສ່ຊື່ສະຖານທີ່',
      vietnamese: 'nhập tên địa điểm',
      myanmar: 'နေရာအမည်ထည့်ပါ',
      khmer: 'បញ្ចូលឈ្មោះកន្លែង',
      malay: 'masukkan nama tempat',
      indonesian: 'masukkan nama tempat',
    );
  }

  factory LocaleText.savedToFavorite() {
    return LocaleText(
      thai: 'เพิ่มในรายการโปรดแล้ว',
      english: 'Saved to favorite.',
      chinese: '保存到收藏夹',
      japanese: 'お気に入りに保存しました',
      korean: '즐겨 찾기에 저장',
      lao: 'ບັນທຶກເປັນທີ່ນິຍົມ',
      vietnamese: 'được lưu vào mục yêu thích',
      myanmar: 'အကြိုက်ဆုံးသို့သိမ်းဆည်းထားသည်',
      khmer: 'រក្សាទុកទៅក្នុងចំណូលចិត្ត',
      malay: 'disimpan ke kegemaran',
      indonesian: 'disimpan ke favorit',
    );
  }

  factory LocaleText.deletedFromFavorite() {
    return LocaleText(
      thai: 'ลบออกจากรายการโปรดแล้ว',
      english: 'Deleted from favorite.',
      chinese: '从收藏夹中删除',
      japanese: 'お気に入りから削除しました',
      korean: '즐겨 찾기에서 삭제',
      lao: 'ຖືກລຶບອອກຈາກສິ່ງທີ່ມັກ',
      vietnamese: 'bị xóa khỏi mục yêu thích',
      myanmar: 'အကြိုက်ဆုံးမှဖျက်သိမ်းလိုက်သည်',
      khmer: 'លុបពីចំណូលចិត្ត',
      malay: 'dipadam dari kegemaran',
      indonesian: 'dihapus dari favorit',
    );
  }

  factory LocaleText.confirmDeleteFromFavorite() {
    return LocaleText(
      thai: 'ยืนยันลบออกจากรายการโปรด?',
      english: 'Delete from favorite. Are you sure?',
      chinese: '从收藏夹中删除。 你确定吗？',
      japanese: 'お気に入りから削除します。 本気ですか？',
      korean: '즐겨 찾기에서 삭제합니다. 확실합니까?',
      lao: 'ລົບຈາກທີ່ມັກ. ເຈົ້າ​ແນ່​ໃຈ​ບໍ່?',
      vietnamese: 'xóa khỏi mục yêu thích. bạn có chắc không?',
      myanmar: 'အကြိုက်ဆုံးမှဖျက်ပါ။ သေချာလား?',
      khmer: 'លុបពីសំណព្វ តើ​អ្នក​ប្រាកដ​ឬ​អត់?',
      malay: 'padam dari kegemaran. Adakah anda pasti?',
      indonesian: 'hapus dari favorit. apakah kamu yakin',
    );
  }

  factory LocaleText.departureTime() {
    return LocaleText(
      thai: 'เวลาออกเดินทาง',
      english: 'Departure time',
      chinese: '出发时间',
      japanese: '出発時間',
      korean: '출발 시각',
      lao: 'ເວລາອອກເດີນທາງ',
      vietnamese: 'Giờ khởi hành',
      myanmar: 'ထွက်ခွာချိန်',
      khmer: 'មោង​ចាកចេញ',
      malay: 'Masa berlepas',
      indonesian: 'Waktu keberangkatan',
    );
  }

  factory LocaleText.now() {
    return LocaleText(
      thai: 'ตอนนี้',
      english: 'Now',
      chinese: '现在',
      japanese: '今',
      korean: '지금',
      lao: 'ດຽວນີ້',
      vietnamese: 'hiện nay',
      myanmar: 'အခု',
      khmer: 'ឥឡូវ​នេះ',
      malay: 'sekarang',
      indonesian: 'sekarang',
    );
  }

  factory LocaleText.minutesLater() {
    return LocaleText(
      thai: '%d นาทีข้างหน้า',
      english: '%d minutes later',
      chinese: '%d分钟后',
      japanese: '%d分後',
      korean: '%d 분 후',
      lao: 'ໃນ %d ນາທີ',
      vietnamese: '%d phút sau',
      myanmar: '%d မိနစ်အကြာတွင်',
      khmer: '%d នាទីក្រោយមក',
      malay: '%d minit kemudian',
      indonesian: '%d menit kemudian',
    );
  }

  factory LocaleText.leaveArrive() {
    return LocaleText(
      thai: 'เดินทาง %s น. ถึง %s น.',
      english: 'Leave %s, arrive %s',
      chinese: '出发%s，到达%s',
      japanese: '出発%s、到着%s',
      korean: '출발 %s, 도착 %s',
      lao: 'ການອອກເດີນທາງ %s, ມາຮອດ %s',
      vietnamese: 'khởi hành %s, đến %s',
      myanmar: 'ထွက်ခွာ %s, %s ရောက်ရှိ',
      khmer: 'ការចាកចេញ %s, មកដល់ %s',
      malay: 'bertolak %s, tiba %s',
      indonesian: 'keberangkatan %s, tiba %s',
    );
  }

  factory LocaleText.leaveNowArrive() {
    return LocaleText(
      thai: 'เดินทางตอนนี้ ถึง %s น.',
      english: 'Leave now, arrive %s',
      chinese: '现在出发，到达%s',
      japanese: '今出発、%s着',
      korean: '지금 출발, %s 도착',
      lao: 'ອອກເດີນທາງດຽວນີ້, ມາຮອດເວລາ %s',
      vietnamese: 'khởi hành ngay bây giờ, đến lúc %s',
      myanmar: 'ယခုထွက်ခွာ, %s ရောက်ရှိမည်',
      khmer: 'ការចាកចេញឥឡូវនេះមកដល់ %s',
      malay: 'bertolak sekarang, tiba %s',
      indonesian: 'keberangkatan sekarang, tiba %s',
    );
  }

  factory LocaleText.totalTollPlaza() {
    return LocaleText(
      thai: 'ผ่านทั้งหมด %d ด่าน',
      english: '%d Toll plaza',
      chinese: '%d收费站',
      japanese: '%d道路料金所',
      korean: '%d 톨게이트',
      lao: '%d ດ່ານເກັບ​ເງິນ',
      vietnamese: 'Trạm thu lộ phí',
      myanmar: '%d ေငြျဖတ္တြဲ',
      khmer: '%d ថូលហ្គេត',
      malay: '%d Plaza Tol',
      indonesian: '%d Tol Plaza',
    );
  }

  factory LocaleText.currentLocation() {
    return LocaleText(
      thai: 'ตำแหน่งปัจจุบันของคุณ',
      english: 'Current location',
      chinese: '当前位置',
      japanese: '現在位置',
      korean: '현재 위치',
      lao: 'ສະຖານທີ່ປະຈຸບັນ',
      vietnamese: 'vị trí hiện tại',
      myanmar: 'လက်ရှိတည်နေရာ',
      khmer: 'ទីតាំង​បច្ចុប្បន្ន',
      malay: 'lokasi sekarang',
      indonesian: 'lokasi saat ini',
    );
  }

  factory LocaleText.payTollAhead() {
    return LocaleText(
      thai: 'อีก %s กม. ถึง%s โปรดเตรียมเงินค่าผ่านทาง',
      english: 'Pay toll ahead %s km',
      chinese: '提前付费%s公里',
      japanese: '%s km先に通行料を支払う',
      korean: '%skm 전방에 통행료 지불',
      lao: 'ຈ່າຍຄ່າໂທລ່ວງ ໜ້າ %s ກິໂລແມັດ',
      vietnamese: 'trả phí trước %s km',
      myanmar: 'ရှေ့ဆက် %s ကီလိုမီတာသေဆုံးသူပေးဆောင်',
      khmer: 'បង់ថ្លៃសេវាខាងមុខ %s គីឡូម៉ែត្រ',
      malay: 'bayar tol lebih awal %s km',
      indonesian: 'membayar tol ke depan %s km',
    );
  }

  factory LocaleText.findingRoute() {
    return LocaleText(
      thai: 'กำลังค้นหาเส้นทาง...',
      english: 'Finding route...',
      chinese: '寻找路线...',
      japanese: 'ルートを検索しています...',
      korean: '경로 찾는 중 ...',
      lao: 'ຊອກຫາເສັ້ນທາງ ...',
      vietnamese: 'tìm đường ...',
      myanmar: 'လမ်းကြောင်းရှာနေသည် ...',
      khmer: 'ស្វែងរកផ្លូវ ...',
      malay: 'mencari jalan ...',
      indonesian: 'mencari rute ...',
    );
  }

  factory LocaleText.next() {
    return LocaleText(
      thai: 'ถัดไป',
      english: 'Next',
      chinese: '下一个',
      japanese: '次',
      korean: '다음',
      lao: 'ຕໍ່ໄປ',
      vietnamese: 'kế tiếp',
      myanmar: 'နောက်တစ်ခု',
      khmer: 'បន្ទាប់',
      malay: 'seterusnya',
      indonesian: 'lanjut',
    );
  }

  factory LocaleText.routeNotFound() {
    return LocaleText(
      thai: 'ขออภัย ไม่พบเส้นทางบนทางพิเศษสำหรับสถานที่นี้',
      english: 'Expressway route not found for this place',
      chinese: '找不到这个地方的高速公路路线',
      japanese: 'この場所の高速道路ルートが見つかりません',
      korean: '이 장소에 대한 고속도로 경로를 찾을 수 없습니다.',
      lao: 'ບໍ່ພົບເຫັນເສັ້ນທາງດ່ວນ ສຳ ລັບສະຖານທີ່ນີ້',
      vietnamese: 'Không tìm thấy tuyến đường cao tốc cho địa điểm này',
      myanmar: 'ဒီနေရာအတွက်အမြန်လမ်းမကြီးလမ်းကြောင်းရှာမတွေ့ပါ',
      khmer: 'រកមិនឃើញផ្លូវល្បឿនលឿនសម្រាប់កន្លែងនេះ',
      malay: 'Laluan lebuh raya tidak dijumpai untuk tempat ini',
      indonesian: 'Rute jalan tol tidak ditemukan untuk tempat ini',
    );
  }

  factory LocaleText.tapMarkerToSelect() {
    return LocaleText(
      thai: 'แตะที่หมุดเพื่อเลือก',
      english: 'Tap the marker icon to select',
      chinese: '点击标记图标以选择',
      japanese: 'マーカーアイコンをタップして選択します',
      korean: '선택하려면 마커 아이콘을 탭하세요.',
      lao: 'ແຕະທີ່ໄອຄອນເຄື່ອງ ໝາຍ ເພື່ອເລືອກ',
      vietnamese: 'chạm vào biểu tượng điểm đánh dấu để chọn',
      myanmar: 'ရွေးရန်အမှတ်အသားအိုင်ကွန်ကိုအသာပုတ်ပါ',
      khmer: 'ប៉ះរូបសញ្ញាសម្គាល់ដើម្បីជ្រើសរើស',
      malay: 'ketik ikon penanda untuk memilih',
      indonesian: 'ketuk ikon penanda untuk memilih',
    );
  }

  /*factory LocaleText.xxx() {
    return LocaleText(
      thai: '',
      english: '',
      chinese: '',
      japanese: '',
      korean: '',
      lao: '',
      vietnamese: '',
      myanmar: '',
      khmer: '',
      malay: '',
      indonesian: '',
    );
  }*/
}
