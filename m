From: akpm@linux-foundation.org
Subject: [withdrawn] lib-switch-config_printk_time-to-int.patch removed
 from -mm tree
Date: Wed, 27 Jul 2016 16:08:19 -0700
Message-ID: <57993ee3.bf5Bgkle3a6fgSx+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163142AbcG0XIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 19:08:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, baolin.wang@linaro.org, gregkh@linuxfoundation.org, joe@perches.com, john.stultz@linaro.org, pang.xunlei@linaro.org, penguin-kernel@I-love.SAKURA.ne.jp, peter@hurleysoftware.com, pmladek@suse.com, pmladek@suse.cz, tglx@linutronix.de, tj@kernel.org, vvs@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib, switch CONFIG_PRINTK_TIME to int
has been removed from the -mm tree.  Its filename was
     lib-switch-config_printk_time-to-int.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Prarit Bhargava <prarit@redhat.com>
Subject: lib, switch CONFIG_PRINTK_TIME to int

CONFIG_PRINTK_TIME is a bool and in order to add timestamp options for
the monotonic and real time clock it must be expanded to an int.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Xunlei Pang <pang.xunlei@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Baolin Wang <baolin.wang@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt                      |    2 
 arch/arm/configs/axm55xx_defconfig                       |    2 
 arch/arm/configs/bcm2835_defconfig                       |    2 
 arch/arm/configs/bcm_defconfig                           |    2 
 arch/arm/configs/colibri_pxa270_defconfig                |    2 
 arch/arm/configs/colibri_pxa300_defconfig                |    2 
 arch/arm/configs/dove_defconfig                          |    2 
 arch/arm/configs/efm32_defconfig                         |    2 
 arch/arm/configs/exynos_defconfig                        |    2 
 arch/arm/configs/ezx_defconfig                           |    2 
 arch/arm/configs/h5000_defconfig                         |    2 
 arch/arm/configs/hisi_defconfig                          |    2 
 arch/arm/configs/imote2_defconfig                        |    2 
 arch/arm/configs/imx_v6_v7_defconfig                     |    2 
 arch/arm/configs/keystone_defconfig                      |    2 
 arch/arm/configs/lpc18xx_defconfig                       |    2 
 arch/arm/configs/magician_defconfig                      |    2 
 arch/arm/configs/mmp2_defconfig                          |    2 
 arch/arm/configs/moxart_defconfig                        |    2 
 arch/arm/configs/multi_v7_defconfig                      |    2 
 arch/arm/configs/mvebu_v7_defconfig                      |    2 
 arch/arm/configs/mxs_defconfig                           |    2 
 arch/arm/configs/omap2plus_defconfig                     |    2 
 arch/arm/configs/pxa168_defconfig                        |    2 
 arch/arm/configs/pxa3xx_defconfig                        |    2 
 arch/arm/configs/pxa910_defconfig                        |    2 
 arch/arm/configs/pxa_defconfig                           |    2 
 arch/arm/configs/qcom_defconfig                          |    2 
 arch/arm/configs/raumfeld_defconfig                      |    2 
 arch/arm/configs/shmobile_defconfig                      |    2 
 arch/arm/configs/socfpga_defconfig                       |    2 
 arch/arm/configs/stm32_defconfig                         |    2 
 arch/arm/configs/sunxi_defconfig                         |    2 
 arch/arm/configs/tegra_defconfig                         |    2 
 arch/arm/configs/u300_defconfig                          |    2 
 arch/arm/configs/u8500_defconfig                         |    2 
 arch/arm/configs/vt8500_v6_v7_defconfig                  |    2 
 arch/arm/configs/xcep_defconfig                          |    2 
 arch/arm/configs/zx_defconfig                            |    2 
 arch/arm64/configs/defconfig                             |    2 
 arch/mips/configs/bcm47xx_defconfig                      |    2 
 arch/mips/configs/bmips_be_defconfig                     |    2 
 arch/mips/configs/bmips_stb_defconfig                    |    2 
 arch/mips/configs/ci20_defconfig                         |    2 
 arch/mips/configs/lemote2f_defconfig                     |    2 
 arch/mips/configs/loongson3_defconfig                    |    2 
 arch/mips/configs/nlm_xlp_defconfig                      |    2 
 arch/mips/configs/nlm_xlr_defconfig                      |    2 
 arch/mips/configs/pistachio_defconfig                    |    2 
 arch/mips/configs/qi_lb60_defconfig                      |    2 
 arch/mips/configs/rt305x_defconfig                       |    2 
 arch/mips/configs/xway_defconfig                         |    2 
 arch/parisc/configs/generic-64bit_defconfig              |    2 
 arch/powerpc/configs/40x/virtex_defconfig                |    2 
 arch/powerpc/configs/44x/virtex5_defconfig               |    2 
 arch/powerpc/configs/44x/warp_defconfig                  |    2 
 arch/powerpc/configs/52xx/cm5200_defconfig               |    2 
 arch/powerpc/configs/52xx/lite5200b_defconfig            |    2 
 arch/powerpc/configs/52xx/motionpro_defconfig            |    2 
 arch/powerpc/configs/52xx/tqm5200_defconfig              |    2 
 arch/powerpc/configs/gamecube_defconfig                  |    2 
 arch/powerpc/configs/mpc5200_defconfig                   |    2 
 arch/powerpc/configs/pasemi_defconfig                    |    2 
 arch/powerpc/configs/wii_defconfig                       |    2 
 arch/s390/configs/default_defconfig                      |    2 
 arch/s390/configs/gcov_defconfig                         |    2 
 arch/s390/configs/performance_defconfig                  |    2 
 arch/s390/configs/zfcpdump_defconfig                     |    2 
 arch/sh/configs/edosk7760_defconfig                      |    2 
 arch/sh/configs/sdk7786_defconfig                        |    2 
 arch/sh/configs/se7722_defconfig                         |    2 
 arch/sh/configs/sh7785lcr_32bit_defconfig                |    2 
 arch/sh/configs/urquell_defconfig                        |    2 
 arch/sparc/configs/sparc64_defconfig                     |    2 
 arch/x86/configs/i386_defconfig                          |    2 
 arch/x86/configs/x86_64_defconfig                        |    2 
 arch/xtensa/configs/audio_kc705_defconfig                |    2 
 arch/xtensa/configs/generic_kc705_defconfig              |    2 
 arch/xtensa/configs/nommu_kc705_defconfig                |    2 
 arch/xtensa/configs/smp_lx200_defconfig                  |    2 
 kernel/printk/printk.c                                   |   41 +++++++++-
 lib/Kconfig.debug                                        |    7 +
 tools/testing/selftests/rcutorture/configs/lock/CFcommon |    2 
 tools/testing/selftests/rcutorture/configs/rcu/CFcommon  |    2 
 84 files changed, 126 insertions(+), 86 deletions(-)

diff -puN Documentation/kernel-parameters.txt~lib-switch-config_printk_time-to-int Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~lib-switch-config_printk_time-to-int
+++ a/Documentation/kernel-parameters.txt
@@ -3164,7 +3164,7 @@ bytes respectively. Such letter suffixes
 			Default: ratelimit
 
 	printk.time=	Show timing data prefixed to each printk message line
-			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
+			Format: <string>  (1/Y/y=enable, 0/N/n=disable)
 
 	processor.max_cstate=	[HW,ACPI]
 			Limit processor to maximum C-state
diff -puN arch/arm/configs/axm55xx_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/axm55xx_defconfig
--- a/arch/arm/configs/axm55xx_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/axm55xx_defconfig
@@ -232,7 +232,7 @@ CONFIG_NFS_FSCACHE=y
 CONFIG_SUNRPC_DEBUG=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
diff -puN arch/arm/configs/bcm2835_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/bcm2835_defconfig
--- a/arch/arm/configs/bcm2835_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/bcm2835_defconfig
@@ -130,7 +130,7 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ASCII=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_BOOT_PRINTK_DELAY=y
 CONFIG_DYNAMIC_DEBUG=y
 CONFIG_DEBUG_INFO=y
diff -puN arch/arm/configs/bcm_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/bcm_defconfig
--- a/arch/arm/configs/bcm_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/bcm_defconfig
@@ -120,7 +120,7 @@ CONFIG_CONFIGFS_FS=y
 # CONFIG_MISC_FILESYSTEMS is not set
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
diff -puN arch/arm/configs/colibri_pxa270_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/colibri_pxa270_defconfig
--- a/arch/arm/configs/colibri_pxa270_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/colibri_pxa270_defconfig
@@ -156,7 +156,7 @@ CONFIG_NLS_ASCII=y
 CONFIG_NLS_ISO8859_1=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_UTF8=m
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
diff -puN arch/arm/configs/colibri_pxa300_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/colibri_pxa300_defconfig
--- a/arch/arm/configs/colibri_pxa300_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/colibri_pxa300_defconfig
@@ -58,7 +58,7 @@ CONFIG_INOTIFY=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
 CONFIG_ROOT_NFS=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
diff -puN arch/arm/configs/dove_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/dove_defconfig
--- a/arch/arm/configs/dove_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/dove_defconfig
@@ -119,7 +119,7 @@ CONFIG_NLS_CODEPAGE_850=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_ISO8859_2=y
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_SCHED_DEBUG is not set
diff -puN arch/arm/configs/efm32_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/efm32_defconfig
--- a/arch/arm/configs/efm32_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/efm32_defconfig
@@ -93,7 +93,7 @@ CONFIG_EXT2_FS=y
 CONFIG_ROMFS_FS=y
 CONFIG_ROMFS_BACKED_BY_MTD=y
 # CONFIG_NETWORK_FILESYSTEMS is not set
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
diff -puN arch/arm/configs/exynos_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/exynos_defconfig
--- a/arch/arm/configs/exynos_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/exynos_defconfig
@@ -241,7 +241,7 @@ CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ASCII=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
diff -puN arch/arm/configs/ezx_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/ezx_defconfig
--- a/arch/arm/configs/ezx_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/ezx_defconfig
@@ -379,7 +379,7 @@ CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_NLS_UTF8=m
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_SCHED_DEBUG is not set
diff -puN arch/arm/configs/h5000_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/h5000_defconfig
--- a/arch/arm/configs/h5000_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/h5000_defconfig
@@ -66,7 +66,7 @@ CONFIG_TMPFS=y
 CONFIG_JFFS2_FS=y
 CONFIG_JFFS2_COMPRESSION_OPTIONS=y
 # CONFIG_NETWORK_FILESYSTEMS is not set
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_SCHED_DEBUG is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
diff -puN arch/arm/configs/hisi_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/hisi_defconfig
--- a/arch/arm/configs/hisi_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/hisi_defconfig
@@ -82,7 +82,7 @@ CONFIG_NFS_FS=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_FS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
diff -puN arch/arm/configs/imote2_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/imote2_defconfig
--- a/arch/arm/configs/imote2_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/imote2_defconfig
@@ -350,7 +350,7 @@ CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_NLS_UTF8=m
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_SCHED_DEBUG is not set
diff -puN arch/arm/configs/imx_v6_v7_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/imx_v6_v7_defconfig
--- a/arch/arm/configs/imx_v6_v7_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/imx_v6_v7_defconfig
@@ -366,7 +366,7 @@ CONFIG_NLS_ASCII=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_SCHED_DEBUG is not set
diff -puN arch/arm/configs/keystone_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/keystone_defconfig
--- a/arch/arm/configs/keystone_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/keystone_defconfig
@@ -197,7 +197,7 @@ CONFIG_NFSD_V3=y
 CONFIG_NFSD_V3_ACL=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_SHIRQ=y
 CONFIG_DEBUG_USER=y
diff -puN arch/arm/configs/lpc18xx_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/lpc18xx_defconfig
--- a/arch/arm/configs/lpc18xx_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/lpc18xx_defconfig
@@ -159,7 +159,7 @@ CONFIG_EXT2_FS=y
 # CONFIG_INOTIFY_USER is not set
 CONFIG_JFFS2_FS=y
 # CONFIG_NETWORK_FILESYSTEMS is not set
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
diff -puN arch/arm/configs/magician_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/magician_defconfig
--- a/arch/arm/configs/magician_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/magician_defconfig
@@ -167,7 +167,7 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_1251=m
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_TIMER_STATS=y
diff -puN arch/arm/configs/mmp2_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/mmp2_defconfig
--- a/arch/arm/configs/mmp2_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/mmp2_defconfig
@@ -81,7 +81,7 @@ CONFIG_NFS_V3=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
diff -puN arch/arm/configs/moxart_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/moxart_defconfig
--- a/arch/arm/configs/moxart_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/moxart_defconfig
@@ -124,7 +124,7 @@ CONFIG_EXT3_FS=y
 CONFIG_TMPFS=y
 CONFIG_CONFIGFS_FS=y
 CONFIG_JFFS2_FS=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
diff -puN arch/arm/configs/multi_v7_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/multi_v7_defconfig
--- a/arch/arm/configs/multi_v7_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/multi_v7_defconfig
@@ -845,7 +845,7 @@ CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_LOCKUP_DETECTOR=y
diff -puN arch/arm/configs/mvebu_v7_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/mvebu_v7_defconfig
--- a/arch/arm/configs/mvebu_v7_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/mvebu_v7_defconfig
@@ -147,7 +147,7 @@ CONFIG_NLS_CODEPAGE_850=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_ISO8859_2=y
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
diff -puN arch/arm/configs/mxs_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/mxs_defconfig
--- a/arch/arm/configs/mxs_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/mxs_defconfig
@@ -166,7 +166,7 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_850=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_ISO8859_15=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_FRAME_WARN=2048
 CONFIG_UNUSED_SYMBOLS=y
diff -puN arch/arm/configs/omap2plus_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/omap2plus_defconfig
--- a/arch/arm/configs/omap2plus_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/omap2plus_defconfig
@@ -460,7 +460,7 @@ CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_INFO_SPLIT=y
 CONFIG_DEBUG_INFO_DWARF4=y
diff -puN arch/arm/configs/pxa168_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/pxa168_defconfig
--- a/arch/arm/configs/pxa168_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/pxa168_defconfig
@@ -57,7 +57,7 @@ CONFIG_NFS_V3=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_PREEMPT is not set
diff -puN arch/arm/configs/pxa3xx_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/pxa3xx_defconfig
--- a/arch/arm/configs/pxa3xx_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/pxa3xx_defconfig
@@ -117,7 +117,7 @@ CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_SHIRQ=y
diff -puN arch/arm/configs/pxa910_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/pxa910_defconfig
--- a/arch/arm/configs/pxa910_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/pxa910_defconfig
@@ -65,7 +65,7 @@ CONFIG_NFS_V3=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_PREEMPT is not set
diff -puN arch/arm/configs/pxa_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/pxa_defconfig
--- a/arch/arm/configs/pxa_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/pxa_defconfig
@@ -734,7 +734,7 @@ CONFIG_NLS_ASCII=m
 CONFIG_NLS_ISO8859_1=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_UTF8=m
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DYNAMIC_DEBUG=y
 CONFIG_DEBUG_INFO=y
 CONFIG_FRAME_WARN=0
diff -puN arch/arm/configs/qcom_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/qcom_defconfig
--- a/arch/arm/configs/qcom_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/qcom_defconfig
@@ -181,7 +181,7 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ASCII=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DYNAMIC_DEBUG=y
 CONFIG_DEBUG_INFO=y
 CONFIG_MAGIC_SYSRQ=y
diff -puN arch/arm/configs/raumfeld_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/raumfeld_defconfig
--- a/arch/arm/configs/raumfeld_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/raumfeld_defconfig
@@ -196,7 +196,7 @@ CONFIG_NLS_ISO8859_15=y
 CONFIG_NLS_KOI8_R=y
 CONFIG_NLS_KOI8_U=y
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
diff -puN arch/arm/configs/shmobile_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/shmobile_defconfig
--- a/arch/arm/configs/shmobile_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/shmobile_defconfig
@@ -210,7 +210,7 @@ CONFIG_NFS_V4_1=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
 # CONFIG_ARM_UNWIND is not set
diff -puN arch/arm/configs/socfpga_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/socfpga_defconfig
--- a/arch/arm/configs/socfpga_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/socfpga_defconfig
@@ -101,7 +101,7 @@ CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DETECT_HUNG_TASK=y
diff -puN arch/arm/configs/stm32_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/stm32_defconfig
--- a/arch/arm/configs/stm32_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/stm32_defconfig
@@ -61,7 +61,7 @@ CONFIG_STM32_DMA=y
 # CONFIG_DNOTIFY is not set
 # CONFIG_INOTIFY_USER is not set
 CONFIG_NLS=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
diff -puN arch/arm/configs/sunxi_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/sunxi_defconfig
--- a/arch/arm/configs/sunxi_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/sunxi_defconfig
@@ -146,6 +146,6 @@ CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_FS=y
 CONFIG_CRYPTO_DEV_SUN4I_SS=y
diff -puN arch/arm/configs/tegra_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/tegra_defconfig
--- a/arch/arm/configs/tegra_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/tegra_defconfig
@@ -287,7 +287,7 @@ CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
diff -puN arch/arm/configs/u300_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/u300_defconfig
--- a/arch/arm/configs/u300_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/u300_defconfig
@@ -63,7 +63,7 @@ CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_FS=y
 # CONFIG_SCHED_DEBUG is not set
diff -puN arch/arm/configs/u8500_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/u8500_defconfig
--- a/arch/arm/configs/u8500_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/u8500_defconfig
@@ -128,7 +128,7 @@ CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
diff -puN arch/arm/configs/vt8500_v6_v7_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/vt8500_v6_v7_defconfig
--- a/arch/arm/configs/vt8500_v6_v7_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/vt8500_v6_v7_defconfig
@@ -84,6 +84,6 @@ CONFIG_NFS_FS=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_KERNEL=y
 CONFIG_LOCKUP_DETECTOR=y
diff -puN arch/arm/configs/xcep_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/xcep_defconfig
--- a/arch/arm/configs/xcep_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/xcep_defconfig
@@ -85,7 +85,7 @@ CONFIG_NFS_V3=y
 CONFIG_NLS=m
 CONFIG_NLS_DEFAULT="utf8"
 CONFIG_NLS_UTF8=m
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_SCHED_DEBUG is not set
diff -puN arch/arm/configs/zx_defconfig~lib-switch-config_printk_time-to-int arch/arm/configs/zx_defconfig
--- a/arch/arm/configs/zx_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm/configs/zx_defconfig
@@ -97,7 +97,7 @@ CONFIG_TMPFS_POSIX_ACL=y
 CONFIG_NLS_CODEPAGE_936=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO=y
diff -puN arch/arm64/configs/defconfig~lib-switch-config_printk_time-to-int arch/arm64/configs/defconfig
--- a/arch/arm64/configs/defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/arm64/configs/defconfig
@@ -324,7 +324,7 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_VIRTUALIZATION=y
 CONFIG_KVM=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
diff -puN arch/mips/configs/bcm47xx_defconfig~lib-switch-config_printk_time-to-int arch/mips/configs/bcm47xx_defconfig
--- a/arch/mips/configs/bcm47xx_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/mips/configs/bcm47xx_defconfig
@@ -74,7 +74,7 @@ CONFIG_USB_HCD_BCMA=y
 CONFIG_USB_HCD_SSB=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_INFO_REDUCED=y
 CONFIG_STRIP_ASM_SYMS=y
diff -puN arch/mips/configs/bmips_be_defconfig~lib-switch-config_printk_time-to-int arch/mips/configs/bmips_be_defconfig
--- a/arch/mips/configs/bmips_be_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/mips/configs/bmips_be_defconfig
@@ -33,7 +33,7 @@ CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 # CONFIG_STANDALONE is not set
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_BRCMSTB_GISB_ARB=y
 CONFIG_MTD=y
 CONFIG_MTD_BCM63XX_PARTS=y
diff -puN arch/mips/configs/bmips_stb_defconfig~lib-switch-config_printk_time-to-int arch/mips/configs/bmips_stb_defconfig
--- a/arch/mips/configs/bmips_stb_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/mips/configs/bmips_stb_defconfig
@@ -34,7 +34,7 @@ CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 # CONFIG_STANDALONE is not set
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_BRCMSTB_GISB_ARB=y
 CONFIG_MTD=y
 CONFIG_MTD_CFI=y
diff -puN arch/mips/configs/ci20_defconfig~lib-switch-config_printk_time-to-int arch/mips/configs/ci20_defconfig
--- a/arch/mips/configs/ci20_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/mips/configs/ci20_defconfig
@@ -148,7 +148,7 @@ CONFIG_NLS_ISO8859_15=y
 CONFIG_NLS_KOI8_R=y
 CONFIG_NLS_KOI8_U=y
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_DEBUG_FS=y
diff -puN arch/mips/configs/lemote2f_defconfig~lib-switch-config_printk_time-to-int arch/mips/configs/lemote2f_defconfig
--- a/arch/mips/configs/lemote2f_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/mips/configs/lemote2f_defconfig
@@ -404,7 +404,7 @@ CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_FRAME_WARN=1024
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_DEBUG_FS=y
diff -puN arch/mips/configs/loongson3_defconfig~lib-switch-config_printk_time-to-int arch/mips/configs/loongson3_defconfig
--- a/arch/mips/configs/loongson3_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/mips/configs/loongson3_defconfig
@@ -329,7 +329,7 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_936=y
 CONFIG_NLS_ASCII=y
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_FRAME_WARN=1024
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_MAGIC_SYSRQ=y
diff -puN arch/mips/configs/nlm_xlp_defconfig~lib-switch-config_printk_time-to-int arch/mips/configs/nlm_xlp_defconfig
--- a/arch/mips/configs/nlm_xlp_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/mips/configs/nlm_xlp_defconfig
@@ -553,7 +553,7 @@ CONFIG_NLS_ISO8859_14=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_FRAME_WARN=1024
diff -puN arch/mips/configs/nlm_xlr_defconfig~lib-switch-config_printk_time-to-int arch/mips/configs/nlm_xlr_defconfig
--- a/arch/mips/configs/nlm_xlr_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/mips/configs/nlm_xlr_defconfig
@@ -513,7 +513,7 @@ CONFIG_NLS_ISO8859_14=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_UNUSED_SYMBOLS=y
diff -puN arch/mips/configs/pistachio_defconfig~lib-switch-config_printk_time-to-int arch/mips/configs/pistachio_defconfig
--- a/arch/mips/configs/pistachio_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/mips/configs/pistachio_defconfig
@@ -299,7 +299,7 @@ CONFIG_NLS_DEFAULT="utf8"
 CONFIG_NLS_CODEPAGE_437=m
 CONFIG_NLS_ASCII=m
 CONFIG_NLS_ISO8859_1=m
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0
diff -puN arch/mips/configs/qi_lb60_defconfig~lib-switch-config_printk_time-to-int arch/mips/configs/qi_lb60_defconfig
--- a/arch/mips/configs/qi_lb60_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/mips/configs/qi_lb60_defconfig
@@ -172,7 +172,7 @@ CONFIG_NLS_ISO8859_15=y
 CONFIG_NLS_KOI8_R=y
 CONFIG_NLS_KOI8_U=y
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_READABLE_ASM=y
diff -puN arch/mips/configs/rt305x_defconfig~lib-switch-config_printk_time-to-int arch/mips/configs/rt305x_defconfig
--- a/arch/mips/configs/rt305x_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/mips/configs/rt305x_defconfig
@@ -145,7 +145,7 @@ CONFIG_JFFS2_COMPRESSION_OPTIONS=y
 CONFIG_SQUASHFS=y
 # CONFIG_SQUASHFS_ZLIB is not set
 CONFIG_SQUASHFS_XZ=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_STRIP_ASM_SYMS=y
diff -puN arch/mips/configs/xway_defconfig~lib-switch-config_printk_time-to-int arch/mips/configs/xway_defconfig
--- a/arch/mips/configs/xway_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/mips/configs/xway_defconfig
@@ -143,7 +143,7 @@ CONFIG_JFFS2_COMPRESSION_OPTIONS=y
 CONFIG_SQUASHFS=y
 # CONFIG_SQUASHFS_ZLIB is not set
 CONFIG_SQUASHFS_XZ=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_DEBUG_FS=y
diff -puN arch/parisc/configs/generic-64bit_defconfig~lib-switch-config_printk_time-to-int arch/parisc/configs/generic-64bit_defconfig
--- a/arch/parisc/configs/generic-64bit_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/parisc/configs/generic-64bit_defconfig
@@ -279,7 +279,7 @@ CONFIG_NLS_ASCII=m
 CONFIG_NLS_ISO8859_1=m
 CONFIG_NLS_ISO8859_2=m
 CONFIG_NLS_UTF8=m
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_UNUSED_SYMBOLS=y
 CONFIG_DEBUG_FS=y
diff -puN arch/powerpc/configs/40x/virtex_defconfig~lib-switch-config_printk_time-to-int arch/powerpc/configs/40x/virtex_defconfig
--- a/arch/powerpc/configs/40x/virtex_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/powerpc/configs/40x/virtex_defconfig
@@ -72,7 +72,7 @@ CONFIG_CRC_CCITT=y
 CONFIG_FONTS=y
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/powerpc/configs/44x/virtex5_defconfig~lib-switch-config_printk_time-to-int arch/powerpc/configs/44x/virtex5_defconfig
--- a/arch/powerpc/configs/44x/virtex5_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/powerpc/configs/44x/virtex5_defconfig
@@ -71,7 +71,7 @@ CONFIG_CRC_CCITT=y
 CONFIG_FONTS=y
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/powerpc/configs/44x/warp_defconfig~lib-switch-config_printk_time-to-int arch/powerpc/configs/44x/warp_defconfig
--- a/arch/powerpc/configs/44x/warp_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/powerpc/configs/44x/warp_defconfig
@@ -93,7 +93,7 @@ CONFIG_NLS_ISO8859_15=y
 CONFIG_NLS_UTF8=y
 CONFIG_CRC_CCITT=y
 CONFIG_CRC_T10DIF=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
diff -puN arch/powerpc/configs/52xx/cm5200_defconfig~lib-switch-config_printk_time-to-int arch/powerpc/configs/52xx/cm5200_defconfig
--- a/arch/powerpc/configs/52xx/cm5200_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/powerpc/configs/52xx/cm5200_defconfig
@@ -74,7 +74,7 @@ CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_CRYPTO_ECB=y
diff -puN arch/powerpc/configs/52xx/lite5200b_defconfig~lib-switch-config_printk_time-to-int arch/powerpc/configs/52xx/lite5200b_defconfig
--- a/arch/powerpc/configs/52xx/lite5200b_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/powerpc/configs/52xx/lite5200b_defconfig
@@ -60,7 +60,7 @@ CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
diff -puN arch/powerpc/configs/52xx/motionpro_defconfig~lib-switch-config_printk_time-to-int arch/powerpc/configs/52xx/motionpro_defconfig
--- a/arch/powerpc/configs/52xx/motionpro_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/powerpc/configs/52xx/motionpro_defconfig
@@ -86,7 +86,7 @@ CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
diff -puN arch/powerpc/configs/52xx/tqm5200_defconfig~lib-switch-config_printk_time-to-int arch/powerpc/configs/52xx/tqm5200_defconfig
--- a/arch/powerpc/configs/52xx/tqm5200_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/powerpc/configs/52xx/tqm5200_defconfig
@@ -88,7 +88,7 @@ CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
diff -puN arch/powerpc/configs/gamecube_defconfig~lib-switch-config_printk_time-to-int arch/powerpc/configs/gamecube_defconfig
--- a/arch/powerpc/configs/gamecube_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/powerpc/configs/gamecube_defconfig
@@ -92,7 +92,7 @@ CONFIG_CIFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_CRC_CCITT=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_LATENCYTOP=y
diff -puN arch/powerpc/configs/mpc5200_defconfig~lib-switch-config_printk_time-to-int arch/powerpc/configs/mpc5200_defconfig
--- a/arch/powerpc/configs/mpc5200_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/powerpc/configs/mpc5200_defconfig
@@ -128,7 +128,7 @@ CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
diff -puN arch/powerpc/configs/pasemi_defconfig~lib-switch-config_printk_time-to-int arch/powerpc/configs/pasemi_defconfig
--- a/arch/powerpc/configs/pasemi_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/powerpc/configs/pasemi_defconfig
@@ -171,7 +171,7 @@ CONFIG_NFSD_V4=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_CRC_CCITT=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
diff -puN arch/powerpc/configs/wii_defconfig~lib-switch-config_printk_time-to-int arch/powerpc/configs/wii_defconfig
--- a/arch/powerpc/configs/wii_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/powerpc/configs/wii_defconfig
@@ -113,7 +113,7 @@ CONFIG_CIFS=m
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_CRC_CCITT=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_MUTEXES=y
diff -puN arch/s390/configs/default_defconfig~lib-switch-config_printk_time-to-int arch/s390/configs/default_defconfig
--- a/arch/s390/configs/default_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/s390/configs/default_defconfig
@@ -542,7 +542,7 @@ CONFIG_NLS_ISO8859_1=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_UTF8=m
 CONFIG_DLM=m
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DYNAMIC_DEBUG=y
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_INFO_DWARF4=y
diff -puN arch/s390/configs/gcov_defconfig~lib-switch-config_printk_time-to-int arch/s390/configs/gcov_defconfig
--- a/arch/s390/configs/gcov_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/s390/configs/gcov_defconfig
@@ -534,7 +534,7 @@ CONFIG_NLS_ISO8859_1=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_UTF8=m
 CONFIG_DLM=m
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_INFO_DWARF4=y
 CONFIG_GDB_SCRIPTS=y
diff -puN arch/s390/configs/performance_defconfig~lib-switch-config_printk_time-to-int arch/s390/configs/performance_defconfig
--- a/arch/s390/configs/performance_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/s390/configs/performance_defconfig
@@ -535,7 +535,7 @@ CONFIG_NLS_ISO8859_1=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_UTF8=m
 CONFIG_DLM=m
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_INFO_DWARF4=y
 CONFIG_GDB_SCRIPTS=y
diff -puN arch/s390/configs/zfcpdump_defconfig~lib-switch-config_printk_time-to-int arch/s390/configs/zfcpdump_defconfig
--- a/arch/s390/configs/zfcpdump_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/s390/configs/zfcpdump_defconfig
@@ -55,7 +55,7 @@ CONFIG_RAW_DRIVER=y
 # CONFIG_INOTIFY_USER is not set
 CONFIG_CONFIGFS_FS=y
 # CONFIG_MISC_FILESYSTEMS is not set
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
diff -puN arch/sh/configs/edosk7760_defconfig~lib-switch-config_printk_time-to-int arch/sh/configs/edosk7760_defconfig
--- a/arch/sh/configs/edosk7760_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/sh/configs/edosk7760_defconfig
@@ -109,7 +109,7 @@ CONFIG_NLS_ASCII=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_ISO8859_15=y
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_UNUSED_SYMBOLS=y
diff -puN arch/sh/configs/sdk7786_defconfig~lib-switch-config_printk_time-to-int arch/sh/configs/sdk7786_defconfig
--- a/arch/sh/configs/sdk7786_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/sh/configs/sdk7786_defconfig
@@ -215,7 +215,7 @@ CONFIG_NLS_ASCII=m
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_UTF8=m
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_MAGIC_SYSRQ=y
diff -puN arch/sh/configs/se7722_defconfig~lib-switch-config_printk_time-to-int arch/sh/configs/se7722_defconfig
--- a/arch/sh/configs/se7722_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/sh/configs/se7722_defconfig
@@ -53,7 +53,7 @@ CONFIG_EXT3_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_HUGETLBFS=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
diff -puN arch/sh/configs/sh7785lcr_32bit_defconfig~lib-switch-config_printk_time-to-int arch/sh/configs/sh7785lcr_32bit_defconfig
--- a/arch/sh/configs/sh7785lcr_32bit_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/sh/configs/sh7785lcr_32bit_defconfig
@@ -144,7 +144,7 @@ CONFIG_NFSD_V3=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_932=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
diff -puN arch/sh/configs/urquell_defconfig~lib-switch-config_printk_time-to-int arch/sh/configs/urquell_defconfig
--- a/arch/sh/configs/urquell_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/sh/configs/urquell_defconfig
@@ -142,7 +142,7 @@ CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_932=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_FS=y
diff -puN arch/sparc/configs/sparc64_defconfig~lib-switch-config_printk_time-to-int arch/sparc/configs/sparc64_defconfig
--- a/arch/sparc/configs/sparc64_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/sparc/configs/sparc64_defconfig
@@ -202,7 +202,7 @@ CONFIG_EXT3_FS_SECURITY=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_HUGETLBFS=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
diff -puN arch/x86/configs/i386_defconfig~lib-switch-config_printk_time-to-int arch/x86/configs/i386_defconfig
--- a/arch/x86/configs/i386_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/x86/configs/i386_defconfig
@@ -285,7 +285,7 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ASCII=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 CONFIG_FRAME_WARN=1024
 CONFIG_MAGIC_SYSRQ=y
diff -puN arch/x86/configs/x86_64_defconfig~lib-switch-config_printk_time-to-int arch/x86/configs/x86_64_defconfig
--- a/arch/x86/configs/x86_64_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/x86/configs/x86_64_defconfig
@@ -284,7 +284,7 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ASCII=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_UNUSED_SYMBOLS is not set
diff -puN arch/xtensa/configs/audio_kc705_defconfig~lib-switch-config_printk_time-to-int arch/xtensa/configs/audio_kc705_defconfig
--- a/arch/xtensa/configs/audio_kc705_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/xtensa/configs/audio_kc705_defconfig
@@ -123,7 +123,7 @@ CONFIG_ROOT_NFS=y
 CONFIG_SUNRPC_DEBUG=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DYNAMIC_DEBUG=y
 CONFIG_DEBUG_INFO=y
 CONFIG_MAGIC_SYSRQ=y
diff -puN arch/xtensa/configs/generic_kc705_defconfig~lib-switch-config_printk_time-to-int arch/xtensa/configs/generic_kc705_defconfig
--- a/arch/xtensa/configs/generic_kc705_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/xtensa/configs/generic_kc705_defconfig
@@ -110,7 +110,7 @@ CONFIG_ROOT_NFS=y
 CONFIG_SUNRPC_DEBUG=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DYNAMIC_DEBUG=y
 CONFIG_DEBUG_INFO=y
 CONFIG_MAGIC_SYSRQ=y
diff -puN arch/xtensa/configs/nommu_kc705_defconfig~lib-switch-config_printk_time-to-int arch/xtensa/configs/nommu_kc705_defconfig
--- a/arch/xtensa/configs/nommu_kc705_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/xtensa/configs/nommu_kc705_defconfig
@@ -107,7 +107,7 @@ CONFIG_ROOT_NFS=y
 CONFIG_SUNRPC_DEBUG=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DYNAMIC_DEBUG=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_FRAME_POINTER is not set
diff -puN arch/xtensa/configs/smp_lx200_defconfig~lib-switch-config_printk_time-to-int arch/xtensa/configs/smp_lx200_defconfig
--- a/arch/xtensa/configs/smp_lx200_defconfig~lib-switch-config_printk_time-to-int
+++ a/arch/xtensa/configs/smp_lx200_defconfig
@@ -114,7 +114,7 @@ CONFIG_ROOT_NFS=y
 CONFIG_SUNRPC_DEBUG=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_DYNAMIC_DEBUG=y
 CONFIG_DEBUG_INFO=y
 CONFIG_MAGIC_SYSRQ=y
diff -puN kernel/printk/printk.c~lib-switch-config_printk_time-to-int kernel/printk/printk.c
--- a/kernel/printk/printk.c~lib-switch-config_printk_time-to-int
+++ a/kernel/printk/printk.c
@@ -1171,8 +1171,45 @@ static inline void boot_delay_msec(int l
 }
 #endif
 
-static bool printk_time = IS_ENABLED(CONFIG_PRINTK_TIME);
-module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
+static int printk_time = CONFIG_PRINTK_TIME;
+
+static int printk_time_param_set(const char *val,
+				 const struct kernel_param *kp)
+{
+	char *param = strstrip((char *)val);
+
+	if (strlen(param) != 1)
+		return -EINVAL;
+
+	switch (param[0]) {
+	/* 0/N/n = disabled */
+	case '0':
+	case 'N':
+	case 'n':
+		printk_time = 0;
+		break;
+	/* 1/Y/y = local clock */
+	case '1':
+	case 'Y':
+	case 'y':
+		printk_time = 1;
+		break;
+	default:
+		pr_warn("printk: invalid timestamp value\n");
+		return -EINVAL;
+		break;
+	}
+
+	pr_info("printk: timestamp set to %d.\n", printk_time);
+	return 0;
+}
+
+static struct kernel_param_ops printk_time_param_ops = {
+	.set = printk_time_param_set,
+	.get = param_get_int,
+};
+
+module_param_cb(time, &printk_time_param_ops, &printk_time, S_IRUGO);
 
 static size_t print_time(u64 ts, char *buf)
 {
diff -puN lib/Kconfig.debug~lib-switch-config_printk_time-to-int lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-switch-config_printk_time-to-int
+++ a/lib/Kconfig.debug
@@ -1,7 +1,9 @@
 menu "printk and dmesg options"
 
 config PRINTK_TIME
-	bool "Show timing information on printks"
+	int "Show timing information on printks (0-1)"
+	range 0 1
+	default "0"
 	depends on PRINTK
 	help
 	  Selecting this option causes time stamps of the printk()
@@ -10,7 +12,8 @@ config PRINTK_TIME
 
 	  The timestamp is always recorded internally, and exported
 	  to /dev/kmsg. This flag just specifies if the timestamp should
-	  be included, not that the timestamp is recorded.
+	  be included, not that the timestamp is recorded. 0 disables the
+	  timestamp and 1 uses the local clock.
 
 	  The behavior is also controlled by the kernel command line
 	  parameter printk.time=1. See Documentation/kernel-parameters.txt
diff -puN tools/testing/selftests/rcutorture/configs/lock/CFcommon~lib-switch-config_printk_time-to-int tools/testing/selftests/rcutorture/configs/lock/CFcommon
--- a/tools/testing/selftests/rcutorture/configs/lock/CFcommon~lib-switch-config_printk_time-to-int
+++ a/tools/testing/selftests/rcutorture/configs/lock/CFcommon
@@ -1,2 +1,2 @@
 CONFIG_LOCK_TORTURE_TEST=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
diff -puN tools/testing/selftests/rcutorture/configs/rcu/CFcommon~lib-switch-config_printk_time-to-int tools/testing/selftests/rcutorture/configs/rcu/CFcommon
--- a/tools/testing/selftests/rcutorture/configs/rcu/CFcommon~lib-switch-config_printk_time-to-int
+++ a/tools/testing/selftests/rcutorture/configs/rcu/CFcommon
@@ -1,5 +1,5 @@
 CONFIG_RCU_TORTURE_TEST=y
-CONFIG_PRINTK_TIME=y
+CONFIG_PRINTK_TIME=1
 CONFIG_RCU_TORTURE_TEST_SLOW_CLEANUP=y
 CONFIG_RCU_TORTURE_TEST_SLOW_INIT=y
 CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT=y
_

Patches currently in -mm which might be from prarit@redhat.com are

printk-allow-different-timestamps-for-printktime.patch
init-allow-blacklisting-of-module_init-functions.patch

