From: akpm@linux-foundation.org
Subject: [folded-merged]
 sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch removed from -mm tree
Date: Tue, 22 Mar 2016 13:53:47 -0700
Message-ID: <56f1b0db.cxOhSAQibqDYIXd8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbcCVUxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 16:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, luto@kernel.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix
has been removed from the -mm tree.  Its filename was
     sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch

This patch was dropped because it was folded into sparc-compat-provide-an-accurate-in_compat_syscall-implementation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix

update comment, per Andy

Cc: Andy Lutomirski <luto@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/compat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sparc/include/asm/compat.h~sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix arch/sparc/include/asm/compat.h
--- a/arch/sparc/include/asm/compat.h~sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix
+++ a/arch/sparc/include/asm/compat.h
@@ -309,7 +309,7 @@ static inline int is_compat_task(void)
 
 static inline bool in_compat_syscall(void)
 {
-	/* Check if this is LINUX_32BIT_SYSCALL_TRAP */
+	/* Vector 0x110 is LINUX_32BIT_SYSCALL_TRAP */
 	return pt_regs_trap_type(current_pt_regs()) == 0x110;
 }
 #define in_compat_syscall in_compat_syscall
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

sparc-compat-provide-an-accurate-in_compat_syscall-implementation.patch
rapidio-add-mport-char-device-driver-fix.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
kernel-add-kcov-code-coverage-makefile-tweaks.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch

