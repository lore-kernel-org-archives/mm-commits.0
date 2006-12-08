From: akpm@osdl.org
Subject: - log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:50:50 -0800
Message-ID: <200612080850.kB88ooWH013936@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37186 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425203AbWLHIvL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:51:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, benh@kernel.crashing.org, dhowells@redhat.com, paulus@samba.org, wojtekka@toxygen.net, mm-commits@vger.kernel.org


The patch titled
     log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix
has been removed from the -mm tree.  Its filename was
     log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch

This patch was dropped because it was folded into log2-implement-a-general-integer-log2-facility-in-the-kernel.patch

------------------------------------------------------
Subject: log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix
From: Andrew Morton <akpm@osdl.org>

Cc: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Wojtek Kaniewski <wojtekka@toxygen.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ppc/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ppc/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix
+++ a/arch/ppc/Kconfig
@@ -21,7 +21,7 @@ config RWSEM_XCHGADD_ALGORITHM
 
 config ARCH_HAS_ILOG2_U32
 	bool
-	default n
+	default y
 
 config ARCH_HAS_ILOG2_U64
 	bool
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch
add-process_session-helper-routine-deprecate-old-field-tidy.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-irda-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

