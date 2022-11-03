$importedList = Get-Content -Path './172addresses.txt'
$lookup_results = @()

foreach($address in $importedList){
    $lookup = nslookup $address
    if($lookup.length -eq 3){
        $name = 'No Resolution'
    }
    else {
        $name = $lookup[3].substring(5)
    }
    
    $lookup_results += [PSCustomObject]@{
        Address = $address
        Name = $name
    }
}

$lookup_results | Export-Csv lookup_results.csv -NoTypeInformation


