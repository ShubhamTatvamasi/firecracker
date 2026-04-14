#!/usr/bin/env bash

set -e

OUTPUT_DIR="docs"
SPEC_URL="https://raw.githubusercontent.com/firecracker-microvm/firecracker/main/src/firecracker/swagger/firecracker.yaml"

echo "🚀 Generating Swagger UI static bundle..."

docker run --rm -v "$(pwd)":/app node:24-alpine sh -c "
  apk add --no-cache curl >/dev/null && \
  npm install -g swagger-ui-dist >/dev/null 2>&1 && \
  mkdir -p /app/${OUTPUT_DIR} && \
  cp -r \$(npm root -g)/swagger-ui-dist/* /app/${OUTPUT_DIR} && \
  rm -rf /app/${OUTPUT_DIR}/node_modules /app/${OUTPUT_DIR}/package.json && \
  curl -s -o /app/${OUTPUT_DIR}/firecracker.yaml ${SPEC_URL} && \
  cat > /app/${OUTPUT_DIR}/swagger-initializer.js << 'EOF'
window.onload = function () {
  window.ui = SwaggerUIBundle({
    url: 'firecracker.yaml',
    dom_id: '#swagger-ui',
    presets: [
      SwaggerUIBundle.presets.apis,
      SwaggerUIStandalonePreset
    ],
    layout: 'StandaloneLayout'
  });
};
EOF
"

echo "✅ Done!"
echo "📂 Output directory: ${OUTPUT_DIR}"
echo "🌐 To test locally:"
echo "   docker run -p 8080:80 -v \$(pwd)/${OUTPUT_DIR}:/usr/share/nginx/html nginx"
echo "   Open http://localhost:8080"
