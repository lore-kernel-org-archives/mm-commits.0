From: akpm@osdl.org
Subject: - log2-implement-a-general-integer-log2-facility-in-the-kernel-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 01:27:53 -0800
Message-ID: <200612080927.kB89RrVT014916@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41003 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425286AbWLHJ2C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 04:28:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     log2-implement-a-general-integer-log2-facility-in-the-kernel-fix
has been removed from the -mm tree.  Its filename was
     log2-implement-a-general-integer-log2-facility-in-the-kernel-fix.patch

This patch was dropped because it was folded into log2-implement-a-general-integer-log2-facility-in-the-kernel.patch

------------------------------------------------------
Subject: log2-implement-a-general-integer-log2-facility-in-the-kernel-fix
From: Andrew Morton <akpm@osdl.org>

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mmc/tifm_sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/tifm_sd.c~log2-implement-a-general-integer-log2-facility-in-the-kernel-fix drivers/mmc/tifm_sd.c
--- a/drivers/mmc/tifm_sd.c~log2-implement-a-general-integer-log2-facility-in-the-kernel-fix
+++ a/drivers/mmc/tifm_sd.c
@@ -387,7 +387,7 @@ static void tifm_sd_prepare_data(struct 
 
 	writel(TIFM_FIFO_INT_SETALL,
 		sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
-	writel(long_log2(cmd->data->blksz) - 2,
+	writel(ilog2(cmd->data->blksz) - 2,
 			sock->addr + SOCK_FIFO_PAGE_SIZE);
 	writel(TIFM_FIFO_ENABLE, sock->addr + SOCK_FIFO_CONTROL);
 	writel(TIFM_FIFO_INTMASK, sock->addr + SOCK_DMA_FIFO_INT_ENABLE_SET);
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel.patch
add-process_session-helper-routine-deprecate-old-field.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
drivers-isdn-handcrafted-min-max-macro-removal.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer.patch
gxfb-fixups-for-the-amd-geode-gx.patch
gxfb-support-flat-panel-timings.patch
gxfb-support-command-line-options.patch

