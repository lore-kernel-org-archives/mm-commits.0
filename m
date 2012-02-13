From: akpm@linux-foundation.org
Subject: + maintainers-update-git-urls-for-26-deletions.patch added to -mm tree
Date: Mon, 13 Feb 2012 14:36:15 -0800
Message-ID: <20120213223615.C8FC0A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:49562 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2BMWgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2012 17:36:18 -0500
Received: by eekb15 with SMTP id b15so187197eek.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2012 14:36:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, jj@chaosbits.net


The patch titled
     Subject: MAINTAINERS: update git urls for 2.6 deletions
has been added to the -mm tree.  Its filename is
     maintainers-update-git-urls-for-26-deletions.patch

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
Subject: MAINTAINERS: update git urls for 2.6 deletions

Update the various git urls for name changes from 2.6.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |  106 +++++++++++++++++++++++++-------------------------
 1 file changed, 53 insertions(+), 53 deletions(-)

diff -puN MAINTAINERS~maintainers-update-git-urls-for-26-deletions MAINTAINERS
--- a/MAINTAINERS~maintainers-update-git-urls-for-26-deletions
+++ a/MAINTAINERS
@@ -163,7 +163,7 @@ M:	Greg Kroah-Hartman <gregkh@linuxfound
 L:	linux-serial@vger.kernel.org
 W:	http://serial.sourceforge.net
 S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
 F:	drivers/tty/serial/8250*
 F:	include/linux/serial_8250.h
 
@@ -504,7 +504,7 @@ F:	arch/x86/include/asm/geode.h
 AMD IOMMU (AMD-VI)
 M:	Joerg Roedel <joerg.roedel@amd.com>
 L:	iommu@lists.linux-foundation.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
 S:	Supported
 F:	drivers/iommu/amd_iommu*.[ch]
 F:	include/linux/amd-iommu.h
@@ -1503,7 +1503,7 @@ F:	drivers/i2c/busses/i2c-bfin-twi.c
 
 BLOCK LAYER
 M:	Jens Axboe <axboe@kernel.dk>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
 S:	Maintained
 F:	block/
 
@@ -1518,7 +1518,7 @@ M:	Marcel Holtmann <marcel@holtmann.org>
 M:	"Gustavo F. Padovan" <padovan@profusion.mobi>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth.git
 S:	Maintained
 F:	drivers/bluetooth/
 
@@ -1527,7 +1527,7 @@ M:	Marcel Holtmann <marcel@holtmann.org>
 M:	"Gustavo F. Padovan" <padovan@profusion.mobi>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth.git
 S:	Maintained
 F:	net/bluetooth/
 F:	include/net/bluetooth/
@@ -1638,7 +1638,7 @@ BTTV VIDEO4LINUX DRIVER
 M:	Mauro Carvalho Chehab <mchehab@infradead.org>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	Documentation/video4linux/bttv/
 F:	drivers/media/video/bt8xx/bttv*
@@ -1668,7 +1668,7 @@ F:	fs/cachefiles/
 CAFE CMOS INTEGRATED CAMERA CONTROLLER DRIVER
 M:	Jonathan Corbet <corbet@lwn.net>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	Documentation/video4linux/cafe_ccic
 F:	drivers/media/video/marvell-ccic/
@@ -2019,7 +2019,7 @@ CX18 VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
 L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 W:	http://linuxtv.org
 W:	http://www.ivtvdriver.org/index.php/Cx18
 S:	Maintained
@@ -2317,7 +2317,7 @@ F:	Documentation/blockdev/drbd/
 
 DRIVER CORE, KOBJECTS, DEBUGFS AND SYSFS
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
 S:	Supported
 F:	Documentation/kobject.txt
 F:	drivers/base/
@@ -2339,7 +2339,7 @@ INTEL DRM DRIVERS (excluding Poulsbo, Mo
 M:	Keith Packard <keithp@keithp.com>
 L:	intel-gfx@lists.freedesktop.org (subscribers-only)
 L:	dri-devel@lists.freedesktop.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux.git
 S:	Supported
 F:	drivers/gpu/drm/i915
 F:	include/drm/i915*
@@ -2912,8 +2912,8 @@ GFS2 FILE SYSTEM
 M:	Steven Whitehouse <swhiteho@redhat.com>
 L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git
 S:	Supported
 F:	Documentation/filesystems/gfs2*.txt
 F:	fs/gfs2/
@@ -2954,42 +2954,42 @@ F:	drivers/net/ethernet/aeroflex/
 GSPCA FINEPIX SUBDRIVER
 M:	Frank Zago <frank@zago.net>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	drivers/media/video/gspca/finepix.c
 
 GSPCA GL860 SUBDRIVER
 M:	Olivier Lorin <o.lorin@laposte.net>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	drivers/media/video/gspca/gl860/
 
 GSPCA M5602 SUBDRIVER
 M:	Erik Andren <erik.andren@gmail.com>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	drivers/media/video/gspca/m5602/
 
 GSPCA PAC207 SONIXB SUBDRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	drivers/media/video/gspca/pac207.c
 
 GSPCA SN9C20X SUBDRIVER
 M:	Brian Johnson <brijohn@gmail.com>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	drivers/media/video/gspca/sn9c20x.c
 
 GSPCA T613 SUBDRIVER
 M:	Leandro Costantino <lcostantino@gmail.com>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	drivers/media/video/gspca/t613.c
 
@@ -2997,7 +2997,7 @@ GSPCA USB WEBCAM DRIVER
 M:	Jean-Francois Moine <moinejf@free.fr>
 W:	http://moinejf.free.fr
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	drivers/media/video/gspca/
 
@@ -3284,7 +3284,7 @@ IDE SUBSYSTEM
 M:	"David S. Miller" <davem@davemloft.net>
 L:	linux-ide@vger.kernel.org
 Q:	http://patchwork.ozlabs.org/project/linux-ide/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide.git
 S:	Maintained
 F:	Documentation/ide/
 F:	drivers/ide/
@@ -3396,7 +3396,7 @@ F:	firmware/isci/
 INTEL IDLE DRIVER
 M:	Len Brown <lenb@kernel.org>
 L:	linux-pm@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git
 S:	Supported
 F:	drivers/idle/intel_idle.c
 
@@ -3703,7 +3703,7 @@ IVTV VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
 L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 W:	http://www.ivtvdriver.org
 S:	Maintained
 F:	Documentation/video4linux/*.ivtv
@@ -3799,8 +3799,8 @@ F:	fs/autofs4/
 
 KERNEL BUILD + files below scripts/ (unless maintained elsewhere)
 M:	Michal Marek <mmarek@suse.cz>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git for-next
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git for-next
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes
 L:	linux-kbuild@vger.kernel.org
 S:	Maintained
 F:	Documentation/kbuild/
@@ -4223,7 +4223,7 @@ MAC80211
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git
 S:	Maintained
 F:	Documentation/networking/mac80211-injection.txt
 F:	include/net/mac80211.h
@@ -4234,7 +4234,7 @@ M:	Stefano Brivio <stefano.brivio@polimi
 M:	Mattias Nissler <mattias.nissler@gmx.de>
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/en/developers/Documentation/mac80211/RateControl/PID
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git
 S:	Maintained
 F:	net/mac80211/rc80211_pid*
 
@@ -4306,7 +4306,7 @@ P:	LinuxTV.org Project
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 Q:	http://patchwork.kernel.org/project/linux-media/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	Documentation/dvb/
 F:	Documentation/video4linux/
@@ -4607,7 +4607,7 @@ M:	James Morris <jmorris@namei.org>
 M:	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
 M:	Patrick McHardy <kaber@trash.net>
 L:	netdev@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
 S:	Maintained
 F:	net/ipv4/
 F:	net/ipv6/
@@ -4623,7 +4623,7 @@ NETWORKING [WIRELESS]
 M:	"John W. Linville" <linville@tuxdriver.com>
 L:	linux-wireless@vger.kernel.org
 Q:	http://patchwork.kernel.org/project/linux-wireless/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git
 S:	Maintained
 F:	net/mac80211/
 F:	net/rfkill/
@@ -4636,8 +4636,8 @@ F:	drivers/net/wireless/
 NETWORKING DRIVERS
 L:	netdev@vger.kernel.org
 W:	http://www.linuxfoundation.org/en/Net
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
 S:	Odd Fixes
 F:	drivers/net/
 F:	include/linux/if_*
@@ -4712,7 +4712,7 @@ NTFS FILESYSTEM
 M:	Anton Altaparmakov <anton@tuxera.com>
 L:	linux-ntfs-dev@lists.sourceforge.net
 W:	http://www.tuxera.com/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs.git
 S:	Supported
 F:	Documentation/filesystems/ntfs.txt
 F:	fs/ntfs/
@@ -4853,7 +4853,7 @@ F:	drivers/char/pcmcia/cm4040_cs.*
 OMNIVISION OV7670 SENSOR DRIVER
 M:	Jonathan Corbet <corbet@lwn.net>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	drivers/media/video/ov7670.c
 
@@ -5029,7 +5029,7 @@ M:	"James E.J. Bottomley" <jejb@parisc-l
 L:	linux-parisc@vger.kernel.org
 W:	http://www.parisc-linux.org/
 Q:	http://patchwork.kernel.org/project/linux-parisc/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6.git
 S:	Maintained
 F:	arch/parisc/
 F:	drivers/parisc/
@@ -5085,7 +5085,7 @@ PCI SUBSYSTEM
 M:	Jesse Barnes <jbarnes@virtuousgeek.org>
 L:	linux-pci@vger.kernel.org
 Q:	http://patchwork.kernel.org/project/linux-pci/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci.git
 S:	Supported
 F:	Documentation/PCI/
 F:	drivers/pci/
@@ -5359,7 +5359,7 @@ M:	Mike Isely <isely@pobox.com>
 L:	pvrusb2@isely.net	(subscribers-only)
 L:	linux-media@vger.kernel.org
 W:	http://www.isely.net/pvrusb2/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	Documentation/video4linux/README.pvrusb2
 F:	drivers/media/video/pvrusb2/
@@ -5525,7 +5525,7 @@ RCUTORTURE MODULE
 M:	Josh Triplett <josh@freedesktop.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 S:	Supported
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
 
@@ -5550,7 +5550,7 @@ M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 W:	http://www.rdrop.com/users/paulmck/rclock/
 S:	Supported
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
 F:	Documentation/RCU/
 F:	include/linux/rcu*
 F:	include/linux/srcu*
@@ -5711,7 +5711,7 @@ F:	drivers/mmc/host/s3cmci.*
 SAA7146 VIDEO4LINUX-2 DRIVER
 M:	Michael Hunold <michael@mihu.de>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 W:	http://www.mihu.de/linux/saa7146
 S:	Maintained
 F:	drivers/media/common/saa7146*
@@ -6133,7 +6133,7 @@ F:	arch/ia64/sn/
 SOC-CAMERA V4L2 SUBSYSTEM
 M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	include/media/v4l2*
 F:	drivers/media/video/v4l2*
@@ -6205,8 +6205,8 @@ SPARC + UltraSPARC (sparc/sparc64)
 M:	"David S. Miller" <davem@davemloft.net>
 L:	sparclinux@vger.kernel.org
 Q:	http://patchwork.ozlabs.org/project/sparclinux/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next.git
 S:	Maintained
 F:	arch/sparc/
 F:	drivers/sbus/
@@ -6214,8 +6214,8 @@ F:	drivers/sbus/
 SPARC SERIAL DRIVERS
 M:	"David S. Miller" <davem@davemloft.net>
 L:	sparclinux@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next.git
 S:	Maintained
 F:	include/linux/sunserialcore.h
 F:	drivers/tty/serial/suncore.c
@@ -6505,7 +6505,7 @@ L:	linux-scsi@vger.kernel.org
 L:	target-devel@vger.kernel.org
 L:	http://groups.google.com/group/linux-iscsi-target-dev
 W:	http://www.linux-iscsi.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git master
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core.git master
 S:	Supported
 F:	drivers/target/
 F:	include/target/
@@ -6696,7 +6696,7 @@ K:	^Subject:.*(?i)trivial
 TTY LAYER
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 S:	Supported
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
 F:	drivers/tty/
 F:	drivers/tty/serial/serial_core.c
 F:	include/linux/serial_core.h
@@ -6864,7 +6864,7 @@ USB ET61X[12]51 DRIVER
 M:	Luca Risolia <luca.risolia@studio.unibo.it>
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 W:	http://www.linux-projects.org
 S:	Maintained
 F:	drivers/media/video/et61x251/
@@ -7020,7 +7020,7 @@ USB SN9C1xx DRIVER
 M:	Luca Risolia <luca.risolia@studio.unibo.it>
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 W:	http://www.linux-projects.org
 S:	Maintained
 F:	Documentation/video4linux/sn9c102.txt
@@ -7030,7 +7030,7 @@ USB SUBSYSTEM
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-usb@vger.kernel.org
 W:	http://www.linux-usb.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
 S:	Supported
 F:	Documentation/usb/
 F:	drivers/net/usb/
@@ -7056,7 +7056,7 @@ USB VIDEO CLASS
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-uvc-devel@lists.berlios.de (subscribers-only)
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 W:	http://www.ideasonboard.org/uvc/
 S:	Maintained
 F:	drivers/media/video/uvc/
@@ -7065,7 +7065,7 @@ USB W996[87]CF DRIVER
 M:	Luca Risolia <luca.risolia@studio.unibo.it>
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 W:	http://www.linux-projects.org
 S:	Maintained
 F:	Documentation/video4linux/w9968cf.txt
@@ -7094,7 +7094,7 @@ USB ZR364XX DRIVER
 M:	Antoine Jacquet <royale@zerezo.com>
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 W:	http://royale.zerezo.com/zr364xx/
 S:	Maintained
 F:	Documentation/video4linux/zr364xx.txt
@@ -7244,7 +7244,7 @@ M:	Liam Girdwood <lrg@ti.com>
 M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
 W:	http://opensource.wolfsonmicro.com/node/15
 W:	http://www.slimlogic.co.uk/?p=48
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lrg/regulator.git
 S:	Supported
 F:	drivers/regulator/
 F:	include/linux/regulator/
_
Subject: Subject: MAINTAINERS: update git urls for 2.6 deletions

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-git-urls-for-26-deletions.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch

