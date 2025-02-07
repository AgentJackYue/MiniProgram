Page({
  data: {
    data: "记事本",
    notes: [],
    resetActive: false // 添加一个标志位
  },
  onLoad: function() {
    // 页面加载时从本地存储中读取记事数据
    const notes = this.getNotesFromStorage();
    this.setData({
      notes: notes.filter(note => note.title.trim() || note.content.trim())
    });
  },
  onShow: function() {
    // 每次页面显示时重新加载笔记数据
    this.loadNotes();
  },
  loadNotes: function() {
    const notes = this.getNotesFromStorage();
    const filteredNotes = notes.filter(note => note.title.trim() || note.content.trim());
    wx.setStorageSync('notes', filteredNotes);
    this.setData({
      notes: filteredNotes.map(note => ({ ...note, activeClass: '' }))
    });
  },
  navigateToAddOrEdit: function(e) {
    let noteId = null;
    if (e && e.currentTarget.dataset && e.currentTarget.dataset.id) {
      noteId = e.currentTarget.dataset.id;
      const index = e.currentTarget.dataset.index; // 获取当前点击的索引
      const notes = this.data.notes;
      notes[index].activeClass = 'active'; // 设置当前点击的 activeClass
      this.setData({
        notes
      });
      setTimeout(() => {
        notes[index].activeClass = '';
        this.setData({
          notes
        });
      }, 50); // 50ms
    }
    wx.navigateTo({
      url: `/pages/AddNotePage/AddNotePage?id=${noteId}`
    });
  },
  
  getNotesFromStorage: function() {
    // 从本地存储获取所有记事
    return wx.getStorageSync('notes') || [];
  },
  saveNotesToStorage: function() {
    // 保存 notes 数组到本地存储
    wx.setStorageSync('notes', this.data.notes);
  },
  onUnload: function() {
    // 页面卸载时重置所有 activeClass
    const notes = this.data.notes.map(note => ({
      ...note,
      activeClass: ''
    }));
    this.setData({
      notes
    });
  },
});