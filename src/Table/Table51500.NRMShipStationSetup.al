table 51500 "NRM ShipStation Setup"
{
    Caption = 'ShipStation Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "API v2 Key"; Text[250])
        {
            Caption = 'API v2 Key';
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = Masked;
        }
        field(3; "API v2 Base URL"; Text[250])
        {
            Caption = 'API v2 Base URL';
            DataClassification = SystemMetadata;
        }
        field(4; Enabled; Boolean)
        {
            Caption = 'Enabled';
            DataClassification = SystemMetadata;
        }
        field(5; "Tax Account No."; Code[20])
        {
            Caption = 'Tax Account No.';
            DataClassification = SystemMetadata;
            TableRelation = "G/L Account" where("Account Type" = const(Posting), "Blocked" = const(false));
        }
        field(6; "No Tax"; Boolean)
        {
            Caption = 'No Tax';
            DataClassification = SystemMetadata;
        }
        field(7; "API v1 Key"; Text[250])
        {
            Caption = 'API v1 Key';
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = Masked;
        }
        field(8; "API Secret"; Text[250])
        {
            Caption = 'API Secret';
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = Masked;
        }
        field(9; "API v1 Base URL"; Text[250])
        {
            Caption = 'API v1 Base URL';
            DataClassification = SystemMetadata;
        }
        field(10; "Tax Description"; Text[100])
        {
            Caption = 'Tax Description';
            DataClassification = SystemMetadata;
        }
        field(11; "Prefix Store Id"; Code[10])
        {
            Caption = 'Prefix Store Id';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        "API v2 Base URL" := 'https://api.shipstation.com';
    end;
}