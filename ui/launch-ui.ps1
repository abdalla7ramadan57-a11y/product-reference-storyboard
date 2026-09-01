Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$stateDir = Join-Path $HOME '.product-reference-storyboard'
$inboxDir = Join-Path $stateDir 'inbox'
New-Item -ItemType Directory -Force -Path $inboxDir | Out-Null

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Product Reference Storyboard'
$form.Size = New-Object System.Drawing.Size(620, 360)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

$title = New-Object System.Windows.Forms.Label
$title.Text = 'Choose inputs and output mode'
$title.Font = New-Object System.Drawing.Font('Segoe UI', 14, [System.Drawing.FontStyle]::Bold)
$title.Location = New-Object System.Drawing.Point(20, 18)
$title.Size = New-Object System.Drawing.Size(560, 32)
$form.Controls.Add($title)

$videoLabel = New-Object System.Windows.Forms.Label
$videoLabel.Text = 'Reference video'
$videoLabel.Location = New-Object System.Drawing.Point(20, 72)
$videoLabel.Size = New-Object System.Drawing.Size(130, 22)
$form.Controls.Add($videoLabel)

$videoBox = New-Object System.Windows.Forms.TextBox
$videoBox.Location = New-Object System.Drawing.Point(155, 68)
$videoBox.Size = New-Object System.Drawing.Size(330, 25)
$videoBox.ReadOnly = $true
$form.Controls.Add($videoBox)

$videoBtn = New-Object System.Windows.Forms.Button
$videoBtn.Text = 'Choose video...'
$videoBtn.Location = New-Object System.Drawing.Point(495, 66)
$videoBtn.Size = New-Object System.Drawing.Size(95, 29)
$form.Controls.Add($videoBtn)

$imageLabel = New-Object System.Windows.Forms.Label
$imageLabel.Text = 'Product image'
$imageLabel.Location = New-Object System.Drawing.Point(20, 115)
$imageLabel.Size = New-Object System.Drawing.Size(130, 22)
$form.Controls.Add($imageLabel)

$imageBox = New-Object System.Windows.Forms.TextBox
$imageBox.Location = New-Object System.Drawing.Point(155, 111)
$imageBox.Size = New-Object System.Drawing.Size(330, 25)
$imageBox.ReadOnly = $true
$form.Controls.Add($imageBox)

$imageBtn = New-Object System.Windows.Forms.Button
$imageBtn.Text = 'Choose image...'
$imageBtn.Location = New-Object System.Drawing.Point(495, 109)
$imageBtn.Size = New-Object System.Drawing.Size(95, 29)
$form.Controls.Add($imageBtn)

$modeLabel = New-Object System.Windows.Forms.Label
$modeLabel.Text = 'Output'
$modeLabel.Location = New-Object System.Drawing.Point(20, 160)
$modeLabel.Size = New-Object System.Drawing.Size(130, 22)
$form.Controls.Add($modeLabel)

$videoMode = New-Object System.Windows.Forms.RadioButton
$videoMode.Text = 'Video JSON Prompt'
$videoMode.Location = New-Object System.Drawing.Point(155, 158)
$videoMode.Size = New-Object System.Drawing.Size(150, 24)
$videoMode.Checked = $true
$form.Controls.Add($videoMode)

$storyMode = New-Object System.Windows.Forms.RadioButton
$storyMode.Text = 'Storyboard'
$storyMode.Location = New-Object System.Drawing.Point(320, 158)
$storyMode.Size = New-Object System.Drawing.Size(120, 24)
$form.Controls.Add($storyMode)

$note = New-Object System.Windows.Forms.Label
$note.Text = 'This UI stores selected files locally for compatible local agents. For hosted ChatGPT/Claude, attach the selected files to the chat normally.'
$note.Location = New-Object System.Drawing.Point(20, 200)
$note.Size = New-Object System.Drawing.Size(565, 45)
$form.Controls.Add($note)

$goBtn = New-Object System.Windows.Forms.Button
$goBtn.Text = 'Continue'
$goBtn.Location = New-Object System.Drawing.Point(390, 260)
$goBtn.Size = New-Object System.Drawing.Size(95, 34)
$form.Controls.Add($goBtn)

$cancelBtn = New-Object System.Windows.Forms.Button
$cancelBtn.Text = 'Cancel'
$cancelBtn.Location = New-Object System.Drawing.Point(495, 260)
$cancelBtn.Size = New-Object System.Drawing.Size(95, 34)
$form.Controls.Add($cancelBtn)

$script:videoPath = $null
$script:imagePath = $null

$videoBtn.Add_Click({
    $d = New-Object System.Windows.Forms.OpenFileDialog
    $d.Filter = 'Video files|*.mp4;*.mov;*.mkv;*.webm;*.avi|All files|*.*'
    if ($d.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $script:videoPath = $d.FileName
        $videoBox.Text = $d.FileName
    }
})

$imageBtn.Add_Click({
    $d = New-Object System.Windows.Forms.OpenFileDialog
    $d.Filter = 'Image files|*.png;*.jpg;*.jpeg;*.webp;*.bmp|All files|*.*'
    if ($d.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $script:imagePath = $d.FileName
        $imageBox.Text = $d.FileName
    }
})

$cancelBtn.Add_Click({ $form.Close() })

$goBtn.Add_Click({
    $mode = if ($storyMode.Checked) { 'storyboard' } else { 'video' }
    $manifest = [ordered]@{
        skill = 'product-reference-storyboard'
        version = '4.0.0'
        mode = $mode
        reference_video = $script:videoPath
        product_image = $script:imagePath
        created_at = (Get-Date).ToString('o')
    }
    $manifestPath = Join-Path $inboxDir 'current.json'
    $manifest | ConvertTo-Json -Depth 5 | Set-Content -Path $manifestPath -Encoding UTF8
    Set-Clipboard -Value "/product-reference-storyboard $mode"
    [System.Windows.Forms.MessageBox]::Show("Selection saved. Invocation copied to clipboard:`n/product-reference-storyboard $mode`n`nFor hosted chat, attach the chosen files before sending the command.", 'Ready') | Out-Null
    $form.Close()
})

[void]$form.ShowDialog()
