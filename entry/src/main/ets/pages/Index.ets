import { image } from '@kit.ImageKit';
import colorEffects from '../lib/ColorEffects';
import { effectKit } from '@kit.ArkGraphics2D';

@Entry
@Component
struct Index {
  @State pixelMap: image.PixelMap | undefined = undefined;
  @State pixelMapOriginal: image.PixelMap | undefined = undefined;
  @State activeFilter: string = 'none';

  async aboutToAppear() {
    const imagefile = await this.getUIContext()?.getHostContext()?.resourceManager.getRawFd('cat.jpg');
    const imageSource: image.ImageSource = image.createImageSource(imagefile);
    let decodingOptions: image.DecodingOptions = {
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
    };

    this.pixelMap = await imageSource.createPixelMap(decodingOptions);
    this.pixelMapOriginal = this.pixelMap.cloneSync();
  }

  async applyFilter(filterType: string) {
    this.pixelMap =
      await effectKit.createEffect(this.pixelMapOriginal)
        .setColorMatrix(colorEffects[filterType]).getEffectPixelMap();
    this.activeFilter = filterType;
  }

  build() {
    Column({ space: 8 }) {
      Row({ space: 4 }) {
        ForEach(Object.keys(colorEffects).slice(0, 3), (item: string) => {
          Button(item.toUpperCase())
            .height(24)
            .backgroundColor(this.activeFilter === item ? '#007AFF' : '#f0f0f0')
            .fontColor(this.activeFilter === item ? '#ffffff' : '#333')
            .fontSize(9)
            .fontWeight(FontWeight.Bold)
            .borderRadius(6)
            .padding(4)
            .width(56)
            .onClick(() => this.applyFilter(item))
        })
      }

      Image(this.pixelMap).width(176).height(80).borderRadius(8)

      Row({ space: 4 }) {
        ForEach(Object.keys(colorEffects).slice(3), (item: string) => {
          Button(item.toUpperCase())
            .height(24)
            .backgroundColor(this.activeFilter === item ? '#007AFF' : '#f0f0f0')
            .fontColor(this.activeFilter === item ? '#ffffff' : '#333')
            .fontSize(9)
            .fontWeight(FontWeight.Bold)
            .borderRadius(6)
            .padding(4)
            .width(56)
            .onClick(() => this.applyFilter(item))
        })
      }
    }
    .align(Alignment.Center)
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }
}