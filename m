From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-introduce-external-memory-hinting-api-fix-2-fix.patch removed from -mm
 tree
Date: Wed, 10 Jun 2020 18:22:41 -0700
Message-ID: <20200611012241.skwsuI1oj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgFKBWm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:22:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-external-memory-hinting-api-fix-2-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-external-memory-hinting-api-fix-2-fix.patch

This patch was dropped because it was folded into mm-introduce-external-memory-hinting-api.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-introduce-external-memory-hinting-api-fix-2-fix

the compat bit comes later

Cc: Minchan Kim <minchan@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/syscalls/syscall_o32.tbl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/syscalls/syscall_o32.tbl~mm-introduce-external-memory-hinting-api-fix-2-fix
+++ a/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -426,4 +426,4 @@
 437	o32	openat2				sys_openat2
 438	o32	pidfd_getfd			sys_pidfd_getfd
 439	o32	faccessat2			sys_faccessat2
-440	o32	process_madvise			sys_process_madvise		compat_sys_process_madvise
+440	o32	process_madvise			sys_process_madvise
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
arch-powerpc-mm-pgtablec-another-missed-conversion.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
kernel-forkc-export-kernel_thread-to-modules.patch
