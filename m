From: akpm@linux-foundation.org
Subject: [folded-merged] printk-create-pr_level-functions-fix.patch
 removed from -mm tree
Date: Tue, 02 Aug 2016 13:43:00 -0700
Message-ID: <57a105d4.r5cX7Kzky4Ab1mmy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbcHBUnB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 16:43:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-create-pr_level-functions-fix
has been removed from the -mm tree.  Its filename was
     printk-create-pr_level-functions-fix.patch

This patch was dropped because it was folded into printk-create-pr_level-functions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: printk-create-pr_level-functions-fix

fix LOGLEVEL_INFO, per Joe

Cc: Joe Perches <joe@perches.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-create-pr_level-functions-fix kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-create-pr_level-functions-fix
+++ a/kernel/printk/printk.c
@@ -1819,7 +1819,7 @@ define_pr_level(__pr_crit, LOGLEVEL_CRIT
 define_pr_level(__pr_err, LOGLEVEL_ERR);
 define_pr_level(__pr_warn, LOGLEVEL_WARNING);
 define_pr_level(__pr_notice, LOGLEVEL_NOTICE);
-define_pr_level(__pr_info, LOGLEVEL_NOTICE);
+define_pr_level(__pr_info, LOGLEVEL_INFO);
 #endif
 
 int vprintk_default(int level, const char *fmt, va_list args)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

printk-create-pr_level-functions.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
kexec-add-restriction-on-kexec_load-segment-sizes-fix.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch

