tableextension 51501 "NRM Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(51500; "NRM ShipStation Id"; Code[50])
        {
            Caption = 'ShipStation ID';
            DataClassification = SystemMetadata;
            TableRelation = "NRM SS Shipment"."Shipment ID";
        }
    }
}