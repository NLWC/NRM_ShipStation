enum 51502 "NRM SS Item Status"
{
    Caption = 'ShipStation Item Status';
    Extensible = true;

    value(0; Draft)
    {
        Caption = 'Draft';
    }
    value(1; Active)
    {
        Caption = 'Active';
    }
    value(2; Archived)
    {
        Caption = 'Archived';
    }
}