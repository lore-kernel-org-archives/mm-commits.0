From: akpm@linux-foundation.org
Subject: - remove-unused-include-linux-versionhs.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:45:52 -0700
Message-ID: <200808261845.m7QIjq6k021442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757659AbYHZSqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:46:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     remove unused #include <linux/version.h>'s
has been removed from the -mm tree.  Its filename was
     remove-unused-include-linux-versionhs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove unused #include <linux/version.h>'s
From: Adrian Bunk <bunk@kernel.org>

Let the files using linux/version.h match the files that #include it.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-omap/clock.c                   |    1 -
 arch/cris/arch-v32/kernel/fasttimer.c        |    2 --
 arch/mn10300/kernel/mn10300-serial.c         |    1 -
 arch/powerpc/sysdev/bestcomm/gen_bd.c        |    1 -
 arch/x86/mach-rdc321x/platform.c             |    1 -
 drivers/atm/adummy.c                         |    1 -
 drivers/char/xilinx_hwicap/buffer_icap.h     |    1 -
 drivers/char/xilinx_hwicap/fifo_icap.h       |    1 -
 drivers/char/xilinx_hwicap/xilinx_hwicap.h   |    1 -
 drivers/edac/edac_core.h                     |    1 -
 drivers/i2c/busses/i2c-at91.c                |    1 -
 drivers/infiniband/hw/ehca/ehca_tools.h      |    1 -
 drivers/infiniband/hw/ipath/ipath_fs.c       |    1 -
 drivers/infiniband/hw/nes/nes.h              |    1 -
 drivers/infiniband/ulp/iser/iser_verbs.c     |    1 -
 drivers/input/keyboard/bf54x-keys.c          |    1 -
 drivers/input/touchscreen/mainstone-wm97xx.c |    1 -
 drivers/mfd/asic3.c                          |    1 -
 drivers/mtd/nand/au1550nd.c                  |    1 -
 drivers/net/myri10ge/myri10ge.c              |    1 -
 drivers/net/netxen/netxen_nic.h              |    1 -
 drivers/net/netxen/netxen_nic_ethtool.c      |    1 -
 drivers/net/netxen/netxen_nic_hdr.h          |    2 --
 drivers/net/tokenring/lanstreamer.c          |    1 -
 drivers/net/tokenring/lanstreamer.h          |    2 --
 drivers/net/wireless/b43legacy/main.c        |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945-led.c  |    1 -
 drivers/net/wireless/iwlwifi/iwl-led.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl-rfkill.c    |    1 -
 drivers/rtc/rtc-max6902.c                    |    2 --
 drivers/rtc/rtc-r9701.c                      |    1 -
 drivers/s390/net/ctcm_mpc.c                  |    1 -
 drivers/scsi/dpt/dpti_i2o.h                  |    1 -
 drivers/scsi/ips.c                           |    1 -
 drivers/scsi/ips.h                           |    1 -
 drivers/scsi/lpfc/lpfc_debugfs.c             |    1 -
 drivers/scsi/nsp32.c                         |    1 -
 drivers/scsi/nsp32.h                         |    1 -
 drivers/scsi/pcmcia/nsp_cs.c                 |    1 -
 drivers/scsi/qla2xxx/qla_mid.c               |    1 -
 drivers/usb/gadget/s3c2410_udc.c             |    1 -
 drivers/video/vermilion/vermilion.h          |    1 -
 drivers/video/xilinxfb.c                     |    1 -
 fs/jffs2/jffs2_fs_i.h                        |    1 -
 fs/xfs/xfs_dmapi.h                           |    1 -
 include/asm-x86/xen/hypervisor.h             |    1 -
 include/linux/fs_uart_pd.h                   |    1 -
 kernel/nsproxy.c                             |    1 -
 kernel/power/swap.c                          |    1 -
 kernel/user_namespace.c                      |    1 -
 kernel/utsname.c                             |    1 -
 kernel/utsname_sysctl.c                      |    1 -
 sound/mips/au1x00.c                          |    1 -
 sound/soc/at91/eti_b1_wm8731.c               |    1 -
 sound/soc/codecs/wm8753.c                    |    1 -
 sound/soc/codecs/wm9712.c                    |    1 -
 56 files changed, 60 deletions(-)

diff -puN arch/arm/plat-omap/clock.c~remove-unused-include-linux-versionhs arch/arm/plat-omap/clock.c
--- a/arch/arm/plat-omap/clock.c~remove-unused-include-linux-versionhs
+++ a/arch/arm/plat-omap/clock.c
@@ -10,7 +10,6 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff -puN arch/cris/arch-v32/kernel/fasttimer.c~remove-unused-include-linux-versionhs arch/cris/arch-v32/kernel/fasttimer.c
--- a/arch/cris/arch-v32/kernel/fasttimer.c~remove-unused-include-linux-versionhs
+++ a/arch/cris/arch-v32/kernel/fasttimer.c
@@ -19,8 +19,6 @@
 #include <asm/irq.h>
 #include <asm/system.h>
 
-#include <linux/version.h>
-
 #include <hwregs/reg_map.h>
 #include <hwregs/reg_rdwr.h>
 #include <hwregs/timer_defs.h>
diff -puN arch/mn10300/kernel/mn10300-serial.c~remove-unused-include-linux-versionhs arch/mn10300/kernel/mn10300-serial.c
--- a/arch/mn10300/kernel/mn10300-serial.c~remove-unused-include-linux-versionhs
+++ a/arch/mn10300/kernel/mn10300-serial.c
@@ -17,7 +17,6 @@ static const char serial_revdate[] = "20
 #define SUPPORT_SYSRQ
 #endif
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/serial.h>
 #include <linux/circ_buf.h>
diff -puN arch/powerpc/sysdev/bestcomm/gen_bd.c~remove-unused-include-linux-versionhs arch/powerpc/sysdev/bestcomm/gen_bd.c
--- a/arch/powerpc/sysdev/bestcomm/gen_bd.c~remove-unused-include-linux-versionhs
+++ a/arch/powerpc/sysdev/bestcomm/gen_bd.c
@@ -11,7 +11,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN arch/x86/mach-rdc321x/platform.c~remove-unused-include-linux-versionhs arch/x86/mach-rdc321x/platform.c
--- a/arch/x86/mach-rdc321x/platform.c~remove-unused-include-linux-versionhs
+++ a/arch/x86/mach-rdc321x/platform.c
@@ -25,7 +25,6 @@
 #include <linux/list.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
-#include <linux/version.h>
 #include <linux/leds.h>
 
 #include <asm/gpio.h>
diff -puN drivers/atm/adummy.c~remove-unused-include-linux-versionhs drivers/atm/adummy.c
--- a/drivers/atm/adummy.c~remove-unused-include-linux-versionhs
+++ a/drivers/atm/adummy.c
@@ -3,7 +3,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
diff -puN drivers/char/xilinx_hwicap/buffer_icap.h~remove-unused-include-linux-versionhs drivers/char/xilinx_hwicap/buffer_icap.h
--- a/drivers/char/xilinx_hwicap/buffer_icap.h~remove-unused-include-linux-versionhs
+++ a/drivers/char/xilinx_hwicap/buffer_icap.h
@@ -38,7 +38,6 @@
 
 #include <linux/types.h>
 #include <linux/cdev.h>
-#include <linux/version.h>
 #include <linux/platform_device.h>
 
 #include <asm/io.h>
diff -puN drivers/char/xilinx_hwicap/fifo_icap.h~remove-unused-include-linux-versionhs drivers/char/xilinx_hwicap/fifo_icap.h
--- a/drivers/char/xilinx_hwicap/fifo_icap.h~remove-unused-include-linux-versionhs
+++ a/drivers/char/xilinx_hwicap/fifo_icap.h
@@ -38,7 +38,6 @@
 
 #include <linux/types.h>
 #include <linux/cdev.h>
-#include <linux/version.h>
 #include <linux/platform_device.h>
 
 #include <asm/io.h>
diff -puN drivers/char/xilinx_hwicap/xilinx_hwicap.h~remove-unused-include-linux-versionhs drivers/char/xilinx_hwicap/xilinx_hwicap.h
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.h~remove-unused-include-linux-versionhs
+++ a/drivers/char/xilinx_hwicap/xilinx_hwicap.h
@@ -38,7 +38,6 @@
 
 #include <linux/types.h>
 #include <linux/cdev.h>
-#include <linux/version.h>
 #include <linux/platform_device.h>
 
 #include <asm/io.h>
diff -puN drivers/edac/edac_core.h~remove-unused-include-linux-versionhs drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~remove-unused-include-linux-versionhs
+++ a/drivers/edac/edac_core.h
@@ -34,7 +34,6 @@
 #include <linux/platform_device.h>
 #include <linux/sysdev.h>
 #include <linux/workqueue.h>
-#include <linux/version.h>
 
 #define EDAC_MC_LABEL_LEN	31
 #define EDAC_DEVICE_NAME_LEN	31
diff -puN drivers/i2c/busses/i2c-at91.c~remove-unused-include-linux-versionhs drivers/i2c/busses/i2c-at91.c
--- a/drivers/i2c/busses/i2c-at91.c~remove-unused-include-linux-versionhs
+++ a/drivers/i2c/busses/i2c-at91.c
@@ -14,7 +14,6 @@
 */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/err.h>
 #include <linux/slab.h>
diff -puN drivers/infiniband/hw/ehca/ehca_tools.h~remove-unused-include-linux-versionhs drivers/infiniband/hw/ehca/ehca_tools.h
--- a/drivers/infiniband/hw/ehca/ehca_tools.h~remove-unused-include-linux-versionhs
+++ a/drivers/infiniband/hw/ehca/ehca_tools.h
@@ -54,7 +54,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
-#include <linux/version.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/device.h>
diff -puN drivers/infiniband/hw/ipath/ipath_fs.c~remove-unused-include-linux-versionhs drivers/infiniband/hw/ipath/ipath_fs.c
--- a/drivers/infiniband/hw/ipath/ipath_fs.c~remove-unused-include-linux-versionhs
+++ a/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -31,7 +31,6 @@
  * SOFTWARE.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
diff -puN drivers/infiniband/hw/nes/nes.h~remove-unused-include-linux-versionhs drivers/infiniband/hw/nes/nes.h
--- a/drivers/infiniband/hw/nes/nes.h~remove-unused-include-linux-versionhs
+++ a/drivers/infiniband/hw/nes/nes.h
@@ -43,7 +43,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <asm/io.h>
 #include <linux/crc32c.h>
 
diff -puN drivers/infiniband/ulp/iser/iser_verbs.c~remove-unused-include-linux-versionhs drivers/infiniband/ulp/iser/iser_verbs.c
--- a/drivers/infiniband/ulp/iser/iser_verbs.c~remove-unused-include-linux-versionhs
+++ a/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -33,7 +33,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 
 #include "iscsi_iser.h"
 
diff -puN drivers/input/keyboard/bf54x-keys.c~remove-unused-include-linux-versionhs drivers/input/keyboard/bf54x-keys.c
--- a/drivers/input/keyboard/bf54x-keys.c~remove-unused-include-linux-versionhs
+++ a/drivers/input/keyboard/bf54x-keys.c
@@ -29,7 +29,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 
 #include <linux/init.h>
 #include <linux/fs.h>
diff -puN drivers/input/touchscreen/mainstone-wm97xx.c~remove-unused-include-linux-versionhs drivers/input/touchscreen/mainstone-wm97xx.c
--- a/drivers/input/touchscreen/mainstone-wm97xx.c~remove-unused-include-linux-versionhs
+++ a/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -25,7 +25,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
diff -puN drivers/mfd/asic3.c~remove-unused-include-linux-versionhs drivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~remove-unused-include-linux-versionhs
+++ a/drivers/mfd/asic3.c
@@ -16,7 +16,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
diff -puN drivers/mtd/nand/au1550nd.c~remove-unused-include-linux-versionhs drivers/mtd/nand/au1550nd.c
--- a/drivers/mtd/nand/au1550nd.c~remove-unused-include-linux-versionhs
+++ a/drivers/mtd/nand/au1550nd.c
@@ -16,7 +16,6 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
-#include <linux/version.h>
 #include <asm/io.h>
 
 #include <asm/mach-au1x00/au1xxx.h>
diff -puN drivers/net/myri10ge/myri10ge.c~remove-unused-include-linux-versionhs drivers/net/myri10ge/myri10ge.c
--- a/drivers/net/myri10ge/myri10ge.c~remove-unused-include-linux-versionhs
+++ a/drivers/net/myri10ge/myri10ge.c
@@ -56,7 +56,6 @@
 #include <linux/ethtool.h>
 #include <linux/firmware.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 #include <linux/timer.h>
 #include <linux/vmalloc.h>
 #include <linux/crc32.h>
diff -puN drivers/net/netxen/netxen_nic.h~remove-unused-include-linux-versionhs drivers/net/netxen/netxen_nic.h
--- a/drivers/net/netxen/netxen_nic.h~remove-unused-include-linux-versionhs
+++ a/drivers/net/netxen/netxen_nic.h
@@ -45,7 +45,6 @@
 #include <linux/in.h>
 #include <linux/tcp.h>
 #include <linux/skbuff.h>
-#include <linux/version.h>
 
 #include <linux/ethtool.h>
 #include <linux/mii.h>
diff -puN drivers/net/netxen/netxen_nic_ethtool.c~remove-unused-include-linux-versionhs drivers/net/netxen/netxen_nic_ethtool.c
--- a/drivers/net/netxen/netxen_nic_ethtool.c~remove-unused-include-linux-versionhs
+++ a/drivers/net/netxen/netxen_nic_ethtool.c
@@ -38,7 +38,6 @@
 #include <asm/io.h>
 #include <linux/netdevice.h>
 #include <linux/ethtool.h>
-#include <linux/version.h>
 
 #include "netxen_nic.h"
 #include "netxen_nic_hw.h"
diff -puN drivers/net/netxen/netxen_nic_hdr.h~remove-unused-include-linux-versionhs drivers/net/netxen/netxen_nic_hdr.h
--- a/drivers/net/netxen/netxen_nic_hdr.h~remove-unused-include-linux-versionhs
+++ a/drivers/net/netxen/netxen_nic_hdr.h
@@ -32,8 +32,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
-
 #include <linux/spinlock.h>
 #include <asm/irq.h>
 #include <linux/init.h>
diff -puN drivers/net/tokenring/lanstreamer.c~remove-unused-include-linux-versionhs drivers/net/tokenring/lanstreamer.c
--- a/drivers/net/tokenring/lanstreamer.c~remove-unused-include-linux-versionhs
+++ a/drivers/net/tokenring/lanstreamer.c
@@ -119,7 +119,6 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/spinlock.h>
-#include <linux/version.h>
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
diff -puN drivers/net/tokenring/lanstreamer.h~remove-unused-include-linux-versionhs drivers/net/tokenring/lanstreamer.h
--- a/drivers/net/tokenring/lanstreamer.h~remove-unused-include-linux-versionhs
+++ a/drivers/net/tokenring/lanstreamer.h
@@ -60,8 +60,6 @@
  *
  */
 
-#include <linux/version.h>
-
 /* MAX_INTR - the maximum number of times we can loop
  * inside the interrupt function before returning
  * control to the OS (maximum value is 256)
diff -puN drivers/net/wireless/b43legacy/main.c~remove-unused-include-linux-versionhs drivers/net/wireless/b43legacy/main.c
--- a/drivers/net/wireless/b43legacy/main.c~remove-unused-include-linux-versionhs
+++ a/drivers/net/wireless/b43legacy/main.c
@@ -34,7 +34,6 @@
 #include <linux/moduleparam.h>
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
-#include <linux/version.h>
 #include <linux/firmware.h>
 #include <linux/wireless.h>
 #include <linux/workqueue.h>
diff -puN drivers/net/wireless/iwlwifi/iwl-3945-led.c~remove-unused-include-linux-versionhs drivers/net/wireless/iwlwifi/iwl-3945-led.c
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c~remove-unused-include-linux-versionhs
+++ a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -27,7 +27,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
diff -puN drivers/net/wireless/iwlwifi/iwl-led.c~remove-unused-include-linux-versionhs drivers/net/wireless/iwlwifi/iwl-led.c
--- a/drivers/net/wireless/iwlwifi/iwl-led.c~remove-unused-include-linux-versionhs
+++ a/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -27,7 +27,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
diff -puN drivers/net/wireless/iwlwifi/iwl-rfkill.c~remove-unused-include-linux-versionhs drivers/net/wireless/iwlwifi/iwl-rfkill.c
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c~remove-unused-include-linux-versionhs
+++ a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -27,7 +27,6 @@
  *****************************************************************************/
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 
 #include <net/mac80211.h>
diff -puN drivers/rtc/rtc-max6902.c~remove-unused-include-linux-versionhs drivers/rtc/rtc-max6902.c
--- a/drivers/rtc/rtc-max6902.c~remove-unused-include-linux-versionhs
+++ a/drivers/rtc/rtc-max6902.c
@@ -20,8 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
-
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/init.h>
diff -puN drivers/rtc/rtc-r9701.c~remove-unused-include-linux-versionhs drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~remove-unused-include-linux-versionhs
+++ a/drivers/rtc/rtc-r9701.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/device.h>
diff -puN drivers/s390/net/ctcm_mpc.c~remove-unused-include-linux-versionhs drivers/s390/net/ctcm_mpc.c
--- a/drivers/s390/net/ctcm_mpc.c~remove-unused-include-linux-versionhs
+++ a/drivers/s390/net/ctcm_mpc.c
@@ -19,7 +19,6 @@
 #undef DEBUGDATA
 #undef DEBUGCCW
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff -puN drivers/scsi/dpt/dpti_i2o.h~remove-unused-include-linux-versionhs drivers/scsi/dpt/dpti_i2o.h
--- a/drivers/scsi/dpt/dpti_i2o.h~remove-unused-include-linux-versionhs
+++ a/drivers/scsi/dpt/dpti_i2o.h
@@ -21,7 +21,6 @@
 
 #include <linux/i2o-dev.h>
 
-#include <linux/version.h>
 #include <linux/notifier.h>
 #include <asm/atomic.h>
 
diff -puN drivers/scsi/ips.c~remove-unused-include-linux-versionhs drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~remove-unused-include-linux-versionhs
+++ a/drivers/scsi/ips.c
@@ -165,7 +165,6 @@
 #include <asm/byteorder.h>
 #include <asm/page.h>
 #include <linux/stddef.h>
-#include <linux/version.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
diff -puN drivers/scsi/ips.h~remove-unused-include-linux-versionhs drivers/scsi/ips.h
--- a/drivers/scsi/ips.h~remove-unused-include-linux-versionhs
+++ a/drivers/scsi/ips.h
@@ -50,7 +50,6 @@
 #ifndef _IPS_H_
    #define _IPS_H_
 
-#include <linux/version.h>
 #include <linux/nmi.h>
    #include <asm/uaccess.h>
    #include <asm/io.h>
diff -puN drivers/scsi/lpfc/lpfc_debugfs.c~remove-unused-include-linux-versionhs drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c~remove-unused-include-linux-versionhs
+++ a/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -27,7 +27,6 @@
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/ctype.h>
-#include <linux/version.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
diff -puN drivers/scsi/nsp32.c~remove-unused-include-linux-versionhs drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c~remove-unused-include-linux-versionhs
+++ a/drivers/scsi/nsp32.c
@@ -23,7 +23,6 @@
  *   1.2: PowerPC (big endian) support.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff -puN drivers/scsi/nsp32.h~remove-unused-include-linux-versionhs drivers/scsi/nsp32.h
--- a/drivers/scsi/nsp32.h~remove-unused-include-linux-versionhs
+++ a/drivers/scsi/nsp32.h
@@ -16,7 +16,6 @@
 #ifndef _NSP32_H
 #define _NSP32_H
 
-#include <linux/version.h>
 //#define NSP32_DEBUG 9
 
 /*
diff -puN drivers/scsi/pcmcia/nsp_cs.c~remove-unused-include-linux-versionhs drivers/scsi/pcmcia/nsp_cs.c
--- a/drivers/scsi/pcmcia/nsp_cs.c~remove-unused-include-linux-versionhs
+++ a/drivers/scsi/pcmcia/nsp_cs.c
@@ -25,7 +25,6 @@
 
 ***********************************************************************/
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff -puN drivers/scsi/qla2xxx/qla_mid.c~remove-unused-include-linux-versionhs drivers/scsi/qla2xxx/qla_mid.c
--- a/drivers/scsi/qla2xxx/qla_mid.c~remove-unused-include-linux-versionhs
+++ a/drivers/scsi/qla2xxx/qla_mid.c
@@ -6,7 +6,6 @@
  */
 #include "qla_def.h"
 
-#include <linux/version.h>
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
 #include <linux/smp_lock.h>
diff -puN drivers/usb/gadget/s3c2410_udc.c~remove-unused-include-linux-versionhs drivers/usb/gadget/s3c2410_udc.c
--- a/drivers/usb/gadget/s3c2410_udc.c~remove-unused-include-linux-versionhs
+++ a/drivers/usb/gadget/s3c2410_udc.c
@@ -35,7 +35,6 @@
 #include <linux/list.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <linux/version.h>
 #include <linux/clk.h>
 
 #include <linux/debugfs.h>
diff -puN drivers/video/vermilion/vermilion.h~remove-unused-include-linux-versionhs drivers/video/vermilion/vermilion.h
--- a/drivers/video/vermilion/vermilion.h~remove-unused-include-linux-versionhs
+++ a/drivers/video/vermilion/vermilion.h
@@ -30,7 +30,6 @@
 #define _VERMILION_H_
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/pci.h>
 #include <asm/atomic.h>
 #include <linux/mutex.h>
diff -puN drivers/video/xilinxfb.c~remove-unused-include-linux-versionhs drivers/video/xilinxfb.c
--- a/drivers/video/xilinxfb.c~remove-unused-include-linux-versionhs
+++ a/drivers/video/xilinxfb.c
@@ -24,7 +24,6 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/mm.h>
diff -puN fs/jffs2/jffs2_fs_i.h~remove-unused-include-linux-versionhs fs/jffs2/jffs2_fs_i.h
--- a/fs/jffs2/jffs2_fs_i.h~remove-unused-include-linux-versionhs
+++ a/fs/jffs2/jffs2_fs_i.h
@@ -12,7 +12,6 @@
 #ifndef _JFFS2_FS_I
 #define _JFFS2_FS_I
 
-#include <linux/version.h>
 #include <linux/rbtree.h>
 #include <linux/posix_acl.h>
 #include <linux/mutex.h>
diff -puN fs/xfs/xfs_dmapi.h~remove-unused-include-linux-versionhs fs/xfs/xfs_dmapi.h
--- a/fs/xfs/xfs_dmapi.h~remove-unused-include-linux-versionhs
+++ a/fs/xfs/xfs_dmapi.h
@@ -18,7 +18,6 @@
 #ifndef __XFS_DMAPI_H__
 #define __XFS_DMAPI_H__
 
-#include <linux/version.h>
 /*	Values used to define the on-disk version of dm_attrname_t. All
  *	on-disk attribute names start with the 8-byte string "SGI_DMI_".
  *
diff -puN include/asm-x86/xen/hypervisor.h~remove-unused-include-linux-versionhs include/asm-x86/xen/hypervisor.h
--- a/include/asm-x86/xen/hypervisor.h~remove-unused-include-linux-versionhs
+++ a/include/asm-x86/xen/hypervisor.h
@@ -35,7 +35,6 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/version.h>
diff -puN include/linux/fs_uart_pd.h~remove-unused-include-linux-versionhs include/linux/fs_uart_pd.h
--- a/include/linux/fs_uart_pd.h~remove-unused-include-linux-versionhs
+++ a/include/linux/fs_uart_pd.h
@@ -12,7 +12,6 @@
 #ifndef FS_UART_PD_H
 #define FS_UART_PD_H
 
-#include <linux/version.h>
 #include <asm/types.h>
 
 enum fs_uart_id {
diff -puN kernel/nsproxy.c~remove-unused-include-linux-versionhs kernel/nsproxy.c
--- a/kernel/nsproxy.c~remove-unused-include-linux-versionhs
+++ a/kernel/nsproxy.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/nsproxy.h>
 #include <linux/init_task.h>
 #include <linux/mnt_namespace.h>
diff -puN kernel/power/swap.c~remove-unused-include-linux-versionhs kernel/power/swap.c
--- a/kernel/power/swap.c~remove-unused-include-linux-versionhs
+++ a/kernel/power/swap.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
-#include <linux/version.h>
 #include <linux/delay.h>
 #include <linux/bitops.h>
 #include <linux/genhd.h>
diff -puN kernel/user_namespace.c~remove-unused-include-linux-versionhs kernel/user_namespace.c
--- a/kernel/user_namespace.c~remove-unused-include-linux-versionhs
+++ a/kernel/user_namespace.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 #include <linux/user_namespace.h>
diff -puN kernel/utsname.c~remove-unused-include-linux-versionhs kernel/utsname.c
--- a/kernel/utsname.c~remove-unused-include-linux-versionhs
+++ a/kernel/utsname.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/uts.h>
 #include <linux/utsname.h>
-#include <linux/version.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 
diff -puN kernel/utsname_sysctl.c~remove-unused-include-linux-versionhs kernel/utsname_sysctl.c
--- a/kernel/utsname_sysctl.c~remove-unused-include-linux-versionhs
+++ a/kernel/utsname_sysctl.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/uts.h>
 #include <linux/utsname.h>
-#include <linux/version.h>
 #include <linux/sysctl.h>
 
 static void *get_uts(ctl_table *table, int write)
diff -puN sound/mips/au1x00.c~remove-unused-include-linux-versionhs sound/mips/au1x00.c
--- a/sound/mips/au1x00.c~remove-unused-include-linux-versionhs
+++ a/sound/mips/au1x00.c
@@ -38,7 +38,6 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <sound/core.h>
 #include <sound/initval.h>
 #include <sound/pcm.h>
diff -puN sound/soc/at91/eti_b1_wm8731.c~remove-unused-include-linux-versionhs sound/soc/at91/eti_b1_wm8731.c
--- a/sound/soc/at91/eti_b1_wm8731.c~remove-unused-include-linux-versionhs
+++ a/sound/soc/at91/eti_b1_wm8731.c
@@ -22,7 +22,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/clk.h>
 #include <linux/timer.h>
diff -puN sound/soc/codecs/wm8753.c~remove-unused-include-linux-versionhs sound/soc/codecs/wm8753.c
--- a/sound/soc/codecs/wm8753.c~remove-unused-include-linux-versionhs
+++ a/sound/soc/codecs/wm8753.c
@@ -34,7 +34,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
diff -puN sound/soc/codecs/wm9712.c~remove-unused-include-linux-versionhs sound/soc/codecs/wm9712.c
--- a/sound/soc/codecs/wm9712.c~remove-unused-include-linux-versionhs
+++ a/sound/soc/codecs/wm9712.c
@@ -13,7 +13,6 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <sound/core.h>
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
ntfs-update-homepage.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
mpc8xxx_wdt-fix-modular-build.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
binfmt_somc-add-module_license.patch
make-probe_serial_gsc-static.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
make-ptrace_untrace-static.patch
fs-partitions-acornc-remove-dead-code.patch
parport-remove-cvs-keywords.patch
make-mm-rmapc-anon_vma_cachep-static.patch
ipc-semc-make-free_un-static.patch
make-fs-proc-proc_sysctlc-grab_header-static.patch
make-hp_wmi_notify-static.patch
mm-hugetlbc-make-resv_map_allocrelease-static.patch
make-mm-hugetlbc-unmap_ref_private-static.patch
make-kprobesc-kretprobe_table_lock-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
arm-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
sparc64-use-bcd2bin-bin2bcd.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

