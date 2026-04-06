tableextension 51500 "NRM Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(51500; "NRM ShipStation Id"; Code[50])
        {
            Caption = 'ShipStation ID';
            DataClassification = SystemMetadata;
            TableRelation = "NRM SS Shipment"."Shipment ID";
        }
        field(51501; "NRM ShipStation Amount"; Decimal)
        {
            Caption = 'ShipStation Amount';
            DataClassification = SystemMetadata;
            DecimalPlaces = 2 : 2;
        }
        field(51502; "NRM ShipStation Shipping"; Decimal)
        {
            Caption = 'ShipStation Shipping';
            DataClassification = SystemMetadata;
            DecimalPlaces = 2 : 2;
        }
        field(51503; "NRM ShipStation Tax"; Decimal)
        {
            Caption = 'ShipStation Tax';
            DataClassification = SystemMetadata;
            DecimalPlaces = 2 : 2;
        }
    }
}