import router from '@ohos.router';
import dataPreferences from '@ohos.data.preferences';

@Entry
@Component
struct ResetPassword {
  @State phoneNumber: string = ''
  @State verificationCode: string = ''
  @State newPassword: string = ''
  @State confirmPassword: string = ''
  @State countdown: number = 0
  @State isLoading: boolean = false
  @State generatedCode: string = '' // 用于存储生成的验证码

  // 生成6位随机数字验证码
  private generateVerificationCode(): string {
    let code = ''
    for (let i = 0; i < 6; i++) {
      code += Math.floor(Math.random() * 10).toString()
    }
    return code
  }

  // 保存重置后的密码
  async saveResetPassword() {
    try {
      // 获取重置密码的偏好存储
      const resetPreferences = await dataPreferences.getPreferences(getContext(this), 'reset_password_prefs')
      
      // 设置重置标志，确保只能用最新密码登录
      await resetPreferences.put('has_reset', true)
      await resetPreferences.put('username', this.phoneNumber) // 使用手机号作为新的用户名
      await resetPreferences.put('password', this.newPassword)
      await resetPreferences.flush()
      
      // 记录重置密码的时间
      const resetTimePreferences = await dataPreferences.getPreferences(getContext(this), 'reset_time_prefs')
      await resetTimePreferences.put('reset_time', new Date().getTime())
      await resetTimePreferences.put('phone_number', this.phoneNumber)
      await resetTimePreferences.flush()
      
      // 清除可能存在的记住密码信息，确保用户必须使用新密码
      try {
        const loginPreferences = await dataPreferences.getPreferences(getContext(this), 'login_prefs')
        // 如果记住的是这个手机号，则清除记住的密码
        const rememberedUsername = await loginPreferences.get('username', '')
        if (rememberedUsername.toString() === this.phoneNumber) {
          await loginPreferences.put('password', '')
          await loginPreferences.put('rememberPassword', false)
          await loginPreferences.flush()
        }
      } catch (error) {
        console.error('清除登录记住的密码失败')
      }
      
      console.info('重置密码保存成功')
    } catch (error) {
      console.error('保存重置密码失败')
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
          Text('重置密码')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
          Blank()
        }
        .width('90%')
        .padding({ top: 16, bottom: 16 })

        // 表单区域
        Column() {
          Text('请输入您的手机号码和验证码重置密码')
            .fontSize(16)
            .fontColor('#666666')
            .margin({ bottom: 30, top: 20 })

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

          // 新密码输入
          TextInput({ placeholder: '请输入新密码' })
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
              this.newPassword = value
            })

          // 确认密码输入
          TextInput({ placeholder: '请确认新密码' })
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
              this.confirmPassword = value
            })

          // 重置密码按钮
          Button('重置密码')
            .width('90%')
            .height(50)
            .backgroundColor('#007DFF')
            .borderRadius(25)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .onClick(() => {
              this.resetPassword()
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)

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

  // 重置密码
  private resetPassword(): void {
    // 表单验证
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

    if (!this.newPassword || this.newPassword.length < 6) {
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

    if (this.newPassword !== this.confirmPassword) {
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

    // 模拟重置密码
    this.isLoading = true
    
    // 保存重置后的新密码
    this.saveResetPassword().then(() => {
      setTimeout(() => {
        this.isLoading = false
        AlertDialog.show({
          title: '提示',
          message: '密码重置成功，请使用新密码登录',
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