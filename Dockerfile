FROM mcr.microsoft.com/dotnet/aspnet:3.1-focal AS base
WORKDIR /app
EXPOSE 443
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:443

FROM mcr.microsoft.com/dotnet/sdk:3.1-focal AS build
WORKDIR /src
COPY ["blazor-server-githubactions-demo.csproj", "./"]
RUN dotnet restore "blazor-server-githubactions-demo.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "blazor-server-githubactions-demo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "blazor-server-githubactions-demo.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "blazor-server-githubactions-demo.dll"]
