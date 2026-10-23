# Planet Avenue

planet 应用库里列出的 satellite。planet 的应用页读取这里的 `satellites.json`，
每一项从它自己仓库最新的 GitHub 发布里下载 `.satellite` 安装（planet 仓库的
`crates/planet-web/src/store.rs`）。

## 添加一个 satellite

在 `satellites.json` 的 `satellites` 里加一项：

```json
{
  "id": "files",
  "name": "Files",
  "description": "一句话介绍",
  "repository": "heyplanet-app/satellite-files",
  "asset": "files.satellite"
}
```

- `id`：在这份列表里的编号，小写字母、数字和 `-`，不能重复
- `repository`：GitHub 上的 `owner/name`
- `asset`：发布里要安装的文件。文件名就是装好后的 app id（去掉 `.satellite`），
  所以两项不能用同一个文件名

仓库需要有带这个文件的发布（预发布也算，草稿不算）；planet 校验 GitHub 记录的
SHA-256 后才安装。

改完运行：

```sh
xmake validate
```

## 用别的列表

planet 默认读这个仓库的 `satellites.json`。设置页的「应用库地址」（即
`planet-web.toml` 的 `[store] avenue`）可以改成任何一个 `satellites.json`
的 https 地址。私有仓库通过 GitHub API 读取，planet 运行时需要设置
`GITHUB_TOKEN`。
