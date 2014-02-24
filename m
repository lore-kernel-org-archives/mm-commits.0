From: akpm@linux-foundation.org
Subject: +
 submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch added to -mm tree
Date: Mon, 24 Feb 2014 15:13:00 -0800
Message-ID: <530bd1fc.5I50H9BX4z6EPxHY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaBXXNB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 18:13:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, rdunlap@infradead.org, bp@suse.de, josh@joshtriplett.org

Subject: + submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch added to -mm tree
To: josh@joshtriplett.org,bp@suse.de,rdunlap@infradead.org,rob@landley.net
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 15:13:00 -0800


The patch titled
     Subject: SubmittingPatches: add style recommendation to use imperative descriptions
has been added to the -mm tree.  Its filename is
     submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch

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
Subject: SubmittingPatches: add style recommendation to use imperative descriptions

Most commit messages use this style, and the recommendation frequently
comes up in discussions (especially in response to patches that don't use
it), but that recommendation doesn't actually appear anywhere in
Documentation.  Add this style guideline to SubmittingPatches, using the
description from git's SubmittingPatches.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN Documentation/SubmittingPatches~submittingpatches-add-style-recommendation-to-use-imperative-descriptions Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~submittingpatches-add-style-recommendation-to-use-imperative-descriptions
+++ a/Documentation/SubmittingPatches
@@ -106,6 +106,11 @@ I.e., the patch (series) and its descrip
 This benefits both the patch merger(s) and reviewers.  Some reviewers
 probably didn't even receive earlier versions of the patch.
 
+Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
+instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
+to do frotz", as if you are giving orders to the codebase to change
+its behaviour.
+
 If the patch fixes a logged bug entry, refer to that bug entry by
 number and URL.
 
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

