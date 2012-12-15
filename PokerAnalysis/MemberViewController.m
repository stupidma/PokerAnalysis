//
//  MemberViewController.m
//  PokerAnalysis
//
//  Created by He Tyrion on 12-11-25.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import "MemberViewController.h"
#import "DataOp.h"
#import "config.h"
#import "AnalysisViewController.h"

@interface MemberViewController ()

@end

@implementation MemberViewController

@synthesize analysisCtrl;
@synthesize players = _players;
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void) dealloc {
    nameView = nil;
    self.players = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.players = [DataOp allPlayers];
    
    nameView = [[UITextView alloc] initWithFrame:self.view.frame];
    nameView.delegate = self;
//    nameView.text = @"Set Player name";
    nameView.returnKeyType = UIReturnKeyDefault;
    nameView.keyboardType = UIKeyboardTypeDefault;
    nameView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
//                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//                                                                                   target:self
//                                                                                   action:@selector(addMember:)];

    // should be deleted when implment complete ???
    [DataOp createTable];
    
    [mebCtrl addTarget:self action:@selector(mebCtrlChanged:) forControlEvents:UIControlEventValueChanged];
    type = MEMBER_SET;
    
    analysisCtrl = [[AnalysisViewController alloc] initWithNibName:@"AnalysisViewController" bundle:nil];
    
#ifdef DEBUG
    for ( NSString *s in [self.players allValues] ) {
        NSLog( @"MemberViewController:viewDidLoad value:%@", s );
    }
    
    for ( id key in [self.players allKeys] ) {
        NSLog( @"MemberViewController:viewDidLoad key:%@", key );
    }
#endif
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) playerSelected:(NSString *)_name playerID:(int)_id {
    assert( _name );
    assert( _id );
    
    [delegate selectedPlayer:_name playerID:_id];
    [delegate cancelMemberView];
}
- (void) playerAnalysis:(NSString *)_name playerID:(int)_id {
    assert( _name );
    assert( _id );
    
    [analysisCtrl displayWithPlayerName:_name playerID:_id];
    [self.view addSubview:analysisCtrl.view];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog( @"MemberViewController:tableView:cellForRowAtIndexPath" );
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
//    cell.textLabel.text = [self.players objectAtIndex:[indexPath row]];
    cell.textLabel.text = [_players objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]+1]];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger  row = [indexPath row];
    NSString *player_name = [_players objectForKey:[NSString stringWithFormat:@"%d", row+1]];
    
    switch ( type ) {
        case MEMBER_SET:
            [self playerSelected:player_name playerID:row+1];
            break;
        case MEMBER_ANALYSIS:
            [self playerAnalysis:player_name playerID:row+1];
        default:
            break;
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void) createPlayer {
    if ( nameView.text.length > 0 ) {
        [DataOp createPlayer:nameView.text];
    }
}

#pragma mark - selector
- (void) mebCtrlChanged:(id)_sender {
    type = [_sender selectedSegmentIndex]+1;
    
#ifdef DEBUG
    NSLog( @"MemberViewController:mebCtrlChanged type=%d", type );
#endif
}

- (IBAction) addMember:(id)_sender {
    NSLog( @"MemberViewController:addMember" );
    
    [self.view addSubview:nameView];
    
}

- (IBAction) cancel:(id)sender {
    NSLog( @"MemberViewController:cancel" );
    
    [delegate cancelMemberView];
}
//- (IBAction) textFieldDoneEditing:(id)sender {
//    [sender resignFirstResponder];
//    
//    if ( nameField.text.length > 0 ) {
//        NSString *name = [NSString stringWithFormat:@"%@", nameField.text];
//        UIButton *btn = (UIButton *)[self.view viewWithTag:playerNum];
//        [btn setTitle:name forState:0];
//
//        [DataOp createPlayer:name];
//    }
//
//}

#pragma mark - UITextView Delegate Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        [nameView removeFromSuperview];
        [self createPlayer];
        
        
        return NO;
        
    }
    
    return YES;
    
}

@end
