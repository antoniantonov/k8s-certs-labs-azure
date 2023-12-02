# Dockerfile sample with explanations
```Dockerfile
Every RUN command will create a new layer - meaning if you store something there it will be available in final image.
```

# Run two containers in the same process namespace (PID)
```bash
docker run --name app1 -d nginx:alpine sleep infinity
docker exec app1 ps aux

# The important part here is the --pid=container:app1
docker run --name app2 --pid=container:app1 -d nginx:alpine sleep infinity
docker exec app1 ps aux
docker exec app2 ps aux
```