From: akpm@linux-foundation.org
Subject: + aerdrv-fix-a-typo-in-error-message.patch added to -mm tree
Date: Sun, 07 Dec 2008 00:36:44 -0800
Message-ID: <200812070836.mB78aiQL002489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661AbYLGIgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 03:36:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: seto.hidetoshi@jp.fujitsu.com, jbarnes@virtuousgeek.org, yanmin.zhang@intel.com


The patch titled
     aerdrv: fix a typo in error message
has been added to the -mm tree.  Its filename is
     aerdrv-fix-a-typo-in-error-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
aerdrv-fix-a-typo-in-error-message.patch

