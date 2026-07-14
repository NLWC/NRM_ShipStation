table 51510 "NRM SS Item"
{
    Caption = 'ShipStation Item';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Store ID"; Text[100])
        {
            Caption = 'Store ID';
            DataClassification = SystemMetadata;
        }
        field(2; SKU; Text[100])
        {
            Caption = 'SKU';
            DataClassification = SystemMetadata;
        }
        field(3; Name; Text[200])
        {
            Caption = 'Name';
            DataClassification = SystemMetadata;
        }
        field(4; "Image URL"; Text[500])
        {
            Caption = 'Image URL';
            DataClassification = SystemMetadata;
        }
        field(5; "Product ID"; Integer)
        {
            Caption = 'Product ID';
            DataClassification = SystemMetadata;
        }
        field(6; "Fulfillment SKU"; Text[100])
        {
            Caption = 'Fulfillment SKU';
            DataClassification = SystemMetadata;
        }
        field(7; "Upc"; Text[50])
        {
            Caption = 'UPC';
            DataClassification = SystemMetadata;
        }
        field(8; "Weight Value"; Decimal)
        {
            Caption = 'Weight Value';
            DataClassification = SystemMetadata;
            DecimalPlaces = 0 : 3;
        }
        field(9; "Weight Units"; Text[10])
        {
            Caption = 'Weight Units';
            DataClassification = SystemMetadata;
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = SystemMetadata;
            TableRelation = Item;
        }
        field(11; Status; Enum "NRM SS Item Status")
        {
            Caption = 'Status';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Store ID", SKU)
        {
            Clustered = true;
        }
        key(ProductID; "Product ID") { }
        key(Status; Status, "Item No.") { }
    }
}