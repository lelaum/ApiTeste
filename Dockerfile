#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["ApiTeste.csproj", "."]
RUN dotnet restore "./ApiTeste.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./ApiTeste.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish

RUN dotnet publish "./ApiTeste.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=False

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ApiTeste.dll"]