$currentVersion=$(containerd --version);
$version="1.7.0-beta.3";

if ($currentVersion -notlike "*$version*"){
    echo "Updating containerd version $currentVersion to $version";
    curl.exe  -o containerd-windows-amd64.tar.gz -L https://github.com/containerd/containerd/releases/download/v$version/containerd-$version-windows-amd64.tar.gz;
    tar.exe xvf .\containerd-windows-amd64.tar.gz;
    echo "Stop services";
    echo "$Env:ProgramFiles";
    Stop-Service kubeproxy; Stop-Service kubelet; Stop-Service containerd;
    echo "Replace ctr.exe";
    Copy-Item -Path ".\bin\ctr.exe" -Destination "$Env:ProgramFiles\containerd" -Force;
    Copy-Item -Path ".\bin\containerd-shim-runhcs-v1.exe" -Destination "$Env:ProgramFiles\containerd" -Force;
    Copy-Item -Path ".\bin\containerd.exe" -Destination "$Env:ProgramFiles\containerd" -Force;
    echo "Start service";
    Start-Service containerd; Start-Service kubeproxy; Start-Service kubelet;
    echo "Finished installing containerd";        
} else {
    echo "$version version of containerd already installed"
}

if(![System.IO.File]::Exists("C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe")){ 
    echo "Install NVIDIA GRID driver";
    curl.exe -L -o nvidia_grid.exe https://download.microsoft.com/download/7/3/6/7361d1b9-08c8-4571-87aa-18cf671e71a0/512.78_grid_win10_win11_server2016_server2019_server2022_64bit_azure_swl.exe
    Start-Process -FilePath nvidia_grid.exe -Wait -ArgumentList '-s'
} else {
    echo "GPU drivers already installed"
}
