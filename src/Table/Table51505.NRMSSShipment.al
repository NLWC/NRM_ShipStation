table 51505 "NRM SS Shipment"
{
    Caption = 'ShipStation Shipment';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Shipment ID"; Code[50])
        {
            Caption = 'Shipment ID';
            DataClassification = SystemMetadata;
        }
        field(2; "External Shipment ID"; Text[100])
        {
            Caption = 'External Shipment ID';
            DataClassification = SystemMetadata;
        }
        field(3; "Shipment Status"; Enum "NRM SS Shipment Status")
        {
            Caption = 'Shipment Status';
            DataClassification = SystemMetadata;
        }
        field(4; "Ship Date"; Text[30])
        {
            Caption = 'Ship Date';
            DataClassification = SystemMetadata;
        }
        field(6; "Ship To Name"; Text[100])
        {
            Caption = 'Ship To Name';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(7; "Ship To Address 1"; Text[250])
        {
            Caption = 'Ship To Address 1';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(8; "Ship To City"; Text[50])
        {
            Caption = 'Ship To City';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(9; "Ship To State"; Text[50])
        {
            Caption = 'Ship To State';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(10; "Ship To Postal Code"; Text[20])
        {
            Caption = 'Ship To Postal Code';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(11; "Ship To Country"; Text[10])
        {
            Caption = 'Ship To Country';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(12; "Carrier ID"; Text[50])
        {
            Caption = 'Carrier ID';
            DataClassification = SystemMetadata;
        }
        field(13; "Service Code"; Text[50])
        {
            Caption = 'Service Code';
            DataClassification = SystemMetadata;
        }
        field(14; Email; Text[300])
        {
            Caption = 'Email';
            DataClassification = SystemMetadata;
        }
        field(15; "Store ID"; Text[20])
        {
            Caption = 'Store ID';
            DataClassification = SystemMetadata;
        }
        field(16; "Ship To Address 2"; Text[250])
        {
            Caption = 'Ship To Address 2';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(17; "Ship To Address 3"; Text[250])
        {
            Caption = 'Ship To Address 3';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(18; Phone; Text[30])
        {
            Caption = 'Phone';
            DataClassification = SystemMetadata;
            ExtendedDatatype = PhoneNo;
        }
        field(19; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = SystemMetadata;
            DecimalPlaces = 2 : 2;
        }
        field(20; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';
            DataClassification = SystemMetadata;
            DecimalPlaces = 2 : 2;
        }
        field(21; "Shipping Amount"; Decimal)
        {
            Caption = 'Shipping Amount';
            DataClassification = SystemMetadata;
            DecimalPlaces = 2 : 2;
        }
        field(22; "Requested Shipment Service"; Text[50])
        {
            Caption = 'Requested Shipment Service';
            DataClassification = SystemMetadata;
        }
        field(23; "Ship by Date"; Text[30])
        {
            Caption = 'Ship by Date';
            DataClassification = SystemMetadata;
        }
        field(24; "Store Name"; Text[100])
        {
            Caption = 'Store Name';
            FieldClass = FlowField;
            CalcFormula = Lookup("NRM SS Store"."Store Name" where("Store ID" = field("Store ID")));
            Editable = false;
        }
        field(25; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."No." where("Document Type" = const(Order), "NRM ShipStation Id" = field("Shipment ID")));
            Editable = false;
        }
        field(26; "Posted Invoice No."; Code[20])
        {
            Caption = 'Posted Invoice No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Invoice Header"."No." where("NRM ShipStation Id" = field("Shipment ID")));
            Editable = false;
        }
        field(27; "Created At"; Text[30])
        {
            Caption = 'Created At';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Shipment ID")
        {
            Clustered = true;
        }
        key(StoreId; "Store ID") { }
    }
}