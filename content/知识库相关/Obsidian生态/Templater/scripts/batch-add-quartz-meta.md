---
publish: true
title: batch-add-quartz-meta
created: 2026-11-02
modified: 2026-11-02T04:55:29.285Z
---

````
<%*
// ========== 配置区，你改这里 ==========
//const targetFolder = ""; // 要处理的子文件夹名称，留空处理所有
const fixedTags = []; // 统一追加的tags，[]就是不加
const override = false; // false=只补缺失、不覆盖已有值；true=强制覆盖
// ======================================

const vault = app.vault;
const files = vault.getFiles().filter(f => {
  return f.extension === "md";
});

let cnt = 0;
for (const file of files) {
  await app.fileManager.processFrontMatter(file, (fm) => {
    // title：取文件名（去掉.md后缀），缺失才填 
    if (!fm.title || override) { 
      fm.title = file.basename; 
    } 
    // description：留空字符串，缺失才填 
    if (!fm.description || override) { 
      fm.description = ""; 
    }
    // date：不存在才填充，取文件创建时间 ctime
    if (!fm.date || override) {
      fm.date = new Date(file.stat.ctime).toISOString().split("T")[0];
    }
    // tags：不存在就赋值；存在则不改动（不会追加，如需追加我给你改版本）
    if ((!fm.tags || override)) {
      if(fixedTags.length > 0) {
        fm.tags = fixedTags;
      }else {```

````

```
    fm.tags = [];
  }
}
// draft false
if (fm.draft === undefined || override) {
  fm.draft = false;
}
// publish true
if (fm.publish === undefined || override) {
  fm.publish = true;
}
```

})
cnt++;
}
new Notice(`处理完成，一共 ${cnt} 个md文件`);
%>

```
```
