From: akpm@linux-foundation.org
Subject: [merged] scsi_transport_fc-fix-missing-kernel-doc.patch removed from -mm tree
Date: Fri, 25 Sep 2009 12:53:33 -0700
Message-ID: <200909251953.n8PJrXrG003218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816AbZIYTxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Sep 2009 15:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     scsi_transport_fc: fix missing kernel-doc
has been removed from the -mm tree.  Its filename was
     scsi_transport_fc-fix-missing-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi_transport_fc: fix missing kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing kernel-doc notation in scsi_transport_fc.c:

Warning(drivers/scsi/scsi_transport_fc.c:3593): No description found for parameter 'q'
Warning(drivers/scsi/scsi_transport_fc.c:3700): No description found for parameter 'q'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_transport_fc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/scsi_transport_fc.c~scsi_transport_fc-fix-missing-kernel-doc drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c~scsi_transport_fc-fix-missing-kernel-doc
+++ a/drivers/scsi/scsi_transport_fc.c
@@ -3586,6 +3586,7 @@ enum fc_dispatch_result {
 
 /**
  * fc_bsg_host_dispatch - process fc host bsg requests and dispatch to LLDD
+ * @q:		fc host request queue
  * @shost:	scsi host rport attached to
  * @job:	bsg job to be processed
  */
@@ -3693,6 +3694,7 @@ fc_bsg_goose_queue(struct fc_rport *rpor
 
 /**
  * fc_bsg_rport_dispatch - process rport bsg requests and dispatch to LLDD
+ * @q:		rport request queue
  * @shost:	scsi host rport attached to
  * @rport:	rport request destined to
  * @job:	bsg job to be processed
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
isdn-fix-netjet-build-errors.patch
scsi-fix-func-names-in-kernel-doc.patch
readahead-add-blk_run_backing_dev.patch
pcmcia-fix-controller-printk-warnings.patch
reiser4-export-remove_from_page_cache-fix.patch

