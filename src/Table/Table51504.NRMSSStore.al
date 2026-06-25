table 51504 "NRM SS Store"
{
    Caption = 'ShipStation Store';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Store ID"; Code[20])
        {
            Caption = 'Store ID';
            DataClassification = SystemMetadata;
        }
        field(2; "Store Name"; Text[100])
        {
            Caption = 'Store Name';
            DataClassification = SystemMetadata;
        }
        field(3; "Marketplace Name"; Text[50])
        {
            Caption = 'Marketplace Name';
            DataClassification = SystemMetadata;
        }
        field(4; "Account Name"; Text[100])
        {
            Caption = 'Account Name';
            DataClassification = SystemMetadata;
        }
        field(5; Active; Boolean)
        {
            Caption = 'Active';
            DataClassification = SystemMetadata;
        }
        field(6; "Customer Template Code"; Code[20])
        {
            Caption = 'Customer Template Code';
            TableRelation = "Customer Templ.";
            DataClassification = SystemMetadata;
        }
        field(7; "Customer Prefix"; Code[10])
        {
            Caption = 'Customer Prefix';
            DataClassification = SystemMetadata;
        }
        field(8; Website; Text[250])
        {
            Caption = 'Website';
            DataClassification = SystemMetadata;
        }
        field(9; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = SystemMetadata;
        }
        field(10; "Prefix Order No."; Code[10])
        {
            Caption = 'Prefix Order No.';
            DataClassification = SystemMetadata;
        }
        field(11; "Shipping Account No."; Code[20])
        {
            Caption = 'Shipping Account No.';
            DataClassification = SystemMetadata;
            TableRelation = "G/L Account" where("Account Type" = const(Posting), "Blocked" = const(false));
        }
        field(12; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            DataClassification = SystemMetadata;
            TableRelation = "Gen. Journal Template".Name;
        }
        field(13; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = SystemMetadata;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(14; "Clearing Account No."; Code[20])
        {
            Caption = 'Clearing Account No.';
            DataClassification = SystemMetadata;
            TableRelation = "G/L Account" where("Account Type" = const(Posting), "Blocked" = const(false));
        }
        field(15; "Colorado Fee Code"; Code[20])
        {
            Caption = 'Colorado Fee Code';
            TableRelation = "NRM SS Fee"."Code" where("Store ID" = field("Store ID"));
            DataClassification = SystemMetadata;
        }
        field(16; "Tax Account No."; Code[20])
        {
            Caption = 'Tax Account No.';
            DataClassification = SystemMetadata;
            TableRelation = "G/L Account" where("Account Type" = const(Posting), "Blocked" = const(false));
        }
    }

    keys
    {
        key(PK; "Store ID")
        {
            Clustered = true;
        }
        key(Active; Active, "Store Name") { }
    }
}