{
  Serialize the selected forms in YAML format
  Will write to ProgramPath + output.yml
  Hotkey: Ctrl+J
}

unit SerializeCommand;

uses 'lib\SerializeJsonItemLoc';

var
  inputPathList: TStringList;
  outputJSON: TStringList;
  outputPath: String;
  

function Initialize: integer;
begin
  inputPathList := TStringList.Create;
  outputJSON := TStringList.Create;
  outputJSON.Add('{' + #13#10);

  try
    inputPathList.LoadFromFile(ProgramPath + 'serialize_path.txt');
    outputPath := Trim(inputPathList.Text);
  except
    outputPath := ProgramPath + 'output.json';
  end;

end;

function Process(e: IInterface): integer;
var
 output: String;
begin
	output := Serialize(e);
	if(output <> '') then outputJSON.Add( output );
  
end;

function Finalize: integer;
var
  lastString: String;
  I: Integer;
begin
  //delete last comma
  I := outputJSON.Count-1;
  lastString := outputJSON[I];
  //remove last id processed from stringlist
  outputJSON.Delete(I);
  //delete the last comma
  delete(lastString,length(lastString),1);
  //add the cleaned string back
  outputJSON.Add(lastString);
  
  //add last curly brace
  outputJSON.Add(#13#10 + '}');
  
  AddMessage('Saving list to ' + outputPath);
  outputJSON.SaveToFile(outputPath);

  outputJSON.Free;
  inputPathList.Free;
end;

end.
