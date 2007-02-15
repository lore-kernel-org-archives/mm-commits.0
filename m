From: akpm@linux-foundation.org
Subject: - x86_64-i386-compat-wire-up-sys_epoll_pwait.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:52:03 -0800
Message-ID: <200702150852.l1F8q3lT025342@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40484 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965306AbXBOIzZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:55:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, ak@muc.de, mm-commits@vger.kernel.org


The patch titled
     x86_64 i386 compat: wire up sys_epoll_pwait()
has been removed from the -mm tree.  Its filename was
     x86_64-i386-compat-wire-up-sys_epoll_pwait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 i386 compat: wire up sys_epoll_pwait()
From: Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32entry.S |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86_64/ia32/ia32entry.S~x86_64-i386-compat-wire-up-sys_epoll_pwait arch/x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~x86_64-i386-compat-wire-up-sys_epoll_pwait
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -730,4 +730,5 @@ ia32_sys_call_table:
 	.quad compat_sys_vmsplice
 	.quad compat_sys_move_pages
 	.quad sys_getcpu
+	.quad sys_epoll_pwait
 ia32_syscall_end:		
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
git-mips.patch
mips-remove-smp_tune_scheduling.patch
simplify-the-stacktrace-code.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
clocksource-fixup-is_continous-changes-on-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
