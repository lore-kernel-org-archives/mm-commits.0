From: akpm@linux-foundation.org
Subject: - scsi-tmscsimc-fix-mangled-printk-output.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:45:25 -0700
Message-ID: <200808261845.m7QIjPXM021401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756803AbYHZSqG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:46:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nick@ukfsn.org, James.Bottomley@HansenPartnership.com, g.liakhovetski@gmx.de, mm-commits@vger.kernel.org


The patch titled
     scsi: tmscsim.c: fix mangled printk output
has been removed from the -mm tree.  Its filename was
     scsi-tmscsimc-fix-mangled-printk-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: tmscsim.c: fix mangled printk output
From: Nick Warne <nick@ukfsn.org>

Signed-off-by: Nick Warne <nick@ukfsn.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/tmscsim.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/tmscsim.c~scsi-tmscsimc-fix-mangled-printk-output drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c~scsi-tmscsimc-fix-mangled-printk-output
+++ a/drivers/scsi/tmscsim.c
@@ -2573,8 +2573,8 @@ static struct pci_driver dc390_driver = 
 static int __init dc390_module_init(void)
 {
 	if (!disable_clustering)
-		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n"
-		       "\twith \"disable_clustering=1\" and report to maintainers\n");
+		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n");
+		printk(KERN_INFO "	with \"disable_clustering=1\" and report to maintainers\n");
 
 	if (tmscsim[0] == -1 || tmscsim[0] > 15) {
 		tmscsim[0] = 7;
_

Patches currently in -mm which might be from nick@ukfsn.org are

linux-next.patch

