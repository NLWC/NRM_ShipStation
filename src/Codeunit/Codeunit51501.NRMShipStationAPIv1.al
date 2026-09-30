codeunit 51501 "NRM ShipStation API v1"
{
    trigger OnRun()
    begin

    end;

    internal procedure SyncStores()
    var
        Endpoint: Text;
        ResponseText: Text;
    begin
        GetShipStationSetup();

        Endpoint := GetShipStationEndpoint('STORES');

        if SendGetRequest(Endpoint, ResponseText) then
            ParseStores(ResponseText)
        // Message(ResponseText)
        else
            Error(SendingRequestErr);
    end;

    internal procedure SendGetRequest(xEndpoint: Text; var xResponseText: Text): Boolean
    var
        Base64Convert: Codeunit "Base64 Convert";
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        AuthText: Text;
        ApiKey: Text;
        ApiSecret: Text;
    begin
        GetShipStationSetup();

        ApiKey := ShipStationSetup."API v1 Key";
        ApiSecret := ShipStationSetup."API Secret";
        AuthText := StrSubstNo('%1:%2', ApiKey, ApiSecret);
        AuthText := Base64Convert.ToBase64(AuthText); // из Codeunit "Base64 Convert" или аналог

        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.SetRequestUri(ShipStationSetup."API v1 Base URL" + xEndpoint);
        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', StrSubstNo(BasicAuthLbl, AuthText));

        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            HttpResponseMessage.Content().ReadAs(xResponseText);
            exit(true);
        end else begin
            HttpResponseMessage.Content().ReadAs(xResponseText);
            Error(APIErr, HttpResponseMessage.HttpStatusCode, xResponseText);
        end;

        exit(false);
        // далее чтение HttpResponseMessage.Content().ReadAs...
    end;

    local procedure GetShipStationEndpoint(xEndpointCode: Code[20]): Text
    var
    begin
        if not SSEndpoint.Get(xEndpointCode) then
            Error(EndpointNotFoundErr, xEndpointCode);
        if not SSEndpoint.Enabled then
            Error(EndpointDisabledErr, xEndpointCode);
        exit(SSEndpoint."Endpoint Path");
    end;

    local procedure ParseStores(ResponseText: Text)
    var
        StoresArray: JsonArray;
        StoreToken: JsonToken;
    begin
        if not StoresArray.ReadFrom(ResponseText) then
            Error(InvalidJSONResponseErr);

        GetShipStationSetup();
        ShipStationSetup.TestField("Prefix Store Id");

        foreach StoreToken in StoresArray do
            ParseStore(StoreToken.AsObject());
    end;

    local procedure ParseStore(xStoreObj: JsonObject)
    var
        SSStore: Record "NRM SS Store";
        JsonToken: JsonToken;
    begin
        SSStore.Init();

        // Parse basic fields
        if xStoreObj.Get('storeId', JsonToken) then
            SSStore."Store ID" := StrSubstNo('%1%2', ShipStationSetup."Prefix Store Id", CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(SSStore."Store ID")));

        if xStoreObj.Get('storeName', JsonToken) then
            SSStore."Store Name" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(SSStore."Store Name"));

        if xStoreObj.Get('marketplaceName', JsonToken) then
            SSStore."Marketplace Name" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(SSStore."Marketplace Name"));

        if xStoreObj.Get('accountName', JsonToken) and not JsonToken.AsValue().IsNull() then
            SSStore."Account Name" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(SSStore."Account Name"));

        if xStoreObj.Get('active', JsonToken) then
            SSStore.Active := JsonToken.AsValue().AsBoolean();

        if xStoreObj.Get('website', JsonToken) and not JsonToken.AsValue().IsNull() then
            SSStore.Website := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(SSStore.Website));

        SSStore.Blocked := true;

        if SSStore.Insert(true) then; // Insert or modify if exists
    end;

    local procedure GetShipStationSetup()
    begin

        if not ShipStationSetup.Get() then
            Error(SetupNotFoundErr);

        if not ShipStationSetup.Enabled then
            Error(IntegrationDisabledErr);

        if ShipStationSetup."API v1 Key" = '' then
            Error(APIKeyNotConfiguredErr);

        if ShipStationSetup."API Secret" = '' then
            Error(APISecretNotConfiguredErr);

        if ShipStationSetup."API v1 Base URL" = '' then
            Error(APIBaseURLNotConfiguredErr);
    end;

    var
        ShipStationSetup: Record "NRM ShipStation Setup";
        SSEndpoint: Record "NRM SS Endpoint";
        APIErr: Label 'ShipStation API Error: %1 - %2', Comment = '%1 = HTTP Status Code, %2 = Response Text';
        SetupNotFoundErr: Label 'ShipStation setup not found. Please configure the API settings.';
        IntegrationDisabledErr: Label 'ShipStation integration is disabled. Please enable it in the setup.';
        APIKeyNotConfiguredErr: Label 'API Key is not configured. Please enter your ShipStation API Key.';
        APIBaseURLNotConfiguredErr: Label 'API Base URL is not configured. Please enter the ShipStation API Base URL.';
        APISecretNotConfiguredErr: Label 'API Secret is not configured. Please enter your ShipStation API Secret.';
        BasicAuthLbl: Label 'Basic %1', Comment = '%1 = Base64 encoded API Key and Secret';
        SendingRequestErr: Label 'Failed to send HTTP request to ShipStation API.', Comment = '%1 = Endpoint';
        EndpointNotFoundErr: Label 'Endpoint %1 not found.', Comment = '%1 = Endpoint Code';
        EndpointDisabledErr: Label 'Endpoint %1 is disabled. Please enable it in the setup.', Comment = '%1 = Endpoint Code';
        InvalidJSONResponseErr: Label 'Invalid JSON response from ShipStation API.', Comment = '%1 = Response Text';
}