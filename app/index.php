<?php
require '../vendor/autoload.php';
use Elastic\Elasticsearch\ClientBuilder;

$client = ClientBuilder::create()
    ->setHosts(['es01:9200'])
    ->build();

$params = [
    'index' => 'my_index',
    'body'  => [
        'mappings' => [
            'properties' => [
                'first_name' => [
                    'type' => 'text'
                ],
                'last_name' => [
                    'type' => 'text'
                ]
            ]
        ]
    ]
];

$response = $client->indices()->create($params);

$params = [
    'index' => 'my_index',
    'id'    => '1',
    'body'  => ['first_name' => 'John', 'last_name' => 'Doe']
];

$response = $client->index($params);

$params = [
    'index' => 'my_index',
    'body'  => [
        'query' => [
            'match' => [
                'first_name' => 'John'
            ]
        ]
    ]
];

$response = $client->search($params);
echo "<pre>";var_dump($response);echo "</pre>";die();