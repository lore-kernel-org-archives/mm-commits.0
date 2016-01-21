From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-git-url-for-apm-driver.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 15:30:11 -0800
Message-ID: <56a16a03.zv1SSG0lrNPujy1w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbcAUXaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:30:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, alexandre.belloni@free-electrons.com, catalin.marinas@arm.com, cornelia.huck@de.ibm.com, dan.carpenter@oracle.com, james.hogan@imgtec.com, kvalo@qca.qualcomm.com, linux@dominikbrodowski.net, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add/fix git URLs for various subsystems
has been removed from the -mm tree.  Its filename was
     maintainers-add-git-url-for-apm-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: MAINTAINERS: add/fix git URLs for various subsystems

Add/fix git URLs for various subsystems
Add git URL for at91
Add git URL for Rockchip
Add git URL for ARM64
Update git URL for ath6kl
Add git URL for backlight
Add git URL for chrome
Add git URL for cris
Add git URL for cryptodev
Update git URL for DLM
Add git URL for eCryptfs
Add git URL for ext4
Add git URL for hwspinlock
Add git URL for integrity
Add git URL for IPVS
Add git URL for nfsd
Add git URL for KVM/s390
Add git URL for kgdb
Add git URL for nvdimm
Add git URL for metag
Add git URL for wireless drivers
Add git URL for devicetree
Update git URL for PCMCIA
Update git URL for pstore
Update git URL for ath10k
Add git URL for hexagon
Add git URL for reset
Add git URL for s390
Fix tree format for SAMSUNG thermal
Add git URL for md
Add git URL for squashfs
Add git URL for swiotlb
Add git URL for xtensa
Fix tree format for TPM
Add git URL for UML
Add git URL for VFIO
Add git URL for vhost
Update git URL for XFS
Fix MIC maintainers entry

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Acked-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   53 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 11 deletions(-)

diff -puN MAINTAINERS~maintainers-add-git-url-for-apm-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-add-git-url-for-apm-driver
+++ a/MAINTAINERS
@@ -781,6 +781,7 @@ F:	sound/aoa/
 APM DRIVER
 M:	Jiri Kosina <jikos@kernel.org>
 S:	Odd fixes
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/apm.git
 F:	arch/x86/kernel/apm_32.c
 F:	include/linux/apm_bios.h
 F:	include/uapi/linux/apm_bios.h
@@ -946,6 +947,7 @@ M:	Alexandre Belloni <alexandre.belloni@
 M:	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.linux4sam.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git
 S:	Supported
 F:	arch/arm/mach-at91/
 F:	include/soc/at91/
@@ -1454,6 +1456,7 @@ ARM/Rockchip SoC support
 M:	Heiko Stuebner <heiko@sntech.de>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	linux-rockchip@lists.infradead.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mmind/linux-rockchip.git
 S:	Maintained
 F:	arch/arm/boot/dts/rk3*
 F:	arch/arm/mach-rockchip/
@@ -1778,6 +1781,7 @@ ARM64 PORT (AARCH64 ARCHITECTURE)
 M:	Catalin Marinas <catalin.marinas@arm.com>
 M:	Will Deacon <will.deacon@arm.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git
 S:	Maintained
 F:	arch/arm64/
 F:	Documentation/arm64/
@@ -1863,7 +1867,7 @@ ATHEROS ATH6KL WIRELESS DRIVER
 M:	Kalle Valo <kvalo@qca.qualcomm.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/en/users/Drivers/ath6kl
-T:	git git://github.com/kvalo/ath.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
 S:	Supported
 F:	drivers/net/wireless/ath/ath6kl/
 
@@ -2115,6 +2119,7 @@ F:	drivers/net/wireless/broadcom/b43lega
 BACKLIGHT CLASS/SUBSYSTEM
 M:	Jingoo Han <jingoohan1@gmail.com>
 M:	Lee Jones <lee.jones@linaro.org>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight.git
 S:	Maintained
 F:	drivers/video/backlight/
 F:	include/linux/backlight.h
@@ -2796,6 +2801,7 @@ F:	drivers/input/touchscreen/chipone_icn
 CHROME HARDWARE PLATFORM SUPPORT
 M:	Olof Johansson <olof@lixom.net>
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/olof/chrome-platform.git
 F:	drivers/platform/chrome/
 
 CISCO VIC ETHERNET NIC DRIVER
@@ -3094,6 +3100,7 @@ M:	Mikael Starvik <starvik@axis.com>
 M:	Jesper Nilsson <jesper.nilsson@axis.com>
 L:	linux-cris-kernel@axis.com
 W:	http://developer.axis.com
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jesper/cris.git
 S:	Maintained
 F:	arch/cris/
 F:	drivers/tty/serial/crisv10.*
@@ -3102,6 +3109,7 @@ CRYPTO API
 M:	Herbert Xu <herbert@gondor.apana.org.au>
 M:	"David S. Miller" <davem@davemloft.net>
 L:	linux-crypto@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 S:	Maintained
 F:	Documentation/crypto/
@@ -3551,7 +3559,7 @@ M:	Christine Caulfield <ccaulfie@redhat.
 M:	David Teigland <teigland@redhat.com>
 L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git
 S:	Supported
 F:	fs/dlm/
 
@@ -3965,6 +3973,7 @@ M:	Tyler Hicks <tyhicks@canonical.com>
 L:	ecryptfs@vger.kernel.org
 W:	http://ecryptfs.org
 W:	https://launchpad.net/ecryptfs
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git
 S:	Supported
 F:	Documentation/filesystems/ecryptfs.txt
 F:	fs/ecryptfs/
@@ -4243,6 +4252,7 @@ M:	Andreas Dilger <adilger.kernel@dilger
 L:	linux-ext4@vger.kernel.org
 W:	http://ext4.wiki.kernel.org
 Q:	http://patchwork.ozlabs.org/project/linux-ext4/list/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
 S:	Maintained
 F:	Documentation/filesystems/ext4.txt
 F:	fs/ext4/
@@ -4925,6 +4935,7 @@ F:	include/linux/hw_random.h
 HARDWARE SPINLOCK CORE
 M:	Ohad Ben-Cohen <ohad@wizery.com>
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ohad/hwspinlock.git
 F:	Documentation/hwspinlock.txt
 F:	drivers/hwspinlock/hwspinlock_*
 F:	include/linux/hwspinlock.h
@@ -5463,6 +5474,7 @@ M:	Dmitry Kasatkin <dmitry.kasatkin@gmai
 L:	linux-ima-devel@lists.sourceforge.net
 L:	linux-ima-user@lists.sourceforge.net
 L:	linux-security-module@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
 S:	Supported
 F:	security/integrity/ima/
 
@@ -5718,11 +5730,11 @@ F:	include/linux/mic_bus.h
 F:	include/linux/scif.h
 F:	include/uapi/linux/mic_common.h
 F: 	include/uapi/linux/mic_ioctl.h
-F	include/uapi/linux/scif_ioctl.h
+F:	include/uapi/linux/scif_ioctl.h
 F:	drivers/misc/mic/
 F:	drivers/dma/mic_x100_dma.c
 F:	drivers/dma/mic_x100_dma.h
-F	Documentation/mic/
+F:	Documentation/mic/
 
 INTEL PMC/P-Unit IPC DRIVER
 M:	Zha Qipeng<qipeng.zha@intel.com>
@@ -5803,6 +5815,8 @@ M:	Julian Anastasov <ja@ssi.bg>
 L:	netdev@vger.kernel.org
 L:	lvs-devel@vger.kernel.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs-next.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git
 F:	Documentation/networking/ipvs-sysctl.txt
 F:	include/net/ip_vs.h
 F:	include/uapi/linux/ip_vs.h
@@ -6086,6 +6100,7 @@ M:	"J. Bruce Fields" <bfields@fieldses.o
 M:	Jeff Layton <jlayton@poochiereds.net>
 L:	linux-nfs@vger.kernel.org
 W:	http://nfs.sourceforge.net/
+T:	git git://linux-nfs.org/~bfields/linux.git
 S:	Supported
 F:	fs/nfsd/
 F:	include/uapi/linux/nfsd/
@@ -6142,6 +6157,7 @@ M:	Christian Borntraeger <borntraeger@de
 M:	Cornelia Huck <cornelia.huck@de.ibm.com>
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git
 S:	Supported
 F:	Documentation/s390/kvm.txt
 F:	arch/s390/include/asm/kvm*
@@ -6215,6 +6231,7 @@ KGDB / KDB /debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
 W:	http://kgdb.wiki.kernel.org/
 L:	kgdb-bugreport@lists.sourceforge.net
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/kgdb.git
 S:	Maintained
 F:	Documentation/DocBook/kgdb.tmpl
 F:	drivers/misc/kgdbts.c
@@ -6386,6 +6403,7 @@ LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SU
 M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-nvdimm@lists.01.org
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git
 S:	Supported
 F:	drivers/nvdimm/*
 F:	include/linux/nd.h
@@ -7055,6 +7073,7 @@ F:	Documentation/hwmon/menf21bmc
 METAG ARCHITECTURE
 M:	James Hogan <james.hogan@imgtec.com>
 L:	linux-metag@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag.git
 S:	Odd Fixes
 F:	arch/metag/
 F:	Documentation/metag/
@@ -7536,7 +7555,8 @@ NETWORKING DRIVERS (WIRELESS)
 M:	Kalle Valo <kvalo@codeaurora.org>
 L:	linux-wireless@vger.kernel.org
 Q:	http://patchwork.kernel.org/project/linux-wireless/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
 S:	Maintained
 F:	drivers/net/wireless/
 
@@ -7942,6 +7962,7 @@ M:	Mark Rutland <mark.rutland@arm.com>
 M:	Ian Campbell <ijc+devicetree@hellion.org.uk>
 M:	Kumar Gala <galak@codeaurora.org>
 L:	devicetree@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
 S:	Maintained
 F:	Documentation/devicetree/
 F:	arch/*/boot/dts/
@@ -8318,7 +8339,7 @@ PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
 L:	linux-pcmcia@lists.infradead.org
 W:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia.git
 S:	Maintained
 F:	Documentation/pcmcia/
 F:	drivers/pcmcia/
@@ -8640,7 +8661,7 @@ M:	Colin Cross <ccross@android.com>
 M:	Kees Cook <keescook@chromium.org>
 M:	Tony Luck <tony.luck@intel.com>
 S:	Maintained
-T:	git git://git.infradead.org/users/cbou/linux-pstore.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git
 F:	fs/pstore/
 F:	include/linux/pstore*
 F:	drivers/firmware/efi/efi-pstore.c
@@ -8849,13 +8870,14 @@ QUALCOMM ATHEROS ATH10K WIRELESS DRIVER
 M:	Kalle Valo <kvalo@qca.qualcomm.com>
 L:	ath10k@lists.infradead.org
 W:	http://wireless.kernel.org/en/users/Drivers/ath10k
-T:	git git://github.com/kvalo/ath.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
 S:	Supported
 F:	drivers/net/wireless/ath/ath10k/
 
 QUALCOMM HEXAGON ARCHITECTURE
 M:	Richard Kuo <rkuo@codeaurora.org>
 L:	linux-hexagon@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rkuo/linux-hexagon-kernel.git
 S:	Supported
 F:	arch/hexagon/
 
@@ -9054,6 +9076,7 @@ F:	drivers/phy/phy-rcar-gen3-usb2.c
 
 RESET CONTROLLER FRAMEWORK
 M:	Philipp Zabel <p.zabel@pengutronix.de>
+T:	git git://git.pengutronix.de/git/pza/linux
 S:	Maintained
 F:	drivers/reset/
 F:	Documentation/devicetree/bindings/reset/
@@ -9201,6 +9224,7 @@ M:	Martin Schwidefsky <schwidefsky@de.ib
 M:	Heiko Carstens <heiko.carstens@de.ibm.com>
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git
 S:	Supported
 F:	arch/s390/
 F:	drivers/s390/
@@ -9393,7 +9417,7 @@ M:	Lukasz Majewski <l.majewski@samsung.c
 L:	linux-pm@vger.kernel.org
 L:	linux-samsung-soc@vger.kernel.org
 S:	Supported
-T:	https://github.com/lmajewski/linux-samsung-thermal.git
+T:	git https://github.com/lmajewski/linux-samsung-thermal.git
 F:	drivers/thermal/samsung/
 
 SAMSUNG USB2 PHY DRIVER
@@ -10046,6 +10070,7 @@ F:	drivers/media/pci/solo6x10/
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
 L:	linux-raid@vger.kernel.org
+T:	git git://neil.brown.name/md
 S:	Supported
 F:	drivers/md/
 F:	include/linux/raid/
@@ -10217,6 +10242,7 @@ SQUASHFS FILE SYSTEM
 M:	Phillip Lougher <phillip@squashfs.org.uk>
 L:	squashfs-devel@lists.sourceforge.net (subscribers-only)
 W:	http://squashfs.org.uk
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next.git
 S:	Maintained
 F:	Documentation/filesystems/squashfs.txt
 F:	fs/squashfs/
@@ -10413,6 +10439,7 @@ F:	arch/x86/boot/video*
 SWIOTLB SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
 L:	linux-kernel@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb.git
 S:	Supported
 F:	lib/swiotlb.c
 F:	arch/*/kernel/pci-swiotlb.c
@@ -10676,6 +10703,7 @@ TENSILICA XTENSA PORT (xtensa)
 M:	Chris Zankel <chris@zankel.net>
 M:	Max Filippov <jcmvbkbc@gmail.com>
 L:	linux-xtensa@linux-xtensa.org
+T:	git git://github.com/czankel/xtensa-linux.git
 S:	Maintained
 F:	arch/xtensa/
 F:	drivers/irqchip/irq-xtensa-*
@@ -10958,7 +10986,7 @@ R:	Jason Gunthorpe <jgunthorpe@obsidianr
 W:	http://tpmdd.sourceforge.net
 L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 Q:	git git://github.com/PeterHuewe/linux-tpmdd.git
-T:	https://github.com/PeterHuewe/linux-tpmdd
+T:	git https://github.com/PeterHuewe/linux-tpmdd
 S:	Maintained
 F:	drivers/char/tpm/
 
@@ -11415,6 +11443,7 @@ M:	Richard Weinberger <richard@nod.at>
 L:	user-mode-linux-devel@lists.sourceforge.net
 L:	user-mode-linux-user@lists.sourceforge.net
 W:	http://user-mode-linux.sourceforge.net
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git
 S:	Maintained
 F:	Documentation/virtual/uml/
 F:	arch/um/
@@ -11461,6 +11490,7 @@ F:	fs/fat/
 VFIO DRIVER
 M:	Alex Williamson <alex.williamson@redhat.com>
 L:	kvm@vger.kernel.org
+T:	git git://github.com/awilliam/linux-vfio.git
 S:	Maintained
 F:	Documentation/vfio.txt
 F:	drivers/vfio/
@@ -11530,6 +11560,7 @@ M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	kvm@vger.kernel.org
 L:	virtualization@lists.linux-foundation.org
 L:	netdev@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
 S:	Maintained
 F:	drivers/vhost/
 F:	include/uapi/linux/vhost.h
@@ -11946,7 +11977,7 @@ M:	Dave Chinner <david@fromorbit.com>
 M:	xfs@oss.sgi.com
 L:	xfs@oss.sgi.com
 W:	http://oss.sgi.com/projects/xfs
-T:	git git://oss.sgi.com/xfs/xfs.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
 S:	Supported
 F:	Documentation/filesystems/xfs.txt
 F:	fs/xfs/
_

Patches currently in -mm which might be from fengguang.wu@intel.com are


