# Planet Avenue

planet 应用库里列出的 satellite：<https://avenue.heyplanet.app/apps.json>，由
Cloudflare Pages 直接发布这个仓库。

`apps.json` 是 GitHub 仓库地址的列表，别的都由 planet 从仓库里读（planet 仓库的
`crates/planet-web/src/store.rs`）：

- 名称、简介、版本：默认分支的 `manifest.yaml`
- 图标：仓库根目录的 `icon.png`（或 `.svg` / `.jpg` / `.jpeg` / `.webp`）
- 安装包：最新正式发布里的 `<manifest 的 id>.satellite`，文件名也就是装好后的 app id

改完运行：

```sh
xmake validate
```
