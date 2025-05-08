import router from '@ohos.router';

@Entry
@Component
struct Agreement {
  @State currentDate: string = ''

  aboutToAppear() {
    // 获取当前时间并格式化为年月日
    const now = new Date();
    const year = now.getFullYear();
    const month = now.getMonth() + 1;
    const day = now.getDate();
    this.currentDate = `${year}年${month}月${day}日`;
  }

  build() {
    Stack() {
      // 白色背景
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#FFFFFF')

      // 内容区域
      Column() {
        // 顶部导航栏
        Row() {
          Image($r('app.media.2'))
            .width(24)
            .height(24)
            .onClick(() => {
              router.back()
            })
          Text('用户协议和隐私政策')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
          Blank()
        }
        .width('90%')
        .padding({ top: 16, bottom: 16 })

        // 协议内容
        Scroll() {
          Column() {
            Text('用户协议')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 20, bottom: 10 })
              .alignSelf(ItemAlign.Start)

            Text('欢迎您使用京西APP！\n\n' +
              '1. 协议的接受和修改\n' +
              '使用本服务前，请您务必仔细阅读并透彻理解本协议。如果您使用本服务，您将被视为已接受本协议。我们保留随时修改本协议的权利。\n\n' +
              '2. 服务内容\n' +
              '本应用主要提供电子商务购物服务，包括但不限于商品浏览、购买、支付、售后等。\n\n' +
              '3. 用户账户\n' +
              '您需要注册账户才能使用我们的完整服务。您对账户所有活动负全责，包括密码保管和隐私保护。\n\n' +
              '4. 用户行为规范\n' +
              '您承诺遵守所有适用的法律法规，不发布违法、侵权、不良信息。\n\n')
              .fontSize(16)
              .fontColor('#333333')
              .margin({ bottom: 20 })
              .textAlign(TextAlign.Start)

            Text('隐私政策')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 10, bottom: 10 })
              .alignSelf(ItemAlign.Start)

            Text('我们重视您的隐私保护，依法收集、使用、存储和共享您的个人信息。\n\n' +
              '1. 信息收集\n' +
              '我们可能收集您的个人资料（如姓名、电话、地址）、设备信息、位置信息等以提供服务。\n\n' +
              '2. 信息使用\n' +
              '我们使用您的信息来提供、维护和改进服务，以及进行身份验证、客户服务等。\n\n' +
              '3. 信息保护\n' +
              '我们采取严格的安全措施保护您的个人信息，防止信息泄露、损毁和丢失。\n\n' +
              '4. 第三方共享\n' +
              '未经您同意，我们不会向第三方提供您的个人信息，法律法规另有规定的除外。\n\n' +
              '5. 用户权利\n' +
              '您有权访问、更正、删除您的个人信息，以及撤回您的授权同意。\n\n')
              .fontSize(16)
              .fontColor('#333333')
              .margin({ bottom: 20 })
              .textAlign(TextAlign.Start)
              
            // 协议更新日期
            Text(`更新日期：${this.currentDate}`)
              .fontSize(14)
              .fontColor('#999999')
              .margin({ top: 10, bottom: 30 })
          }
          .width('90%')
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .padding({ top: 50 })
    }
    .width('100%')
    .height('100%')
  }
} 