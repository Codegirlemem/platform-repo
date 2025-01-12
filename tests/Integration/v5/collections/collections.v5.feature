@setsFixture @oauth2Skip
Feature: Testing the Sets API

	Scenario: Creating a Collection
		Given that I want to make a new "collection"
		And that the api_url is "api/v5"
		And that the request "data" is:
			"""
			{
				"name":"Set One",
				"featured": 1,
				"view":"map",
				"view_options":[],
				"role":[]
			}
			"""
		When I request "/collections"
		Then the response is JSON
		And the response has a "result.id" property
		And the type of the "result.id" property is "numeric"
		And the response has a "result.name" property
		And the "result.name" property equals "Set One"
		And the "result.featured" property equals "1"
		And the "result.user_id" property equals "2"
		And the "result.view" property equals "map"
		Then the guzzle status code should be 200

	Scenario: Creating a Collection ignores SavedSearch properties
		Given that I want to make a new "collection"
		And that the api_url is "api/v5"
		And that the request "data" is:
			"""
			{
				"name":"Set two",
				"featured": 1,
				"search": 1,
				"filter": {"q":"test"},
				"view":"map",
				"view_options":[],
				"role":[]
			}
			"""
		When I request "/collections"
		Then the response is JSON
		And the response has a "result.id" property
		And the type of the "result.id" property is "numeric"
		And the response has a "result.name" property
		And the response does not have a "result.search" property
		And the response does not have a "result.filter" property
		Then the guzzle status code should be 200

	Scenario: Updating a Collection
		Given that I want to update a "collection"
		And that the api_url is "api/v5"
		And that the request "data" is:
			"""
			{
				"name":"Updated Set One"
			}
			"""
		And that its "id" is "1"
		When I request "/collections"
		Then the response is JSON
		And the response has a "result.id" property
		And the type of the "result.id" property is "numeric"
		And the "result.id" property equals "1"
		And the response has a "result.name" property
		And the "result.name" property equals "Updated Set One"
		Then the guzzle status code should be 200


	Scenario: Updating a non-existent Collection
		Given that I want to update a "collection"
		And that the api_url is "api/v5"
		And that the request "data" is:
			"""
			{
				"name":"Updated Set",
				"filter":"updated filter"
			}
			"""
		And that its "id" is "20"
		When I request "/collections"
		Then the response is JSON
		And the response has a "errors" property
		Then the guzzle status code should be 404

	Scenario: Updating a SavedSearch via collections API fails
		Given that I want to update a "collection"
		And that the api_url is "api/v5"
		And that the request "data" is:
			"""
			{
				"name":"Updated Set",
				"filter":"updated filter"
			}
			"""
		And that its "id" is "4"
		When I request "/collections"
		Then the response is JSON
		And the response has a "errors" property
		Then the guzzle status code should be 404

	Scenario: Non admin user trying to make a collection featured fails
		Given that I want to update a "collection"
		And that the api_url is "api/v5"
		And that the oauth token is "testbasicuser2"
		And that the request "data" is:
			"""
			{
				"name":"Updated Set One by non admmin",
				"filter":"updated set filter",
				"featured":1
			}
			"""
		And that its "id" is "2"
		When I request "/collections"
		Then the response is JSON
		Then the guzzle status code should be 403

	@resetFixture
	Scenario: Listing All Collections
		Given that I want to get all "Collections"
		And that the api_url is "api/v5"
		When I request "/collections"
		Then the response is JSON
		And the response has a "meta.total" property
		And the type of the "meta.total" property is "numeric"
		And the "meta.total" property equals "4"
		Then the guzzle status code should be 200

	@resetFixture
	Scenario: Listing All Collections as a normal user doesn't return admin set
		Given that I want to get all "Collections"
		And that the api_url is "api/v5"
		And that the oauth token is "testbasicuser2"
		When I request "/collections"
		Then the response is JSON
		And the response has a "meta.total" property
		And the type of the "meta.total" property is "numeric"
		And the "meta.total" property equals "3"
		Then the guzzle status code should be 200

	@resetFixture
	Scenario: Search All Collections
		Given that I want to get all "Collections"
		And that the api_url is "api/v5"
		And that the request "query string" is:
			"""
			q=Explo
			"""
		When I request "/collections"
		Then the response is JSON
		And the "meta.total" property equals "1"
		And the "results.0.name" property equals "Explosion"
		Then the guzzle status code should be 200

	Scenario: Finding a Collection
		Given that I want to find a "Collection"
		And that the api_url is "api/v5"
		And that its "id" is "1"
		When I request "/collections"
		Then the response is JSON
		And the response has a "result.id" property
		And the type of the "result.id" property is "numeric"
		Then the guzzle status code should be 200

	Scenario: Finding a non-existent Collection
		Given that I want to find a "Collection"
		And that the api_url is "api/v5"
		And that its "id" is "22"
		When I request "/collections"
		Then the response is JSON
		And the response has a "errors" property
		Then the guzzle status code should be 404

	Scenario: Finding a saved search via Collection should 404
		Given that I want to find a "Collection"
		And that the api_url is "api/v5"
		And that its "id" is "4"
		When I request "/collections"
		Then the response is JSON
		And the response has a "errors" property
		Then the guzzle status code should be 404

	Scenario: Deleting a Collection
		Given that I want to delete a "Collection"
		And that the api_url is "api/v5"
		And that its "id" is "1"
		When I request "/collections"
		Then the guzzle status code should be 200

	Scenario: Deleting a non-existent Collection
		Given that I want to delete a "Collection"
		And that the api_url is "api/v5"
		And that its "id" is "22"
		When I request "/collection"
		And the response has a "errors" property
		Then the guzzle status code should be 404

	Scenario: Deleting a saved search via Collections api fails


		Given that I want to delete a "Collection"
		And that the api_url is "api/v5"
		And that its "id" is "4"
		When I request "/collection"
		And the response has a "errors" property
		Then the guzzle status code should be 404
