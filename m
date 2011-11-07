From: akpm@linux-foundation.org
Subject: [merged] rapidio-documentation-update.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:28:46 -0800
Message-ID: <201111072028.pA7KSkHx011313@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5892 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1KGU3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, Gang.Liu@freescale.com, micha@neli.hopto.org, mm-commits@vger.kernel.org


The patch titled
     Subject: RapidIO: documentation update
has been removed from the -mm tree.  Its filename was
     rapidio-documentation-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: RapidIO: documentation update

Update rapidio.txt to reflect changes from recent patch.
See http://marc.info/?l=linux-kernel&m=131285620113589&w=2 for details.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Liu Gang <Gang.Liu@freescale.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

