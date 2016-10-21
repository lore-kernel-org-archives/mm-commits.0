From: akpm@linux-foundation.org
Subject: + scripts-checkpatchpl-fix-spelling.patch added to -mm tree
Date: Fri, 21 Oct 2016 14:28:20 -0700
Message-ID: <580a8874.heGBLsPq8Ei0B/4C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35312 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933451AbcJUV2V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2016 17:28:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/checkpatch.pl: fix spelling
has been added to the -mm tree.  Its filename is
     scripts-checkpatchpl-fix-spelling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-checkpatchpl-fix-spelling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-checkpatchpl-fix-spelling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts/checkpatch.pl: fix spelling

s/preceeded/preceded/

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~scripts-checkpatchpl-fix-spelling scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~scripts-checkpatchpl-fix-spelling
+++ a/scripts/checkpatch.pl
@@ -5925,7 +5925,7 @@ sub process {
 			}
 			if (!$has_break && $has_statement) {
 				WARN("MISSING_BREAK",
-				     "Possible switch case/default not preceeded by break or fallthrough comment\n" . $herecurr);
+				     "Possible switch case/default not preceded by break or fallthrough comment\n" . $herecurr);
 			}
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-fix.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

