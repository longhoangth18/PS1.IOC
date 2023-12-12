# Outbound Connections Checker

![Logo](https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/PowerShell_5.0_icon.png/120px-PowerShell_5.0_icon.png)

This tool is designed to check for outbound connections on a system and display information about the processes involved. It helps identify potential botnet or malicious activity by monitoring established connections and providing details about the processes and IP addresses involved.

## Features
- Live Mode: Continuously monitors for outbound connections and displays real-time information.
- Run Once: Performs a single check for outbound connections and displays the results.

## Installation
1. Clone the repository: `git clone https://github.com/longhoangth18/PS1.IOC`
2. Change into the project directory: `cd PS1.IOC`
3. Run the script: `powershell -ExecutionPolicy Bypass -File OutboundConnectionsChecker.ps1`

## Usage
1. Live Mode: Continuously monitor for outbound connections and display information.
   - Open a PowerShell terminal.
   - Navigate to the project directory: `cd PS1.IOC`
   - Run the script: `powershell -ExecutionPolicy Bypass -File OutboundConnectionsChecker.ps1`
2. Run Once: Perform a single check for outbound connections and display the results.
   - Open a PowerShell terminal.
   - Navigate to the project directory: `cd PS1.IOC`
   - Run the script: `powershell -ExecutionPolicy Bypass -File OutboundConnectionsChecker.ps1`

## Configuration
You can modify the script to fit your specific needs. For example, you can adjust the time interval between checks in the "Live Mode" or customize the output format.

## Contributing
Contributions to this project are welcome. Feel free to open an issue or submit a pull request with any improvements or bug fixes.

## License
This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
