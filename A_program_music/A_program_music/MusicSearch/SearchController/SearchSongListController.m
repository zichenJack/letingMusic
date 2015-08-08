//
//  SearchSongListController.m
//  A_program_music
//
//  Created by 姚天成 on 15/6/21.
//  Copyright (c) 2015年 CHD. All rights reserved.
//

#import "SearchSongListController.h"
#import "DiscoverNewsongList.h"
#import "DiscoverModel.h"
@interface SearchSongListController ()

@property(nonatomic,retain)MusicTableViewController *tableView;


@end

@implementation SearchSongListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[[MusicTableViewController alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 100)style:UITableViewStyleGrouped] autorelease];
    self.tableView.backgroundColor = [UIColor colorWithRed:143.0/255 green:172.0/255 blue:193.0/255 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 0.01f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 0.01f)];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 1;
//    
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *name = @"SearchSongList";
    SearchSongListCell *cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (cell == nil) {
        cell = [[SearchSongListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
    }
    cell.model = [self.array objectAtIndex:indexPath.row];
    //添加cell上右箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
    
}

-(void)setSearchName:(NSString *)searchName{
    
    [self getData:searchName];
    
}
-(void)getData:(NSString *)name{
    NSString *urlString= [NSString stringWithFormat:@"%@",name];
    
    NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL,  kCFStringEncodingUTF8 );
    
    NSString *url = [NSString stringWithFormat:@"http://so.ard.iyyin.com/s/playlist?q=%@&page=1&size=50",encodedString];
    self.array = [NSMutableArray array];
    [AFNGet GetData:url block:^(id backData) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:backData];
        NSMutableArray *array = [dic objectForKey:@"data"];
        
        for (NSMutableDictionary *dic in array) {
            SearchSongListModel *model = [[[SearchSongListModel alloc] init] autorelease];
            [model setValuesForKeysWithDictionary:dic];
            [self.array addObject:model];
        }
        // NSLog(@"%@",self.array);
        [self.tableView reloadData];
        
    }];
    
    
}
//cell点击效果
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DiscoverNewsongList *NewList = [[DiscoverNewsongList alloc] init] ;
    DiscoverModel *model = [[DiscoverModel alloc] init] ;
    SearchSongListModel *model1 = [self.array objectAtIndex:indexPath.row];
    //NSLog(@"===================%@",model1.song_list);
    model.Listid = model1.quan_id;
    model.name = model1.title;
    NewList.model = model;
    //NewList.model = [array objectAtIndex:row];;
    [self.navigationController pushViewController:NewList animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
