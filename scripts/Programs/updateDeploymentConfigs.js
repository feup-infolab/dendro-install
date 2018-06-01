const fs = require("fs");
const path = require("path");

/**
 * Updates a JSON file
 * @param filepath the path of the JSON file
 * @param keyPath the full json key whose value will be changed ex: "users.John.age"
 * @param newValue the new value
 */
module.exports.updateJSONFile = function (filepath, keyPath, newValue)
{
	var originalData = JSON.parse(fs.readFileSync(filepath).toString());
    var keys = keyPath.split(".");

    const setValue = function(propertyPath, value, obj){

		// this is a super simple parsing, you will want to make this more complex to handle correctly any path
		// it will split by the dots at first and then simply pass along the array (on next iterations)
		let properties = Array.isArray(propertyPath) ? propertyPath : propertyPath.split(".");

		// Not yet at the last property so keep digging
		if (properties.length > 1) {
			// The property doesn't exists OR is not an object (and so we overwrite it) or we create it
			if (!obj.hasOwnProperty(properties[0]) || typeof obj[properties[0]] !== "object")
			{
				//we create the property has it does not exist
                obj[properties[0]] = {};
			}

			// We iterate.
			return setValue(properties.slice(1), value, obj[properties[0]])
		} else {
            // This is the last property - the one where to set the value
			// We set the value to the last property
			obj[properties[0]] = value;
			return true // this is the end
		}
	};

	try
	{
		setValue(keys, newValue, originalData);
        fs.writeFileSync(filepath, JSON.stringify(originalData, null, 4));
	}
	catch(error)
	{
		console.log("This is an error: " + error);
	}
};

