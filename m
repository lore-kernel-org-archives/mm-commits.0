From: akpm@linux-foundation.org
Subject: + add-mm-testing-in-submitchecklist.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:32:22 -0800
Message-ID: <200702272032.l1RKWPR2027434@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50608 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbXB0Ucq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:32:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     add -mm testing in SubmitChecklist
has been added to the -mm tree.  Its filename is
     add-mm-testing-in-submitchecklist.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add -mm testing in SubmitChecklist
From: Randy Dunlap <randy.dunlap@oracle.com>

Add -mm testing to SubmitChecklist.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmitChecklist |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/SubmitChecklist~add-mm-testing-in-submitchecklist Documentation/SubmitChecklist
--- a/Documentation/SubmitChecklist~add-mm-testing-in-submitchecklist
+++ a/Documentation/SubmitChecklist
@@ -76,3 +76,7 @@ kernel patches.
 22: Newly-added code has been compiled with `gcc -W'.  This will generate
     lots of noise, but is good for finding bugs like "warning: comparison
     between signed and unsigned".
+
+23: Tested after it has been merged into the -mm patchset to make sure
+    that it still works with all of the other queued patches and various
+    changes in the VM, VFS, and other subsystems.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

kernel-doc-allow-space-after-__attribute__.patch
kernel-doc-fixes-for-2620-git15-non-drivers.patch
add-mm-testing-in-submitchecklist.patch
git-drm.patch
git-libata-all.patch
phy-layer-add-kernel-doc-docbook.patch
git-parisc.patch
fusion-kernel-doc-warning-fixes.patch
x86-dont-probe-for-ddc-on-vbe12.patch
scripts-kernel-doc-whitespace-cleanup.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
