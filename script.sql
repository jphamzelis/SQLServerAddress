SELECT --'2000' AS ResponseCode, 'Loan found' AS ResponseMessage,
CONTRACT_ID				LERETAContract
,LOAN_ID				LoanNumber
,LENDER_ID				LenderNumber
,CUST_ID				CustomerNumber
,TAX_SERVICE_TYPE		ServiceType
,TAX_ID					ParcelNumber
-- Enhanced ParcelLegalDescription: Properly handle null/blank fields without unnecessary commas
,CAST(NULLIF(
    LTRIM(RTRIM(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            CONCAT_WS(', ',
                                NULLIF(TRIM(ISNULL(LEGAL_DESCRIPTION,'')), ''),
                                NULLIF(TRIM(ISNULL(LEGAL_FREEFORM,'')), '')
                            ),
                            '  ', ' '  -- Replace double spaces with single space
                        ),
                        '   ', ' '  -- Replace triple spaces with single space
                    ),
                    '    ', ' '  -- Replace quad spaces with single space
                ),
                ', ,', ','  -- Clean up comma-space-comma patterns
            ),
            ',,', ','   -- Replace double commas
        )
    ))
,'') AS VARCHAR(MAX))	ParcelLegalDescription --LEGAL_DESCRIPTION
-- Enhanced ParcelPropertyAddress: Properly handle null/blank fields without unnecessary commas
,CAST(NULLIF(
    LTRIM(RTRIM(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            CONCAT_WS(', ',
                                NULLIF(TRIM(ISNULL(SITUS_ADDRESS,'')), ''),
                                NULLIF(TRIM(ISNULL(SITUS_CITY,'')), ''),
                                NULLIF(TRIM(ISNULL(SITUS_STATE,'')), ''),
                                NULLIF(TRIM(ISNULL(IIF(LEN(SITUS_ZIP) > 5,LEFT(SITUS_ZIP,5) + '-' + RIGHT(SITUS_ZIP,5),SITUS_ZIP),'')), '')
                            ),
                            '  ', ' '   -- Replace double spaces
                        ),
                        '   ', ' '   -- Replace triple spaces
                    ),
                    '    ', ' '   -- Replace quad spaces
                ),
                ', ,', ','    -- Remove space between consecutive commas
            ),
            ',,', ','     -- Replace double commas
        )
    ))
,'') AS VARCHAR(175))	ParcelPropertyAddress
,AGENCY_ID				AgencyNumber
,AGENCY_NAME			AgencyName
-- Enhanced AgencyAddress: Properly handle null/blank fields without unnecessary commas
,CAST(NULLIF(
    LTRIM(RTRIM(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                CONCAT_WS(', ',
                                    NULLIF(TRIM(ISNULL(SITUS_ADDR_1,'')), ''),
                                    NULLIF(TRIM(ISNULL(SITUS_ADDR_2,'')), ''),
                                    NULLIF(TRIM(ISNULL(SITUS_ADDR_3,'')), '')
                                ),
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