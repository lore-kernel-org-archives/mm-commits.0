From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 08 Nov 2010 11:57:21 -0800
Message-ID: <201011081959.oA8JxSIg005104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754375Ab0KHT75 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 14:59:57 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id oA8JxSxC019208
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 8 Nov 2010 11:59:29 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-msm/include/mach/debug-macro.S |    4 ----
 drivers/usb/host/Kconfig                     |    5 -----
 2 files changed, 9 deletions(-)

diff -puN arch/arm/mach-msm/include/mach/debug-macro.S~linux-next-git-rejects arch/arm/mach-msm/include/mach/debug-macro.S
--- a/arch/arm/mach-msm/include/mach/debug-macro.S~linux-next-git-rejects
+++ a/arch/arm/mach-msm/include/mach/debug-macro.S
@@ -37,13 +37,9 @@
 	beq	1001b
 	.endm
 #else
-<<<<<<< HEAD
 	.macro  addruart, rp, rv
 	mov	\rv, #0xff000000
 	orr	\rv, \rv, #0x00f00000
-=======
-	.macro	addruart, rp, rv
->>>>>>> FETCH_HEAD
 	.endm
 
 	.macro	senduart,rd,rx
diff -puN drivers/usb/host/Kconfig~linux-next-git-rejects drivers/usb/host/Kconfig
--- a/drivers/usb/host/Kconfig~linux-next-git-rejects
+++ a/drivers/usb/host/Kconfig
@@ -93,14 +93,9 @@ config USB_EHCI_TT_NEWSCHED
 
 config USB_EHCI_BIG_ENDIAN_MMIO
 	bool
-<<<<<<< HEAD
 	depends on USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || \
 				    ARCH_IXP4XX || XPS_USB_HCD_XILINX || \
 				    PPC_MPC512x || CPU_CAVIUM_OCTEON)
-=======
-	depends on USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || \
-				    XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OCTEON)
->>>>>>> FETCH_HEAD
 	default y
 
 config USB_EHCI_BIG_ENDIAN_DESC
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hpet-factor-timer-allocate-from-open.patch
atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-misc-isl29020c-dont-ignore-the-i2c_smbus_read_byte_data-return-value.patch
drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-add-led-trigger-for-input-subsystem-led-events.patch
backlight-add-low-threshold-to-pwm-backlight.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
sync_inode_metadata-fix-comment.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

