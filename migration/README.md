## Steps `to-do` to provide new migration

1. Inside `/migration/lib/migration` create a folder with name `from_X_to_Y`, where
   X - old version
   Y - new version
2. Inside `from_X_to_Y` folder create `dto` folder
   * inside it create `_new` folder and put inside all `Y`-related dto models
   * inside it create `_old` folder and put inside all `X`-related dto models
3. Create `.dart` file with the same name
    * inside of it create a file with name `FromXtoY` and `extend` it from `BaseDataMigration`
    * provide `super` constructor with the `X` version 
    * `override` `migrate` function and put inside all necessary data manipulation
4. Inside `main.dart` add `FromXtoY` class to the `migrationsList`
5. Run `main.dart`
6. Replace links to the new data into the application
