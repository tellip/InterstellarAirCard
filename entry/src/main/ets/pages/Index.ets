import { AbilityConstant, Want } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.log('-----------------------------')
  }

  static shuffle: Function = <T>(array: Array<T>): void => {
    for (let i = array.length - 1; i >= 1; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      let t = array[j]
      array[j] = array[i]
      array[i] = t
    }
  }
  card?: Card

  build() {
    RelativeContainer() {
      Scroll() {
        GridRow({
          columns: {
            xs: 1,
            sm: 2,
            md: 4,
            lg: 8,
            xl: 8,
            xxl: 8
          }
        }) {
          GridCol() {
            Image($rawfile('Earth.jpg'))
          }.aspectRatio(1).padding(3)

          GridCol() {
            Image($rawfile('Saturn.jpg')).onClick(() => {
              console.log('--------------------')
              if (this.card) {
                this.card.src = $rawfile('Earth.jpg')
              }
            })
          }.aspectRatio(1).padding(3)

          GridCol() {
            Card({ src: $rawfile('Saturn.jpg'), ref: (el: Card) => this.card = el })
              .onClick(() => console.log('--------------------'))
          }.aspectRatio(1).padding(3)

          GridCol() {
            Image($rawfile('Icon-round-Question_mark.svg'))
          }.aspectRatio(1).padding(3)
        }.padding(3)
      }
      .alignRules({ center: { anchor: '__container__', align: VerticalAlign.Center } }) /*.backgroundColor(Color.Blue)*/
    } /*.backgroundColor(Color.Green)*/
  }
}

@Component
struct Card {
  ref = (cb: Function): void => cb(this);
  @State src: Resource = $rawfile('Icon-round-Question_mark.svg');

  build() {
    Image(this.src)
  }
}