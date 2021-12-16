# Run Tests For Admin User
docker run \
    -v $(pwd)/tests:/etc/newman --network=Workforce-api_default \
    --entrypoint /bin/bash postman/newman:ubuntu \
    -c "newman run /etc/newman/workforce.postman_collection.json \
        --environment=/etc/newman/Workforce-docker-compose.postman_environment.json"