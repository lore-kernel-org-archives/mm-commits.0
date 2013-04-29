From: akpm@linux-foundation.org
Subject: [folded-merged] powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:50:00 -0700
Message-ID: <20130429215000.B798131C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:42928 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab3D2VuB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:50:01 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so109592vbe.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:50:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, cody@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix
has been removed from the -mm tree.  Its filename was
     powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix.patch

This patch was dropped because it was folded into powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/mm/numa.c~powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix
+++ a/arch/powerpc/mm/numa.c
@@ -66,7 +66,7 @@ static void __init setup_node_to_cpumask
 
 	/* setup nr_node_ids if not done yet */
 	if (nr_node_ids == MAX_NUMNODES)
-		setup_nr_node_ids()
+		setup_nr_node_ids();
 
 	/* allocate the map */
 	for (node = 0; node < nr_node_ids; node++)
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking-fix.patch

