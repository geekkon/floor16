//
//  DBItemDetailTableViewController.m
//  Floor16
//
//  Created by Dim on 15.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBItemDetailTableViewController.h"
#import "DBRequestManager.h"
#import "DBItemDetails.h"
#import "DBCollectionViewController.h"
#import "DBCollectionViewCell.h"

#import "DBMapAnnotation.h"

NS_ENUM(NSUInteger, DBPhoneCallAlertViewButtonType) {
    
    DBPhoneCallAlertViewButtonTypeCancel,
    DBPhoneCallAlertViewButtonTypeCall
};

NSString const * basePhoneURL =  @"https://floor16.ru/api/private";

@interface DBItemDetailTableViewController () <DBRequestManagerDelegate>

@property (strong, nonatomic) DBItemDetails *itemDetails;
@property (strong, nonatomic) NSString *phoneNumber;

@end

@implementation DBItemDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [[DBRequestManager sharedManager] getItemDetailsFromServerWithSeoid:self.seoid
                                                            andDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <DBRequestManagerDelegate>

- (void)requestManager:(DBRequestManager *)manager didGetItemDetails:(DBItemDetails *)itemDatails {
    
    self.itemDetails = itemDatails;
    [self configureView];
    [self.tableView reloadData];
    [self.activityIndicator stopAnimating];
}

- (void)requestManager:(DBRequestManager *)manager didFailWithError:(NSError *)error {
    
    [self alertWithError:error];
}

#pragma mark - Private Methods

- (void)configureView {
    
    self.navigationItemLabel.text = self.itemDetails.created;
    self.streetLabel.text = self.itemDetails.address;
    self.areaLabel.text = [NSString stringWithFormat:@"%.0fм2", self.itemDetails.total_area];
    self.floorsLabel.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)self.itemDetails.floor, (unsigned long)self.itemDetails.floors];
    self.buildingLabel.text = [NSString stringWithFormat:@"%@", self.itemDetails.building_type];
    self.priceLabel.text = [NSString stringWithFormat:@"%.0f руб.", self.itemDetails.price];
    
    self.pageControl.numberOfPages = [self.itemDetails.imgs count];

    [self.collectionView reloadData];
}

- (void)alertWithError:(NSError *)error {
    
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                         message:[error localizedDescription]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    
    [errorAlert show];
}

- (void)phoneNumberRequestWithActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    
    NSString *phoneString = [basePhoneURL stringByAppendingPathComponent:self.itemDetails.seoid];
    
    NSURLRequest *phoneRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:phoneString]];
    
    NSError *error = nil;
    
    NSData *phoneData = [NSURLConnection sendSynchronousRequest:phoneRequest
                                              returningResponse:nil
                                                          error:&error];
    
    if (error) {
        
        [self alertWithError:error];
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        
        return;
    }
    
    NSArray *phone = [NSJSONSerialization JSONObjectWithData:phoneData options:0 error:&error];
    
    if (error) {
        
        [self alertWithError:error];
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        
        return;
    }
    
    if ([NSJSONSerialization isValidJSONObject:phone]) {
        
        self.phoneNumber = [phone firstObject];
        
        [self showPhoneNumberAlert];
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    }
}

- (void)showPhoneNumberAlert {
    
    NSString *message = @"";
    
    if (self.itemDetails.person_name) {
        
        message = [NSString stringWithFormat:@"Арендодатель %@\n", self.itemDetails.person_name];
    }
    
    message = [message stringByAppendingFormat:@"Номер %@", self.phoneNumber];
    
    UIAlertView *phoneNumberAlert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:message
                                                            delegate:self
                                                   cancelButtonTitle:@"Отмена"
                                                   otherButtonTitles:@"Звонок", nil];
    
    [phoneNumberAlert show];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.pageControl.currentPage = self.collectionView.contentOffset.x / CGRectGetWidth(self.view.bounds);
}

#pragma mark - <UICollectionViewDelegate>

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    self.pageControl.currentPage = indexPath.row;
//}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.itemDetails.imgs count];
}

- (DBCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
        
    NSString *stringURL = self.itemDetails.imgs[indexPath.row];
    
    [cell configureWithStringURL:stringURL];
    
    return cell;
}

#pragma mamrk - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        
        return self.itemDetails.imgs_cnt ? 274.0 : 0.0;
    }
    
    return 72.0;
}

#pragma mark - <UITableViewDataSource>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *titleForHeader = nil;
    
    if (self.itemDetails.appartment_type) {
        titleForHeader = [NSString stringWithFormat:@"Сдается %@", self.itemDetails.appartment_type];
    }
    
    return titleForHeader;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    return self.itemDetails.descr;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.itemDetails.lat, self.itemDetails.lng);
        
        DBMapAnnotation *annotation = [[DBMapAnnotation alloc] init];
        annotation.title = self.itemDetails.address;
        annotation.coordinate = coordinate;
        
        [[segue destinationViewController] setAnnotation:annotation];
        
    } else if ([[segue identifier] isEqualToString:@"showPhoto"]) {
        
        UINavigationController *navigationController = [segue destinationViewController];
        
        DBCollectionViewController *collectionViewController = (DBCollectionViewController *)navigationController.topViewController;
        
        collectionViewController.pics = self.itemDetails.imgs;
        
        [collectionViewController showPhotoByIndex:3];
    }
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == DBPhoneCallAlertViewButtonTypeCall && self.phoneNumber) {
                
        //input format +x(xxx) xxx-xx-xx
        
        NSCharacterSet *phoneNumberCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"+1234567890"];
        
        NSArray *components = [self.phoneNumber componentsSeparatedByCharactersInSet:[phoneNumberCharacterSet invertedSet]];
        
        NSString *phoneNumber = [components componentsJoinedByString:@""];
        
        //output format +xxxxxxxxxxx
                
        NSString *telString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
    }
}

#pragma mark - Actions

- (IBAction)actionCall:(UIButton *)sender {
    
    if (self.phoneNumber) {
        
        [self showPhoneNumberAlert];
        
    } else {
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activityIndicator.backgroundColor = [UIColor whiteColor];
        activityIndicator.frame = sender.bounds;
        
        [activityIndicator startAnimating];
        
        [sender addSubview:activityIndicator];
        
        /*
        
        NSString *phoneString = [basePhoneURL stringByAppendingPathComponent:self.itemDetails.seoid];
        
        NSURLRequest *phoneRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:phoneString]];
        
        [NSURLConnection sendAsynchronousRequest:phoneRequest
                                           queue:[NSOperationQueue currentQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   
                                   if (connectionError) {
                                       
                                       [self alertWithError:connectionError];
                                       
                                       [activityIndicator stopAnimating];
                                       [activityIndicator removeFromSuperview];
                                       
                                       return;
                                   }
                                   
                                   NSError *error = nil;
                                   
                                    NSArray *phone = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   
                                           if (error) {
                                   
                                               [self alertWithError:error];
                                   
                                               [activityIndicator stopAnimating];
                                               [activityIndicator removeFromSuperview];
                                   
                                               return;
                                           }
                                   
                                   if ([NSJSONSerialization isValidJSONObject:phone]) {
                                       
                                       self.phoneNumber = [phone firstObject];
                                       
                                       [self showPhoneNumberAlert];
                                       
                                       [activityIndicator stopAnimating];
                                       [activityIndicator removeFromSuperview];
                                   }
                                   
                                   
                               }];
         */
        
        [self performSelectorInBackground:@selector(phoneNumberRequestWithActivityIndicator:) withObject:activityIndicator];
    }
}

- (IBAction)actionPageControl:(UIPageControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.currentPage inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

@end
