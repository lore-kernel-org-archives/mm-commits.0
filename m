From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch removed from -mm tree
Date: Fri, 06 Jun 2014 14:08:41 -0700
Message-ID: <53922dd9.pS2Cagn7nsneIR//%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaFFVIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:08:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, joe@perches.com, fabf@skynet.be, akpm@linux-foundation.org

Subject: [folded-merged] fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,fabf@skynet.be,joe@perches.com,tytso@mit.edu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:08:41 -0700


The patch titled
     Subject: fs-devpts-inodec-convert-printk-to-pr_foo-fix
has been removed from the -mm tree.  Its filename was
     fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch

This patch was dropped because it was folded into fs-devpts-inodec-convert-printk-to-pr_foo.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-devpts-inodec-convert-printk-to-pr_foo-fix

use KBUILD_MODNAME, per Joe

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/devpts/inode.c~fs-devpts-inodec-convert-printk-to-pr_foo-fix fs/devpts/inode.c
--- a/fs/devpts/inode.c~fs-devpts-inodec-convert-printk-to-pr_foo-fix
+++ a/fs/devpts/inode.c
@@ -10,7 +10,7 @@
  *
  * ------------------------------------------------------------------------- */
 
-#define pr_fmt(fmt) "devpts: " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
 #include <linux/init.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch
rtc-da9063-rtc-driver.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
sysctl-allow-for-strict-write-position-handling.patch
fs-pstore-logging-clean-up.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch

