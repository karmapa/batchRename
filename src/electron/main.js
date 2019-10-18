const { app, BrowserWindow } = require('electron');

let win;

app.on('ready', createWindow);

app.on('window-all-closed', () => {
  if ('darwin' !== process.platform) {
    app.quit();
  }
});

app.on('activate', () => {
  if (null === win) {
    createWindow();
  }
});

function createWindow() {
  let win = new BrowserWindow({
    show: false,
    webPreferences: {
      nodeIntegration: true
    }
  });

  win.loadURL(`file://${__dirname}/../index.html`);

  win.once('ready-to-show', () => {
    win.maximize();
    win.show();
  });

  win.on('close', () => {
    win = null;
  });
}

