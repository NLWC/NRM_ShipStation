enum 51500 "NRM SS HTTP Method"
{
    Caption = 'ShipStation HTTP Method';
    Extensible = true;

    value(0; GET)
    {
        Caption = 'GET';
    }
    value(1; POST)
    {
        Caption = 'POST';
    }
    value(2; PUT)
    {
        Caption = 'PUT';
    }
    value(3; DELETE)
    {
        Caption = 'DELETE';
    }
    value(4; PATCH)
    {
        Caption = 'PATCH';
    }
}