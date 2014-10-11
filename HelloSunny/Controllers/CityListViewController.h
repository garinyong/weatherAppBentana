//
//  CityListViewController.h
//  HelloSunny
//
//  Created by fan on 14-10-5.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^citySelectBlock)(NSString * sno,NSString * sname);

@interface CityListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>
{
    NSDictionary *cityData;
    NSArray *keyArr;
    NSMutableArray *seachResultArr;
}
@property (weak, nonatomic) IBOutlet UISearchBar *keywordsSearchBar;

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (weak, nonatomic) IBOutlet UISearchBar *curSeachBar;

@property (copy,nonatomic) citySelectBlock citySelect;

@end
