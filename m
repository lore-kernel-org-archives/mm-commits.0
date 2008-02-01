From: akpm@linux-foundation.org
Subject: + doc-use-correct-debugfs-mountpoint.patch added to -mm tree
Date: Thu, 31 Jan 2008 16:07:43 -0800
Message-ID: <200802010007.m1107h90018261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52077 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934555AbYBAAIE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 19:08:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, zanussi@us.ibm.com


The patch titled
     doc: use correct debugfs mountpoint
has been added to the -mm tree.  Its filename is
     doc-use-correct-debugfs-mountpoint.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-alsa.patch
docbook-fix-drivers-base-class-warning.patch
ia64-aliasing-test-fix-gcc-warnings-on-non-ia64.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
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
doc-use-correct-debugfs-mountpoint.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
