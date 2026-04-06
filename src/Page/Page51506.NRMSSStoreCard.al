page 51506 "NRM SS Store Card"
{
    Caption = 'ShipStation Store Card';
    PageType = Card;
    SourceTable = "NRM SS Store";
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = true;
    ApplicationArea = All;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Store ID"; Rec."Store ID")
                {
                    ApplicationArea = All;
                }
                field("Store Name"; Rec."Store Name")
                {
                    ApplicationArea = All;
                }
                field("Marketplace Name"; Rec."Marketplace Name")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
            }
            group(Extended)
            {
                field("Customer Template Code"; Rec."Customer Template Code")
                {
                    ApplicationArea = All;
                }
                field("Customer Prefix"; Rec."Customer Prefix")
                {
                    ApplicationArea = All;
                }
                field("Prefix Order No."; Rec."Prefix Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prefix Order No. field.', Comment = '%';
                }
                field("Website"; Rec."Website")
                {
                    ApplicationArea = All;
                }
                field("Shipping Account No."; Rec."Shipping Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shipping Account No. field.', Comment = '%';
                }
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