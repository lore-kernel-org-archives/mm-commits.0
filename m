From: akpm@linux-foundation.org
Subject: [merged]
 tools-vm-slabinfo-fix-spelling-mistake-ocurrences-occurrences.patch removed from -mm tree
Date: Tue, 28 Jun 2016 19:03:15 -0700
Message-ID: <57732c63.PL8uGCcfpczVOgu4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbcF2CF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:05:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/slabinfo: fix spelling mistake: "Ocurrences" -> "Occurrences"
has been removed from the -mm tree.  Its filename was
     tools-vm-slabinfo-fix-spelling-mistake-ocurrences-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: tools/vm/slabinfo: fix spelling mistake: "Ocurrences" -> "Occurrences"

trivial fix to spelling mistake

Link: http://lkml.kernel.org/r/1466672144-831-1-git-send-email-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/vm/slabinfo.c~tools-vm-slabinfo-fix-spelling-mistake-ocurrences-occurrences tools/vm/slabinfo.c
--- a/tools/vm/slabinfo.c~tools-vm-slabinfo-fix-spelling-mistake-ocurrences-occurrences
+++ a/tools/vm/slabinfo.c
@@ -492,7 +492,7 @@ static void slab_stats(struct slabinfo *
 			s->deactivate_to_head + s->deactivate_to_tail + s->deactivate_bypass;
 
 	if (total) {
-		printf("\nSlab Deactivation             Ocurrences  %%\n");
+		printf("\nSlab Deactivation             Occurrences %%\n");
 		printf("-------------------------------------------------\n");
 		printf("Slab full                     %7lu  %3lu%%\n",
 			s->deactivate_full, (s->deactivate_full * 100) / total);
_

Patches currently in -mm which might be from colin.king@canonical.com are


