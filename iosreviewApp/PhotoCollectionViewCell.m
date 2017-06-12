//
//  PhotoCollectionViewCell.m
//  flowerdelivery
//
//  Created by zhaochenghe on 9/2/16.
//  Copyright © 2016 jn. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setPhoto:(NSString *)photoUrl
{
    ivPhoto.image = nil;
    NSURL *url = [NSURL URLWithString:photoUrl];
    [ivPhoto setImageWithURL:url];
}

-(void)setPhotoImage:(UIImage *)photoImage
{
    ivPhoto.image = photoImage;
}

-(void)setName:(NSString *)name
{
    ivTitle.text = name;
}
@end
