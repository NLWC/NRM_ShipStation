page 51505 "NRM SS Stores"
{
    Caption = 'ShipStation Stores';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "NRM SS Store";
    CardPageId = "NRM SS Store Card";
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    InsertAllowed = false;
    RefreshOnActivate = true;
    SourceTableView = sorting(Active, "Store Name") order(descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Store ID"; Rec."Store ID")
                {
                    ApplicationArea = All;
                }
                field("Store Name"; Rec."Store Name")
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
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