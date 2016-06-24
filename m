From: akpm@linux-foundation.org
Subject: +
 tools-vm-slabinfo-fix-spelling-mistake-ocurrences-occurrences.patch added
 to -mm tree
Date: Fri, 24 Jun 2016 13:12:56 -0700
Message-ID: <576d9448.LBD6zuO3U0r5GzDW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbcFXUM5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 16:12:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/slabinfo: fix spelling mistake: "Ocurrences" -> "Occurrences"
has been added to the -mm tree.  Its filename is
     tools-vm-slabinfo-fix-spelling-mistake-ocurrences-occurrences.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-vm-slabinfo-fix-spelling-mistake-ocurrences-occurrences.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-slabinfo-fix-spelling-mistake-ocurrences-occurrences.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tools-vm-slabinfo-fix-spelling-mistake-ocurrences-occurrences.patch

