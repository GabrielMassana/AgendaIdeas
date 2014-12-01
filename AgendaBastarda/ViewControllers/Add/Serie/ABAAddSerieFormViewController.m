//
//  ABAAddSerieFormViewController.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 14/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABAAddSerieFormViewController.h"
#import "ABASerieCollectionViewLayout.h"
#import "ABAAddImageCollectionViewCell.h"
#import "ABAAddNameCollectionViewCell.h"
#import "ABAAddDateCollectionViewCell.h"
#import "ABAAddSettingsCollectionViewCell.h"
#import "ABATextField.h"
#import "ABATextFieldDate.h"
#import "ABAAppDelegate.h"
#import "ABASerie.h"
#import "ABAImage.h"
#import "ABAAddSerieCell.h"
#import "ABAImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>

typedef NS_ENUM(NSUInteger, ABAAlertSerieType)
{
    ABAAlertSerieTypeNoFound      = 0,
    ABAAlertSerieTypeNoImageFound = 1,
    ABAAlertSerieTypeNoConnection = 2,
};

@interface ABAAddSerieFormViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ABAAddImageCollectionViewCellDelegate, ABAImagePickerControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableArray *addSerieCellsArray;

@property (nonatomic, readonly) NSDateFormatter *dateFormatter;

@property (nonatomic, assign) BOOL updateWithSerie;
@property (nonatomic, strong) ABASerie *serie;

@end

@implementation ABAAddSerieFormViewController

#pragma mark - Init

-(instancetype)initWithViewControllerType:(ABAAddSerieFilmTypeViewController)typeViewController
{
    self = [super init];
    
    if (self)
    {
        self.typeViewController = typeViewController;
    }
    return self;
}

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*---------------------*/

    self.navigationController.navigationBarHidden = YES;
    self.navigationController.hidesBarsOnSwipe = YES;
    self.navigationController.hidesBarsWhenKeyboardAppears = YES;
    
    /*---------------------*/

    [self.view addSubview:self.collectionView];
    self.collectionView.contentOffset = CGPointMake(0, 20.0f);
    
    /*---------------------*/

    [self.view addSubview:self.finishButton];
    
    /*---------------------*/

    [self updateViewConstraints];
    
    [self fakeAddCoreData];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.updateWithSerie)
    {
        self.updateWithSerie = NO;
        [self updateWithSerie:self.serie];
        self.serie = nil;
    }
}

- (void)fakeAddCoreData
{
    ABAAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;

    ABASerie *serie = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ABASerie class])
                                                    inManagedObjectContext:self.managedObjectContext];
    
    serie.name = [NSString stringWithFormat:@"The Walking Dead: %@", [NSDate date]];
    serie.serieID = @(1);
    serie.start = [NSDate date];
    
    [self.managedObjectContext save:nil];
    
    [self retrieveCoreData];
}

- (void)retrieveCoreData
{
    ABAAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ABASerie class])
                                                         inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"start" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    NSLog(@"array = %@", array);
    NSLog(@"array = %lu", (unsigned long)[array count]);
}

#pragma mark - Subviews

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        ABASerieCollectionViewLayout *serieCollectionViewLayout = [[ABASerieCollectionViewLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             self.view.bounds.size.width,
                                                                             self.view.bounds.size.height)
                                             collectionViewLayout:serieCollectionViewLayout];
        
        _collectionView.alwaysBounceVertical = YES;
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [self registerCells];
    }
    
    return _collectionView;
}

- (UIButton *)finishButton
{
    if (!_finishButton)
    {
        _finishButton = [UIButton newAutoLayoutView];
        _finishButton.backgroundColor = [UIColor blueColor];
        
        if (self.typeViewController == ABAAddSerieFilmTypeViewControllerEdit)
        {
            [_finishButton setTitle:@"Edit" forState:UIControlStateNormal];
        }
        else
        {
            [_finishButton setTitle:@"Save" forState:UIControlStateNormal];
        }
        
    }
    
    return _finishButton;
}


#pragma mark - Getters

- (NSMutableArray *)addSerieCellsArray
{
    if (!_addSerieCellsArray)
    {
        _addSerieCellsArray = [[NSMutableArray alloc] init];
        
        ABAAddSerieCell *image = [[ABAAddSerieCell alloc] init];
        image.key = @"image";
        image.type = ABAAddSerieCellTypeImage;
        [_addSerieCellsArray addObject:image];
        
        ABAAddSerieCell *name = [[ABAAddSerieCell alloc] init];
        name.key = @"name";
        name.type = ABAAddSerieCellTypeTextField;
        name.canBeginEditedWithNext = NO;
        name.doneShouldReturnTextFieldAction = YES;
        name.autocapitalizationType = UITextAutocapitalizationTypeWords;
        name.autocapitalizationType = UITextAutocorrectionTypeNo;
        name.placeholder = @"Name";
        name.returnKeyType = UIReturnKeyNext;
        [_addSerieCellsArray addObject:name];

        ABAAddSerieCell *start = [[ABAAddSerieCell alloc] init];
        start.key = @"start";
        start.type = ABAAddSerieCellTypeTextFieldDate;
        start.canBeginEditedWithNext = YES;
        start.doneShouldReturnTextFieldAction = YES;
        start.autocapitalizationType = UITextAutocapitalizationTypeNone;
        start.autocapitalizationType = UITextAutocorrectionTypeNo;
        start.placeholder = @"Start Date";
        start.returnKeyType = UIReturnKeyNext;
        [_addSerieCellsArray addObject:start];
        
        ABAAddSerieCell *end = [[ABAAddSerieCell alloc] init];
        end.key = @"end";
        end.type = ABAAddSerieCellTypeTextFieldDate;
        end.canBeginEditedWithNext = YES;
        end.doneShouldReturnTextFieldAction = NO;
        end.autocapitalizationType = UITextAutocapitalizationTypeNone;
        end.autocapitalizationType = UITextAutocorrectionTypeNo;
        end.placeholder = @"End Date";
        end.returnKeyType = UIReturnKeyDone;
        [_addSerieCellsArray addObject:end];
        
        ABAAddSerieCell *weekly = [[ABAAddSerieCell alloc] init];
        weekly.key = @"weekly";
        weekly.type = ABAAddSerieCellTypeSwitch;
        weekly.canBeginEditedWithNext = NO;
        weekly.doneShouldReturnTextFieldAction = NO;
        weekly.title = @"Weekly";
        weekly.switchOn = YES;
        [_addSerieCellsArray addObject:weekly];
        
        ABAAddSerieCell *daily = [[ABAAddSerieCell alloc] init];
        daily.key = @"daily";
        daily.type = ABAAddSerieCellTypeSwitch;
        daily.canBeginEditedWithNext = NO;
        daily.doneShouldReturnTextFieldAction = NO;
        daily.title = @"Daily";
        [_addSerieCellsArray addObject:daily];
        
        ABAAddSerieCell *aproxDate = [[ABAAddSerieCell alloc] init];
        aproxDate.key = @"aproxDate";
        aproxDate.type = ABAAddSerieCellTypeSwitch;
        aproxDate.canBeginEditedWithNext = NO;
        aproxDate.doneShouldReturnTextFieldAction = NO;
        aproxDate.title = @"Aprox. Date";
        [_addSerieCellsArray addObject:aproxDate];
    }
    
    return _addSerieCellsArray;
}

#pragma mark - Getters

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    });
    
    return dateFormatter;
}

#pragma mark - RegisterCells

- (void)registerCells
{
    [self.collectionView registerClass:[ABAAddImageCollectionViewCell class]
            forCellWithReuseIdentifier:[ABAAddImageCollectionViewCell reuseIdentifier]];
    
    [self.collectionView registerClass:[ABAAddNameCollectionViewCell class]
            forCellWithReuseIdentifier:[ABAAddNameCollectionViewCell reuseIdentifier]];
    
    [self.collectionView registerClass:[ABAAddDateCollectionViewCell class]
            forCellWithReuseIdentifier:[ABAAddDateCollectionViewCell reuseIdentifier]];
    
    [self.collectionView registerClass:[ABAAddSettingsCollectionViewCell class]
            forCellWithReuseIdentifier:[ABAAddSettingsCollectionViewCell reuseIdentifier]];
}

#pragma mark - Constraints

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    /*---------------------*/
    
    [self.finishButton autoSetDimensionsToSize:CGSizeMake(78.0f, 78.0f)];
    
    [self.finishButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [self.finishButton autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                      withInset:0.0f];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.addSerieCellsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ABACollectionViewCell *cell = nil;
    
    
    
    if (indexPath.row == 0)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ABAAddImageCollectionViewCell reuseIdentifier]
                                                         forIndexPath:indexPath];
        ((ABAAddImageCollectionViewCell *)cell).delegate = self;
    }
    else if (indexPath.row == 1)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ABAAddNameCollectionViewCell reuseIdentifier]
                                                         forIndexPath:indexPath];
    }
    else if (indexPath.row == 2)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ABAAddDateCollectionViewCell reuseIdentifier]
                                                         forIndexPath:indexPath];
        ((ABAAddDateCollectionViewCell *)cell).textField.placeholder = @"Start Date";
    }
    else if (indexPath.row == 3)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ABAAddDateCollectionViewCell reuseIdentifier]
                                                         forIndexPath:indexPath];
        ((ABAAddDateCollectionViewCell *)cell).textField.placeholder = @"End Date";

    }
    else if (indexPath.row <= 7)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ABAAddSettingsCollectionViewCell reuseIdentifier]
                                                         forIndexPath:indexPath];
    }
    
    [cell updateWithAddSerieCellData:self.addSerieCellsArray[indexPath.row]];
    
    /*---------------------*/
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    /*---------------------*/
    
    return cell;    
}

- (void)updateWithSerie:(ABASerie *)serie
{
    if (serie.image.image)
    {
        ABAAddImageCollectionViewCell *cellImage = (ABAAddImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [cellImage.imageButton setImage:[UIImage imageWithData:serie.image.image] forState:UIControlStateNormal];
    }
    
    ABAAddNameCollectionViewCell *cellName = (ABAAddNameCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    cellName.textField.text = serie.name;
    
    if (!cellName)
    {
        self.updateWithSerie = YES;
        self.serie = serie;
    }
    
    ABAAddDateCollectionViewCell *cellStart = (ABAAddDateCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
    cellStart.textField.text = [self.dateFormatter stringFromDate:serie.start];
    
    ABAAddDateCollectionViewCell *cellEnd = (ABAAddDateCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
    cellEnd.textField.text = [self.dateFormatter stringFromDate:serie.end];
    
    ABAAddSettingsCollectionViewCell *cellWeek = (ABAAddSettingsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
    cellWeek.switcher.on = [serie.weekly boolValue];
    
    ABAAddSettingsCollectionViewCell *cellDay = (ABAAddSettingsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0]];
    cellDay.switcher.on = [serie.daily boolValue];
    
    ABAAddSettingsCollectionViewCell *cellAprox = (ABAAddSettingsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:6 inSection:0]];
    cellAprox.switcher.on = [serie.aproxDate boolValue];
}

#pragma mark - ABAAddImageCollectionViewCellDelegate

- (void)userWantToChangeCellImage:(UIButton *)button
{
    NSLog(@"userWantToChangeCellImage");
    
    UIAlertController *imageAlertController = [UIAlertController alertControllerWithTitle:@"Add an Image"
                                                                                  message:nil
                                                                           preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *newPhoto = [UIAlertAction actionWithTitle:@"Take a photo"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                                   [imageAlertController dismissViewControllerAnimated:YES
                                                                            completion:nil];
                                   
                                   [self newPhotoPressed:button];
                                   
                               }];
    
    UIAlertAction *existingPhoto = [UIAlertAction actionWithTitle:@"Use existing photo"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [imageAlertController dismissViewControllerAnimated:YES
                                                                                 completion:nil];
                                        
                                        [self existingPhotoPressed:button];
                                        
                                    }];
    
    UIAlertAction *search = [UIAlertAction actionWithTitle:@"Search by Serie Name"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                 [imageAlertController dismissViewControllerAnimated:YES
                                                                          completion:nil];
                                 
                                 [self searchPressed:button];
                                 
                             }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action)
                             {
                                 [imageAlertController dismissViewControllerAnimated:YES
                                                                          completion:nil];
                             }];
    
    [imageAlertController addAction:newPhoto];
    [imageAlertController addAction:existingPhoto];
    [imageAlertController addAction:search];
    [imageAlertController addAction:cancel];
    
    [self presentViewController:imageAlertController
                       animated:YES
                     completion:nil];
}

#pragma mark - ImagePickers

- (void)newPhotoPressed:(UIButton *)button
{
    NSLog(@"userWantToChangeCellImage newPhotoPressed");
    
    BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];

    if (cameraAvailable)
    {
        ABAImagePickerController *imagePickerController = [[ABAImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.pickerDelegate = self;
        
        [self presentViewController:imagePickerController
                           animated:YES
                         completion:nil];

    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Camera not available"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                 [alertController dismissViewControllerAnimated:YES
                                                                     completion:nil];
                             }];
        
        [alertController addAction:ok];
        
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    }
    
}

- (void)existingPhotoPressed:(UIButton *)button
{
    NSLog(@"userWantToChangeCellImage existingPhotoPressed");
    
    BOOL imagesAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];

    if (imagesAvailable)
    {
        ABAImagePickerController *imagePickerController = [[ABAImagePickerController alloc] init];
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        imagePickerController.pickerDelegate = self;
        
        [self presentViewController:imagePickerController
                           animated:YES
                         completion:nil];
        
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Photo Library not available"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                 [alertController dismissViewControllerAnimated:YES
                                                                     completion:nil];
                             }];
        
        [alertController addAction:ok];
        
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    }
}

- (void)searchPressed:(UIButton *)button
{
    NSLog(@"userWantToChangeCellImage searchPressed");
    
    ABAAddNameCollectionViewCell *cellName = (ABAAddNameCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    
     NSString *trimmedName = [cellName.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"userWantToChangeCellImage trimmedName = %@", trimmedName);

    
    if (trimmedName == nil ||
        [trimmedName length] == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Serie name is empty."
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                 [cellName.textField becomeFirstResponder];
                                 
                                 [alertController dismissViewControllerAnimated:YES
                                                                     completion:nil];
                             }];
        
        [alertController addAction:ok];
        
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];

    }
    else
    {
        //Google Images
        NSLog(@"userWantToChangeCellImage Google Images = %@", trimmedName);
        
        
        NSString *newTrimmedName = [trimmedName stringByReplacingOccurrencesOfString:@" " withString:@"+"];

        NSLog(@"userWantToChangeCellImage Google Images = %@", newTrimmedName);

        NSString *urlString = [NSString stringWithFormat:@"http://www.omdbapi.com/?t=%@&y=&plot=short&r=json", newTrimmedName];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        if (data)
        {
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:0
                                                                           error:nil];
            
            NSLog(@"parsedObject = %@", parsedObject);
            
            if ([parsedObject[@"Response"] boolValue])
            {
                if (parsedObject[@"Poster"])
                {
                    NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:parsedObject[@"Poster"]]];
                    
                    if (dataImage)
                    {
                        UIImage *image = [UIImage imageWithData:dataImage];
                        [self selectedImage:image];
                        
                    }
                    else
                    {
                        [self showAlertView:ABAAlertSerieTypeNoImageFound];
                    }
                    
                }
                else
                {
                    [self showAlertView:ABAAlertSerieTypeNoImageFound];
                }
                
            }
            else
            {
                [self showAlertView:ABAAlertSerieTypeNoFound];
            }

        }
        else
        {
            [self showAlertView:ABAAlertSerieTypeNoConnection];
        }
        
    }
}

#pragma mark - ABAImagePickerControllerDelegate

- (void)selectedImage:(UIImage *)image
{
    ABAAddImageCollectionViewCell *cellImage = (ABAAddImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    cellImage.image.contentMode = UIViewContentModeScaleAspectFit;
    cellImage.image.image = image;
}

#pragma mark - AlertView

- (void)showAlertView:(ABAAlertSerieType)alertType
{
    NSString *message;
    
    if (alertType == ABAAlertSerieTypeNoImageFound)
    {
        message = @"Sorry, no image for this serie in our Database.";
    }
    else if (alertType == ABAAlertSerieTypeNoFound)
    {
        message = @"Sorry, no Serie found.\nCheck the spelling of the serie, please.";
    }
    else if (alertType == ABAAlertSerieTypeNoConnection)
    {
        message = @"We cannot reach our Database. Check if you have Internet Connection.";
    }
    
    UIAlertController *imageAlertController = [UIAlertController alertControllerWithTitle:nil
                                                                                  message:message
                                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             [imageAlertController dismissViewControllerAnimated:YES
                                                                      completion:nil];
                         }];
    
    [imageAlertController addAction:ok];
    
    [self presentViewController:imageAlertController
                       animated:YES
                     completion:nil];
}

#pragma mark - MemoryManagement

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
