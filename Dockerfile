FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["content-api.csproj", "./"]
RUN dotnet restore "./content-api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "content-api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "content-api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "content-api.dll"]
