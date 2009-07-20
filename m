From: akpm@linux-foundation.org
Subject: + scsi_transport_fc-fix-kernel-doc-param-name.patch added to -mm tree
Date: Mon, 20 Jul 2009 12:40:48 -0700
Message-ID: <200907201940.n6KJemDB011362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555AbZGTTlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jul 2009 15:41:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     scsi_transport_fc: fix kernel-doc param name
has been added to the -mm tree.  Its filename is
     scsi_transport_fc-fix-kernel-doc-param-name.patch

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
Subject: scsi_transport_fc: fix kernel-doc param name
From: Randy Dunlap <randy.dunlap@oracle.com>

Change function parameter name in kernel-doc to match the function's
actual parameter name, to fix 2 kernel-doc warnings.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_transport_fc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_transport_fc.c~scsi_transport_fc-fix-kernel-doc-param-name drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c~scsi_transport_fc-fix-kernel-doc-param-name
+++ a/drivers/scsi/scsi_transport_fc.c
@@ -3432,7 +3432,7 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
 
 /**
  * fc_bsg_softirq_done - softirq done routine for destroying the bsg requests
- * @req:        BSG request that holds the job to be destroyed
+ * @rq:        BSG request that holds the job to be destroyed
  */
 static void fc_bsg_softirq_done(struct request *rq)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
scsi_transport_fc-fix-kernel-doc-param-name.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
maintainers-coalesce-name-and-email-address-lines.patch
lis3-add-power-management-functions-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
reiser4-export-remove_from_page_cache-fix.patch

