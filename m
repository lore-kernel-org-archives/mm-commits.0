From: akpm@linux-foundation.org
Subject: [folded] v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:54:31 -0700
Message-ID: <200909222154.n8MLsWnf022540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161AbZIVVyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dgraham@nortel.com, mm-commits@vger.kernel.org


The patch titled
     v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch

This patch was dropped because it was folded into v3-minixfs-add-missing-directory-type-checking.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "(foo*)" should be "(foo *)"
#62: FILE: fs/minix/dir.c:481:
+		struct inode *inode = (struct inode*)mapping->host;

total: 1 errors, 0 warnings, 46 lines checked

./patches/v3-minixfs-add-missing-directory-type-checking.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Doug Graham" <dgraham@nortel.com>
Cc: Doug Graham <dgraham@nortel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/minix/dir.c~v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes fs/minix/dir.c
--- a/fs/minix/dir.c~v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes
+++ a/fs/minix/dir.c
@@ -478,7 +478,7 @@ ino_t minix_inode_by_name(struct dentry 
 
 	if (de) {
 		struct address_space *mapping = page->mapping;
-		struct inode *inode = (struct inode*)mapping->host;
+		struct inode *inode = mapping->host;
 		struct minix_sb_info *sbi = minix_sb(inode->i_sb);
 
 		if (sbi->s_version == MINIX_V3)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
generic-ipi-make-struct-call_function_data-lockless.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support.patch
sdio-add-mmc_quirk_lenient_fn0.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver.patch
mmc-core-sdio-suspend-resume-support.patch
procfs-provide-stack-information-for-threads-v08.patch
kcore-register-vmemmap-range.patch
rtc-add-driver-for-mxcs-internal-rtc-module.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4.patch
drivers-video-add-kmalloc-null-tests.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch

