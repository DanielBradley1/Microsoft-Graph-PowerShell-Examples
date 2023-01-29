#####
# Author: Daniel Bradley
# LinkedIn: https://www.linkedin.com/in/danielbradley2/
# Twitter: https://twitter.com/DanielatOCN
# Website: https://ourcloudnetwork.com/
# Info: This script was written by Daniel Bradley for the Microsoft Graph PowerShell Zero to Hero Book
#####

Import-Module Microsoft.Graph.Groups
Connect-MgGraph -Scope Group.ReadWrite.All

$group = Get-MgGroup -Search '"DisplayName:Test2"' -ConsistencyLevel eventual
$user = Get-MgUser -Search '"DisplayName:Daniel Bradley 2"' -ConsistencyLevel eventual

New-MgGroupMember -GroupId $group.id -DirectoryObjectId $user.id