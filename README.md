# InfluxMonit
_This repository refers to the following links_

* [:link: static_ip_assign](https://bug41.tistory.com/entry/Docker-%EC%BB%A8%ED%85%8C%EC%9D%B4%EB%84%88-%EA%B3%A0%EC%A0%95-IP-%EC%A7%80%EC%A0%95%ED%95%98%EB%8A%94%EB%B2%95-%EB%8F%84%EC%BB%A4-%EC%BB%A8%ED%85%8C%EC%9D%B4%EB%84%88-IP%EB%B3%80%EB%8F%99-%EB%8F%84%EC%BB%A4-%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC)

* [:link: docker-compose.yaml](https://johncom.tistory.com/36)

* [:link: design grafana](https://itprogramming119.tistory.com/entry/InfluxDB-%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%A5%BC-Grafana%EC%97%90-%EC%8B%9C%EA%B0%81%ED%99%94%ED%95%98%EB%8A%94-%EC%98%88%EC%A0%9C)

* https://github.com/influxdata/influxdata-docker/issues/349
  
* [:link: check out1](https://helgeklein.com/blog/docker-monitoring-with-prometheus-automatic-https-sso-authentication/)


## Problems

Still working on telegraf.config...
It is not a completed project!
Trying to find how to 'monitor host command cpu usage grafana'

## Environment installation

    chmod +x install_docker.sh
    ./install_docker.sh

    
## Docker Start

    docker-compose up -d

## entering running docker

    docker exec -it <docker_name> bash

### influx

    # entering influx
    influx
    show databases;
    use influxdb
    
To check your measurements, below list will be shown.

    show measurements
    # ----
    # cpu
    # disk
    # diskio
    # kernel
    # mem
    # processes
    # procstat
    # procstat_lookup
    # swap
    # system
    ----

## Grafanan Designs

* memory

        SELECT mean("available_percent") AS "AVAILABLE_PERCENT", mean("used_percent") AS "USED_PERCENT" FROM "mem" WHERE $timeFilter GROUP BY time($__interval) fill(null)