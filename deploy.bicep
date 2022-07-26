 module aci 'container-instance.bicep' = [for i in range(1, 3): {
   name: 'ContainerInstanceDeploy${i}'
   params: {
     name: 'agent-${i}'
   }
 }]
 