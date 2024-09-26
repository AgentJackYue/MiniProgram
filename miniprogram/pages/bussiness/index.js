Page({
  data: {
    data: "记事本",
    notes: []
  },
  onLoad: function() {
    // 页面加载时从本地存储中读取记事数据
    const notes = this.getNotesFromStorage();
    this.setData({
      notes: notes.filter(note => note.title.trim() || note.content.trim())
    });
  },
  loadNotes: function() {
    const notes = this.getNotesFromStorage();
    this.setData({
      notes: notes.filter(note => note.title.trim() || note.content.trim())
    });
  },
  navigateToAddOrEdit: function(e) {
    let noteId = null;
    if (e && e.currentTarget.dataset && e.currentTarget.dataset.id) {
      noteId = e.currentTarget.dataset.id;
    }
    wx.navigateTo({
      url: `/pages/AddNotePage/index?id=${noteId}`
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
  
});