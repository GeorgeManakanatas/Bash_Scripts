docker run \
    --name testneo4j \
    -p7474:7474 -p7687:7687 \
    -d \
    -v /home/georgemanakanatas/Documents/neo4jVolume/data:/data \
    -v /home/georgemanakanatas/Documents/neo4jVolume/neo4j/logs:/logs \
    -v /home/georgemanakanatas/Documents/neo4jVolume/neo4j/import:/var/lib/neo4j/import \
    -v /home/georgemanakanatas/Documents/neo4jVolume/neo4j/plugins:/plugins \
    --env NEO4J_AUTH=neo4j/test \
    neo4j:latest