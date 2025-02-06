// pages/somePage/somePage.js
const utils = require('../../utils/utils.js'); // 引入 utils 模块

Page({
  data: {
    title: '',
    content: '',
    noteId: null
  },
  onLoad: function(options) {
    this.setData({
      noteId: options.id ? parseInt(options.id) : null
    });
    // 如果没有传递ID，则初始化一个新的记事对象
    if (!this.data.noteId) {
      const newNote = { id: Date.now(), title: '', content: '', createTime: utils.formatTime(new Date()) };
      this.setData({
        title: newNote.title,
        content: newNote.content,
        createTime: newNote.createTime
      });
    }
    // 如果传递了ID，则加载现有记事的数据
    else {
      const notes = wx.getStorageSync('notes') || [];
      const note = notes.find(n => n.id === this.data.noteId);
      console.log('找到的记事:', note); // 调试信息
      if (note) {
        this.setData({
          title: note.title,
          content: note.content,
          createTime: note.createTime
        });
      } else {
        console.log('未找到对应的记事'); // 调试信息
      }
    }
  },
  inputTitle: function(e) {
    this.setData({
      title: e.detail.value
    });
  },
  inputContent: function(e) {
    this.setData({
      content: e.detail.value
    });
  },
  saveNote: function() {
    const { noteId, title, content } = this.data;
    let notes = wx.getStorageSync('notes') || [];
    const index = notes.findIndex(note => note.id === noteId);
    const currentTime = utils.formatTime(new Date()); // 获取当前时间
    console.log(currentTime);
    if (index !== -1) {
      // 更新现有笔记
      notes[index] = { id: noteId, title: title, content: content, createTime: currentTime };
    } else {
      // 创建新笔记
      const newNote = { id: Date.now(), title: title, content: content, createTime: currentTime };
      notes.push(newNote);
    }

    // 保存到本地存储
    wx.setStorageSync('notes', notes);

    // 调用App实例的方法来更新展示页面的数据
    const app = getApp();
    app.globalData.updateNotes();

    // 返回上一页
    wx.navigateBack();
  },
  deleteNote: function() {
    wx.showModal({
      title: '确认删除',
      content: '删除后将无法找回',
      success: (res) => {
        if (res.confirm) {
          console.log('用户点击确定');
          const noteId = this.data.noteId;
          let notes = this.getNotesFromStorage();
          // 过滤掉要删除的记事
          notes = notes.filter(note => note.id !== noteId);
          // 更新本地存储
          wx.setStorageSync('notes', notes);
          // 清空当前页面的记事数据
          this.setData({
            title: '',
            content: '',
            noteId: null
          });
          // 调用App实例的方法来更新展示页面的数据
          const app = getApp();
          app.globalData.updateNotes();
          // 返回上一页
          wx.navigateBack();
        } else if (res.cancel) {
          console.log('用户点击取消');
        }
      }
    });
  },
  getNotesFromStorage: function() {
    // 从本地存储获取所有记事
    return wx.getStorageSync('notes') || [];
  }
});