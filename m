From: akpm@linux-foundation.org
Subject: - doc-use-correct-debugfs-mountpoint.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:54:22 -0800
Message-ID: <200802050254.m152s3Pw031558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41093 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772AbYBEDAa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 22:00:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, zanussi@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     doc: use correct debugfs mountpoint
has been removed from the -mm tree.  Its filename was
     doc-use-correct-debugfs-mountpoint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: use correct debugfs mountpoint
From: Randy Dunlap <randy.dunlap@oracle.com>

Use the normal, expected mountpoint in the relay(fs) example for debugfs.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/relay.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/filesystems/relay.txt~doc-use-correct-debugfs-mountpoint Documentation/filesystems/relay.txt
--- a/Documentation/filesystems/relay.txt~doc-use-correct-debugfs-mountpoint
+++ a/Documentation/filesystems/relay.txt
@@ -140,7 +140,7 @@ close()     decrements the channel buffe
 In order for a user application to make use of relay files, the
 host filesystem must be mounted.  For example,
 
-	mount -t debugfs debugfs /debug
+	mount -t debugfs debugfs /sys/kernel/debug
 
 NOTE:   the host filesystem doesn't need to be mounted for kernel
 	clients to create or use channels - it only needs to be
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-ia64.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
kernel-doc-prevent-duplicate-description-output.patch
kernel-doc-warn-on-badly-formatted-short-description.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
