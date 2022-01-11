![GitHub last commit](https://img.shields.io/github/last-commit/eded333/TheFuckingList) ![GitHub commit activity](https://img.shields.io/github/commit-activity/m/eded333/TheFuckingList) ![GitHub issues](https://img.shields.io/github/issues/eded333/TheFuckingList) ![GitHub closed issues](https://img.shields.io/github/issues-closed/eded333/TheFuckingList) ![GitHub repo size](https://img.shields.io/github/repo-size/eded333/TheFuckingList)

# TheFuckingList
| List 																							 | Description 										 | Includes 																																														                                                                                |
|------------------------------------------------------------------------------------------------|---------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|[Adblock Format](https://raw.githubusercontent.com/eded333/TheFuckingList/main/adguardhome.txt) |Use with AdguardHome, Adguard, uBlock Origin		 |[whitelist](https://raw.githubusercontent.com/eded333/TheFuckingList/main/whitelist.txt) - [exclusions](https://raw.githubusercontent.com/eded333/TheFuckingList/main/exclusions.txt) - [deadlist](https://raw.githubusercontent.com/eded333/TheFuckingList/main/deadlist.txt)	|
|[Domain format](https://raw.githubusercontent.com/eded333/TheFuckingList/main/pihole.txt) 	 	 |Use with Pihole 						             | - [exclusions](https://raw.githubusercontent.com/eded333/TheFuckingList/main/exclusions.txt) - [deadlist](https://raw.githubusercontent.com/eded333/TheFuckingList/main/deadlist.txt)																	  		                |
|[Hosts format](https://raw.githubusercontent.com/eded333/TheFuckingList/main/hosts_nine.txt)	 |Use as Hostfile							         | - [exclusions](https://raw.githubusercontent.com/eded333/TheFuckingList/main/exclusions.txt) - [deadlist](https://raw.githubusercontent.com/eded333/TheFuckingList/main/deadlist.txt)                                                        			  		                |

## Description

A collection of 100+ blocklists, updated daily, compiled with adguards hostlist-compiler, deduped, pruned of dead domains and sprinkled with some personal exclusions and exceptions for my use case.

Compiled as adblock format for AdguardHome, as domains for pihole and transformed into compressed host format (9 hosts per line).

Beware false positives ahead.

*Porn, Piracy, Torrents, Social media (except facebook) arent actively blocked. Some crypto services and VPNs will need to be whitelisted.

## Use a whitelist, you will need it

This is a restrictive blocklist, although I keep adding legit domains to the limited exclusion list it is recommended to use a whitelist, as it will probably break some of the services you use. E.g. Facebook.

## Size matters

I have resorted to prune the blocklists of dead domains creating a dead domain list, [deadlist](https://raw.githubusercontent.com/eded333/TheFuckingList/main/deadlist.txt).

The deadlist is monitored to remove from it any domain that become active again.

More infrequently the deadlist will be refreshed to catch new dead or invalid domains.

## Issues/Suggestions

Feel free to report issues or suggestions.

## Credits

A huge thanks to the maintainers of the [sources](https://raw.githubusercontent.com/eded333/TheFuckingList/main/sources.txt).

mmotti, oisd, jerryn70, hblock, Zelo72, crazy-max, StevenBlack, mitchellkrogza, Spam404, durablenapkin, Perflyst, curben, oneoffdallas, notracking, DandelionSprout, EnergizedProtection, someonewhocares, blocklistproject, Ultimate-Hosts-Blacklist, mkb2091, DRSDavidSoft, suodrazah, easylist, marcusminus, developerdan, ftpmorph, WaLLy3K, anudeepND, Disconnect, Prigent, phishing army, urlhaus, zerodot1, Ewpratten, kboghdady, herrbischoff, KitsapCreator, shahidcodes, badmojr, rimu, BlackJack8, neodevpro, threatcrowd, TheAntiSocialEngineer, sebsauvage, nextdns, missdeer, joewein, Socram, Sinfonietta, tiuxo, bongochong, furkun, gwillem, hell-sh, merkleID, mhxion, mitchellkrogza, no-cmyk, RooneyMcNibNug, TonyRL, tg12, stonecrusher, stamparm, soteria-nou, ShadowWhisperer, matomo-org, VeleSila, firebog, neohosts, RooneyMcNibNug, bigdargon, frogeye, Perflyst, Shalla-mal, privacy-protection-tools, iam-py-test, Segasec, Phishfort.

