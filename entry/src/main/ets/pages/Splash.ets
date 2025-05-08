import router from '@ohos.router';

@Entry
@Component
struct Splash {
  @State countdown: number = 5  // 倒计时秒数
  @State imgOpacity: number = 0  // 图片透明度
  @State imgScale: number = 1.0  // 图片缩放比例
  @State textOpacity: number = 0 // 文字透明度
  @State particleOpacity: number = 0 // 粒子效果透明度
  @State blurRadius: number = 0 // 模糊半径
  private timer: number = -1    // 定时器ID
  
  aboutToAppear() {
    console.info('Splash页面启动');
    // 启动动画和倒计时
    this.startAnimations();
    this.startCountdown();
  }
  
  aboutToDisappear() {
    // 清除定时器
    this.clearTimer();
    console.info('Splash页面退出');
  }
  
  // 启动倒计时
  startCountdown() {
    console.info('开始倒计时');
    this.timer = setInterval(() => {
      this.countdown--;
      console.info(`倒计时: ${this.countdown}秒`);
      if (this.countdown <= 0) {
        this.navigateToLogin();
      }
    }, 1000);
  }
  
  // 清除定时器
  clearTimer() {
    if (this.timer !== -1) {
      clearInterval(this.timer);
      this.timer = -1;
      console.info('定时器已清除');
    }
  }
  
  // 开始动画效果
  startAnimations() {
    console.info('开始启动动画');
    
    // 背景图片淡入动画
    this.animateBackgroundIn();
  }
  
  // 背景图片淡入
  animateBackgroundIn() {
    console.info('背景图片淡入动画');
    animateTo({
      duration: 1000,
      curve: Curve.EaseInOut,
      delay: 100,
      onFinish: () => {
        console.info('背景图片淡入完成，开始文字淡入');
        this.animateTextIn();
      }
    }, () => {
      this.imgOpacity = 1;
    });
  }
  
  // 文字淡入
  animateTextIn() {
    animateTo({
      duration: 800,
      curve: Curve.EaseIn,
      delay: 200,
      onFinish: () => {
        console.info('文字淡入完成，开始粒子效果和图片缩放');
        this.animateParticlesAndScale();
      }
    }, () => {
      this.textOpacity = 1;
    });
  }
  
  // 粒子效果和图片缩放
  animateParticlesAndScale() {
    // 粒子效果
    animateTo({
      duration: 1000,
      curve: Curve.EaseInOut,
      delay: 100,
      onFinish: () => {
        console.info('粒子效果动画完成');
        
        // 增加模糊效果
        animateTo({
          duration: 2000,
          curve: Curve.EaseInOut,
          onFinish: () => {
            console.info('模糊效果动画完成');
          }
        }, () => {
          this.blurRadius = 10;
        });
      }
    }, () => {
      this.particleOpacity = 1;
    });
    
    // 缓慢缩放背景图
    animateTo({
      duration: 4000,
      curve: Curve.Linear,
      onFinish: () => {
        console.info('背景缩放动画完成');
      }
    }, () => {
      this.imgScale = 1.05;
    });
  }
  
  // 导航到登录页面
  navigateToLogin() {
    console.info('准备跳转到登录页面');
    this.clearTimer();
    router.replaceUrl({
      url: 'pages/Login'
    });
  }
  
  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      // 主背景图片 - 使用空间大图
      Image($r('app.media.3'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .opacity(this.imgOpacity)
        .scale({ x: this.imgScale, y: this.imgScale })
        .animation({
          duration: 300,
          curve: Curve.Linear
        })
      
      // 蓝色粒子效果层
      Column()
        .width('100%')
        .height('40%')
        .backgroundImage($r('app.media.3'))
        .backgroundImagePosition(Alignment.Bottom)
        .backgroundImageSize(ImageSize.Cover)
        .opacity(this.particleOpacity * 0.4)
        .blur(this.blurRadius)
        .animation({
          duration: 800,
          curve: Curve.EaseInOut
        })
        .position({ x: 0, y: '60%' })
      
      // 内容层
      Column() {
        // 头部跳过按钮
        Row() {
          Blank()
          Button() {
            Row() {
              Text(`跳过 ${this.countdown}s`)
                .fontSize(14)
                .fontColor('#FFFFFF')
                .margin({ right: 4 })
              
              Progress({ value: this.countdown, total: 5, type: ProgressType.Ring })
                .width(18)
                .height(18)
                .color('#FFFFFF')
                .style({ strokeWidth: 2 })
            }
            .width(90)
            .height(32)
            .justifyContent(FlexAlign.Center)
          }
          .backgroundColor('rgba(0,0,0,0.4)')
          .borderRadius(16)
          .margin({ top: 40, right: 16 })
          .onClick(() => {
            this.navigateToLogin();
          })
        }
        .width('100%')
        
        Blank()
        
        // 中间标题层
        Column() {
          // 应用名称
          Text('探索新世界')
            .fontSize(44)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .opacity(this.textOpacity)
            .shadow({ radius: 10, color: 'rgba(0,0,0,0.5)', offsetX: 2, offsetY: 2 })
            .animation({
              duration: 500, 
              curve: Curve.EaseOut
            })
          
          Text('开启无限可能')
            .fontSize(22)
            .fontColor('#FFFFFF')
            .opacity(this.textOpacity)
            .margin({ top: 8, bottom: 100 })
            .animation({
              duration: 500,
              delay: 200,
              curve: Curve.EaseOut
            })
        }
        .margin({ bottom: 100 })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000') // 添加黑色背景色，确保在图片加载前有底色
  }
} 