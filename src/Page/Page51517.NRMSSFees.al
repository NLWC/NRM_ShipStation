page 51517 "NRM SS Fees"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "NRM SS Fee";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Order Total %"; Rec."Order Total %")
                {
                    ToolTip = 'Specifies the value of the Order Total % field.', Comment = '%';
                }
                field("Item Total %"; Rec."Item Total %")
                {
                    ToolTip = 'Specifies the value of the Item Total % field.', Comment = '%';
                }
                field("Shipping Total %"; Rec."Shipping Total %")
                {
                    ToolTip = 'Specifies the value of the Shipping Total % field.', Comment = '%';
                }
                field(Constant; Rec.Constant)
                {
                    ToolTip = 'Specifies the value of the Constant field.', Comment = '%';
                }
                field("County Delivery"; Rec."County Delivery")
                {
                    ToolTip = 'Specifies the value of the County Delivery field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                }
            }
        }
    }
}