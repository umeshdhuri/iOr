//
//  FBCDViewController.m
//  FailedBankCD
//
//  Created by Umesh Dhuri on 17/12/12.
//  Copyright (c) 2012 Umesh Dhuri. All rights reserved.
//

#import "FBCDViewController.h"
#import "FBCDAppDelegate.h"

@interface FBCDViewController ()

@end

@implementation FBCDViewController
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    NSError *error = nil;
    
    FBCDAppDelegate *appDele = (FBCDAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *userInfoRetrive = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:appDele.managedObjectContext];
    [fetchRequest setEntity:userInfoRetrive];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fname=%@", @"Umesh"];
    //[fetchRequest setPredicate:predicate];
    NSArray *fetchRow = [appDele.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for(NSManagedObject *userInfo in fetchRow)
    {
        NSLog(@"First Name : ==== %@", [userInfo valueForKey:@"fname"]);
        NSManagedObject *detailsInfo = [userInfo valueForKey:@"userInfo"];
        dataDict = [[NSMutableDictionary alloc] init];
        
        [dataDict setObject:[userInfo valueForKey:@"fname"] forKey:@"Fname"];
        [dataDict setObject:[userInfo valueForKey:@"lname"] forKey:@"Lname"];
        
        [dataList addObject:dataDict];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    dataList = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataList count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[dataList objectAtIndex:indexPath.row] objectForKey:@"Fname"], [[dataList objectAtIndex:indexPath.row] objectForKey:@"Lname"]];
    
    return cell;
}

-(IBAction) insertData
{
    addData *add = [[addData alloc] init];
    
    [self.navigationController pushViewController:add animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
