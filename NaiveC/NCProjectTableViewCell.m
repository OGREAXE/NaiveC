//
//  NCProjectTableViewCell.m
//  NaiveC
//
//  Created by 梁志远 on 01/01/2018.
//  Copyright © 2018 Ogreaxe. All rights reserved.
//

#import "NCProjectTableViewCell.h"

@interface NCProjectTableViewCell()

@property (nonatomic) UIImageView * seperator;

@end

@implementation NCProjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView * seperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1)];
        seperator.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
        [self.contentView addSubview:seperator];
        self.seperator = seperator;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.seperator.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
