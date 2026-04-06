page 51500 "NRM SS Setup"
{
    Caption = 'ShipStation Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "NRM ShipStation Setup";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                group(APIv1)
                {
                    Caption = 'ShipStation API v1';
                    field("API v1 Key"; Rec."API v1 Key")
                    {
                        Caption = 'Key';
                        ToolTip = 'Specifies the value of the API v1 Key field.', Comment = '%';
                    }
                    field("API Secret"; Rec."API Secret")
                    {
                        Caption = 'Secret';
                        ToolTip = 'Specifies the value of the API Secret field.', Comment = '%';
                    }
                    field("API v1 Base URL"; Rec."API v1 Base URL")
                    {
                        Caption = 'Base URL';
                        ToolTip = 'The base URL for ShipStation API v1. Default is https://ssapi.shipstation.com';
                    }
                    field("Prefix Store Id"; Rec."Prefix Store Id")
                    {
                        Caption = 'Prefix Store Id';
                        ToolTip = 'Specifies the value of the Prefix Store Id field.', Comment = '%';
                    }
                }
                group(APIv2)
                {
                    Caption = 'ShipStation API v2';
                    field("API v2 Key"; Rec."API v2 Key")
                    {
                        Caption = 'Key';
                        ExtendedDatatype = Masked;
                        ToolTip = 'Enter your ShipStation API Key. You can find it in your ShipStation account settings.';
                    }
                    field("API v2 Base URL"; Rec."API v2 Base URL")
                    {
                        Caption = 'Base URL';
                        ToolTip = 'The base URL for ShipStation API v2. Default is https://api.shipstation.com';
                    }
                }
                group(Options)
                {
                    Caption = 'Options';
                    field("Tax G/L Account"; Rec."Tax Account No.")
                    {
                        ToolTip = 'Specifies the value of the Tax G/L Account field.', Comment = '%';
                    }
                    field("No Tax"; Rec."No Tax")
                    {
                        ToolTip = 'Specifies the value of the No Tax field.', Comment = '%';
                    }
                    field(Enabled; Rec.Enabled)
                    {
                        ToolTip = 'Enable or disable the ShipStation integration.';
                    }
                }
            }
            part(Endpoints; "NRM SS Endpoints Subpage")
            {
                Caption = 'API Endpoints';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Stores)
            {
                Caption = 'Stores';
                ApplicationArea = All;
                Image = WarehouseSetup;
                ToolTip = 'View the list of stores.';
                RunObject = page "NRM SS Stores";
            }
            action(Shipments)
            {
                Caption = 'Shipments';
                ApplicationArea = All;
                Image = NewWarehouseShipment;
                ToolTip = 'View the list of shipments.';
                RunObject = page "NRM SS Shipments";
            }
            action(Items)
            {
                Caption = 'Items';
                ApplicationArea = All;
                Image = ItemAvailability;
                ToolTip = 'View the list of items.';
                RunObject = page "NRM SS Items";
            }
        }
        area(Promoted)
        {
            group(Home)
            {
                Caption = 'Home';

                actionref("Stores_Promoted"; Stores) { }
                actionref("Shipments_Promoted"; Shipments) { }
                actionref("Items_Promoted"; Items) { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        InitRecord();
    end;

    local procedure InitRecord()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}