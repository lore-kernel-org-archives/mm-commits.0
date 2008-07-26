From: akpm@linux-foundation.org
Subject: - parport-sharec-proper-externs.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:44 -0700
Message-ID: <200807262113.m6QLDiTj019622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757492AbYGZVNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:13:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     parport/share.c: proper externs
has been removed from the -mm tree.  Its filename was
     parport-sharec-proper-externs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport/share.c: proper externs
From: Adrian Bunk <bunk@kernel.org>

This patch adds proper externs for parport_default_timeslice and
parport_default_spintime in include/linux/parport.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/procfs.c |    3 ---
 include/linux/parport.h  |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/parport/procfs.c~parport-sharec-proper-externs drivers/parport/procfs.c
--- a/drivers/parport/procfs.c~parport-sharec-proper-externs
+++ a/drivers/parport/procfs.c
@@ -429,9 +429,6 @@ struct parport_default_sysctl_table
 	ctl_table dev_dir[2];
 };
 
-extern unsigned long parport_default_timeslice;
-extern int parport_default_spintime;
-
 static struct parport_default_sysctl_table
 parport_default_sysctl_table = {
 	.sysctl_header	= NULL,
diff -puN include/linux/parport.h~parport-sharec-proper-externs include/linux/parport.h
--- a/include/linux/parport.h~parport-sharec-proper-externs
+++ a/include/linux/parport.h
@@ -560,5 +560,8 @@ extern int parport_device_proc_unregiste
 
 #endif /*  !CONFIG_PARPORT_NOT_PC  */
 
+extern unsigned long parport_default_timeslice;
+extern int parport_default_spintime;
+
 #endif /* __KERNEL__ */
 #endif /* _PARPORT_H_ */
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

