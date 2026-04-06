page 51507 "NRM SS Endpoints Subpage"
{
    Caption = 'ShipStation Endpoints';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "NRM SS Endpoint";

    layout
    {
        area(content)
        {
            repeater(Endpoints)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'The unique code for this endpoint.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'A description of what this endpoint does.';
                }
                field("Endpoint Path"; Rec."Endpoint Path")
                {
                    ToolTip = 'The API endpoint path for ShipStation.';
                }
                field("HTTP Method"; Rec."HTTP Method")
                {
                    ToolTip = 'The HTTP method used for this endpoint (GET, POST, etc.).';
                }
                field(Enabled; Rec.Enabled)
                {
                    ToolTip = 'Enable or disable this endpoint.';
                }
            }
        }
    }
}