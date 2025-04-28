# startup command 
```bash
chainlit run app.py --host 0.0.0.0 --port 80
```


```bash
# ssh connect
# az webapp ssh --name <your-webapp-name> --resource-group <your-resource-group>
az webapp ssh --name 'mg-demo200-frontend' --resource-group 'mg-demo200'

# list
az webapp list --query "[].{name:name, resourceGroup:resourceGroup, location:location}" --output table
# mg-demo200-frontend  mg-demo200       East US 2


# logs
# az webapp log tail --name <your-webapp-name> --resource-group <your-resource-group>
az webapp log tail --name 'mg-demo200-frontend' --resource-group 'mg-demo200'


# az webapp show --name <your-webapp-name> --resource-group <your-resource-group> --query "state" --output table
az webapp show --name 'mg-demo200-frontend' --resource-group 'mg-demo200' --query "state" --output table

```