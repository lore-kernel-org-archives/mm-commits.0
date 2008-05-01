From: akpm@linux-foundation.org
Subject: - maintainers-sort-ordering.patch removed from -mm tree
Date: Thu, 01 May 2008 02:24:45 -0700
Message-ID: <200805010924.m419OjAr030139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307AbYEAJZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:25:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: sort ordering
has been removed from the -mm tree.  Its filename was
     maintainers-sort-ordering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -3743,42 +3743,6 @@ M:	chrisw@sous-sol.org
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
@@ -3875,6 +3839,12 @@ P:	Christoph Hellwig
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
@@ -3897,6 +3867,25 @@ M:	andy@greyhouse.net
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
@@ -3914,12 +3903,6 @@ P:	Deepak Saxena
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
@@ -3953,6 +3936,16 @@ L:	tlinux-users@tce.toshiba-dme.co.jp
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
@@ -3965,6 +3958,12 @@ M:	trivial@kernel.org
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
@@ -4133,6 +4132,20 @@ L:      linux-usb@vger.kernel.org
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
@@ -4152,20 +4165,6 @@ M:	gregkh@suse.de
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
@@ -4268,7 +4267,7 @@ M:	gregkh@suse.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-FAT/VFAT/MSDOS FILESYSTEM:
+VFAT/FAT/MSDOS FILESYSTEM:
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
 L:	linux-kernel@vger.kernel.org
@@ -4313,6 +4312,13 @@ M:	dushistov@mail.ru
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
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

