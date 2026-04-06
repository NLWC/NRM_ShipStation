page 51501 "NRM SS Shipments"
{
    Caption = 'ShipStation Shipments';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "NRM SS Shipment";
    CardPageId = "NRM SS Shipment Card";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
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
                field("Ship To Name"; Rec."Ship To Name")
                {
                    ToolTip = 'Specifies the recipient name.';
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the email address of the recipient.';
                }
                field("Store ID"; Rec."Store ID")
                {
                    ToolTip = 'Specifies the store ID from ShipStation.';
                }
                field("Ship To Address 1"; Rec."Ship To Address 1")
                {
                    ToolTip = 'Specifies the recipient address 1.';
                }
                field("Ship To Address 2"; Rec."Ship To Address 2")
                {
                    ToolTip = 'Specifies the recipient address 2.';
                }
                field("Ship To Address 3"; Rec."Ship To Address 3")
                {
                    ToolTip = 'Specifies the recipient address 3.';
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
                field("Carrier ID"; Rec."Carrier ID")
                {
                    ToolTip = 'Specifies the carrier ID for this shipment.';
                }
                field("Service Code"; Rec."Service Code")
                {
                    ToolTip = 'Specifies the service code used for shipping.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SyncShipments)
            {
                Caption = 'Sync Shipments';
                Image = Refresh;
                ToolTip = 'Synchronize shipments from ShipStation API.';

                trigger OnAction()
                var
                    NRMSSStore: Record "NRM SS Store";
                    ShipStationAPIV2: Codeunit "NRM ShipStation API v2";
                    PageNo, TotalPages : Integer;
                begin
                    PageNo := 0;
                    TotalPages := 0;
                    NRMSSStore.SetRange(Active, true);
                    NRMSSStore.SetRange(Blocked, false);
                    if NRMSSStore.FindSet() then
                        repeat
                            repeat
                                PageNo += 1;
                                ShipStationAPIV2.GetShipments(Rec, PageNo, 100, Format(Enum::"NRM SS Shipment Status"::pending), '', '', NRMSSStore."Store ID", TotalPages);
                            until PageNo >= TotalPages;
                        until NRMSSStore.Next() = 0;
                    Message('Shipments synchronized successfully.');
                end;
            }
            action(GetShipmentByID)
            {
                Caption = 'Get Shipment by ID';
                ApplicationArea = All;
                Image = Find;
                ToolTip = 'Retrieve a specific shipment by its ShipStation shipment ID.';

                trigger OnAction()
                var
                    TempShipment: Record "NRM SS Shipment" temporary;
                    ShipStationAPIV2: Codeunit "NRM ShipStation API v2";
                begin
                    ShipStationAPIV2.GetShipmentById(Rec."External Shipment ID", TempShipment);
                    if TempShipment.FindFirst() then begin
                        Rec := TempShipment;
                        Rec.Modify();
                        Message('Shipment refreshed successfully.');
                    end else
                        Message('Failed to refresh shipment details.');
                end;
            }
            action(CreateSalesOrder)
            {
                Caption = 'Create Sales Order';
                ApplicationArea = All;
                Image = Sales;
                ToolTip = 'Create a sales order from the shipment.';

                trigger OnAction()
                var
                    ShipStationMgt: Codeunit "NRM ShipStation Management";
                    CustomerNo: Code[20];
                    SalesOrderNo: Code[20];
                begin
                    if ShipStationMgt.CreateSalesOrderFromShipStation(Rec, CustomerNo, SalesOrderNo) then
                        Message('Sales order created successfully.')
                    else
                        Message(GetLastErrorText);
                end;
            }
            action(Items)
            {
                Caption = 'Items';
                ApplicationArea = All;
                Image = ItemAvailability;
                ToolTip = 'View the list of items for the shipment.';
                RunObject = page "NRM SS Items";
            }
        }
        area(Promoted)
        {
            group(Process)
            {
                Caption = 'Process';

                actionref(SyncShipments_Promoted; SyncShipments) { }
                actionref(GetShipmentByID_Promoted; GetShipmentByID) { }
                actionref(CreateSalesOrder_Promoted; CreateSalesOrder) { }
                actionref(Items_Promoted; Items) { }
            }
        }
    }
}