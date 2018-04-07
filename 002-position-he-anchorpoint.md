### position 和anchorPoint

- CALayer 有2个非常重要的属性position 和 anchorPoint
    - postion 用来设置CALayer在父层中的位置，以父层的左上角为原点（0，0）。
    - anchorPoint 称为**锚点、定位点** 决定者CALayer 身上那个点会在position指定的位置，anchorPoint 以自己的左上角为原点（0，0）。