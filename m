From: akpm@linux-foundation.org
Subject: + documentation-explain-memory-barriers.patch added to -mm tree
Date: Fri, 10 Oct 2008 13:06:05 -0700
Message-ID: <200810102006.m9AK65f9029408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760565AbYJJUGu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 16:06:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     documentation: explain memory barriers
has been added to the -mm tree.  Its filename is
     documentation-explain-memory-barriers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation: explain memory barriers
From: Randy Dunlap <randy.dunlap@oracle.com>

We want all uses of memory barriers to be explained in the source code.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmitChecklist |    3 +++
 1 file changed, 3 insertions(+)

diff -puN Documentation/SubmitChecklist~documentation-explain-memory-barriers Documentation/SubmitChecklist
--- a/Documentation/SubmitChecklist~documentation-explain-memory-barriers
+++ a/Documentation/SubmitChecklist
@@ -85,3 +85,6 @@ kernel patches.
 23: Tested after it has been merged into the -mm patchset to make sure
     that it still works with all of the other queued patches and various
     changes in the VM, VFS, and other subsystems.
+
+24: All memory barriers {e.g., barrier(), rmb(), wmb()} need a comment in the
+    source code that explains the logic of what they are doing and why.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-tip.patch
git-hid.patch
git-net.patch
git-sound.patch
git-block.patch
git-drm.patch
git-security-testing.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
toshiba_acpi-depends-on-input.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
eeepc-laptop-use-standard-interfaces-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
documentation-explain-memory-barriers.patch
docbook-update-procfs-credits.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support-fix.patch
profile-likely-unlikely-macros.patch

