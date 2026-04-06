codeunit 51502 "NRM ShipStation Management"
{
    trigger OnRun()
    begin

    end;

    [TryFunction]
    internal procedure CreateSalesOrderFromShipStation(var xShipStationShipment: Record "NRM SS Shipment";
                                                    var xCustomerNo: Code[20];
                                                    var xSalesOrderNo: Code[20])
    var
        SSShipmentLine: Record "NRM SS Shipment Line";
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        LastErrorText: Text;
        LineNo: Integer;
    begin
        FindShipStationSalesOrder(xShipStationShipment);

        xCustomerNo := '';
        if not CreateCustomerFromShipStation(xShipStationShipment, Customer) then
            Error(GetLastErrorText());

        CreateSalesOrderNo(SalesHeader);

        if not UpdateUnivermagSalesOrder(xShipStationShipment, Customer, SalesHeader) then begin
            LastErrorText := GetLastErrorText();
            SalesHeader.Delete(true);
            Error(LastErrorText);
        end;
        SalesHeader.Modify(true);

        LineNo := 10000;
        SSShipmentLine.SetRange("Shipment ID", xShipStationShipment."Shipment ID");
        SSShipmentLine.SetFilter(SKU, '<>%1', '');
        if SSShipmentLine.FindSet() then
            repeat
                // create sales lines
                SalesLine.Init();
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := LineNo;

                if not UpdateShipStationSalesOrderLines(SSShipmentLine, SalesLine, xShipStationShipment."Store ID") then begin
                    LastErrorText := GetLastErrorText();
                    SalesHeader.Delete(true);
                    Error(LastErrorText);
                end;
                SalesLine.Insert(true);
                LineNo += 10000;
            until SSShipmentLine.Next() = 0;

        UpdateShipStationSalesOrderDiscount(SalesHeader);
        UpdateShipStationSalesOrderShippingLine(xShipStationShipment, SalesHeader, LineNo);
        UpdateShipStationSalesOrderTaxLine(SalesHeader, LineNo);
        UpdateShipStationSalesOrderChargeLineFromShippingAgentCode(xShipStationShipment, SalesHeader, LineNo);
        xCustomerNo := Customer."No.";
        xSalesOrderNo := SalesHeader."No.";
    end;

    internal procedure CreateCustomerFromShipStation(xShipStationShipment: Record "NRM SS Shipment";
                                                     var xCustomer: Record Customer): Boolean
    var
        CustomerTemplate: Record "Customer Templ.";
        CustomerTemplMgt: Codeunit "Customer Templ. Mgt.";
        IsHandled, IsNew : Boolean;
    begin
        if xShipStationShipment.Email = '' then Error(EmptyEmailErr);

        GetSSStore(xShipStationShipment."Store ID");
        SSStore.TestField("Customer Template Code");
        SSStore.TestField("Customer Prefix");

        xCustomer.ReadIsolation(IsolationLevel::ReadUncommitted);
        xCustomer.SetCurrentKey("No.", "E-Mail");
        xCustomer.SetFilter("No.", '@' + SSStore."Customer Prefix" + '*');
        xCustomer.SetRange("E-Mail", xShipStationShipment.Email);
        if not xCustomer.FindFirst() then begin
            IsNew := true;
            if not CustomerTemplate.Get(SSStore."Customer Template Code") then exit;
            CustomerTemplMgt.CreateCustomerFromTemplate(xCustomer, IsHandled, CustomerTemplate.Code);
        end;

        if CustomerFromShipStationOnUpdate(xCustomer, xShipStationShipment) then
            exit(xCustomer.Modify(true));

        if IsNew then
            xCustomer.Delete(true);
        exit(false);
    end;

    local procedure GetSSStore(xStoreId: Text[20])
    begin
        if xStoreId = OldStoreId then exit;
        OldStoreId := xStoreId;

        if not SSStore.Get(xStoreId) then begin
            SSStore.Init();
            SSStore."Store ID" := xStoreId;
            SSStore.Insert();
        end;
    end;

    local procedure GetShipStationSetup()
    begin
        if ShipStationSetupRead then exit;
        ShipStationSetupRead := true;

        if not ShipStationSetup.Get() then begin
            ShipStationSetup.Init();
            ShipStationSetup.Insert();
        end;
    end;

    [TryFunction]
    local procedure CustomerFromShipStationOnUpdate(var Customer: Record Customer;
                                                  xShipStationShipment: Record "NRM SS Shipment")
    var
        AddressText: Text;
    begin
        if xShipStationShipment."Ship To Name" = '' then
            Error('Ship To Name is empty not allowed!');
        Customer.Validate(Name, xShipStationShipment."Ship To Name");

        if xShipStationShipment.Phone <> '' then
            Customer.Validate("Mobile Phone No.", xShipStationShipment.Phone);

        Customer.Validate("E-Mail", xShipStationShipment.Email);

        AddressText := StrSubstNo('%1%2%3', xShipStationShipment."Ship To Address 1", xShipStationShipment."Ship To Address 2", xShipStationShipment."Ship To Address 3");
        Customer.Validate(Address, CopyStr(AddressText, 1, MaxStrLen(Customer.Address)));
        if MaxStrLen(Customer.Address) < StrLen(AddressText) then
            Customer.Validate("Address 2", CopyStr(AddressText, MaxStrLen(Customer.Address) + 1, MaxStrLen(Customer."Address 2")));

        Customer.Validate(City, xShipStationShipment."Ship To City");
        Customer.Validate(County, xShipStationShipment."Ship To State");
        Customer.Validate("Country/Region Code", xShipStationShipment."Ship To Country");
        Customer.Validate("Post Code", xShipStationShipment."Ship To Postal Code");
    end;

    local procedure FindShipStationSalesOrder(xShipStationShipment: Record "NRM SS Shipment")
    var
        SalesHeader: Record "Sales Header";
        SalesInvHdr: Record "Sales Invoice Header";
    begin
        SalesHeader.SetCurrentKey("Document Type", "NRM ShipStation Id");
        SalesHeader.SetRange("Document Type", Enum::"Sales Document Type"::Order);
        SalesHeader.SetRange("NRM ShipStation Id", xShipStationShipment."Shipment ID");
        SalesHeader.SetLoadFields("No.", "NRM ShipStation Id");
        if SalesHeader.FindFirst() then
            Error(SalesOrderAlreadyExistsErr, SalesHeader."No.", SalesHeader."NRM ShipStation Id");

        SalesInvHdr.SetCurrentKey("NRM ShipStation Id");
        SalesInvHdr.SetRange("NRM ShipStation Id", xShipStationShipment."Shipment ID");
        SalesInvHdr.SetLoadFields("No.", "NRM ShipStation Id");
        if SalesInvHdr.FindFirst() then
            Error(SalesInvoiceAlreadyExistsErr, SalesInvHdr."No.", SalesInvHdr."NRM ShipStation Id");
    end;

    local procedure CreateSalesOrderNo(var xSalesHeader: Record "Sales Header")
    begin
        xSalesHeader.Init();
        xSalesHeader."Document Type" := Enum::"Sales Document Type"::Order;
        xSalesHeader.Insert(true);
    end;

    [TryFunction]
    local procedure UpdateUnivermagSalesOrder(xShipStationShipment: Record "NRM SS Shipment";
                                              xCustomer: Record Customer;
                                              var xSalesHeader: Record "Sales Header")
    var
        AddressText: Text;
    begin
        xSalesHeader.Validate("NRM ShipStation Id", xShipStationShipment."Shipment ID");
        xSalesHeader.Validate("Sell-to Customer No.", xCustomer."No.");

        // ShippingAreaProcessing(xShipStationShipment, xSalesHeader);

        xSalesHeader.Validate("NRM ShipStation Tax", xShipStationShipment."Tax Amount");
        xSalesHeader.Validate("NRM ShipStation Shipping", xShipStationShipment."Shipping Amount");
        xSalesHeader.Validate("NRM ShipStation Amount", xShipStationShipment."Amount");

        AddressText := StrSubstNo(AddressLbl, xShipStationShipment."Ship To Address 1", xShipStationShipment."Ship To Address 2", xShipStationShipment."Ship To Address 3");
        xSalesHeader.Validate("Ship-to Address", CopyStr(AddressText, 1, MaxStrLen(xSalesHeader."Ship-to Address")));

        if MaxStrLen(xSalesHeader."Ship-to Address") < StrLen(AddressText) then
            xSalesHeader.Validate("Ship-to Address 2", CopyStr(AddressText, MaxStrLen(xSalesHeader."Ship-to Address") + 1, MaxStrLen(xSalesHeader."Ship-to Address 2")));

        xSalesHeader.Validate("Ship-to City", xShipStationShipment."Ship To City");

        xSalesHeader.Validate("Ship-to County", xShipStationShipment."Ship To State");

        xSalesHeader.Validate("Ship-to Country/Region Code", xShipStationShipment."Ship To Country");

        xSalesHeader.Validate("Ship-to Post Code", xShipStationShipment."Ship To Postal Code");

        xSalesHeader.Validate("Document Date", WorkDate());
        xSalesHeader.Validate("Posting Date", WorkDate());
        xSalesHeader.Validate("Your Reference", GetYourReference(xSalesHeader."NRM ShipStation Id", xShipStationShipment."Store ID"));
    end;

    local procedure GetYourReference(xSalesHeaderShipStationId: Text[50]; xStoreId: Text[20]): Text[35]
    begin
        GetSSStore(xStoreId);
        SSStore.TestField("Prefix Order No.");
        xSalesHeaderShipStationId := CopyStr(RemoveNonNumericCharacters(xSalesHeaderShipStationId), 1, MaxStrLen(xSalesHeaderShipStationId));
        exit(CopyStr(StrSubstNo('%1%2', SSStore."Prefix Order No.", xSalesHeaderShipStationId), 1, 35));
    end;

    local procedure RemoveNonNumericCharacters(xText: Text): Text
    begin
        exit(DelChr(xText, '=', DelChr(xText, '=', '1234567890')));
    end;

    [TryFunction]
    local procedure UpdateShipStationSalesOrderLines(var xSSShipmentLine: Record "NRM SS Shipment Line";
                                                     var xSalesLine: Record "Sales Line"; xStoreId: Code[20])
    var
        SSItem: Record "NRM SS Item";
        SSVariant: Record "NRM SS Variant";
        Item: Record Item;
    begin
        xSalesLine.Validate(Type, Enum::"Sales Line Type"::Item);

        SSItem.SetCurrentKey("Store ID", SKU, Status);
        SSItem.SetRange("Store ID", xStoreId);
        SSItem.SetRange(SKU, xSSShipmentLine.SKU);
        SSItem.SetRange(Status, Enum::"NRM SS Item Status"::Active);
        SSItem.SetFilter("Item No.", '<>%1', '');
        SSItem.SetLoadFields("Item No.");
        SSItem.FindFirst();
        xSalesLine.Validate("No.", SSItem."Item No.");

        if (xSSShipmentLine.Option <> '') then begin
            SSVariant.SetCurrentKey(SKU, "Option", Status);
            SSVariant.SetRange(SKU, xSSShipmentLine.SKU);
            SSVariant.SetRange("Option", xSSShipmentLine.Option);
            SSVariant.SetRange(Status, Enum::"NRM SS Item Status"::Active);
            SSVariant.SetLoadFields(Variant);
            SSVariant.FindFirst();
            xSalesLine.Validate("Variant Code", SSVariant.Variant);
        end;

        xSalesLine.Validate(Quantity, xSSShipmentLine.Quantity);

        Item.Get(xSalesLine."No.");
        Item.TestField("Base Unit of Measure");
        if xSalesLine."Unit of Measure Code" <> Item."Base Unit of Measure" then
            xSalesLine.Validate("Unit of Measure Code", Item."Base Unit of Measure");

        xSalesLine.Validate("Unit Price", xSSShipmentLine."Unit Price Amount");
    end;

    local procedure UpdateShipStationSalesOrderDiscount(xSalesHeader: Record "Sales Header")
    var
        SSShipmentLine: Record "NRM SS Shipment Line";
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
    begin
        SSShipmentLine.SetRange("Shipment ID", xSalesHeader."NRM ShipStation Id");
        SSShipmentLine.SetFilter(SKU, '%1', '');
        SSShipmentLine.CalcSums("Unit Price Amount");
        if SSShipmentLine."Unit Price Amount" = 0 then exit;
        SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(-SSShipmentLine."Unit Price Amount", xSalesHeader);
    end;

    local procedure UpdateShipStationSalesOrderTaxLine(var xSalesHeader: Record "Sales Header"; var xLineNo: Integer)
    var
        SalesLine: Record "Sales Line";
    begin
        if xSalesHeader."NRM ShipStation Tax" = 0 then exit;

        GetShipStationSetup();
        if ShipStationSetup."No Tax" then exit;
        ShipStationSetup.TestField("Tax Account No.");

        SalesLine.Init();
        SalesLine."Document Type" := xSalesHeader."Document Type";
        SalesLine."Document No." := xSalesHeader."No.";
        SalesLine."Line No." := xLineNo;
        SalesLine.Insert(true);

        SalesLine.Validate(Type, Enum::"Sales Line Type"::"G/L Account");
        SalesLine.Validate("No.", ShipStationSetup."Tax Account No.");
        SalesLine.Validate(Quantity, 1);
        SalesLine.Validate("Unit Price", xSalesHeader."NRM ShipStation Tax");

        if ShipStationSetup."Tax Description" <> '' then
            SalesLine.Description := ShipStationSetup."Tax Description";

        SalesLine.Modify(true);

        xLineNo += 10000;
    end;

    local procedure UpdateShipStationSalesOrderShippingLine(var xShipStationShipment: Record "NRM SS Shipment"; var xSalesHeader: Record "Sales Header"; var xLineNo: Integer)
    var
        SalesLine: Record "Sales Line";
        ShippingAgent: Record "Shipping Agent";
    begin
        if xShipStationShipment."Shipping Amount" = 0 then exit;
        if ShippingAgent.Get(xSalesHeader."Shipping Agent Code") then exit;

        GetSSStore(xShipStationShipment."Store ID");
        SSStore.TestField("Shipping Account No.");

        SalesLine.Init();
        SalesLine."Document Type" := xSalesHeader."Document Type";
        SalesLine."Document No." := xSalesHeader."No.";
        SalesLine."Line No." := xLineNo;
        SalesLine.Insert(true);

        SalesLine.Validate(Type, Enum::"Sales Line Type"::"G/L Account");
        SalesLine.Validate("No.", SSStore."Shipping Account No.");
        SalesLine.Validate(Quantity, 1);
        SalesLine.Validate("Unit Price", xShipStationShipment."Shipping Amount");

        if xShipStationShipment."Requested Shipment Service" <> '' then
            SalesLine.Description := xShipStationShipment."Requested Shipment Service";

        SalesLine.Modify(true);

        xLineNo += 10000;
    end;

    local procedure UpdateShipStationSalesOrderChargeLineFromShippingAgentCode(var xShipStationShipment: Record "NRM SS Shipment"; var xSalesHeader: Record "Sales Header"; var xLineNo: Integer)
    var
        SalesLine: Record "Sales Line";
        ShippingAgent: Record "Shipping Agent";
    begin
        if xShipStationShipment."Shipping Amount" = 0 then exit;

        if not ShippingAgent.Get(xSalesHeader."Shipping Agent Code") then exit;
        ShippingAgent.TestField("Account No.");

        SalesLine.Init();
        SalesLine."Document Type" := xSalesHeader."Document Type";
        SalesLine."Document No." := xSalesHeader."No.";
        SalesLine."Line No." := xLineNo;
        SalesLine.Insert(true);

        SalesLine.Validate(Type, Enum::"Sales Line Type"::"G/L Account");
        SalesLine.Validate("No.", ShippingAgent."Account No.");
        SalesLine.Validate(Quantity, 1);
        SalesLine.Validate("Unit Price", xShipStationShipment."Shipping Amount");

        if xShipStationShipment."Requested Shipment Service" <> '' then
            SalesLine.Description := xShipStationShipment."Requested Shipment Service";

        SalesLine.Modify(true);

        xLineNo += 10000;
    end;

    local procedure ShippingAreaProcessing(var xShipStationShipment: Record "NRM SS Shipment";
                                           var xSalesHeader: Record "Sales Header")
    var
        ShippingAgentServices: Record "Shipping Agent Services";
    begin
        xSalesHeader.Validate("Shipping Agent Code", xShipStationShipment."Carrier ID");
        ShippingAgentServices.SetRange("Shipping Agent Code", xSalesHeader."Shipping Agent Code");
        // ShippingAgentServices.SetRange(Description, CodeText);
        ShippingAgentServices.FindFirst();
        xSalesHeader.Validate("Shipping Agent Service Code", xShipStationShipment."Service Code");
    end;

    var
        SSStore: Record "NRM SS Store";
        ShipStationSetup: Record "NRM ShipStation Setup";
        OldStoreId: Text[20];
        ShipStationSetupRead: Boolean;
        SalesOrderAlreadyExistsErr: Label 'Sales Order already exists with No.= %1 and ShipStation ID = %2!', Comment = '%1 = Sales Order No., %2 = ShipStation ID';
        SalesInvoiceAlreadyExistsErr: Label 'Sales Invoice already exists with No.= %1 and ShipStation ID = %2!', Comment = '%1 = Sales Invoice No., %2 = ShipStation ID';
        EmptyEmailErr: Label 'Email is empty not allowed!';
        AddressLbl: Label '%1 %2 %3', Comment = '%1 = Ship To Address 1, %2 = Ship To Address 2, %3 = Ship To Address 3';
        ItemNotFoundQst: Label 'Item %1 not found! Do you want to create it?', Comment = '%1 = SKU';
        ItemNotFoundErr: Label 'Item %1 not found and user did not want to create it!', Comment = '%1 = SKU';
}