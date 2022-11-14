# alternative to Test-Netconnection
function tp($i, $p) {
    $t=New-Object Net.Sockets.TcpClient;
    try{
        $t.Connect($i,$p);
        Write-Host -f green "[$i`:$p] Successful"
    }catch{
        Write-Host -f red "[$i`:$p] Failed"
    }finally{
        try{$t.Dispose()
        }catch{}
    }
}

$region='us-east-1'

"ssm","ssmmessages","ec2messages" |
    ForEach-Object {
        tp "$_.$region.amazonaws.com" 443
    }
