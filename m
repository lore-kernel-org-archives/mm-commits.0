From: akpm@linux-foundation.org
Subject: [folded] net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch removed from -mm tree
Date: Mon, 21 Dec 2009 16:36:29 -0800
Message-ID: <200912220036.nBM0aTW7005951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751262AbZLVAhm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 19:37:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, florian@openwrt.org, horms@verge.net.au, juliusv@google.com, kaber@trash.net, sshtylyov@ru.mvista.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix
has been removed from the -mm tree.  Its filename was
     net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch

This patch was dropped because it was folded into net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix
From: Andrew Morton <akpm@linux-foundation.org>

repair neighboring whitespace because the diff looked odd.

Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Julius Volz <juliusv@google.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/ipvs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/netfilter/ipvs/Kconfig~net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix net/netfilter/ipvs/Kconfig
--- a/net/netfilter/ipvs/Kconfig~net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix
+++ a/net/netfilter/ipvs/Kconfig
@@ -112,7 +112,7 @@ config	IP_VS_RR
 	  module, choose M here. If unsure, say N.
  
 config	IP_VS_WRR
-        tristate "weighted round-robin scheduling" 
+	tristate "weighted round-robin scheduling"
 	select GCD
 	---help---
 	  The weighted robin-robin scheduling algorithm directs network
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kfifo-move-struct-kfifo-in-place.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
net-sctp-socketc-squish-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
3x59x-fix-pci-resource-management.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
fs-ext4-superc-fix-printk-warning.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
char-cyclades-fix-compiler-warning.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

