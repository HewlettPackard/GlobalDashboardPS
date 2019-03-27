function BuildPath {
    [CmdletBinding()]
    param (
        $Resource,
        $Entity
    )
    if ($Entity) {
        if($Entity -is [string]){
            $Resource += "/$Entity"
        }
        elseif ($Entity -is [object]) {
            if ($Entity.category -eq $Resource) {
                $Resource = $Entity.uri
            }
            else {
                $Resource += "/$($Entity.id)"
            }
        }
    }
    return $resource
}
