//
//  CityListViewController.m
//  HelloSunny
//
//  Created by fan on 14-10-5.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "CityListViewController.h"

@interface CityListViewController ()

@end

@implementation CityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"citycode" ofType:@"plist"];
    cityData = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    keyArr =  [cityData.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSString *a = obj1;
        NSString *b = obj2;
        
        return [a localizedCompare:b];
        
    }];
    
    seachResultArr = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_contentTableView == tableView)
        return keyArr.count;
    else
        return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == _contentTableView)
        return 20;
    else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == _contentTableView)
    {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        sectionView.backgroundColor = RGBA(236, 236, 236, 1);
        
        UILabel *zimuLable = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, self.view.bounds.size.width - 18, 20)];
        zimuLable.text =  [keyArr objectAtIndex:section];
        [sectionView addSubview:zimuLable];
        
        return sectionView;
    }
    else
    {
        return [UIView new];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == _contentTableView)
        return keyArr;
    else
        return [NSArray array];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _contentTableView)
    {
        NSString *keyString = [keyArr safeObjectAtIndex:section];
        
        NSArray *arr = [cityData safeObjectForKey:keyString];
        
        return arr.count;
    }
    else
        return seachResultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _contentTableView)
    {
        static NSString *identfier = @"citylistcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
        }
        
        NSString *keyString = [keyArr safeObjectAtIndex:indexPath.section];
        
        NSArray *curSectionArr = [cityData safeObjectForKey:keyString];
        
        if (ARRAYHASVALUE(curSectionArr)) {
         
            NSDictionary *dict = [curSectionArr safeObjectAtIndex:indexPath.row];
            
            if (DICTIONARYHASVALUE(dict)) {
                cell.textLabel.text = [dict objectForKey:@"sName"];
            }
        }
        
        return cell;
    }
    else
    {
        static NSString *identfier = @"displaycell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
        }
        
        if (ARRAYHASVALUE(seachResultArr))
        {
            
            NSDictionary *dict = [seachResultArr safeObjectAtIndex:indexPath.row];
            
            if (DICTIONARYHASVALUE(dict))
            {
                cell.textLabel.text = [dict objectForKey:@"sName"];
            }
        }
        
        return cell;
    }
}


#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_contentTableView == tableView)
    {
        NSString *keyString = [keyArr safeObjectAtIndex:indexPath.section];
        
        NSArray *curSectionArr = [cityData safeObjectForKey:keyString];
        
        if (ARRAYHASVALUE(curSectionArr)) {
            
            NSDictionary *dict = [curSectionArr safeObjectAtIndex:indexPath.row];
            
            if (DICTIONARYHASVALUE(dict)) {
                NSString *sno = [dict objectForKey:@"sNo"];
                
                NSString *sname = [dict objectForKey:@"sName"];
                
                NSLog(@"sno:%@,sname:%@",sno,sname);
                
                _citySelect(sno,sname);
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
        }
    }
    else
    {
        if (ARRAYHASVALUE(seachResultArr))
        {
            
            NSDictionary *dict = [seachResultArr safeObjectAtIndex:indexPath.row];
            
            if (DICTIONARYHASVALUE(dict))
            {
                NSString *sno = [dict objectForKey:@"sNo"];
                
                NSString *sname = [dict objectForKey:@"sName"];
                
                NSLog(@"sno:%@,sname:%@",sno,sname);
                
                _citySelect(sno,sname);
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
        }
    }
}


#pragma mark - UISearchDisplayController delegate methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{

    if (!searchString) {
        return YES;
    }
    
    searchString = [searchString lowercaseString];

    [seachResultArr removeAllObjects];
    
    for (NSArray *arrayData in cityData.allValues) {
        for (NSDictionary *dict in arrayData) {
            
            if (!DICTIONARYHASVALUE(dict)) {
                continue;
            }
            
            NSString *pingyin = [dict safeObjectForKey:@"pingyin"];
            
            if (STRINGHASVALUE(pingyin))
            {
                pingyin = [pingyin lowercaseString];
                if ([pingyin hasPrefix:searchString])
                {
                    [seachResultArr addObject:dict];
                }
            }
        }
    }
    
    return YES;
    
}

@end
