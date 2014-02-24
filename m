From: akpm@linux-foundation.org
Subject: +
 submittingpatches-add-recommendation-for-mailing-list-references.patch
 added to -mm tree
Date: Mon, 24 Feb 2014 15:13:01 -0800
Message-ID: <530bd1fd.UYyyYeSwSP6mX1aM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaBXXND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 18:13:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, rdunlap@infradead.org, bp@suse.de, josh@joshtriplett.org

Subject: + submittingpatches-add-recommendation-for-mailing-list-references.patch added to -mm tree
To: josh@joshtriplett.org,bp@suse.de,rdunlap@infradead.org,rob@landley.net
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 15:13:01 -0800


The patch titled
     Subject: SubmittingPatches: add recommendation for mailing list references
has been added to the -mm tree.  Its filename is
     submittingpatches-add-recommendation-for-mailing-list-references.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/submittingpatches-add-recommendation-for-mailing-list-references.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/submittingpatches-add-recommendation-for-mailing-list-references.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: SubmittingPatches: add recommendation for mailing list references

SubmittingPatches already mentions referencing bugs fixed by a commit, but
doesn't mention citing relevant mailing list discussions.  Add a note to
that effect, along with a recommendation to use the
https://lkml.kernel.org/ redirector.

Portions based on text from git's SubmittingPatches.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN Documentation/SubmittingPatches~submittingpatches-add-recommendation-for-mailing-list-references Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~submittingpatches-add-recommendation-for-mailing-list-references
+++ a/Documentation/SubmittingPatches
@@ -112,7 +112,15 @@ to do frotz", as if you are giving order
 its behaviour.
 
 If the patch fixes a logged bug entry, refer to that bug entry by
-number and URL.
+number and URL.  If the patch follows from a mailing list discussion,
+give a URL to the mailing list archive; use the https://lkml.kernel.org/
+redirector with a Message-Id, to ensure that the links cannot become
+stale.
+
+However, try to make your explanation understandable without external
+resources.  In addition to giving a URL to a mailing list archive or
+bug, summarize the relevant points of the discussion that led to the
+patch as submitted.
 
 If you want to refer to a specific commit, don't just refer to the
 SHA-1 ID of the commit. Please also include the oneline summary of
_

Patches currently in -mm which might be from josh@joshtriplett.org are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
include-linux-syscallsh-add-sys32_quotactl-prototype.patch
fs-kernel-permit-disabling-the-uselib-syscall.patch
fs-kernel-permit-disabling-the-uselib-syscall-v2.patch
submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch
submittingpatches-add-recommendation-for-mailing-list-references.patch
submittingpatches-document-the-use-of-git.patch
lglock-map-to-spinlock-when-config_smp.patch
fs-reiserfs-move-prototype-declaration-to-header-file.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert.patch
linux-next.patch

