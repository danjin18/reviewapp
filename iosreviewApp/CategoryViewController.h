//
//  CategoryViewController.h
//  iosreviewApp
//
//  Created by star on 5/21/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "categoryModel.h"

@interface CategoryViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *category;

@property (nonatomic, retain) categoryModel *categoryModel;


@end
