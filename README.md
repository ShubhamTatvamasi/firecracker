# firecracker


Generate Swagger UI documentation for Firecracker using Docker:
```bash
docker run --rm -v $(pwd):/app node:24-alpine sh -c "\
apk add --no-cache curl && \
npm install -g swagger-ui-dist && \
mkdir -p /app/docs && \
cp -r \$(npm root -g)/swagger-ui-dist/* /app/docs && \
curl -o /app/docs/firecracker.yaml https://raw.githubusercontent.com/firecracker-microvm/firecracker/main/src/firecracker/swagger/firecracker.yaml && \
echo 'window.onload = function() { const ui = SwaggerUIBundle({ url: \"firecracker.yaml\", dom_id: \"#swagger-ui\" }); };' > /app/docs/swagger-initializer.js"
```
