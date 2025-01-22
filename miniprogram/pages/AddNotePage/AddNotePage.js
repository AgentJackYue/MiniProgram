Page({
  data: {
    title: '',
    content: ''
  },
  onLoad: function(options) {
    this.setData({
      noteId: options.id ? parseInt(options.id) : null
    });
    // 如果没有传递ID，则初始化一个新的记事对象
    if (!this.data.noteId) {
      const newNote = { id: Date.now(), title: '', content: '' };
      this.setData({
        title: newNote.title,
        content: newNote.content
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
          content: note.content
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
    if (index !== -1) {
      notes[index] = { id: noteId, title: title, content: content };
    } else {
      const newNote = { id: Date.now(), title: title, content: content };
      notes.push(newNote);
    }
    wx.setStorageSync('notes', notes);
    const app = getApp();
    app.globalData.updateNotes();
    wx.navigateBack();
  },
  deleteNote: function() {
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
  
    wx.navigateBack();
  },
  getNotesFromStorage: function() {
    // 从本地存储获取所有记事
    return wx.getStorageSync('notes') || [];
  }
});
