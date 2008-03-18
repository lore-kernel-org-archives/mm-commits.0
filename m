From: akpm@linux-foundation.org
Subject: + pm-remove-legacy-pm-fix.patch added to -mm tree
Date: Mon, 17 Mar 2008 17:07:38 -0700
Message-ID: <200803180007.m2I07crb005253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbYCRAHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 20:07:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, pavel@suse.cz, rjw@sisk.pl


The patch titled
     PM: Remove legacy PM (fix)
has been added to the -mm tree.  Its filename is
     pm-remove-legacy-pm-fix.patch

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
Subject: PM: Remove legacy PM (fix)
From: Randy Dunlap <randy.dunlap@oracle.com>

Source file was removed.  Need to remove docbook reference also.

Are there other files in kernel/power/ that should be added to the docbook?

$ power> kerndoc-search.pl --count *.c
file console.c: 0 kernel-doc blocks
file disk.c: 18 kernel-doc blocks
file main.c: 9 kernel-doc blocks
file poweroff.c: 0 kernel-doc blocks
file process.c: 2 kernel-doc blocks
file snapshot.c: 39 kernel-doc blocks
file swap.c: 10 kernel-doc blocks
file swsusp.c: 4 kernel-doc blocks
file user.c: 0 kernel-doc blocks

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    5 -----
 1 file changed, 5 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~pm-remove-legacy-pm-fix Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~pm-remove-legacy-pm-fix
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -297,11 +297,6 @@ X!Earch/x86/kernel/mca_32.c
 !Ikernel/acct.c
   </chapter>
 
-  <chapter id="pmfuncs">
-     <title>Power Management</title>
-!Ekernel/power/pm.c
-  </chapter>
-
   <chapter id="devdrivers">
      <title>Device drivers infrastructure</title>
      <sect1><title>Device Drivers Base</title>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mm-fix-various-kernel-doc-comments.patch
mm-shmem-and-tiny-shmem-fix-some-kernel-doc.patch
mm-oom_kill-fix-kernel-doc.patch
mm-highmem-kernel-doc-additions.patch
mm-rmap-kernel-doc-fixes.patch
jbd-fix-jbd-kernel-doc-notation.patch
x86-convert-mtrr-genericc-to-kernel-doc.patch
pm-remove-legacy-pm-fix.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-visws-fix-printk-format-warnings.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
profile-likely-unlikely-macros.patch

