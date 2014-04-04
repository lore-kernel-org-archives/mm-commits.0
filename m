From: akpm@linux-foundation.org
Subject: [merged]
 submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:32:26 -0700
Message-ID: <533f08ca.Stl+WtoMEDQRAzjQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbaDDTc1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, rdunlap@infradead.org, bp@suse.de, josh@joshtriplett.org

Subject: [merged] submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch removed from -mm tree
To: josh@joshtriplett.org,bp@suse.de,rdunlap@infradead.org,rob@landley.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:26 -0700


The patch titled
     Subject: SubmittingPatches: add style recommendation to use imperative descriptions
has been removed from the -mm tree.  Its filename was
     submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
cris-make-etrax_arch_v10-select-tty-for-use-in-debugport.patch
ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned.patch
ppc-make-ppc_book3s_64-select-irq_work.patch
kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert.patch
bug-when-config_bug-simplify-warn_on_once-and-family.patch
include-asm-generic-bugh-style-fix-s-while0-while-0.patch
bug-when-config_bug-make-warn-call-no_printk-to-check-format-and-args.patch
bug-make-bug-always-stop-the-machine.patch
x86-always-define-bug-and-have_arch_bug-even-with-config_bug.patch
linux-next.patch
lglock-map-to-spinlock-when-config_smp.patch

