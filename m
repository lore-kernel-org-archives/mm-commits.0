From: akpm@linux-foundation.org
Subject: [folded-merged] fs-pstore-logging-clean-up-fix.patch removed from -mm tree
Date: Fri, 06 Jun 2014 14:08:11 -0700
Message-ID: <53922dbb.qkxZ/O9Rd1hYmRqL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaFFVIM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:08:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, fabf@skynet.be, ccross@android.com, anton@enomsg.org, akpm@linux-foundation.org

Subject: [folded-merged] fs-pstore-logging-clean-up-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,anton@enomsg.org,ccross@android.com,fabf@skynet.be,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:08:11 -0700


The patch titled
     Subject: fs-pstore-logging-clean-up-fix
has been removed from the -mm tree.  Its filename was
     fs-pstore-logging-clean-up-fix.patch

This patch was dropped because it was folded into fs-pstore-logging-clean-up.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-pstore-logging-clean-up-fix

missed a couple of prefix removals

Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pstore/platform.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/pstore/platform.c~fs-pstore-logging-clean-up-fix fs/pstore/platform.c
--- a/fs/pstore/platform.c~fs-pstore-logging-clean-up-fix
+++ a/fs/pstore/platform.c
@@ -455,8 +455,7 @@ int pstore_register(struct pstore_info *
 		add_timer(&pstore_timer);
 	}
 
-	pr_info("pstore: Registered %s as persistent store backend\n",
-		psi->name);
+	pr_info("Registered %s as persistent store backend\n", psi->name);
 
 	return 0;
 }
@@ -502,7 +501,7 @@ void pstore_get_records(int quiet)
 				size = unzipped_len;
 				compressed = false;
 			} else {
-				pr_err("pstore: decompression failed;returned %d\n",
+				pr_err("decompression failed;returned %d\n",
 				       unzipped_len);
 				compressed = true;
 			}
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
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch

