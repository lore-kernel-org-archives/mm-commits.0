From: akpm@linux-foundation.org
Subject: - update-stale-maintainers-entries.patch removed from -mm tree
Date: Tue, 11 Dec 2007 14:42:05 -0800
Message-ID: <200712112242.lBBMg55I012585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54886 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758679AbXLKWuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 17:50:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update stale entries
has been removed from the -mm tree.  Its filename was
     update-stale-maintainers-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MAINTAINERS: update stale entries
From: Joe Perches <joe@perches.com>

Some bad email addresses are removed:

        linux-tr@linuxtr.net
        ehaase@inf.fu-berlin.de

Some are updated:

        linux@maxim.org.za to andrew@sanpeople.com
        linux-kernel@linux-mips.org to linux-mips@linux-mips.org
        jdike@karaya.com to jdike@addtoit.com

The PCMCIA entry is corrected to a web address

The ZR36120 VIDEO FOR LINUX DRIVER entry is removed

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff -puN MAINTAINERS~update-stale-maintainers-entries MAINTAINERS
--- a/MAINTAINERS~update-stale-maintainers-entries
+++ a/MAINTAINERS
@@ -88,7 +88,6 @@ S: Status, one of the following:
 P:	Mike Phillips
 M:	mikep@linuxtr.net
 L:	netdev@vger.kernel.org
-L:	linux-tr@linuxtr.net
 W:	http://www.linuxtr.net
 S:	Maintained
 
@@ -167,7 +166,6 @@ S:	Maintained
 
 A2232 SERIAL BOARD DRIVER
 P:	Enver Haase
-M:	ehaase@inf.fu-berlin.de
 M:	A2232@gmx.net
 L:	linux-m68k@lists.linux-m68k.org
 S:	Maintained
@@ -439,7 +437,7 @@ S:	Maintained
 
 ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
 P:      Andrew Victor
-M:      linux@maxim.org.za
+M:      andrew@sanpeople.com
 L:      linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 W:      http://maxim.org.za/at91_26.html
 S:      Maintained
@@ -2064,7 +2062,7 @@ S:	Maintained
 IOC3 SERIAL DRIVER
 P:	Pat Gefre
 M:	pfg@sgi.com
-L:	linux-kernel@linux-mips.org
+L:	linux-mips@linux-mips.org
 S:	Maintained
 
 IP MASQUERADING:
@@ -2815,7 +2813,6 @@ M:	p2@ace.ulyssis.student.kuleuven.ac.be
 P:	Mike Phillips
 M:	mikep@linuxtr.net
 L:	netdev@vger.kernel.org
-L:	linux-tr@linuxtr.net
 W:	http://www.linuxtr.net
 S:	Maintained
 
@@ -2953,7 +2950,7 @@ S:	Supported
 PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
 L:	linux-pcmcia@lists.infradead.org
-L:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
+W:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
 T:	git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 S:	Maintained
 
@@ -3731,7 +3728,6 @@ TOKEN-RING NETWORK DRIVER
 P:	Mike Phillips
 M:	mikep@linuxtr.net
 L:	netdev@vger.kernel.org
-L:	linux-tr@linuxtr.net
 W:	http://www.linuxtr.net
 S:	Maintained
 
@@ -4049,7 +4045,7 @@ S:	Maintained
 
 USER-MODE LINUX
 P:	Jeff Dike
-M:	jdike@karaya.com
+M:	jdike@addtoit.com
 L:	user-mode-linux-devel@lists.sourceforge.net
 L:	user-mode-linux-user@lists.sourceforge.net
 W:	http://user-mode-linux.sourceforge.net
@@ -4280,13 +4276,6 @@ L:	mjpeg-users@lists.sourceforge.net
 W:	http://mjpeg.sourceforge.net/driver-zoran/
 S:	Maintained
 
-ZR36120 VIDEO FOR LINUX DRIVER
-P:	Pauline Middelink
-M:	middelin@polyware.nl
-W:	http://www.polyware.nl/~middelin/En/hobbies.html
-W:	http://www.polyware.nl/~middelin/hobbies.html
-S:	Maintained
-
 ZS DECSTATION Z85C30 SERIAL DRIVER
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
_

Patches currently in -mm which might be from joe@perches.com are

git-alsa.patch
git-cpufreq.patch
git-powerpc.patch
git-dvb.patch
git-ieee1394.patch
git-infiniband.patch
git-jfs.patch
git-kvm.patch
git-netdev-all.patch
git-s390.patch
uml-add-missing-space.patch
