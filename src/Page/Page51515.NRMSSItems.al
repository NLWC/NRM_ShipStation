page 51515 "NRM SS Items"
{
    PageType = List;
    Caption = 'ShipStation Items';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "NRM SS Item";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {

                field(SKU; Rec.SKU)
                {
                    ToolTip = 'Specifies the value of the SKU field.', Comment = '%';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';

                    trigger OnValidate()
                    begin
                        ItemNoOnValidate();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                    Editable = false;
                }
                field("Product ID"; Rec."Product ID")
                {
                    ToolTip = 'Specifies the value of the Product ID field.', Comment = '%';
                    Editable = false;
                }
                field("Fulfillment SKU"; Rec."Fulfillment SKU")
                {
                    ToolTip = 'Specifies the value of the Fulfillment SKU field.', Comment = '%';
                    Editable = false;
                }
                field(Upc; Rec.Upc)
                {
                    ToolTip = 'Specifies the value of the UPC field.', Comment = '%';
                    Editable = false;
                }
                field("Weight Units"; Rec."Weight Units")
                {
                    ToolTip = 'Specifies the value of the Weight Units field.', Comment = '%';
                    Editable = false;
                }
                field("Weight Value"; Rec."Weight Value")
                {
                    ToolTip = 'Specifies the value of the Weight Value field.', Comment = '%';
                    Editable = false;
                }
                field("Image URL"; Rec."Image URL")
                {
                    ToolTip = 'Specifies the value of the Image URL field.', Comment = '%';
                    Editable = false;
                    ExtendedDatatype = URL;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
            }
            part(Variants; "NRM SS Variants")
            {
                Caption = 'Variants';
                SubPageLink = SKU = field(SKU);
            }
        }
    }

    local procedure ItemNoOnValidate()
    var
        SSVariant: Record "NRM SS Variant";
    begin
        SSVariant.SetRange(SKU, Rec.SKU);
        SSVariant.ModifyAll("Item No.", Rec."Item No.");
        SSVariant.ModifyAll(Status, Enum::"NRM SS Item Status"::Draft);
        SSVariant.ModifyAll(Variant, '');
    end;
}