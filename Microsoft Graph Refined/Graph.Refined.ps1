function Refine {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]
        $InputObject,

        [switch] $limit
    )

    foreach ($object in $InputObject) {
        if ($object -is [string] -or $object.GetType().IsPrimitive) {
            $object
            return
        }
    
        $NewObj = @{ }
        $PropertyList = $object.PSObject.Properties | Where-Object { $null -ne $_.Value }
        foreach ($Property in $PropertyList) {
            If ($limit) {
                if (($property.TypeNameOfValue -eq "System.String") -or ($property.TypeNameOfValue -eq "System.String[]")){
                    $NewObj[$Property.Name] = $Property.Value
                }
            } Else {
                $NewObj[$Property.Name] = $Property.Value
            }
        }
        [PSCustomObject]$NewObj
    } 
}