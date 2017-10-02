var colors = require('colors/safe');
var fs = require('fs');
var path = require('path');

var string_t = {"type" : "string"};
var integer_t = {"type" : "integer"};
var boolean_t = {"type" : "boolean"};
var array_t = {"type" : "array"};

var possible_arguments = {
	"dendro_config_output_folder_location" : string_t,
	"dr_config_template_abs_path" : string_t,

	//identifier
	"config_identifier" : string_t,

	//dendro instance
	"port" : integer_t,
	"host" : integer_t,
	"secret" : string_t,
	"base_uri" : string_t,

	//eudat
	"eudat_base_url" : string_t,
	"eudat_token" : string_t,
	"eudat_community_id" : string_t,

	//elasticsearch
	"elasticsearch_port" : integer_t,
	"elasticsearch_host" : string_t,

	//cache
	"cache_active" : boolean_t,
	"cache_type" : string_t,
	"redis_cache_active" : boolean_t,
	"redis_cache_host" : string_t,
	"redis_default_port" : integer_t,
	"redis_social_port" : integer_t,
	"redis_notification_port" : integer_t,
	"mongodb_cache_active" : boolean_t,
	"mongodb_cache_host" : string_t,
	"mongodb_cache_port" : integer_t,
	"mongodb_cache_database" : string_t,
	//caching of static content
	"last_modified_caching" : boolean_t,
	"cache_period_in_seconds" : integer_t,

	//virtuoso
	"virtuoso_host" : string_t,
	"virtuoso_port" : integer_t,
	"virtuoso_isql_port" : integer_t,
	"virtuoso_dba_user" : string_t,
	"virtuoso_dba_password" : string_t,
	"virtuoso_sql_loglevel" : integer_t,

	//mongodb
	"mongodb_host" : string_t,
	"mongodb_port" : integer_t,
	"mongodb_files_collection_name" : string_t,
	"mongodb_sessions_store_collection_name" : string_t,
	"mongodb_dba_user" : string_t,
	"mongodb_dba_password" : string_t,

	//mysql
	"mysql_host" : string_t,
	"mysql_port" : integer_t,
	"mysql_dba_user" : string_t,
	"mysql_password" : string_t,
	"mysql_db_name" : string_t,

	//uploads
	"max_upload_size" : integer_t,
	"max_project_size" : integer_t,

	//dendro file storage
	"temp_files_directory" : string_t,
	"temp_uploads_files_directory" : string_t,

	//demo mode
	"demo_mode_active" : boolean_t,

	//dendro theme
	"dendro_theme" : string_t,

	//startup
	"load_databases_on_startup" : boolean_t,
	"reload_administrators_on_startup" : boolean_t,
	"reload_demo_users_on_startup" : boolean_t,
	"reload_ontologies_on_startup" : boolean_t,
	"reload_descriptors_on_startup" : boolean_t,
	"clear_session_store_on_startup" : boolean_t,

	//logging
	"pipe_console_to_logfile" : boolean_t,
	"log_request_times" : boolean_t,
	"custom_exception_logging" : boolean_t,

	//dendro configuration name
	"config_human_readable_name" : string_t,

	//recommendation
	"dendro_recommender_active" : boolean_t,
	"dr_config_output_folder_location" : string_t,
	"dendro_recommender_host" : string_t,
	"dendro_recommender_port" : integer_t,
	"dr_all_ontologies_uri" : string_t,
	"interactions_table_stage1" : string_t,
	"interactions_table_stage2" : string_t,
	"dr_stage1_active" : boolean_t,
	"dr_stage2_active" : boolean_t,

	"project_descriptors_recommender_active" : boolean_t,

	//gmail mailing account for password resets, etc...

	"emailing_account_gmail_reply_to_address" : string_t,
	"emailing_account_gmail_user" : string_t,
	"emailing_account_gmail_password" : string_t,

	//gmaps settings
	"gmaps_api_key" : string_t,
	"gmaps_map_height" : integer_t,

	//Dendro Recommender possible_arguments
	//google analytics
	"google_analytics_tracking_code" : string_t,

	//public ontologies
	"public_ontologies" : array_t,

	//authentication

	"default_authentication_enabled" : boolean_t,
	"orcid_authentication_enabled" : boolean_t,
	"orcid_client_id" : string_t,
	"orcid_client_secret" : string_t,
	"orcid_auth_callback_url" : string_t,
	"saml_authentication_enabled" : boolean_t,
	"saml_authentication_callback_path" : string_t,
	"saml_authentication_entry_point" : string_t,
	"saml_authentication_issuer" : string_t,
	"saml_authentication_button_text" : string_t
};

var get_argument_by_name = function(argument)
{
	var argumentValue = null;

	if(process.argv.indexOf("--"+argument) != -1){ //does our flag exist?
		argumentValue = process.argv[process.argv.indexOf("--"+argument) + 1]; //grab the next item

		//console.log("RAW ARGUMENT " + argument);
		//console.log("VALUE PARAMETRIZATION " + JSON.stringify(possible_arguments[argument]));

		if (possible_arguments[argument] != null && possible_arguments[argument].type == "boolean")
		{
			//console.log("PARSING BOOLEAN " + argumentValue);

			//from http://stackoverflow.com/questions/263965/how-can-i-convert-a-string-to-boolean-in-javascript
			if(argumentValue == "true" || argumentValue == "false")
			{
				argumentValue = (argumentValue == "true");
				//console.log("PARSED BOOLEAN " + argumentValue)
			}
			else
			{
				console.log("[ERROR] Unable to parse flag " + argument + ". It must be a boolean (true/false). Got " + argumentValue );
				process.exit(1);
			}
		}
		else if (possible_arguments[argument] != null && possible_arguments[argument].type == "array")
		{
			try{
				argumentValue = JSON.parse(argumentValue);
			}
			catch (e) {
				console.log("[ERROR] Unable to parse flag " + argument + ". It must be an array. " + e.message);
				process.exit(1);
			}
		}
		else if (possible_arguments[argument] != null && possible_arguments[argument].type == "integer")
		{
			try{
				argumentValue = parseInt(argumentValue);
			}
			catch (e) {
				console.log("[ERROR] Unable to parse flag " + argument + ". It must be an integer. " + e.message);
				process.exit(1);
			}
		}

		if(argumentValue[0] == "-" && argumentValue[1] == "-")
		{
			console.error("Got value " + colors.red(argumentValue) + " for argument " + colors.yellow(argument) + ". This is likely due to an invalid parameter value!! Review the " + colors.blue("constants.sh") + " file and the "+colors.blue("generate_configuration_files.sh")+" file to make sure the parameter names match.");
			process.exit(1);
		}
	}

	//console.log("Got value " + argumentValue + " for argument " + argument);
	return argumentValue;
}

var detect_missing_possible_arguments = function(possible_arguments)
{
	var missing_possible_arguments = [];
	var keys = Object.keys(possible_arguments);

	for (var i = 0; i < keys.length; i++) {
		var key = keys[i];
		if(get_argument_by_name(key) == null)
		{
			missing_possible_arguments.push(key);
		}
	}

	return missing_possible_arguments;
}

var print_usage = function(possible_arguments)
{
	var missing_possible_arguments = detect_missing_possible_arguments(possible_arguments);

	var output = "USAGE: " + colors.bold("build_configurations.sh") + " \n";
	var keys = Object.keys(possible_arguments);

	for (var i = 0; i < keys.length; i++) {
		var key = keys[i];
		output += "	--" + key + " << " + colors.cyan(possible_arguments[key].type) + " >>";

		if(missing_possible_arguments.indexOf(key) >= 0)
		{
			output += colors.red(" [ MISSING ]\n");
		}
		else
		{
			output += colors.green(" [ OK ]\n");
		}
	}

	console.log(output);
}

var write_dendro_configuration_file = function ()
{
	var dendro_config_template = {};

	dendro_config_template[get_argument_by_name('config_identifier')] =
	{
		"port" : get_argument_by_name('port'),
		"host" : get_argument_by_name('host'),
		"crypto" :
		{
			"secret" : get_argument_by_name('secret')
		},
		"baseUri" : get_argument_by_name('base_uri'),
		"eudatBaseUrl" : get_argument_by_name('eudat_base_url'),
		"eudatToken" : get_argument_by_name('eudat_token'),
		"eudatCommunityId" : get_argument_by_name('eudat_community_id'),
		"sendGridUser" : get_argument_by_name('emailing_account_gmail_user'),
		"sendGridPassword" : get_argument_by_name('emailing_account_gmail_user'),
		"elasticSearchHost" : get_argument_by_name('elasticsearch_host'),
		"elasticSearchPort" : get_argument_by_name('elasticsearch_port'),
	    "datastore" :
	    {
	      "database": get_argument_by_name('port')+":"+get_argument_by_name('host')+"_datastore",
	      "host": get_argument_by_name('mongodb_cache_host'),
	      "port": get_argument_by_name('mongodb_cache_port'),
	      "id": "default",
	      "log" : {
	        "log_datastore_ops" : true
	      }
	    },
	    "ontologies_cache" :
	    {
	      "database": get_argument_by_name('port')+":"+get_argument_by_name('host')+"_ontologies",
	      "host": get_argument_by_name('mongodb_cache_host'),
	      "port": get_argument_by_name('mongodb_cache_port'),
	      "id": "default",
	      "collection" : "ontologies_cache"
	    },
		"cache": {
			"active": get_argument_by_name('cache_active'),
			"redis": {
				"active": get_argument_by_name('redis_cache_active'),
				"instances": {
					"default": {
						"host": get_argument_by_name('redis_cache_host'),
						"port": get_argument_by_name('redis_default_port'),
						"id": "default",
						"database_number": 1
					},
					"social": {
						"host": get_argument_by_name('redis_cache_host'),
						"port": get_argument_by_name('redis_social_port'),
						"id": "social",
						"database_number": 1
					},
					"notifications": {
						"host": get_argument_by_name('redis_cache_host'),
						"port": get_argument_by_name('redis_notifications_port'),
						"id": "notification",
						"database_number": 1
					}
				}
			},
			"mongodb": {
				"active": get_argument_by_name('mongodb_cache_active'),
				"instances": {
					"default" : {
						"database": get_argument_by_name('mongodb_cache_database'),
						"collection": "default_cache",
						"clear_on_startup" : true,
						"host": get_argument_by_name('mongodb_cache_host'),
						"port": get_argument_by_name('mongodb_cache_port'),
						"id": "default"
					},
					"social": {
						"database": get_argument_by_name('mongodb_cache_database'),
						"collection": "social_cache",
						"clear_on_startup" : true,
						"host": get_argument_by_name('mongodb_cache_host'),
						"port": get_argument_by_name('mongodb_cache_port'),
						"id": "social"
					},
					"notifications": {
						"database": get_argument_by_name('mongodb_cache_database'),
						"collection": "notifications_cache",
						"clear_on_startup" : true,
						"port": get_argument_by_name('mongodb_cache_port'),
						"host": get_argument_by_name('mongodb_cache_host'),
						"id": "notifications"
					}
				}
			},
			"static": {
				"last_modified_caching" : get_argument_by_name('last_modified_caching'),
				"cache_period_in_seconds" : get_argument_by_name('cache_period_in_seconds')
			}
		},
		"virtuosoHost" : get_argument_by_name('virtuoso_host'),
		"virtuosoPort" : get_argument_by_name('virtuoso_port'),
		"virtuosoISQLPort" : get_argument_by_name('virtuoso_isql_port'),
		"virtuosoConnector" : "http",
		"virtuosoAuth" : {
			"user" : get_argument_by_name('virtuoso_dba_user'),
			"password" : get_argument_by_name('virtuoso_dba_password')
		},
		"virtuosoSQLLogLevel":  get_argument_by_name('virtuoso_sql_loglevel'),
		"mongoDBHost" : get_argument_by_name('mongodb_host'),
		"mongoDbPort" : get_argument_by_name('mongodb_port'),
		"mongoDbCollectionName" : get_argument_by_name('mongodb_files_collection_name'),
		"mongoDBSessionStoreCollection" : get_argument_by_name('mongodb_sessions_store_collection_name'),
		"mongoDbVersion" : "",
		"mongoDBAuth" : {
			"user" : get_argument_by_name('mongodb_dba_user'),
			"password" : get_argument_by_name('mongodb_dba_password'),
		},
		"mySQLHost" : get_argument_by_name('mysql_host'),
		"mySQLPort" : get_argument_by_name('mysql_port'),
		"mySQLAuth" : {
			"user" : get_argument_by_name('mysql_dba_user'),
			"password" : get_argument_by_name('mysql_password')
		},
		"mySQLDBName" : get_argument_by_name('mysql_db_name'),
		"maxUploadSize" : get_argument_by_name('max_upload_size'),
		"maxProjectSize" : get_argument_by_name('max_project_size'),
		"maxSimultaneousConnectionsToDb" : 10,
		"dbOperationTimeout" : 8000,
		"tempFilesDir" : get_argument_by_name('temp_files_directory'),
		"tempUploadsDir" : get_argument_by_name('temp_uploads_files_directory'),
		"tempFilesCreationMode" : "0777",
		"administrators" : [
			{
				"username": "admin",
				"password": "admintest123",
				"firstname" : "Dendro",
				"surname" : "Administrator",
				"mbox" : "admin@dendro.fe.up.pt"
			}
		],
		"change_log" :
		{
			"default_page_length" : "10"
		},
		"demo_mode" :
		{
			"active": get_argument_by_name("demo_mode_active"),
			"users":
			[
				{
					"username": "demouser1",
					"password": "demouserpassword2015",
					"firstname" : "Dendro",
					"surname" : "Demo User",
					"mbox" : "demouser@dendro.fe.up.pt"
				}
			]
		},
		"useElasticSearchAuth" : false,
		"elasticSearchAuthCredentials" : {
			"username" : "user",
			"password" : "pass"
		},
		"systemOrHiddenFilesRegexes" : ["__MACOSX", "^[.]"],
		"theme" : get_argument_by_name('dendro_theme'),
		"debug": {
			"active": true,
			"database": {
				"log_all_queries": false,
				"log_all_cache_queries" : false,
				"log_query_timeouts": false
			},
			"session": {
				"auto_login": false,
				"login_user": "demouser"
			},
			"files": {
				"log_all_restore_operations": false,
				"log_delete_operations": false,
				"log_file_fetches": false,
				"delete_temp_folder_on_startup": false,
				"log_file_version_fetches": false,
				"log_temp_file_writes": false,
				"log_temp_file_reads": false
			},
			"resources": {
				"log_all_type_checks": false,
				"log_missing_resources": false
			},
			"permissions": {
				"enable_permissions_system": true,
				"log_authorizations": false,
				"log_denials": true,
				"log_requests_and_permissions": false
			},
			"users": {
				"log_fetch_by_username": false
			},
			"descriptors": {
				"log_missing_unknown_descriptors": false,
				"log_unknown_types": false,
				"log_descriptor_filtering_operations": false
			},
			"ontologies": {
				"log_autocomplete_requests": false
			},
			"views": {
				"show_all_buttons_in_recommendations": false,
				"prefill_text_boxes": false
			},
			"cache": {
				"log_cache_hits": false,
				"log_cache_writes": false,
				"log_cache_deletes": false
			},
			"diagnostics": {
				"ram_usage_report": true
			},
			"index": {
				"elasticsearch_connection_log_type": ""
			},
			"tests" :
			{
				"log_unit_completion_and_startup" : false
			}
		},
		"startup" : {
			"load_databases" : get_argument_by_name('load_databases_on_startup'),
			"reload_administrators_on_startup" : get_argument_by_name('reload_administrators_on_startup'),
			"reload_demo_users_on_startup" : get_argument_by_name('reload_demo_users_on_startup'),
			"reload_ontologies_on_startup" : get_argument_by_name('reload_ontologies_on_startup'),
			"clear_session_store" : get_argument_by_name('clear_session_store_on_startup'),

			"load_databases": get_argument_by_name('load_databases_on_startup'),
			"reload_administrators_on_startup": get_argument_by_name('reload_administrators_on_startup'),
			"reload_demo_users_on_startup": get_argument_by_name('reload_demo_users_on_startup'),
			"reload_ontologies_on_startup": get_argument_by_name('reload_ontologies_on_startup'),
			"reload_descriptors_on_startup": get_argument_by_name('reload_descriptors_on_startup'),
			"reload_research_domains_on_startup": true,
			"reload_descriptor_validation_data" : true,
			"clear_session_store": get_argument_by_name('clear_session_store_on_startup'),
			"clear_caches" : true,
			"log_bootup_actions" : true,
			"destroy_all_graphs": false,
			"destroy_all_indexes": false
		},
		"baselines" : {
			"dublin_core_only" : false
		},
		"logging" :
		{
			"pipe_console_to_logfile" : get_argument_by_name('pipe_console_to_logfile'),
			"format" : "combined",
			"app_logs_folder" : "logs/app",
			"log_request_times" : get_argument_by_name('log_request_times'),
			"request_times_log_folder" : "logs/request_times",
			"log_requests_in_apache_format" : false,
			"requests_in_apache_format_log_folder" : "logs/requests_apache_format",
			"suppress_all_logs": false,
			"suppress_all_errors": false,
			"log_all_requests": false,
			"log_emailing": false,
			"custom_exception_logging": get_argument_by_name('custom_exception_logging')
		},
		"version" :
		{
			"number" : 0.2,
			"name" : get_argument_by_name('config_human_readable_name')
		},
		"recommendation":
		{
			"modes" : {
				"dendro_recommender" :
				{
					"active" : get_argument_by_name('dendro_recommender_active'),
					"host" : get_argument_by_name('dendro_recommender_host'),
					"port" : get_argument_by_name('dendro_recommender_port'),
					"log_modes" : {
						"phase_1" :
						{
							"table_to_write_interactions" : get_argument_by_name('interactions_table_stage1'),
							"active" : get_argument_by_name('dr_stage1_active')
						},
						"phase_2" :
						{
							"table_to_write_interactions" : get_argument_by_name('interactions_table_stage2'),
							"active" : get_argument_by_name('dr_stage2_active')
						}
					}
				},
				"project_descriptors" : {
					"active" : get_argument_by_name('project_descriptors_recommender_active')
				},
				"standalone" : {
					"active" : false
				},
				"none" : {
					"active" : false
				}
			},
			"max_autocomplete_results" : 4,
			"max_suggestions_of_each_type" : 80,
			"recommendation_page_size" : 30,
			"random_interactions_generation_page_size": 5,
			"max_interaction_pushing_threads" : 1
		},
		"email" :
		{
			"gmail":
			{
				"address": get_argument_by_name('emailing_account_gmail_reply_to_address'),
				"username" : get_argument_by_name('emailing_account_gmail_user'),
				"password" : get_argument_by_name('emailing_account_gmail_password')
			}
		},
		"maps" :
		{
			"gmaps_api_key" : get_argument_by_name('gmaps_api_key'),
			"map_height" : get_argument_by_name('gmaps_map_height')
		},
		"exporting" :
		{
			"generated_files_metadata" :
			{
				"bagit" :
				{
					"dcterms" : {
						"title" : "Full contents of the dataset in ZIP format (Bagit Specification)",
						"description" : "This file contains all the files and corresponding metadata in a ZIP arghive that follows the BagIt (https://tools.ietf.org/html/draft-kunze-bagit-08) specification. Exported by the Dendro platform."
						}
					},
					"zip" :
					{
						"dcterms" : {
							"title" : "Full contents of the dataset in ZIP format",
							"description" : "This file contains all the files and corresponding metadata in a ZIP archive. Exported by the Dendro platform."
						}
					},
					"json" :
					{
						"dcterms" : {
							"title" : "Dataset metadata in JSON format",
							"description" : "This file contains all the metadata in JSON format. Exported by the Dendro platform."
						}
					},
					"rdf" :
					{
						"dcterms" : {
							"title" : "Dataset metadata in RDF format",
							"description" : "This file contains all the metadata in RDF (Resource Description Framework) format. Exported by the Dendro platform."
						}
					},
					"txt" :
					{
						"dcterms" : {
							"title" : "Dataset metadata in human-readable TXT format",
							"description" : "This file contains all the metadata in Plain text for human reading. Exported by the Dendro platform."
						}
					}
				},
				"ckan" :
				{

				}
			},
			"analytics_tracking_code" : get_argument_by_name("google_analytics_tracking_code"),
			"public_ontologies" : get_argument_by_name("public_ontologies"),
			"authentication": {
				"default": {
					"enabled": get_argument_by_name("default_authentication_enabled")
				},
				"orcid": {
					"enabled": get_argument_by_name("orcid_authentication_enabled"),
					"client_id": get_argument_by_name("orcid_client_id"),
					"client_secret": get_argument_by_name("orcid_client_secret"),
					"callback_url": get_argument_by_name("orcid_auth_callback_url")
				},
				"saml": {
					"enabled":  get_argument_by_name("saml_authentication_enabled"),
					"path": get_argument_by_name("saml_authentication_callback_path"),
					"entry_point": get_argument_by_name("saml_authentication_entry_point"),
					"issuer": get_argument_by_name("saml_authentication_issuer"),
					"button_text": get_argument_by_name("saml_authentication_button_text")
				}
			}
		};

		//console.log("FINISHED CONFIGURATION"));
		//console.log(JSON.stringify(dendro_config_template, null, 2));

		var util = require('util');

		var destinationFolder = get_argument_by_name('dendro_config_output_folder_location');
		if(!fs.existsSync(destinationFolder))
		{
			fs.mkdirSync(destinationFolder);
		}

		var destinationFile = path.join(destinationFolder, 'deployment_configs.json');
		fs.writeFileSync(destinationFile, JSON.stringify(dendro_config_template, null, 2) , 'utf-8');
		return destinationFile;
	}

	var write_dendro_recommender_configuration_file = function ()
	{
		var dr_parameters = [
			{
				key: "ontologies.all_ontologies_uri",
				value : get_argument_by_name("dr_all_ontologies_uri")
			},
			{
				key: "persistence.mysql.host",
				value : get_argument_by_name("mysql_host")
			},
			{
				key: "persistence.mysql.port",
				value : get_argument_by_name("mysql_port")
			},
			{
				key: "persistence.mysql.database",
				value : get_argument_by_name("mysql_db_name")
			},
			{
				key: "persistence.mysql.interactions_table",
				value : get_argument_by_name("dr_interactions_table")
			},
			{
				key: "persistence.mysql.username",
				value : get_argument_by_name("mysql_dba_user")
			},
			{
				key: "persistence.mysql.password",
				value : get_argument_by_name("mysql_password")
			},
			{
				key: "play.server.http.port",
				value : get_argument_by_name("dendro_recommender_port")
			}
		];

		var contents_of_current_file = fs.readFileSync(get_argument_by_name('dr_config_template_abs_path'), 'utf-8');

		var output = contents_of_current_file.replace(/\n# BEGIN_AUTO_GENERATED_BY_BUILD_CONFIGURATIONS_JS.*#END_AUTO_GENERATED_BY_BUILD_CONFIGURATIONS_JS/gm, "");

		output += "\n# BEGIN_AUTO_GENERATED_BY_BUILD_CONFIGURATIONS_JS\n";
		output += "# auto-generated parameters DO NOT CHANGE.\n";
		output += "# Edit the configuration generation script (build_configuration_files.js) instead!\n";

		for (var i = 0; i < dr_parameters.length; i++) {
			var dr_parameter = dr_parameters[i];
			output += dr_parameter.key + "=\"" + dr_parameter.value+"\"\n";
		}

		output += "#END_AUTO_GENERATED_BY_BUILD_CONFIGURATIONS_JS\n";

		var destinationFolder = get_argument_by_name('dr_config_output_folder_location');
		if(!fs.existsSync(destinationFolder))
		{
			fs.mkdirSync(destinationFolder);
		}

		var destinationFile = path.join(destinationFolder, 'application.conf');
		fs.writeFileSync(destinationFile, output , 'utf-8');
		return destinationFile;
	}

	var write_active_deployment_config_file = function()
	{
		var util = require('util');

		var destinationFolder = get_argument_by_name('dendro_config_output_folder_location');
		if(!fs.existsSync(destinationFolder))
		{
			fs.mkdirSync(destinationFolder);
		};

		var activeConfigTemplate = {
			"key" : get_argument_by_name('config_identifier')
		};

		var destinationFile = path.join(destinationFolder, 'active_deployment_config.json');
		fs.writeFileSync(destinationFile, JSON.stringify(activeConfigTemplate, null, 2) , 'utf-8');
		return destinationFile;
	}

	/**
	* Start the program!
	**/

	// console.log(JSON.stringify(process.argv));

	var missing_possible_arguments = detect_missing_possible_arguments(possible_arguments);

	if(missing_possible_arguments.length == 0)
	{
		var config_identifier = get_argument_by_name("config_identifier");
		console.log(colors.cyan("[INFO] ") + "Creating new configuration file for Dendro with name " + colors.yellow(config_identifier) + "...");
		var dendroConfigurationLocation = write_dendro_configuration_file();
		var dendroActiveDeploymentConfigLocation = write_active_deployment_config_file();
		console.log(colors.green("[OK] ") + "Configuration file for Dendro with name \"" + colors.yellow(config_identifier) + " created at " + dendroConfigurationLocation);

		console.log(colors.cyan("[INFO] ") + "Creating new configuration file for Dendro Recommender...");
		var dendroRecommenderConfigurationLocation = write_dendro_recommender_configuration_file();
		console.log(colors.green("[OK] ") + "Created new configuration file for Dendro Recommender at " + dendroRecommenderConfigurationLocation);
	}
	else
	{
		//console.log("Missing possible_arguments ", JSON.stringify(missing_possible_arguments));
		print_usage(possible_arguments);
		process.exit(1);
	}
