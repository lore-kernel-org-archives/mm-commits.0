From: akpm@linux-foundation.org
Subject: + update-stale-maintainers-entries.patch added to -mm tree
Date: Fri, 07 Dec 2007 14:40:46 -0800
Message-ID: <200712072240.lB7MekXc007315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33044 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053AbXLGWlx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 17:41:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: update stale entries
has been added to the -mm tree.  Its filename is
     update-stale-maintainers-entries.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2065,7 +2063,7 @@ S:	Maintained
 IOC3 SERIAL DRIVER
 P:	Pat Gefre
 M:	pfg@sgi.com
-L:	linux-kernel@linux-mips.org
+L:	linux-mips@linux-mips.org
 S:	Maintained
 
 IP MASQUERADING:
@@ -2816,7 +2814,6 @@ M:	p2@ace.ulyssis.student.kuleuven.ac.be
 P:	Mike Phillips
 M:	mikep@linuxtr.net
 L:	netdev@vger.kernel.org
-L:	linux-tr@linuxtr.net
 W:	http://www.linuxtr.net
 S:	Maintained
 
@@ -2955,7 +2952,7 @@ S:	Supported
 PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
 L:	linux-pcmcia@lists.infradead.org
-L:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
+W:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
 T:	git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 S:	Maintained
 
@@ -3733,7 +3730,6 @@ TOKEN-RING NETWORK DRIVER
 P:	Mike Phillips
 M:	mikep@linuxtr.net
 L:	netdev@vger.kernel.org
-L:	linux-tr@linuxtr.net
 W:	http://www.linuxtr.net
 S:	Maintained
 
@@ -4051,7 +4047,7 @@ S:	Maintained
 
 USER-MODE LINUX
 P:	Jeff Dike
-M:	jdike@karaya.com
+M:	jdike@addtoit.com
 L:	user-mode-linux-devel@lists.sourceforge.net
 L:	user-mode-linux-user@lists.sourceforge.net
 W:	http://user-mode-linux.sourceforge.net
@@ -4282,13 +4278,6 @@ L:	mjpeg-users@lists.sourceforge.net
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

update-stale-maintainers-entries.patch
git-alsa.patch
git-cpufreq.patch
git-powerpc.patch
git-dvb.patch
git-ieee1394.patch
git-infiniband.patch
git-jfs.patch
git-kvm.patch
git-netdev-all.patch
git-selinux.patch
git-s390.patch
git-sparc64.patch
uml-add-missing-space.patch
