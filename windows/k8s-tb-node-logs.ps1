echo "Starting tb-nodes logs collection ..."

Get-job | Remove-job -Force

New-Item -ItemType Directory -Force -Name tb-node-logs

Remove-Item -Recurse -Force tb-node-logs/*

echo "Waiting for tb-nodes..."

C:\k8s\oc.exe rollout status statefulset/tb-node; if (-not $?) { echo 'Failed to get tb-nodes statefulset status. Exiting...' ; exit 1; }

$nodes = ( $(C:\k8s\oc.exe get pods | Select-String -Pattern "tb-node-" | %{ $_.Line.Split( )[0]; }) )

$len=$nodes.Count

echo "Found $len tb-nodes..."

if ($len -eq 0) { echo "No tb-nodes pods found! Exiting...";  exit 1; }

For ( $i=0; $i -lt $len; $i++ ) {
    $node = $nodes[$i]
    echo "${i}: $node"
    Start-Job -ScriptBlock { switch ($input) { {$true} { $foo = $_ ; C:\k8s\oc.exe logs -f $_ --since=1m | Out-File C:\k8s\tb-node-logs\$_.log -Append } }  } -InputObject $node
}

echo "Collecting tb-node logs..."

Wait-Job -Any

echo "Finished tb-nodes logs collection."


