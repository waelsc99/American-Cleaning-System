@echo off
chcp 65001 >nul
title نظام الحضور والانصراف - الشركة الأمريكية لخدمات النظافة والبيئة

echo.
echo ===============================================
echo    نظام الحضور والانصراف الذكي
echo    الشركة الأمريكية لخدمات النظافة والبيئة
echo ===============================================
echo.

echo 📦 جاري التحقق من تثبيت Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js غير مثبت على النظام!
    echo ⬇️  يرجى تحميله من: https://nodejs.org
    pause
    exit /b 1
)

echo ✅ Node.js مثبت: 
node --version

echo.
echo 📦 جاري تثبيت dependencies...
call npm install

if errorlevel 1 (
    echo ❌ فشل في تثبيت dependencies!
    echo 🔧 جاري محاولة التثبيت باستخدام --force...
    call npm install --force
)

if errorlevel 1 (
    echo ❌ فشل في تثبيت dependencies!
    pause
    exit /b 1
)

echo.
echo 🔨 جاري بناء التطبيق...
echo ⏳ قد تستغرق هذه العملية عدة دقائق...
call npm run build

if errorlevel 1 (
    echo ❌ فشل في بناء التطبيق!
    echo 🔧 جاري المحاولة بإعدادات بديلة...
    call npm run build-win-portable
)

if errorlevel 1 (
    echo ❌ فشل في بناء التطبيق!
    pause
    exit /b 1
)

echo.
echo ✅ تم البناء بنجاح!
echo.
echo 📁 الملفات النهائية في مجلد: dist
echo.
echo 🚀 الملفات المتاحة:
echo    - American Cleaning System Setup.exe (لتثبيت النظام)
echo    - American_Cleaning_System_Portable.exe (إصدار محمول)
echo.
echo 💡 تعليمات التثبيت:
echo    1. شغل ملف Setup.exe للتثبيت
echo    2. أو شغل Portable.exe للاستخدام المباشر
echo    3. النظام سيضيف اختصار على سطح المكتب
echo.
echo 📊 بيانات الدخول الافتراضية:
echo    اسم المستخدم: admin
echo    كلمة المرور: admin123
echo.

pause
