Page({
    data:{
        hello:"Hi~",
        textcheck:"记事本入口",
        avatarUrl: 'avatar.png' ,// 用于存储用户头像的 URL
    },
    
    // change: function () {
    //     this.setData({
    //         hello: this.data.hello + "~~",
    //     });
    //     console.log("press1")
    // },
    changescroll:function(){
      console.log("press2")
      wx.navigateTo({
        url: '/pages/bussiness/index'
      });
    },
});