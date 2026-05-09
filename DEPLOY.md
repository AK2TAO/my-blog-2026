# 博客部署说明

## 这是什么

- **框架**：Hexo（把 Markdown 文章转成网页）
- **主题**：Stellar（外观样式）
- **托管**：Vercel（免费自动部署，每次 git push 自动更新）
- **域名**：zo1tan.cn

---

## 文件结构（你需要了解的）

```
my-hexo-blog/
├── source/_posts/       ← 所有文章（.md 文件）
├── source/about/        ← 关于页
├── layout/              ← 模板覆盖（重要！见下文）
├── _config.yml           ← Hexo 主配置
├── _config.stellar.yml   ← 主题配置（字体、颜色、菜单等）
├── Dockerfile            ← Docker 镜像构建规则
├── docker-compose.yml    ← Docker 一键启动配置
└── package.json          ← 项目依赖清单
```

---

## 换电脑部署（3 步）

### 前提

新电脑需要装好：Docker Desktop + WSL2（Windows）或 Docker Desktop（Mac）。

### 步骤

```bash
# 1. 下载代码
git clone git@github.com:AK2TAO/my-blog-2026.git
cd my-blog-2026

# 2. 启动开发模式（可实时预览）
docker compose up dev

# 3. 浏览器打开 http://localhost:4000
```

之后修改 `source/_posts/` 里的文章，浏览器会自动刷新。

> **原理**：`docker compose up dev` 跑起来后，`source/` 文件夹被"挂载"进容器。你在外面改文件，容器里面的 hexo server 立刻感知并重新生成——不需要每次手动 build。

---

## 写文章发布流程

1. 在 `source/_posts/` 新建 `.md` 文件
2. 写完 docker compose 会自动刷新预览
3. 满意后提交到 GitHub：
   ```bash
   git add source/_posts/你的文章.md
   git commit -m "新文章：xxx"
   git push origin main
   ```
4. Vercel 检测到 GitHub push → 自动构建 → 自动部署到 zo1tan.cn
5. 等 1-2 分钟，刷新 zo1tan.cn 就能看到新文章

> 也可以直接用 skill：在 Claude Code 里输入 `/submit-article` 或说「提交文章」，按提示操作。

---

## 模板覆盖机制（重要）

主题的模板文件在 `node_modules/hexo-theme-stellar/layout/` 里。直接改 `node_modules/` 里的文件有两个问题：
- `node_modules/` 被 git 忽略，换电脑后丢失
- 运行 `npm install` 会重置所有修改

**正确的做法**：把要改的模板文件复制到项目根目录的 `layout/` 下，保持相同的文件夹路径。Hexo 会自动用 `layout/` 里的文件覆盖 `node_modules/` 里同路径的文件。

```
node_modules/hexo-theme-stellar/layout/_partial/main/article/article_footer.ejs  ← 主题原版
                                       ↓ 覆盖
layout/_partial/main/article/article_footer.ejs                                  ← 你的定制版（git 跟踪）
```

目前有两个自定义覆盖：
| 文件 | 作用 |
|------|------|
| `layout/.../nav_tabs_blog.ejs` | 导航栏只显示 分类/标签/专栏/归档（去掉"近期发布"） |
| `layout/.../article_footer.ejs` | 文章底部标签可点击跳转 |

---

## Docker 镜像原理

```
Dockerfile
  Stage 1（builder）          Stage 2（最终镜像）
  ┌──────────────┐           ┌──────────────┐
  │ node:20      │           │ nginx:alpine │
  │ npm install  │           │              │
  │ hexo generate│ ──复制──→ │ public/      │
  │ → public/    │           │ → nginx 提供 │
  └──────────────┘           └──────────────┘
  体积大（~500MB）             最终镜像小（~30MB）
  仅构建时使用                 实际跑的时候只用这个
```

分两个阶段的好处：最终镜像只包含 nginx + 静态文件，非常小，启动快。

---

## 常见问题

**Q: 为什么我的文章没出现在首页？**
A: 检查文章头部 `categories` 字段。Stellar 主题默认首页只显示"博客"分类的文章，其他分类在对应的分类页。

**Q: 本地预览正常但线上没更新？**
A: 确认 `git push` 了。Vercel 需要 1-2 分钟构建，等一会刷新。

**Q: Docker 国内下载太慢？**
A: Dockerfile 里已经配置了 npm 国内镜像，但 Docker 镜像本身（node:20-alpine, nginx:alpine）需要从 Docker Hub 拉取。可以配置 Docker 镜像加速器。
