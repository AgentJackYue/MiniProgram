App({
  onLaunch: function () {
    if (!wx.cloud) {
      console.error('请使用 2.2.3 或以上的基础库以使用云能力');
    } else {
      wx.cloud.init({
        env: 'wx-env01-3gf49vue58112f19',
        traceUser: true,
      });
    }
      if (wx.getStorageSync('userInfo')) {
        // 用户已经授权，可以直接获取用户信息
        const userInfo = wx.getStorageSync('userInfo');
        const avatarUrl = userInfo.avatarUrl;
      }
    this.globalData = {
      updateNotes: function() {
        const pages = getCurrentPages(); // 获取页面栈
        const page = pages[pages.length - 2]; // 展示页面应该是上一个页面
        if (page && page.loadNotes) {
          page.loadNotes();
        }
      }
    };
  }
});