From: akpm@linux-foundation.org
Subject: - cdrom-replace-hard-coded-constants-by-kernelh-macro.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:37 -0700
Message-ID: <200707162057.l6GKvbNO002209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47626 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755776AbXGPVOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:14:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cdrom: replace hard-coded constants by kernel.h macro.
has been removed from the -mm tree.  Its filename was
     cdrom-replace-hard-coded-constants-by-kernelh-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cdrom: replace hard-coded constants by kernel.h macro.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cdrom.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

origin.patch
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
mm-make-needlessly-global-hugetlb_no_page-static.patch
