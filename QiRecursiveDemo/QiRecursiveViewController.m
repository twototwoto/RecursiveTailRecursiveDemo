//
//  QiRecursiveViewController.m
//  QiRecursiveDemo
//
//  Created by QiShare on 2018/8/22.
//  Copyright © 2018年 QiShare. All rights reserved.
//

#import "QiRecursiveViewController.h"

#define WWLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

static NSUInteger kCollapseValue = 180000; //!< 崩溃测试值
static NSUInteger kMaxNum = 1000000;    //!< 较大数

@implementation QiRecursiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Fibonacci sequence
    NSUInteger num = [self FibonacciSequenceNum:7];
    NSLog(@"num = %lu",(unsigned long)num);
    
    // 等差数列求和
    NSUInteger sum = [self recursiveSumOfArithmeticPropgressionNum:7];
    NSLog(@"sum= %lu",(unsigned long)sum);
    
    [self setupUI];
}

#pragma mark - Private functions

- (void)setupUI {
    
    NSString *titleStr = @"Debug 递归尾递归 首项1公差1等差数列和";
#if !DEBUG
    titleStr = @"Release 递归尾递归 首项1公差1等差数列和";
#endif
    self.title = titleStr;
    NSArray *titleArr = @[@"一、\nDebug模式\n1 - 15 0000\n普通递归求和\n不崩溃",
                          @"二、\nDebug模式\n1 - 15 0000\n尾递归求和\n崩溃",
                          @"二、\nDebug模式\n1 - 10 0000\n尾递归求和\n不崩溃",
                          @"三、\nDebug模式\n1 - 18 0000\n普通递归求和\n崩溃",
                          @"四、\nDebug模式\n1 - 18 0000\n尾递归求和\n崩溃",
                          @"五、\nRelease模式\n1 - 18 0000\n普通递归求和\n不崩溃",
                          @"六、\nRelease模式\n1 - 18 0000\n尾递归求和\n不崩溃",
                          @"七、\nRelease模式\n1-100 0000\n普通递归求和\n崩溃",
                          @"八、\nRelease模式\n1-100 0000\n尾递归求和\n不崩溃"];
    
    CGFloat screenW = CGRectGetWidth(self.view.frame);
    CGFloat screenH = CGRectGetHeight(self.view.frame);
    
    CGFloat btnTopMargin = 20.0;
    CGFloat btnW = screenW;
    CGFloat btnH = .0;
    
    if (screenW == 375.0 && screenH == 812.0) {
        btnH = (screenH - 88.0 - 34.0 - btnTopMargin * (titleArr.count)) / titleArr.count;
    } else {
        btnH = ((screenH - 64.0) - btnTopMargin * (titleArr.count)) / titleArr.count;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton new];
        btn.titleLabel.font = [UIFont systemFontOfSize:9.0];
        [self.view addSubview:btn];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.numberOfLines = 0;
        btn.frame = CGRectMake(.0, btnH * i + btnTopMargin * (i + 1), btnW, btnH);
        btn.backgroundColor = [UIColor grayColor];
        // 是否要考虑RGB不同配色为了便于区分
        switch (i) {
            case 0:
            case 3:
            case 5:
            case 7:
                btn.backgroundColor = [UIColor darkGrayColor];
                break;
        }
        btn.tag = i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 斐波那契数列

- (NSUInteger)FibonacciSequenceNum:(NSUInteger)num {
    
    // 0 1 1 2 3 5 8 13
    if (num < 2) {
        return num;
    }
    return [self FibonacciSequenceNum:(num - 1)] + [self FibonacciSequenceNum:(num - 2)];
}

#pragma mark - 递归方式等差数列求和


/**
 普通递归方法求首项为1公差为1的等差数列的和

 @param num 前num项的等差数列
 @return 返回等差数列前num项的和
 */
- (NSUInteger)recursiveSumOfArithmeticPropgressionNum:(NSUInteger)num {

    // 1  2  3  4   5   6   7
    // 1  3  6  10  15  21  28
    if (num < 2) {
        return num;
    }
    return [self recursiveSumOfArithmeticPropgressionNum:(num - 1)] + num;
}

#pragma mark - 尾递归方式等差数列求和

/**
 尾递归的方式求首项为1公差为1的等差数列的和

 @param num 前num项
 @return 返回等差数列前num项的和
 */
- (NSInteger)tailRecursiveSumOfArithmeticProgressionNum:(NSInteger)num {
    
    return [self tailRecurisveNum:num current:0];
}

- (NSInteger)tailRecurisveNum:(NSInteger)num current:(NSInteger)current {
    
    if (num == 0) {
        return current;
    } else {
        return [self tailRecurisveNum:(num - 1) current: (num + current)];
    }
}

#pragma mark - Action functions

- (void)buttonClicked:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:
            {
                NSUInteger sum = [self recursiveSumOfArithmeticPropgressionNum:(kCollapseValue - 30000)];
                WWLog(@"sum = %lu",(unsigned long)sum);
                break;
            }
        case 1:
            {
                NSUInteger sum = [self tailRecursiveSumOfArithmeticProgressionNum:(kCollapseValue - 30000)];
                WWLog(@"sum = %lu",(unsigned long)sum);
                break;
            }
        case 2:
        {
            NSUInteger sum = [self tailRecursiveSumOfArithmeticProgressionNum:(kCollapseValue - 50000)];
            WWLog(@"sum = %lu",(unsigned long)sum);
            break;
        }
        case 3:
        {
            NSUInteger sum = [self recursiveSumOfArithmeticPropgressionNum:kCollapseValue];
            WWLog(@"sum = %lu",(unsigned long)sum);
            break;
        }
        case 4:
            {
                NSUInteger sum = [self tailRecursiveSumOfArithmeticProgressionNum:kCollapseValue];
                WWLog(@"sum = %lu",(unsigned long)sum);
                break;
            }
        case 5:
        {
            NSUInteger sum = [self recursiveSumOfArithmeticPropgressionNum:kCollapseValue];
            WWLog(@"sum = %lu",(unsigned long)sum);
            break;
        }
        case 6:
        {
            NSUInteger sum = [self tailRecursiveSumOfArithmeticProgressionNum:kCollapseValue];
            WWLog(@"sum = %lu",(unsigned long)sum);
            break;
        }
        case 7:
        {
            NSUInteger sum = [self recursiveSumOfArithmeticPropgressionNum:kMaxNum];
            WWLog(@"sum = %lu",(unsigned long)sum);
            break;
        }
        case 8:
        {
            NSUInteger sum = [self tailRecursiveSumOfArithmeticProgressionNum:kMaxNum];
            WWLog(@"sum = %lu",(unsigned long)sum);
            break;
        }
    }
}

- (void)readMe {
    /**
     * 通过对比 一二三 ：
        * 普通递归可以求出 1- 15 0000的和，但是 尾递归 在求1- 150000 的和时候会崩溃
        * 我们可以得出 在Debug模式下 尾递归 效果并不如 普通递归的性能好 并且要差
     * 通过对比 五六七八：
        * 我们可以得出 在Release模式下 尾递归很有优势 系统会对尾递归做优化
     */
}
@end
