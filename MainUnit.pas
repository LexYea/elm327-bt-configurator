unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  ShellApi;

type
  TMainForm = class(TForm)
    LogMemo: TMemo;
    DeviceBTNameEdit: TEdit;
    DeviceBTPasswordEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    SaveButton: TButton;
    OpenButton: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    DeviceBTMACEdit: TEdit;
    DeviceBTBaudrateComboBox: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    DeveloperUrlLabel: TLabel;
    CompanyUrlLabel: TLabel;
    ChipModelLabel: TLabel;
    Label5: TLabel;
    DeviceBTBLENameEdit: TEdit;
    Label6: TLabel;
    DeviceBTBLEMACEdit: TEdit;
    Label7: TLabel;
    SaveAsButton: TButton;
    SpecialUrlLabel: TLabel;
    procedure OpenButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CompanyUrlLabelMouseEnter(Sender: TObject);
    procedure CompanyUrlLabelMouseLeave(Sender: TObject);
    procedure CompanyUrlLabelClick(Sender: TObject);
    procedure DeveloperUrlLabelClick(Sender: TObject);
    procedure SaveAsButtonClick(Sender: TObject);
    procedure SpecialUrlLabelClick(Sender: TObject);
  private
    { Private declarations }
    FFileName: string;
    FChipType: string; // Тип микросхемы (T24LC32A или T24LC64A)
    procedure CopyFile(const NewFileName: string);
    procedure LoadBinFile(const FileName: string);
    procedure SaveBinFile(const FileName: string);
    function ReverseMacAddress(const MacBytes: array of Byte): string;
    procedure WriteMacAddress(var FileStream: TFileStream; const MacAddress: string; Offset: Integer);
    function BaudRateToDivider(const BaudRate: Integer): Word;
    function DividerToBaudRate(const Divider: Word): Integer;
    function DetectChipType(const FileName: string): string;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.SaveButtonClick(Sender: TObject);
begin
  if MessageDlg('Перезаписать текущий файл?', mtInformation, mbYesNo, 0)=MrYes then
  begin
    SaveBinFile(FFileName);
    LogMemo.Lines.Add('Файл успешно сохранен: ' + FFileName);
  end;
end;

procedure TMainForm.SaveAsButtonClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    CopyFile(SaveDialog1.FileName);
    SaveBinFile(SaveDialog1.FileName);
    LogMemo.Lines.Add('Файл успешно сохранен: ' + SaveDialog1.FileName);
  end;
end;

procedure TMainForm.OpenButtonClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    FFileName := OpenDialog1.FileName;
    FChipType := DetectChipType(FFileName); // Определяем тип микросхемы
    if FChipType = '' then
    begin
      ShowMessage('Неподдерживаемый размер файла. Поддерживаются только файлы размером 4 КБ (T24LC32A) или 8 КБ (T24LC64A).');
      Exit;
    end;

    LoadBinFile(FFileName);
    LogMemo.Lines.Add(Format('Файл успешно загружен: %s (%s)', [FFileName, FChipType]));
  end;
end;

procedure TMainForm.CompanyUrlLabelClick(Sender: TObject);
begin
  ShellExecute(0, 'OPEN', 'https://aedev.ru', '', '', SW_SHOWNORMAL);
end;

procedure TMainForm.CompanyUrlLabelMouseEnter(Sender: TObject);
begin
 (Sender as TLabel).Font.Color:=clHighlight;
 (Sender as TLabel).Font.Style:=[fsUnderline];
end;

procedure TMainForm.CompanyUrlLabelMouseLeave(Sender: TObject);
begin
 (Sender as TLabel).Font.Color:=clWindowText;
 (Sender as TLabel).Font.Style:=[];
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Заполняем ComboBox возможными значениями скорости
  DeviceBTBaudrateComboBox.Items.Add('38400');
  DeviceBTBaudrateComboBox.Items.Add('57600');
  DeviceBTBaudrateComboBox.Items.Add('115200');
  //DeviceBTBaudrateComboBox.ItemIndex := 0; // Устанавливаем первое значение по умолчанию
end;

function TMainForm.DetectChipType(const FileName: string): string;
var
  FileStream: TFileStream;
  FileSize: Int64;
begin
  Result := '';
  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    FileSize := FileStream.Size;
    if FileSize = 4096 then
      begin
        ChipModelLabel.Caption:='T24LC32A (4КБ)';
        Result := 'T24LC32A';
      end
    else if FileSize = 8192 then
      begin
        ChipModelLabel.Caption:='T24LC64A (8КБ)';
        Result := 'T24LC64A';
      end;
    DeviceBTBLENameEdit.Enabled:= Boolean(FileSize = 8192);
    DeviceBTBLEMACEdit.Enabled:= Boolean(FileSize = 8192);

  finally
    FileStream.Free;
  end;
end;

procedure TMainForm.CopyFile(const NewFileName: string);
var
  SourceFileStream, TargetFileStream: TFileStream;
begin
  // Копируем исходный файл в новый файл
  SourceFileStream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyWrite);
  try
    TargetFileStream := TFileStream.Create(NewFileName, fmCreate or fmShareDenyWrite);
    try
      TargetFileStream.CopyFrom(SourceFileStream, SourceFileStream.Size);
    finally
      TargetFileStream.Free;
    end;
  finally
    SourceFileStream.Free;
  end;
end;

procedure TMainForm.SpecialUrlLabelClick(Sender: TObject);
begin
  ShellExecute(0, 'OPEN', 'https://4pda.to/forum/index.php?showtopic=639908', '', '', SW_SHOWNORMAL);
end;

procedure TMainForm.LoadBinFile(const FileName: string);
var
  FileStream: TFileStream;
  DeviceNameLength: Byte;
  PasswordLength: Byte;
  DeviceNameBuffer: array[0..14] of AnsiChar; // Буфер для имени устройства (до 32 символов)
  PasswordBuffer: array[0..14] of AnsiChar;  // Буфер для пароля (до 32 символов)
  MacBuffer: array[0..5] of Byte;           // Буфер для MAC-адреса (6 байт)
  BaudRateDivider: array[0..1] of Byte;     // Буфер для делителя скорости (2 байта)
  Divider: Word;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    try
      if FChipType = 'T24LC32A' then
        begin
          // Чтение MAC-адреса (смещение $F88, в обратном порядке)
          FileStream.Position := $F88;
          FileStream.ReadBuffer(MacBuffer, SizeOf(MacBuffer));
          DeviceBTMACEdit.Text := ReverseMacAddress(MacBuffer);

          // Чтение длины имени устройства (смещение $FA4)
          FileStream.Position := $FA4;
          FileStream.ReadBuffer(DeviceNameLength, SizeOf(DeviceNameLength));

          // Чтение имени устройства (смещение $FA5)
          FileStream.Position := $FA5;
          FillChar(DeviceNameBuffer, SizeOf(DeviceNameBuffer), 0); // Очистка буфера
          FileStream.ReadBuffer(DeviceNameBuffer, DeviceNameLength);
          DeviceBTNameEdit.Text := string(DeviceNameBuffer).Trim;

          // Чтение длины пароля (смещение $F94)
          FileStream.Position := $F94;
          FileStream.ReadBuffer(PasswordLength, SizeOf(PasswordLength));

          // Чтение пароля (смещение $F95)
          FileStream.Position := $F95;
          FillChar(PasswordBuffer, SizeOf(PasswordBuffer), 0); // Очистка буфера
          FileStream.ReadBuffer(PasswordBuffer, PasswordLength);
          DeviceBTPasswordEdit.Text := string(PasswordBuffer).Trim;

          // Чтение делителя скорости (смещение $FE5, в обратном порядке)
          FileStream.Position := $FE5;
          FileStream.ReadBuffer(BaudRateDivider, SizeOf(BaudRateDivider));
          Divider := (Word(BaudRateDivider[1]) shl 8) or Word(BaudRateDivider[0]);
          DeviceBTBaudrateComboBox.ItemIndex := DeviceBTBaudrateComboBox.Items.IndexOf(IntToStr(DividerToBaudRate(Divider)));
        end
      else if FChipType = 'T24LC64A' then
        begin
          // Чтение MAC-адреса (смещение $18E3, в обратном порядке)
          FileStream.Position := $18E3;
          FileStream.ReadBuffer(MacBuffer, SizeOf(MacBuffer));
          DeviceBTMACEdit.Text := ReverseMacAddress(MacBuffer);

          // Чтение MAC-адреса BLE (смещение $18E9, в обратном порядке)
          FileStream.Position := $18E9;
          FileStream.ReadBuffer(MacBuffer, SizeOf(MacBuffer));
          DeviceBTBLEMACEdit.Text := ReverseMacAddress(MacBuffer);

          // Чтение длины имени BT2.0 (смещение $18FF)
          FileStream.Position := $18FF;
          FileStream.ReadBuffer(DeviceNameLength, SizeOf(DeviceNameLength));

          // Чтение имени BT2.0 (смещение $1900)
          FileStream.Position := $1900;
          FillChar(DeviceNameBuffer, SizeOf(DeviceNameBuffer), 0); // Очистка буфера
          FileStream.ReadBuffer(DeviceNameBuffer, DeviceNameLength);
          DeviceBTNameEdit.Text := string(DeviceNameBuffer).Trim;

          // Чтение длины пароля (смещение $18EF)
          FileStream.Position := $18EF;
          FileStream.ReadBuffer(PasswordLength, SizeOf(PasswordLength));

          // Чтение пароля (смещение $18F0)
          FileStream.Position := $18F0;
          FillChar(PasswordBuffer, SizeOf(PasswordBuffer), 0); // Очистка буфера
          FileStream.ReadBuffer(PasswordBuffer, PasswordLength);
          DeviceBTPasswordEdit.Text := string(PasswordBuffer).Trim;

          // Чтение имени BT4.0 (смещение $1921)
          FileStream.Position := $1920;
          FileStream.ReadBuffer(DeviceNameLength, SizeOf(DeviceNameLength));
          FileStream.Position := $1921;
          FillChar(DeviceNameBuffer, SizeOf(DeviceNameBuffer), 0); // Очистка буфера
          FileStream.ReadBuffer(DeviceNameBuffer, DeviceNameLength);
          DeviceBTBLENameEdit.Text:=string(DeviceNameBuffer).Trim;

          // Чтение делителя скорости (смещение $1940, в обратном порядке)
          FileStream.Position := $1940;
          FileStream.ReadBuffer(BaudRateDivider, SizeOf(BaudRateDivider));
          Divider := (Word(BaudRateDivider[1]) shl 8) or Word(BaudRateDivider[0]);
          DeviceBTBaudrateComboBox.ItemIndex := DeviceBTBaudrateComboBox.Items.IndexOf(IntToStr(DividerToBaudRate(Divider)));
        end;
    except
      ShowMessage('Ошибка при чтении файла в буфер '+IntToStr(FileStream.Position)+', ');
    end;
  finally
    FileStream.Free;
  end;
end;

procedure TMainForm.SaveBinFile(const FileName: string);
var
  FileStream: TFileStream;
  DeviceNameLength: Byte;
  PasswordLength: Byte;
  DeviceNameBytes: array[0..14] of AnsiChar; // Буфер для имени устройства (до 32 символов)
  PasswordBytes: array[0..14] of AnsiChar;  // Буфер для пароля (до 32 символов)
  BaudRateDivider: array[0..1] of Byte;     // Буфер для делителя скорости (2 байта)
  Divider: Word;
begin
  FileStream := TFileStream.Create(FileName, fmOpenReadWrite {or fmCreate} or fmShareDenyWrite);
  try
    if FChipType = 'T24LC32A' then
      begin
        // Запись MAC-адреса (смещение $F88 и $F8E)
        WriteMacAddress(FileStream, DeviceBTMACEdit.Text, $F88);
        WriteMacAddress(FileStream, DeviceBTMACEdit.Text, $F8E);

        // Запись длины имени устройства (смещение $FA4)
        FileStream.Position := $FA4;
        DeviceNameLength := Length(DeviceBTNameEdit.Text);
        FileStream.WriteBuffer(DeviceNameLength, SizeOf(DeviceNameLength));

        // Запись имени устройства (смещение $FA5)
        FileStream.Position := $FA5;
        FillChar(DeviceNameBytes, SizeOf(DeviceNameBytes), 0); // Очистка буфера
        StrPCopy(DeviceNameBytes, AnsiString(DeviceBTNameEdit.Text));
        FileStream.WriteBuffer(DeviceNameBytes, SizeOf(DeviceNameBytes));

        // Запись длины пароля (смещение $F94)
        FileStream.Position := $F94;
        PasswordLength := Length(DeviceBTPasswordEdit.Text);
        FileStream.WriteBuffer(PasswordLength, SizeOf(PasswordLength));

        // Запись пароля (смещение $F95)
        FileStream.Position := $F95;
        FillChar(PasswordBytes, SizeOf(PasswordBytes), 0); // Очистка буфера
        StrPCopy(PasswordBytes, AnsiString(DeviceBTPasswordEdit.Text));
        FileStream.WriteBuffer(PasswordBytes, SizeOf(PasswordBytes));

        // Запись делителя скорости (смещение $FE5, в обратном порядке)
        FileStream.Position := $FE5;
        Divider := BaudRateToDivider(StrToInt(DeviceBTBaudrateComboBox.Text));
        BaudRateDivider[0] := Byte(Divider and $FF);
        BaudRateDivider[1] := Byte((Divider shr 8) and $FF);
        FileStream.WriteBuffer(BaudRateDivider, SizeOf(BaudRateDivider));
      end
    else if FChipType = 'T24LC64A' then
      begin
        // Запись MAC-адреса (смещение $18E3, $E06, $E12)
        WriteMacAddress(FileStream, DeviceBTMACEdit.Text, $18E3);
        WriteMacAddress(FileStream, DeviceBTBLEMACEdit.Text, $18E9);

        // Запись длины имени BT2.0 (смещение $18FF)
        FileStream.Position := $18FF;
        DeviceNameLength := Length(DeviceBTNameEdit.Text);
        FileStream.WriteBuffer(DeviceNameLength, SizeOf(DeviceNameLength));

        // Запись имени BT2.0 (смещение $1900)
        FileStream.Position := $1900;
        FillChar(DeviceNameBytes, SizeOf(DeviceNameBytes), 0); // Очистка буфера
        StrPCopy(DeviceNameBytes, AnsiString(DeviceBTNameEdit.Text));
        FileStream.WriteBuffer(DeviceNameBytes, SizeOf(DeviceNameBytes));

        // Запись длины имени BT4.0 (смещение $1920)
        FileStream.Position := $1920;
        DeviceNameLength := Length(DeviceBTBLENameEdit.Text);
        FileStream.WriteBuffer(DeviceNameLength, SizeOf(DeviceNameLength));

        // Запись имени BT4.0 (смещение $1921)
        FileStream.Position := $1921;
        FillChar(DeviceNameBytes, SizeOf(DeviceNameBytes), 0); // Очистка буфера
        StrPCopy(DeviceNameBytes, AnsiString(DeviceBTBLENameEdit.Text));
        FileStream.WriteBuffer(DeviceNameBytes, SizeOf(DeviceNameBytes));

        // Запись длины пароля (смещение $18EF)
        FileStream.Position := $18EF;
        PasswordLength := Length(DeviceBTPasswordEdit.Text);
        FileStream.WriteBuffer(PasswordLength, SizeOf(PasswordLength));

        // Запись пароля (смещение $18F0)
        FileStream.Position := $18F0;
        FillChar(PasswordBytes, SizeOf(PasswordBytes), 0); // Очистка буфера
        StrPCopy(PasswordBytes, AnsiString(DeviceBTPasswordEdit.Text));
        FileStream.WriteBuffer(PasswordBytes, SizeOf(PasswordBytes));


        // Запись делителя скорости (смещение $FE5, в обратном порядке)
        FileStream.Position := $1940;
        Divider := BaudRateToDivider(StrToInt(DeviceBTBaudrateComboBox.Text));
        BaudRateDivider[0] := Byte(Divider and $FF);
        BaudRateDivider[1] := Byte((Divider shr 8) and $FF);
        FileStream.WriteBuffer(BaudRateDivider, SizeOf(BaudRateDivider));
      end;
  finally
    FileStream.Free;
  end;
end;

function TMainForm.ReverseMacAddress(const MacBytes: array of Byte): string;
var
  i: Integer;
begin
  Result := '';
  for i := High(MacBytes) downto Low(MacBytes) do
    Result := Result + IntToHex(MacBytes[i], 2) + ':';
  Result := Copy(Result, 1, Length(Result) - 1); // Убираем последнее двоеточие
end;

procedure TMainForm.WriteMacAddress(var FileStream: TFileStream; const MacAddress: string; Offset: Integer);
var
  MacParts: TArray<string>;
  MacBytes: array[0..5] of Byte;
  i: Integer;
begin
  // Разделяем MAC-адрес на части
  MacParts := MacAddress.Split([':']);
  if Length(MacParts) <> 6 then
    raise Exception.Create('Некорректный формат MAC-адреса');

  // Преобразуем части в байты
  for i := 0 to 5 do
    MacBytes[i] := StrToInt('$' + MacParts[i]);

  // Записываем MAC-адрес в обратном порядке
  FileStream.Position := Offset;
  for i := 5 downto 0 do
    FileStream.WriteBuffer(MacBytes[i], SizeOf(Byte));
end;

function TMainForm.BaudRateToDivider(const BaudRate: Integer): Word;
begin
  case BaudRate of
    38400: Result := 1250; // 0x04E2
    57600: Result := 833;  // 0x0341
    115200: Result := 417; // 0x01A1
  else
    raise Exception.Create('Неподдерживаемая скорость');
  end;
end;

procedure TMainForm.DeveloperUrlLabelClick(Sender: TObject);
begin
  ShellExecute(0, 'OPEN', 'https://aedev.ru', '', '', SW_SHOWNORMAL);
end;

function TMainForm.DividerToBaudRate(const Divider: Word): Integer;
begin
  case Divider of
    1250: Result := 38400;
    833: Result := 57600;
    417: Result := 115200;
  else
    raise Exception.Create('Неподдерживаемый делитель ('+IntToStr(Divider)+'). Скорость в дампе EEPROM задана некорректно');
  end;
end;


end.
