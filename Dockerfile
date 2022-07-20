FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["blazor-server-githubactions-demo.csproj", "./"]
RUN dotnet restore "./blazor-server-githubactions-demo.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "blazor-server-githubactions-demo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "blazor-server-githubactions-demo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "blazor-server-githubactions-demo.dll"]
