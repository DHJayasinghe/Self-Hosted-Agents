# Azure DevOps Self-Hosted Agent - Windows Agent

## How to Run

docker run -d -e AZP_URL=https://dev.azure.com/{ORGANIZATION} -e AZP_TOKEN={PERSONAL_ACCESS_TOKEN} -e AZP_AGENT_NAME={AGENT_NAME} --network "Default Switch" hasitha2kandy/dockeragent:latest

Make sure PAT has Agent Pool Read & Execute Permission.
![image](https://user-images.githubusercontent.com/26274468/201583530-b5b7dd0b-f3c5-4ade-ae76-5800ed24b00e.png)

## Capabilities
1. azure-cli
2. Azure powershell
3. Bicep
4. AzCopy v10
5. Git
6. Dotnet 6.0 SDK
7. Dotnet Core SDK
8. Node.js 16
