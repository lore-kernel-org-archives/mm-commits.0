From: akpm@linux-foundation.org
Subject: + gitignore-updates.patch added to -mm tree
Date: Mon, 20 Oct 2008 14:51:22 -0700
Message-ID: <200810202151.m9KLpMcd024758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbYJTVvx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 17:51:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     .gitignore updates
has been added to the -mm tree.  Its filename is
     gitignore-updates.patch

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
Subject: .gitignore updates
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/.gitignore   |    1 +
 Documentation/auxdisplay/.gitignore   |    1 +
 Documentation/connector/.gitignore    |    1 +
 Documentation/ia64/.gitignore         |    1 +
 Documentation/networking/.gitignore   |    1 +
 Documentation/pcmcia/.gitignore       |    1 +
 Documentation/spi/.gitignore          |    2 ++
 Documentation/video4linux/.gitignore  |    1 +
 Documentation/vm/.gitignore           |    1 +
 Documentation/watchdog/src/.gitignore |    2 ++
 arch/x86/boot/compressed/.gitignore   |    2 ++
 x86/kernel/cpu/.gitignore             |    0 
 12 files changed, 14 insertions(+)

diff -puN /dev/null Documentation/accounting/.gitignore
--- /dev/null
+++ a/Documentation/accounting/.gitignore
@@ -0,0 +1 @@
+getdelays
diff -puN /dev/null Documentation/auxdisplay/.gitignore
--- /dev/null
+++ a/Documentation/auxdisplay/.gitignore
@@ -0,0 +1 @@
+cfag12864b-example
diff -puN /dev/null Documentation/connector/.gitignore
--- /dev/null
+++ a/Documentation/connector/.gitignore
@@ -0,0 +1 @@
+ucon
diff -puN /dev/null Documentation/ia64/.gitignore
--- /dev/null
+++ a/Documentation/ia64/.gitignore
@@ -0,0 +1 @@
+aliasing-test
diff -puN /dev/null Documentation/networking/.gitignore
--- /dev/null
+++ a/Documentation/networking/.gitignore
@@ -0,0 +1 @@
+ifenslave
diff -puN /dev/null Documentation/pcmcia/.gitignore
--- /dev/null
+++ a/Documentation/pcmcia/.gitignore
@@ -0,0 +1 @@
+crc32hash
diff -puN /dev/null Documentation/spi/.gitignore
--- /dev/null
+++ a/Documentation/spi/.gitignore
@@ -0,0 +1,2 @@
+spidev_fdx
+spidev_test
diff -puN /dev/null Documentation/video4linux/.gitignore
--- /dev/null
+++ a/Documentation/video4linux/.gitignore
@@ -0,0 +1 @@
+v4lgrab
diff -puN /dev/null Documentation/vm/.gitignore
--- /dev/null
+++ a/Documentation/vm/.gitignore
@@ -0,0 +1 @@
+slabinfo
diff -puN /dev/null Documentation/watchdog/src/.gitignore
--- /dev/null
+++ a/Documentation/watchdog/src/.gitignore
@@ -0,0 +1,2 @@
+watchdog-simple
+watchdog-test
diff -puN arch/x86/boot/compressed/.gitignore~gitignore-updates arch/x86/boot/compressed/.gitignore
--- a/arch/x86/boot/compressed/.gitignore~gitignore-updates
+++ a/arch/x86/boot/compressed/.gitignore
@@ -1 +1,3 @@
 relocs
+vmlinux.bin.all
+vmlinux.relocs
diff -puN arch/x86/kernel/cpu/.gitignore~gitignore-updates arch/x86/kernel/cpu/.gitignore
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
gitignore-updates.patch
linux-next.patch
tags-skip-in-filenames.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

