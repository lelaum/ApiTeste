
#docker build -t sgldservice-hml .
#docker run -d -p 5000:8080 --restart=unless-stopped -e ASPNETCORE_ENVIRONMENT="Development" -e IdentitySettings:Secret="" -e ConnectionStrings:AppConnectionString="" sgldservice-hml:latest

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["NuGet.Config", "."]
COPY . .

# Inserir certificado CA do domínio SEDUC
# ADD seed-SEDUC-604-ADP-V-CA-1.crt /usr/local/share/ca-certificates/foo.crt
# RUN chmod 644 /usr/local/share/ca-certificates/foo.crt && update-ca-certificates
RUN dotnet restore "ApiTeste.csproj"
COPY . .
WORKDIR "/app"
RUN dotnet build "ApiTeste.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ApiTeste.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Inserir certificado CA do domínio SEDUC
# ADD seed-SEDUC-604-ADP-V-CA-1.crt /usr/local/share/ca-certificates/foo.crt
# RUN chmod 644 /usr/local/share/ca-certificates/foo.crt && update-ca-certificates
ENTRYPOINT ["dotnet", "ApiTeste.dll"]
