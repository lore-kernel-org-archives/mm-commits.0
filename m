From: akpm@linux-foundation.org
Subject: [folded-merged] selftests-add-a-simple-doc-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:48:53 -0800
Message-ID: <20130228004854.4306831C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:62959 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab3B1Asz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:48:55 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so139979vch.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:48:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dyoung@redhat.com, jk@ozlabs.org, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests-add-a-simple-doc-fix
has been removed from the -mm tree.  Its filename was
     selftests-add-a-simple-doc-fix.patch

This patch was dropped because it was folded into selftests-add-a-simple-doc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-add-a-simple-doc-fix

move from Documentation to tools/testing/selftests/README.txt

Cc: Dave Young <dyoung@redhat.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/selftests.txt        |   43 ---------------------------
 tools/testing/selftests/README.txt |   43 +++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 43 deletions(-)

diff -puN Documentation/selftests.txt~selftests-add-a-simple-doc-fix /dev/null
--- a/Documentation/selftests.txt
+++ /dev/null
@@ -1,43 +0,0 @@
-Linux Kernel Selftests
-
-The kernel contains a set of "self tests" under the tools/testing/selftests/
-directory. These are intended to be small unit tests to exercise individual
-code paths in the kernel.
-
-Running the selftests
-=====================
-
-To build the tests:
-
-  $ make -C tools/testing/selftests
-
-
-To run the tests:
-
-  $ make -C tools/testing/selftests run_tests
-
-- note that some tests will require root privileges.
-
-
-To run only tests targetted for a single subsystem:
-
-  $  make -C tools/testing/selftests TARGETS=cpu-hotplug run_tests
-
-See the top-level tools/testing/selftests/Makefile for the list of all possible
-targets.
-
-
-Contributing new tests
-======================
-
-In general, the rules for for selftests are
-
- * Do as much as you can if you're not root;
-
- * Don't take too long;
-
- * Don't break the build on any architecture, and
-
- * Don't cause the top-level "make run_tests" to fail if your feature is
-   unconfigured.
-
diff -puN /dev/null tools/testing/selftests/README.txt
--- /dev/null
+++ a/tools/testing/selftests/README.txt
@@ -0,0 +1,43 @@
+Linux Kernel Selftests
+
+The kernel contains a set of "self tests" under the tools/testing/selftests/
+directory. These are intended to be small unit tests to exercise individual
+code paths in the kernel.
+
+Running the selftests
+=====================
+
+To build the tests:
+
+  $ make -C tools/testing/selftests
+
+
+To run the tests:
+
+  $ make -C tools/testing/selftests run_tests
+
+- note that some tests will require root privileges.
+
+
+To run only tests targetted for a single subsystem:
+
+  $  make -C tools/testing/selftests TARGETS=cpu-hotplug run_tests
+
+See the top-level tools/testing/selftests/Makefile for the list of all possible
+targets.
+
+
+Contributing new tests
+======================
+
+In general, the rules for for selftests are
+
+ * Do as much as you can if you're not root;
+
+ * Don't take too long;
+
+ * Don't break the build on any architecture, and
+
+ * Don't cause the top-level "make run_tests" to fail if your feature is
+   unconfigured.
+
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
fs-proc-clean-up-printks.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
idr-remove-length-restriction-from-idr_layer-bitmap.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

