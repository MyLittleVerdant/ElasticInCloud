<?php
require 'vendor/autoload.php';
$client = (new \OpenSearch\ClientBuilder())
    ->setHosts(['opensearch:9200'])
    ->setBasicAuthentication('admin', 'strongPass123!')
    ->setSSLVerification(false)
    ->build();

$indexName = 'test-index-name';
$client->indices()->create([
    'index' => $indexName,
    'body' => [
        'settings' => [
            'index' => [
                'number_of_shards' => 4
            ]
        ]
    ]
]);

$client->create([
    'index' => $indexName,
    'id' => 1,
    'body' => [
        'title' => 'Moneyball',
        'director' => 'Bennett Miller',
        'year' => 2011
    ]
]);

var_dump(
    $client->search([
        'index' => $indexName,
        'body' => [
            'size' => 5,
            'query' => [
                'multi_match' => [
                    'query' => 'miller',
                    'fields' => ['title^2', 'director']
                ]
            ]
        ]
    ])
);

