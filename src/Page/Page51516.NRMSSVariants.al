page 51516 "NRM SS Variants"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "NRM SS Variant";

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
                field("Option"; Rec."Option")
                {
                    ToolTip = 'Specifies the value of the Option field.', Comment = '%';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                    Editable = false;
                    Visible = false;
                }
                field(Variant; Rec.Variant)
                {
                    ToolTip = 'Specifies the value of the Variant field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
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
        }
    }
}