#!/bin/bash
X=""
num='^[0-9]$'
amount=$3
if [ "$1" ] && [ $1 != "$X" ]
then
    
    if [ "$1" == "market" ] || [ $1 == "-m" ] || [ "$1" == "supply" ] || [ $1 == "-s" ]
    then
        
        datacmc=$(curl -s -XGET "https://api.coinmarketcap.com/v2/ticker/2958/?convert=usd")                                #grab coinmarketcap data
    
        if [ "$1" == "market" ] || [ $1 == "-m" ]
        then
            echo "$datacmc" | jq ".data.quotes.USD.price" | xargs printf "Price Turtlecoin USD: %.*f USD\n" 10              #Get latest price
            echo "$datacmc" | jq ".data.quotes.USD.percent_change_24h" | xargs printf "24h price %%:  %.*f %%\n" 2          #Get 24h % change
            echo "$datacmc" | jq ".data.quotes.USD.volume_24h" | xargs printf "24h Volume USD:  %.*f USD\n" 2               #Get 24h Volume
            exit 0
        fi
    
        if [ "$1" == "supply" ] || [ $1 == "-s" ]
        then
            echo "$datacmc" | jq ".data.circulating_supply" | xargs printf "Circulating Supply Turtlecoin: %s TRTL\n"       #Get total supply
            exit 0
        fi
    fi
    
    if [ "$1" == "network" ] || [ $1 == "-n" ]
    then
        datatrtl=$(curl -s -XGET "http://public.turtlenode.io:11898/getinfo")                                           #grab turtlenetwork data
        echo "$datatrtl" | jq ".network_height" | xargs printf "Network block height: %s\n"                             #Get network height
        echo "$datatrtl" | jq ".hashrate" | awk '{ foo = $1 / 1000 / 1000 ; print "Network Hashrate " foo " Mh/s" }'    #Get hashrate in mh/s
        echo "$datatrtl" | jq ".difficulty" | xargs printf "Mining diffculty: %s\n"                                     #Get diffculty
        echo "$datatrtl" | jq ".version" | xargs printf "Client version: %s\n"                                          #Get version
        exit 0
    fi
    
    if [ "$1" == "help" ] || [ $1 == "-h" ]
    then
        if [ "$2" == "market" ]
        then
        echo "List market data"
        exit 0
        fi
        if [ "$2" == "supply" ]
        then
        echo "List circulating supply"
        exit 0
        fi
        if [ "$2" == "network" ]
        then
        echo "Shows network data"
        exit 0
        fi
        echo -e "Valid arguments are:\n-m, market\n-n, network\n-s, supply"    
    fi
    
elif  [ ! "$1" ] 
then    
    echo -e "This is the Turtle Bash Information Script\nfor more information use help"
else
    echo "unkown arguement - valid values are market,network,supply"
fi
