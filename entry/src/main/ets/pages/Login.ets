import router from '@ohos.router';
import dataPreferences from '@ohos.data.preferences';

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
  @State rememberPassword: boolean = false
  
  // 默认账号和密码
  private defaultUsername: string = 'admin'
  private defaultPassword: string = '12345678'
  private resetUsername: string = ''
  private resetPassword: string = ''
  private hasResetPassword: boolean = false

  aboutToAppear() {
    // 加载已重置的密码（如果有）
    this.loadResetPassword()
    // 加载已保存的凭据
    this.loadSavedCredentials()
  }

  // 加载已重置的密码
  async loadResetPassword() {
    try {
      const resetPreferences = await dataPreferences.getPreferences(getContext(this), 'reset_password_prefs')
      const hasReset = await resetPreferences.get('has_reset', false)
      
      if (hasReset) {
        const phoneNumber = await resetPreferences.get('username', '')
        const newPassword = await resetPreferences.get('password', '')
        
        if (phoneNumber.toString() !== '' && newPassword.toString() !== '') {
          this.resetUsername = phoneNumber.toString()
          this.resetPassword = newPassword.toString()
          this.hasResetPassword = true
          console.info('已加载重置后的密码信息')
        }
      }

      // 加载注册的用户信息
      try {
        const userPreferences = await dataPreferences.getPreferences(getContext(this), 'user_prefs')
        const registeredPhone = await userPreferences.get('registered_phone', '')
        if (registeredPhone.toString() !== '') {
          console.info('找到注册用户的手机号: ' + registeredPhone.toString())
        }
      } catch (error) {
        console.error('加载注册用户信息失败')
      }
    } catch (error) {
      console.error('加载重置密码失败')
    }
  }

  // 加载保存的凭据
  async loadSavedCredentials() {
    try {
      const loginPreferences = await dataPreferences.getPreferences(getContext(this), 'login_prefs')
      const rememberedUsername = await loginPreferences.get('username', '')
      const rememberedPassword = await loginPreferences.get('password', '')
      const isRemembered = await loginPreferences.get('rememberPassword', false)
      
      if (isRemembered) {
        this.username = rememberedUsername.toString()
        this.password = rememberedPassword.toString()
        this.rememberPassword = true
      }
    } catch (error) {
      console.error('加载保存的凭据失败')
    }
  }

  // 保存凭据
  async saveCredentials() {
    try {
      const loginPreferences = await dataPreferences.getPreferences(getContext(this), 'login_prefs')
      if (this.rememberPassword) {
        await loginPreferences.put('username', this.username)
        await loginPreferences.put('password', this.password)
      } else {
        await loginPreferences.put('username', '')
        await loginPreferences.put('password', '')
      }
      await loginPreferences.put('rememberPassword', this.rememberPassword)
      await loginPreferences.flush()
    } catch (error) {
      console.error('保存凭据失败')
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
          TextInput({ placeholder: '请输入用户名或手机号', text: this.username })
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
          TextInput({ placeholder: '请输入密码', text: this.password })
            .width('90%')
            .height(50)
            .margin({ bottom: 10 })
            .backgroundColor('#F5F5F5')
            .borderRadius(25)
            .padding({ left: 20, right: 20 })
            .placeholderColor('#999999')
            .fontSize(16)
            .type(InputType.Password)
            .onChange((value: string) => {
              this.password = value
            })
            
          // 记住密码选项
          Row() {
            Checkbox()
              .select(this.rememberPassword)
              .onChange((value: boolean) => {
                this.rememberPassword = value
              })
            Text('记住密码')
              .fontSize(14)
              .fontColor('#666666')
              .margin({ left: 5 })
              
            Blank()
            
            Text('忘记密码')
              .fontSize(14)
              .fontColor('#007DFF')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ResetPassword'
                })
              })
          }
          .width('90%')
          .margin({ bottom: 20 })

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
            
          // 注册选项
          Row() {
            Text('还没有账号？')
              .fontSize(14)
              .fontColor('#666666')
            Text('立即注册')
              .fontSize(14)
              .fontColor('#007DFF')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Register'
                })
              })
          }
          .margin({ top: 20 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        // 用户协议
        Text() {
          Span('登录即表示同意')
            .fontSize(12)
            .fontColor('#666666')
          Span('《用户协议》')
            .fontSize(12)
            .fontColor('#007DFF')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/Agreement'
              })
            })
          Span('和')
            .fontSize(12)
            .fontColor('#666666')
          Span('《隐私政策》')
            .fontSize(12)
            .fontColor('#007DFF')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/Agreement'
              })
            })
        }
        .margin({ top: 20 })
        .textAlign(TextAlign.Center)

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
                        router.replaceUrl({
                          url: 'pages/Index'
                        })
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
          action: () => {}
        }
      })
      return
    }
    
    // 验证用户名和密码
    let isValid = false;
    
    // 检查是否是重置后的账号密码 (优先检查)
    if (this.hasResetPassword && 
        (this.username === this.resetUsername || this.username === this.defaultUsername) && 
        this.password === this.resetPassword) {
      isValid = true;
      console.info('使用重置密码登录成功')
    } 
    // 只有在没有重置密码的情况下，才检查默认账号密码
    else if (!this.hasResetPassword && this.username === this.defaultUsername && this.password === this.defaultPassword) {
      isValid = true;
      console.info('使用默认账号密码登录成功')
    }
    // 对于手机号登录，要求必须使用最新重置的密码
    else if (this.username.length === 11 && /^\d+$/.test(this.username)) {
      // 如果是手机号登录，必须使用重置后的密码
      if (this.hasResetPassword && this.username === this.resetUsername && this.password === this.resetPassword) {
        isValid = true;
        console.info('使用手机号和重置密码登录成功')
      }
    }
    
    // 如果上述验证都未通过，尝试通过用户偏好存储验证用户名和密码
    if (!isValid) {
      this.verifyWithPreferences().then((valid: boolean) => {
        if (valid) {
          // 如果选择记住密码，保存凭据
          this.saveCredentials()
          
          // 跳转到首页
          router.replaceUrl({
            url: 'pages/Index'
          })
        } else {
          AlertDialog.show({
            title: '提示',
            message: '用户名或密码错误',
            confirm: {
              value: '确定',
              action: () => {}
            }
          })
        }
      }).catch(() => {
        // 简化错误处理，不使用错误参数
        AlertDialog.show({
          title: '提示',
          message: '登录验证失败，请重试',
          confirm: {
            value: '确定',
            action: () => {}
          }
        })
      })
      return
    }
    
    // 如果选择记住密码，保存凭据
    this.saveCredentials()
    
    // 直接跳转到首页
    router.replaceUrl({
      url: 'pages/Index'
    })
  }
  
  // 通过用户偏好存储验证用户名和密码
  async verifyWithPreferences(): Promise<boolean> {
    try {
      // 先检查重置密码记录
      const resetPreferences = await dataPreferences.getPreferences(getContext(this), 'reset_password_prefs')
      const storedUsername = await resetPreferences.get('username', '')
      const storedPassword = await resetPreferences.get('password', '')
      
      // 如果手机号和密码匹配，验证通过
      if (storedUsername.toString() === this.username && storedPassword.toString() === this.password) {
        console.info('通过重置密码验证成功')
        return true
      }
      
      // 尝试从注册信息中验证
      const userPreferences = await dataPreferences.getPreferences(getContext(this), 'user_prefs')
      const registeredPhone = await userPreferences.get('registered_phone', '')
      const registeredPassword = await userPreferences.get('registered_password', '')
      const registeredUsername = await userPreferences.get('registered_username', '')
      
      // 检查是否通过注册的手机号登录
      if (registeredPhone.toString() === this.username && registeredPassword.toString() === this.password) {
        console.info('通过注册手机号和密码验证成功')
        return true
      }
      
      // 检查是否通过注册的用户名登录
      if (registeredUsername.toString() === this.username && registeredPassword.toString() === this.password) {
        console.info('通过注册用户名和密码验证成功')
        return true
      }
      
      return false
    } catch (error) {
      console.error('验证用户名和密码异常')
      return false
    }
  }
}