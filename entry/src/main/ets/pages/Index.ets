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
  $rawfile('Mercury.jpg'), $rawfile('Venus.jpg'), $rawfile('Earth.jpg'), $rawfile('Mars.png'),
  $rawfile('Jupiter.png'), $rawfile('Saturn.jpg'), $rawfile('Uranus.png'), $rawfile('Neptune.png')
]

@Entry
@Component
struct Index {
  @State indexList: Array<number> = shuffle([
    ...cardSources.map((_, i) => i),
    ...cardSources.map((_, i) => i)
  ])
  @State cardsFlipped: Array<boolean> = this.indexList.map(() => false)
  justClicked = NaN
  flippedCount = 0
  startTime = Date.now()
  clickCount: number = 0

  build() {
    RelativeContainer() {
      Scroll() {
        GridRow({ columns: 2 }) {
          ForEach(this.indexList, (sourceIndex: number, cardIndex) => {
            GridCol() {
              RelativeContainer() {
                Image(!this.cardsFlipped[cardIndex] ? $rawfile('QuestionMark.svg') :
                cardSources[sourceIndex])
                  .onClick(() => {
                    if (!this.cardsFlipped[cardIndex]) {
                      this.clickCount++
                      if (sourceIndex !== this.indexList[this.justClicked]) {
                        if (!isNaN(this.justClicked)) {
                          this.cardsFlipped[this.justClicked] = false
                        }
                        this.justClicked = cardIndex
                      } else {
                        this.justClicked = NaN
                        if (++this.flippedCount >= cardSources.length) {
                          this.getUIContext().showAlertDialog({
                            message: `航卡配对完成!\n用时${Date.now() - this.startTime}毫秒，点击${this.clickCount}次。`,
                            cancel: () => {
                              this.indexList = shuffle([
                                ...cardSources.map((_, i) => i),
                                ...cardSources.map((_, i) => i)
                              ])
                              this.cardsFlipped = this.indexList.map(() => false)
                              this.flippedCount = 0
                              this.startTime = Date.now()
                              this.clickCount = 0
                            }
                          })
                        }
                      }
                      this.cardsFlipped[cardIndex] = true
                    }
                  })
              }
            }.aspectRatio(1).padding(3)
          })
        }.padding(3)
      }
      .alignRules({ center: { anchor: '__container__', align: VerticalAlign.Center } })
    }
  }
}