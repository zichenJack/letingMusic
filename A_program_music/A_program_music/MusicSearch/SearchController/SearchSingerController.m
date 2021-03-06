//
//  SearchSingerController.m
//  A_program_music
//
//  Created by 姚天成 on 15/6/21.
//  Copyright (c) 2015年 CHD. All rights reserved.
//

#import "SearchSingerController.h"
#import "SingerSongViewController.h"
@interface SearchSingerController ()

@property(nonatomic,retain)MusicTableViewController *tableView;


@end

@implementation SearchSingerController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建tableview
    self.tableView = [[[MusicTableViewController alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 100) style:UITableViewStyleGrouped] autorelease];
    self.tableView.backgroundColor = [UIColor colorWithRed:143.0/255 green:172.0/255 blue:193.0/255 alpha:1];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 0.01f)];
    
    
    
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
    static NSString *name = @"SearchSinger";
    SearchSingerCell *cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (cell == nil) {
        cell = [[SearchSingerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
    }
    cell.model = [self.array objectAtIndex:indexPath.row];
    //添加cell上右箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;


}
//cell点击效果
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
#warning mark - 返回时crash
    SearchSingerModel *model = [self.array objectAtIndex:indexPath.row];
    SingerSongViewController *detail = [[SingerSongViewController alloc] init];
    detail.singerSongModel = [[SingerSongModel alloc] init];
    detail.singerSongModel.singer_id = model._id;
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)setSearchName:(NSString *)searchName{


    [self getNetData:searchName];

}

-(void)getNetData:(NSString *)name{

    NSString *urlString= [NSString stringWithFormat:@"%@",name];
    
    NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL,  kCFStringEncodingUTF8 );
    
    NSString *url = [NSString stringWithFormat:@"http://so.ard.iyyin.com/s/artist?q=%@&page=1&size=15",encodedString];
    
    [AFNGet GetData:url block:^(id backData) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:backData];
        NSMutableArray *array = [dic objectForKey:@"data"];
        self.array = [NSMutableArray array];
        for (NSMutableDictionary *dic in array) {
            SearchSingerModel *model = [[SearchSingerModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.array addObject:model];
            
        }
        [self.tableView reloadData];
    }];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
