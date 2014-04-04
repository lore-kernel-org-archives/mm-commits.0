From: akpm@linux-foundation.org
Subject: [merged]
 submittingpatches-add-recommendation-for-mailing-list-references.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:32:28 -0700
Message-ID: <533f08cc.C6rMssBqrp/fqnb1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbaDDTc3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, rdunlap@infradead.org, bp@suse.de, josh@joshtriplett.org

Subject: [merged] submittingpatches-add-recommendation-for-mailing-list-references.patch removed from -mm tree
To: josh@joshtriplett.org,bp@suse.de,rdunlap@infradead.org,rob@landley.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:28 -0700


The patch titled
     Subject: SubmittingPatches: add recommendation for mailing list references
has been removed from the -mm tree.  Its filename was
     submittingpatches-add-recommendation-for-mailing-list-references.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

