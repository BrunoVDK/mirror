//
//  ProjectOptionsDictionary.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 18/11/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#define MAX_PRESETS 10

FOUNDATION_EXPORT NSString *const ProjectOptionsDictionaryWillChange; // Notification sent before dictionary changes
FOUNDATION_EXPORT NSString *const ProjectOptionsDictionaryDidChange; // Notification sent after dictionary changed
FOUNDATION_EXPORT NSString *const CustomPresetName; // The reserved preset name for custom options
FOUNDATION_EXPORT NSString *const DefaultPresetName; // The reserved preset name for default options
FOUNDATION_EXPORT NSString *const PresetsPreferencesKey; // The preferences key under which presets are saved
FOUNDATION_EXPORT NSString *const DefaultPresetPreferencesKey; // The preferences key referring to the default preset

@class Project;

/**
 * The `ProjectOptionsDictionary` class functions as a proxy for a dictionary of project options.
 *  When initialised it holds a reference to an empty dictionary and provides default values when asked.
 *  Option values can then be altered, and these modifications are stored in the private dictionary.
 *
 * The dictionary is KVO-compatible, the keys that are used have to match those of the actual option keys
 *  (eg. self.usecache). Getting a full list of available options is possible with the +allOptions method.
 * Altering options and propagating them to a project's httrack dictionary is fast, as hashing is used to
 *  figure out what is necessary to alter the option that is set.
 *
 * This class also takes care of presets saved in the user defaults.
 */
@interface ProjectOptionsDictionary : NSObject<NSCoding> {
    
    Project *_project;
    NSMutableDictionary *optionsDictionary; // The dictionary this instance proxies to (private)
    NSString *_presetIdentifier;
    
}

@property (nonatomic, assign, readonly) Project *project;

/**
 * Returns an array having the keys of all project options.
 */
+ (NSArray *)allOptionKeys;

/**
 * Returns a dictionary with one key for every project option category. Each key's corresponding value
 *  is an NSArray with option keys that are part of the very category. The corresponding options have a boolean value.
 */
+ (NSDictionary *)generalOptionKeys;

/**
 * Returns the description of the general option with given key.
 *
 * @param key The key of the option whose description is desired.
 * @return The description of the option with given key.
 */
+ (NSString *)descriptionForGeneralOptionKey:(NSString *)key;

/**
 * Returns an array of preset names that have been saved in the user defaults.
 */
+ (NSArray *)savedPresetNames;

/**
 * Returns the name of the preset used by default.
 */
+ (NSString *)defaultPresetName;

/**
 * Remove the preset with given name from the user defaults.
 *
 * @param presetName The name (identifier) of the preset that is to be removed.
 */
+ (void)removePresetWithName:(NSString *)presetName;

/**
 * Remove the presets with given names from the user defaults.
 *
 * @param presetNames A list of identifiers of presets that are to be removed.
 */
+ (void)removePresetsWithNames:(NSArray *)presetNames;

/**
 * Returns the default value for the option with given key.
 *
 * @param key The key of the option whose default value is desired.
 */
+ (id)defaultValueForOptionKey:(NSString *)key;

/**
 * Returns whether or not the option with given key can be altered when the project's engine is running.
 *
 * @param key The key of the option to inspect.
 * @return True if and only if the option with given key can indeed be altered when the project's engine is running.
 */
+ (BOOL)optionCanBeAltered:(NSString *)key;

/**
 * Initialise a new options dictionary and associate it to the given project.
 *
 * @param project The project the new options dictionary is associated with.
 * @return A new options dictionary attached to the given project, with default option values.
 */
- (id)initWithProject:(Project *)project;

/**
 * Initialise a new options dictionary with the preset with the given name and associate it to the given project.
 *
 * @param project The project the new options dictionary is associated with.
 * @param presetName The name of the preset that is to be used.
 * @return A new options dictionary attached to the given project, with option values matching that of the preset with given name.
 */
- (id)initWithProject:(Project *)project usingPresetWithName:(NSString *)presetName;

/**
 * Initialise a new options dictionary based on the given dictionary, and associate it to the given project.
 *
 * @param project The project the new options dictionary is associated with.
 * @param dictionary An options dictionary which this dictionary is to be based on.
 * @return A new options dictionary attached to the given project, with the same values as the given dictionary.
 */
- (id)initWithProject:(Project *)project usingDictionary:(ProjectOptionsDictionary *)dictionary;

/**
 * Adopt the values in the given options dictionary.
 *
 * @param dictionary The dictionary to take values from.
 */
- (void)adoptDictionary:(ProjectOptionsDictionary *)dictionary;

/**
 * Checks whether or not the given preset name is a valid name for saving this options dictionary as a preset.
 *
 * @param presetName The name whose validity needs to be checked.
 * @param error A pointer to a string. If the preset name is invalid, then this error will point to a
 *              description of the problem with the preset name.
 * @return True if and only if the given preset name can be used when saving this options dictionary.
 */
- (BOOL)isValidPresetName:(NSString *)presetName error:(NSString **)error;

/**
 * Save this options dictionary's values as a preset.
 *
 * @param presetName The name of the new preset
 * @param error A pointer to a string that will hold the error if any occured.
 * @return  True if and only if this options dictionary has been savned as a preset. If not, then
 *          the error description will be saved in the given string pointer.
 */
- (BOOL)saveAsPresetWithName:(NSString *)presetName error:(NSString **)error;

/**
 * Returns the name of the preset that this options dictionary adheres to.
 *
 * @return The name of the preset (which is also its identifier).
 */
- (NSString *)presetName;

/**
 * Checks whether or not this options dictionary has customised values.
 *
 * @return True if and only if this options dictionary has been customised.
 */
- (BOOL)isCustom;

/**
 * Get a list of option keys for which this dictionary has non-default values.
 *
 * @return An array of option keys for which this dictionary has custom values.
 */
- (NSArray *)customisedOptionKeys;

@end
