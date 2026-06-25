const shuffle = <T>(array: Array<T>) => {
  for (let i = array.length - 1; i >= 1; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    let t = array[j]
    array[j] = array[i]
    array[i] = t
  }
  return array
}

const cardSources = [
  $rawfile('Sun.jpg'), $rawfile('Mercury.jpg'), $rawfile('Venus.jpg'), $rawfile('Earth.jpg'), $rawfile('Mars.png'),
  $rawfile('Jupiter.png'), $rawfile('Saturn.jpg'), $rawfile('Uranus.png'), $rawfile('Neptune.png'), $rawfile('Moon.jpg')
]

@Entry
@Component
struct Index {
  // ========== 响应式状态（直接驱动UI渲染） ==========
  @State indexList: Array<number> = [];
  @State cardsFlipped: Array<boolean> = []
  @State flippedCount: number = NaN
  @State clickCount: number = NaN
  // ========== 纯逻辑变量（不直接绑定UI） ==========
  private justClicked: number = NaN
  private startTime: number = NaN
  private isLocked: boolean = false

  onPageShow() {
    this.resetGame()
  }

  // ========== 私有方法 ==========
  /** 初始化洗牌后的卡牌索引数组 */
  private initIndexList(): Array<number> {
    const a = cardSources.map((_, i) => i)
    return shuffle([...a, ...a])
  }

  /** 重置游戏全部状态 */
  private resetGame(): void {
    this.indexList = this.initIndexList()
    this.cardsFlipped = this.indexList.map(() => false)
    this.justClicked = NaN
    this.flippedCount = 0
    this.startTime = Date.now()
    this.clickCount = 0
    this.isLocked = false
  }

  /** 处理卡牌点击核心逻辑 */
  private handleCardClick(sourceIndex: number, cardIndex: number): void {
    // 锁定中或卡牌已翻开，直接忽略点击
    if (this.isLocked || this.cardsFlipped[cardIndex]) {
      return
    }

    this.clickCount++
    // 先翻开当前卡牌
    this.cardsFlipped[cardIndex] = true

    // 第一张牌：记录索引，直接结束
    if (isNaN(this.justClicked)) {
      this.justClicked = cardIndex
      return
    }

    // 第二张牌：进入配对判断，先锁定点击
    this.isLocked = true

    if (sourceIndex === this.indexList[this.justClicked]) {
      // 配对成功
      this.flippedCount++
      this.justClicked = NaN
      this.isLocked = false

      // 全部配对完成，弹出结算弹窗
      if (this.flippedCount >= cardSources.length) {
        const costTime = Date.now() - this.startTime
        this.getUIContext().showAlertDialog({
          title: '挑战成功',
          message: `航卡配对完成！\n用时：${costTime} 毫秒\n点击次数：${this.clickCount} 次`,
          primaryButton: {
            value: '再来一局',
            action: () => this.resetGame()
          },
          secondaryButton: {
            value: '关闭',
            action: () => {
            }
          }
        })
      }
    } else {
      // 配对失败：停留800ms后共同翻回
      setTimeout(() => {
        this.cardsFlipped[this.justClicked] = false
        this.cardsFlipped[cardIndex] = false
        this.justClicked = NaN
        this.isLocked = false
      }, 800)
    }
  }

  // ========== UI构建 ==========
  build() {
    Column() {
      // 顶部状态栏
      Row() {
        Text(`配对进度：${this.flippedCount}/${cardSources.length}`)
          .fontSize(14)
          .fontColor('#333333')
        Blank()
        Text(`点击次数：${this.clickCount}`)
          .fontSize(14)
          .fontColor('#333333')
      }
      .width('90%')
      .padding({ top: 12, bottom: 8 })

      // 卡牌滚动区域
      Scroll() {
        GridRow({ columns: 3 }) {
          ForEach(this.indexList, (sourceIndex: number, cardIndex: number) => {
            GridCol() {
              Image(!this.cardsFlipped[cardIndex] ? $rawfile('QuestionMark.svg') : cardSources[sourceIndex])
                .width('100%')
                .aspectRatio(1)
                .borderRadius(8)
                .objectFit(ImageFit.Cover)
                .shadow({
                  radius: 4,
                  color: 'rgba(0,0,0,0.1)',
                  offsetX: 0,
                  offsetY: 2
                })
                .onClick(() => {
                  this.handleCardClick(sourceIndex, cardIndex)
                })
            }
            .padding(3)
          })
        }
        .width('90%')
        .padding(3)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}