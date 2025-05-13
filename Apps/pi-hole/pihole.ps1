$PiHoleImage = "https://github.com/homarr-labs/dashboard-icons/tree/main/svg/pi-hole.svg"
$piholes = @(
    'http://192.168.1.121'
    'http://192.168.1.176'
    'http://192.168.1.126'
)

$buttonStyle = @'
/* BLUE BUTTON */
.button-blue {
  padding: 15px;
  margin: 5px;
  background: linear-gradient(45deg, rgba(33, 150, 243, 0.5) 30%, rgba(66, 165, 245, 0.6) 90%);
  border-radius: 8px;
  height: 100px;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  border: 2px solid rgba(33, 150, 243, 1);
  color: #1976d2;
  font-weight: 700; /* Bolder text */
  font-size: 16px; /* Slightly larger font */
  text-transform: uppercase; /* Make text more striking */
  transition: all 0.3s ease;
  gap: 8px;
}

.button-blue:hover {
  transform: scale(1.05);
  background: linear-gradient(45deg, rgba(33, 150, 243, 0.3) 30%, rgba(66, 165, 245, 0.4) 90%);
  color: #1e88e5; /* Lighter shade on hover */
  font-weight: 600; /* Slightly lighter weight */
  border: 2px solid rgba(33, 150, 243, 0.8); /* Lighter border */
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

/* RED BUTTON */
.button-red {
  padding: 15px;
  margin: 5px;
  background: linear-gradient(45deg, rgba(244, 67, 54, 0.5) 30%, rgba(239, 83, 80, 0.6) 90%);
  border-radius: 8px;
  height: 100px;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  border: 2px solid rgba(244, 67, 54, 1);
  color: #f44336;
  font-weight: 700;
  font-size: 16px;
  text-transform: uppercase;
  transition: all 0.3s ease;
  gap: 8px;
}

.button-red:hover {
  transform: scale(1.05);
  background: linear-gradient(45deg, rgba(244, 67, 54, 0.6) 30%, rgba(239, 83, 80, 0.7) 90%);
  color: #d32f2f; /* Lighter shade on hover */
  font-weight: 600;
  border: 2px solid rgba(244, 67, 54, 0.8);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

/* YELLOW BUTTON */
.button-yellow {
  padding: 15px;
  margin: 5px;
  background: linear-gradient(45deg, rgba(255, 235, 59, 0.5) 30%, rgba(255, 238, 88, 0.6) 90%);
  border-radius: 8px;
  height: 100px;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  border: 2px solid rgba(255, 235, 59, 1);
  color: #ffd600;
  font-weight: 700;
  font-size: 16px;
  text-transform: uppercase;
  transition: all 0.3s ease;
  gap: 8px;
}

.button-yellow:hover {
  transform: scale(1.05);
  background: linear-gradient(45deg, rgba(255, 235, 59, 0.6) 30%, rgba(255, 238, 88, 0.7) 90%);
  color: #ffb300; /* Lighter shade on hover */
  font-weight: 600;
  border: 2px solid rgba(255, 235, 59, 0.8);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

/* GREEN BUTTON */
.button-green {
  padding: 15px;
  margin: 5px;
  background: linear-gradient(45deg, rgba(76, 175, 80, 0.5) 30%, rgba(102, 187, 106, 0.6) 90%);
  border-radius: 8px;
  height: 100px;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  border: 2px solid rgba(76, 175, 80, 1);
  color: #4caf50;
  font-weight: 700;
  font-size: 16px;
  text-transform: uppercase;
  transition: all 0.3s ease;
  gap: 8px;
}

.button-green:hover {
  transform: scale(1.05);
  background: linear-gradient(45deg, rgba(76, 175, 80, 0.6) 30%, rgba(102, 187, 106, 0.7) 90%);
  color: #388e3c; /* Lighter shade on hover */
  font-weight: 600;
  border: 2px solid rgba(76, 175, 80, 0.8);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

'@
New-UDStack -Direction row -Spacing 1 -Children {

    New-UDStack -Direction column -Spacing 2 -Children {
        New-UDStyle -Style $buttonStyle -Content {
            New-UDButton -Text 'Enable All' -Icon 'circle-check' -OnClick {
                foreach ($ph in $piholes) {
                    Enable-PiHoleBlocking -BaseUrl $ph -Credential $Secret:pihole
                }
                Sync-UDElement -Id piholes
                Show-UDToast -Message "Enabled all Pi-holes" -Duration 2000 -Position Center
            } -ClassName "button-green" -Style @{
                height = '50px'
                width  = '175px'
            }

            New-UDButton -Text 'Disable All' -Icon 'ban' -OnClick {
                Show-UDModal -Persistent -Header {
                    New-UDTypography -Text "Set Disable Timer" -Variant h5
                } -Content {
                    New-UDGrid -Container -Children {
                        New-UDGrid -Item -ExtraSmallSize 12 -Children {
                            New-UDTextbox -Id "timer_all" -Type number -Label "Duration (seconds)" -Value 0 -Style @{
                                marginTop = '1rem'
                                width     = '100%'
                            }
                        }
                    }
                } -Footer {
                    New-UDStyle -Style $buttonStyle -Content {
                        New-UDStack -Direction row -Spacing 2 -Children {
                            New-UDButton -Text "Submit" -ClassName 'button-green' -OnClick {
                                $time = (Get-UDElement -Id "timer_all").value
                                if ($time -gt 0) {
                                    foreach ($ph in $piholes) {
                                        Disable-PiHoleBlocking -BaseUrl $ph -Credential $Secret:pihole -Timer $time
                                    }
                                    Sync-UDElement -Id piholes
                                    Show-UDToast -Message "Disabled all Pi-holes with duration $time" -Duration 2000 -Position Center
                                    #Disable-PiHoleBlocking -BaseUrl $pi -Credential $Secret:pihole -Timer $time
                                }
                                else {
                                    foreach ($ph in $piholes) {
                                        Disable-PiHoleBlocking -BaseUrl $ph -Credential $Secret:pihole
                                    }
                                    Sync-UDElement -Id piholes
                                    Show-UDToast -Message "Disabled all Pi-holes until re-enabled." -Duration 2000 -Position Center
                                }
                                Hide-UDModal
                                Sync-UDElement -Id piholes
                            } -Style @{
                                #background  = 'linear-gradient(45deg, rgba(244, 67, 54, 0.8) 30%, rgba(255, 121, 97, 0.9) 90%)'
                                height = '50px'
                                width  = '100px'
                            }
                            New-UDButton -Text "Cancel" -ClassName 'button-red' -OnClick { Hide-UDModal } -Style @{
                                height = '50px'
                                width  = '100px'
                            }
                        }
                    }
                }
            } -ClassName "button-red" -Style @{
                height = '50px'
                width  = '175px'
            }

            New-UDButton -Text 'Refresh All' -Icon 'sync' -OnClick {
                Sync-UDElement -Id piholes
                #Show-UDToast -Message "Refreshed" -Duration 2000 -Position Center
                Show-UDModal -Content { "Refreshed" } -Style @{
                    height = '300px'
                    width = '300px'
                    position = 'absolute'
                    top = '50%'
                    left = '50%'
                    transform = 'translate(-50%, -50%)'
                    background = 'rgba(76, 175, 80, 0.5)'
                }
                Start-Sleep -Seconds 2
                Hide-UDModal
            } -ClassName "button-blue" -Style @{
                height = '50px'
                width  = '175px'
            }
        }

        New-UDDynamic -Id 'allStats' -Content {
            New-UDPaper -Style @{
                padding        = '15px'
                margin         = '5px'
                background     = 'rgba(33, 150, 243, 0.1)'
                borderRadius   = '8px'
                height         = '100px'
                width          = '175px'
                display        = 'flex'
                flexDirection  = 'column'
                justifyContent = 'center'
                alignItems     = 'center'
                border         = '1px solid rgba(33, 150, 243, 1)'
            } -Children {
                New-UDTypography -Text "Total Queries" -Variant h6 -Style @{
                    color        = '#2196f3'
                    marginBottom = '8px'
                }
                New-UDTypography -Text "$($page:totalQueries.ToString('N0'))" -Variant h4 -Style @{
                    color      = '#1976d2'
                    fontWeight = 600
                }
            }

            New-UDPaper -Style @{
                padding        = '15px'
                margin         = '5px'
                background     = 'rgba(244, 67, 54, 0.1)'
                borderRadius   = '8px'
                height         = '100px'
                width          = '175px'
                display        = 'flex'
                flexDirection  = 'column'
                justifyContent = 'center'
                alignItems     = 'center'
                border         = '1px solid rgba(244, 67, 54, 1)'
            } -Children {
                New-UDTypography -Text "Total Blocked" -Variant h6 -Style @{
                    color        = '#f44336'
                    marginBottom = '8px'
                }
                New-UDTypography -Text "$($page:totalBlocked.ToString('N0'))" -Variant h4 -Style @{
                    color      = '#d32f2f'
                    fontWeight = 600
                }
            }
            
            New-UDPaper -Style @{
                padding        = '15px'
                margin         = '5px'
                background     = 'rgba(255, 235, 59, 0.1)'
                borderRadius   = '8px'
                height         = '100px'
                width          = '175px'
                display        = 'flex'
                flexDirection  = 'column'
                justifyContent = 'center'
                alignItems     = 'center'
                border         = '1px solid rgba(255, 235, 59, 10)'
            } -Children {
                New-UDTypography -Text "Block Rate" -Variant h6 -Style @{
                    color        = '#ffd600'
                    marginBottom = '8px'
                }
                New-UDTypography -Text "$page:totalPercentage%" -Variant h4 -Style @{
                    color      = '#ffc400'
                    fontWeight = 600
                }
            }

            New-UDPaper -Style @{
                padding        = '15px'
                margin         = '5px'
                background     = 'rgba(76, 175, 80, 0.1)'
                borderRadius   = '8px'
                height         = '100px'
                width          = '175px'
                display        = 'flex'
                flexDirection  = 'column'
                justifyContent = 'center'
                alignItems     = 'center'
                border         = '1px solid rgba(76, 175, 80, 1)'
            } -Children {
                New-UDTypography -Text "Domains Blocked" -Variant h6 -Style @{
                    color        = '#4caf50'
                    marginBottom = '8px'
                }
                New-UDTypography -Text "$($page:totalDomains.ToString('N0'))" -Variant h4 -Style @{
                    color      = '#388e3c'
                    fontWeight = 600
                }
            }
        }
    }

    New-UDDynamic -Id 'piholes' -Content {
        $page:totalQueries = 0
        $page:totalBlocked = 0
        $page:totalPercentage = 0
        $page:totalDomains = 0

        New-UDGrid -Container -JustifyContent space-evenly -Children {
            foreach ($pi in $piholes) {
                $PaperID = $pi -replace '.*\.(\d{3})$', '$1'
                $systemInfo = Get-PiHoleSystemInfo -BaseUrl $pi -Credential $Secret:pihole
                $piVers = Get-PiHoleVersion -BaseUrl $pi -Credential $Secret:pihole
        
        
                New-UDGrid -Item -ExtraSmallSize 12 -SmallSize 12 -MediumSize 12 -LargeSize 12 -ExtraLargeSize 6 -Children {
                    New-UDPaper -Id "pi_$PaperID" -Elevation 3 -Style @{
                        padding      = '1.5rem'
                        #margin       = 'auto'
                        Height       = '310px'
                        Width        = '600px'
                        background   = "(function() { const isDark = document.documentElement.getAttribute('data-theme') === 'dark'; return isDark ? '#3c3c3c' : 'white'; })()"
                        borderRadius = '8px'
                        boxShadow    = '0 4px 20px 0 rgba(0, 0, 0, 0.1)'
                        border       = '1px solid rgba(255, 255, 255, 0.1)'
                    } -Children {
                        New-UDGrid -Container -Spacing 2 -Children {
                            $PiStatus = try { Get-PiHoleBlocking -BaseUrl $pi -Credential $Secret:pihole } catch { $null }
                            New-UDGrid -Item -ExtraSmallSize 1 -Children {
                                New-UDImage -Url $PiHoleImage -Height 60 -Width 60
                            }
                            New-UDGrid -Item -ExtraSmallSize 3 -Children {
                                New-UDLink -Text "Pi-hole $PaperID" -Url "$pi/admin" -Variant h5 -Underline always -Style @{
                                    #color      = 'var(--ud-theme-text-primary)'
                                    fontWeight = '500'
                                }
                            }
                            New-UDGrid -Item -ExtraSmallSize 3 -Children {
                                New-UDElement -Tag 'div' -Content {
                                    switch ($PiStatus.BlockingStatus) {
                                        "enabled" {
                                            New-UDGrid -Container -Children {
                                                New-UDGrid -Item -ExtraSmallSize 4 -Children {
                                                    New-UDStyle -Style $buttonStyle -Content {
                                                        New-UDButton -Text 'Disable' -Icon 'ban' -ClassName "button-red" -Style @{
                                                            height = '60px'
                                                            width  = '120px'
                                                        } -OnClick {
                                                            Show-UDModal -Persistent -Header {
                                                                New-UDTypography -Text "Set Disable Timer" -Variant h5
                                                            } -Content {
                                                                New-UDGrid -Container -Children {
                                                                    New-UDGrid -Item -ExtraSmallSize 12 -Children {
                                                                        New-UDTextbox -Id "modal_timer_$PaperID" -Type number -Label "Duration (seconds)" -Value 0 -Style @{
                                                                            marginTop = '1rem'
                                                                            width     = '100%'
                                                                        }
                                                                    }
                                                                }
                                                            } -Footer {
                                                                New-UDStyle -Style $buttonStyle -Content {
                                                                    New-UDStack -Direction row -Spacing 2 -Children {
                                                                        New-UDButton -Text "Submit" -ClassName 'button-green' -OnClick {
                                                                            $time = (Get-UDElement -Id "modal_timer_$PaperID").value
                                                                            if ($time -and $time -gt 0) {
                                                                                Disable-PiHoleBlocking -BaseUrl $pi -Credential $Secret:pihole -Timer $time
                                                                            }
                                                                            else {
                                                                                Disable-PiHoleBlocking -BaseUrl $pi -Credential $Secret:pihole
                                                                            }
                                                                            Hide-UDModal
                                                                            Sync-UDElement -Id piholes
                                                                        } -Style @{
                                                                            #background  = 'linear-gradient(45deg, rgba(244, 67, 54, 0.8) 30%, rgba(255, 121, 97, 0.9) 90%)'
                                                                            height = '50px'
                                                                            width  = '100px'
                                                                        }
                                                                        New-UDButton -Text "Cancel" -ClassName 'button-red' -OnClick { Hide-UDModal } -Style @{
                                                                            height = '50px'
                                                                            width  = '100px'
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        "disabled" {
                                            New-UDGrid -Container -Children {
                                                New-UDGrid -Item -ExtraSmallSize 4 -Children {
                                                    New-UDStyle -Style $buttonStyle -Content {
                                                        New-UDButton -Text 'Enable' -Icon 'circle-check' -ClassName 'button-green' -Style @{
                                                            height = '60px'
                                                            width  = '120px'
                                                        } -OnClick {
                                                            Enable-PiHoleBlocking -BaseUrl $pi -Credential $Secret:pihole
                                                            Sync-UDElement -Id piholes
                                                        }
                                                    }
                                                }
                                                New-UDGrid -Item -ExtraSmallSize 8 -Children {
                                                    # Empty space to maintain grid ratio
                                                }
                                            }
                                        }
                                        default {
                                            New-UDAlert -Text "Connection Error" -Severity error -Style @{
                                                borderRadius = '8px'
                                                marginBottom = '1rem'
                                                padding      = '12px 20px'
                                                border       = '2px solid #f44336'
                                                background   = 'linear-gradient(45deg, #ffebee 30%, #ffcdd2 90%)'
                                                boxShadow    = '0 2px 8px rgba(244, 67, 54, 0.2)'
                                                fontWeight   = '500'
                                                fontSize     = '1.1rem'
                                            }
                                        }
                                    }
                                }
                            }
                            New-UDGrid -Item -ExtraSmallSize 1 -Children {
                                switch ($PiStatus.BlockingStatus) {
                                    "enabled" {
                                        New-UDAlert -Text 'Blocking Enabled' -Severity success -Style @{
                                            borderRadius   = '8px'
                                            padding        = '6px 16px'
                                            border         = '2px solid rgba(76, 175, 80, 0.5)'
                                            background     = 'linear-gradient(45deg, rgba(76, 175, 80, 0.15) 30%, rgba(76, 175, 80, 0.25) 90%)'
                                            boxShadow      = '0 2px 8px rgba(76, 175, 80, 0.2)'
                                            fontWeight     = '500'
                                            fontSize       = '1rem'
                                            height         = '60px'
                                            width          = '200px'
                                            display        = 'flex'
                                            alignItems     = 'center'
                                            justifyContent = 'center'
                                            marginTop      = '4px'
                                            color          = '#66bb6a'
                                        }
                                    }
                                    "disabled" {
                                        New-UDAlert -Text 'Blocking Disabled' -Severity error -Style @{
                                            borderRadius   = '8px'
                                            padding        = '6px 16px'
                                            border         = '2px solid rgba(244, 67, 54, 0.5)'
                                            background     = 'linear-gradient(45deg, rgba(244, 67, 54, 0.15) 30%, rgba(244, 67, 54, 0.25) 90%)'
                                            boxShadow      = '0 2px 8px rgba(244, 67, 54, 0.2)'
                                            fontWeight     = '500'
                                            fontSize       = '1rem'
                                            height         = '60px'
                                            width          = '200px'
                                            display        = 'flex'
                                            alignItems     = 'center'
                                            justifyContent = 'center'
                                            marginTop      = '4px'
                                            color          = '#ef5350'
                                        }
                                    }
                                    default {
                                        New-UDAlert -Text "Connection Error" -Severity error -Style @{
                                            borderRadius   = '8px'
                                            padding        = '4px 12px'
                                            border         = '2px solid #f44336'
                                            background     = 'linear-gradient(45deg, #ffebee 30%, #ffcdd2 90%)'
                                            boxShadow      = '0 2px 8px rgba(244, 67, 54, 0.2)'
                                            fontWeight     = '500'
                                            fontSize       = '0.9rem'
                                            height         = '32px'
                                            display        = 'flex'
                                            alignItems     = 'center'
                                            justifyContent = 'center'
                                            marginTop      = '4px'
                                        }
                                    }
                                }
                            }
                            New-UDGrid -Item -ExtraSmallSize 12 -Children {
                                if ($PiStatus) {
                                    try {
                                        $PiStats = Get-PiHoleStats -BaseUrl $pi -Credential $Secret:pihole

                                        $queries = if ($PiStats.queries.total) { $PiStats.queries.total } else { 0 }
                                        $blocked = if ($PiStats.queries.blocked) { $PiStats.queries.blocked } else { 0 }
                                        $blockingPercentage = if ($PiStats.queries.percent_blocked) { 
                                            [math]::Round($PiStats.queries.percent_blocked, 1)
                                        }
                                        else { 0 }
                                        $page:totalQueries = $page:totalQueries + $queries
                                        $page:totalBlocked = $page:totalBlocked + $blocked
                                        $page:totalDomains = $PiStats.gravity.domains_being_blocked

                                        New-UDGrid -Container -Spacing 1 -Children {
                                            New-UDGrid -Item -ExtraSmallSize 4 -Children {
                                                New-UDPaper -Style @{
                                                    padding        = '15px'
                                                    margin         = '5px'
                                                    background     = 'rgba(33, 150, 243, 0.1)'
                                                    borderRadius   = '4px'
                                                    height         = '80px'
                                                    display        = 'flex'
                                                    flexDirection  = 'column'
                                                    justifyContent = 'center'
                                                    alignItems     = 'center'
                                                    border         = '1px solid rgba(33, 150, 243, 1)'
                                                } -Children {
                                                    New-UDTypography -Text "Queries" -Variant caption -Style @{ 
                                                        color        = '#42a5f5'
                                                        marginBottom = '8px'
                                                    }
                                                    New-UDTypography -Text "$($queries.ToString('N0'))" -Variant h5 -Style @{ 
                                                        color      = '#2196f3'
                                                        margin     = 0
                                                        fontWeight = 600
                                                    }
                                                }
                                            }
                                            New-UDGrid -Item -ExtraSmallSize 4 -Children {
                                                New-UDPaper -Style @{
                                                    padding        = '15px'
                                                    margin         = '5px'
                                                    background     = 'rgba(244, 67, 54, 0.1)'
                                                    borderRadius   = '4px'
                                                    height         = '80px'
                                                    display        = 'flex'
                                                    flexDirection  = 'column'
                                                    justifyContent = 'center'
                                                    alignItems     = 'center'
                                                    border         = '1px solid rgba(244, 67, 54, 1)'
                                                } -Children {
                                                    New-UDTypography -Text "Blocked" -Variant caption -Style @{ 
                                                        color        = '#ef5350'
                                                        marginBottom = '8px'
                                                    }
                                                    New-UDTypography -Text "$($blocked.ToString('N0'))" -Variant h5 -Style @{ 
                                                        color      = '#f44336'
                                                        margin     = 0
                                                        fontWeight = 600
                                                    }
                                                }
                                            }
                                            New-UDGrid -Item -ExtraSmallSize 4 -Children {
                                                New-UDPaper -Style @{
                                                    padding        = '15px'
                                                    margin         = '5px'
                                                    background     = 'rgba(255, 235, 59, .1)'
                                                    borderRadius   = '4px'
                                                    height         = '80px'
                                                    display        = 'flex'
                                                    flexDirection  = 'column'
                                                    justifyContent = 'center'
                                                    alignItems     = 'center'
                                                    border         = '1px solid rgba(255, 235, 59, 10)'
                                                } -Children {
                                                    New-UDTypography -Text "Block Rate" -Variant caption -Style @{ 
                                                        color        = '#ffd600'
                                                        marginBottom = '8px'
                                                    }
                                                    New-UDTypography -Text "$blockingPercentage%" -Variant h5 -Style @{
                                                        color      = '#ffc400'
                                                        margin     = 0
                                                        fontWeight = 600
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    catch {
                                        New-UDAlert -Text "Error loading statistics: $($_.Exception.Message)" -Severity error
                                    }
                                }
                                else {
                                    New-UDAlert -Text "Connection Error" -Severity error -Style @{
                                        borderRadius = '8px'
                                        marginBottom = '1rem'
                                        padding      = '12px 20px'
                                        border       = '2px solid #f44336'
                                        background   = 'linear-gradient(45deg, #ffebee 30%, #ffcdd2 90%)'
                                        boxShadow    = '0 2px 8px rgba(244, 67, 54, 0.2)'
                                        fontWeight   = '500'
                                        fontSize     = '1.1rem'
                                    }
                                }
                            }

                            New-UDGrid -Id 'stats' -Item -ExtraSmallSize 12 -Children {
                                New-UDStack -Direction row -Spacing 5 -Children {
                                    New-UDTypography "Uptime days: $([math]::Round((New-TimeSpan -Seconds $systemInfo.system.uptime).TotalDays, 2))"
                                    New-UDTypography "CPU usage $([math]::Round($systemInfo.system.cpu.'%cpu',2))%"
                                    New-UDTypography "RAM usage $([math]::Round($systemInfo.system.memory.ram.'%used',2))%"
                                }
                            }

                            New-UDGrid -Id 'versions' -Item -ExtraSmallSize 12 -Children {
                                New-UDStack -Direction row -Spacing 5 -Children {
                                    New-UDStyle -Style '
                a {
                    color: #2196f3 !important;
                    text-decoration: underline !important;
                }
            ' -Content {
                                        $link = "https://github.com/pi-hole/docker-pi-hole/releases/$($piVers.version.docker.local)"            
                                        New-UDMarkdown -Markdown "DockerTag [$($piVers.version.docker.local)]($link)"
                                    }
                                    New-UDStyle -Style '
                a {
                    color: #2196f3 !important;
                    text-decoration: underline !important;
                }
            ' -Content {
                                        $link = "https://github.com/pi-hole/pi-hole/releases/$($piVers.version.core.local.version)"
                                        New-UDMarkdown -Markdown "Core [$($piVers.version.core.local.version)]($link)"
                                    }
                                    New-UDStyle -Style '
                a {
                    color: #2196f3 !important;
                    text-decoration: underline !important;
                }
            ' -Content {
                                        $link = "https://github.com/pi-hole/FTL/releases/$($piVers.version.ftl.local.version)"
                                        New-UDMarkdown -Markdown "FTL [$($piVers.version.ftl.local.version)]($link)"
                                    }
                                    New-UDStyle -Style '
                a {
                    color: #2196f3 !important;
                    text-decoration: underline !important;
                }
            ' -Content {
                                        $link = "https://github.com/pi-hole/web/release/$($piVers.version.web.local.version)"
                                        New-UDMarkdown -Markdown "Web interface [$($piVers.version.web.local.version)]($link)"
                                    }
                                }
                            }
                        }
                    }
                }
            }

        
        }

        $page:totalPercentage = if ($page:totalQueries -gt 0) {
            [math]::Round(($page:totalBlocked / $page:totalQueries) * 100, 1)
        }

        Sync-UDElement -Id allStats
    }
}