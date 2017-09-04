//
//  DMRectangleViewController.m
//  DMOpenGLES1
//
//  Created by lbq on 2017/9/4.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import "DMRectangleViewController.h"

@interface DMRectangleViewController ()
{
    GLuint _vertexBufferID;//顶点缓存标识
}

@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@end


@implementation DMRectangleViewController

typedef struct {
    GLKVector3 positionCoords;//坐标系中的点
}
SceneVertex;

//在openGL ES中坐标原点位于平面中间 范围是(-1.,1.)
static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.f}},
    {{ 0.5f, -0.5f, 0.f}},
    {{ 0.5f,  0.5f, 0.f}},
    {{-0.5f,  0.5f, 0.f}}
};

- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(0.f, 0.f, 1.f, 1.f);
    
    glClearColor(1.f, 1.f, 1.f, 1.f);
    
    glGenBuffers(1, &_vertexBufferID);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
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
    glDrawArrays(GL_TRIANGLE_FAN,//告诉GPU如何处理在绑定的顶点缓存内的顶点数据
                 0,//需要渲染的第一个顶点的位置
                 4);//需要渲染顶点的个数
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
