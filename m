From: akpm@linux-foundation.org
Subject: [merged] staging-udlfb-fix-printk-format-warning.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:28:38 -0700
Message-ID: <200908101928.n7AJScaw028047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbZHJT2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:28:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     staging/udlfb: fix printk format warning
has been removed from the -mm tree.  Its filename was
     staging-udlfb-fix-printk-format-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: staging/udlfb: fix printk format warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning: use %td for ptrdiff:

drivers/staging/udlfb/udlfb.h:209: warning: format '%d' expects type 'int', but argument 3 has type 'long int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/udlfb/udlfb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/udlfb/udlfb.h~staging-udlfb-fix-printk-format-warning drivers/staging/udlfb/udlfb.h
--- a/drivers/staging/udlfb/udlfb.h~staging-udlfb-fix-printk-format-warning
+++ a/drivers/staging/udlfb/udlfb.h
@@ -205,7 +205,7 @@ static int dlfb_set_video_mode(struct dl
 
 			/* send */
 			ret = dlfb_bulk_msg(dev_info, bufptr - dev_info->buf);
-			printk("ret bulk 2: %d %d\n", ret,
+			printk("ret bulk 2: %d %td\n", ret,
 			       bufptr - dev_info->buf);
 
 			/* flush */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
media-zr364xx-fix-build-errors.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mtd-make-onenand-genericc-more-generic-fix.patch
isdn-fix-netjet-build-errors.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
add-a-driver-for-the-winbond-wpcd376i-ir-functionality-select-bitreverse.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
reiser4-export-remove_from_page_cache-fix.patch

