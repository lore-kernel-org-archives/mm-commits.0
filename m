From: akpm@linux-foundation.org
Subject: + scsi-fix-func-names-in-kernel-doc.patch added to -mm tree
Date: Wed, 19 Aug 2009 11:36:42 -0700
Message-ID: <200908191836.n7JIag5g002244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202AbZHSSgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 14:36:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com


The patch titled
     scsi: fix func names in kernel-doc
has been added to the -mm tree.  Its filename is
     scsi-fix-func-names-in-kernel-doc.patch

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
Subject: scsi: fix func names in kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix scsi_devinfo.c kernel-doc function names to match actual function
names.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_devinfo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_devinfo.c~scsi-fix-func-names-in-kernel-doc drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c~scsi-fix-func-names-in-kernel-doc
+++ a/drivers/scsi/scsi_devinfo.c
@@ -454,7 +454,7 @@ int scsi_get_device_flags(struct scsi_de
 
 
 /**
- * get_device_flags_keyed - get device specific flags from the dynamic device list.
+ * scsi_get_device_flags_keyed - get device specific flags from the dynamic device list
  * @sdev:       &scsi_device to get flags for
  * @vendor:	vendor name
  * @model:	model name
@@ -685,7 +685,7 @@ MODULE_PARM_DESC(default_dev_flags,
 		 "scsi default device flag integer value");
 
 /**
- * scsi_dev_info_list_delete - called from scsi.c:exit_scsi to remove the scsi_dev_info_list.
+ * scsi_exit_devinfo - remove /proc/scsi/device_info & the scsi_dev_info_list
  **/
 void scsi_exit_devinfo(void)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mtd-make-onenand-genericc-more-generic-fix.patch
isdn-fix-netjet-build-errors.patch
scsi-fix-func-names-in-kernel-doc.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
reiser4-export-remove_from_page_cache-fix.patch

