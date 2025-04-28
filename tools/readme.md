# startup command 
```bash
chainlit run app.py --host 0.0.0.0 --port 80
```


```bash
# ssh connect
# az webapp ssh --name <your-webapp-name> --resource-group <your-resource-group>
az webapp ssh --name 'lexatlas-frontend' --resource-group 'mg-demo10'

# list
az webapp list --query "[].{name:name, resourceGroup:resourceGroup, location:location}" --output table


# logs
# az webapp log tail --name <your-webapp-name> --resource-group <your-resource-group>
az webapp log tail --name 'lexatlas-frontend' --resource-group 'mg-demo10'


# az webapp show --name <your-webapp-name> --resource-group <your-resource-group> --query "state" --output table
az webapp show --name 'lexatlas-frontend' --resource-group 'mg-demo10' --query "state" --output table

```