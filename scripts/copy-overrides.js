// 将 layout/ 下的模板覆盖文件复制到 node_modules 主题目录
// 解决 Hexo 7 的 layout 目录不能覆盖主题 _partial 文件的问题
const fs = require('fs');
const path = require('path');

const THEME_DIR = 'node_modules/hexo-theme-stellar/layout';
const OVERRIDES_DIR = 'layout';

function copyDir(src, dest) {
  if (!fs.existsSync(dest)) {
    fs.mkdirSync(dest, { recursive: true });
  }
  const entries = fs.readdirSync(src, { withFileTypes: true });
  for (const entry of entries) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);
    if (entry.isDirectory()) {
      copyDir(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
      console.log('  copied:', path.relative(OVERRIDES_DIR, srcPath));
    }
  }
}

if (fs.existsSync(OVERRIDES_DIR)) {
  console.log('Copying layout overrides...');
  copyDir(OVERRIDES_DIR, THEME_DIR);
  console.log('Done.');
} else {
  console.log('No layout overrides found.');
}
