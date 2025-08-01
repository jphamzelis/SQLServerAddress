SELECT --'2000' AS ResponseCode, 'Loan found' AS ResponseMessage,
CONTRACT_ID				LERETAContract
,LOAN_ID				LoanNumber
,LENDER_ID				LenderNumber
,CUST_ID				CustomerNumber
,TAX_SERVICE_TYPE		ServiceType
,TAX_ID					ParcelNumber
,CAST(NULLIF(IIF(ISNULL(LEGAL_DESCRIPTION,'') = '','',TRIM(LEGAL_DESCRIPTION) + ' ') + ISNULL(LEGAL_FREEFORM,''),'') AS VARCHAR(MAX))	ParcelLegalDescription --LEGAL_DESCRIPTION
,CAST(NULLIF(IIF(ISNULL(SITUS_ADDRESS,'') = '','',TRIM(SITUS_ADDRESS)) + IIF(ISNULL(SITUS_CITY,'') = '','',', '+TRIM(SITUS_CITY)) + IIF(ISNULL(SITUS_STATE,'')='','',', '+TRIM(SITUS_STATE)) + ' ' + ISNULL(IIF(LEN(SITUS_ZIP) > 5,LEFT(SITUS_ZIP,5) + '-' + RIGHT(SITUS_ZIP,5),SITUS_ZIP),''),'') AS VARCHAR(175))	ParcelPropertyAddress
,AGENCY_ID				AgencyNumber
,AGENCY_NAME			AgencyName
,CAST(NULLIF(REPLACE(IIF(ISNULL(SITUS_ADDR_1,'') = '','',TRIM(SITUS_ADDR_1) + ', ') + IIF(ISNULL(SITUS_ADDR_2,'') = '','',TRIM(SITUS_ADDR_2) + ', ') + ISNULL(TRIM(SITUS_ADDR_3),''),',,',','),'') AS VARCHAR(325)) AgencyAddress
,PAYEE_ID				ClientPayeeNumber
,PAYEE_NAME				ClientPayeeName
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