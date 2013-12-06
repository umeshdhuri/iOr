//
//  CountryPickerViewController.m
//  iOR
//
//  Created by Krunal Doshi on 10/28/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "CountryPickerViewController.h"
#import "SponsorViewController.h"

@interface CountryPickerViewController ()
@property (nonatomic, strong) NSArray *aryCountryNames;
@property (nonatomic, strong) NSArray *aryCountryCodes;
@property (nonatomic, strong) NSMutableArray *arySearchResult;

@end

@implementation CountryPickerViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
//    self.aryCountryNames = [[[[CountryPickerViewController countryNamesByCode] allValues] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] copy];
//    self.aryCountryCodes = [[[CountryPickerViewController countryCodesByName] objectsForKeys:self.aryCountryNames notFoundMarker:@""] copy];
    
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.backgroundImage = [UIImage imageNamed:@"content_background_normal.png"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    self.aryCountryNames = [[NSArray alloc] initWithContentsOfFile:path];
    
    //self.aryCountryCodes = [NSArray arrayWithArray:[self.dictCountries allKeys]];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    self.aryCountryCodes = [self.aryCountryNames sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    self.tblCountry.backgroundColor = [UIColor colorWithRed:40.0/255 green:40.0/255 blue:40.0/255 alpha:100.0];
    self.tblCountry.separatorColor = [UIColor lightGrayColor];
    
    if(self.sponsorViewController) {
        CGRect frame = self.tblCountry.frame;
        frame.origin.y += 10;
        self.tblCountry.frame = frame;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Custom methods

+ (NSDictionary *)countryNamesByCode
{
    static NSDictionary *_countryNamesByCode = nil;
    if (!_countryNamesByCode)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
        _countryNamesByCode = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return _countryNamesByCode;
}

+ (NSDictionary *)countryCodesByName
{
    static NSDictionary *_countryCodesByName = nil;
    if (!_countryCodesByName)
    {
        NSDictionary *countryNamesByCode = [self countryNamesByCode];
        NSMutableDictionary *codesByName = [NSMutableDictionary dictionary];
        for (NSString *code in countryNamesByCode)
        {
            codesByName[countryNamesByCode[code]] = code;
        }
        _countryCodesByName = [codesByName copy];
    }
    return _countryCodesByName;
}

- (IBAction)btnCloseClicked:(id)sender {
    [self.searchBar resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked: dictCountry:)]) {
        [self.delegate cancelButtonClicked:self dictCountry:nil];
    }
}

#pragma mark -
#pragma mark TableView DataSource Mehotds

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.tblCountry) {
        return [self.aryCountryCodes count];
    }
    else {
        return [self.arySearchResult count];
    }
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {

    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(48, 5, 225, 24)];
    [lblTime setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary *dictCountry;
    
    if(tableView == self.tblCountry) {
        dictCountry = [self.aryCountryCodes objectAtIndex:indexPath.row];
        if(indexPath.row != [self.aryCountryCodes count]) {
            UIView *dividerImgView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 5, 320, 1)];
            [dividerImgView setBackgroundColor:[UIColor lightGrayColor]];
            //[dividerImgView setImage:[UIImage imageNamed:@"divider_line.png"]];
            [cell.contentView addSubview:dividerImgView];
        }

    }
    else {
        dictCountry = [self.arySearchResult objectAtIndex:indexPath.row];
        if(indexPath.row != [self.arySearchResult count]) {
            UIView *dividerImgView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 5, 320, 1)];
            [dividerImgView setBackgroundColor:[UIColor lightGrayColor]];
            //[dividerImgView setImage:[UIImage imageNamed:@"divider_line.png"]];
            [cell.contentView addSubview:dividerImgView];
        }
    }
    
    NSString *strTitle = @"";
    strTitle = [dictCountry valueForKey:@"name"];
    lblTime.text = strTitle;
    lblTime.textColor = [UIColor whiteColor];
    
    UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 24, 24)];
    flagView.contentMode = UIViewContentModeScaleToFill;
    [cell addSubview:flagView];
    flagView.image = [UIImage imageNamed:[[dictCountry valueForKey:@"flag"] stringByAppendingPathExtension:@"png"]];
    
    [cell.contentView addSubview:lblTime];
    
    if(IS_IOS7_AND_UP) {
        cell.backgroundColor = [UIColor grayColor];
    }
    else {
        UIView * v = [[UIView alloc] init];
        v.backgroundColor = [UIColor grayColor];
        cell.backgroundView = v;
    }
    
    return cell;


}



#pragma mark -
#pragma mark Tableview Delegate Methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self.searchDisplayController.searchBar resignFirstResponder];
    [self.searchBar resignFirstResponder];
    
       // NSDictionary *dictCountry = [self.aryCountryCodes objectAtIndex:indexPath.row];
    
    NSDictionary *dictCountry;
    
    if(tableView == self.tblCountry) {
        dictCountry = [self.aryCountryCodes objectAtIndex:indexPath.row];
    }
    else {
//        DLog(@"%@", [self.arySearchResult objectAtIndex:indexPath.row]);
        dictCountry = [self.arySearchResult objectAtIndex:indexPath.row];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked: dictCountry:)]) {
        [self.delegate cancelButtonClicked:self dictCountry:dictCountry];
    }
    else {
        if (self.sponsorViewController && [self.sponsorViewController respondsToSelector:@selector(cancelButtonClicked: dictCountry:)]) {
            [self.sponsorViewController cancelButtonClicked:self dictCountry:dictCountry];
        }
    }
}

#pragma mark -
#pragma mark Search Bar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS [cd] %@",searchText];
    NSArray *arySearch = [self.aryCountryNames filteredArrayUsingPredicate:resultPredicate];
    if(self.arySearchResult) {
        [self.arySearchResult removeAllObjects];
        self.arySearchResult = nil;
    }
    
    self.arySearchResult = [[NSMutableArray alloc] initWithArray:arySearch];
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];

    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    
    tableView.backgroundColor = [UIColor colorWithRed:40.0/255 green:40.0/255 blue:40.0/255 alpha:100.0];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


@end
