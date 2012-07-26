From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 26 Jul 2012 10:33:11 -0700
Message-ID: <20120726173313.2FD2C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:64155 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650Ab2GZRdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2012 13:33:16 -0400
Received: by lagr15 with SMTP id r15so99317lag.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Jul 2012 10:33:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/highbank.dts |    6 ------
 drivers/dma/Kconfig            |    3 ---
 drivers/dma/Makefile           |    3 ---
 include/linux/pci_regs.h       |    3 ---
 include/scsi/libsas.h          |    3 ---
 include/scsi/sas_ata.h         |    3 ---
 include/scsi/scsi_device.h     |    3 ---
 7 files changed, 24 deletions(-)

diff -puN arch/arm/boot/dts/highbank.dts~linux-next-git-rejects arch/arm/boot/dts/highbank.dts
--- a/arch/arm/boot/dts/highbank.dts~linux-next-git-rejects
+++ a/arch/arm/boot/dts/highbank.dts
@@ -128,15 +128,12 @@
 			reg = <0xffe0e000 0x1000>;
 			interrupts = <0 90 4>;
 			clocks = <&eclk>;
-<<<<<<< HEAD
-=======
 		};
 
 		memory-controller@fff00000 {
 			compatible = "calxeda,hb-ddr-ctrl";
 			reg = <0xfff00000 0x1000>;
 			interrupts = <0 91 4>;
->>>>>>> linux-next/akpm-base
 		};
 
 		ipc@fff20000 {
@@ -282,15 +279,12 @@
 					clock-frequency = <150000000>;
 				};
 			};
-<<<<<<< HEAD
-=======
 		};
 
 		sregs@fff3c200 {
 			compatible = "calxeda,hb-sregs-l2-ecc";
 			reg = <0xfff3c200 0x100>;
 			interrupts = <0 71 4  0 72 4>;
->>>>>>> linux-next/akpm-base
 		};
 
 		dma@fff3d000 {
diff -puN drivers/dma/Kconfig~linux-next-git-rejects drivers/dma/Kconfig
--- a/drivers/dma/Kconfig~linux-next-git-rejects
+++ a/drivers/dma/Kconfig
@@ -276,15 +276,12 @@ config DMA_SA11X0
 	  SA-1110 SoCs.  This DMA engine can only be used with on-chip
 	  devices.
 
-<<<<<<< HEAD
-=======
 config DMA_OMAP
 	tristate "OMAP DMA support"
 	depends on ARCH_OMAP
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 
->>>>>>> linux-next/akpm-base
 config MMP_TDMA
 	bool "MMP Two-Channel DMA support"
 	depends on ARCH_MMP
diff -puN drivers/dma/Makefile~linux-next-git-rejects drivers/dma/Makefile
--- a/drivers/dma/Makefile~linux-next-git-rejects
+++ a/drivers/dma/Makefile
@@ -30,8 +30,5 @@ obj-$(CONFIG_PCH_DMA) += pch_dma.o
 obj-$(CONFIG_AMBA_PL08X) += amba-pl08x.o
 obj-$(CONFIG_EP93XX_DMA) += ep93xx_dma.o
 obj-$(CONFIG_DMA_SA11X0) += sa11x0-dma.o
-<<<<<<< HEAD
-=======
 obj-$(CONFIG_DMA_OMAP) += omap-dma.o
->>>>>>> linux-next/akpm-base
 obj-$(CONFIG_MMP_TDMA) += mmp_tdma.o
diff -puN include/linux/pci_regs.h~linux-next-git-rejects include/linux/pci_regs.h
--- a/include/linux/pci_regs.h~linux-next-git-rejects
+++ a/include/linux/pci_regs.h
@@ -543,14 +543,11 @@
 #define  PCI_EXP_OBFF_MSGB_EN	0x4000	/* OBFF enable with Message type B */
 #define  PCI_EXP_OBFF_WAKE_EN	0x6000	/* OBFF using WAKE# signaling */
 #define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	44	/* v2 endpoints end here */
-<<<<<<< HEAD
-=======
 #define PCI_EXP_LNKCAP2		44	/* Link Capability 2 */
 #define  PCI_EXP_LNKCAP2_SLS_2_5GB 0x01	/* Current Link Speed 2.5GT/s */
 #define  PCI_EXP_LNKCAP2_SLS_5_0GB 0x02	/* Current Link Speed 5.0GT/s */
 #define  PCI_EXP_LNKCAP2_SLS_8_0GB 0x04	/* Current Link Speed 8.0GT/s */
 #define  PCI_EXP_LNKCAP2_CROSSLINK 0x100 /* Crosslink supported */
->>>>>>> linux-next/akpm-base
 #define PCI_EXP_LNKCTL2		48	/* Link Control 2 */
 #define PCI_EXP_SLTCTL2		56	/* Slot Control 2 */
 
diff -puN include/scsi/libsas.h~linux-next-git-rejects include/scsi/libsas.h
--- a/include/scsi/libsas.h~linux-next-git-rejects
+++ a/include/scsi/libsas.h
@@ -172,10 +172,7 @@ struct sata_device {
         enum   ata_command_set command_set;
         struct smp_resp        rps_resp; /* report_phy_sata_resp */
         u8     port_no;        /* port number, if this is a PM (Port) */
-<<<<<<< HEAD
-=======
 	int    pm_result;
->>>>>>> linux-next/akpm-base
 
 	struct ata_port *ap;
 	struct ata_host ata_host;
diff -puN include/scsi/sas_ata.h~linux-next-git-rejects include/scsi/sas_ata.h
--- a/include/scsi/sas_ata.h~linux-next-git-rejects
+++ a/include/scsi/sas_ata.h
@@ -45,11 +45,8 @@ void sas_ata_eh(struct Scsi_Host *shost,
 void sas_ata_schedule_reset(struct domain_device *dev);
 void sas_ata_wait_eh(struct domain_device *dev);
 void sas_probe_sata(struct asd_sas_port *port);
-<<<<<<< HEAD
-=======
 void sas_suspend_sata(struct asd_sas_port *port);
 void sas_resume_sata(struct asd_sas_port *port);
->>>>>>> linux-next/akpm-base
 void sas_ata_end_eh(struct ata_port *ap);
 #else
 
diff -puN include/scsi/scsi_device.h~linux-next-git-rejects include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h~linux-next-git-rejects
+++ a/include/scsi/scsi_device.h
@@ -154,11 +154,8 @@ struct scsi_device {
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
-<<<<<<< HEAD
-=======
 	unsigned can_power_off:1; /* Device supports runtime power off */
 	unsigned wakeup_by_user:1;	/* user wakes up the ODD */
->>>>>>> linux-next/akpm-base
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
memcg-oom-provide-more-info-while-memcg-oom-happening-checkpatch-fixes.patch
memcg-oom-clarify-some-oom-dump-messages-checkpatch-fixes.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
posix_typesh-cleanup-stale-__nfdbits-and-related-definitions-checkpatch-fixes.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
rbtree-performance-and-correctness-test-fix.patch
firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
minixfs-fix-block-limit-check-fix.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

