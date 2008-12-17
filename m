From: akpm@linux-foundation.org
Subject: - aerdrv-fix-a-typo-in-error-message.patch removed from -mm tree
Date: Wed, 17 Dec 2008 12:48:36 -0800
Message-ID: <200812172048.mBHKmame006893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbYLQUtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 15:49:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: seto.hidetoshi@jp.fujitsu.com, jbarnes@virtuousgeek.org, yanmin.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     aerdrv: fix a typo in error message
has been removed from the -mm tree.  Its filename was
     aerdrv-fix-a-typo-in-error-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aerdrv: fix a typo in error message
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

"TLP" is an acronym for "Transaction Layer Packet."

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aer/aerdrv_errprint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/pcie/aer/aerdrv_errprint.c~aerdrv-fix-a-typo-in-error-message drivers/pci/pcie/aer/aerdrv_errprint.c
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c~aerdrv-fix-a-typo-in-error-message
+++ a/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -233,7 +233,7 @@ void aer_print_error(struct pci_dev *dev
 
 		if (info->flags & AER_TLP_HEADER_VALID_FLAG) {
 			unsigned char *tlp = (unsigned char *) &info->tlp;
-			printk("%sTLB Header:\n", loglevel);
+			printk("%sTLP Header:\n", loglevel);
 			printk("%s%02x%02x%02x%02x %02x%02x%02x%02x"
 				" %02x%02x%02x%02x %02x%02x%02x%02x\n",
 				loglevel,
_

Patches currently in -mm which might be from seto.hidetoshi@jp.fujitsu.com are

linux-next.patch
aerdrv-fix-sanity-check-in-report_resume.patch

