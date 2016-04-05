# TagEditor
一款轻量级标签编辑器，支持空格、换行分隔，自动适配容器尺寸，快速删除等。

## 使用
标签编辑器使用相当简单，可以通过tag属性直接设置默认值，通过placeholder设置输入提示，通过tagChangeHandler监听标签输入变化。下面是一段简单的使用示例:

```swift
class ViewController: UIViewController {
    // MARK: - 生命周期及覆盖方法、属性
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "标签编辑器"
        self.view.addSubview(self.tagScrollView)
        self.view.addSubview(self.descriptionLabel)
        // 设置默认标签 self.tagScrollView.tags = ["风光","花卉"]
    }

    // MARK: - 私有属性
    private lazy var tagScrollView:KCTagScrollView = {
        let temp = KCTagScrollView(frame:CGRect(x: 8.0, y: 16.0, width: self.view.width - 16.0, height: 200.0))
        temp.placeholder = "输入空格或者换行分隔"
        temp.tagChangeHandler = {
            [unowned self] tagScrollView in
            self.descriptionLabel.text = tagScrollView.tags.joinWithSeparator(",")
        }
        return temp
    }()
    
    private lazy var descriptionLabel:UILabel = {
        let temp = UILabel(frame:CGRect(x: 8.0, y: CGRectGetMaxY(self.tagScrollView.frame) + 16.0, width: self.tagScrollView.width, height: 200.0))
        temp.numberOfLines = 0
        temp.textColor = UIColor(hexValue: 0x2385f1)
        temp.fontSize = 15.0
        return temp
    }()   
}
```

## 演示

![](https://raw.githubusercontent.com/kenshincui/TagEditor/master/TagEditor.gif)

## 博客
欢迎访问本人博客：[Kenshin Cui's Blog](http://www.cnblogs.com/kenshincui/)

