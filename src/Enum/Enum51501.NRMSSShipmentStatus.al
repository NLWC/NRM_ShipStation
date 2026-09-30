enum 51501 "NRM SS Shipment Status"
{
    Caption = 'Shipment Status';
    Extensible = true;

    value(0; pending)
    {
        Caption = 'Pending';
    }
    value(1; processing)
    {
        Caption = 'Processing';
    }
    value(2; label_purchased)
    {
        Caption = 'Label Purchased';
    }
    value(3; cancelled)
    {
        Caption = 'Cancelled';
    }
    value(4; on_hold)
    {
        Caption = 'On Hold';
    }
    value(5; shipped)
    {
        Caption = 'Shipped';
    }
    value(6; delivered)
    {
        Caption = 'Delivered';
    }
    value(7; returned)
    {
        Caption = 'Returned';
    }
    value(8; voided)
    {
        Caption = 'Voided';
    }
}