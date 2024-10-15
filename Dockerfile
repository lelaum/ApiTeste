FROM mcr.microsoft.com/dotnet/sdk:8.0 as build-env
WORKDIR /src
COPY *.csproj .
RUN pwd
RUN ls -la
RUN dotnet restore
COPY . .
RUN pwd
RUN ls -la

RUN dotnet build "ApiTeste.csproj" -c Release -o /build
RUN pwd
RUN ls -la /build

FROM build-env AS publish
RUN dotnet publish "ApiTeste.csproj" -c Release -o /publish
RUN pwd
RUN ls -la

FROM mcr.microsoft.com/dotnet/aspnet:8.0 as runtime
WORKDIR /publish
COPY --from=build-env /publish .
ENV ASPNETCORE_URLS=http://+:6000
EXPOSE 6000
ENTRYPOINT ["dotnet", "ApiTeste.dll"]
