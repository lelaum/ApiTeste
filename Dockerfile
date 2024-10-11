# Use a imagem do .NET SDK
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

# Use uma imagem do SDK para construir a aplicação
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["ApiTeste.csproj", "/app"]
RUN dotnet restore "app/ApiTeste.csproj"
COPY . .
WORKDIR "/app"
RUN dotnet build "ApiTeste.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ApiTeste.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ApiTeste.dll"]
