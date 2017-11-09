From: akpm@linux-foundation.org
Subject: + maintainers-update-tpm-driver-infrastructure-changes-fix.patch
 added to -mm tree
Date: Wed, 08 Nov 2017 17:34:10 -0800
Message-ID: <5a03b092.aU/cuwbx//wyeggQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34094 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdKIBeM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2017 20:34:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jarkko.sakkinen@linux.intel.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: maintainers-update-tpm-driver-infrastructure-changes-fix
has been added to the -mm tree.  Its filename is
     maintainers-update-tpm-driver-infrastructure-changes-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-tpm-driver-infrastructure-changes-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-tpm-driver-infrastructure-changes-fix.patch

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
Subject: maintainers-update-tpm-driver-infrastructure-changes-fix

alpha-sort CREDITS, per Randy

Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN CREDITS~maintainers-update-tpm-driver-infrastructure-changes-fix CREDITS
--- a/CREDITS~maintainers-update-tpm-driver-infrastructure-changes-fix
+++ a/CREDITS
@@ -2113,6 +2113,10 @@ S: J. Obrechtstr 23
 S: NL-5216 GP 's-Hertogenbosch
 S: The Netherlands
 
+N: Ashley Lai
+E: ashleydlai@gmail.com
+D: IBM VTPM driver
+
 N: Savio Lam
 E: lam836@cs.cuhk.hk
 D: Author of the dialog utility, foundation
@@ -3333,6 +3337,10 @@ S: Braunschweiger Strasse 79
 S: 31134 Hildesheim
 S: Germany
 
+N: Marcel Selhorst
+E: tpmdd@selhorst.net
+D: TPM driver
+
 N: Darren Senn
 E: sinster@darkwater.com
 D: Whatever I notice needs doing (so far: itimers, /proc)
@@ -4128,14 +4136,6 @@ D: MD driver
 D: EISA/sysfs subsystem
 S: France
 
-N: Marcel Selhorst
-E: tpmdd@selhorst.net
-D: TPM driver
-
-N: Ashley Lai
-E: ashleydlai@gmail.com
-D: IBM VTPM driver
-
 # Don't add your name here, unless you really _are_ after Marc
 # alphabetically. Leonard used to be very proud of being the 
 # last entry, and he'll get positively pissed if he can't even
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
maintainers-update-tpm-driver-infrastructure-changes-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-consolidate-page-table-accounting-fix-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
support-resetting-warn_once-for-all-architectures-v2-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

