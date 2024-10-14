# Image for our app. To build the app, we use dotnet-sdk
# and call this image builder
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder
# Directory for our application inside the container
WORKDIR /app

COPY . /app/

RUN dotnet restore

RUN dotnet publish -c Release -o output

FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /App

COPY --from=builder /app .

ENTRYPOINT ["dotnet", "ApiTeste.dll"]