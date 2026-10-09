Write-Host ""
Write-Host "====================================="
Write-Host "OpenWeather API CI/CD Pipeline"
Write-Host "====================================="
Write-Host ""

Write-Host "[1/6] Installing dependencies..."
npm ci

if ($LASTEXITCODE -ne 0) {
    Write-Host "FAILED: Dependency installation"
    exit 1
}

Write-Host "[2/6] Validating OpenAPI..."
npx @redocly/cli lint openapi/openweather-api.yaml

if ($LASTEXITCODE -ne 0) {
    Write-Host "FAILED: OpenAPI validation"
    exit 1
}

Write-Host "[3/6] Running Spectral Lint..."
npm run lint:openapi

if ($LASTEXITCODE -ne 0) {
    Write-Host "FAILED: Spectral lint"
    exit 1
}

Write-Host "[4/6] Running Unit Tests..."
npm test

if ($LASTEXITCODE -ne 0) {
    Write-Host "FAILED: Unit tests"
    exit 1
}

Write-Host "[5/6] Building Application..."
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "FAILED: Build"
    exit 1
}

Write-Host "[6/6] Deploying OpenAPI to Azure APIM..."

az apim api import `
  --resource-group rg-openweather-api-padmalaya26 `
  --service-name openweather-apim-devops `
  --api-id openweather-api `
  --path weather `
  --specification-format OpenApi `
  --specification-path openapi/openweather-api.yaml

if ($LASTEXITCODE -ne 0) {
    Write-Host "FAILED: APIM deployment"
    exit 1
}

Write-Host ""
Write-Host "====================================="
Write-Host "CI/CD PIPELINE SUCCESSFUL"
Write-Host "====================================="