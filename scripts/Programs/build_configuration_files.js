var colors = require('colors/safe');
var fs = require('fs');
var path = require('path');

var possible_arguments = {

	//target folders for the generated configuration files
	"dr_config_output_folder_location" :
	{
		type: "string",
		example : "./generated_configuration_files",
		tip : "Coming soon"
	},

	"eudat_token" :
	{
		type: "string",
		example : "veryLONGNADCOMPLICATEDSTRING",
		tip : "Coming soon"
	},
	"eudat_community_id :
	{
		type: "string",
		example : "e9b9792e-79fb-4b07-b6b4-b9c2bd06d095",
		tip : "Coming soon"
	},
	"dr_config_template_abs_path" :
	{
		type: "string",
		example : "/usr/home/test/scripts/Programs/DendroRecommender/application.conf.template",
		tip : "Coming soon"
	},

	"dendro_config_output_folder_location" :
	{
		type: "string",
		example : "./generated_configuration_files",
		tip : "Coming soon"
	},

	//dendro instance
	"config_identifier" :
	{
		type: "string",
		example : "dendro_dev_feup",
		tip : "Coming soon"
	},
	"port" :
	{
		type: "integer",
		example : "3001",
		tip : "Coming soon"
	},
	"host" :
	{
		type: "string",
		example : "192.168.56.101 or dendro.fe.up.pt",
		tip : "Coming soon"
	},
	"base_uri" :
	{
		type: "string",
		example : "http://192.168.56.101:3001 or http://dendro.fe.up.pt",
		tip : "Coming soon"
	},

	//elasticsearch
	"elasticsearch_port" :
	{
		type: "integer",
		example : "9200",
		tip : "Coming soon"
	},
	"elasticsearch_host" :
	{
		type: "string",
		example : "127.0.0.1",
		tip : "Coming soon"
	},

	//virtuoso
	"virtuoso_host" :
	{
		type: "string",
		example : "127.0.0.1",
		tip : "Coming soon"
	},
	"virtuoso_port" :
	{
		type: "integer",
		example : "8890",
		tip : "Coming soon"
	},
	"virtuoso_dba_user" :
	{
		type: "string",
		example : "dba",
		tip : "Coming soon"
	},
	"virtuoso_dba_password" :
	{
		type: "string",
		example : "dba",
		tip : "Coming soon"
	},

	//mongodb
	"mongodb_host" :
	{
		type: "string",
		example : "dba",
		tip : "Coming soon"
	},
	"mongodb_port" :
	{
		type: "integer",
		example : "9200",
		tip : "Coming soon"
	},
	"mongodb_dba_user" :
	{
		type: "string",
		example : "mongodb",
		tip : "Coming soon"
	},
	"mongodb_dba_password" :
	{
		type: "string",
		example : "mong0db",
		tip : "Coming soon"
	},

	//mysql
	"mysql_host" :
	{
		type: "string",
		example : "mong0db",
		tip : "Coming soon"
	},
	"mysql_port" :
	{
		type: "integer",
		example : 3306,
		tip : "Coming soon"
	},
	"mysql_dba_user" :
	{
		type: "string",
		example : "root",
		tip : "Coming soon"
	},
	"mysql_password" :
	{
		type: "string",
		example : "root",
		tip : "Coming soon"
	},
	"mysql_db_name" :
	{
		type: "string",
		example : "mong0db",
		tip : "Coming soon"
	},

	//dendro file storage
	"temp_files_directory" :
	{
		type: "string",
		example : "/tmp/dendro_files",
		tip : "Coming soon"
	},

	//demo mode
	"demo_mode_active" :
	{
		type: "boolean",
		example : "\"true\" | \"false\"",
		tip : "Coming soon"
	},

	//dendro theme
	"dendro_theme" :
	{
		type: "string",
		example : "lumen | default | ....",
		tip : "See Bootstrap theme names."
	},

	//startup

	"reload_administrators_on_startup" :
	{
		type: "boolean",
		example : "\"true\" | \"false\"",
		tip : "Coming soon"
	},

	"reload_demo_users_on_startup" :
	{
		type: "boolean",
		example : "\"true\" | \"false\"",
		tip : "Coming soon"
	},
	"reload_ontologies_on_startup" :
	{
		type: "boolean",
		example : "\"true\" | \"false\"",
		tip : "Coming soon"
	},
	//dendro configuration name
	"config_human_readable_name" :
	{
		type: "string",
		example : "FEUP Demo Dendro",
		tip : "Coming soon"
	},

	//dendro recommender
	"dendro_recommender_active" :
	{
		type: "boolean",
		example : "\"true\" | \"false\"",
		tip : "Coming soon"
	},
	"dendro_recommender_host" :
	{
		type: "string",
		example : "127.0.0.1",
		tip : "Coming soon"
	},
	"dendro_recommender_port" :
	{
		type: "integer",
		example : "9001",
		tip : "Coming soon"
	},

	//gmail mailing account for password resets, etc...

	"emailing_account_gmail_user" :
	{
		type: "string",
		example : "gmail_user",
		tip : "Coming soon"
	},

	"emailing_account_gmail_password" :
	{
		type: "string",
		example : "gmail_user_password",
		tip : "Coming soon"
	},

	//caching of static content
	"last_modified_caching" :
	{
		type: "boolean",
		example : "true",
		tip : "Coming soon"
	},
	"cache_period_in_seconds" :
	{
		type: "integer",
		example : "true",
		tip : "Coming soon"
	},

	/**
	 * Dendro Recommender possible_arguments
	 **/

	"dr_all_ontologies_uri" :
	{
		type: "string",
		example : "http://dendro-dev.fe.up.pt:3009/ontologies/all",
		tip : "Coming soon"
	},
	"mysql_host" :
	{
		type: "string",
		example : "127.0.0.1",
		tip : "Coming soon"
	},
	"mysql_port" :
	{
		type: "integer",
		example : 3306,
		tip : "Coming soon"
	},
	"dr_interactions_table" :
	{
		type: "string",
		example : "interactions",
		tip : "Coming soon"
	},
	"mysql_password" :
	{
		type: "string",
		example : "root",
		tip : "Coming soon"
	},
	"dr_stage1_active" :
	{
		type: "boolean",
		example : "interactions_stage1",
		tip : "Coming soon"
	},
	"dr_stage2_active" :
	{
		type: "boolean",
		example : "interactions_stage2",
		tip : "Coming soon"
	},
	"gmaps_api_key" :
	{
		type: "string",
		example : "Get it from Google Maps website",
		tip : "Coming soon"
	},
	"gmaps_map_height" :
	{
		type: "integer",
		example : "Map height for the control in metadata editor",
		tip : "for example 500"
	},
	"google_analytics_tracking_code" :
	{
		type: "string",
		example : "Google analytics tracking code (if you want google analytics on this Dendro)",
		tip : "Get it from the Google Analytics website"
	},
	"secret" :
	{
		type: "string",
		example : "Crypto secret of the app",
		tip : "VERY LONG AND COMPLICATED STRING"
	},
	"project_descriptors_recommender_active" :
	{
		type: "boolean",
		example : "true or false",
		tip : "Is the project-level descriptor recommendation active?"
	},
	"public_ontologies" :
	{
		type: "array",
		example : "[\"dcterms\", \"dcb\", \"foaf\"]",
		tip : "Is the project-level descriptor recommendation active?"
	},
	"pipe_console_to_logfile" :
	{
		type: "boolean",
		example : "true",
		tip : "Pipe all logging to dedicated logfile at logs/app"
	}
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
				console.log("[ERROR] Unable to parse flag " + argument + ". It must be a boolean (true/false). " + e.message);
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
	var config_id = get_argument_by_name('config_identifier');
	var dendro_config_template = {};

	dendro_config_template[config_id] =
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
		"cache": {
			"active": true,
			"redis" : {
	        "instances": [
	          {
	            "id" : "default",
	            "options":
	            {
	              "host" : "127.0.0.1",
	              "port" : "6780"
	            },
	            "database_number" : 1
	          },
	          {
	            "id" : "social",
	            "options":
	            {
	              "host" : "127.0.0.1",
	              "port" : "6781"
	            },
	            "database_number" : 1
	          },
	          {
	            "id" : "notifications",
	            "options":
	            {
	              "host" : "127.0.0.1",
	              "port" : "6782"
	            },
	            "database_number" : 1
	          }
    		]
      },
	  		"static" :
      		{
        		"last_modified_caching" : get_argument_by_name('last_modified_caching'),
        		"cache_period_in_seconds" : get_argument_by_name('cache_period_in_seconds')
      	  }
		},
		"virtuosoHost" : get_argument_by_name('virtuoso_host'),
		"virtuosoPort" : get_argument_by_name('virtuoso_port'),
		"virtuosoAuth" : {
			"user" : get_argument_by_name('virtuoso_dba_user'),
			"password" : get_argument_by_name('virtuoso_dba_password')
		},
		"mongoDBHost" : get_argument_by_name('mongodb_host'),
		"mongoDbPort" : get_argument_by_name('mongodb_port'),
		"mongoDbCollectionName" : get_argument_by_name('mongodb_collection_name'),
		"mongoDBSessionStoreCollection" : get_argument_by_name('mongodb_collection_name') + "_sessions",
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
		"maxUploadSize" : 200000000,
		"maxProjectSize" : 200000000,
		"maxSimultanousConnectionsToDb" : 3,
		"dbOperationTimeout" : 5000,
		"tempFilesDir" : get_argument_by_name('temp_files_directory'),
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
		"debug" : {
			"debug_active": false,
			"database" :{
				"log_all_queries": false
			},
			"session": {
				"auto_login": false,
				"login_user": "demouser1"
			},
			"files": {
				"log_all_restore_operations": true,
				"log_delete_operations" : true
			},
			"resources": {
				"log_all_type_checks": false,
				"log_missing_resources": false
			},
			"permissions" : {
				"enable_permissions_system" : true,
				"log_authorizations" : false,
				"log_denials" : false,
				"log_requests_and_permissions" : false
			},
			"users" : {
				"log_fetch_by_username" : false
			},
			"descriptors": {
				"log_missing_unknown_descriptors": false,
				"log_unknown_types": false
			},
			"ontologies" : {
				"log_autocomplete_requests" : false
			},
			"views" : {
				"show_all_buttons_in_recommendations" : false,
				"prefill_text_boxes" : false
			},
			"cache" :
			{
				"log_cache_hits" : true,
				"log_cache_writes" : true,
				"log_cache_deletes" : true
			},
			"diagnostics" :
			{
				"ram_usage_report" : true
			}
		},
		"startup" : {
			"reload_administrators_on_startup" : get_argument_by_name('reload_administrators_on_startup'),
			"reload_demo_users_on_startup" : get_argument_by_name('reload_demo_users_on_startup'),
			"reload_ontologies_on_startup" : get_argument_by_name('reload_ontologies_on_startup')
		},
		"baselines" : {
			"dublin_core_only" : false
		},
		"logging" :
    {
      "pipe_console_to_logfile" : get_argument_by_name('pipe_console_to_logfile'),
      "format" : "combined",
      "app_logs_folder" : "logs/app",
      "log_request_times" : true,
      "request_times_log_folder" : "logs/request_times",
      "log_requests_in_apache_format" : false,
      "requests_in_apache_format_log_folder" : "logs/requests_apache_format"
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
							"active" : false
						},
						"phase_2" :
						{
							"table_to_write_interactions" : get_argument_by_name('interactions_table_stage2'),
							"active" : true
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
			"public_ontologies" : get_argument_by_name("public_ontologies")
	}

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
