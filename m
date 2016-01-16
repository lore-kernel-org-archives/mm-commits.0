From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 16:36:31 -0800
Message-ID: <5699908f.7l1+VBEd2+FW2MhX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbcAPAgc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:36:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aconole@redhat.com, dvyukov@google.com, jbaron@akamai.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix
has been removed from the -mm tree.  Its filename was
     printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch

This patch was dropped because it was folded into printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix

remove braces, per Joe

Cc: Aaron Conole <aconole@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/printk.h~printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix include/linux/printk.h
--- a/include/linux/printk.h~printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix
+++ a/include/linux/printk.h
@@ -110,9 +110,8 @@ struct va_format {
  */
 #define no_printk(fmt, ...)			\
 do {						\
-	if (0) {				\
+	if (0)					\
 		printk(fmt, ##__VA_ARGS__);	\
-	}					\
 } while (0)
 
 #ifdef CONFIG_EARLY_PRINTK
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-define-madv_free-for-some-arches.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments.patch

