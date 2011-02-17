From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects-git-rejects.patch removed from -mm tree
Date: Thu, 17 Feb 2011 12:45:47 -0800
Message-ID: <201102172045.p1HKjllZ010859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757977Ab1BQUqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Feb 2011 15:46:19 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p1HKjmnd018775
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2011 12:45:48 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-rejects-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-rejects-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/68328serial.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff -puN drivers/tty/serial/68328serial.c~linux-next-rejects-git-rejects drivers/tty/serial/68328serial.c
--- a/drivers/tty/serial/68328serial.c~linux-next-rejects-git-rejects
+++ a/drivers/tty/serial/68328serial.c
@@ -393,31 +393,6 @@ static void do_softint(struct work_struc
 #endif   
 }
 
-<<<<<<< HEAD
-/*
- * This routine is called from the scheduler tqueue when the interrupt
- * routine has signalled that a hangup has occurred.  The path of
- * hangup processing is:
- *
- * 	serial interrupt routine -> (scheduler tqueue) ->
- * 	do_serial_hangup() -> tty->hangup() -> rs_hangup()
- * 
- */
-static void do_serial_hangup(struct work_struct *work)
-{
-	struct m68k_serial	*info = container_of(work, struct m68k_serial, tqueue_hangup);
-	struct tty_struct	*tty;
-	
-	tty = info->tty;
-	if (!tty)
-		return;
-
-	tty_hangup(tty);
-}
-
-
-=======
->>>>>>> FETCH_HEAD
 static int startup(struct m68k_serial * info)
 {
 	m68328_uart *uart = &uart_addr[info->line];
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-platform-x86-intel_pmic_gpioc-fix-big-mess-with-i386-allmodconfig.patch
drivers-platform-x86-makefile-drivers-platform-x86-intel_mid_thermalc-doesnt-exist.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

