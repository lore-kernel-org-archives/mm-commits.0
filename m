From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 08 Feb 2016 16:39:41 -0800
Message-ID: <56b9354d.HDvKZx26qU85i+Y0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452AbcBIAjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 19:39:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/boot/dts/brcm/bcm6328.dtsi |    4 -
 arch/mips/boot/dts/brcm/bcm7125.dtsi |    4 -
 arch/mips/boot/dts/brcm/bcm7346.dtsi |    4 -
 arch/mips/boot/dts/brcm/bcm7358.dtsi |    4 -
 arch/mips/boot/dts/brcm/bcm7360.dtsi |    4 -
 arch/mips/boot/dts/brcm/bcm7362.dtsi |    4 -
 arch/mips/boot/dts/brcm/bcm7420.dtsi |    4 -
 arch/mips/boot/dts/brcm/bcm7425.dtsi |    4 -
 arch/mips/boot/dts/brcm/bcm7435.dtsi |    4 -
 drivers/base/regmap/regmap-mmio.c    |   58 -------------------------
 10 files changed, 94 deletions(-)

diff -puN arch/mips/boot/dts/brcm/bcm6328.dtsi~linux-next-git-rejects arch/mips/boot/dts/brcm/bcm6328.dtsi
--- a/arch/mips/boot/dts/brcm/bcm6328.dtsi~linux-next-git-rejects
+++ a/arch/mips/boot/dts/brcm/bcm6328.dtsi
@@ -74,11 +74,7 @@
 		timer: timer@10000040 {
 			compatible = "syscon";
 			reg = <0x10000040 0x2c>;
-<<<<<<< HEAD
-			little-endian;
-=======
 			native-endian;
->>>>>>> linux-next/akpm-base
 		};
 
 		reboot {
diff -puN arch/mips/boot/dts/brcm/bcm7125.dtsi~linux-next-git-rejects arch/mips/boot/dts/brcm/bcm7125.dtsi
--- a/arch/mips/boot/dts/brcm/bcm7125.dtsi~linux-next-git-rejects
+++ a/arch/mips/boot/dts/brcm/bcm7125.dtsi
@@ -98,11 +98,7 @@
 		sun_top_ctrl: syscon@404000 {
 			compatible = "brcm,bcm7125-sun-top-ctrl", "syscon";
 			reg = <0x404000 0x60c>;
-<<<<<<< HEAD
-			little-endian;
-=======
 			native-endian;
->>>>>>> linux-next/akpm-base
 		};
 
 		reboot {
diff -puN arch/mips/boot/dts/brcm/bcm7346.dtsi~linux-next-git-rejects arch/mips/boot/dts/brcm/bcm7346.dtsi
--- a/arch/mips/boot/dts/brcm/bcm7346.dtsi~linux-next-git-rejects
+++ a/arch/mips/boot/dts/brcm/bcm7346.dtsi
@@ -118,11 +118,7 @@
 		sun_top_ctrl: syscon@404000 {
 			compatible = "brcm,bcm7346-sun-top-ctrl", "syscon";
 			reg = <0x404000 0x51c>;
-<<<<<<< HEAD
-			little-endian;
-=======
 			native-endian;
->>>>>>> linux-next/akpm-base
 		};
 
 		reboot {
diff -puN arch/mips/boot/dts/brcm/bcm7358.dtsi~linux-next-git-rejects arch/mips/boot/dts/brcm/bcm7358.dtsi
--- a/arch/mips/boot/dts/brcm/bcm7358.dtsi~linux-next-git-rejects
+++ a/arch/mips/boot/dts/brcm/bcm7358.dtsi
@@ -112,11 +112,7 @@
 		sun_top_ctrl: syscon@404000 {
 			compatible = "brcm,bcm7358-sun-top-ctrl", "syscon";
 			reg = <0x404000 0x51c>;
-<<<<<<< HEAD
-			little-endian;
-=======
 			native-endian;
->>>>>>> linux-next/akpm-base
 		};
 
 		reboot {
diff -puN arch/mips/boot/dts/brcm/bcm7360.dtsi~linux-next-git-rejects arch/mips/boot/dts/brcm/bcm7360.dtsi
--- a/arch/mips/boot/dts/brcm/bcm7360.dtsi~linux-next-git-rejects
+++ a/arch/mips/boot/dts/brcm/bcm7360.dtsi
@@ -112,11 +112,7 @@
 		sun_top_ctrl: syscon@404000 {
 			compatible = "brcm,bcm7360-sun-top-ctrl", "syscon";
 			reg = <0x404000 0x51c>;
-<<<<<<< HEAD
-			little-endian;
-=======
 			native-endian;
->>>>>>> linux-next/akpm-base
 		};
 
 		reboot {
diff -puN arch/mips/boot/dts/brcm/bcm7362.dtsi~linux-next-git-rejects arch/mips/boot/dts/brcm/bcm7362.dtsi
--- a/arch/mips/boot/dts/brcm/bcm7362.dtsi~linux-next-git-rejects
+++ a/arch/mips/boot/dts/brcm/bcm7362.dtsi
@@ -118,11 +118,7 @@
 		sun_top_ctrl: syscon@404000 {
 			compatible = "brcm,bcm7362-sun-top-ctrl", "syscon";
 			reg = <0x404000 0x51c>;
-<<<<<<< HEAD
-			little-endian;
-=======
 			native-endian;
->>>>>>> linux-next/akpm-base
 		};
 
 		reboot {
diff -puN arch/mips/boot/dts/brcm/bcm7420.dtsi~linux-next-git-rejects arch/mips/boot/dts/brcm/bcm7420.dtsi
--- a/arch/mips/boot/dts/brcm/bcm7420.dtsi~linux-next-git-rejects
+++ a/arch/mips/boot/dts/brcm/bcm7420.dtsi
@@ -99,11 +99,7 @@
 		sun_top_ctrl: syscon@404000 {
 			compatible = "brcm,bcm7420-sun-top-ctrl", "syscon";
 			reg = <0x404000 0x60c>;
-<<<<<<< HEAD
-			little-endian;
-=======
 			native-endian;
->>>>>>> linux-next/akpm-base
 		};
 
 		reboot {
diff -puN arch/mips/boot/dts/brcm/bcm7425.dtsi~linux-next-git-rejects arch/mips/boot/dts/brcm/bcm7425.dtsi
--- a/arch/mips/boot/dts/brcm/bcm7425.dtsi~linux-next-git-rejects
+++ a/arch/mips/boot/dts/brcm/bcm7425.dtsi
@@ -100,11 +100,7 @@
 		sun_top_ctrl: syscon@404000 {
 			compatible = "brcm,bcm7425-sun-top-ctrl", "syscon";
 			reg = <0x404000 0x51c>;
-<<<<<<< HEAD
-			little-endian;
-=======
 			native-endian;
->>>>>>> linux-next/akpm-base
 		};
 
 		reboot {
diff -puN arch/mips/boot/dts/brcm/bcm7435.dtsi~linux-next-git-rejects arch/mips/boot/dts/brcm/bcm7435.dtsi
--- a/arch/mips/boot/dts/brcm/bcm7435.dtsi~linux-next-git-rejects
+++ a/arch/mips/boot/dts/brcm/bcm7435.dtsi
@@ -114,11 +114,7 @@
 		sun_top_ctrl: syscon@404000 {
 			compatible = "brcm,bcm7425-sun-top-ctrl", "syscon";
 			reg = <0x404000 0x51c>;
-<<<<<<< HEAD
-			little-endian;
-=======
 			native-endian;
->>>>>>> linux-next/akpm-base
 		};
 
 		reboot {
diff -puN drivers/base/regmap/regmap-mmio.c~linux-next-git-rejects drivers/base/regmap/regmap-mmio.c
--- a/drivers/base/regmap/regmap-mmio.c~linux-next-git-rejects
+++ a/drivers/base/regmap/regmap-mmio.c
@@ -131,36 +131,7 @@ static int regmap_mmio_write(void *conte
 			return ret;
 	}
 
-<<<<<<< HEAD
-	offset = regmap_mmio_get_offset(reg, reg_size);
-
-	while (val_size) {
-		switch (ctx->val_bytes) {
-		case 1:
-			writeb(*(u8 *)val, ctx->regs + offset);
-			break;
-		case 2:
-			writew(*(u16 *)val, ctx->regs + offset);
-			break;
-		case 4:
-			writel(*(u32 *)val, ctx->regs + offset);
-			break;
-#ifdef CONFIG_64BIT
-		case 8:
-			writeq(*(u64 *)val, ctx->regs + offset);
-			break;
-#endif
-		default:
-			/* Should be caught by regmap_mmio_check_config */
-			BUG();
-		}
-		val_size -= ctx->val_bytes;
-		val += ctx->val_bytes;
-		offset += ctx->val_bytes;
-	}
-=======
 	ctx->reg_write(ctx, reg, val);
->>>>>>> linux-next/akpm-base
 
 	if (!IS_ERR(ctx->clk))
 		clk_disable(ctx->clk);
@@ -217,36 +188,7 @@ static int regmap_mmio_read(void *contex
 			return ret;
 	}
 
-<<<<<<< HEAD
-	offset = regmap_mmio_get_offset(reg, reg_size);
-
-	while (val_size) {
-		switch (ctx->val_bytes) {
-		case 1:
-			*(u8 *)val = readb(ctx->regs + offset);
-			break;
-		case 2:
-			*(u16 *)val = readw(ctx->regs + offset);
-			break;
-		case 4:
-			*(u32 *)val = readl(ctx->regs + offset);
-			break;
-#ifdef CONFIG_64BIT
-		case 8:
-			*(u64 *)val = readq(ctx->regs + offset);
-			break;
-#endif
-		default:
-			/* Should be caught by regmap_mmio_check_config */
-			BUG();
-		}
-		val_size -= ctx->val_bytes;
-		val += ctx->val_bytes;
-		offset += ctx->val_bytes;
-	}
-=======
 	*val = ctx->reg_read(ctx, reg);
->>>>>>> linux-next/akpm-base
 
 	if (!IS_ERR(ctx->clk))
 		clk_disable(ctx->clk);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
vsprintf-kptr_restrict-is-okay-in-irq-when-2-checkpatch-fixes.patch
kernel-locking-lockdepc-convert-hash-tables-to-hlists.patch
kernel-locking-lockdepc-convert-hash-tables-to-hlists-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
sound-query-dynamic-debug_pagealloc-setting-fix.patch
mm-config_nr_zones_extended-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-global-inbound-port-write-interfaces-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

