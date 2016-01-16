From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 16:33:31 -0800
Message-ID: <56998fdb.P5oJ6RMYsjaZTA6F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbcAPAdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:33:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, wangxq10@lzu.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix
has been removed from the -mm tree.  Its filename was
     mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix.patch

This patch was dropped because it was folded into mm-mlockc-change-can_do_mlock-return-value-type-to-boolean.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix

update declaration in mm.h

Cc: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix
+++ a/include/linux/mm.h
@@ -1100,7 +1100,7 @@ static inline bool shmem_mapping(struct
 }
 #endif
 
-extern int can_do_mlock(void);
+extern bool can_do_mlock(void);
 extern int user_shm_lock(size_t, struct user_struct *);
 extern void user_shm_unlock(size_t, struct user_struct *);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-define-madv_free-for-some-arches.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures.patch
mm-mlockc-change-can_do_mlock-return-value-type-to-boolean.patch
mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch
mm-soft-offline-exit-with-failure-for-non-anonymous-thp-fix.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch

