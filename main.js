const { app, BrowserWindow, Menu, dialog, ipcMain } = require('electron');
const path = require('path');
const fs = require('fs');

// إخفاء القائمة الرئيسية
Menu.setApplicationMenu(null);

// المتغير العام للنافذة
let mainWindow;

function createWindow() {
  // إنشاء النافذة الرئيسية
  mainWindow = new BrowserWindow({
    width: 1400,
    height: 900,
    minWidth: 1200,
    minHeight: 800,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
      enableRemoteModule: true,
      webSecurity: false
    },
    icon: path.join(__dirname, 'icon.ico'),
    title: 'الشركة الأمريكية لخدمات النظافة والبيئة - نظام الحضور والانصراف الذكي',
    show: false, // إخفاء حتى التحميل الكامل
    titleBarStyle: 'default',
    autoHideMenuBar: true,
    frame: true
  });

  // تحميل ملف HTML الرئيسي
  mainWindow.loadFile('index.html');

  // إظهار النافذة عندما تكون جاهزة
  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
    // ملء الشاشة (اختياري)
    // mainWindow.maximize();
  });

  // التعامل مع إغلاق النافذة
  mainWindow.on('close', (e) => {
    e.preventDefault();
    
    dialog.showMessageBox(mainWindow, {
      type: 'question',
      buttons: ['نعم، اخترج', 'لا، إلغاء'],
      defaultId: 1,
      title: 'تأكيد الخروج',
      message: 'هل تريد حقاً الخروج من النظام؟',
      detail: 'سيتم حفظ جميع البيانات تلقائياً'
    }).then((result) => {
      if (result.response === 0) {
        // حفظ البيانات قبل الخروج
        saveApplicationData();
        mainWindow.destroy();
      }
    });
  });

  // فتح أدوات المطور في وضع التطوير
  if (process.env.NODE_ENV === 'development') {
    mainWindow.webContents.openDevTools();
  }
}

// حفظ بيانات التطبيق
function saveApplicationData() {
  const dataPath = path.join(__dirname, 'data');
  if (!fs.existsSync(dataPath)) {
    fs.mkdirSync(dataPath);
  }
  
  const backup = {
    timestamp: new Date().toISOString(),
    message: 'نسخة احتياطية من نظام الحضور'
  };
  
  fs.writeFileSync(
    path.join(dataPath, 'backup.json'), 
    JSON.stringify(backup, null, 2)
  );
}

// عندما يكون التطبيق جاهزاً
app.whenReady().then(() => {
  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

// إغلاق التطبيق عندما يتم إغلاق جميع النوافذ
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// منع التنفيذ المتعدد للتطبيق
app.requestSingleInstanceLock();

app.on('second-instance', () => {
  if (mainWindow) {
    if (mainWindow.isMinimized()) mainWindow.restore();
    mainWindow.focus();
  }
});

// التعامل مع أخطاء غير متوقعة
process.on('uncaughtException', (error) => {
  console.error('خطأ غير متوقع:', error);
  dialog.showErrorBox('خطأ في النظام', 'حدث خطأ غير متوقع. يرجى إعادة فتح التطبيق.');
});

// استقبال الرسائل من عملية التقديم
ipcMain.handle('get-app-version', () => {
  return '2.0.0';
});

ipcMain.handle('export-data', async (event, data) => {
  try {
    const { filePath } = await dialog.showSaveDialog(mainWindow, {
      defaultPath: `attendance-backup-${new Date().toISOString().split('T')[0]}.json`,
      filters: [
        { name: 'JSON Files', extensions: ['json'] },
        { name: 'All Files', extensions: ['*'] }
      ]
    });

    if (filePath) {
      fs.writeFileSync(filePath, JSON.stringify(data, null, 2));
      return { success: true, path: filePath };
    }
    return { success: false };
  } catch (error) {
    return { success: false, error: error.message };
  }
});
