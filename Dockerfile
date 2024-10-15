FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /
COPY . .
RUN dotnet restore "ApiTeste.csproj"
COPY . .
WORKDIR "ApiTeste"
RUN dotnet build "ApiTeste.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ApiTeste.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "ApiTeste.Api.dll"]
