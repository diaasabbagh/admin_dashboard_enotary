part of 'admin_dashboard_model.dart';

class DashboardStore {
  DashboardStore({
    required this.notaries,
    required this.sessions,
    required this.records,
    required this.rotations,
    required this.activities,
  });

  final List<NotaryAccount> notaries;
  final List<NotarySession> sessions;
  final List<FinalRecord> records;
  final List<AddressRotationRecord> rotations;
  final List<ActivityItem> activities;

  factory DashboardStore.seeded() {
    final notaries = [
      NotaryAccount(
        name: 'Diaa Sabbah',
        licenseId: 'NOT-2401',
        jurisdiction: 'Damascus',
        expiryDate: '2027-04-18',
        wallet: '0x8C39F2A04a71d6E211a83492cB7209dD817bE011',
        status: 'Active',
      ),
      NotaryAccount(
        name: 'Moh maksousa',
        licenseId: 'NOT-2418',
        jurisdiction: 'Aleppo',
        expiryDate: '2026-11-02',
        wallet: '0x1Ad7F4334E8Dc1290c0fa90176d37A68F01cD505',
        status: 'Suspended',
      ),
      NotaryAccount(
        name: 'Eyman bazerbashy',
        licenseId: 'NOT-2455',
        jurisdiction: 'Homs',
        expiryDate: '2028-01-14',
        wallet: '0xB5D08e8B2bB9cB86Eec729D3E80a885AbE7e4190',
        status: 'Active',
      ),
      NotaryAccount(
        name: 'moh moh',
        licenseId: 'NOT-2309',
        jurisdiction: 'Latakia',
        expiryDate: '2026-07-30',
        wallet: '0x01D27AfAF4b77548Dde9BAb72F900e4f64dA0d86',
        status: 'Revoked',
      ),
    ];

    return DashboardStore(
      notaries: notaries,
      sessions: const [
        NotarySession(
          id: 'SES-90021',
          documentType: 'Power of attorney',
          notary: 'Leen Al-Hakim',
          participants: ['CIT-12845', 'CIT-66219'],
          progress: 75,
          status: 'Active',
          createdAt: '2026-05-22',
        ),
        NotarySession(
          id: 'SES-90012',
          documentType: 'Property declaration',
          notary: 'Moh maksousa',
          participants: ['CIT-77102'],
          progress: 100,
          status: 'Notarized',
          createdAt: '2026-05-21',
        ),
        NotarySession(
          id: 'SES-89984',
          documentType: 'Commercial authorization',
          notary: 'Moh maksousa',
          participants: ['CIT-31008', 'CIT-31009'],
          progress: 50,
          status: 'Signed',
          createdAt: '2026-05-20',
        ),
        NotarySession(
          id: 'SES-89955',
          documentType: 'Civil affidavit',
          notary: 'Moh maksousa',
          participants: ['CIT-44210'],
          progress: 10,
          status: 'Completed',
          createdAt: '2026-05-18',
        ),
        NotarySession(
          id: 'SES-89933',
          documentType: 'Inheritance statement',
          notary: 'Moh maksousa',
          participants: ['CIT-21940', 'CIT-10442'],
          progress: 0,
          status: 'Cancelled',
          createdAt: '2026-05-16',
        ),
      ],
      records: const [
        FinalRecord(
          recordId: 'REC-71009',
          sessionId: 'SES-90012',
          documentHash:
              '0xb0d41a8c633c1d13fbbdc7068f14b5e6a309c271f8b21cd9c24fc6d44ea6cc72',
          proofHash:
              '0x974120b813dfa7d98ed609379e33b10a72a50c1ed933c0df837a550b1e6bfe91',
          notaryWallet: '0xB5D08e8B2bB9cB86Eec729D3E80a885AbE7e4190',
          txHash:
              '0xc3168cc78a1c0f8a698c5f1993e8263fd407f46db0995f63daabf609ca677c1a',
          timestamp: '2026-05-21 16:42',
          status: 'Active',
        ),
        FinalRecord(
          recordId: 'REC-70987',
          sessionId: 'SES-89902',
          documentHash:
              '0x2a79a108e32e99532fadf93d9cc1090db7f7e3e3dc623b50c1399fc8a1407f25',
          proofHash:
              '0xefc6339fa818c91ed81dc89731aa111d0d37612bb7dc8bcb1f3610b9e1d97b60',
          notaryWallet: '0x8C39F2A04a71d6E211a83492cB7209dD817bE011',
          txHash:
              '0xf1cad84810c829f70a4176a2fc7bf2872f6cc485a83abc42c1842c0e5d6fb913',
          timestamp: '2026-05-19 09:18',
          status: 'Revoked',
        ),
        FinalRecord(
          recordId: 'REC-70950',
          sessionId: 'SES-89870',
          documentHash:
              '0x4b7a2c9bd807192fc9462e36ab229d478211be891289d93f140122c3e11a0919',
          proofHash:
              '0xa3114d6e6197e001f2921c7d3fab5b808e10918f442d393e3d279a77a45088a5',
          notaryWallet: '0x01D27AfAF4b77548Dde9BAb72F900e4f64dA0d86',
          txHash:
              '0x83d0bdbb889d824fd48a9679d6f860789ab111fe75532f22ee2350a0a1bdd435',
          timestamp: '2026-05-17 13:05',
          status: 'Replaced',
        ),
      ],
      rotations: [
        AddressRotationRecord(
          id: 'ROT-5107',
          citizenId: 'CIT-12845',
          oldWallet: '0x3A1A245a49b1e21DBbcDE096Cd81d6f80661Efd2',
          newWallet: '0xd0b181A94455f5b246114e514E4bf605c17b83cC',
          reason: 'Lost access to mobile wallet',
          verifiedBy: 'Admin AD',
          rotationDate: '2026-05-22',
          status: 'Completed',
        ),
        AddressRotationRecord(
          id: 'ROT-5099',
          citizenId: 'CIT-66219',
          oldWallet: '0x7954910E0570866c66F3acE31dF23Cb816E4F477',
          newWallet: '0x97c408027dFf680fB4931e4d5Cc4A18312F1Fa13',
          reason: 'Hardware key replaced',
          verifiedBy: 'Admin AD',
          rotationDate: '2026-05-19',
          status: 'Completed',
        ),
        AddressRotationRecord(
          id: 'ROT-5081',
          citizenId: 'CIT-77102',
          oldWallet: '0x6F72688CafE08D4A38363c5CC07E5cABe2E9cA21',
          newWallet: '0xc6258D8a763e7Cc3E89a938AD2253eb0C1A37239',
          reason: 'Insufficient identity evidence',
          verifiedBy: 'Admin AD',
          rotationDate: '2026-05-11',
          status: 'Cancelled',
        ),
      ],
      activities: const [
        ActivityItem(
          'Notary account suspended',
          'Diaa Sabbagh access changed by platform admin',
          '12 min',
          Icons.pause_circle_rounded,
        ),
        ActivityItem(
          'Record verified',
          'REC-71009 matched on-chain transaction proof',
          '28 min',
          Icons.hub_rounded,
        ),
        ActivityItem(
          'Wallet rotation completed',
          'Admin AD rotated wallet for CIT-12845',
          '1 hr',
          Icons.sync_lock_rounded,
        ),
        ActivityItem(
          'Session notarized',
          'SES-90012 finalized by diaa sabbagh',
          '3 hr',
          Icons.verified_rounded,
        ),
      ],
    );
  }
}
