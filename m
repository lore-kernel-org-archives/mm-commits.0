From: akpm@linux-foundation.org
Subject: + mm-add-comment-about-deprecation-of-__gfp_nofail.patch added to -mm tree
Date: Tue, 02 Mar 2010 12:34:12 -0800
Message-ID: <201003022034.o22KYCEM028022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752917Ab0CBUew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 15:34:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: add comment about deprecation of __GFP_NOFAIL
has been added to the -mm tree.  Its filename is
     mm-add-comment-about-deprecation-of-__gfp_nofail.patch

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
Subject: mm: add comment about deprecation of __GFP_NOFAIL
From: David Rientjes <rientjes@google.com>

__GFP_NOFAIL was deprecated in dab48dab, so add a comment that no new
users should be added.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/gfp.h~mm-add-comment-about-deprecation-of-__gfp_nofail include/linux/gfp.h
--- a/include/linux/gfp.h~mm-add-comment-about-deprecation-of-__gfp_nofail
+++ a/include/linux/gfp.h
@@ -30,7 +30,8 @@ struct vm_area_struct;
  * _might_ fail.  This depends upon the particular VM implementation.
  *
  * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
- * cannot handle allocation failures.
+ * cannot handle allocation failures.  This modifier is deprecated and no new
+ * users should be added.
  *
  * __GFP_NORETRY: The VM implementation must not retry indefinitely.
  *
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mm-clean-up-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-count-swap-usage.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-suppress-pfn-range-output-for-zones-without-pages.patch
mm-add-comment-about-deprecation-of-__gfp_nofail.patch
nodemaskh-remove-macro-any_online_node.patch
memcg-handle-panic_on_oom=always-case-v2.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch

