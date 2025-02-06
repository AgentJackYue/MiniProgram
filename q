[33mcommit 5d5cc5752382767ad40a14b392fe785ee5df7c19[m[33m ([m[1;36mHEAD[m[33m -> [m[1;32mmain[m[33m)[m
Author: Yuexmh <2269643334@qq.com>
Date:   Thu Feb 6 18:20:38 2025 +0800

    animate 'note' button

[1mdiff --git a/miniprogram/app.json b/miniprogram/app.json[m
[1mindex c37cac2..dca5c9b 100644[m
[1m--- a/miniprogram/app.json[m
[1m+++ b/miniprogram/app.json[m
[36m@@ -1,7 +1,7 @@[m
 {[m
   "pages": [[m
     "pages/index/index",[m
[31m-    "pages/bussiness/index",[m
[32m+[m[32m    "pages/bussiness/bussiness",[m
     "pages/AddNotePage/AddNotePage"],[m
   "window": {[m
     "backgroundColor": "#F6F6F6",[m
[1mdiff --git a/miniprogram/pages/bussiness/index.js b/miniprogram/pages/bussiness/bussiness.js[m
[1msimilarity index 53%[m
[1mrename from miniprogram/pages/bussiness/index.js[m
[1mrename to miniprogram/pages/bussiness/bussiness.js[m
[1mindex b634d5f..16b230f 100644[m
[1m--- a/miniprogram/pages/bussiness/index.js[m
[1m+++ b/miniprogram/pages/bussiness/bussiness.js[m
[36m@@ -1,7 +1,8 @@[m
 Page({[m
   data: {[m
     data: "记事本",[m
[31m-    notes: [][m
[32m+[m[32m    notes: [],[m
[32m+[m[32m    resetActive: false // 添加一个标志位[m
   },[m
   onLoad: function() {[m
     // 页面加载时从本地存储中读取记事数据[m
[36m@@ -10,21 +11,39 @@[m [mPage({[m
       notes: notes.filter(note => note.title.trim() || note.content.trim())[m
     });[m
   },[m
[32m+[m[32m  onShow: function() {[m
[32m+[m[32m    // 每次页面显示时重新加载笔记数据[m
[32m+[m[32m    this.loadNotes();[m
[32m+[m[32m  },[m
   loadNotes: function() {[m
     const notes = this.getNotesFromStorage();[m
     this.setData({[m
[31m-      notes: notes.filter(note => note.title.trim() || note.content.trim())[m
[32m+[m[32m      notes: notes.filter(note => note.title.trim() || note.content.trim()),[m
[32m+[m[32m      notes: notes.map(note => ({...note,activeClass: '' }))// 初始化 activeClass[m
     });[m
   },[m
   navigateToAddOrEdit: function(e) {[m
     let noteId = null;[m
     if (e && e.currentTarget.dataset && e.currentTarget.dataset.id) {[m
       noteId = e.currentTarget.dataset.id;[m
[32m+[m[32m      const index = e.currentTarget.dataset.index; // 获取当前点击的索引[m
[32m+[m[32m      const notes = this.data.notes;[m
[32m+[m[32m      notes[index].activeClass = 'active'; // 设置当前点击的 activeClass[m
[32m+[m[32m      this.setData({[m
[32m+[m[32m        notes[m
[32m+[m[32m      });[m
[32m+[m[32m      setTimeout(() => {[m
[32m+[m[32m        notes[index].activeClass = '';[m
[32m+[m[32m        this.setData({[m
[32m+[m[32m          notes[m
[32m+[m[32m        });[m
[32m+[m[32m      }, 50); // 50ms[m
     }[m
     wx.navigateTo({[m
       url: `/pages/AddNotePage/AddNotePage?id=${noteId}`[m
     });[m
   },[m
[32m+[m[41m  [m
   getNotesFromStorage: function() {[m
     // 从本地存储获取所有记事[m
     return wx.getStorageSync('notes') || [];[m
[36m@@ -33,5 +52,14 @@[m [mPage({[m
     // 保存 notes 数组到本地存储[m
     wx.setStorageSync('notes', this.data.notes);[m
   },[m
[31m-  [m
[32m+[m[32m  onUnload: function() {[m
[32m+[m[32m    // 页面卸载时重置所有 activeClass[m
[32m+[m[32m    const notes = this.data.notes.map(note => ({[m
[32m+[m[32m      ...note,[m
[32m+[m[32m      activeClass: ''[m
[32m+[m[32m    }));[m
[32m+[m[32m    this.setData({[m
[32m+[m[32m      notes[m
[32m+[m[32m    });[m
[32m+[m[32m  },[m
 });[m
\ No newline at end of file[m
[1mdiff --git a/miniprogram/pages/bussiness/index.json b/miniprogram/pages/bussiness/bussiness.json[m
[1msimilarity index 100%[m
[1mrename from miniprogram/pages/bussiness/index.json[m
[1mrename to miniprogram/pages/bussiness/bussiness.json[m
[1mdiff --git a/miniprogram/pages/bussiness/index.wxml b/miniprogram/pages/bussiness/bussiness.wxml[m
[1msimilarity index 53%[m
[1mrename from miniprogram/pages/bussiness/index.wxml[m
[1mrename to miniprogram/pages/bussiness/bussiness.wxml[m
[1mindex 23949f4..c745631 100644[m
[1m--- a/miniprogram/pages/bussiness/index.wxml[m
[1m+++ b/miniprogram/pages/bussiness/bussiness.wxml[m
[36m@@ -1,7 +1,11 @@[m
 <view class="container">[m
   <view class ="text">{{data}}</view>[m
   <block wx:for="{{notes}}" wx:key="index">[m
[31m-    <view class="note" style="width: 300px; white-space: pre-wrap; word-wrap: break-word; overflow-wrap: break-word;" bind:tap="navigateToAddOrEdit" data-id="{{item.id}}">[m
[32m+[m[32m    <view class="note {{item.activeClass}}"[m[41m [m
[32m+[m[32m          style="width: 300px; white-space: pre-wrap; word-wrap: break-word; overflow-wrap: break-word;"[m[41m [m
[32m+[m[32m          bind:tap="navigateToAddOrEdit"[m[41m [m
[32m+[m[32m          data-id="{{item.id}}"[m[41m [m
[32m+[m[32m          data-index="{{index}}">[m
       <text class = "title">{{item.title}}</text>[m
       <text>\n</text>[m
       <text>{{item.content}}</text>[m
[1mdiff --git a/miniprogram/pages/bussiness/index.wxss b/miniprogram/pages/bussiness/bussiness.wxss[m
[1msimilarity index 75%[m
[1mrename from miniprogram/pages/bussiness/index.wxss[m
[1mrename to miniprogram/pages/bussiness/bussiness.wxss[m
[1mindex ea6dad5..3f97636 100644[m
[1m--- a/miniprogram/pages/bussiness/index.wxss[m
[1m+++ b/miniprogram/pages/bussiness/bussiness.wxss[m
[36m@@ -15,4 +15,8 @@[m
   margin-bottom: 20rpx;[m
   padding: 20rpx;[m
   background-color: #3ecbee;[m
[31m-}[m
\ No newline at end of file[m
[32m+[m[32m  transition: transform 0.05s ease;[m
[32m+[m[32m}[m
[32m+[m[32m.note.active {[m
[32m+[m[32m  transform: scale(0.9);[m
[32m+[m[32m}[m
[1mdiff --git a/miniprogram/pages/index/index.js b/miniprogram/pages/index/index.js[m
[1mindex edf8ad7..da50896 100644[m
[1m--- a/miniprogram/pages/index/index.js[m
[1m+++ b/miniprogram/pages/index/index.js[m
[36m@@ -14,7 +14,7 @@[m [mPage({[m
     changescroll:function(){[m
       console.log("press2")[m
       wx.navigateTo({[m
[31m-        url: '/pages/bussiness/index'[m
[32m+[m[32m        url: '/pages/bussiness/bussiness'[m
       });[m
     },[m
 });[m
\ No newline at end of file[m
[1mdiff --git a/project.config.json b/project.config.json[m
[1mindex 3a5e8a7..2bd2949 100644[m
[1m--- a/project.config.json[m
[1m+++ b/project.config.json[m
[36m@@ -1,6 +1,5 @@[m
 {[m
   "miniprogramRoot": "miniprogram/",[m
[31m-  "cloudfunctionRoot": "cloudfunctions/",[m
   "setting": {[m
     "urlCheck": true,[m
     "es6": true,[m
[36m@@ -40,29 +39,7 @@[m
   "projectname": "quickstart-wx-cloud",[m
   "libVersion": "latest",[m
   "cloudfunctionTemplateRoot": "cloudfunctionTemplate/",[m
[31m-  "condition": {[m
[31m-    "search": {[m
[31m-      "list": [][m
[31m-    },[m
[31m-    "conversation": {[m
[31m-      "list": [][m
[31m-    },[m
[31m-    "plugin": {[m
[31m-      "list": [][m
[31m-    },[m
[31m-    "game": {[m
[31m-      "list": [][m
[31m-    },[m
[31m-    "miniprogram": {[m
[31m-      "list": [[m
[31m-        {[m
[31m-          "id": -1,[m
[31m-          "name": "db guide",[m
[31m-          "pathName": "pages/databaseGuide/databaseGuide"[m
[31m-        }[m
[31m-      ][m
[31m-    }[m
[31m-  },[m
[32m+[m[32m  "condition": {},[m
   "compileType": "miniprogram",[m
   "srcMiniprogramRoot": "miniprogram/",[m
   "packOptions": {[m
[1mdiff --git a/project.private.config.json b/project.private.config.json[m
[1mindex fca4c6f..7a73a41 100644[m
[1m--- a/project.private.config.json[m
[1m+++ b/project.private.config.json[m
[36m@@ -1,37 +1,2 @@[m
 {[m
[31m-  "setting": {[m
[31m-    "compileHotReLoad": true,[m
[31m-    "urlCheck": true[m
[31m-  },[m
[31m-  "condition": {[m
[31m-    "miniprogram": {[m
[31m-      "list": [[m
[31m-        {[m
[31m-          "name": "首页-快速开始",[m
[31m-          "pathName": "pages/index/index",[m
[31m-          "query": ""[m
[31m-        },[m
[31m-        {[m
[31m-          "name": "商品列表",[m
[31m-          "pathName": "pages/goods-list/index",[m
[31m-          "query": "",[m
[31m-          "scene": null[m
[31m-        },[m
[31m-        {[m
[31m-          "name": "云开发示例",[m
[31m-          "pathName": "pages/examples/index",[m
[31m-          "query": "",[m
[31m-          "scene": null[m
[31m-        },[m
[31m-        {[m
[31m-          "name": "个人中心",[m
[31m-          "pathName": "pages/user-center/index",[m
[31m-          "query": "",[m
[31m-          "scene": null[m
[31m-        }[m
[31m-      ][m
[31m-    }[m
[31m-  },[m
[31m-  "description": "项目私有配置文件。此文件中的内容将覆盖 project.config.json 中的相同字段。项目的改动优先同步到此文件中。详见文档：https://developers.weixin.qq.com/miniprogram/dev/devtools/projectconfig.html",[m
[31m-  "projectname": "MiniProgramTest1"[m
 }[m
\ No newline at end of file[m
