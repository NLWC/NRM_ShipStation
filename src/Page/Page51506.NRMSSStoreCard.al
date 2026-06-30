page 51506 "NRM SS Store Card"
{
    Caption = 'ShipStation Store Card';
    PageType = Card;
    SourceTable = "NRM SS Store";
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = true;
    ApplicationArea = All;
    UsageCategory = None;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Store ID"; Rec."Store ID")
                {
                    ToolTip = 'Specifies the value of the Store ID field.', Comment = '%';
                }
                field("Store Name"; Rec."Store Name")
                {
                    ToolTip = 'Specifies the value of the Store Name field.', Comment = '%';
                }
                field("Marketplace Name"; Rec."Marketplace Name")
                {
                    ToolTip = 'Specifies the value of the Marketplace Name field.', Comment = '%';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.', Comment = '%';
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies the value of the Active field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
            }
            group(Extended)
            {
                field("Customer Template Code"; Rec."Customer Template Code")
                {
                    ToolTip = 'Specifies the value of the Customer Template Code field.', Comment = '%';
                }
                field("Customer Prefix"; Rec."Customer Prefix")
                {
                    ToolTip = 'Specifies the value of the Customer Prefix field.', Comment = '%';
                }
                field("Prefix Order No."; Rec."Prefix Order No.")
                {
                    ToolTip = 'Specifies the value of the Prefix Order No. field.', Comment = '%';
                }
                field("Website"; Rec."Website")
                {
                    ToolTip = 'Specifies the value of the Website field.', Comment = '%';
                }
                field("Shipping Income Account No."; Rec."Shipping Income Account No.")
                {
                    ToolTip = 'Specifies the value of the Shipping Income Account No. field.', Comment = '%';
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ToolTip = 'Specifies the value of the Journal Template Name field.', Comment = '%';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                }
                field("Clearing Account No."; Rec."Clearing Account No.")
                {
                    ToolTip = 'Specifies the value of the Clearing Account No. field.', Comment = '%';
                }
                field("Colorado Fee Code"; Rec."Colorado Fee Code")
                {
                    ToolTip = 'Specifies the value of the Colorado Fee Code field.', Comment = '%';
                }
                field("Tax Account No."; Rec."Tax Account No.")
                {
                    ToolTip = 'Specifies the value of the Tax Account No. field.', Comment = '%';
                }
                field("Shipping Expense"; Rec."Shipping Expense")
                {
                    ToolTip = 'Specifies the value of the Tax Account No. field.', Comment = '%';
                }
            }
            part(Fees; "NRM SS Fees")
            {
                Caption = 'Fees';
                SubPageLink = "Store ID" = field("Store ID");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Sync Stores")
            {
                Caption = 'Sync Stores';
                ApplicationArea = All;
                Image = Refresh;
                ToolTip = 'Synchronize store data from ShipStation API.';

                trigger OnAction()
                var
                    ShipStationAPIV1: Codeunit "NRM ShipStation API v1";
                begin
                    ShipStationAPIV1.SyncStores();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref("Sync Stores_Promoted"; "Sync Stores") { }
            }
        }
    }
}