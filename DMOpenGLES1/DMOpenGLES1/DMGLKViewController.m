//
//  DMGLKViewController.m
//  DMOpenGLES1
//
//  Created by lbq on 2017/9/2.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import "DMGLKViewController.h"

@interface DMGLKViewController ()

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, assign) GLuint vertexBufferID;

@end

@implementation DMGLKViewController

typedef struct {
    GLKVector3 positionCoords;//坐标系中的点
}
SceneVertex;

//在openGL ES中坐标原点位于平面中间 范围是(-1.,1.)
static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.f}},
    {{ 0.5f, -0.5f, 0.f}},
    {{-0.5f,  0.5f, 0.f}}
};


- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
                                                   1.f,//Red
                                                   1.f,//Green
                                                   1.f,//Blue
                                                   1.f);//Alpha
    glClearColor(0, 0, 0, 1.f);
    
    //第一步： 为缓存生成标识
    glGenBuffers(1,//生成缓存标识的数量
                 &_vertexBufferID);//存放生成缓存标识的变量
    
    //第二步：绑定缓存
    glBindBuffer(GL_ARRAY_BUFFER,//指定要绑定的缓存类型 GL_ARRAY_BUFFER 用于指定一个顶点属性数组
                 _vertexBufferID);
    
    //第三步：复制数据到缓存 复制应用的顶点数据到当前上下文所绑定的顶点缓存中
    glBufferData(GL_ARRAY_BUFFER,//指定要更新当前上下文中所绑定的哪一个缓存
                 sizeof(vertices),//要复制进这个缓存的字节数
                 vertices,//要复制的字节的地址
                 GL_STATIC_DRAW);//提示了缓存在未来的运算中可能会被怎样使用，GL_STATIC_DRAW 缓存中内容适合复制到GPU控制的内存 GL_DYNAMIC_DRAW 缓存中的数据会被频繁改变
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    glClear(GL_COLOR_BUFFER_BIT);
    
    //第四步：启动 启动顶点缓存渲染操作
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    //第五步：设置指针
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,//指示每个位置有三个部分
                          GL_FLOAT,//每个部分都保存为一个浮点类型的值
                          GL_FALSE,//小数点后固定数据是否可以被改变
                          sizeof(SceneVertex),//步幅 每个顶点的保存需要多少个字节
                          NULL);
    
    //第六步：绘图
    glDrawArrays(GL_TRIANGLES,//告诉GPU如何处理在绑定的顶点缓存内的顶点数据
                 0,//需要渲染的第一个顶点的位置
                 3);//需要渲染顶点的个数
    
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
