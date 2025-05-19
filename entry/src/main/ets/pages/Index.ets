import router from '@ohos.router';

interface CategoryItem {
  icon: Resource;
  label: string;
}

interface RecommendItem {
  img: Resource;
  imgName: string;
  text: string;
}

@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  @State categoryPageIndex: number = 0;
  @State selectedTab: number = 0;
  private swiperController: SwiperController = new SwiperController();
  private carouselImages: Resource[] = [
    $r('app.media.banner1'),
    $r('app.media.banner2'),
    $r('app.media.banner3'),
    $r('app.media.banner4'),
    $r('app.media.banner5')
  ];
  private timer: number = 0;
  private categoryPages: CategoryItem[][] = [
    [
      { icon: $r('app.media.iconFlashSale'), label: '秒杀' } as CategoryItem,
      { icon: $r('app.media.iconFarm'), label: '西西农场' } as CategoryItem,
      { icon: $r('app.media.iconSign'), label: '签到' } as CategoryItem,
      { icon: $r('app.media.iconGroup'), label: '万人团' } as CategoryItem,
      { icon: $r('app.media.iconNew'), label: '新品' } as CategoryItem,
      { icon: $r('app.media.iconCoupon'), label: '优惠券' } as CategoryItem,
      { icon: $r('app.media.iconSupermarket'), label: '京西超市' } as CategoryItem,
      { icon: $r('app.media.iconDigital'), label: '数码电器' } as CategoryItem,
      { icon: $r('app.media.iconBeauty'), label: '服饰美妆' } as CategoryItem,
      { icon: $r('app.media.iconFresh'), label: '京东生鲜' } as CategoryItem
    ],
    [
      { icon: $r('app.media.iconHome'), label: '家居家装' } as CategoryItem,
      { icon: $r('app.media.iconBaby'), label: '母婴童装' } as CategoryItem,
      { icon: $r('app.media.iconRecharge'), label: '优惠充值' } as CategoryItem,
      { icon: $r('app.media.iconTry'), label: '1元试用' } as CategoryItem,
      { icon: $r('app.media.iconTicket'), label: '领券' } as CategoryItem,
      { icon: $r('app.media.iconMedicine'), label: '看病买药' } as CategoryItem,
      { icon: $r('app.media.iconPhone'), label: '京东手机' } as CategoryItem,
      { icon: $r('app.media.iconSecondHand'), label: '拍二手' } as CategoryItem,
      { icon: $r('app.media.iconPlus'), label: 'PLUS会员' } as CategoryItem,
      { icon: $r('app.media.iconRecycle'), label: '爱回收' } as CategoryItem
    ]
  ];
  // 精选推荐数据
  private recommendList: RecommendItem[] = [];

  aboutToAppear() {
    this.startCarousel();
    // 生成30条推荐数据
    if (this.recommendList.length === 0) {
      const words = ['美好生活', '精选好物', '限时抢购', '热卖爆款', '品质优选', '人气推荐', '新品上市', '超值特惠', '限量秒杀', '热销单品', '爆款直降', '品牌精选', '优质好货', '热卖推荐', '限时优惠', '新品推荐', '热销推荐', '人气好物', '超值爆款', '限量抢购', '热卖新品', '精选爆款', '优选好物', '热销优选', '限时特惠', '新品热卖', '爆款推荐', '品牌热卖', '优选推荐', '热销好物'];
      for (let i = 0; i < 30; i++) {
        this.recommendList.push({
          img: $r('app.media.banner'),
          imgName: 'banner',
          text: words[Math.floor(Math.random() * words.length)].slice(0, Math.floor(Math.random() * 10) + 1)
        });
      }
    }
  }
  aboutToDisappear() {
    clearInterval(this.timer);
  }
  startCarousel() {
    this.timer = setInterval(() => {
      this.currentIndex = (this.currentIndex + 1) % this.carouselImages.length;
    }, 2000);
  }

  @Builder
  HeaderSection() {
    Column() {
      // 顶部头部栏
      Row() {
        Image($r('app.media.logoIcon'))
          .width(28)
          .height(28)
          .margin({ left: 16, right: 8 })
        TextInput({ placeholder: '搜索商品/商铺' })
          .placeholderColor('#999999')
          .fontSize(18)
          .margin({ right: 10 })
          .backgroundColor('#F0F0F0')
          .width('70%')
          .height(36)
          .borderRadius(18)
        Image($r('app.media.toRightIcon'))
          .width(24)
          .height(24)
          .margin({ right: 20 })
      }
      .height(56)
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .backgroundColor('#F5F6FA')

      // 头部下方轮播图
      Stack() {
        Image(this.carouselImages[this.currentIndex])
          .width('96%')
          .height(120)
          .borderRadius(16)
          .margin({ top: 12, bottom: 8 })
          .objectFit(ImageFit.Cover)
          .alignSelf(ItemAlign.Center)
        Row() {
          ForEach(this.carouselImages, (item: Resource, idx: number) => {
            Blank()
              .width(8)
              .height(8)
              .borderRadius(4)
              .backgroundColor(this.currentIndex === idx ? '#FF2D2D' : '#FFFFFF')
              .margin({ left: 8, right: 2 })
              .opacity(this.currentIndex === idx ? 1 : 0.6)
          })
        }
        .alignSelf(ItemAlign.Center)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 0, left: 130 })
        .position({ y: 120 - 0 })
      }
      .width('100%')

      // 分类宫格横向滑动模块
      Column() {
        Swiper(this.swiperController) {
          ForEach(this.categoryPages, (page: CategoryItem[], pageIdx: number) => {
            Grid() {
              ForEach(page, (item: CategoryItem, idx: number) => {
                GridItem() {
                  Column() {
                    Image(item.icon)
                      .width(44)
                      .height(44)
                      .borderRadius(22)
                      .backgroundColor('#FFFFFF')
                    Text(item.label)
                      .fontSize(12)
                      .fontColor('#333333')
                      .margin({ top: 4 })
                  }
                  .width('100%')
                  .alignItems(HorizontalAlign.Center)
                  .margin({ top: 8, bottom: 8 })
                }
              })
            }
            .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
            .width('100%')
            .height(150)
          })
        }
        .onChange((idx: number) => {
          this.categoryPageIndex = idx
        })
        .width('100%')
        .height(170)
        .backgroundColor('#F7F7F7')
      }
    }
    .width('100%')
    .backgroundColor('#F5F6FA')
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        // 固定部分：头部、轮播图、分类
        this.HeaderSection()

        // 可滚动部分：精选推荐
        Scroll() {
          Column() {
            Text('精选推荐')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#222')
              .margin({ top: 12, left: 16, bottom: 16 })
              .height(36)
              .alignSelf(ItemAlign.Center)
            List() {
              ForEach(this.recommendList, (item: RecommendItem, idx: number) => {
                if (idx % 2 === 0) {
                  ListItem() {
                    Row() {
                      Column() {
                        Image(item.img)
                          .width('92%')
                          .aspectRatio(1.7)
                          .borderRadius(12)
                          .margin({ bottom: 8 })
                          .objectFit(ImageFit.Cover)
                        Text(item.text)
                          .fontSize(14)
                          .fontColor('#888')
                          .maxLines(1)
                          .margin({ bottom: 16, left: 8 })
                      }
                      .width('46%')
                      .margin({ left: 8, right: 4, bottom: 18 })
                      .backgroundColor('#fff')
                      .borderRadius(14)
                      .onClick(() => {
                        router.pushUrl({
                          url: 'pages/Detail',
                          params: {}
                        }).catch((err: Error) => {
                          console.error(`跳转失败: ${err.message}`);
                        });
                      })
                      if (idx + 1 < this.recommendList.length) {
                        Column() {
                          Image(this.recommendList[idx + 1].img)
                            .width('92%')
                            .aspectRatio(1.7)
                            .borderRadius(12)
                            .margin({ bottom: 8 })
                            .objectFit(ImageFit.Cover)
                          Text(this.recommendList[idx + 1].text)
                            .fontSize(14)
                            .fontColor('#888')
                            .maxLines(1)
                            .margin({ bottom: 16, left: 8 })
                        }
                        .width('46%')
                        .margin({ left: 4, right: 8, bottom: 18 })
                        .backgroundColor('#fff')
                        .borderRadius(14)
                        .onClick(() => {
                          router.pushUrl({
                            url: 'pages/Detail',
                            params: {}
                          }).catch((err: Error) => {
                            console.error(`跳转失败: ${err.message}`);
                          });
                        })
                      } else {
                        Blank().width('46%')
                      }
                    }
                  }
                }
              })
            }
            .width('100%')
            .margin({ bottom: 24 })
          }
          .width('100%')
          .backgroundColor('#F5F6FA')
        }
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .width('100%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')

      // Tab Bar
      Row() {
        ForEach(['首页', '信息', '购物车', '我的'], (item: string, index: number) => {
          Column() {
            Text(item)
              .fontSize(14)
              .fontColor(this.selectedTab === index ? '#FF2D2D' : '#666666')
              .height(48)
              .onClick(() => {
                this.selectedTab = index;
              })
          }
          .width('25%')
          .height(48)
          .justifyContent(FlexAlign.Center)
        })
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .position({ y: '100%' })
      .translate({ y: -48 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6FA')
  }
}