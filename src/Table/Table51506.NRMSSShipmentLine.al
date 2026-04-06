table 51506 "NRM SS Shipment Line"
{
    Caption = 'SS Shipment Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Shipment ID"; Code[50])
        {
            Caption = 'Shipment ID';
            DataClassification = SystemMetadata;
        }
        field(2; "Line Item Key"; Text[100])
        {
            Caption = 'Line Item Key';
            DataClassification = SystemMetadata;
        }
        field(4; SKU; Text[100])
        {
            Caption = 'SKU';
            DataClassification = SystemMetadata;
        }
        field(5; Name; Text[200])
        {
            Caption = 'Name';
            DataClassification = SystemMetadata;
        }
        field(6; "Image URL"; Text[500])
        {
            Caption = 'Image URL';
            DataClassification = SystemMetadata;
        }
        field(7; "Quantity"; Integer)
        {
            Caption = 'Quantity';
            DataClassification = SystemMetadata;
        }
        field(8; "Unit Price Currency"; Text[3])
        {
            Caption = 'Unit Price Currency';
            DataClassification = SystemMetadata;
        }
        field(9; "Unit Price Amount"; Decimal)
        {
            Caption = 'Unit Price Amount';
            DataClassification = SystemMetadata;
            DecimalPlaces = 2 : 2;
        }
        field(10; "Tax Amount Currency"; Text[3])
        {
            Caption = 'Tax Amount Currency';
            DataClassification = SystemMetadata;
        }
        field(11; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';
            DataClassification = SystemMetadata;
            DecimalPlaces = 2 : 2;
        }
        field(12; "Shipping Amount Currency"; Text[3])
        {
            Caption = 'Shipping Amount Currency';
            DataClassification = SystemMetadata;
        }
        field(13; "Shipping Amount"; Decimal)
        {
            Caption = 'Shipping Amount';
            DataClassification = SystemMetadata;
            DecimalPlaces = 2 : 2;
        }
        field(14; "Warehouse Location"; Text[100])
        {
            Caption = 'Warehouse Location';
            DataClassification = SystemMetadata;
        }
        field(15; "Product ID"; Integer)
        {
            Caption = 'Product ID';
            DataClassification = SystemMetadata;
        }
        field(16; "Fulfillment SKU"; Text[100])
        {
            Caption = 'Fulfillment SKU';
            DataClassification = SystemMetadata;
        }
        field(17; "Adjustment"; Boolean)
        {
            Caption = 'Adjustment';
            DataClassification = SystemMetadata;
        }
        field(18; "Upc"; Text[50])
        {
            Caption = 'UPC';
            DataClassification = SystemMetadata;
        }
        field(21; "Weight Value"; Decimal)
        {
            Caption = 'Weight Value';
            DataClassification = SystemMetadata;
            DecimalPlaces = 0 : 3;
        }
        field(22; "Weight Units"; Text[10])
        {
            Caption = 'Weight Units';
            DataClassification = SystemMetadata;
        }
        field(23; "Option"; Text[250])
        {
            Caption = 'Option';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Shipment ID", "Line Item Key")
        {
            Clustered = true;
        }
        key(SKU; SKU) { }
        key(ProductID; "Product ID") { }
    }
}