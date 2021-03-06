echo "Starting tb-mqtt-transports logs collection ..."

New-Item -ItemType Directory -Force -Name tb-mqtt-transports-logs

Remove-Item -Recurse -Force tb-mqtt-transports-logs/*

echo "Waiting for tb-mqtt-transports..."

C:\k8s\oc.exe rollout status deployment/tb-mqtt-transport; if (-not $?) { echo 'Failed to get tb-mqtt-transports deployment status. Exiting...' ; exit 1; }

$nodes = ( $(C:\k8s\oc.exe get pods | Select-String -Pattern "tb-mqtt-transport-" | %{ $_.Line.Split( )[0]; }) )

$len=$nodes.Count

echo "Found $len tb-mqtt-transports..."

if ($len -eq 0) { echo "No tb-mqtt-transports pods found! Exiting...";  exit 1; }

For ( $i=0; $i -lt $len; $i++ ) {
    $node = $nodes[$i]
    echo "${i}: $node"
    Start-Job -ScriptBlock { switch ($input) { {$true} { $foo = $_ ; C:\k8s\oc.exe logs -f $_ --since=1m | Out-File C:\k8s\tb-mqtt-transports-logs\$_.log -Append } }  } -InputObject $node
}

echo "Collecting tb-mqtt-transports logs..."

Wait-Job -Any

echo "Finished tb-mqtt-transports logs collection."


