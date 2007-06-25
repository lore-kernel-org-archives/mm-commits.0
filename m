From: akpm@linux-foundation.org
Subject: + cdrom-replace-hard-coded-constants-by-kernelh-macro.patch added to -mm tree
Date: Mon, 25 Jun 2007 15:40:53 -0700
Message-ID: <200706252240.l5PMerH3012784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573AbXFYWlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 18:41:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, jens.axboe@oracle.com


The patch titled
     cdrom: replace hard-coded constants by kernel.h macro.
has been added to the -mm tree.  Its filename is
     cdrom-replace-hard-coded-constants-by-kernelh-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cdrom: replace hard-coded constants by kernel.h macro.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cdrom.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/cdrom.h~cdrom-replace-hard-coded-constants-by-kernelh-macro include/linux/cdrom.h
--- a/include/linux/cdrom.h~cdrom-replace-hard-coded-constants-by-kernelh-macro
+++ a/include/linux/cdrom.h
@@ -414,8 +414,8 @@ struct cdrom_generic_command
 #define CDO_CHECK_TYPE		0x10    /* check type on open for data */
 
 /* Special codes used when specifying changer slots. */
-#define CDSL_NONE       	((int) (~0U>>1)-1)
-#define CDSL_CURRENT    	((int) (~0U>>1))
+#define CDSL_NONE       	(INT_MAX-1)
+#define CDSL_CURRENT    	INT_MAX
 
 /* For partition based multisession access. IDE can handle 64 partitions
  * per drive - SCSI CD-ROM's use minors to differentiate between the
_

Patches currently in -mm which might be from rpjday@mindspring.com are

ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
git-kvm.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
cobalt-remove-all-references-to-cobalt-nvram.patch
remove-final-two-references-to-__obsolete_setup-macro.patch
cdrom-replace-hard-coded-constants-by-kernelh-macro.patch
