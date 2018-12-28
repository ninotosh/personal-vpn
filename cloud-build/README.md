```sh
make create-docker-hub-keyring
```

```
make list-keyrings
```

```
make create-docker-hub-crypto-key
```

```
make list-keys
```

```
docker_hub_password=`cat`
```

```
encrypted_docker_hub_password=`echo -n $docker_hub_password | make encrypt-docker-hub-password`
```

```
cat cloudbuild-template.yaml \
| sed "s/\${PROJECT_ID}/`gcloud config get-value project`/g" \
| sed "s/\${encrypted_docker_hub_password}/${encrypted_docker_hub_password}/g" \
> cloudbuild-generated.yaml
```

```
make DOCKER_USER=your_user_name_at_docker_hub dry-run
```


```
make DOCKER_USER=your_user_name_at_docker_hub build-local
```
