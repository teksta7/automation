#This powershell script allows an Exchange admin to change calendar permissions for all users such as making all calendars visible or restricting their view
cls
Write-Output "======================================================="
Write-host   "== Checking if Exchange module is installed ===========" -foreground "yellow"
Write-Output "======================================================="
if (Get-Module -ListAvailable -Name ExchangeOnlineManagement) {
    Write-Output "======================================================="
    Write-host   "============= Exchange module installed ===============" -foreground "green"
    Write-Output "======================================================="
} 
else {
    Write-Output "======================================================="
    Write-host   "= Exchange module not installed, installing module... =" -foreground "yellow"
    Write-Output "======================================================="
    Install-Module ExchangeOnlineManagement
    Write-Output "======================================================="
    Write-host   "============= Exchange module installed ===============" -foreground "green"
    Write-Output "======================================================="
}
Write-Output "======================================================="
Write-host   "============= Attempting sign in... ===================" -foreground "yellow"
Write-Output "======================================================="
Connect-ExchangeOnline
Write-Output "======================================================="
Write-host   "============= Sign in successful ======================" -foreground "green"
Write-Output "======================================================="
Write-Output "======================================================="
Write-host   "============= Calendar permission setup ===============" -foreground "yellow"
Write-Output "======================================================="
$useAccess = Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox"} | Select Identity
Write-Host "This is a list of the calendar permissions you can set as detailed in Microsoft Documentation

Owner
------
Indicates that the user can create, read, edit, and delete all items in the folder, and create subfolders. The user is both folder owner and folder contact.

PublishingEditor
-----------------
Indicates that the user can create, read, edit, and delete all items in the folder, and create subfolders.

Editor
-------
Indicates that the user can create, read, edit and delete all items in the folder.

PublishingAuthor
----------------
Indicates that the user can create and read all items in the folder, edit and delete only items that the user creates, and create subfolders.

Author
-------
Indicates that the user can create and read all items in the folder, and edit and delete only items that the user creates.

NoneditingAuthor
-----------------
Indicates that the user can create and read all items in the folder, and delete only items that the user creates.

Reviewer
---------
Indicates that the user can read all items in the folder. (Opens a calendar to be fully viewable within an organisation)

Contributor
------------
Indicates that the user can create items in the folder. The contents of the folder do not appear.

FreeBusyTimeOnly
------------------
Indicates that the user can view only free/busy time within the calendar.

FreeBusyTimeAndSubjectAndLocation
----------------------------------
Indicates that the user can view free/busy time within the calendar and the subject and location of appointments.

Custom
--------
Indicates that the user has custom access permissions on the folder. "

Write-Host "---------------------" -foreground "yellow"
$accRight=read-host "Please enter the access rights you want to set for all user calendars. Ex: Reviewer"
ForEach ( $user in $useAccess ) {
Get-Mailbox -ResultSize Unlimited | ForEach {
If ( $_.Identity -ne $user.Identity ) {
    Write-Output "======================================================="
    Write-host   "=== Checking" $user.Identity "permissions against" $_.Identity "===" -foreground "Yellow"
    Write-Output "======================================================="
    $currentRights=Get-MailboxFolderPermission -Identity "$($_.SamAccountName):\calendar" | select -ExpandProperty AccessRights
if ($currentRights.Contains($accRight)) {
    Write-Output "======================================================="
    Write-host   "= Access rights are already set, no change required ===" -foreground "green"
    Write-Output "======================================================="
}
else {
    Write-Output "======================================================="
    Write-host   "======== Access rights differ, updating...===== =======" -foreground "yellow"
    Write-Output "======================================================="
    Write-Output "======================================================="
    Write-host   "======== Removing existing calendar permissions =======" -foreground "yellow"
    Write-Output "======================================================="
    Remove-MailboxFolderPermission "$($_.SamAccountName):\calendar" -User $user.Identity -Confirm:$false
    Write-Output "= Ignoring error due to no permissions currently set =="
    Write-Output "======================================================="
    Write-host   "======== Adding new calendar permissions =======" -foreground "yellow"
    Write-Output "======================================================="
    Add-MailboxFolderPermission "$($_.SamAccountName):\calendar" -User $user.Identity -AccessRights $accRight
    Set-MailboxFolderPermission "$($_.SamAccountName):\calendar" -User $user.Identity -AccessRights $accRight
}

}
}
}
Write-Output "======================================================="
Write-host   "============ CALENDAR INFORMATION UPDATING ============" -foreground "green"
Write-Output "======================================================="
ForEach ($mbx in Get-Mailbox -ResultSize Unlimited) {Get-MailboxFolderPermission ($mbx.Name + “:\Calendar”) | Select Identity,User,AccessRights | ft -Wrap -AutoSize}
Write-Output "======================================================="
Write-host   "============ OPERATION COMPLETE =======================" -foreground "green"
Write-Output "======================================================="