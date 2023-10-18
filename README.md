# Coding Challenge

This repository contains a solution to a coding challenge.  A brief summary
* take 2 files as inputs: users, companies
* calculate a new value
  - add tokens to the user's total
  - identify if the user should be notified
* write out the results: output.txt file

More details are available in [challenge.txt](challenge.txt).

## Usage
The program is run with
```bash
$ ruby challenge.rb companies.json users.json
$ ls output.txt
$ bundle install
$ rspec
```

## Notes

This is not prodution ready code.  Instead, it shows a few design patterns.

The implemenation follows a few guidelines
- treat data objects as read only
- new calculations or transformations are stored in new objects

Using data transfer objects (DTO) allows us to decouple the business logic from
libraries used to access the stored data.  We could implement a `DataLoader`
class that retrieves data from
* a relational database
* queue
* messaage system
* NoSQL system
and pass that data, using the DTO, to the business logic.

### Loading Data
Data is loaded from a json file using `DataLoader#load_or_exit_on_error`.  By passing
in different filenames and factories, the same JSON parsing and error handling logic
is re-used for loading both user and company data.

The return value is an object containing the results of loading the data
* error messages, if any
* valid data
* invalid data

This allows the caller to decide how to
* report errors
* when to process valid data
* when to exit

The helper method `load_or_exit_on_error` exits if a data file contains
known bad data.

### Business Calculations
Business calculations are in `TokenTopUpProcess`.  Data flows through multiple
data transfer objects
* `User`, `Company` represent the original data
* `InputData` holds all input data in one place
* `TokenUpdate` represents the results of the business logic calculation
* `TokenUpdateSummary` holds all results and input data in one place
  - it also provides a few helper methods to summarize the results

### Writing Out Results
`TokenUpdateFormatter` focusses on writing out the results in a specific
format described in the code challenge requirements.

It writes the business results from `TokenUpdateSummary` to an input / output
stream: a file handle to `output.txt` or any similar object.

### Error Class
Some implementations use ruby's exception handling system for business logic.
In this case, a custom error (eg: `ChallengeError`) is created and all
implementation specific errors are descended from this class.

It can work.

An alternative is for the code to handle expected exceptions and errors.
These errors can be added to a results object instead of raising the error.

## Next Steps

This code challenge can provide a good learning opportunity by creating
solutions using very different design patterns.

* functional stream processing
* actor models
* parallel processing

## Limitations

Several key areas where the implementation could be improved.

### Lack of business logic tests

### Detecting Errors
Detecting errors in the user and company data is minimal. Options to improve
- extending the User and Company classes with hand rolled validations
- using ActiveModel to define validations for key fields

Detecting errors in parameters passed to the command line program.

### Reporting Progress
A __transcript__ role or object can receive progress updates on a business
logic calculation.  This is similar to a logging library but more specific
to recording / auditing business calculations.

There may be multiple implementations
* report to a console when running as a command line program
* send results to an "append only" storage system
* send alerts

Many ways to implement the transcript concept and is left as an exercise
for the future.
