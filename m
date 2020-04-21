From: akpm@linux-foundation.org
Subject: [folded-merged]
 maintainers-add-an-entry-for-kfifo-fix-fix.patch removed from -mm tree
Date: Mon, 20 Apr 2020 18:08:04 -0700
Message-ID: <20200421010804.4r-r6Yd5L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgDUBIF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 21:08:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, bgolaszewski@baylibre.com, gregkh@linuxfoundation.org, joe@perches.com, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: maintainers-add-an-entry-for-kfifo-fix-fix
has been removed from the -mm tree.  Its filename was
     maintainers-add-an-entry-for-kfifo-fix-fix.patch

This patch was dropped because it was folded into maintainers-add-an-entry-for-kfifo.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maintainers-add-an-entry-for-kfifo-fix-fix

remove colon, per Bartosz

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-an-entry-for-kfifo-fix-fix
+++ a/MAINTAINERS
@@ -9413,7 +9413,7 @@ F:	include/linux/keyctl.h
 F:	include/uapi/linux/keyctl.h
 F:	security/keys/
 
-KFIFO:
+KFIFO
 M:	Stefani Seibold <stefani@seibold.net>
 S:	Maintained
 F:	include/linux/kfifo.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-an-entry-for-kfifo.patch
mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix.patch
mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
