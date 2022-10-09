# IncomeBalance
 
This is a demo I made using Swift that lists incomes, expenses and shows a balance.

I used the following:
- UIKit
- CoreData
- MVVM
- UnitOfWOrk pattern
- Storyboard
- Combine
- Delegate
- Date formatting
- unit tests
- Repository pattern
- Auto layout

Architecture: MVVM

View <> ViewModel <> TransactionRepository <> CoreDataRepository > Model

Description:
Each view will have it's own viewModel and repositories that are related to their data.
And each repository will communicate with CoreDataRepository to interact with CoreData.
CoreDataRepository contains all logic for CoreData handling while other repositories related to specific context are seperate.

Video

https://user-images.githubusercontent.com/52874288/193270451-e6c5b599-03c4-4ebc-b41c-cfdbe5a873d8.mov



