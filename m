From: akpm@linux-foundation.org
Subject: [merged]
 drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch removed from
 -mm tree
Date: Thu, 27 Feb 2014 12:23:48 -0800
Message-ID: <530f9ed4.qsx2R+lGoNoDFawU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaB0UXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 15:23:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rubini@gnudd.com, joe@perches.com

Subject: [merged] drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch removed from -mm tree
To: joe@perches.com,rubini@gnudd.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 12:23:48 -0800


The patch titled
     Subject: drivers/fmc/fmc-write-eeprom.c: fix decimal permissions
has been removed from the -mm tree.  Its filename was
     drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: drivers/fmc/fmc-write-eeprom.c: fix decimal permissions

This 444 should have been octal.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Alessandro Rubini <rubini@gnudd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/fmc/fmc-write-eeprom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/fmc/fmc-write-eeprom.c~drivers-fmc-fmc-write-eepromc-fix-decimal-permissions drivers/fmc/fmc-write-eeprom.c
--- a/drivers/fmc/fmc-write-eeprom.c~drivers-fmc-fmc-write-eepromc-fix-decimal-permissions
+++ a/drivers/fmc/fmc-write-eeprom.c
@@ -27,7 +27,7 @@ FMC_PARAM_BUSID(fwe_drv);
 /* The "file=" is like the generic "gateware=" used elsewhere */
 static char *fwe_file[FMC_MAX_CARDS];
 static int fwe_file_n;
-module_param_array_named(file, fwe_file, charp, &fwe_file_n, 444);
+module_param_array_named(file, fwe_file, charp, &fwe_file_n, 0444);
 
 static int fwe_run_tlv(struct fmc_device *fmc, const struct firmware *fw,
 	int write)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-use-tab-for-separator.patch
maintainers-add-and-correct-types-of-some-t-entries.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch
checkpatch-use-a-more-consistent-function-argument-style.patch
checkpatch-ignore-networking-block-comment-style-first-lines-in-file.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

