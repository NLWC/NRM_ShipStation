table 51512 "NRM SS Fee"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Store ID"; Code[20])
        {
            Caption = 'Store ID';
            DataClassification = SystemMetadata;
            TableRelation = "NRM SS Store"."Store ID";
        }
        field(2; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = SystemMetadata;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(4; "Order Total %"; Decimal)
        {
            Caption = 'Order Total %';
            DataClassification = SystemMetadata;
        }
        field(5; "Item Total %"; Decimal)
        {
            Caption = 'Item Total %';
            DataClassification = SystemMetadata;
        }
        field(6; "Shipping Total %"; Decimal)
        {
            Caption = 'Shipping Total %';
            DataClassification = SystemMetadata;
        }
        field(7; Constant; Decimal)
        {
            Caption = 'Constant';
            DataClassification = SystemMetadata;
        }
        field(8; "County Delivery"; Code[10])
        {
            Caption = 'County Delivery';
            DataClassification = SystemMetadata;
        }
        field(9; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = SystemMetadata;
        }
        field(10; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = SystemMetadata;
            TableRelation = "G/L Account" where("Account Type" = const(Posting), "Blocked" = const(false));
        }
    }

    keys
    {
        key(PK; "Store ID", Code)
        {
            Clustered = true;
        }
    }
}