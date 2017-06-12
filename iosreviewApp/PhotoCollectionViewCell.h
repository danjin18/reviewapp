//
//  PhotoCollectionViewCell.h
//  flowerdelivery
//
//  Created by zhaochenghe on 9/2/16.
//  Copyright © 2016 jn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEF_PHOTO_COLLECTION_CELL_INDETIFIER          @"PhotoCollectionViewCell"
#define PHOTO_COLLECTION_VIEW_CELL_SCROLLVIEW_WIDTH          141.0f
#define PHOTO_COLLECTION_VIEW_CELL_SCROLLVIEW_HEIGHT         104.0f
#define PHOTO_COLLECTION_VIEW_CELL_SCROLLVIEW_OFFSET_X       2.0f

@interface PhotoCollectionViewCell : UICollectionViewCell
{    
    IBOutlet UIImageView *ivPhoto;
    __weak IBOutlet UILabel *ivTitle;
}

-(void)setPhoto:(NSString *)photoUrl;
-(void)setPhotoImage:(UIImage *)photoImage;
-(void)setName:(NSString *)name;

@end
