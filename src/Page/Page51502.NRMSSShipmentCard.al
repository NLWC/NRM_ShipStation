page 51502 "NRM SS Shipment Card"
{
    Caption = 'Shipment Card';
    PageType = Document;
    SourceTable = "NRM SS Shipment";
    InsertAllowed = false;
    ModifyAllowed = false;
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
                Caption = 'General';

                field("Shipment ID"; Rec."Shipment ID")
                {
                    ToolTip = 'Specifies the unique shipment identifier from ShipStation.';
                }
                field("External Shipment ID"; Rec."External Shipment ID")
                {
                    ToolTip = 'Specifies the external shipment identifier.';
                }
                field("Requested Shipment Service"; Rec."Requested Shipment Service")
                {
                    ToolTip = 'Specifies the requested shipment service.';
                }
                field("Shipment Status"; Rec."Shipment Status")
                {
                    ToolTip = 'Specifies the current status of the shipment.';
                }
                field("Ship Date"; Rec."Ship Date")
                {
                    ToolTip = 'Specifies the date when the shipment was shipped.';
                }
                field("Ship by Date"; Rec."Ship by Date")
                {
                    ToolTip = 'Specifies the value of the Ship by Date field.', Comment = '%';
                }
                field("Created At"; Rec."Created At")
                {
                    ToolTip = 'Specifies the value of the Created At field.', Comment = '%';
                }
                field("Carrier ID"; Rec."Carrier ID")
                {
                    ToolTip = 'Specifies the carrier ID for this shipment.';
                }
                field("Service Code"; Rec."Service Code")
                {
                    ToolTip = 'Specifies the service code used for shipping.';
                }
            }
            part(ShipmentLines; "NRM SS Shipment Lines")
            {
                Caption = 'Shipment Lines';
                SubPageLink = "Shipment ID" = field("Shipment ID");
            }
            group(Paid)
            {
                Caption = 'Paid';

                field("Shipping Amount"; Rec."Shipping Amount")
                {
                    ToolTip = 'Specifies the shipping amount paid for the shipment.';
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ToolTip = 'Specifies the tax amount paid for the shipment.';
                }
                field("Amount"; Rec.Amount)
                {
                    ToolTip = 'Specifies the amount paid for the shipment.';
                }
            }
            group("Ship To")
            {
                Caption = 'Ship To Address';

                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the email address of the recipient.';
                }
                field(Phone; Rec.Phone)
                {
                    ToolTip = 'Specifies the value of the Phone field.', Comment = '%';
                }

                field("Store ID"; Rec."Store ID")
                {
                    ToolTip = 'Specifies the store ID from ShipStation.';
                }
                field("Store Name"; Rec."Store Name")
                {
                    ToolTip = 'Specifies the value of the Store Name field.', Comment = '%';
                }
                field("Ship To Name"; Rec."Ship To Name")
                {
                    ToolTip = 'Specifies the recipient name.';
                }
                field("Ship To Address 1"; Rec."Ship To Address 1")
                {
                    ToolTip = 'Specifies the value of the Ship To Address 1 field.', Comment = '%';
                }
                field("Ship To Address 2"; Rec."Ship To Address 2")
                {
                    ToolTip = 'Specifies the value of the Ship To Address 2 field.', Comment = '%';
                }
                field("Ship To Address 3"; Rec."Ship To Address 3")
                {
                    ToolTip = 'Specifies the value of the Ship To Address field.', Comment = '%';
                }
                field("Ship To City"; Rec."Ship To City")
                {
                    ToolTip = 'Specifies the recipient city.';
                }
                field("Ship To State"; Rec."Ship To State")
                {
                    ToolTip = 'Specifies the recipient state/province.';
                }
                field("Ship To Postal Code"; Rec."Ship To Postal Code")
                {
                    ToolTip = 'Specifies the recipient postal code.';
                }
                field("Ship To Country"; Rec."Ship To Country")
                {
                    ToolTip = 'Specifies the recipient country.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RefreshShipment)
            {
                ApplicationArea = All;
                Caption = 'Refresh Shipment';
                Image = Refresh;
                ToolTip = 'Refresh the current shipment details from ShipStation.';

                trigger OnAction()
                var
                    TempShipment: Record "NRM SS Shipment" temporary;
                    ShipStationAPIV2: Codeunit "NRM ShipStation API v2";
                begin
                    if ShipStationAPIV2.GetShipmentById(Rec."External Shipment ID", TempShipment) then begin
                        Rec := TempShipment;
                        Rec.Modify();
                        Message('Shipment refreshed successfully.');
                    end else
                        Message('Failed to refresh shipment details.');
                end;
            }
        }
        area(Promoted)
        {
            actionref(RefreshShipment_Promoted; RefreshShipment) { }
        }
    }
}