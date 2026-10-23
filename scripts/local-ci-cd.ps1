Write-Host ""
Write-Host "====================================="
Write-Host "OpenWeather API CI/CD Pipeline"
Write-Host "====================================="
Write-Host ""

# ----------------------------------------------------------------
# CI
# ----------------------------------------------------------------

Write-Host "[1/8] Installing dependencies..."
npm ci

if ($LASTEXITCODE -ne 0) {
    Write-Host "FAILED: Dependency installation"
    exit 1
}

Write-Host "[2/8] Validating OpenAPI..."
npx @redocly/cli lint openapi/openweather-api.yaml

if ($LASTEXITCODE -ne 0) {
    Write-Host "FAILED: OpenAPI validation"
    exit 1
}

Write-Host "[3/8] Running Spectral Lint..."
npm run lint:openapi

if ($LASTEXITCODE -ne 0) {
    Write-Host "FAILED: Spectral lint"
    exit 1
}

Write-Host "[4/8] Running Unit Tests..."
npm test

if ($LASTEXITCODE -ne 0) {
    Write-Host "FAILED: Unit tests"
    exit 1
}

Write-Host "[5/8] Building Application..."
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "FAILED: Build"
    exit 1
}

# ----------------------------------------------------------------
# CD
# ----------------------------------------------------------------

Write-Host "[6/8] Deploying Node.js App to Azure App Service..."

az webapp deploy `
  --resource-group rg-openweather-api-padmalaya26 `
  --name openweather-api-padmalaya26 `
  --src-path .

if ($LASTEXITCODE -ne 0) {
    Write-Host "FAILED: Web App deployment"
    exit 1
}

Write-Host "[7/8] Importing OpenAPI into Azure APIM..."

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

Write-Host "[8/8] Configuring APIM Backend..."

az apim api update `
  --resource-group rg-openweather-api-padmalaya26 `
  --service-name openweather-apim-devops `
  --api-id openweather-api `
  --set serviceUrl=https://openweather-api-padmalaya26.azurewebsites.net

if ($LASTEXITCODE -ne 0) {
    Write-Host "FAILED: APIM backend configuration"
    exit 1
}

Write-Host ""
Write-Host "====================================="
Write-Host "CI/CD PIPELINE SUCCESSFUL"
Write-Host "====================================="
Write-Host ""
Write-Host "Web App URL:"
Write-Host "https://openweather-api-padmalaya26.azurewebsites.net"

Write-Host ""
Write-Host "APIM Gateway:"
Write-Host "https://openweather-apim-devops.azure-api.net"