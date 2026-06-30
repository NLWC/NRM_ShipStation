tableextension 51502 "NRM Sales Line Ext" extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here
        modify("Unit Cost (LCY)")
        {
            trigger OnAfterValidate()
            begin
                UnitCostLCYOnAfterValidate();
            end;
        }
    }

    local procedure UnitCostLCYOnAfterValidate()
    begin
        if "Unit Cost (LCY)" <> xRec."Unit Cost (LCY)" then
            ShipStationMgt.CreateGenJnlLineByUnitCostLCYOnAfterValidate(Rec);
    end;

    var
        ShipStationMgt: Codeunit "NRM ShipStation Management";
}