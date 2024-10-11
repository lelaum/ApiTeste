# Etapa 1: Usar a imagem oficial do SDK .NET Core para compilar a aplicação
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copiar os arquivos do projeto e restaurar as dependências
COPY *.sln .
COPY *.csproj ./MyApi/
RUN dotnet restore

# Copiar todos os arquivos e compilar o projeto
COPY . .
WORKDIR /app/MyApi
RUN dotnet publish -c Release -o /out

# Etapa 2: Usar a imagem oficial do runtime do ASP.NET Core para rodar a aplicação
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copiar os arquivos compilados da etapa anterior para o contêiner final
COPY --from=build /out .

# Expor a porta que o contêiner usará
EXPOSE 80

# Definir o ponto de entrada para rodar a aplicação
ENTRYPOINT ["dotnet", "ApiTeste.dll"]
