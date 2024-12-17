CREATE TABLE FAST_DATA
  (
    CLAVE                          DECIMAL(18,0) NOT NULL,
    CONTACT_ID                     DECIMAL(18,0) NOT NULL,
    CONTACT_DESC                   STRING,
    COUNTRY_DESC                   STRING,
    IDENTIFICATION_1_TYPE_CODE     STRING,
    IDENTIFICATION_DOCUMENT_1_NUMB STRING,
    PHONE_NUMBER                   STRING,
    EMAIL_ID                       STRING,
    ELECTRONIC_ADDRESS             STRING,
    FINANCIAL_ACCOUNT_KEY          DECIMAL(18,0),
    FINANCIAL_ACCOUNT_STATUS_DESC  STRING,
    PRIMARY_RESOURCE_VALUE         STRING,
    SUBSCRIBER_KEY                 DECIMAL(18,0),
    SUBSCRIBER_STATUS_DESC         STRING,
    CUSTOMER_TYPE_DESC             STRING,
    CUSTOMER_STATUS_DESC           STRING,
    CONTACT_ROLE_NAME              STRING,
    PRIMARY_SUBS_DESC              STRING,
    PLAN_TYPE                      STRING,
    PRODUCT_LINE_OF_BUSINESS_DESC  STRING,
    CUSTOMER_KEY                   DECIMAL(18,0),
    PRIMARY KEY (CLAVE)
  ) 
  STORED AS KUDU 
  TBLPROPERTIES (
  'kudu.num_tablet_replicas' = '1'
);