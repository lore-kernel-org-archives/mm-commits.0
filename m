From: akpm@linux-foundation.org
Subject: + scsi_transport_fc-fix-missing-kernel-doc.patch added to -mm tree
Date: Mon, 21 Sep 2009 12:54:52 -0700
Message-ID: <200909211954.n8LJsq5Q028134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441AbZIUTyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 15:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     scsi_transport_fc: fix missing kernel-doc
has been added to the -mm tree.  Its filename is
     scsi_transport_fc-fix-missing-kernel-doc.patch

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
kernel-hacking-move-strip_asm_syms-from-general.patch
isdn-fix-netjet-build-errors.patch
include-linux-credh-fix-build.patch
scsi-fix-func-names-in-kernel-doc.patch
scsi_transport_fc-fix-missing-kernel-doc.patch
cciss-fix-schedule_timeout-parameters.patch
wl12xx-fix-kconfig-link-errors.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
pcmcia-fix-controller-printk-warnings.patch
flex_array-add-missing-kerneldoc-annotations.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
kcore-register-vmemmap-range-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
docs-fix-various-documentation-paths-in-header-files.patch
reiser4-export-remove_from_page_cache-fix.patch

