From: akpm@linux-foundation.org
Subject: + x86_64-i386-compat-wire-up-sys_epoll_pwait.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:40:28 -0800
Message-ID: <200702130540.l1D5eSo6022814@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55401 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161086AbXBMFnw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:43:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, ak@muc.de


The patch titled
     x86_64 i386 compat: wire up sys_epoll_pwait()
has been added to the -mm tree.  Its filename is
     x86_64-i386-compat-wire-up-sys_epoll_pwait.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch
x86_64-i386-compat-wire-up-sys_epoll_pwait.patch
simplify-the-stacktrace-code.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
clocksource-fixup-is_continous-changes-on-mips.patch
sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
sysctl-mips-au1000-remove-sys_sysctl-support.patch
sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
