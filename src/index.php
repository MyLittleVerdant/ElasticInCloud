<?php
require $_SERVER['DOCUMENT_ROOT'].'/vendor/autoload.php';

use Elastic\Elasticsearch\ClientBuilder;

$client = ClientBuilder::create()->build();

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
print_r($response);
