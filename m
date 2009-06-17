From: akpm@linux-foundation.org
Subject: [merged] uml-uml-net-driver-does-not-allow-for-vlans.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:55 -0700
Message-ID: <200906171836.n5HIatJG002983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759040AbZFQSiE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:38:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@linux.intel.com, blaisorblade@yahoo.it, davem@davemloft.net, devzero@web.de, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: UML net driver does not allow for vlans
has been removed from the -mm tree.  Its filename was
     uml-uml-net-driver-does-not-allow-for-vlans.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: UML net driver does not allow for vlans
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

See ancient discussion at
http://marc.info/?l=user-mode-linux-devel&m=101990155831279&w=2

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=7854

Signed-off-by: Alan Cox <alan@linux.intel.com>
Reported-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Roland Kletzing <devzero@web.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/shared/net_user.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/include/shared/net_user.h~uml-uml-net-driver-does-not-allow-for-vlans arch/um/include/shared/net_user.h
--- a/arch/um/include/shared/net_user.h~uml-uml-net-driver-does-not-allow-for-vlans
+++ a/arch/um/include/shared/net_user.h
@@ -8,7 +8,7 @@
 
 #define ETH_ADDR_LEN (6)
 #define ETH_HEADER_ETHERTAP (16)
-#define ETH_HEADER_OTHER (14)
+#define ETH_HEADER_OTHER (26) /* 14 for ethernet + VLAN + MPLS for crazy people */
 #define ETH_MAX_PACKET (1500)
 
 #define UML_NET_VERSION (4)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
linux-next.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial-fix-off-by-one-errors.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch
serial-8250c-irq-handling-race-and-spurious-iir-read.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
serial-add-parameter-to-force-skipping-the-test-for-the-txen-bug.patch
char-isicom-fix-build-warning.patch
char-moxa-prevent-opening-unavailable-ports.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
linuxpps-core-support.patch

