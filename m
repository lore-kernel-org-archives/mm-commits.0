From: akpm@google.com
Subject: + rapidio-documentation-update.patch added to -mm tree
Date: Thu, 06 Oct 2011 15:55:29 -0700
Message-ID: <201110062255.p96MtTLD015722@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:7137 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab1JFWzq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2011 18:55:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, Gang.Liu@freescale.com, micha@neli.hopto.org


The patch titled
     Subject: RapidIO: documentation update
has been added to the -mm tree.  Its filename is
     rapidio-documentation-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: RapidIO: documentation update

Update rapidio.txt to reflect changes from recent patch.
See http://marc.info/?l=linux-kernel&m=131285620113589&w=2 for details.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Liu Gang <Gang.Liu@freescale.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 Documentation/rapidio/rapidio.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/rapidio/rapidio.txt~rapidio-documentation-update Documentation/rapidio/rapidio.txt
--- a/Documentation/rapidio/rapidio.txt~rapidio-documentation-update
+++ a/Documentation/rapidio/rapidio.txt
@@ -144,7 +144,7 @@ and the default device ID in order to ac
 
 After the host has completed enumeration of the entire network it releases
 devices by clearing device ID locks (calls rio_clear_locks()). For each endpoint
-in the system, it sets the Master Enable bit in the Port General Control CSR
+in the system, it sets the Discovered bit in the Port General Control CSR
 to indicate that enumeration is completed and agents are allowed to execute
 passive discovery of the network.
 
_
Subject: Subject: RapidIO: documentation update

Patches currently in -mm which might be from alexandre.bounine@idt.com are

drivers-rapidio-rio-scanc-use-discovered-bit-to-test-if-enumeration-is-complete.patch
arch-powerpc-sysdev-fsl_rioc-release-rapidio-port-i-o-region-resource-if-port-failed-to-initialize.patch
rapidio-add-mport-driver-for-tsi721-bridge.patch
rapidio-add-mport-driver-for-tsi721-bridge-update.patch
rapidio-fix-potential-null-deref-in-rio_setup_device.patch
drivers-net-rionetc-fix-ethernet-address-macros-for-le-platforms.patch
rapidio-documentation-update.patch
include-linux-dma-mappingh-add-dma_zalloc_coherent.patch

