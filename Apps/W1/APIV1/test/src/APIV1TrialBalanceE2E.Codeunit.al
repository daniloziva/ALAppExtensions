codeunit 139718 "APIV1 - Trial Balance E2E"
{
    // version Test,ERM,W1,All

    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
        // [FEATURE] [Graph] [Trial Balance]
    end;

    var
        Assert: Codeunit "Assert";
        LibraryApplicationArea: Codeunit "Library - Application Area";
        LibraryGraphMgt: Codeunit "Library - Graph Mgt";
        LibraryUtility: Codeunit "Library - Utility";
        IsInitialized: Boolean;
        ServiceNameTxt: Label 'trialBalance';

    [Test]
    procedure TestGetTrialBalanceRecords()
    var
        ResponseText: Text;
        TargetURL: Text;
    begin
        // [SCENARIO] User can retrieve Trial Balance Report information from the trialBalance API.
        Initialize();

        // [WHEN] A GET request is made to the trialBalance API.
        TargetURL := LibraryGraphMgt.CreateTargetURL('', PAGE::"APIV1 - Trial Balance", ServiceNameTxt);

        LibraryGraphMgt.GetFromWebService(ResponseText, TargetURL);

        // [THEN] The response is empty.
        Assert.AreNotEqual('', ResponseText, 'GET response must not be empty.');
    end;

    [Test]
    procedure TestCreateTrialBalanceRecord()
    var
        TempTrialBalanceEntityBuffer: Record "Trial Balance Entity Buffer" temporary;
        TrialBalanceEntityBufferJSON: Text;
        ResponseText: Text;
        TargetURL: Text;
    begin
        // [SCENARIO] Create a trialBalance record through a POST method and check if it was created
        Initialize();

        // [GIVEN] The user has constructed a trialBalance JSON object to send to the service.
        TrialBalanceEntityBufferJSON := GetTrialBalanceJSON(TempTrialBalanceEntityBuffer);

        // [WHEN] The user posts the JSON to the service.
        TargetURL := LibraryGraphMgt.CreateTargetURL('', PAGE::"APIV1 - Trial Balance", ServiceNameTxt);
        ASSERTERROR LibraryGraphMgt.PostToWebService(TargetURL, TrialBalanceEntityBufferJSON, ResponseText);

        // [THEN] The response is empty.
        Assert.AreEqual('', ResponseText, 'CREATE response must be empty.');
    end;

    local procedure Initialize()
    begin
        IF IsInitialized THEN
            EXIT;

        LibraryApplicationArea.EnableFoundationSetup();
        IsInitialized := TRUE;
    end;

    local procedure GetTrialBalanceJSON(var TrialBalanceEntityBuffer: Record "Trial Balance Entity Buffer") TrialBalanceJSON: Text
    begin
        IF TrialBalanceEntityBuffer."No." = '' THEN
            TrialBalanceEntityBuffer."No." :=
              LibraryUtility.GenerateRandomCode(TrialBalanceEntityBuffer.FIELDNO("No."), DATABASE::"Trial Balance Entity Buffer");
        IF TrialBalanceEntityBuffer.Name = '' THEN
            TrialBalanceEntityBuffer.Name := LibraryUtility.GenerateGUID();
        TrialBalanceJSON := LibraryGraphMgt.AddPropertytoJSON('', 'number', TrialBalanceEntityBuffer."No.");
        TrialBalanceJSON := LibraryGraphMgt.AddPropertytoJSON(TrialBalanceJSON, 'display', TrialBalanceEntityBuffer.Name);
    end;
}








