From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Wed, 27 Jul 2016 16:11:06 -0700
Message-ID: <57993f8a.QRXLNDZNTD+Fahl4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbcG0XLH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 19:11:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/bcm_defconfig |  141 -------------------------------
 mm/page_alloc.c                |    1 
 2 files changed, 1 insertion(+), 141 deletions(-)

diff -puN arch/arm/configs/bcm_defconfig~linux-next-rejects /dev/null
--- a/arch/arm/configs/bcm_defconfig
+++ /dev/null
@@ -1,141 +0,0 @@
-# CONFIG_LOCALVERSION_AUTO is not set
-# CONFIG_SWAP is not set
-CONFIG_SYSVIPC=y
-CONFIG_NO_HZ=y
-CONFIG_HIGH_RES_TIMERS=y
-CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_BSD_PROCESS_ACCT_V3=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_LOG_BUF_SHIFT=19
-CONFIG_CGROUPS=y
-CONFIG_CGROUP_FREEZER=y
-CONFIG_CGROUP_DEVICE=y
-CONFIG_CGROUP_CPUACCT=y
-CONFIG_CGROUP_SCHED=y
-CONFIG_BLK_CGROUP=y
-CONFIG_NAMESPACES=y
-CONFIG_BLK_DEV_INITRD=y
-CONFIG_SYSCTL_SYSCALL=y
-CONFIG_EMBEDDED=y
-# CONFIG_COMPAT_BRK is not set
-CONFIG_MODULES=y
-CONFIG_MODULE_UNLOAD=y
-# CONFIG_BLK_DEV_BSG is not set
-CONFIG_PARTITION_ADVANCED=y
-CONFIG_ARCH_BCM=y
-CONFIG_ARCH_BCM_21664=y
-CONFIG_ARCH_BCM_281XX=y
-CONFIG_ARM_THUMBEE=y
-CONFIG_SMP=y
-CONFIG_PREEMPT=y
-CONFIG_AEABI=y
-# CONFIG_COMPACTION is not set
-CONFIG_ZBOOT_ROM_TEXT=0x0
-CONFIG_ZBOOT_ROM_BSS=0x0
-CONFIG_CMDLINE="console=ttyS0,115200n8 mem=128M"
-CONFIG_CPU_IDLE=y
-CONFIG_VFP=y
-CONFIG_NEON=y
-# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
-CONFIG_PM=y
-CONFIG_NET=y
-CONFIG_PACKET=y
-CONFIG_PACKET_DIAG=y
-CONFIG_UNIX=y
-CONFIG_UNIX_DIAG=y
-CONFIG_NET_KEY=y
-CONFIG_INET=y
-CONFIG_IP_MULTICAST=y
-CONFIG_SYN_COOKIES=y
-CONFIG_TCP_MD5SIG=y
-CONFIG_IPV6=y
-CONFIG_DEVTMPFS=y
-CONFIG_DEVTMPFS_MOUNT=y
-CONFIG_PROC_DEVICETREE=y
-# CONFIG_BLK_DEV is not set
-CONFIG_SCSI=y
-CONFIG_BLK_DEV_SD=y
-CONFIG_CHR_DEV_SG=y
-CONFIG_SCSI_MULTI_LUN=y
-CONFIG_SCSI_SCAN_ASYNC=y
-CONFIG_INPUT_FF_MEMLESS=y
-CONFIG_INPUT_JOYDEV=y
-CONFIG_INPUT_EVDEV=y
-# CONFIG_KEYBOARD_ATKBD is not set
-# CONFIG_INPUT_MOUSE is not set
-CONFIG_INPUT_TOUCHSCREEN=y
-CONFIG_INPUT_MISC=y
-CONFIG_INPUT_UINPUT=y
-# CONFIG_SERIO is not set
-# CONFIG_LEGACY_PTYS is not set
-CONFIG_SERIAL_8250=y
-CONFIG_SERIAL_8250_CONSOLE=y
-CONFIG_SERIAL_8250_EXTENDED=y
-CONFIG_SERIAL_8250_MANY_PORTS=y
-CONFIG_SERIAL_8250_SHARE_IRQ=y
-CONFIG_SERIAL_8250_RSA=y
-CONFIG_SERIAL_8250_DW=y
-CONFIG_HW_RANDOM=y
-CONFIG_I2C=y
-CONFIG_I2C_CHARDEV=y
-# CONFIG_HWMON is not set
-CONFIG_MFD_BCM590XX=y
-CONFIG_REGULATOR=y
-CONFIG_REGULATOR_FIXED_VOLTAGE=y
-CONFIG_REGULATOR_USERSPACE_CONSUMER=y
-CONFIG_REGULATOR_BCM590XX=y
-
-CONFIG_VIDEO_OUTPUT_CONTROL=y
-CONFIG_FB=y
-CONFIG_BACKLIGHT_LCD_SUPPORT=y
-CONFIG_LCD_CLASS_DEVICE=y
-CONFIG_BACKLIGHT_CLASS_DEVICE=y
-CONFIG_BACKLIGHT_PWM=y
-# CONFIG_USB_SUPPORT is not set
-CONFIG_MMC=y
-CONFIG_MMC_BLOCK_MINORS=32
-CONFIG_MMC_TEST=y
-CONFIG_MMC_SDHCI=y
-CONFIG_MMC_SDHCI_PLTFM=y
-CONFIG_MMC_SDHCI_BCM_KONA=y
-CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
-CONFIG_LEDS_TRIGGERS=y
-CONFIG_LEDS_TRIGGER_TIMER=y
-CONFIG_LEDS_TRIGGER_HEARTBEAT=y
-CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
-CONFIG_PWM=y
-CONFIG_PWM_BCM_KONA=y
-CONFIG_EXT4_FS=y
-CONFIG_EXT4_FS_POSIX_ACL=y
-CONFIG_EXT4_FS_SECURITY=y
-CONFIG_AUTOFS4_FS=y
-CONFIG_FUSE_FS=y
-CONFIG_MSDOS_FS=y
-CONFIG_VFAT_FS=y
-CONFIG_TMPFS=y
-CONFIG_TMPFS_POSIX_ACL=y
-CONFIG_CONFIGFS_FS=y
-# CONFIG_MISC_FILESYSTEMS is not set
-CONFIG_NLS_CODEPAGE_437=y
-CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=1
-CONFIG_DEBUG_INFO=y
-CONFIG_DEBUG_FS=y
-CONFIG_MAGIC_SYSRQ=y
-CONFIG_DETECT_HUNG_TASK=y
-CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=110
-CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
-# CONFIG_FTRACE is not set
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
-CONFIG_CRC_CCITT=y
-CONFIG_CRC_T10DIF=y
-CONFIG_CRC_ITU_T=y
-CONFIG_CRC7=y
-CONFIG_XZ_DEC=y
-CONFIG_AVERAGE=y
-CONFIG_PINCTRL_BCM281XX=y
-CONFIG_WATCHDOG=y
-CONFIG_BCM_KONA_WDT=y
-CONFIG_BCM_KONA_WDT_DEBUG=y
diff -puN mm/page_alloc.c~linux-next-rejects mm/page_alloc.c
--- a/mm/page_alloc.c~linux-next-rejects
+++ a/mm/page_alloc.c
@@ -38,6 +38,7 @@
 #include <linux/sysctl.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
+#include <linux/random.h>
 #include <linux/memory_hotplug.h>
 #include <linux/nodemask.h>
 #include <linux/vmalloc.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler-fix.patch
mm.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
mm-bail-out-in-shrin_inactive_list-fix.patch
revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes.patch
mm-optimize-copy_page_to-from_iter_iovec-fix.patch
mm-optimize-copy_page_to-from_iter_iovec-fix-fix.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
kexec-add-restriction-on-kexec_load-segment-sizes-fix.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

