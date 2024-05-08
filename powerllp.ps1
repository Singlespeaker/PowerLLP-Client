function deliverMessage 
{

  <#
.SYNOPSIS

.DESCRIPTION
  Deliver HL7 Message content via TCP using MLLP.
.NOTES
  This function executes for a single message - opens and closes a connection. 
  The function could be expanded to accommodate an array/list - for example, 
  the begin{} portion of the function can be a separate eval on an available 
  connection, while the end{} portion can be a function called at the 
  conclusion of the array.
.LINK
  PENDING LINK TO GITHUB PAGE.
.EXAMPLE
  deliverMessage -remoteAddress "127.0.0.1" -remotePort 1337 -deliverMessage
  "MSH|^~\&|SENDER..."
  
  Each value is required as this establishes a per-message connection. Start by
  adding the server address of the receiving server - this presently only
  allows for an IP Address (rather than host name) to be most broadly
  accessible/usable.

  IP address, rather than the host name, for the remoteAddress parameter:
    i.e. "192.168.14.10"

  Ensure a number is used for the port:
    i.e. 10450

  A variable  can be used to store message content to pass into the 
  -messageToDeliver paramater:
    i.e. $messageContent = "MSH|^~\&|SENDER..."
         deliverMessage ... -messageToDeliver $messageContent
#>

  [CmdletBinding()]
  param (
    [String]$remoteAddress,
    [Int32]$remotePort,
    [String]$messageContent
  )
  
  begin
  {
    $remoteConnection = $remoteAddress + ":" + $remotePort;
    $remoteEndpoint = [System.Net.IPEndPoint]::Parse($remoteConnection);
    $socket = New-Object System.Net.Sockets.TcpClient;
    try
    {
      
      [Int32]$timer = 500;
      while (!$socket.Connected)
      {
        $socket.Connect($remoteEndpoint);
        if ($socket.Connected)
        { 
          Out-File -FilePath ".\logging.log" -Append -Encoding ansi; 
          break; 
        }
        Start-Sleep -Milliseconds $timer;
        $timer = $timer*2;
      }
    } catch
    {
      Write-Output $_ | Out-File -FilePath ".\logging.log" -Append -Encoding ansi;
    }
  }
  
  process
  {
    [Char]$sb = 0x0b;
    [Char]$fs = 0x1c;
    [Char]$cr = 0x0d;
    $messageContent = $sb + $messageContent + $fs + $cr;
    [Byte[]]$messageBuffer = [System.Text.Encoding]::ASCII.GetBytes($messageContent);
    try
    {
      $sendStream = $socket.GetStream();
      $sendStream.CanWrite | Out-File -FilePath ".\logging.log" -Append -Encoding ansi;
      $sendStream.Write($messageBuffer, 0, $messageBuffer.Length);
      $sendstream.Flush();
    } catch
    {
      Write-Output $_ | Out-File -FilePath ".\logging.log" -Append -Encoding ansi;
    }
  }
  
  end
  {
    $sendStream.Close();
    $socket.Close();
  }
}
