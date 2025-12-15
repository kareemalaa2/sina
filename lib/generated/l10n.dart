// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `العربية`
  String get language {
    return Intl.message('العربية', name: 'language', desc: '', args: []);
  }

  /// `ملفي الشخصي`
  String get profile {
    return Intl.message('ملفي الشخصي', name: 'profile', desc: '', args: []);
  }

  /// `سياراتي`
  String get myCars {
    return Intl.message('سياراتي', name: 'myCars', desc: '', args: []);
  }

  /// `الإعدادات`
  String get settings {
    return Intl.message('الإعدادات', name: 'settings', desc: '', args: []);
  }

  /// `الدعم الفني`
  String get support {
    return Intl.message('الدعم الفني', name: 'support', desc: '', args: []);
  }

  /// `الخدمات`
  String get services {
    return Intl.message('الخدمات', name: 'services', desc: '', args: []);
  }

  /// `بالقرب منك`
  String get nearYou {
    return Intl.message('بالقرب منك', name: 'nearYou', desc: '', args: []);
  }

  /// `عرض المزيد`
  String get showMore {
    return Intl.message('عرض المزيد', name: 'showMore', desc: '', args: []);
  }

  /// `التالي`
  String get next {
    return Intl.message('التالي', name: 'next', desc: '', args: []);
  }

  /// `السابق`
  String get prev {
    return Intl.message('السابق', name: 'prev', desc: '', args: []);
  }

  /// `بدأ`
  String get getStarted {
    return Intl.message('بدأ', name: 'getStarted', desc: '', args: []);
  }

  /// `رقم الهاتف`
  String get phoneNo {
    return Intl.message('رقم الهاتف', name: 'phoneNo', desc: '', args: []);
  }

  /// `كلمة المرور`
  String get password {
    return Intl.message('كلمة المرور', name: 'password', desc: '', args: []);
  }

  /// `هل نسيت كلمة المرور ؟`
  String get forgotPassword {
    return Intl.message(
      'هل نسيت كلمة المرور ؟',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل دخول`
  String get signIn {
    return Intl.message('تسجيل دخول', name: 'signIn', desc: '', args: []);
  }

  /// `إنشاء حساب`
  String get createAccount {
    return Intl.message(
      'إنشاء حساب',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `هل لديك حساب ؟`
  String get doYouHaveAccount {
    return Intl.message(
      'هل لديك حساب ؟',
      name: 'doYouHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `الحقل مطلوب`
  String get fieldRequired {
    return Intl.message(
      'الحقل مطلوب',
      name: 'fieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `استمرار`
  String get continueF {
    return Intl.message('استمرار', name: 'continueF', desc: '', args: []);
  }

  /// `الأسم`
  String get name {
    return Intl.message('الأسم', name: 'name', desc: '', args: []);
  }

  /// `أدخل الإسم`
  String get enterName {
    return Intl.message('أدخل الإسم', name: 'enterName', desc: '', args: []);
  }

  /// `أعد كلمة المرور`
  String get rePassword {
    return Intl.message(
      'أعد كلمة المرور',
      name: 'rePassword',
      desc: '',
      args: [],
    );
  }

  /// `الإنضمام كـ`
  String get joinAs {
    return Intl.message('الإنضمام كـ', name: 'joinAs', desc: '', args: []);
  }

  /// `عميل`
  String get client {
    return Intl.message('عميل', name: 'client', desc: '', args: []);
  }

  /// `مقدم خدمة`
  String get serviceProvider {
    return Intl.message(
      'مقدم خدمة',
      name: 'serviceProvider',
      desc: '',
      args: [],
    );
  }

  /// `أدخل رمز التحقق`
  String get enterOtp {
    return Intl.message(
      'أدخل رمز التحقق',
      name: 'enterOtp',
      desc: '',
      args: [],
    );
  }

  /// `تأكيد`
  String get verify {
    return Intl.message('تأكيد', name: 'verify', desc: '', args: []);
  }

  /// `لم يصلك الرمز ؟`
  String get didNotReceiveCode {
    return Intl.message(
      'لم يصلك الرمز ؟',
      name: 'didNotReceiveCode',
      desc: '',
      args: [],
    );
  }

  /// `إعادة إرسال الرمز`
  String get reSendCode {
    return Intl.message(
      'إعادة إرسال الرمز',
      name: 'reSendCode',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل خروج`
  String get signOut {
    return Intl.message('تسجيل خروج', name: 'signOut', desc: '', args: []);
  }

  /// `هل أنت متأكد أنك تريد تسجيل الخروج؟`
  String get signOutMsg {
    return Intl.message(
      'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      name: 'signOutMsg',
      desc: '',
      args: [],
    );
  }

  /// `سيارات`
  String get cars {
    return Intl.message('سيارات', name: 'cars', desc: '', args: []);
  }

  /// `لا`
  String get no {
    return Intl.message('لا', name: 'no', desc: '', args: []);
  }

  /// `إدارة سياراتك`
  String get manageYourCars {
    return Intl.message(
      'إدارة سياراتك',
      name: 'manageYourCars',
      desc: '',
      args: [],
    );
  }

  /// `إضافة سيارة`
  String get addCar {
    return Intl.message('إضافة سيارة', name: 'addCar', desc: '', args: []);
  }

  /// `نسيت كلمة المرور`
  String get forgotPasswordPage {
    return Intl.message(
      'نسيت كلمة المرور',
      name: 'forgotPasswordPage',
      desc: '',
      args: [],
    );
  }

  /// `إستقبال الطلبات`
  String get receivingOrders {
    return Intl.message(
      'إستقبال الطلبات',
      name: 'receivingOrders',
      desc: '',
      args: [],
    );
  }

  /// `قيد الإنتظار`
  String get pendingOrders {
    return Intl.message(
      'قيد الإنتظار',
      name: 'pendingOrders',
      desc: '',
      args: [],
    );
  }

  /// `مكتملة`
  String get completedOrders {
    return Intl.message('مكتملة', name: 'completedOrders', desc: '', args: []);
  }

  /// `الرئيسية`
  String get home {
    return Intl.message('الرئيسية', name: 'home', desc: '', args: []);
  }

  /// `الدردشات`
  String get chats {
    return Intl.message('الدردشات', name: 'chats', desc: '', args: []);
  }

  /// `الشركات`
  String get companies {
    return Intl.message('الشركات', name: 'companies', desc: '', args: []);
  }

  /// `متجري`
  String get myStore {
    return Intl.message('متجري', name: 'myStore', desc: '', args: []);
  }

  /// `إضافة شركة`
  String get addCompany {
    return Intl.message('إضافة شركة', name: 'addCompany', desc: '', args: []);
  }

  /// `إزالة`
  String get remove {
    return Intl.message('إزالة', name: 'remove', desc: '', args: []);
  }

  /// `مكتملة`
  String get completed {
    return Intl.message('مكتملة', name: 'completed', desc: '', args: []);
  }

  /// `دردشات نشطة`
  String get activeChats {
    return Intl.message('دردشات نشطة', name: 'activeChats', desc: '', args: []);
  }

  /// `هل تريد حذف هذا العنصر؟`
  String get doYouWantToDelete {
    return Intl.message(
      'هل تريد حذف هذا العنصر؟',
      name: 'doYouWantToDelete',
      desc: '',
      args: [],
    );
  }

  /// `صناعيتي`
  String get appName {
    return Intl.message('صناعيتي', name: 'appName', desc: '', args: []);
  }

  /// `مرحباً بك في {title}`
  String welcome(String title) {
    return Intl.message(
      'مرحباً بك في $title',
      name: 'welcome',
      desc: '',
      args: [title],
    );
  }

  /// `يمكنك الانضمام إلينا كمقدم خدمة وتلقي الطلبات أو كعميل وطلب خدمة الصيانة أو خدمة قطع الغيار أو خدمة السطحات`
  String get cover1 {
    return Intl.message(
      'يمكنك الانضمام إلينا كمقدم خدمة وتلقي الطلبات أو كعميل وطلب خدمة الصيانة أو خدمة قطع الغيار أو خدمة السطحات',
      name: 'cover1',
      desc: '',
      args: [],
    );
  }

  /// `سهولة طلب الخدمة`
  String get easeService {
    return Intl.message(
      'سهولة طلب الخدمة',
      name: 'easeService',
      desc: '',
      args: [],
    );
  }

  /// `طلب قطع غيار سيارتك لم يكن أسهل من ذلك،  لصيانة سيارتك مع مهندسين صيانة محترفين أو طلب سحب السيارة.`
  String get cover2 {
    return Intl.message(
      'طلب قطع غيار سيارتك لم يكن أسهل من ذلك،  لصيانة سيارتك مع مهندسين صيانة محترفين أو طلب سحب السيارة.',
      name: 'cover2',
      desc: '',
      args: [],
    );
  }

  /// `قطع غيار جديدة ومستعملة`
  String get newUsedSpareParts {
    return Intl.message(
      'قطع غيار جديدة ومستعملة',
      name: 'newUsedSpareParts',
      desc: '',
      args: [],
    );
  }

  /// `طلب صيانة سيارتك لم يكن أسهل من ذلك،  لصيانة سيارتك أو طلب سحبها.`
  String get cover3 {
    return Intl.message(
      'طلب صيانة سيارتك لم يكن أسهل من ذلك،  لصيانة سيارتك أو طلب سحبها.',
      name: 'cover3',
      desc: '',
      args: [],
    );
  }

  /// `إغلاق`
  String get close {
    return Intl.message('إغلاق', name: 'close', desc: '', args: []);
  }

  /// ` رفض الطلب`
  String get rejectOrder {
    return Intl.message(' رفض الطلب', name: 'rejectOrder', desc: '', args: []);
  }
/// Are you sure you want to reject this order?
String get rejectOrderConfirmation {
  return Intl.message(
    'Are you sure you want to reject this order?',
    name: 'rejectOrderConfirmation',
    desc: '',
    args: [],
  );
}

  /// `قبول`
  String get accept {
    return Intl.message('قبول', name: 'accept', desc: '', args: []);
  }

  /// `خاص`
  String get privateOrder {
    return Intl.message('خاص', name: 'privateOrder', desc: '', args: []);
  }

  /// `في مكان العميل`
  String get atPlace {
    return Intl.message('في مكان العميل', name: 'atPlace', desc: '', args: []);
  }

  /// `في المحل`
  String get atShop {
    return Intl.message('في المحل', name: 'atShop', desc: '', args: []);
  }

  /// `مرفق الطلب`
  String get orderAttachment {
    return Intl.message(
      'مرفق الطلب',
      name: 'orderAttachment',
      desc: '',
      args: [],
    );
  }

  /// `وصف الطلب`
  String get orderDesc {
    return Intl.message('وصف الطلب', name: 'orderDesc', desc: '', args: []);
  }

  /// `كلمة المرور غير مطابقة`
  String get doesNotMatch {
    return Intl.message(
      'كلمة المرور غير مطابقة',
      name: 'doesNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل`
  String get passwordMsg {
    return Intl.message(
      'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل',
      name: 'passwordMsg',
      desc: '',
      args: [],
    );
  }

  /// `إضافة قطعة غيار`
  String get addSpare {
    return Intl.message(
      'إضافة قطعة غيار',
      name: 'addSpare',
      desc: '',
      args: [],
    );
  }

  /// `اختر شركة السيارات`
  String get selectCarCompany {
    return Intl.message(
      'اختر شركة السيارات',
      name: 'selectCarCompany',
      desc: '',
      args: [],
    );
  }

  /// `حدد اسم السيارة`
  String get selectCarName {
    return Intl.message(
      'حدد اسم السيارة',
      name: 'selectCarName',
      desc: '',
      args: [],
    );
  }

  /// `حدد قطع الغيار`
  String get selectSpare {
    return Intl.message(
      'حدد قطع الغيار',
      name: 'selectSpare',
      desc: '',
      args: [],
    );
  }

  /// `اختر موديلات السيارات`
  String get chooseCarModels {
    return Intl.message(
      'اختر موديلات السيارات',
      name: 'chooseCarModels',
      desc: '',
      args: [],
    );
  }

  /// `أدخل رقم الهيكل`
  String get enterChassiNo {
    return Intl.message(
      'أدخل رقم الهيكل',
      name: 'enterChassiNo',
      desc: '',
      args: [],
    );
  }

  /// `أدخل حالة الغيار`
  String get enterSpareCondition {
    return Intl.message(
      'أدخل حالة الغيار',
      name: 'enterSpareCondition',
      desc: '',
      args: [],
    );
  }

  /// `قطع غيار جديدة`
  String get newSpare {
    return Intl.message('قطع غيار جديدة', name: 'newSpare', desc: '', args: []);
  }

  /// `قطع غيار مستعملة`
  String get usedSpare {
    return Intl.message(
      'قطع غيار مستعملة',
      name: 'usedSpare',
      desc: '',
      args: [],
    );
  }

  /// `حدد الصورة`
  String get selectSparePhoto {
    return Intl.message(
      'حدد الصورة',
      name: 'selectSparePhoto',
      desc: '',
      args: [],
    );
  }

  /// `السعر`
  String get price {
    return Intl.message('السعر', name: 'price', desc: '', args: []);
  }

  /// `تحديث`
  String get update {
    return Intl.message('تحديث', name: 'update', desc: '', args: []);
  }

  /// `حفظ`
  String get save {
    return Intl.message('حفظ', name: 'save', desc: '', args: []);
  }

  /// `جديد`
  String get newS {
    return Intl.message('جديد', name: 'newS', desc: '', args: []);
  }

  /// `مستعمل`
  String get usedS {
    return Intl.message('مستعمل', name: 'usedS', desc: '', args: []);
  }

  /// `تعديل الملف الشخصي`
  String get editProfile {
    return Intl.message(
      'تعديل الملف الشخصي',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `تغيير كلمة المرور`
  String get changePassword {
    return Intl.message(
      'تغيير كلمة المرور',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `السيرة الذاتية`
  String get bio {
    return Intl.message('السيرة الذاتية', name: 'bio', desc: '', args: []);
  }

  /// `طلب العرض`
  String get requestOffer {
    return Intl.message('طلب العرض', name: 'requestOffer', desc: '', args: []);
  }

  /// `برعاية`
  String get sponsored {
    return Intl.message('برعاية', name: 'sponsored', desc: '', args: []);
  }

  /// `إنشاء تذكرة`
  String get createSupportTicket {
    return Intl.message(
      'إنشاء تذكرة',
      name: 'createSupportTicket',
      desc: '',
      args: [],
    );
  }

  /// `إرسال`
  String get send {
    return Intl.message('إرسال', name: 'send', desc: '', args: []);
  }

  /// `سنة الموديل`
  String get modelYear {
    return Intl.message('سنة الموديل', name: 'modelYear', desc: '', args: []);
  }

  /// `رقم اللوحة`
  String get plateNo {
    return Intl.message('رقم اللوحة', name: 'plateNo', desc: '', args: []);
  }

  /// `رقم الهيكل`
  String get chassiNo {
    return Intl.message('رقم الهيكل', name: 'chassiNo', desc: '', args: []);
  }

  /// `كم`
  String get km {
    return Intl.message('كم', name: 'km', desc: '', args: []);
  }

  /// `إختيار`
  String get select {
    return Intl.message('إختيار', name: 'select', desc: '', args: []);
  }

  /// `إختار سيارة`
  String get chooseCar {
    return Intl.message('إختار سيارة', name: 'chooseCar', desc: '', args: []);
  }

  /// `تفاصيل الطلب`
  String get orderDetails {
    return Intl.message(
      'تفاصيل الطلب',
      name: 'orderDetails',
      desc: '',
      args: [],
    );
  }

  /// `نوع الخدمة`
  String get serviceType {
    return Intl.message('نوع الخدمة', name: 'serviceType', desc: '', args: []);
  }

  /// `نوع طلب الخدمة`
  String get orderType {
    return Intl.message(
      'نوع طلب الخدمة',
      name: 'orderType',
      desc: '',
      args: [],
    );
  }

  /// `إكمال الطلب`
  String get completeOrder {
    return Intl.message(
      'إكمال الطلب',
      name: 'completeOrder',
      desc: '',
      args: [],
    );
  }

  /// `فيديو أو صورة`
  String get videoOrImage {
    return Intl.message(
      'فيديو أو صورة',
      name: 'videoOrImage',
      desc: '',
      args: [],
    );
  }

  /// `إلتقاط صورة`
  String get captureImage {
    return Intl.message(
      'إلتقاط صورة',
      name: 'captureImage',
      desc: '',
      args: [],
    );
  }

  /// `إلتقاط فيديو`
  String get captureVideo {
    return Intl.message(
      'إلتقاط فيديو',
      name: 'captureVideo',
      desc: '',
      args: [],
    );
  }

  /// `علي بعد {km} كم`
  String farAway(double km) {
    final NumberFormat kmNumberFormat = NumberFormat.compact(
      locale: Intl.getCurrentLocale(),
    );
    final String kmString = kmNumberFormat.format(km);

    return Intl.message(
      'علي بعد $kmString كم',
      name: 'farAway',
      desc: '',
      args: [kmString],
    );
  }

  /// `طلب الخدمة`
  String get requestService {
    return Intl.message(
      'طلب الخدمة',
      name: 'requestService',
      desc: '',
      args: [],
    );
  }

  /// `طلباتي`
  String get myOrders {
    return Intl.message('طلباتي', name: 'myOrders', desc: '', args: []);
  }

  /// `تم إنشاء الطلب`
  String get orderPending {
    return Intl.message(
      'تم إنشاء الطلب',
      name: 'orderPending',
      desc: '',
      args: [],
    );
  }

  /// `الطلب قيد التنفيذ`
  String get orderActive {
    return Intl.message(
      'الطلب قيد التنفيذ',
      name: 'orderActive',
      desc: '',
      args: [],
    );
  }

  /// `تم إلغاء الطلب`
  String get orderCanceled {
    return Intl.message(
      'تم إلغاء الطلب',
      name: 'orderCanceled',
      desc: '',
      args: [],
    );
  }

  /// `الطلب مكتمل`
  String get orderCompleted {
    return Intl.message(
      'الطلب مكتمل',
      name: 'orderCompleted',
      desc: '',
      args: [],
    );
  }

  /// `إلغاء`
  String get cancel {
    return Intl.message('إلغاء', name: 'cancel', desc: '', args: []);
  }

  /// `هل تريد إلغاء هذا الطلب`
  String get doYouWantToCancelOrder {
    return Intl.message(
      'هل تريد إلغاء هذا الطلب',
      name: 'doYouWantToCancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `نعم`
  String get yes {
    return Intl.message('نعم', name: 'yes', desc: '', args: []);
  }

  /// `سياية الخصوصية`
  String get privacyPolicy {
    return Intl.message(
      'سياية الخصوصية',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `شروط الاستخدام`
  String get termsOfUse {
    return Intl.message(
      'شروط الاستخدام',
      name: 'termsOfUse',
      desc: '',
      args: [],
    );
  }

  /// `جار إنشاء دردشة`
  String get creatingChat {
    return Intl.message(
      'جار إنشاء دردشة',
      name: 'creatingChat',
      desc: '',
      args: [],
    );
  }

  /// `يكتب الأن...`
  String get isTyping {
    return Intl.message('يكتب الأن...', name: 'isTyping', desc: '', args: []);
  }

  /// `ليس هنالك رسائل`
  String get noMessages {
    return Intl.message(
      'ليس هنالك رسائل',
      name: 'noMessages',
      desc: '',
      args: [],
    );
  }

  /// `أكتب شيئاً....`
  String get writeSomething {
    return Intl.message(
      'أكتب شيئاً....',
      name: 'writeSomething',
      desc: '',
      args: [],
    );
  }

  /// `إرسال موقعي`
  String get sendLocation {
    return Intl.message(
      'إرسال موقعي',
      name: 'sendLocation',
      desc: '',
      args: [],
    );
  }

  /// `معرض الصور`
  String get imageGallery {
    return Intl.message('معرض الصور', name: 'imageGallery', desc: '', args: []);
  }

  /// `طلب عام`
  String get publicOrder {
    return Intl.message('طلب عام', name: 'publicOrder', desc: '', args: []);
  }

  /// `لقد أنتهي اشتراكك`
  String get subscriptionEnded {
    return Intl.message(
      'لقد أنتهي اشتراكك',
      name: 'subscriptionEnded',
      desc: '',
      args: [],
    );
  }

  /// `تجديد الإشتراك`
  String get renew {
    return Intl.message('تجديد الإشتراك', name: 'renew', desc: '', args: []);
  }

  /// `أو`
  String get or {
    return Intl.message('أو', name: 'or', desc: '', args: []);
  }

  /// `حامل البطاقة`
  String get cardHolder {
    return Intl.message('حامل البطاقة', name: 'cardHolder', desc: '', args: []);
  }

  /// `انتهاء الصلاحية`
  String get expiredDate {
    return Intl.message(
      'انتهاء الصلاحية',
      name: 'expiredDate',
      desc: '',
      args: [],
    );
  }

  /// `رقم البطاقة`
  String get cardNumber {
    return Intl.message('رقم البطاقة', name: 'cardNumber', desc: '', args: []);
  }

  /// `رسوم الإشتراك السنوية هي {fee}`
  String subscriptionFees(double fee) {
    final NumberFormat feeNumberFormat = NumberFormat.compact(
      locale: Intl.getCurrentLocale(),
    );
    final String feeString = feeNumberFormat.format(fee);

    return Intl.message(
      'رسوم الإشتراك السنوية هي $feeString',
      name: 'subscriptionFees',
      desc: '',
      args: [feeString],
    );
  }

  /// `الإشعارات`
  String get notifications {
    return Intl.message('الإشعارات', name: 'notifications', desc: '', args: []);
  }

  /// `تغيير حالة الطلب`
  String get changeOrderStatus {
    return Intl.message(
      'تغيير حالة الطلب',
      name: 'changeOrderStatus',
      desc: '',
      args: [],
    );
  }

  /// `قبول العرض`
  String get acceptOffer {
    return Intl.message('قبول العرض', name: 'acceptOffer', desc: '', args: []);
  }

  /// `قبول الطلب`
  String get acceptOrder {
    return Intl.message('قبول الطلب', name: 'acceptOrder', desc: '', args: []);
  }

  /// `قبول عرض مقدم الخدمة`
  String get acceptProviderOffer {
    return Intl.message(
      'قبول عرض مقدم الخدمة',
      name: 'acceptProviderOffer',
      desc: '',
      args: [],
    );
  }

  /// `تم تجديد الاشتراك`
  String get subscriptionRenewed {
    return Intl.message(
      'تم تجديد الاشتراك',
      name: 'subscriptionRenewed',
      desc: '',
      args: [],
    );
  }

  /// `تم رفض العرض`
  String get offerDeclined {
    return Intl.message(
      'تم رفض العرض',
      name: 'offerDeclined',
      desc: '',
      args: [],
    );
  }

  /// `نشط`
  String get active {
    return Intl.message('نشط', name: 'active', desc: '', args: []);
  }

  /// `أنتهى العمل`
  String get jobCompleted {
    return Intl.message(
      'أنتهى العمل',
      name: 'jobCompleted',
      desc: '',
      args: [],
    );
  }

  /// `يجب أن يكون رقم الهاتف مكونًا من 8 أرقام على الأقل`
  String get phoneRequired {
    return Intl.message(
      'يجب أن يكون رقم الهاتف مكونًا من 8 أرقام على الأقل',
      name: 'phoneRequired',
      desc: '',
      args: [],
    );
  }

  /// `يجب عليك تحديد رمز الهاتف الخاص بالبلد`
  String get countryRequired {
    return Intl.message(
      'يجب عليك تحديد رمز الهاتف الخاص بالبلد',
      name: 'countryRequired',
      desc: '',
      args: [],
    );
  }

  /// `يجب أن تكون كلمة المرور مكونة من 8 أحرف أو أكثر`
  String get passwordShouldBe {
    return Intl.message(
      'يجب أن تكون كلمة المرور مكونة من 8 أحرف أو أكثر',
      name: 'passwordShouldBe',
      desc: '',
      args: [],
    );
  }

  /// `المستخدم موجود بالفعل`
  String get userExist {
    return Intl.message(
      'المستخدم موجود بالفعل',
      name: 'userExist',
      desc: '',
      args: [],
    );
  }

  /// `بيانات اعتماد خاطئة`
  String get wrongCredentials {
    return Intl.message(
      'بيانات اعتماد خاطئة',
      name: 'wrongCredentials',
      desc: '',
      args: [],
    );
  }

  /// `إستمتع بتجربة التطبيق مجاناً لمدة {days} يوماً`
  String trailPeriod(int days) {
    final NumberFormat daysNumberFormat = NumberFormat.compact(
      locale: Intl.getCurrentLocale(),
    );
    final String daysString = daysNumberFormat.format(days);

    return Intl.message(
      'إستمتع بتجربة التطبيق مجاناً لمدة $daysString يوماً',
      name: 'trailPeriod',
      desc: '',
      args: [daysString],
    );
  }

  /// `لا توجد بيانات حتى الان`
  String get noData {
    return Intl.message(
      'لا توجد بيانات حتى الان',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء تنشيط خدمة الموقع للمتابعه جميع خدمات التطبيق تعتمد على موقعك`
  String get enableLocationServiceToContinue {
    return Intl.message(
      'الرجاء تنشيط خدمة الموقع للمتابعه جميع خدمات التطبيق تعتمد على موقعك',
      name: 'enableLocationServiceToContinue',
      desc: '',
      args: [],
    );
  }

  /// `تنشيط خدمه الموقع`
  String get enableService {
    return Intl.message(
      'تنشيط خدمه الموقع',
      name: 'enableService',
      desc: '',
      args: [],
    );
  }

  /// `حذف الحساب`
  String get deleteAccount {
    return Intl.message(
      'حذف الحساب',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `هل أنت متأكد أنك تريد حذف هذا الحساب؟ سيتم حذف جميع البيانات المتعلقة بهذا الحساب`
  String get deleteAccountMsg {
    return Intl.message(
      'هل أنت متأكد أنك تريد حذف هذا الحساب؟ سيتم حذف جميع البيانات المتعلقة بهذا الحساب',
      name: 'deleteAccountMsg',
      desc: '',
      args: [],
    );
  }

  /// `ضيف`
  String get guest {
    return Intl.message('ضيف', name: 'guest', desc: '', args: []);
  }

  /// `خدمة الموقع معطلة`
  String get locationDisabled {
    return Intl.message(
      'خدمة الموقع معطلة',
      name: 'locationDisabled',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء تنشيط خدمة الموقع لرؤية مقدمي الخدمة القريبين`
  String get enableLocationServiceToSeeNearbyServiceProviders {
    return Intl.message(
      'الرجاء تنشيط خدمة الموقع لرؤية مقدمي الخدمة القريبين',
      name: 'enableLocationServiceToSeeNearbyServiceProviders',
      desc: '',
      args: [],
    );
  }

  /// `تنشيط`
  String get enable {
    return Intl.message('تنشيط', name: 'enable', desc: '', args: []);
  }

  /// `يجب أن تكون مستخدمًا مسجلًا لطلب خدمة.`
  String get signInMsg {
    return Intl.message(
      'يجب أن تكون مستخدمًا مسجلًا لطلب خدمة.',
      name: 'signInMsg',
      desc: '',
      args: [],
    );
  }

  /// `فشل الدفع`
  String get paymentFailed {
    return Intl.message('فشل الدفع', name: 'paymentFailed', desc: '', args: []);
  }

  /// `نجاح الدفع`
  String get paymentSuccess {
    return Intl.message(
      'نجاح الدفع',
      name: 'paymentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `يتم الحصول على موقعك`
  String get gettingYourLocation {
    return Intl.message(
      'يتم الحصول على موقعك',
      name: 'gettingYourLocation',
      desc: '',
      args: [],
    );
  }

  /// `فتح الإعدادات`
  String get openSettings {
    return Intl.message(
      'فتح الإعدادات',
      name: 'openSettings',
      desc: '',
      args: [],
    );
  }

  /// `تم رفض إذن الموقع`
  String get locationPermissionDenied {
    return Intl.message(
      'تم رفض إذن الموقع',
      name: 'locationPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Location Error`
  String get locationError {
    return Intl.message(
      'Location Error',
      name: 'locationError',
      desc: '',
      args: [],
    );
  }

  /// `إذن الموقع مطلوب للعثور على مقدمي الخدمة بالقرب منك`
  String get locationPermissionNeeded {
    return Intl.message(
      'إذن الموقع مطلوب للعثور على مقدمي الخدمة بالقرب منك',
      name: 'locationPermissionNeeded',
      desc: '',
      args: [],
    );
  }

  /// `يرجى الذهاب إلى الإعدادات وتفعيل إذن الموقع لهذا التطبيق`
  String get locationPermissionPermanentlyDeniedMessage {
    return Intl.message(
      'يرجى الذهاب إلى الإعدادات وتفعيل إذن الموقع لهذا التطبيق',
      name: 'locationPermissionPermanentlyDeniedMessage',
      desc: '',
      args: [],
    );
  }

  /// `تعذر الحصول على موقعك. يرجى المحاولة مرة أخرى`
  String get locationErrorMessage {
    return Intl.message(
      'تعذر الحصول على موقعك. يرجى المحاولة مرة أخرى',
      name: 'locationErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `لا مزيد من المزودين`
  String get noMoreProviders {
    return Intl.message(
      'لا مزيد من المزودين',
      name: 'noMoreProviders',
      desc: '',
      args: [],
    );
  }

  /// `الدردشة موجودة بالفعل مع هذا الجزء`
  String get chatAlreadyExistsWithThisSparePart {
    return Intl.message(
      'الدردشة موجودة بالفعل مع هذا الجزء',
      name: 'chatAlreadyExistsWithThisSparePart',
      desc: '',
      args: [],
    );
  }

  /// `الدردشة موجودة بالفعل مع مزود الخدمة هذا لهذه السيارة والخدمة`
  String get chatAlreadyExistsWithThisServiceProviderForThisCarAndService {
    return Intl.message(
      'الدردشة موجودة بالفعل مع مزود الخدمة هذا لهذه السيارة والخدمة',
      name: 'chatAlreadyExistsWithThisServiceProviderForThisCarAndService',
      desc: '',
      args: [],
    );
  }

  /// `يرجى اختيار تقييم`
  String get pleaseSelectRating {
    return Intl.message(
      'يرجى اختيار تقييم',
      name: 'pleaseSelectRating',
      desc: '',
      args: [],
    );
  }

  /// `تم إرسال التقييم`
  String get ratingSubmitted {
    return Intl.message(
      'تم إرسال التقييم',
      name: 'ratingSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `حدث خطأ أثناء إرسال التقييم`
  String get errorSubmittingRating {
    return Intl.message(
      'حدث خطأ أثناء إرسال التقييم',
      name: 'errorSubmittingRating',
      desc: '',
      args: [],
    );
  }

  /// `قيم الخدمة`
  String get rateService {
    return Intl.message('قيم الخدمة', name: 'rateService', desc: '', args: []);
  }

  /// `كيف كانت تجربتك؟`
  String get howWasYourExperience {
    return Intl.message(
      'كيف كانت تجربتك؟',
      name: 'howWasYourExperience',
      desc: '',
      args: [],
    );
  }

  /// `تخطي`
  String get skip {
    return Intl.message('تخطي', name: 'skip', desc: '', args: []);
  }

  /// `إرسال التقييم`
  String get submitRating {
    return Intl.message(
      'إرسال التقييم',
      name: 'submitRating',
      desc: '',
      args: [],
    );
  }

  /// `أضف تعليق`
  String get addComment {
    return Intl.message('أضف تعليق', name: 'addComment', desc: '', args: []);
  }

  /// `ar`
  String get locale {
    return Intl.message('ar', name: 'locale', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
