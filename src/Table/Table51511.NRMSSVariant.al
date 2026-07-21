table 51511 "NRM SS Variant"
{
    Caption = 'ShipStation Variant';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; SKU; Text[100])
        {
            Caption = 'SKU';
            DataClassification = SystemMetadata;
        }
        field(2; "Option"; Text[250])
        {
            Caption = 'Option';
            DataClassification = SystemMetadata;
        }
        field(3; Name; Text[200])
        {
            Caption = 'Name';
            DataClassification = SystemMetadata;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = SystemMetadata;
            TableRelation = Item;
        }
        field(5; Variant; Code[10])
        {
            Caption = 'Variant';
            DataClassification = SystemMetadata;
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(6; Status; Enum "NRM SS Item Status")
        {
            Caption = 'Status';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if (xRec.Status = Status) or (Status <> Status::Active) then exit;

                TestField("Item No.");
                TestField(Variant);
            end;
        }
        field(7; "Image URL"; Text[500])
        {
            Caption = 'Image URL';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; SKU, "Option")
        {
            Clustered = true;
        }
        key(Status; Status) { }
    }
}