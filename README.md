# Snowflake-Pipelines-and-Governance

The files attached are examples of SnowSQL commands used to manage warehousing pipelines and transformations, data masking policies, and role-based access controls. These are scrubbed examples of work that I completed for Kubrick Group Consulting, iterating on previous client projects to optimize performance and learn best practices with automated pipelines & enterprise data management.

NOTES:
These files cannot be run without a Snowflake warehouse instance. You will also need to install SnowSQL to your command line interface. (Unless you do everything through the GUI or remote connections to an existing server.) SnowSQL is a library meant to work with the Snowflake server-client pair. A Snowflake client allows data engineers and platform architects to stage tables across different warehouses for use across various applications, systems, and software interfaces. 

TO RUN:
If you have a working Snowflake instance or free trial, these queries can be run with the appropriate user and schema connections. To run, copy and paste the code into your Snowflake client and change the Warehouse, Schema, and User settings to your preferences. After modifying the code, you can run it to see how these queries work. You will need multiple accounts (achievable with two free trials across two email addresses, in a pinch) to see the roles and their associated controls.
