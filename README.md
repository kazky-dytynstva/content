## Steps `to-do` to modify data

1. Create a branch with name `data_update`
1. Inside the latest data version folder provide all necessary data manipulations:
   * create
   * update
   * delete
1. Update in `README.md` `modified_by` section:
   * add your name and date
1. Once it ready - commit it and push to the repo.
1. Open PR (if it is not open yet)
1. Merge PR to the `main` branch.


## Steps `to-do` to migrate data

1. Create a branch with name `from_X_to_Y`, where
   X - old version
   Y - new version
1. Inside `/migration/lib/migration` create a folder with name `from_X_to_Y`. 
1. Inside `from_X_to_Y` folder create `dto` folder
   * inside it create `_new` folder and put inside all `Y`-related dto models
   * inside it create `_old` folder and put inside all `X`-related dto models
      * alternatively you can use `dto` objects from the previous migration `dto/_new` folder
1. Create `.dart` file with the same name
    * inside of it create a file with name `FromXtoY` and `extend` it from `BaseDataMigration`
    * override all necessary getters 
    * `override` `migrate` function and put inside all necessary data manipulation
1. Inside `main.dart` add `FromXtoY` class to the `migrationsList`
1. Run `main.dart`
1. Commit all new files with proper message 
    * //todo add msg example
1. Push new data to the repo
1. Open `PR` (if it is not opened yet)
   * provide data manipulation until is is production ready
1. Once data is production ready - merge `PR` to the `main` branch
   * once it is done, _migration_ should not be run again
   * in case of need - create another _migration_
1. Replace links to the new data into the application