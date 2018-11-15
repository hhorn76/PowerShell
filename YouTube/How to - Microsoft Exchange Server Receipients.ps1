#Enable scripting on Server
Get-ExecutionPolicy
Set-ExecutionPolicy RemoteSigned -Force

#Import Microsoft.Exchange Module
$emsCred=Get-Credential
$emsServer="mail.mydomain.com"
$emsServer="cas1.mis-munich.de"
$emsSession=New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$($emsServer)/Powershell" -Credential $emsCred
Import-Module(Import-PSSession $emsSession -AllowClobber)

#Demonstrate Enable-Mailbox with exisitng AD user
$strName="123"
New-ADUser $strName
Enable-Mailbox -Identity $strName -Database $strDatabase -Alias $strName
Remove-ADUser $strName -Confirm:$false

#Demonstrate Enable-MailContact with exisitng AD contact
$strName="345"
New-ADObject -Type Contact -Name $strName -Path $strContactPath
Enable-MailContact -Identity $strName -ExternalEmailAddress "test@mydomain.com"
Remove-MailContact $strName -Confirm:$false

#Demonstrate New-Mailbox and Set-Mailbox
$strName="123"
$strEmail="123@mydomain.com"
$strOrg="OU=MyOU,DC=mydomain,DC=com"
$secStrPw=ConvertTo-SecureString "MyPassword0" -AsPlainText -Force
New-Mailbox -Name $strName -DisplayName $strName -UserPrincipalName $strEmail -Password $secStrPw -Alias $strName -OrganizationalUnit $strOrg -ResetPasswordOnNextLogon:$false -Database $strDatabase

Set-Mailbox -Identity $strName -DisplayName "$($strName) User"
$user=Get-Mailbox -Identity $strName
$user.DisplayName

#Demonstrate New-MailContact, Set-MailContact and Remove-MailContact
$strName="345"
$strExtMail="345@mydomain.com"
$strFirst="3"
$strLast="45"
New-MailContact -Name $strName -DisplayName $strName -ExternalEmailAddress $strExtMail -FirstName $strFirst -LastName $strLast
Set-MailContact -Identity $strName -DisplayName "$($strName) User"
Remove-MailContact $strName -Confirm:$false

#Demonstrate RecipientTypeDetails
Get-Mailbox hhorn | ft RecipientTypeDetails
Get-Mailbox Calendars | ft RecipientTypeDetails

#Demonstrate equipment mailbox 
New-Mailbox testEquip -Equipment
Get-Mailbox testEquip | ft RecipientTypeDetails
Remove-Mailbox testEquip -Confirm:$false

#Demonstrate room mailbox
New-Mailbox testRoom -Room
Get-Mailbox testRoom | ft RecipientTypeDetails
Remove-Mailbox testRoom -Confirm:$false

#Demonstrate shared mailbox
New-Mailbox testShared1 -Shared
Get-Mailbox testShared1 | ft RecipientTypeDetails
Remove-Mailbox testShared1 -Confirm:$false

#Demonstrate converting user mailbox to shard mailbox
New-Mailbox testShared2 -Password $secStrPw -UserPrincipalName $testShared2uP
Get-Mailbox testShared2 | ft RecipientTypeDetails
Set-Mailbox -Identity testShared2 -Type Shared
Get-Mailbox testShared2 | ft RecipientTypeDetails
Remove-Mailbox testShared2 -Confirm:$false

#Demonstrate Send-MailMessage
$strTo="hhorn@mydomain.com"
$strFrom="123@mydomain.com"
$strSubject="Test Email"
$strBody="<H1>This is a test email</H1>"
Send-MailMessage -To $strTo -From $strFrom -Subject $strSubject -BodyAsHtml $strBody -SmtpServer $emsServer #-Credential $emsCred

#Demonstrate DistributionGroup
New-DistributionGroup -Name "Managers" -OrganizationalUnit "Users" -SamAccountName "Managers" -Type "Distribution"
Set-DistributionGroup -Identity "Managers" -DisplayName "Managers Distribution Group"
Remove-DistributionGroup -Identity Managers -Confirm:$false

#Demonstrate Enable-DistributionGroup
New-ADGroup 4321 -GroupCategory Security -GroupScope Universal -ManagedBy hhorn
Enable-DistributionGroup -Identity 4321
Remove-DistributionGroup -Identity 4321 -Confirm:$false

#Demonstrate Get-MailboxStatistics
$strName="123"
Get-Mailbox $strName | Get-MailboxStatistics | fl
Get-MailboxStatistics -Identity hhorn | fl DisplayName,ItemCount,TotalItemSize
Get-MailboxStatistics -Database $strDatabase -Filter 'TotalItemSize -gt 10737418240' | Select-Object @{name="TotalItemSize"; expression={($_.TotalItemSize.ToString())}},ItemCount |Sort "TotalItemSize" -Descending

#Demonstrate Get-MailboxCalendarFolder
Get-Mailbox $strName | % {Get-MailboxCalendarFolder "$($_.Identity):\Calendar"} | fl DetailLevel,PublishEnabled

#Demonstrate Get-MailboxFolderStatistics
$mailBoxStat=Get-MailboxFolderStatistics -Identity $strName
$mailBoxStat.count
$mailBoxStat=Get-Mailbox $strName | Get-MailboxFolderStatistics
$mailBoxStat.count

#Demonstrate Get-MailboxFolderStatistics ForEach-Object
Get-MailboxFolderStatistics $strName | %{$_.Identity}

#Demonstrate Get-MailboxPermission
Get-Mailbox $strName | Get-MailboxPermission | ?{$_.User -like "NT *"} | ft User,AccessRights,IsInherited,Deny

#Demonstrate Add-MailboxPermission and Remove-MailboxPermission
$mailBox=Get-Mailbox $strName
Add-MailboxPermission -Identity "$($mailBox.Identity)" -User hhorn -AccessRights FullAccess | Out-Null
Get-Mailbox $strName | Get-MailboxPermission | ?{$_.User -like "*hhorn"} | ft AccessRights,IsInherited,Deny
Remove-MailboxPermission -Identity "$($mailBox.Identity)" -User hhorn -AccessRights FullAccess -Confirm:$false
Get-Mailbox $strName | Get-MailboxPermission | ?{$_.User -like "*hhorn"} | ft AccessRights,IsInherited,Deny

#Demonstrate Get-MailboxFolderPermission
Get-MailboxFolderPermission "$($strName):\Calendar"

#Demonstrate Add-MailboxFolderPermission and Remove-MailboxFolderPermission
$mailBox=Get-Mailbox $strName
Add-MailboxFolderPermission -Identity "$($strName):\Calendar" -User hhorn -AccessRights Editor
Get-MailboxFolderPermission "$($strName):\Calendar"
Remove-MailboxFolderPermission -Identity "$($strName):\Calendar" -User hhorn -Confirm:$false
Get-MailboxFolderPermission "$($strName):\Calendar"

#Demonstrate BlockedSendersAndDomains with Get-MailboxJunkEmailConfiguration
$Blocked=Get-Mailbox hhorn | Get-MailboxJunkEmailConfiguration | Select-Object -ExpandProperty BlockedSendersAndDomains
$Blocked.Count

#Demonstrate enable auto reply for mailbox
$dateStart=Get-Date
$dateEnd=(Get-Date).AddDays(10)
$strExtMessage="<p>Dear sender,</br>I will be out if the office till the $($dateEnd)</br>In urgent cases please contact Heiko Horn (hhorn@mydomain.com)</br>Kind regards</br>123</p>"
$strIntMessage="<p>Hey,</br>I will be back on $($dateEnd).</br>See you soon!</p>"
Set-MailboxAutoReplyConfiguration $strName –AutoReplyState Scheduled –StartTime $dateStart –EndTime $dateEnd –ExternalMessage $strExtMessage –InternalMessage $strIntMessage

#Demonstrate disable auto reply for mailbox
Set-MailboxAutoReplyConfiguration -Identity $strName -AutoReplyState Disabled

#Demonstrate email tracking
$dateStart=(Get-Date).AddDays(-1)
Get-MessageTrackingLog -Recipients $strEmailTo -Sender $strEmailFrom -Start $dateStart | fl Timestamp, MessageSubject, EventId

#Clean-Up
Remove-Mailbox $strName -Confirm:$false
Remove-PSSession $emsSession
