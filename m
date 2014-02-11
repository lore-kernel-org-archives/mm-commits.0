From: akpm@linux-foundation.org
Subject: + drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch
 added to -mm tree
Date: Tue, 11 Feb 2014 12:26:08 -0800
Message-ID: <52fa8760.F2KxzhWWaTQTUfZk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbaBKU0J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 15:26:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rubini@gnudd.com, joe@perches.com

Subject: + drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch added to -mm tree
To: joe@perches.com,rubini@gnudd.com
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 12:26:08 -0800


The patch titled
     Subject: drivers/fmc/fmc-write-eeprom.c: fix decimal permissions
has been added to the -mm tree.  Its filename is
     drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch
drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

