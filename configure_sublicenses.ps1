$users = Get-MsolUser -All | Where-Object {$_.isLicensed -eq $true}
$user_to_change_list = Import-Csv users.csv
$emails_to_change_list = $user_to_change_list.email
$to_disable_arr = "YAMMER_EDU","MCOSTANDARD","EXCHANGE_S_STANDARD", "Deskless", "STREAM_O365_E3", "FLOW_O365_P2", "POWERAPPS_O365_P2", "PROJECTWORKMANAGEMENT"

foreach($user in $users) {
    Write-Host "Checking " $user.UserPrincipalName -ForegroundColor Cyan
    if ($emails_to_change_list.Contains($user.UserPrincipalName)) {
        Write-Host "User is tasked for checking" -ForegroundColor Green
        $user_licenses = $user.Licenses
        Write-Host "User has " $user_licenses.count "license(s)"
        foreach($user_lic in $user.Licenses) {
            $DisabledServicNames = @()
            $DisabledServicNames = ($user_lic.ServiceStatus | Where-Object -Property ProvisioningStatus -Value "Disabled" -EQ).ServicePlan.ServiceName
            Write-Host "Disabled Services for" $user_lic.AccountSkuId ":" $DisabledServicNames
            $AmmendedDisabledServiceNames = @()
            foreach( $to_disable in $to_disable_arr) {
                if( $DisabledServicNames -notcontains $to_disable) {
                    Write-Host "User " $user.UserPrincipalName "(" $user_lic.AccountSkuId ") has "$to_disable"." -ForegroundColor Green
                    $AmmendedDisabledServiceNames += $to_disable
                }
            }

            if( $AmmendedDisabledServiceNames ) {
                if($DisabledServicNames.count -gt 0) {
                    $AmmendedDisabledServiceNames += $DisabledServicNames
                }
                Write-Host "Amended Disabled Service List: " $AmmendedDisabledServiceNames
                # From Here BE DRAGONS!!!! Disable Below to remove code which makes changes
                $NewLicense = New-MsolLicenseOptions -AccountSkuId $user_lic.AccountSkuId -DisabledPlans $AmmendedDisabledServiceNames
                Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -LicenseOptions $NewLicense
                Write-Host "Disabled Service for " $user.UserPrincipalName ": " $AmmendedDisabledServiceNames
            } else {
                Write-Host "User " $user.UserPrincipalName "doesn't have any of the services, so... doing nothing." -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "User is not tasked for changing" -ForegroundColor Red
    }
}
