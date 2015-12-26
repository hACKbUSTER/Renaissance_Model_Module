//
//  ViewController.m
//  SecneKitDemo
//
//  Created by Fincher Justin on 15/12/26.
//  Copyright © 2015年 Fincher Justin. All rights reserved.
//
//1:24s
#import "ViewController.h"
@import SceneKit;

@interface ViewController ()

@property (nonatomic,strong) SCNView *sceneKitView;
@property (nonatomic,strong) SCNScene *sceneKitScene;
@property (nonatomic,strong) NSMutableArray *allNodeArray;
@property (nonatomic,strong) NSTimer * timer;

@property (nonatomic) int nodeCount;


@end

@implementation ViewController
@synthesize sceneKitView,sceneKitScene;
@synthesize allNodeArray,nodeCount,timer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    sceneKitView = [[SCNView alloc] initWithFrame:self.view.bounds];
    sceneKitScene = [SCNScene scene];
    sceneKitView.allowsCameraControl = YES;
    sceneKitView.scene = sceneKitScene;
    [self.view addSubview:sceneKitView];
    sceneKitView.autoenablesDefaultLighting = YES;
    //sceneKitScene.
    sceneKitView.showsStatistics = YES;
    
    SCNGeometry *PlaneGeometry = [SCNPlane planeWithWidth:2000 height:2000];
    SCNNode * PlaneNode = [SCNNode nodeWithGeometry:PlaneGeometry];
    
    [sceneKitScene.rootNode addChildNode:PlaneNode];
    allNodeArray = [NSMutableArray array];
    for (int i = 0; i < 100; i++)
    {
        NSMutableArray *nodeArray = [NSMutableArray array];
        for (int k = 0; k < 10; k ++)
        {
            //NSLog(@"NUMBER %d",i);
            SCNBox *sceneKitBox = [SCNBox boxWithWidth:15 height:15 length:(arc4random()%50 + 10) chamferRadius:1];
            SCNNode *boxNode = [SCNNode nodeWithGeometry:sceneKitBox];
            boxNode.position = SCNVector3Make((i-50)*20, (-300.0 + arc4random()%600), -sceneKitBox.length/2);
            [PlaneNode addChildNode:boxNode];
            [nodeArray addObject:boxNode];
        }
        [allNodeArray addObject:nodeArray];
    }
    
    nodeCount = 0;
    timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(buildingLevelUp) userInfo:nil repeats:YES];
    

}

- (void)buildingLevelUp
{
    if (nodeCount == allNodeArray.count)
    {
        [timer invalidate];
        nodeCount = 0;
    }else
    {
        NSMutableArray *nodeArray = [allNodeArray objectAtIndex:nodeCount];
        NSLog(@"%lu",(unsigned long)nodeArray.count);
        for (SCNNode * node in nodeArray)
        {
            
            SCNVector3 SCNPosition = node.position;
            SCNVector3 NewSCNPosition = SCNVector3Make(SCNPosition.x, SCNPosition.y, -SCNPosition.z);

            [CATransaction begin];
            CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.z"];
            positionAnimation.toValue = [NSNumber numberWithDouble:-SCNPosition.z];
            positionAnimation.duration = 1.0;
            positionAnimation.removedOnCompletion = NO;
            positionAnimation.autoreverses = NO;
            positionAnimation.repeatCount = 1;
            positionAnimation.fillMode = kCAFillModeForwards;
            [CATransaction setCompletionBlock:^
            {
                //node.position = NewSCNPosition;
            }];
            [node addAnimation:positionAnimation forKey:@"position.z"];
            [CATransaction commit];
        }
        nodeCount ++;
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
