import router from '@ohos.router';

@Entry
@Component
struct Login {
  @State username: string = ''
  @State password: string = ''
  @State isLoading: boolean = false
  @State showSlider: boolean = false
  @State sliderValue: number = 0
  @State isSliderVerified: boolean = false
  @State sliderText: string = '向右滑动完成验证'

  build() {
    Stack() {
      // 背景图片
      Image($r('app.media.1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 页面内容
      Column() {
        // 标题区域
        Column() {
          Text('京西')
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 100, bottom: 20 })
            .fontColor('#333333')

          Text('欢迎回来')
            .fontSize(18)
            .fontColor('#666666')
            .margin({ bottom: 50 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        // 输入区域
        Column() {
          // 用户名输入
          TextInput({ placeholder: '请输入用户名' })
            .width('90%')
            .height(50)
            .margin({ bottom: 20 })
            .backgroundColor('#F5F5F5')
            .borderRadius(25)
            .padding({ left: 20, right: 20 })
            .placeholderColor('#999999')
            .fontSize(16)
            .onChange((value: string) => {
              this.username = value
            })

          // 密码输入
          TextInput({ placeholder: '请输入密码' })
            .width('90%')
            .height(50)
            .margin({ bottom: 30 })
            .backgroundColor('#F5F5F5')
            .borderRadius(25)
            .padding({ left: 20, right: 20 })
            .placeholderColor('#999999')
            .fontSize(16)
            .type(InputType.Password)
            .onChange((value: string) => {
              this.password = value
            })

          // 登录按钮
          Button('登 录')
            .width('90%')
            .height(50)
            .backgroundColor('#007DFF')
            .borderRadius(25)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .onClick(() => {
              this.handleLogin()
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        // 滑块验证
        if (this.showSlider) {
          Column() {
            Text(this.sliderText)
              .fontSize(16)
              .fontColor('#666666')
              .margin({ bottom: 20 })

            Stack() {
              // 滑块背景
              Row()
                .width('90%')
                .height(50)
                .backgroundColor('#F5F5F5')
                .borderRadius(25)

              // 滑块
              Row() {}
              .width(50)
              .height(50)
              .backgroundColor('#007DFF')
              .borderRadius(25)
              .position({ x: this.sliderValue * 2.7 })
              .gesture(
                PanGesture()
                  .onActionStart(() => {
                    this.sliderText = '向右滑动完成验证'
                  })
                  .onActionUpdate((event: GestureEvent) => {
                    if (event.offsetX > 0 && event.offsetX < 270) {
                      this.sliderValue = event.offsetX
                    }
                  })
                  .onActionEnd(() => {
                    if (this.sliderValue >= 250) {
                      this.sliderText = '验证成功'
                      this.isSliderVerified = true
                      setTimeout(() => {
                        router.replaceUrl({ url: 'pages/Index' })
                      }, 500)
                    } else {
                      this.sliderValue = 0
                      this.sliderText = '验证失败，请重试'
                    }
                  })
              )
            }
            .width('90%')
            .height(50)
          }
          .width('100%')
          .margin({ top: 30 })
          .alignItems(HorizontalAlign.Center)
        }

        // 加载指示器
        if (this.isLoading) {
          LoadingProgress()
            .width(24)
            .height(24)
            .margin({ top: 16 })
            .color('#007DFF')
        }
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  private handleLogin(): void {
    if (!this.username || !this.password) {
      AlertDialog.show({
        title: '提示',
        message: '请输入用户名和密码',
        confirm: {
          value: '确定',
          action: () => {
          }
        }
      })
      return
    }
    if (this.username !== 'admin' || this.password !== '12345678') {
      AlertDialog.show({
        title: '提示',
        message: '用户名或密码错误',
        confirm: {
          value: '确定',
          action: () => {
          }
        }
      })
      return
    }
    this.isLoading = true
    setTimeout((): void => {
      this.isLoading = false
      this.showSlider = true
    }, 1000)
  }
}