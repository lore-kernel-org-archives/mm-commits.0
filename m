From: akpm@linux-foundation.org
Subject: + maintainers-append-to-directory-patterns.patch added to -mm
 tree
Date: Tue, 06 Aug 2013 13:00:35 -0700
Message-ID: <520155e3.TFcCKsDA8NNo/iME%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab3HFUAg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 16:00:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + maintainers-append-to-directory-patterns.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 13:00:35 -0700


The patch titled
     Subject: MAINTAINERS: append "/" to directory patterns
has been added to the -mm tree.  Its filename is
     maintainers-append-to-directory-patterns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-append-to-directory-patterns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-append-to-directory-patterns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: append "/" to directory patterns

It's clearer to have patterns marked as directories.

Change the directory patterns without terminating slashes.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff -puN MAINTAINERS~maintainers-append-to-directory-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-append-to-directory-patterns
+++ a/MAINTAINERS
@@ -1003,7 +1003,7 @@ F:	arch/arm/mach-orion5x/ts78xx-*
 ARM/MICREL KS8695 ARCHITECTURE
 M:	Greg Ungerer <gerg@uclinux.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-F:	arch/arm/mach-ks8695
+F:	arch/arm/mach-ks8695/
 S:	Odd Fixes
 
 ARM/MIOA701 MACHINE SUPPORT
@@ -2006,10 +2006,10 @@ W:	http://ceph.com/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git
 S:	Supported
 F:	Documentation/filesystems/ceph.txt
-F:	fs/ceph
-F:	net/ceph
-F:	include/linux/ceph
-F:	include/linux/crush
+F:	fs/ceph/
+F:	net/ceph/
+F:	include/linux/ceph/
+F:	include/linux/crush/
 
 CERTIFIED WIRELESS USB (WUSB) SUBSYSTEM:
 L:	linux-usb@vger.kernel.org
@@ -2289,7 +2289,7 @@ CPU POWER MONITORING SUBSYSTEM
 M:	Dominik Brodowski <linux@dominikbrodowski.net>
 M:	Thomas Renninger <trenn@suse.de>
 S:	Maintained
-F:	tools/power/cpupower
+F:	tools/power/cpupower/
 
 CPUSETS
 M:	Li Zefan <lizefan@huawei.com>
@@ -2727,7 +2727,7 @@ L:	intel-gfx@lists.freedesktop.org
 L:	dri-devel@lists.freedesktop.org
 T:	git git://people.freedesktop.org/~danvet/drm-intel
 S:	Supported
-F:	drivers/gpu/drm/i915
+F:	drivers/gpu/drm/i915/
 F:	include/drm/i915*
 F:	include/uapi/drm/i915*
 
@@ -2739,7 +2739,7 @@ M:	Kyungmin Park <kyungmin.park@samsung.
 L:	dri-devel@lists.freedesktop.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos.git
 S:	Supported
-F:	drivers/gpu/drm/exynos
+F:	drivers/gpu/drm/exynos/
 F:	include/drm/exynos*
 F:	include/uapi/drm/exynos*
 
@@ -3598,8 +3598,8 @@ M:	Arnd Bergmann <arnd@arndb.de>
 L:	linux-arch@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
 S:	Maintained
-F:	include/asm-generic
-F:	include/uapi/asm-generic
+F:	include/asm-generic/
+F:	include/uapi/asm-generic/
 
 GENERIC UIO DRIVER FOR PCI DEVICES
 M:	"Michael S. Tsirkin" <mst@redhat.com>
@@ -3720,7 +3720,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Odd Fixes
-F:	drivers/media/usb/hdpvr
+F:	drivers/media/usb/hdpvr/
 
 HWPOISON MEMORY FAILURE HANDLING
 M:	Andi Kleen <andi@firstfloor.org>
@@ -4521,7 +4521,7 @@ S:	Supported
 W:	http://www.openfabrics.org
 W:	www.open-iscsi.org
 Q:	http://patchwork.kernel.org/project/linux-rdma/list/
-F:	drivers/infiniband/ulp/iser
+F:	drivers/infiniband/ulp/iser/
 
 ISDN SUBSYSTEM
 M:	Karsten Keil <isdn@linux-pingi.de>
@@ -6079,7 +6079,7 @@ W:	http://openrisc.net
 L:	linux@lists.openrisc.net (moderated for non-subscribers)
 S:	Maintained
 T:	git git://openrisc.net/~jonas/linux
-F:	arch/openrisc
+F:	arch/openrisc/
 
 OPENVSWITCH
 M:	Jesse Gross <jesse@nicira.com>
@@ -6363,7 +6363,7 @@ M:	Jamie Iles <jamie@jamieiles.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://github.com/jamieiles/linux-2.6-ji.git
 S:	Supported
-F:	arch/arm/mach-picoxcell
+F:	arch/arm/mach-picoxcell/
 F:	drivers/*/picoxcell*
 F:	drivers/*/*/picoxcell*
 
@@ -6636,7 +6636,7 @@ F:	drivers/spi/spi-pxa2xx*
 F:	drivers/usb/gadget/pxa2*
 F:	include/sound/pxa2xx-lib.h
 F:	sound/arm/pxa*
-F:	sound/soc/pxa
+F:	sound/soc/pxa/
 
 MMP SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
@@ -7081,7 +7081,7 @@ SAMSUNG AUDIO (ASoC) DRIVERS
 M:	Sangbeom Kim <sbkim73@samsung.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
-F:	sound/soc/samsung
+F:	sound/soc/samsung/
 
 SAMSUNG FRAMEBUFFER DRIVER
 M:	Jingoo Han <jg1.han@samsung.com>
@@ -7127,7 +7127,7 @@ SERIAL DRIVERS
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-serial@vger.kernel.org
 S:	Maintained
-F:	drivers/tty/serial
+F:	drivers/tty/serial/
 
 SYNOPSYS DESIGNWARE DMAC DRIVER
 M:	Viresh Kumar <viresh.linux@gmail.com>
@@ -7156,13 +7156,13 @@ F:	include/uapi/linux/timex.h
 F:	kernel/time/clocksource.c
 F:	kernel/time/time*.c
 F:	kernel/time/ntp.c
-F:	drivers/clocksource
+F:	drivers/clocksource/
 
 TLG2300 VIDEO4LINUX-2 DRIVER
 M:	Huang Shijie <shijie8@gmail.com>
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 S:	Odd Fixes
-F:	drivers/media/usb/tlg2300
+F:	drivers/media/usb/tlg2300/
 
 SC1200 WDT DRIVER
 M:	Zwane Mwaikambo <zwane@arm.linux.org.uk>
@@ -7433,7 +7433,7 @@ S:	Odd fixes
 F:	drivers/media/common/siano/
 F:	drivers/media/usb/siano/
 F:	drivers/media/usb/siano/
-F:	drivers/media/mmc/siano
+F:	drivers/media/mmc/siano/
 
 SH_VEU V4L2 MEM2MEM DRIVER
 M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
@@ -7482,7 +7482,7 @@ L:	davinci-linux-open-source@linux.davin
 T:	git git://gitorious.org/linux-davinci/linux-davinci.git
 Q:	http://patchwork.kernel.org/project/linux-davinci/list/
 S:	Supported
-F:	arch/arm/mach-davinci
+F:	arch/arm/mach-davinci/
 F:	drivers/i2c/busses/i2c-davinci.c
 
 TI DAVINCI SERIES MEDIA DRIVER
@@ -7559,7 +7559,7 @@ SMIA AND SMIA++ IMAGE SENSOR DRIVER
 M:	Sakari Ailus <sakari.ailus@iki.fi>
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	drivers/media/i2c/smiapp
+F:	drivers/media/i2c/smiapp/
 F:	include/media/smiapp.h
 F:	drivers/media/i2c/smiapp-pll.c
 F:	drivers/media/i2c/smiapp-pll.h
@@ -9194,7 +9194,7 @@ M:	Matthew Garrett <matthew.garrett@nebu
 L:	platform-driver-x86@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git
 S:	Maintained
-F:	drivers/platform/x86
+F:	drivers/platform/x86/
 
 X86 MCE INFRASTRUCTURE
 M:	Tony Luck <tony.luck@intel.com>
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-exynos-remove-board-files.patch
maintainers-arm-omap2-3-remove-unused-clockdomain-files.patch
maintainers-omap-powerdomain-update-patterns.patch
maintainers-arm-s3c2410-update-patterns.patch
maintainers-arm-spear-consolidate-sections.patch
maintainers-arm-plat-nomadik-update-patterns.patch
maintainers-arm-s3c24xx-remove-plat-s3c24xx.patch
maintainers-ghes_edac-update-pattern.patch
maintainers-update-siano-drivers.patch
maintainers-si4713-fix-file-pattern.patch
maintainers-update-it913x-patterns.patch
maintainers-update-sirf-patterns.patch
maintainers-update-ssbi-patterns.patch
maintainers-update-file-pattern-for-arc-uart.patch
maintainers-update-usb-ehci-platform-pattern.patch
maintainers-usb-phy-update-patterns.patch
maintainers-update-gre-demux-patterns.patch
maintainers-append-to-directory-patterns.patch
checkpatch-add-a-few-more-fix-corrections.patch
checkpatch-check-camelcase-by-word-not-by-lval.patch
checkpatch-enforce-sane-perl-version.patch
checkpatch-check-for-duplicate-signatures.patch
checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch
checkpatch-fix-networking-kernel-doc-block-comment-defect.patch
checkpatch-add-types-option-to-report-only-specific-message-types.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch
pktcdvd-convert-zone-macro-to-static-function-get_zone.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-consolidate-dprintk-and-vprintk-macros.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch
pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch
pktcdvd-convert-pr_notice-to-pkt_notice.patch
pktcdvd-convert-pr_info-to-pkt_info.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch
linux-next.patch

