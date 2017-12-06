From: akpm@linux-foundation.org
Subject: + kmemcheck-rip-it-out-for-real.patch added to -mm tree
Date: Wed, 06 Dec 2017 15:55:26 -0800
Message-ID: <5a28836e.JuqYRnfSWvE6f/qz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751711AbdLFXz1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2017 18:55:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemcheck: rip it out for real
has been added to the -mm tree.  Its filename is
     kmemcheck-rip-it-out-for-real.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmemcheck-rip-it-out-for-real.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmemcheck-rip-it-out-for-real.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: kmemcheck: rip it out for real

4675ff05de2d ("kmemcheck: rip it out") has removed the code but for some
reason SPDX header stayed in place.  This looks like a rebase mistake in
the mmotm tree or the merge mistake.  Let's drop those leftovers as well.

Link: http://lkml.kernel.org/r/20171206102757.25905-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/kmemcheck.h |    1 -
 arch/x86/mm/kmemcheck/error.c    |    1 -
 arch/x86/mm/kmemcheck/error.h    |    1 -
 arch/x86/mm/kmemcheck/opcode.c   |    1 -
 arch/x86/mm/kmemcheck/opcode.h   |    1 -
 arch/x86/mm/kmemcheck/pte.c      |    1 -
 arch/x86/mm/kmemcheck/pte.h      |    1 -
 arch/x86/mm/kmemcheck/selftest.c |    1 -
 arch/x86/mm/kmemcheck/selftest.h |    1 -
 arch/x86/mm/kmemcheck/shadow.h   |    1 -
 include/linux/kmemcheck.h        |    1 -
 mm/kmemcheck.c                   |    1 -
 tools/include/linux/kmemcheck.h  |    1 -
 13 files changed, 13 deletions(-)

diff -puN arch/x86/include/asm/kmemcheck.h~kmemcheck-rip-it-out-for-real /dev/null
--- a/arch/x86/include/asm/kmemcheck.h
+++ /dev/null
@@ -1 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
diff -puN arch/x86/mm/kmemcheck/error.c~kmemcheck-rip-it-out-for-real /dev/null
--- a/arch/x86/mm/kmemcheck/error.c
+++ /dev/null
@@ -1 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
diff -puN arch/x86/mm/kmemcheck/error.h~kmemcheck-rip-it-out-for-real /dev/null
--- a/arch/x86/mm/kmemcheck/error.h
+++ /dev/null
@@ -1 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
diff -puN arch/x86/mm/kmemcheck/opcode.c~kmemcheck-rip-it-out-for-real /dev/null
--- a/arch/x86/mm/kmemcheck/opcode.c
+++ /dev/null
@@ -1 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
diff -puN arch/x86/mm/kmemcheck/opcode.h~kmemcheck-rip-it-out-for-real /dev/null
--- a/arch/x86/mm/kmemcheck/opcode.h
+++ /dev/null
@@ -1 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
diff -puN arch/x86/mm/kmemcheck/pte.c~kmemcheck-rip-it-out-for-real /dev/null
--- a/arch/x86/mm/kmemcheck/pte.c
+++ /dev/null
@@ -1 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
diff -puN arch/x86/mm/kmemcheck/pte.h~kmemcheck-rip-it-out-for-real /dev/null
--- a/arch/x86/mm/kmemcheck/pte.h
+++ /dev/null
@@ -1 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
diff -puN arch/x86/mm/kmemcheck/selftest.c~kmemcheck-rip-it-out-for-real /dev/null
--- a/arch/x86/mm/kmemcheck/selftest.c
+++ /dev/null
@@ -1 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
diff -puN arch/x86/mm/kmemcheck/selftest.h~kmemcheck-rip-it-out-for-real /dev/null
--- a/arch/x86/mm/kmemcheck/selftest.h
+++ /dev/null
@@ -1 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
diff -puN arch/x86/mm/kmemcheck/shadow.h~kmemcheck-rip-it-out-for-real /dev/null
--- a/arch/x86/mm/kmemcheck/shadow.h
+++ /dev/null
@@ -1 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
diff -puN include/linux/kmemcheck.h~kmemcheck-rip-it-out-for-real /dev/null
--- a/include/linux/kmemcheck.h
+++ /dev/null
@@ -1 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
diff -puN mm/kmemcheck.c~kmemcheck-rip-it-out-for-real /dev/null
--- a/mm/kmemcheck.c
+++ /dev/null
@@ -1 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
diff -puN tools/include/linux/kmemcheck.h~kmemcheck-rip-it-out-for-real /dev/null
--- a/tools/include/linux/kmemcheck.h
+++ /dev/null
@@ -1 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
_

Patches currently in -mm which might be from mhocko@suse.com are

kmemcheck-rip-it-out-for-real.patch
mm-drop-hotplug-lock-from-lru_add_drain_all.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch

