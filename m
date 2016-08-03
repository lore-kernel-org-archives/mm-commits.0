From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:22:40 -0700
Message-ID: <57a23670.NcNK4ukoHN1rRoZr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbcHCSW7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:22:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/thread_info.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/x86/include/asm/thread_info.h~linux-next-rejects arch/x86/include/asm/thread_info.h
--- a/arch/x86/include/asm/thread_info.h~linux-next-rejects
+++ a/arch/x86/include/asm/thread_info.h
@@ -263,6 +263,9 @@ static inline int arch_within_stack_fram
  * have to worry about atomic accesses.
  */
 #define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
+#ifdef CONFIG_COMPAT
+#define TS_I386_REGS_POKED	0x0004	/* regs poked by 32-bit ptracer */
+#endif
 
 #ifndef __ASSEMBLY__
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

