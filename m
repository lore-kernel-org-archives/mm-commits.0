From: akpm@linux-foundation.org
Subject: [folded-merged]
 arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch removed from -mm tree
Date: Fri, 15 Jan 2016 16:26:47 -0800
Message-ID: <56998e47.SjGQyMv9LMbR8m+7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309AbcAPA0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:26:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix
has been removed from the -mm tree.  Its filename was
     arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch

This patch was dropped because it was folded into mm-define-madv_free-for-some-arches.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix

Cc: Minchan Kim <minchan@kernel.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/uapi/asm/mman.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/mips/include/uapi/asm/mman.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -73,7 +73,6 @@
 #define MADV_SEQUENTIAL 2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
-#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_FREE	8		/* free pages only if memory pressure */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-define-madv_free-for-some-arches.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix.patch
mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch
mm-soft-offline-exit-with-failure-for-non-anonymous-thp-fix.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch

