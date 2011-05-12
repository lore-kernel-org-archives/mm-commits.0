From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-sorting.patch removed from -mm tree
Date: Thu, 12 May 2011 11:54:45 -0700
Message-ID: <201105121847.p4CIlI1h025936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775Ab1ELSrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 14:47:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harryxiyou@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: fix sorting
has been removed from the -mm tree.  Its filename was
     maintainers-fix-sorting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: fix sorting
From: Harry Wei <harryxiyou@gmail.com>

Take alphabetical orders for MAINTAINERS file.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   80 +++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff -puN MAINTAINERS~maintainers-fix-sorting MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-sorting
+++ a/MAINTAINERS
@@ -2813,38 +2813,19 @@ F:	Documentation/gpio.txt
 F:	drivers/gpio/
 F:	include/linux/gpio*
 
+GRE DEMULTIPLEXER DRIVER
+M:	Dmitry Kozlov <xeb@mail.ru>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	net/ipv4/gre.c
+F:	include/net/gre.h
+
 GRETH 10/100/1G Ethernet MAC device driver
 M:	Kristoffer Glembo <kristoffer@gaisler.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/greth*
 
-HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
-M:	Frank Seidel <frank@f-seidel.de>
-L:	platform-driver-x86@vger.kernel.org
-W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/hdaps/
-S:	Maintained
-F:	drivers/platform/x86/hdaps.c
-
-HWPOISON MEMORY FAILURE HANDLING
-M:	Andi Kleen <andi@firstfloor.org>
-L:	linux-mm@kvack.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison
-S:	Maintained
-F:	mm/memory-failure.c
-F:	mm/hwpoison-inject.c
-
-HYPERVISOR VIRTUAL CONSOLE DRIVER
-L:	linuxppc-dev@lists.ozlabs.org
-S:	Odd Fixes
-F:	drivers/tty/hvc/
-
-iSCSI BOOT FIRMWARE TABLE (iBFT) DRIVER
-M:	Peter Jones <pjones@redhat.com>
-M:	Konrad Rzeszutek Wilk <konrad@kernel.org>
-S:	Maintained
-F:	drivers/firmware/iscsi_ibft*
-
 GSPCA FINEPIX SUBDRIVER
 M:	Frank Zago <frank@zago.net>
 L:	linux-media@vger.kernel.org
@@ -2895,6 +2876,26 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	drivers/media/video/gspca/
 
+HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
+M:	Frank Seidel <frank@f-seidel.de>
+L:	platform-driver-x86@vger.kernel.org
+W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/hdaps/
+S:	Maintained
+F:	drivers/platform/x86/hdaps.c
+
+HWPOISON MEMORY FAILURE HANDLING
+M:	Andi Kleen <andi@firstfloor.org>
+L:	linux-mm@kvack.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison
+S:	Maintained
+F:	mm/memory-failure.c
+F:	mm/hwpoison-inject.c
+
+HYPERVISOR VIRTUAL CONSOLE DRIVER
+L:	linuxppc-dev@lists.ozlabs.org
+S:	Odd Fixes
+F:	drivers/tty/hvc/
+
 HARDWARE MONITORING
 M:	Jean Delvare <khali@linux-fr.org>
 M:	Guenter Roeck <guenter.roeck@ericsson.com>
@@ -3478,6 +3479,12 @@ F:	Documentation/isapnp.txt
 F:	drivers/pnp/isapnp/
 F:	include/linux/isapnp.h
 
+iSCSI BOOT FIRMWARE TABLE (iBFT) DRIVER
+M:	Peter Jones <pjones@redhat.com>
+M:	Konrad Rzeszutek Wilk <konrad@kernel.org>
+S:	Maintained
+F:	drivers/firmware/iscsi_ibft*
+
 ISCSI
 M:	Mike Christie <michaelc@cs.wisc.edu>
 L:	open-iscsi@googlegroups.com
@@ -4989,6 +4996,13 @@ F:	Documentation/pps/
 F:	drivers/pps/
 F:	include/linux/pps*.h
 
+PPTP DRIVER
+M:	Dmitry Kozlov <xeb@mail.ru>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/pptp.c
+W:	http://sourceforge.net/projects/accel-pptp
+
 PREEMPTIBLE KERNEL
 M:	Robert Love <rml@tech9.net>
 L:	kpreempt-tech@lists.sourceforge.net
@@ -7024,20 +7038,6 @@ M:	"Maciej W. Rozycki" <macro@linux-mips
 S:	Maintained
 F:	drivers/tty/serial/zs.*
 
-GRE DEMULTIPLEXER DRIVER
-M:	Dmitry Kozlov <xeb@mail.ru>
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	net/ipv4/gre.c
-F:	include/net/gre.h
-
-PPTP DRIVER
-M:	Dmitry Kozlov <xeb@mail.ru>
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	drivers/net/pptp.c
-W:	http://sourceforge.net/projects/accel-pptp
