# Hydro Raindrop Salesforce plugin 

![Hydro Logo](https://i.imgur.com/slcCepB.png)

Welcome to the Hydro Raindrop Salesforce plugin repository on GitHub.

This plugin provides Hydro Raindrop Multi-Factor Authentication to your Salesforce site.

Visit https://www.hydrogenplatform.com/hydro to learn more about Hydro Raindrop. 

## Installation

Download from appexchange.salesforce.com (soon available).

## Manual installation

1. Checkout or download the [salesforce-hydro-raindrop](https://github.com/brett91ag/salesforce-hydro-raindrop) library from GitHub.

    ```bash
    $ git clone git@github.com:brett91ag/salesforce-hydro-raindrop.git
    ```

1. Install the [Force.com Migration Tool](http://www.salesforce.com/us/developer/docs/daas/Content/forcemigrationtool_install.htm) plugin for Ant, if you don't already have it.

1. Edit `install/build.properties` to insert your Salesforce username and password.  Since you will be using the API to access Salesforce, remember to [append your Security Token](https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_concepts_security.htm#logintoken) to your password.

1. Open your command line to the `install` folder, then deploy using Ant:

    ```bash
    $ ant deployHydro
    ```