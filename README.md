# PowerLLP-Client
Limited MLLP-based TCP client to send a single message to a destination.

ASCII based, initial iteration is a PowerShell function.

## How to Use

Download the `powerllp.ps1` script and load the contained **deliverMessage** function using dot reference:

```PowerShell
C:\temp > . .\powerllp.ps1
```

Then enter an IP address as a string, a port as an integer, and pass an HL7 message to send. Simple logging in a `logging.log` file that simply highlights a connection permits content can be written to the destination.

### Examples

```PowerShell
C:\temp > deliverMessage -remoteAddres "127.0.0.1" -remotePort 1337 -messageContent "MSH|..." 
```

PowerShell doesn't work well with multi-line strings, so I find it better to pass a string variable/object instead. This can be accomplished by using the `Get-Content` cmdlet to retrieve content from a file, and then pass it to the function:

```PowerShell
C:\temp > [String]$message = Get-Content -Path C:\temp\message_sample.txt
> deliverMessage -remoteAddress "127.0.0.1" -remotePort 1337 -messageContent $message
```
