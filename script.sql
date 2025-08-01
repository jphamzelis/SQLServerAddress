SELECT --'2000' AS ResponseCode, 'Loan found' AS ResponseMessage,
CONTRACT_ID				LERETAContract
,LOAN_ID				LoanNumber
,LENDER_ID				LenderNumber
,CUST_ID				CustomerNumber
,TAX_SERVICE_TYPE		ServiceType
,TAX_ID					ParcelNumber
-- Improved ParcelLegalDescription: Clean multiple spaces, trim, handle commas
,CAST(NULLIF(
    LTRIM(RTRIM(
        REPLACE(
            REPLACE(
                REPLACE(
                    IIF(ISNULL(LEGAL_DESCRIPTION,'') = '','',TRIM(LEGAL_DESCRIPTION) + ' ') + ISNULL(LEGAL_FREEFORM,''),
                    '  ', ' '  -- Replace double spaces with single space
                ),
                '   ', ' '  -- Replace triple spaces with single space
            ),
            '    ', ' '  -- Replace quad spaces with single space
        )
    ))
,'') AS VARCHAR(MAX))	ParcelLegalDescription --LEGAL_DESCRIPTION
-- Improved ParcelPropertyAddress: Clean spaces and comma formatting
,CAST(NULLIF(
    LTRIM(RTRIM(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        IIF(ISNULL(SITUS_ADDRESS,'') = '','',TRIM(SITUS_ADDRESS)) + 
                        IIF(ISNULL(SITUS_CITY,'') = '','',', '+TRIM(SITUS_CITY)) + 
                        IIF(ISNULL(SITUS_STATE,'')='','',', '+TRIM(SITUS_STATE)) + 
                        ' ' + ISNULL(IIF(LEN(SITUS_ZIP) > 5,LEFT(SITUS_ZIP,5) + '-' + RIGHT(SITUS_ZIP,5),SITUS_ZIP),''),
                        '  ', ' '   -- Replace double spaces
                    ),
                    ', ,', ','  -- Remove space between consecutive commas
                ),
                ',,', ','   -- Replace double commas
            ),
            ', ,', ','  -- Clean up any remaining comma-space-comma patterns
        )
    ))
,'') AS VARCHAR(175))	ParcelPropertyAddress
,AGENCY_ID				AgencyNumber
,AGENCY_NAME			AgencyName
-- Improved AgencyAddress: Comprehensive cleaning of spaces and commas
,CAST(NULLIF(
    LTRIM(RTRIM(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                IIF(ISNULL(SITUS_ADDR_1,'') = '','',TRIM(SITUS_ADDR_1) + ', ') + 
                                IIF(ISNULL(SITUS_ADDR_2,'') = '','',TRIM(SITUS_ADDR_2) + ', ') + 
                                ISNULL(TRIM(SITUS_ADDR_3),''),
                                '  ', ' '      -- Replace double spaces
                            ),
                            '   ', ' '      -- Replace triple spaces
                        ),
                        '    ', ' '      -- Replace quad spaces
                    ),
                    ', ,', ','       -- Remove space between consecutive commas
                ),
                ',,', ','        -- Replace double commas
            ),
            ', ,', ','       -- Clean up any remaining comma-space-comma patterns
        )
    ))
,'') AS VARCHAR(325)) AgencyAddress
,PAYEE_ID				ClientPayeeNumber
,PAYEE_NAME			ClientPayeeName
,TAX_YEAR				AgencyTaxYear
,INSTALLMENT			AgencyInstallment
,NO_OF_INSTALLS			AgencyInstallmentTotal
,BRQ1           		TaxBillRequestedDate
,CAST(ISNULL(MF_REPORTED_DATE,DR_CreatedDate) AS DATE)	TaxBillReportedDate
,ISNULL(MF_REPORTED_AMT,DR_GrossDisbursement)			TotalAmountDue
,ELDC					TaxInstallmentDueDate
,DR_CheckDate			CheckDate
,DR_CheckNumber			CheckNumber
,PTS_TypeOfFunds		DisbursementMethod
,PTS_DeliveryMethod		DeliveryMethod
,CAST(ISNULL(MailedDate,PTS_FundsSentDate) AS DATE) TaxPaymentRemittedDate
,CAST(ISNULL(TrackingNumber,NULLIF(NULLIF(PTS_PackageTrackingOrFedReference,''),'Exception')) AS VARCHAR(100))	TrackingNumber
,CAST(ISNULL(DeliveryDate,PTS_PaymentDeliveryDate) AS DATE) TaxPaymentDeliveryDate
,TaxBillRequestedStatus
,TaxBillReportedStatus
,TaxPaymentDisbursedStatus
,TaxPaymentRemittedStatus
,DoNotDisplay
FROM [BP].[rvw_BorrowerPortalDetail](NOLOCK)