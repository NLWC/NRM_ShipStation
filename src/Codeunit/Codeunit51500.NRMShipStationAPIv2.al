codeunit 51500 "NRM ShipStation API v2"
{
    Access = Public;

    procedure GetShipments(var xSSShipment: Record "NRM SS Shipment"; xPage: Integer; xPageSize: Integer; xShipmentStatus: Text;
                           xCreatedAtStart: Text; xCreatedAtEnd: Text; xStoreId: Text; var xTotalPages: Integer)
    var
        Endpoint: Text;
        ResponseText: Text;
        UrlBuilder: TextBuilder;
    begin
        GetShipStationSetup();

        // Build endpoint with parameters
        UrlBuilder.Append(GetShipStationEndpoint('SHIPMENTS'));
        if xStoreId = '' then
            Error('Store ID is required');

        UrlBuilder.Append('?store_id=' + xStoreId.ToLower());
        UrlBuilder.Append('&sort_dir=desc');
        UrlBuilder.Append('&sort_by=created_at');

        if xPage > 0 then
            UrlBuilder.Append('&page=' + Format(xPage));
        if xPageSize > 0 then
            UrlBuilder.Append('&page_size=' + Format(xPageSize));
        if xShipmentStatus <> '' then
            UrlBuilder.Append('&shipment_status=' + xShipmentStatus);
        if xCreatedAtStart <> '' then
            UrlBuilder.Append('&created_at_start=' + xCreatedAtStart);
        if xCreatedAtEnd <> '' then
            UrlBuilder.Append('&created_at_end=' + xCreatedAtEnd);

        Endpoint := UrlBuilder.ToText();

        if SendGetRequest(Endpoint, ResponseText) then
            ParseShipments(ResponseText, xSSShipment, xTotalPages)
        else
            Error('Failed to get shipments from SS API');
    end;

    [TryFunction]
    procedure GetShipmentById(ShipmentId: Text; var NRMSSShipment: Record "NRM SS Shipment")
    var
        Endpoint: Text;
        ResponseText: Text;
        JsonResponse: JsonObject;
    begin
        GetShipStationSetup();
        Endpoint := StrSubstNo('%1/%2', GetShipStationEndpoint('SHIPMENT_ID'), ShipmentId);

        if SendGetRequest(Endpoint, ResponseText) then begin
            if JsonResponse.ReadFrom(ResponseText) then
                ParseShipment(JsonResponse, NRMSSShipment);
        end else
            Error('Failed to get shipment %1 from SS API', ShipmentId);
    end;

    local procedure SendGetRequest(Endpoint: Text; var ResponseText: Text): Boolean
    var
        HttpClient: HttpClient;
        HttpRequest: HttpRequestMessage;
        HttpResponse: HttpResponseMessage;
        Headers: HttpHeaders;
        Uri: Text;
    begin
        GetShipStationSetup();

        Uri := ShipStationSetup."API v2 Base URL" + Endpoint;

        HttpRequest.Method := 'GET';
        HttpRequest.SetRequestUri(Uri);
        HttpRequest.GetHeaders(Headers);
        Headers.Add('api-key', ShipStationSetup."API v2 Key");
        Headers.Add('Accept', 'application/json');
        // if Headers.Contains('Content-Type') then
        //     Headers.Remove('Content-Type');
        // Headers.Add('Content-Type', 'application/json');

        if HttpClient.Send(HttpRequest, HttpResponse) then begin
            if HttpResponse.IsSuccessStatusCode then begin
                HttpResponse.Content.ReadAs(ResponseText);
                exit(true);
            end else begin
                HttpResponse.Content.ReadAs(ResponseText);
                Session.LogMessage('0000SHST', StrSubstNo(SSAPIErr, HttpResponse.HttpStatusCode, ResponseText), Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', 'ShipStation');
            end;
        end else
            Session.LogMessage('0000SHST', SSErrorSendingRequestErr, Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', 'ShipStation');

        exit(false);
    end;

    local procedure GetShipStationSetup()
    begin

        if not ShipStationSetup.Get() then
            Error(SSSetupNotFoundErr);

        if not ShipStationSetup.Enabled then
            Error(SSIntegrationDisabledErr);

        if ShipStationSetup."API v2 Key" = '' then
            Error(SSAPIKeyNotConfiguredErr);

        if ShipStationSetup."API v2 Base URL" = '' then
            Error(SSAPIBaseURLNotConfiguredErr);
    end;

    local procedure ParseShipments(ResponseText: Text; var xShipment: Record "NRM SS Shipment"; var xTotalPages: Integer)
    var
        JsonResponse: JsonObject;
        JsonToken: JsonToken;
        ShipmentsArray: JsonArray;
        ShipmentToken: JsonToken;
    begin
        if not JsonResponse.ReadFrom(ResponseText) then
            Error(SSInvalidJSONResponseErr);

        if JsonResponse.Get('pages', JsonToken) then
            xTotalPages := JsonToken.AsValue().AsInteger();

        if JsonResponse.Get('shipments', JsonToken) then begin
            ShipmentsArray := JsonToken.AsArray();

            foreach ShipmentToken in ShipmentsArray do
                ParseShipment(ShipmentToken.AsObject(), xShipment);
        end;
    end;

    local procedure ParseShipment(ShipmentObj: JsonObject; var xNRMSSShipment: Record "NRM SS Shipment")
    var
        JsonToken: JsonToken;
        ShipToObj: JsonObject;
        ItemsArray: JsonArray;
    begin
        xNRMSSShipment.Init();

        // Parse basic fields
        if ShipmentObj.Get('shipment_id', JsonToken) then
            xNRMSSShipment."Shipment ID" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Shipment ID"));

        if ShipmentObj.Get('external_shipment_id', JsonToken) and not JsonToken.AsValue().IsNull() then
            xNRMSSShipment."External Shipment ID" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."External Shipment ID"));

        if ShipmentObj.Get('requested_shipment_service', JsonToken) and not JsonToken.AsValue().IsNull() then
            xNRMSSShipment."Requested Shipment Service" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Requested Shipment Service"));

        if ShipmentObj.Get('shipment_status', JsonToken) and not JsonToken.AsValue().IsNull() then
            Evaluate(xNRMSSShipment."Shipment Status", JsonToken.AsValue().AsText());

        if ShipmentObj.Get('created_at', JsonToken) and not JsonToken.AsValue().IsNull() then
            xNRMSSShipment."Created At" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Created At"));

        if ShipmentObj.Get('ship_by_date', JsonToken) and not JsonToken.AsValue().IsNull() then
            xNRMSSShipment."Ship by Date" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Ship by Date"));

        if ShipmentObj.Get('ship_date', JsonToken) and not JsonToken.AsValue().IsNull() then
            xNRMSSShipment."Ship Date" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Ship Date"));

        if ShipmentObj.Get('carrier_id', JsonToken) and not JsonToken.AsValue().IsNull() then
            xNRMSSShipment."Carrier ID" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Carrier ID"));

        if ShipmentObj.Get('service_code', JsonToken) and not JsonToken.AsValue().IsNull() then
            xNRMSSShipment."Service Code" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Service Code"));

        if ShipmentObj.Get('store_id', JsonToken) then
            xNRMSSShipment."Store ID" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Store ID"));

        if ShipmentObj.Get('amount_paid', JsonToken) then
            if JsonToken.AsObject().Get('amount', JsonToken) then
                xNRMSSShipment.Amount := JsonToken.AsValue().AsDecimal();

        if ShipmentObj.Get('shipping_paid', JsonToken) then
            if JsonToken.AsObject().Get('amount', JsonToken) then
                xNRMSSShipment."Shipping Amount" := JsonToken.AsValue().AsDecimal();

        if ShipmentObj.Get('tax_paid', JsonToken) then
            if JsonToken.AsObject().Get('amount', JsonToken) then
                xNRMSSShipment."Tax Amount" := JsonToken.AsValue().AsDecimal();

        // Parse ship_to object
        if ShipmentObj.Get('ship_to', JsonToken) then begin
            ShipToObj := JsonToken.AsObject();

            if ShipToObj.Get('name', JsonToken) then
                xNRMSSShipment."Ship To Name" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Ship To Name"));

            if ShipToObj.Get('email', JsonToken) then
                xNRMSSShipment.Email := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment.Email));

            if ShipToObj.Get('phone', JsonToken) and not JsonToken.AsValue().IsNull() then
                xNRMSSShipment.Phone := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment.Phone));

            if ShipToObj.Get('address_line1', JsonToken) then
                xNRMSSShipment."Ship To Address 1" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Ship To Address 1"));

            if ShipToObj.Get('address_line2', JsonToken) and not JsonToken.AsValue().IsNull() then
                xNRMSSShipment."Ship To Address 2" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Ship To Address 2"));

            if ShipToObj.Get('address_line3', JsonToken) and not JsonToken.AsValue().IsNull() then
                xNRMSSShipment."Ship To Address 3" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Ship To Address 3"));

            if ShipToObj.Get('city_locality', JsonToken) then
                xNRMSSShipment."Ship To City" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Ship To City"));

            if ShipToObj.Get('state_province', JsonToken) then
                xNRMSSShipment."Ship To State" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Ship To State"));

            if ShipToObj.Get('postal_code', JsonToken) then
                xNRMSSShipment."Ship To Postal Code" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Ship To Postal Code"));

            if ShipToObj.Get('country_code', JsonToken) then
                xNRMSSShipment."Ship To Country" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(xNRMSSShipment."Ship To Country"));
        end;

        if not xNRMSSShipment.Insert() then exit;

        // Parse items after inserting shipment
        if ShipmentObj.Get('items', JsonToken) then begin
            ItemsArray := JsonToken.AsArray();
            ParseItems(ItemsArray, xNRMSSShipment."Shipment ID", xNRMSSShipment."Store ID");
        end;
    end;

    local procedure ParseItems(ItemsArray: JsonArray; ShipmentID: Code[50]; xStoreId: Code[20])
    var
        ItemToken: JsonToken;
        i: Integer;
    begin
        for i := 0 to ItemsArray.Count - 1 do begin
            ItemsArray.Get(i, ItemToken);
            ParseItem(ItemToken.AsObject(), ShipmentID, xStoreId);
        end;
    end;

    local procedure ParseItem(ItemObj: JsonObject; xShipmentID: Code[50]; xStoreId: Code[20])
    var
        SSShipmentLine: Record "NRM SS Shipment Line";
        JsonToken: JsonToken;
        OptionsArray: JsonArray;
        OptionToken: JsonToken;
        j: Integer;
        OptionText: TextBuilder;
        WeightObj: JsonObject;
    begin
        SSShipmentLine.Init();
        SSShipmentLine."Shipment ID" := xShipmentID;

        // Parse basic fields
        if ItemObj.Get('item_id', JsonToken) then
            SSShipmentLine."Line Item Key" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(SSShipmentLine."Line Item Key"));

        if ItemObj.Get('sku', JsonToken) and not JsonToken.AsValue().IsNull() then
            SSShipmentLine.SKU := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(SSShipmentLine.SKU));

        if ItemObj.Get('name', JsonToken) and not JsonToken.AsValue().IsNull() then
            SSShipmentLine.Name := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(SSShipmentLine.Name));

        if ItemObj.Get('image_url', JsonToken) and not JsonToken.AsValue().IsNull() then
            SSShipmentLine."Image URL" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(SSShipmentLine."Image URL"));

        if ItemObj.Get('quantity', JsonToken) and not JsonToken.AsValue().IsNull() then
            SSShipmentLine.Quantity := JsonToken.AsValue().AsInteger();

        if ItemObj.Get('unit_price', JsonToken) and not JsonToken.AsValue().IsNull() then
            SSShipmentLine."Unit Price Amount" := JsonToken.AsValue().AsDecimal();

        if ItemObj.Get('tax_amount', JsonToken) and not JsonToken.AsValue().IsNull() then
            SSShipmentLine."Tax Amount" := JsonToken.AsValue().AsDecimal();

        if ItemObj.Get('shipping_amount', JsonToken) and not JsonToken.AsValue().IsNull() then
            SSShipmentLine."Shipping Amount" := JsonToken.AsValue().AsDecimal();

        if ItemObj.Get('inventory_location', JsonToken) and not JsonToken.AsValue().IsNull() then
            SSShipmentLine."Warehouse Location" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(SSShipmentLine."Warehouse Location"));

        if ItemObj.Get('product_id', JsonToken) and not JsonToken.AsValue().IsNull() then
            SSShipmentLine."Product ID" := JsonToken.AsValue().AsInteger();

        if ItemObj.Get('fullfilment_sku', JsonToken) and not JsonToken.AsValue().IsNull() then
            SSShipmentLine."Fulfillment SKU" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(SSShipmentLine."Fulfillment SKU"));

        if ItemObj.Get('upc', JsonToken) and not JsonToken.AsValue().IsNull() then
            SSShipmentLine.Upc := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(SSShipmentLine.Upc));

        // Check if this is an adjustment (like discount)
        if ItemObj.Get('external_order_item_id', JsonToken) and not JsonToken.AsValue().IsNull() then
            SSShipmentLine.Adjustment := (LowerCase(JsonToken.AsValue().AsText()) = 'discount');

        // Parse weight object
        if ItemObj.Get('weight', JsonToken) then begin
            WeightObj := JsonToken.AsObject();
            if WeightObj.Get('value', JsonToken) and not JsonToken.AsValue().IsNull() then
                SSShipmentLine."Weight Value" := JsonToken.AsValue().AsDecimal();
            if WeightObj.Get('unit', JsonToken) and not JsonToken.AsValue().IsNull() then
                SSShipmentLine."Weight Units" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(SSShipmentLine."Weight Units"));
        end;

        // Parse options array
        if ItemObj.Get('options', JsonToken) then begin
            OptionsArray := JsonToken.AsArray();
            for j := 0 to OptionsArray.Count - 1 do begin
                OptionsArray.Get(j, OptionToken);
                ParseOption(OptionToken.AsObject(), OptionText);
            end;
            SSShipmentLine.Option := CopyStr(OptionText.ToText(), 1, MaxStrLen(SSShipmentLine.Option));
        end;

        if SSShipmentLine.Insert() then begin
            SSItemUpdate(SSShipmentLine, xStoreId);
            SSItemVariantUpdate(SSShipmentLine);
        end;
    end;

    local procedure ParseOption(OptionObj: JsonObject; var OptionText: TextBuilder)
    var
        JsonToken: JsonToken;
        Name: Text;
        Value: Text;
    begin
        if OptionObj.Get('name', JsonToken) and not JsonToken.AsValue().IsNull() then
            Name := JsonToken.AsValue().AsText();

        if OptionObj.Get('value', JsonToken) and not JsonToken.AsValue().IsNull() then
            Value := JsonToken.AsValue().AsText();

        if (Name <> '') and (Value <> '') then begin
            if OptionText.Length() > 0 then
                OptionText.Append('; ');
            OptionText.Append(Name + ': ' + Value);
        end;
    end;

    local procedure GetShipStationEndpoint(xEndpointCode: Code[20]): Text
    var
        SSEndpoint: Record "NRM SS Endpoint";
    begin
        if not SSEndpoint.Get(xEndpointCode) then
            Error(EndpointNotFoundErr, xEndpointCode);
        if not SSEndpoint.Enabled then
            Error(EndpointDisabledErr, xEndpointCode);
        exit(SSEndpoint."Endpoint Path");
    end;

    local procedure SSItemUpdate(xSSShipmentLine: Record "NRM SS Shipment Line"; xStoreId: Code[20])
    var
        SSItem: Record "NRM SS Item";
    begin
        if SSItem.Get(xStoreId, xSSShipmentLine.SKU)
       or (xStoreId = '') or (xSSShipmentLine.SKU = '') then
            exit;

        SSItem.Init();
        SSItem."Store ID" := xStoreId;
        SSItem.SKU := xSSShipmentLine.SKU;
        SSItem.Name := xSSShipmentLine.Name;
        SSItem."Image URL" := xSSShipmentLine."Image URL";
        SSItem."Product ID" := xSSShipmentLine."Product ID";
        SSItem."Fulfillment SKU" := xSSShipmentLine."Fulfillment SKU";
        SSItem.Upc := xSSShipmentLine.Upc;
        SSItem."Weight Value" := xSSShipmentLine."Weight Value";
        SSItem."Weight Units" := xSSShipmentLine."Weight Units";
        SSItem.Insert();
    end;

    local procedure SSItemVariantUpdate(xSSShipmentLine: Record "NRM SS Shipment Line")
    var
        SSItem: Record "NRM SS Item";
        SSVariant: Record "NRM SS Variant";
    begin
        if SSVariant.Get(xSSShipmentLine.SKU, xSSShipmentLine.Option)
        or (xSSShipmentLine.Option = '') then
            exit;

        SSVariant.Init();
        SSVariant.SKU := xSSShipmentLine.SKU;
        SSVariant.Option := xSSShipmentLine.Option;
        SSVariant.Name := xSSShipmentLine.Name;
        SSVariant."Image URL" := xSSShipmentLine."Image URL";

        SSItem.Reset();
        SSItem.SetRange(SKU, xSSShipmentLine.SKU);
        SSItem.SetLoadFields("Item No.");
        if SSItem.FindFirst() and (SSItem."Item No." <> '') then
            SSVariant."Item No." := SSItem."Item No.";

        SSVariant.Insert();
    end;

    var
        ShipStationSetup: Record "NRM ShipStation Setup";
        SSAPIErr: Label 'ShipStation API Error: %1 - %2', Comment = '%1 = HTTP Status Code, %2 = Response Text';
        SSSetupNotFoundErr: Label 'ShipStation setup not found. Please configure the API settings.';
        SSIntegrationDisabledErr: Label 'ShipStation integration is disabled. Please enable it in the setup.';
        SSAPIKeyNotConfiguredErr: Label 'API Key is not configured. Please enter your ShipStation API Key.';
        SSAPIBaseURLNotConfiguredErr: Label 'API Base URL is not configured. Please enter the ShipStation API Base URL.';
        SSErrorSendingRequestErr: Label 'Failed to send HTTP request to ShipStation API';
        SSInvalidJSONResponseErr: Label 'Invalid JSON response from ShipStation API';
        EndpointNotFoundErr: Label 'Endpoint %1 not found.', Comment = '%1 = Endpoint Code';
        EndpointDisabledErr: Label 'Endpoint %1 is disabled. Please enable it in the setup.', Comment = '%1 = Endpoint Code';
}