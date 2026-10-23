# Planet Avenue

planet 应用库里列出的 satellite：<https://avenue.heyplanet.app/apps.json>，由
Cloudflare Pages 直接发布这个仓库。

`apps.json` 是安装包地址的列表。planet 的应用库读它，安装时下载对应的地址（planet
仓库的 `crates/planet-web/src/store.rs`）；文件名去掉 `.satellite` 就是装好后的
app id，所以不能有两个同名的文件。

GitHub 发布用这种地址，总是指向最新正式发布里的那个文件：

```
https://github.com/<owner>/<repo>/releases/latest/download/<文件名>.satellite
```

改完运行：

```sh
xmake validate
```
