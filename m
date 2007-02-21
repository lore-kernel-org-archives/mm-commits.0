From: akpm@linux-foundation.org
Subject: - update-doc-oops-tracingtxt-for-taint_user.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:46:25 -0800
Message-ID: <200702211046.l1LAkPE4006469@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47003 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506AbXBUKrF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:47:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     update Doc/oops-tracing.txt for TAINT_USER
has been removed from the -mm tree.  Its filename was
     update-doc-oops-tracingtxt-for-taint_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: update Doc/oops-tracing.txt for TAINT_USER
From: Randy Dunlap <randy.dunlap@oracle.com>

Add TAINT_USER description to Tainted flags in oops-tracing.txt.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/oops-tracing.txt |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN Documentation/oops-tracing.txt~update-doc-oops-tracingtxt-for-taint_user Documentation/oops-tracing.txt
--- a/Documentation/oops-tracing.txt~update-doc-oops-tracingtxt-for-taint_user
+++ a/Documentation/oops-tracing.txt
@@ -234,6 +234,12 @@ characters, each representing a particul
   6: 'B' if a page-release function has found a bad page reference or
      some unexpected page flags.
 
+  7: 'U' if a user specifically requested that the Tainted flag be set,
+     ' ' otherwise.
+
+  7: 'U' if a user or user application specifically requested that the
+     Tainted flag be set, ' ' otherwise.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-drm.patch
git-libata-all.patch
phy-layer-add-kernel-doc-docbook.patch
git-parisc.patch
x86-dont-probe-for-ddc-on-vbe12.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
