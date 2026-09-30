page 51513 "NRM SS Shipment Lines"
{
    Caption = 'Shipment Lines';
    PageType = ListPart;
    SourceTable = "NRM SS Shipment Line";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line Item Key"; Rec."Line Item Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for this line item.';
                }
                field(SKU; Rec.SKU)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Stock Keeping Unit (SKU) of the item.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the item.';
                }
                field("Image URL"; Rec."Image URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the URL of the item image.';
                    ExtendedDatatype = URL;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of the item in this shipment.';
                }
                field("Unit Price Amount"; Rec."Unit Price Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit price of the item.';
                    BlankZero = true;
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tax amount for this item.';
                    BlankZero = true;
                }
                field("Shipping Amount"; Rec."Shipping Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shipping amount for this item.';
                    BlankZero = true;
                }
                field("Product ID"; Rec."Product ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the product ID from the marketplace.';
                }
                field("Fulfillment SKU"; Rec."Fulfillment SKU")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the fulfillment SKU.';
                }
                field("Warehouse Location"; Rec."Warehouse Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the warehouse location for this item.';
                }
                field("Weight Value"; Rec."Weight Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the weight value of the item.';
                    BlankZero = true;
                }
                field("Weight Units"; Rec."Weight Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the weight units (e.g., ounce, pound).';
                }
                field(Option; Rec.Option)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item options (e.g., size, color).';
                }
                field(Upc; Rec.Upc)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Universal Product Code (UPC).';
                }
                field(Adjustment; Rec.Adjustment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if this is an adjustment item (like discount).';
                }
            }
        }
    }
}