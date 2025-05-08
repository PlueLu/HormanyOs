import router from '@ohos.router';
import dataPreferences from '@ohos.data.preferences';

@Entry
@Component
struct Register {
  @State username: string = ''
  @State password: string = ''
  @State confirmPassword: string = ''
  @State phoneNumber: string = ''
  @State verificationCode: string = ''
  @State countdown: number = 0
  @State isLoading: boolean = false
  @State agreement: boolean = false
  @State generatedCode: string = '' // 用于存储生成的验证码

  // 生成6位随机数字验证码
  private generateVerificationCode(): string {
    let code = ''
    for (let i = 0; i < 6; i++) {
      code += Math.floor(Math.random() * 10).toString()
    }
    return code
  }

  // 保存注册信息
  async saveRegisteredUser() {
    try {
      // 保存为重置密码格式，这样可以用手机号登录
      const resetPreferences = await dataPreferences.getPreferences(getContext(this), 'reset_password_prefs')
      
      // 将该手机号的重置标志设为true，这样该手机号只能用最新密码登录
      await resetPreferences.put('has_reset', true)
      await resetPreferences.put('username', this.phoneNumber) // 使用手机号作为用户名
      await resetPreferences.put('password', this.password)
      await resetPreferences.flush()
      
      // 同时保存用户名信息
      const userPreferences = await dataPreferences.getPreferences(getContext(this), 'user_prefs')
      await userPreferences.put('registered_username', this.username)
      await userPreferences.put('registered_phone', this.phoneNumber)
      await userPreferences.put('registered_password', this.password) // 额外保存密码
      await userPreferences.put('registration_time', new Date().getTime())
      await userPreferences.flush()
      
      console.info('注册信息保存成功，手机号: ' + this.phoneNumber + ', 密码已保存')
    } catch (error) {
      console.error('保存注册信息失败')
    }
  }

  build() {
    Stack() {
      // 背景图片
      Image($r('app.media.1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 页面内容
      Column() {
        // 顶部导航栏
        Row() {
          Image($r('app.media.2'))
            .width(24)
            .height(24)
            .onClick(() => {
              router.back()
            })
          Text('注册账号')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
          Blank()
        }
        .width('90%')
        .padding({ top: 16, bottom: 16 })

        // 注册表单
        Scroll() {
          Column() {
            // 用户名输入
            TextInput({ placeholder: '请输入用户名' })
              .width('90%')
              .height(50)
              .margin({ bottom: 20, top: 20 })
              .backgroundColor('#F5F5F5')
              .borderRadius(25)
              .padding({ left: 20, right: 20 })
              .placeholderColor('#999999')
              .fontSize(16)
              .onChange((value: string) => {
                this.username = value
              })

            // 手机号输入
            TextInput({ placeholder: '请输入手机号码' })
              .width('90%')
              .height(50)
              .margin({ bottom: 20 })
              .backgroundColor('#F5F5F5')
              .borderRadius(25)
              .padding({ left: 20, right: 20 })
              .placeholderColor('#999999')
              .fontSize(16)
              .inputFilter('^[0-9]*$')
              .maxLength(11)
              .onChange((value: string) => {
                this.phoneNumber = value
              })

            // 验证码输入
            Row() {
              TextInput({ placeholder: '请输入验证码' })
                .width('65%')
                .height(50)
                .backgroundColor('#F5F5F5')
                .borderRadius(25)
                .padding({ left: 20, right: 20 })
                .placeholderColor('#999999')
                .fontSize(16)
                .inputFilter('^[0-9]*$')
                .maxLength(6)
                .onChange((value: string) => {
                  this.verificationCode = value
                })

              Button(this.countdown > 0 ? `${this.countdown}秒后重新发送` : '获取验证码')
                .width('30%')
                .height(50)
                .backgroundColor(this.countdown > 0 ? '#CCCCCC' : '#007DFF')
                .borderRadius(25)
                .fontSize(14)
                .enabled(this.countdown <= 0)
                .onClick(() => {
                  this.sendVerificationCode()
                })
            }
            .width('90%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ bottom: 20 })

            // 显示当前生成的验证码（仅开发测试用）
            if (this.generatedCode !== '') {
              Row() {
                Text('当前验证码: ')
                  .fontSize(14)
                  .fontColor('#666666')
                Text(this.generatedCode)
                  .fontSize(14)
                  .fontColor('#FF0000')
                  .fontWeight(FontWeight.Bold)
              }
              .width('90%')
              .margin({ bottom: 10 })
              .justifyContent(FlexAlign.Center)
            }

            // 密码输入
            TextInput({ placeholder: '请输入密码' })
              .width('90%')
              .height(50)
              .margin({ bottom: 20 })
              .backgroundColor('#F5F5F5')
              .borderRadius(25)
              .padding({ left: 20, right: 20 })
              .placeholderColor('#999999')
              .fontSize(16)
              .type(InputType.Password)
              .onChange((value: string) => {
                this.password = value
              })

            // 确认密码输入
            TextInput({ placeholder: '请确认密码' })
              .width('90%')
              .height(50)
              .margin({ bottom: 20 })
              .backgroundColor('#F5F5F5')
              .borderRadius(25)
              .padding({ left: 20, right: 20 })
              .placeholderColor('#999999')
              .fontSize(16)
              .type(InputType.Password)
              .onChange((value: string) => {
                this.confirmPassword = value
              })

            // 用户协议
            Row() {
              Checkbox()
                .select(this.agreement)
                .onChange((value: boolean) => {
                  this.agreement = value
                })
              Text('我已阅读并同意')
                .fontSize(14)
                .fontColor('#666666')
                .margin({ left: 5 })
              Text('《用户协议》和《隐私政策》')
                .fontSize(14)
                .fontColor('#007DFF')
                .onClick(() => {
                  // 打开用户协议页面
                  router.pushUrl({
                    url: 'pages/Agreement'
                  })
                })
            }
            .width('90%')
            .margin({ bottom: 30 })

            // 注册按钮
            Button('注 册')
              .width('90%')
              .height(50)
              .backgroundColor('#007DFF')
              .borderRadius(25)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .onClick(() => {
                this.register()
              })

            // 已有账号
            Row() {
              Text('已有账号？')
                .fontSize(14)
                .fontColor('#666666')
              Text('立即登录')
                .fontSize(14)
                .fontColor('#007DFF')
                .onClick(() => {
                  router.back()
                })
            }
            .margin({ top: 20, bottom: 30 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .layoutWeight(1)

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
      .padding({ top: 50 })
    }
    .width('100%')
    .height('100%')
  }

  // 发送验证码
  private sendVerificationCode(): void {
    if (!this.phoneNumber || this.phoneNumber.length !== 11) {
      AlertDialog.show({
        title: '提示',
        message: '请输入正确的手机号码',
        confirm: {
          value: '确定',
          action: () => {}
        }
      })
      return
    }

    // 生成随机验证码
    this.generatedCode = this.generateVerificationCode()

    // 模拟发送验证码
    this.countdown = 60
    const timer = setInterval(() => {
      this.countdown--
      if (this.countdown <= 0) {
        clearInterval(timer)
      }
    }, 1000)

    // 提示用户
    AlertDialog.show({
      title: '验证码已生成',
      message: `您的验证码是：${this.generatedCode}，有效期10分钟，请勿泄露给他人。`,
      confirm: {
        value: '确定',
        action: () => {}
      }
    })
  }

  // 注册
  private register(): void {
    // 表单验证
    if (!this.username || this.username.length < 3) {
      AlertDialog.show({
        title: '提示',
        message: '用户名长度不能少于3位',
        confirm: {
          value: '确定',
          action: () => {}
        }
      })
      return
    }

    if (!this.phoneNumber || this.phoneNumber.length !== 11) {
      AlertDialog.show({
        title: '提示',
        message: '请输入正确的手机号码',
        confirm: {
          value: '确定',
          action: () => {}
        }
      })
      return
    }

    if (!this.verificationCode || this.verificationCode.length !== 6) {
      AlertDialog.show({
        title: '提示',
        message: '请输入正确的验证码',
        confirm: {
          value: '确定',
          action: () => {}
        }
      })
      return
    }

    // 验证验证码是否正确
    if (this.verificationCode !== this.generatedCode) {
      AlertDialog.show({
        title: '提示',
        message: '验证码错误，请重新输入',
        confirm: {
          value: '确定',
          action: () => {}
        }
      })
      return
    }

    if (!this.password || this.password.length < 6) {
      AlertDialog.show({
        title: '提示',
        message: '密码长度不能少于6位',
        confirm: {
          value: '确定',
          action: () => {}
        }
      })
      return
    }

    if (this.password !== this.confirmPassword) {
      AlertDialog.show({
        title: '提示',
        message: '两次输入的密码不一致',
        confirm: {
          value: '确定',
          action: () => {}
        }
      })
      return
    }

    if (!this.agreement) {
      AlertDialog.show({
        title: '提示',
        message: '请阅读并同意用户协议和隐私政策',
        confirm: {
          value: '确定',
          action: () => {}
        }
      })
      return
    }

    // 模拟注册
    this.isLoading = true
    
    // 保存注册信息
    this.saveRegisteredUser().then(() => {
      setTimeout(() => {
        this.isLoading = false
        AlertDialog.show({
          title: '提示',
          message: '注册成功，请使用手机号和密码登录',
          confirm: {
            value: '确定',
            action: () => {
              router.back()
            }
          }
        })
      }, 2000)
    })
  }
} 