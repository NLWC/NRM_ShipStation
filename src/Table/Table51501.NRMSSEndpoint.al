table 51501 "NRM SS Endpoint"
{
    Caption = 'ShipStation Endpoints';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = SystemMetadata;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(3; "Endpoint Path"; Text[250])
        {
            Caption = 'Endpoint Path';
            DataClassification = SystemMetadata;
        }
        field(4; "HTTP Method"; Enum "NRM SS HTTP Method")
        {
            Caption = 'HTTP Method';
            DataClassification = SystemMetadata;
        }
        field(5; Enabled; Boolean)
        {
            Caption = 'Enabled';
            DataClassification = SystemMetadata;
            InitValue = true;
        }
        // field(6; "Requires Authentication"; Boolean)
        // {
        //     Caption = 'Requires Authentication';
        //     DataClassification = SystemMetadata;
        //     InitValue = true;
        // }
        // field(7; "Response Cache Minutes"; Integer)
        // {
        //     Caption = 'Response Cache Minutes';
        //     DataClassification = SystemMetadata;
        //     MinValue = 0;
        //     MaxValue = 1440; // 24 hours
        // }
        // field(8; "Rate Limit Per Minute"; Integer)
        // {
        //     Caption = 'Rate Limit Per Minute';
        //     DataClassification = SystemMetadata;
        //     MinValue = 0;
        // }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}