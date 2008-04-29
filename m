From: akpm@linux-foundation.org
Subject: + maintainers-sort-ordering.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:39:12 -0700
Message-ID: <200804291939.m3TJdCa0006168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582AbYD2TkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     MAINTAINERS: sort ordering
has been added to the -mm tree.  Its filename is
     maintainers-sort-ordering.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: sort ordering
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Seems we have various confused entries around S and T.  Sort them all out and
also add myself as tty maintainer (which is how I noticed it).

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |  120 ++++++++++++++++++++++++++------------------------
 1 file changed, 63 insertions(+), 57 deletions(-)

diff -puN MAINTAINERS~maintainers-sort-ordering MAINTAINERS
--- a/MAINTAINERS~maintainers-sort-ordering
+++ a/MAINTAINERS
@@ -3740,42 +3740,6 @@ M:	chrisw@sous-sol.org
 L:	stable@kernel.org
 S:	Maintained
 
-TPM DEVICE DRIVER
-P:	Kylene Hall
-M:	tpmdd-devel@lists.sourceforge.net
-W:	http://tpmdd.sourceforge.net
-P:	Marcel Selhorst
-M:	tpm@selhorst.net
-W:	http://www.prosec.rub.de/tpm/
-L:	tpmdd-devel@lists.sourceforge.net
-S:	Maintained
-
-Telecom Clock Driver for MCPL0010
-P:	Mark Gross
-M:	mark.gross@intel.com
-S:	Supported
-
-TENSILICA XTENSA PORT (xtensa):
-P:	Chris Zankel
-M:	chris@zankel.net
-S:	Maintained
-
-THINKPAD ACPI EXTRAS DRIVER
-P:	Henrique de Moraes Holschuh
-M:	ibm-acpi@hmh.eng.br
-L:	ibm-acpi-devel@lists.sourceforge.net
-W:	http://ibm-acpi.sourceforge.net
-W:	http://thinkwiki.org/wiki/Ibm-acpi
-T:	git repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
-S:	Maintained
-
-UltraSPARC (sparc64):
-P:	David S. Miller
-M:	davem@davemloft.net
-L:	sparclinux@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
-S:	Maintained
-
 SHARP LH SUPPORT (LH7952X & LH7A40X)
 P:	Marc Singer
 M:	elf@buici.com
@@ -3872,6 +3836,12 @@ P:	Christoph Hellwig
 M:	hch@infradead.org
 S:	Maintained
 
+TASKSTATS STATISTICS INTERFACE
+P:	Shailabh Nagar
+M:	nagar@watson.ibm.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 TC CLASSIFIER
 P:	Jamal Hadi Salim
 M:	hadi@cyberus.ca
@@ -3894,6 +3864,25 @@ M:	andy@greyhouse.net
 L:	netdev@vger.kernel.org
 S:	Supported
 
+Telecom Clock Driver for MCPL0010
+P:	Mark Gross
+M:	mark.gross@intel.com
+S:	Supported
+
+TENSILICA XTENSA PORT (xtensa):
+P:	Chris Zankel
+M:	chris@zankel.net
+S:	Maintained
+
+THINKPAD ACPI EXTRAS DRIVER
+P:	Henrique de Moraes Holschuh
+M:	ibm-acpi@hmh.eng.br
+L:	ibm-acpi-devel@lists.sourceforge.net
+W:	http://ibm-acpi.sourceforge.net
+W:	http://thinkwiki.org/wiki/Ibm-acpi
+T:	git repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
+S:	Maintained
+
 TI FLASH MEDIA INTERFACE DRIVER
 P:      Alex Dubov
 M:      oakad@yahoo.com
@@ -3911,12 +3900,6 @@ P:	Deepak Saxena
 M:	dsaxena@plexity.net
 S:	Maintained
 
-TASKSTATS STATISTICS INTERFACE
-P:	Shailabh Nagar
-M:	nagar@watson.ibm.com
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-
 TIPC NETWORK LAYER
 P:	Per Liden
 M:	per.liden@ericsson.com
@@ -3950,6 +3933,16 @@ L:	tlinux-users@tce.toshiba-dme.co.jp
 W:	http://www.buzzard.org.uk/toshiba/
 S:	Maintained
 
+TPM DEVICE DRIVER
+P:	Kylene Hall
+M:	tpmdd-devel@lists.sourceforge.net
+W:	http://tpmdd.sourceforge.net
+P:	Marcel Selhorst
+M:	tpm@selhorst.net
+W:	http://www.prosec.rub.de/tpm/
+L:	tpmdd-devel@lists.sourceforge.net
+S:	Maintained
+
 TRIDENT 4DWAVE/SIS 7018 PCI AUDIO CORE
 P:	Muli Ben-Yehuda
 M:	mulix@mulix.org
@@ -3962,6 +3955,12 @@ M:	trivial@kernel.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+TTY LAYER
+P:	Alan Cox
+M:	alan@lxorguk.ukuu.org.uk
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 TULIP NETWORK DRIVERS
 P:	Grant Grundler
 M:	grundler@parisc-linux.org
@@ -4130,6 +4129,20 @@ L:      linux-usb@vger.kernel.org
 W:	http://www.chello.nl/~j.vreeken/se401/
 S:	Maintained
 
+USB SERIAL BELKIN F5U103 DRIVER
+P:	William Greathouse
+M:	wgreathouse@smva.com
+L:      linux-usb@vger.kernel.org
+S:	Maintained
+
+USB SERIAL CYPRESS M8 DRIVER
+P:	Lonnie Mendez
+M:	dignome@gmail.com
+L:      linux-usb@vger.kernel.org
+S:	Maintained
+W:	http://geocities.com/i0xox0i
+W:	http://firstlight.net/cvs
+
 USB SERIAL CYBERJACK DRIVER
 P:	Matthias Bruestle and Harald Welte
 M:	support@reiner-sct.com
@@ -4149,20 +4162,6 @@ M:	gregkh@suse.de
 L:      linux-usb@vger.kernel.org
 S:	Supported
 
-USB SERIAL BELKIN F5U103 DRIVER
-P:	William Greathouse
-M:	wgreathouse@smva.com
-L:      linux-usb@vger.kernel.org
-S:	Maintained
-
-USB SERIAL CYPRESS M8 DRIVER
-P:	Lonnie Mendez
-M:	dignome@gmail.com
-L:      linux-usb@vger.kernel.org
-S:	Maintained
-W:	http://geocities.com/i0xox0i
-W:	http://firstlight.net/cvs
-
 USB SERIAL EMPEG EMPEG-CAR MARK I/II DRIVER
 P:	Gary Brubaker
 M:	xavyer@ix.netcom.com
@@ -4265,7 +4264,7 @@ M:	gregkh@suse.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-FAT/VFAT/MSDOS FILESYSTEM:
+VFAT/FAT/MSDOS FILESYSTEM:
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
 L:	linux-kernel@vger.kernel.org
@@ -4310,6 +4309,13 @@ M:	dushistov@mail.ru
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+UltraSPARC (sparc64):
+P:	David S. Miller
+M:	davem@davemloft.net
+L:	sparclinux@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
+S:	Maintained
+
 USB DIAMOND RIO500 DRIVER
 P:	Cesar Miquel
 M:	miquel@df.uba.ar
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
vt-fix-background-color-on-line-feed.patch
proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch
edac-new-support-for-intel-3100-chipset.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
edac-fix-module-initialization-on-several-modules-2nd-time.patch
maintainers-sort-ordering.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
libata-more-tsstcorp-pain-keep-in-sync-with-legacy-ide.patch
pata_atiixp-simplex-clear.patch
pata_via-fix-6410-misdetect.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
tty_ioctl-soft-carrier-handling.patch
tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch
sxc-fix-printk-warnings-on-sparc32.patch
istallion-tiocg-ssoftcar-handling-removal.patch
cyclades-coding-style-review.patch
cyclades-use-ioremap_nocache-for-clarity-as-proposed.patch
tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch
s390-tty-prepare-for-put_char-to-return-success-fail.patch
serial-m68k-put_char-returns.patch
usb-gadget-switch-to-put_char-returning-int.patch
amiserial-switch-put-char-to-return-success-fail.patch
char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch
mxser-switch-to-put_char-being-int.patch
pcmcia-serial-to-int-put_char-method.patch
riscom-rocket-switch-to-int-put_char-method.patch
serial167-switch-to-int-put_char-method.patch
specialix-switch-to-int-put_char-method.patch
synclink-series-switch-to-int-put_char-method.patch
consoles-switch-to-int-put_char-method.patch
isdn-switch-to-int-put_char-method.patch
pty-prepare-for-tty-ops-changes.patch
pc300-update-to-tty_set_operations.patch
serial-switch-the-serial-core-to-int-put_char-methods.patch
isicom-bring-into-coding-style.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework.patch
tty-the-big-operations-rework-broke-wan-x25_asy-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
strip-fix-up-strip-for-the-new-order.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
riscom8-coding-style.patch
epca-coding-style.patch
esp-clean-up-to-modern-coding-style.patch
toshiba-use-ioremap_cached.patch
isicom-fix-buffer-allocation.patch
tty-add-throttle-unthrottle-helpers.patch
ip2-switch-remaining-direct-call-of-ops-flush_buffer.patch
char-serial-switch-drivers-to-ioremap_nocache.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

