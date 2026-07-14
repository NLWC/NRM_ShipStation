pageextension 51500 "NRM Sales Tax Journal Ext" extends "Sales Tax Journal"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1030011)
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
            }
        }
    }
}